# Falsehoods About /dev/urandom

> Everything everyone repeats about /dev/urandom vs /dev/random is wrong.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **"/dev/urandom is insecure; always use /dev/random for crypto."** Backwards. On UNIX-like systems, /dev/urandom is the *preferred* source of cryptographic randomness. Real cryptographers say so — Thomas Ptacek's entire considered position is "Use urandom. Use urandom. Use urandom."

- **"/dev/random is a 'true' RNG and /dev/urandom is just a PRNG."** Both pull from the *exact same* cryptographically secure PRNG (CSPRNG). The only meaningful difference is what happens when the entropy estimate runs low: /dev/random blocks, /dev/urandom doesn't.

- **"/dev/random hands you pure randomness straight from the entropy pool."** It doesn't. Every randomness source is mixed and hashed through the CSPRNG before a single byte comes out — via either device. There is no "raw whitened randomness" tap.

- **"You'll run out of entropy and /dev/urandom will give you weak numbers."** Entropy "running low" is a straw man. ~256 bits of entropy is enough to produce computationally secure output for longer than the universe has existed. You don't burn through it like fuel.

- **"The kernel precisely counts the entropy in its pool."** It *estimates* it, by interpolating polynomials over event arrival times to gauge "how surprising" each event was. If that estimate is too optimistic, /dev/random's cherished guarantee evaporates anyway.

- **"True quantum randomness makes your crypto stronger."** Your "philosophically secure" quantum bits get fed into AES, RSA, and SHA — all of which are only *computationally* secure. If those break, your perfect randomness buys you nothing. You're distrusting the CSPRNG while trusting algorithms built on the same math.

- **"Even the man page agrees /dev/urandom is risky."** The man page is, in djb's words, "superstitious nonsense." Its own logic implies we can't expand a 256-bit seed into an unpredictable stream — yet trust a single key to encrypt many SSL/PGP messages. It doesn't pass the laugh test.

- **"Blocking is the safe choice."** Blocking is a *security* problem. It pushes desperate users to patch out `random()`, fake the entropy counter via some forum-found ioctl, or disable SSL entirely — quietly destroying the security you thought you had.

## Where It Gets Complicated

### Entropy myths

The intuitive mental model — entropy is precisely counted, added to a counter, drained on each read — is wrong on two counts. First, the kernel only *estimates* entropy, using event arrival times run through polynomial interpolation. Hardware sampling rates and internal restrictions can skew those times. The estimate is believed to be conservative and pretty good, but it is fundamentally an estimate, not a measurement.

Second, entropy doesn't deplete like a tank. The CSPRNG's building blocks are designed so that, given enough randomness at the start (a usual lower bound is 256 bits), an attacker cannot predict the output — period. More than that buys you nothing. Given that "entropy" here is already a hand-wavy quantity the kernel can't precisely measure, fretting about it "running low" is misplaced.

### CSPRNG vs "true" randomness

Cryptographers sidestep the philosophical question of what "truly random" means (quantum effects, radioactive decay, take your pick) and care about one thing: **unpredictability**. As long as nobody can learn anything about the next number, you're fine.

And here's the trap. Almost every algorithm you use — AES, RSA, Diffie-Hellman, elliptic curves, OpenSSL, GnuTLS — offers only *computational* security, not information-theoretic security. (The rare exceptions, the one-time pad and Shamir's Secret Sharing, are impractical or niche.) So if you reject the CSPRNG because it's "only" computationally secure, you must reject every cipher you'd feed those numbers into. A CSPRNG's output is, by design, indistinguishable from random — the same property a block cipher's or hash's output must have. If someone could exploit a "weakness" of the CSPRNG over true randomness, they'd already be breaking AES and SHA, and you'd have nothing left to protect anyway.

### Blocking vs non-blocking

This is the *only* real difference between the two devices. Both are fed by the same CSPRNG; /dev/random simply blocks when its entropy estimate runs out, and /dev/urandom doesn't.

