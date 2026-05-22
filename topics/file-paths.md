# Falsehoods About File Paths

> A path is not a string, and Windows paths are a different animal entirely.

## The Big Surprises

- **A path is not a Unicode string.** On Linux, a file path is just any sequence of bytes terminated by a NUL — it has no defined encoding. Decoding it to a Unicode string can corrupt or fail on perfectly valid filenames. (This is the bug that started the whole list: a Python library returning a path as a unicode string.)
- **`PATH_MAX` is not the maximum length of a path.** Despite the name, it was only ever the maximum size of a single component — and you can't even rely on it for that, since a different filesystem or symlink may apply between when you check `pathconf(3)` and when you use the path. Allocate on the heap in a `realloc(3)` loop instead.
- **Two different path strings can be the same file, and one path string can be different files over time.** Hard links, symlinks, bind mounts, and `/..` (which equals `/`) all make distinct paths resolve to one file. Meanwhile the *same* path can point to different files moment to moment because another process moved it, swapped a symlink, mounted a filesystem, or because you `chroot(2)`'d.
- **Two processes don't even agree on what a path means.** Different mount namespaces, different roots, and `/proc/self` (which shows each process a different thing) mean the filesystem isn't a single shared truth.
- **Filenames can contain things you'd never expect.** Spaces, colons (`:`), glob characters (`*`, `?`), and even newlines are all legal in POSIX filenames — embedding a newline made old `ls(1)` appear to print two files. The *only* byte forbidden in a component is the separator itself (and NUL).
- **Case sensitivity is per-filesystem, not per-OS.** POSIX is usually case-sensitive, macOS and Windows usually aren't — but macOS can be case-sensitive, Linux can mount FAT32/NTFS (insensitive), and since the Windows 10 April 2018 Update NTFS can be case-sensitive *per folder*. There is no safe assumption.
- **A Windows path with a drive letter is not necessarily absolute.** `C:foo.txt` is relative to the current working directory *for the C: drive specifically* — which the shell tracks separately per drive and may differ from the current drive's directory.
- **The same Windows directory has a near-unlimited number of valid spellings.** `C:\…`, forward slashes, doubled-up separators (`C:/\\/\\//Chameleon`), trailing-dot junk (`C:\foo\.\.\.`), UNC, device paths, and volume GUIDs all name the same place. That's what decades of strict backwards compatibility buys you.
- **A "file" you open might not be a file, and might have more than one data stream.** On *nix you can open directories, sockets, FIFOs, and device nodes; on Windows the colon addresses NTFS alternate data streams. macOS has resource forks. One name, multiple streams.

## Where It Gets Complicated

### Encoding

Linux paths are raw bytes ending in NUL — no encoding, period. Windows paths, by contrast, are Unicode (UTF-16 under the hood). So "file paths are UTF-8," "file paths are Unicode," and "file paths have an encoding" are *all* false depending on platform, and so is "file paths have no encoding." When paths *are* interpreted as Unicode, different byte sequences can normalize to identical-looking strings, so two files can be visually indistinguishable.

### Separators & roots

