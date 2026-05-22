# Falsehoods About File Systems

> Writing a file looks atomic. It isn't — and your data is one power-cut away from finding out.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A single write isn't atomic.** `pwrite([file], "bar", 3, 2)` to turn `a foo` into `a bar` can leave you with `a boo` or `a far` if power drops mid-write — any in-between state is fair game. The unit isn't your bytes; think sectors and blocks.
- **fsync doesn't always reach the disk.** On macOS, plain `fsync` doesn't flush to platters — you need `fcntl(F_FULLFSYNC)`. Some older ext3 versions only flushed when the inode changed. And some disks ignore flush commands outright, to look faster in benchmarks.
- **Syscalls get reordered.** On ext4 `data=ordered`, a `write` to your log and a later `pwrite` to the real file can hit disk in the wrong order, defeating the entire point of having a log. The fix is an `fsync` barrier between them.
- **Creating a file isn't durable until you fsync its directory.** You can `creat`, `write`, and `fsync` a file, then crash and find the directory entry never made it — the file is effectively gone. `fsync` the parent directory too.
- **rename is not atomic on crash.** POSIX says rename is atomic, but that's only during normal operation. On most mainstream Linux filesystems, rename-on-crash can lose data — so the famous "write to temp, rename over original" trick is not the silver bullet everyone thinks.
- **An fsync error is usually unrecoverable.** On ext4/XFS/btrfs, when `fsync` returns an error the dirty data is thrown away or marked clean; retrying `fsync` returns success while your data is gone. Postgres, MySQL, and MongoDB respond by crashing themselves on purpose.
- **Disks corrupt data far more than datasheets claim.** Datasheets say ~1 unrecoverable error per 1e14 bits read; field studies (FB, Microsoft) measured rates up to 2e-9 — hundreds of thousands to millions of times worse. Read a 10TB drive once and expect an error.
- **Experts get this wrong too.** A static-analysis pass over LevelDB, LMDB, GDBM, HSQLDB, SQLite, PostgreSQL, git, Mercurial, HDFS, and Zookeeper found that every one except SQLite-in-one-specific-mode had at least one file-handling bug.

## Where It Gets Complicated

### "A write either happens or it doesn't."

The false assumption: a `pwrite` is a single indivisible event. It isn't. If you crash partway through, you can land on any intermediate state — `a boo`, `a bor`, `a far`. The atomic unit is a sector or block, not your logical write, and the paper authors note that even single-sector atomicity sometimes comes from a property of the *disk*, not the filesystem — run the same filesystem on a different disk and you may lose it.

The classic fix is an undo log: copy the soon-to-be-overwritten bytes into a log file, modify the real file, delete the log on success. On recovery, if the log is complete you restore from it; if it's incomplete you know the modification never started. Simple in theory, and it works — but only after you've layered on everything below.

### "The syscalls run in the order I wrote them."

The false assumption: `write(log); pwrite(orig)` reaches disk in that order. On ext4/ext3 with the default `data=ordered`, it doesn't have to. The filesystem is free to push the `pwrite` to `orig` out before the `write` to the log, so a crash leaves you with a modified file and no usable log — strictly worse than no log at all.

You fix ordering with an `fsync` barrier between the two writes. `fsync` does double duty here: it's a barrier (prevents reordering) *and* a cache flush. That bundling is annoying — sometimes you only want ordering and end up paying the flush cost anyway — but it's the primitive you've got. This "incorrectly assuming ordering between syscalls" was the single most common bug class found across the tested applications, and "assuming syscalls are atomic" was the runner-up. These are the same mistakes people make in multithreaded code, except files get treated more casually.

### "data=ordered, data=writeback — they're all basically the same."

The false assumption: the journal mode is a performance knob with no correctness implications. Wrong, and the manpage won't save you:

- **journal**: all data goes through the journal before the main filesystem. Safest, slowest.
- **ordered** (the historical default): data is forced to the main filesystem before its metadata commits to the journal.
- **writeback**: no data ordering — data may land *after* its metadata. The manpage literally calls this "rumoured to be the highest-throughput option."

Under `data=writeback`, the file-length metadata for your log can be updated before the log's bytes are written, so after a crash the log "exists" at the right size but contains whatever garbage was already on those blocks. Restore from that and you've corrupted the original. The defense is a checksum inside the log so you can tell a valid log from random bits. (And note: `data=ordered` being the default only held pre-2.6.30; after that it depends on a kernel config option, and some distros only support `data=ordered` at all.)

### "Once the file is written and fsync'd, it's safely on disk."

The false assumption: `creat` + `write` + `fsync` on the file is enough. It's legal for the filesystem to come back from a crash with the file's *contents* durable but its *directory entry* missing — so the file you carefully synced can't be found. You must also `fsync` the parent directory after creating the file, and again after the final `unlink` if deletions matter to your protocol.

So the actually-correct version of "write a file safely" is roughly: `creat(log)` → `write(log, "...[checksum],foo")` → `fsync(log)` → `fsync(dir)` → `pwrite(orig, ...)` → `fsync(orig)` → `unlink(log)` → `fsync(dir)`. Seven-plus steps, three of them `fsync`s on two different objects, to overwrite three bytes. Get this right on ext4 `data=journal` and it's tractable; write it to be correct across ext2/ext3/ext4/btrfs/xfs simultaneously and it's genuinely hard.

