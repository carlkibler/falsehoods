# Falsehoods About Computer Science

> The tidy abstractions you were taught leak everywhere in practice.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **"No space left on device" doesn't mean you're out of disk space.** You could be out of inodes, hitting a filesystem quota, or have a full partition that isn't your data partition. The error message is technically accurate and practically misleading.

- **`malloc(3)` always returns a valid pointer — except on Linux, where it often doesn't even try.** Linux overcommits memory by default: `malloc` succeeds, you get a pointer, and then the OOM killer shoots your process later when you actually touch the pages. The abstraction lies to your face.

- **File deletion requires write permissions on the file — false.** You need write permission on the *directory*, not the file. You can delete a file you can't read, can't write, and don't own, as long as you own the directory.

- **After `fork(2)`, the parent always executes first.** The scheduler decides. Assuming parent-first ordering is a classic source of race conditions that work fine in testing and explode in production.

- **DNS traffic always uses UDP.** DNS falls back to TCP for responses larger than 512 bytes (or 4096 bytes with EDNS), for zone transfers, and in other cases. Writing a firewall rule that blocks TCP/53 is a great way to break things mysteriously.

- **ICMP is only used for ping and traceroute.** ICMP is a load-bearing part of TCP/IP: Path MTU Discovery relies on it, and blocking ICMP wholesale breaks things in ways that are infuriating to diagnose.

- **The error "compiler warning" means something optional.** Warnings are frequently errors-in-waiting. Ignoring them is how you get undefined behavior that works perfectly until it doesn't — usually in production, under load, on a platform you didn't test.

---

## Where It Gets Complicated

### The Filesystem Is Not What You Think

The Unix filesystem model looks simple until you actually use it. Several assumptions collapse immediately:

**You can always write to the current working directory.** Not if it's been deleted out from under you, is on a read-only mount, or belongs to someone else. **You can always write to `/tmp`** — except when `/tmp` is on a separate partition that's full, or when the system has per-user `/tmp` quotas, or when you're in a container with a read-only root.

**Temporary files are easy and risk-free.** They aren't. Race conditions in temp file creation are a classic security vulnerability; the safe way to create temp files is non-obvious and platform-specific.

**"No space left on device" means you're out of disk space.** It can also mean you've exhausted inodes (you can have gigabytes free and zero inodes), hit a quota, or filled a partition that isn't the one you think you're on.

**You can read the entire file into memory.** Only if the file fits. Log files, database dumps, and `/proc` virtual files will disabuse you of this notion quickly.

**I/O efficiency increases linearly with buffer size.** It doesn't. There's a sweet spot — usually around the filesystem block size — after which you get diminishing returns, and eventually the overhead of managing large buffers costs more than it saves.

### Processes, Memory, and the Kernel's Lies

**`malloc(3)` always returns a valid pointer.** On Linux with memory overcommit enabled (the default), `malloc` can return a non-NULL pointer for an allocation the kernel has no intention of actually backing. The OOM killer resolves the discrepancy later, at a time of its choosing.

**After `fork(2)`, the parent executes first.** Undefined. The scheduler decides. Code that accidentally depends on this ordering will work reliably in testing and fail under load.

**`main` takes two arguments, `argc` and `argv`.** It can take three: `argc`, `argv`, and `envp`. POSIX also defines `getenv`, but the three-argument form exists and is used.

**If you see a process with the same PID as one you saw before, it's the same process.** PIDs are reused. A PID is not a stable identity for a process over time.

**"setuid" means the program has root privileges.** Setuid means the program runs as *its owner*, whoever that is. A setuid binary owned by a regular user runs with that user's privileges, not root's.

**`chmod 777` fixes permissions errors.** It fixes *some* permissions errors while creating security holes. It also doesn't help if the problem is ownership, ACLs, SELinux labels, or any of the other access control layers that exist beneath the simple rwxrwxrwx model.

**Race conditions are only rarely triggered.** Under load, on multi-core systems, or across a network, they're triggered constantly. The fact that you haven't seen one doesn't mean it isn't there.