Blocking runs directly counter to availability. Waited for a PGP key to generate in a VM? Watched a web server hang creating an ephemeral session key? That's /dev/random. A system that won't do its job isn't secure — it's broken. Worse, blocking trains ordinary, non-cryptographer users to invent workarounds: patching out the blocking call, abusing an ioctl to inflate the entropy counter, or just turning SSL off. The "secure" choice silently produces insecure systems. Blocking is not necessary for security; it is a false dichotomy.

Re-seeding is real and good, but it's a separate matter from blocking. Fresh entropy is continuously mixed into the generator's *internal state* — not because the output is otherwise weak, but for self-healing: if an attacker ever fully compromises the internal state (and can thus compute all future output), continued re-seeding gradually restores unpredictability. That's an argument for injecting entropy, never an argument for blocking the output.

### Kernel structure (and the Linux 4.8 change)

Before Linux 4.8, /dev/random and /dev/urandom were equivalent: both drew from the same CSPRNG-driven pool, differing only in blocking behavior. From Linux 4.8 onward, the equivalence was dropped — /dev/urandom's output now comes directly from a CSPRNG rather than the entropy pool. This is not a security problem, for all the reasons above: CSPRNG output is exactly what you want.

### The boot-time exception (the one genuine caveat)

/dev/urandom isn't flawless, and the flaw is narrow: the whole scheme rests on having *some* starting seed. On Linux, /dev/urandom never blocks — so very early in boot, before the kernel has gathered entropy, it will happily hand out not-very-random numbers.

FreeBSD does this right: one device, which blocks *once* at startup until enough seed entropy is gathered, then never blocks again. Linux instead mitigates it: distributions save random numbers to a seed file (gathered after some entropy is available) and reload it on the next boot, carrying randomness across reboots. It's not perfect — writing the seed at shutdown would capture more accumulated entropy — but reading at boot survives crashes that skip shutdown scripts. Installers seed the file too, covering the first-ever boot.

**Virtual machines break this.** Cloning a VM or rewinding to a checkpoint duplicates the seed file, so two "different" machines start from identical state. The fix is still not "use /dev/random everywhere" — it's to properly re-seed each VM after any clone, restore, or checkpoint.

### Cross-platform

FreeBSD's model is the cleaner design: no /dev/random vs /dev/urandom distinction at all. A single device blocks exactly once at startup to gather initial entropy, then is always non-blocking and always safe. Linux's split is the source of most of the confusion.

## If You Build This

- **Default to /dev/urandom** (or `getrandom()`, or your OS CSPRNG) for all cryptographic randomness. Don't reach for /dev/random thinking you'll get "better" numbers — you'll get the same numbers, sometimes after a pointless wait.

- **Never let randomness block a user-facing operation.** Don't make a mail server connection hang "to be safe." Blocking drives users to dangerous workarounds; non-blocking CSPRNG output is already secure.

- **Stop worrying about entropy "running out."** Once seeded with ~256 bits, a CSPRNG is good effectively forever. Don't add entropy-counter checks, ioctl hacks, or re-read loops chasing a number the kernel can only estimate anyway.

- **Handle early boot deliberately.** This is the one real risk. Ensure a seed file is loaded before generating keys, or use an interface like `getrandom()` that waits for the pool to be initialized exactly once — not /dev/random's perpetual blocking.

- **Re-seed every VM after cloning, restoring, or rewinding.** Cloned seed files mean cloned "randomness." Inject fresh entropy per instance; don't assume the saved seed makes a duplicated machine unique.

- **If you truly want /dev/random for long-lived GPG/SSL/SSH keys, fine** — a few seconds of typing won't hurt. Just don't impose that blocking on anything else, and know it's belt-and-suspenders, not a real security upgrade.
## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Myths about /dev/urandom (Thomas Hühn)](https://www.2uo.de/myths-about-urandom) · [archived copy](../archive/urandom/01-myths-about-dev-urandom-thomas-h-hn.md)
