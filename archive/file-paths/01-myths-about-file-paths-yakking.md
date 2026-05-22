# Myths about File Paths (Yakking)

> **Original:** <https://yakking.branchable.com/posts/falsehoods-programmers-believe-about-file-paths/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Myths programmers believe about file paths

← Random Numbers in Linux \| posts \| Chunks of scripting →

I recently had cause to debug some string handling problems in a python program.

The root cause of which was diagnosed to be a library function returning a file path as a unicode string.

I believe this to be fundamentally wrong, so I decided to write this article in the same vein as the Falsehoods programmers believe articles.

I have no illusions about this being an exhaustive list, so if you have any to add, please comment.

Paths fit in PATH_MAX .

This seductively named constant does not mean the full length of a path.

It was only ever meant to be maximum size of an individual component.

Path components fit in PATH_MAX

We no longer live in those times.

You can use pathconf(3) to determine this limit, but you cannot rely on it, since a different filesystem may be mounted, or a symlink changed, at any time between checking this and using it.

It is better to dynamically allocate memory for strings on the heap in a realloc(3) loop.

Two files with different paths refer to different files

Apart from /.. being the same path as / , hard links, symbolic links and bind-mounts all allow different file names to resolve to the same file.

Two files with the same path refer to the same file

The same process at different times may see a different file, since another process may have moved it, changed a symbolic link, or mounted a filesystem.

The process itself may have used chroot(2) to change its view of the filesystem.

Different processes can have different views of the filesystem at the same time, since they may occupy different mount namespaces, different roots, or refer to different paths in proc(5) , which shows different values of /proc/self to each process, and shows different processes in different process namespaces.

All files have visibly distinct file paths

When file paths are interpreted as unicode different sequences of bytes can produce identical looking strings.

File paths are case insensitive

File paths are case sensitive

Paths are case sensitive in POSIX file systems, and insensitive on Mac and Windows file systems.

File paths are unicode

File paths have an encoding

Under Linux, file paths are any sequence of bytes terminated with a NUL .

File paths have no encoding

Under Windows, file paths are Unicode.

File paths cannot contain whitespace

Shell scripts often get this wrong, but there’s nothing preventing you putting spaces in.

File paths cannot contain : characters.

POSIX shells use : as the path separator. make uses : to separate build targets from dependent rules. Old versions of tar would interpret a file paths with : in file names as a remote tape address.

File paths cannot contain \* or ? characters

If you make use of your shell’s globbing feature, you need to escape or quote glob characters.

File paths can contain \* or ? characters

Windows does not allow you to create files with glob characters in.

Paths may contain only printable characters.

You can have fun and embed a newline character in a file name, which makes old versions of ls(1) appear to print two file names.

File path components can contain any string

The path separator cannot be part of a path component (excepting filesystem corruption).

The names . and .. are reserved for current directory and previous.

File path components can contain any string except “.” , “..” , or “/” .

Windows reserves CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8, COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9.

File paths have 1 . separating the name from the file extension.

You may have a file without an extension, and you may have multiple . .

File name extensions are 3 characters long.

Path components are separated with / .

Windows used to only support  , now it supports it in addition. More obscure operating systems like RISC OS use . as a path separator.

Absolute paths start with a / .

Windows has drive path (e.g. C: ), and UNC paths which start with \\ .

foo and foo/../foo always point to the same directory.

If the first foo is a symbolic link, then following it takes you to the directory it is in. The .. takes you to the parent directory of that, which may contain an entirely different directory called foo .

Symbolic links may not be empty

Symbolic links point to a file that exists.

You can put any text that is also a valid file path in a symbolic link. That text may not refer to a file that currently exists. This is called a dangling symbolic link.

Symbolic links that don’t point to a file that exists are dangling.

There’re magic symlinks in proc(5) , that when read with readlink(2) display an ID and type, which if you were to pass to open(2) would create a new file, but if you open(2) ’d the file directly would give something else.

RSS Atom

Mac OS X filesystems might be case-sensitive, but the default is not to be, and the system stuff does not assume case sensitivity.