### Networking Is a Best-Effort Suggestion

**The network is reliable.** The [Fallacies of Distributed Computing](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing) exist precisely because this is so seductively wrong. Latency is not zero, bandwidth is not infinite, the network is not secure, topology changes, and there is more than one administrator.

**Third-party services are reliable. AWS is reliable.** Even with redundancy across multiple geographic regions, AWS has had multi-region outages. "Highly available" is a spectrum, not a binary.

**All traffic on the internet is either UDP or TCP.** ICMP, GRE, ESP, SCTP, and others all exist and matter. A firewall policy built on "allow TCP and UDP" will block things you need.

**DNS traffic always uses UDP.** DNS uses TCP for large responses, zone transfers, and increasingly for privacy-preserving transports. Blocking TCP/53 breaks DNS in ways that are intermittent and maddening.

**ICMP is only used for ping and traceroute.** Path MTU Discovery uses ICMP "Fragmentation Needed" messages. Blocking ICMP causes mysterious TCP stalls that look like application bugs.

### Parsing and Validation Are Unsolved Problems

**Parsing timestamps and dates is trivial.** It is not. See the full [Falsehoods Programmers Believe About Time](https://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time). Time zones are political. Leap seconds exist. "Now" is not a fixed point.

**They know how to validate an email address.** The RFC 5321/5322 grammar for valid email addresses is baroque. `Abc\@def@example.com` is valid. `"Abc@def"@example.com` is valid. The only reliable validation is sending a message and seeing if it arrives.

**They know how to validate a hostname.** Internationalized domain names, trailing dots, labels with hyphens, and the 253-character total length limit all complicate this. Regex is not sufficient.

**They know how to validate an IP address.** IPv4 has edge cases (leading zeros mean octal in some parsers). IPv6 has eight distinct compressed forms for the same address. "Is this a valid IP?" is not a simple question.

**They know how to parse HTML.** You cannot parse HTML with regular expressions. The HTML5 parsing algorithm is a state machine with explicit error recovery. Use a real parser.

### Tooling and Environment Assumptions

**If it builds on your laptop, it will build on everybody else's.** Library versions, compiler versions, `PATH` contents, locale settings, filesystem case-sensitivity (macOS vs. Linux), and dozens of other environmental factors differ between machines.

**`git` and `GitHub` are synonymous.** Git is a distributed version control system. GitHub is one company's web hosting product for git repositories. GitLab, Bitbucket, Gitea, and self-hosted options all exist.

**`Unix` and `Linux` are synonymous.** Linux is one Unix-like operating system. macOS is a certified Unix. Solaris, AIX, HP-UX, and FreeBSD are not Linux. Behavioral differences between them are real and bite you in production.

**`Bash` and `sh` are synonymous.** `/bin/sh` on Ubuntu is `dash`. On macOS it's `bash` in compatibility mode. Bash-specific syntax (`[[ ]]`, arrays, `local`) silently breaks in `sh`. Always specify the interpreter you actually require.

**Command-line tools should print colorized output.** Color codes in output break log parsing, piping to `grep`, and any downstream tool that doesn't strip ANSI escapes. Check `isatty()` before emitting color.

**StackOverflow answers are always correct.** They are frequently correct for the question as asked in 2012, on the platform the asker was using, with the library version they had. Your situation may differ.

**If the code is on the internet, you can use it.** Copyright exists. A license is required to use code legally, and "no license stated" means "all rights reserved," not "public domain."

**Free software is free.** Free as in freedom, not as in beer. Compliance with GPL, LGPL, AGPL, and similar licenses has real legal and engineering costs.

**Open source means fewer bugs and better security.** The OpenSSL Heartbleed vulnerability existed for two years in one of the most widely deployed open-source libraries in the world. Availability of source does not imply anyone has read it.

### Professional and Institutional Myths

**Programming equals Computer Science.** CS is mathematics, theory of computation, algorithms, and systems. Programming is one skill that sometimes follows from it. Many excellent programmers have no CS background; many CS graduates can barely program.

**Being able to program is the most important aspect of being a good software engineer.** Communication, debugging, reading code, estimating work, understanding requirements, and knowing when *not* to write code all matter as much or more.

**Productive coders write lots of code.** The best commits are often deletions. The most productive engineers frequently spend their time preventing code from being written.

**Smart people write clever code.** Clever code is hard to read, hard to debug, and hard to maintain. The goal is clarity. Cleverness is usually a liability.

**Employers care about which courses you took.** They care about what you can do, how you communicate, and whether you'll be effective on their specific problems.

**Technology and algorithms are neutral.** Training data reflects historical biases. Optimization targets encode value judgments. The people who build systems make choices that have consequences for real people.

**Brooks's Law, Conway's Law, and Murphy's Law all have exceptions.** They don't — the laws hold. Adding people to a late project makes it later. Systems reflect the communication structures of the organizations that build them. Anything that can go wrong will.

### When the Category Doesn't Match Reality

Organizational labels lie the same way abstractions do — and the academic "postdoc" is a sharp example. At almost all universities there is no "postdoc" in the official ontology; research councils recognize only "Research Assistants" and "academic staff." An entire workforce runs on a category that doesn't formally exist, and the assumptions stacked on it are mostly false:

**Postdocs are "students" or "trainees."** They aren't. Someone who finished a PhD is a qualified researcher doing real research; the "postdoctoral student" framing — used in actual funding documents — is both inaccurate and corrosive.

**Postdocs are a homogeneous, junior population.** At Cambridge, over 40% of Research Associates had more than three years of service, and around 10% had over ten. The "overgrown graduate student" caricature drives misguided policy.

**Postdoc numbers grew because there are "too many PhDs."** No — they are a function of *how money is spent*. A decades-long shift from core institutional funding to short-term project grants deliberately created a large pool of cheap, highly-skilled, precarious labor. Positions are created by budget decisions, not by nature.

The lesson generalizes: before you build policy or software around a category — "postdoc," "contractor," "user," "admin" — verify what it actually means in the system you're operating in.

---

## If You Build This

1. **Never trust the error message; trust the errno.** "No space left on device," "permission denied," and similar messages describe one possible cause. Check the actual error code and handle all the cases, not just the obvious one.

2. **Use a real parser for structured data.** Dates, email addresses, hostnames, IP addresses, HTML, and URLs all have edge cases that defeat regex. Reach for a standards-compliant library: `dateutil` in Python, `net/mail` in Go, the HTML5 parser in your language of choice. Your hand-rolled validator is wrong.

3. **Design for network failure, not network success.** Assume requests time out, services go down, and DNS lies. Use retries with exponential backoff, circuit breakers, and explicit timeouts. Test with a chaos tool, not just a happy-path integration test.

4. **Check your filesystem assumptions in CI on a different OS than your dev machine.** Case sensitivity, inode limits, `/tmp` behavior, and available disk space differ. If you only test on macOS, you will be surprised by Linux in production, and vice versa.

5. **Treat compiler warnings as errors in CI.** Pass `-Werror` (GCC/Clang) or the equivalent. Warnings that ship are bugs that haven't manifested yet. The time to fix them is before they're in production.

6. **Never assume a category in your organizational system maps to a legal or institutional reality.** "Postdoc," "contractor," "user," "admin" — verify what the word actually means in the system you're operating in before building policy or software around it. Mismatches between paper ontologies and ground truth are where abuse and bugs both live.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods CS students believe (netmeister)](https://www.netmeister.org/blog/cs-falsehoods.html) · [archived copy](../archive/computer-science/01-falsehoods-cs-students-believe-netmeister.md)
- [Falsehoods about computer science (srk21)](https://www.cs.kent.ac.uk/people/staff/srk21/blog/2019/12/02/) · [archived copy](../archive/computer-science/02-falsehoods-about-computer-science-srk21.md)