`/` is not the universal separator. Windows historically used `\` and now accepts both; RISC OS uses `.`; classic Mac OS 9 used `:`. Absolute paths don't always start with `/` either — Windows has drive paths (`C:\`) and UNC paths starting with `\\`. And separators aren't even necessarily uniform within one path: OpenVMS looks like `SYS$SYSDEVICE:[DIR1.DIR2.DIR3]FILENAME.EXT;FILEVER`, with different delimiters for device, directory chain, name, and version.

### Windows path schemes

There are three flavors of absolute path and three of relative path:

- **Drive path:** `D:\preferences\jam`. The familiar form.
- **UNC path:** `\\Work\Media`, `\\192.168.1.15\share`. First segment is a host (name or IP). `\\Pipeline` alone is *not* a valid directory — it only names a server; you must append a share. The `C$` in `\\host\C$\…` is a hidden administrative share, not a substitute for the drive colon, and only works as an administrator.
- **Device path:** starts with `\\.\` (normalized) or `\\?\` (literal). Can address physical devices, or folders via e.g. `\\?\Z:\…`, or even a volume GUID like `\\?\Volume{59e01a55-…}\`. The `\\?\` form *skips normalization*, which is the only way to reach a file literally named `..` that would otherwise resolve away.
- **Relative forms:** current-directory-relative (`.`, `..`); current-drive-root-relative (a leading `\`, so on `E:` it means `E:\…`); and drive's-current-directory-relative (`E:Kreuzberg`, per-drive cwd that really only makes sense at the shell).

### Normalization

Every path *except* a literal `\\?\` device path is cleaned up first: forward slashes become backslashes, repeated separators collapse to one, `.`/`..` get resolved, and trailing spaces and periods get trimmed. This is why forward slashes usually work on Windows, and why a trailing dot or space silently vanishes.

### Case & normalization gotchas

`C:\hamlet`, `c:\Hamlet`, and `C:\hAMlET` are the same file on a default Windows setup. That means a "delete path Y, path X survives" assumption breaks when X and Y differ only by case on an insensitive filesystem — or when X is an alternate data stream of Y (`C:\f.txt:sub1`), since deleting the file `C:\f.txt` takes the stream with it. Normalizing a path's case to compare or store it will eventually corrupt someone's data.

### Special & reserved names

Windows reserves `CON`, `PRN`, `AUX`, `NUL`, `COM0`–`COM9`, and `LPT0`–`LPT9` — *including with an extension*, so `COM1.txt` is treated as a device, not a file. Forbidden characters: `< > " / \ | ? *`, plus any control character below ASCII 32. The colon is mostly banned except for alternate data streams. A `.` is fine at the start or middle of a name but not as the final character. Leading spaces are allowed; trailing spaces are not. `.` and `..` are reserved everywhere for current/parent directory.

### Names, extensions & short names

A file may have zero extensions or several dots — there isn't always exactly one `.` splitting name from extension, and extensions aren't always three characters (that's a DOS 8.3 limit, not a rule). On Windows, 8.3 short names mean one file can have a second name: `LongFileName.txt` becomes something like `LONGFI~1.TXT`, and if two files collide, which gets `~1` versus `~2` is indeterminate.

### Symlinks & object types

A symlink can be empty, and it can point at something that doesn't exist (a "dangling" link) — its target is just text that happens to be a valid path. The magic symlinks in `proc(5)` are stranger still: `readlink(2)` shows an ID and type that, if passed to `open(2)`, creates something different from what opening the link directly gives you. And the filesystem zoo is bigger than files-and-directories: *nix has symlinks, sockets, FIFOs, character and block devices (and Solaris doors); Windows has junctions (symlink-like but not symlinks). Bind mounts on *nix and junctions on Windows mean even a fully normalized, symlink-free path isn't unique.

### Limits & locking

The classic Windows path limit was 260 characters, still enforced by many apps; rewriting paths to literal `\\?\` device paths under the hood lifts it to 32,767. Individual names cap at 255 characters. And don't assume locking is uniform: Windows provides mandatory locking and uses it by default; Linux does not.

## If You Build This

- **Use the platform's path library** (`os.path`/`pathlib`, `std::filesystem`, etc.), not string concatenation. Treat paths as opaque path objects, not strings you can split on `/`.
- **Never assume the encoding.** On *nix, handle paths as bytes; don't force-decode to UTF-8 or Unicode. On Windows, expect UTF-16. Round-trip without lossy conversion.
- **Don't assume the separator or that a drive letter means absolute.** Accept `\` and `/` on Windows, handle UNC, device, and drive-relative forms, and remember `C:foo` is relative.
- **Handle Windows extended-length and device paths.** Convert to `\\?\` when you need to exceed 260 characters or address a literal `..`/`.`-laden name — and know that doing so skips normalization.
- **Don't normalize case** to compare or canonicalize paths; case sensitivity is per-filesystem, even per-folder on modern NTFS. Let the filesystem decide identity.
- **Treat path-to-file as a runtime fact, not an identity.** Re-resolve when it matters, expect TOCTOU races, dangling symlinks, alternate data streams, reserved names, and trailing dots/spaces that silently disappear.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Myths about File Paths (Yakking)](https://yakking.branchable.com/posts/falsehoods-programmers-believe-about-file-paths/) · [archived copy](../archive/file-paths/01-myths-about-file-paths-yakking.md)
- [The weird world of Windows file paths (Fileside)](https://www.fileside.app/blog/2023-03-17_windows-file-paths/) · [archived copy](../archive/file-paths/02-the-weird-world-of-windows-file-paths-fileside.md)