(side-note: even the UNIX layer seems to work surprisingly well given this. The one clash I’ve discovered in 2 years of use is head (the pager) versus HEAD (the convenience binary for libwww-perl)

Some things to add:

On MacOS 9 the path component separator was :. Falsehood: The path component separator is always / or .

You should add a list of all the reserved characters on Windows, as well as the COM\*, etc. already listed. From https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247(v=vs.85).aspx#:

\< (less than)

> (greater than)

(colon) ” (double quote) / (forward slash)  (backslash) \| (vertical bar or pipe) ? (question mark)

(asterisk)

Falsehood: Windows UNC paths refer to a network server. Counterpoint: ..

Falsehood: Absolute Windows paths always begin with DRIVELETTER:. Counterpoint: ?:. This is the long path support, the ? prefix is used to indicate the application can support long paths.

Falsehood: Windows UNC paths begin with . Counterpoint: ?. ? is the long path UNC prefix.

Falsehood: A subdirectory of a directory is on the same physical storage on Windows. Counterpoint: Drives can be mounted at arbitrary directories, not just at drive letters.

Falsehood: Barring symlinks and hardlinks, a file has only one path which can access it. Counterpoint: File paths can contain redundancies like /./, leading to an arbitrary number of strings accessing the same file.

Falsehood: Barring symlinks and hardlinks and with paths normalised to remove redundancies, a file has only one path which can access it. Counterpoint: The same filesystem can appear at different mountpoints on \*nix using bind mounts. On Windows, junctions can be used, which function similarly to directory symlinks, but which are not symlinks and which are substantially more transparent.

Falsehood: If a Windows path has a drive letter, it must be an absolute path. Counterpoint: C:foo.txt (or C:bar.txt or C:...txt) is relative to the current working directory which was last set for C:, which may be different to the current working directory for the current drive letter.

Falsehood: Barring symlinks or hardlinks, a file has only one name. Counterpoint: Short names on Windows. C:.txt is reduced to C:~1.txt for legacy access.

Falsehood: A short name will always end in ~1.EXT. Counterpoint: If C:.txt and C:.txt both exist, one will be C:~1.txt and one will be C:~2.txt. Which is which is indeterminate.

Falsehood: Opening a path successfully means you’ve opened a file. Counterpoint: Directories (and sockets, and so on) can be opened on \*nix. On Windows, alternate file streams are addressed with the colon, which are subcomponents of files.

Falsehood: A file only has one stream of data associated with it. Counterpoint: Windows has alternate file streams. MacOS has resource forks.

Falsehood: A filesystem supports filenames longer than 8+3 characters. Counterpoint: DOS is limited to 8 characters before the file extension and 3 after.

Falsehood: If you write to a file with provided normalised path X and then delete normalised path Y, where Y != X, X will still exist. Counterpoint: On Windows, if X is an alternate file stream path (C:.txt:sub1), and Y is the file path (C:.txt), deleting Y will delete X. Also if Y != X is a case sensitive comparison and the filesystem is case insensitive.

Falsehood: The types of objects which can appear on a filesystem is limited to files and directories. Counterpoint: Windows has files (including hardlinks), directories, symlinks, junctions. *nix has files (including hardlinks), directories, symlinks, sockets, FIFOs, character devices, block devices. Some* nixes may have other object types, like Solaris doors.

Falsehood: A platform provides or doesn’t provide mandatory locking. Counterpoint: Windows does and it is used by default. Linux doesn’t provide mandatory file locking.

Falsehood: A filesystem mounted on \*nix is always case sensitive. Counterpoint: Linux can mount FAT32, NTFS, etc.

Falsehood: A filesystem mounted on Windows is always case insensitive. Counterpoint: Windows can be configured to make its filesystems case sensitive.

Falsehood: The separators between multiple directory components are the same as that used to separate the directory components and the filename. Counterpoint: OpenVMS paths look like this: SYS\$SYSDEVICE:\[DIR1.DIR2.DIR3\]FILENAME.EXT;FILEVER.

Feel free to use the above.

Add a comment