### "rename is atomic, so I'll write a temp file and rename it over the original."

The false assumption: POSIX rename atomicity protects you on crash. It only guarantees atomicity during *normal operation*. On most mainstream Linux filesystems there's at least one mode where rename is not atomic across a crash, and rename isn't guaranteed to run in program order either. The most-cited exception is btrfs — but even there it's subtle: rename is atomic on crash only when *replacing an existing file*, not when creating a new one. And Mohan et al. (OSDI'18) found numerous btrfs rename-atomicity bugs, some years old, some introduced the same year as the paper. So don't lean on it without extensive crash testing even in btrfs-specific code.

The append trick has the same problem. "Only ever append, never overwrite" feels safe, but appends guarantee neither ordering nor atomicity — LevelDB, Mercurial, and HSQLDB all shipped corruption bugs from assuming appends were atomic. The general pattern is that the same people who underestimate this problem keep walking into a thread that explains the problem in detail and then confidently propose the trick the thread just debunked.

### "btrfs is newer, so it must be more reliable than ext."

The false assumption: a more modern filesystem is automatically safer for applications. btrfs's semantics aren't inherently *less* reliable — but far more applications corrupt data on top of it, because developers aren't used to coding against a filesystem that allows directory operations to be reordered (ext2 was the last widely-used filesystem that did that). People test against what their filesystem happens to do rather than what POSIX actually permits, so moving to a filesystem with different-but-legal behavior exposes a wave of latent bugs. Expect the same when byte-addressable NVRAM drives go mainstream.

### "If fsync fails, I'll just retry it."

The false assumption: a failed `fsync` is a transient hiccup you can recover from by calling it again. On most Linux filesystems, a failed `fsync` *discards* the dirty data — XFS and btrfs throw it away outright; ext4 marks it clean so it'll never be written back and can be evicted under memory pressure. Worse, on kernels before ~Q2 2018 the error could be dropped entirely or reported to the wrong process. Retrying `fsync` then returns success — over data that no longer exists. Because most disk errors are *transient* and would succeed on retry, this behavior turns recoverable blips into mandatory data loss. That's why Postgres, MySQL, and MongoDB deliberately crash on `fsync` error and make you restore from a checkpoint. `syncfs` is even worse — on Linux it doesn't return errors at all. This isn't Linux-only: OpenBSD and NetBSD historically behaved the same way (some since fixed); FreeBSD was arguably correct.

### "The filesystem will tell me when the disk has a problem."

The false assumption: the layer below you reports its errors honestly. Fault-injection studies (Prabhakaran et al., SOSP'05) found most filesystems silently *dropped* write errors. ext3 ignored write failures in most cases and remounted read-only on read failures — exactly backwards, since read errors are often transient and write errors are the ones that corrupt data. Error-handling code was littered with comments like "Error, skip block and hope for the best." and "I really hope a write error doesn't happen here." Things improved markedly by 2017 (most filesystems other than JFS now pass the basic tests), but error codes are still dropped on a meaningful fraction of internal paths. And disks themselves silently corrupt data — vendors privately admit some disks "do not allow the file system to force writes to disk properly." SSD "power loss protection" is no guarantee either: of six PLP-labeled drives tested, four models failed when written to faster or more in parallel than the implementer anticipated.

## If You Build This

- **Don't roll your own durable write. Use SQLite (or a real database).** It's the most reliable file-abstraction default available, and its devs understand these issues deeply. Lampson's lesson applies: package the hard part in a box and let a wizard write the box. The one caveat is the no-bugs-found result was for *one specific SQLite mode* — even SQLite isn't magic in every configuration.
- **If you must write files directly, do the whole dance.** Write to a temp file, `fsync` it, `fsync` the parent directory, then atomically rename over the target, then `fsync` the directory again. Know that rename-on-crash atomicity is not universal (btrfs only guarantees it for replace, not create), so this is a floor, not a ceiling.
- **Don't trust defaults — know your journal mode and your platform.** `data=ordered` vs `data=writeback` changes what you must do; macOS needs `F_FULLFSYNC`, not `fsync`; some disks lie about flushing. Code to what's *legal*, not to what your one test machine happens to do.
- **Treat an fsync error as fatal.** Following Postgres/MySQL/MongoDB: on `fsync` failure, crash and recover from a known-good checkpoint rather than retrying. Retry returns a false success.
- **Checksum your data and bound your blast radius.** You will get silent corruption. Checksumming is the only way to *detect* it, and a record format that loses one record on corruption beats one that loses the whole database (the path most desktop mail clients chose).
- **Test with crash injection and fault injection — normal tests won't find these bugs.** The failure modes are non-deterministic and rare in casual use. Researchers found large numbers of real bugs with tools of a few thousand lines (one error-propagation checker was ~4k LOC). Basic random testing, static analysis, and fault injection pay for themselves the first time you run them.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Files are hard (Dan Luu)](https://danluu.com/file-consistency/) · [archived copy](../archive/file-systems/01-files-are-hard-dan-luu.md)
- [Files are fraught with peril (Dan Luu)](https://danluu.com/deconstruct-files/) · [archived copy](../archive/file-systems/02-files-are-fraught-with-peril-dan-luu.md)
