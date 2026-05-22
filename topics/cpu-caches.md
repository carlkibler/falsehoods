# Falsehoods About CPU Caches

> What you believe about CPU caches is quietly breaking your concurrency.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **"Different cores see stale values in their private caches."** On modern x86 (Intel, AMD), hardware keeps every core's cache coherent: if two threads anywhere in the system read the same address, they will never simultaneously read different values. The caches are not dumb storage — they run intricate coherence protocols among themselves.
- **"`volatile` exists to stop variables from being cached locally."** It doesn't. The hardware already keeps caches in sync. `volatile` is about something else entirely (registers, reordering, and write buffers — see below).
- **"`volatile` forces every read/write all the way to main memory."** If it did, it would be brutally slow — a main-memory reference is roughly 200x slower than an L1 reference. In reality a Java volatile read can be as cheap as an L1 hit, and inter-thread coordination can happen in as little as ~1ns.
- **"Single-core systems are immune to concurrency bugs."** False, and dangerously so. Even on one core, the compiler reorders instructions and caches values in registers, so unprotected shared data still races. Coherent caches were never the thing protecting you.
- **"Caches are just fast memory."** Each cache line carries coherence state (M/E/S/I) and a cache that wants to write may have to send a Request-For-Ownership and snoop-invalidate every sibling that holds the line before it's allowed to touch it.
- **"Reads are free / passive."** A read can miss locally, go to L2, miss there, hit main memory, and force a *sibling* core to downgrade a Modified line from M to S and ship its dirty data back — all before your read returns.
- **"The memory subsystem is a single fast monolith."** It behaves like a coherent monolith to your program, but with *very* variable latencies depending on which cache (and which core, and which chip) currently owns the line.
- **"Relying on cache coherence is always safe and portable."** Coherence is a hardware guarantee many memory models lean on, but it isn't universal — non-coherent designs exist (e.g. Intel's Single-Chip Cloud), and code that assumes coherence is, strictly speaking, non-portable.

## Where It Gets Complicated

### Coherence is real, and it's the hardware's job

If each core has a private L1 holding copies of the same data, writes would seem to cause mismatches. They don't, because the hardware enforces coherence for you — invisibly, at the hardware level, so compiler/systems/software developers never manage it directly. The working definition of "in sync": no two threads reading the same address ever see different values at the same time. A buggy processor *can* violate this; no modern x86 does.

### The MESI protocol, concretely

Coherence is most commonly enforced with **MESI**. Every implementation differs (Intel's, Sun's, others all have variants with their own tradeoffs and bugs), but they share the idea that each cache line is tagged with one state:

- **Modified (M):** modified, differs from main memory; this copy is the source of truth and every other copy is stale.
- **Exclusive (E):** unmodified, in sync with main memory, and no sibling cache has it.
- **Shared (S):** unmodified, in sync, and other sibling caches may also hold it.
- **Invalid (I):** stale; never use it.

Consider a 4-core CPU, each core with its own L1, plus a shared on-chip L2.

**A write that hits in E or M** is easy: no other cache has the line, so the core writes immediately and sets the line to M.

**A write where the local line is S (or absent)** is where the work happens. Another sibling might hold the data, so:
1. L1-1 sends a Request-For-Ownership to L2.
2. L2's directory shows L1-2 holds the line in S, so L2 sends a snoop-invalidate to L1-2.
3. L1-2 marks its copy Invalid and Acks.
4. L2 Acks back to L1-1 with the latest data and records that L1-1 now holds it in E.
5. L1-1 performs the write and flips the line to M.

**A read that hits** (line in S, E, or M) just returns the data.

**A read that misses everywhere:** L1-2 (line in I) sends a Request-for-Share to L2; L2 misses too, reads from main memory, then hands the data to L1-2 with permission to enter S.

**A read that misses locally but hits a sibling in E or M:** L2 sends a snoop-share to the owning L1-1, which **downgrades to S and sends back its modified data if applicable** (it cannot drop from M to S without writing its changes back — a subtlety a sharp reader caught in the original comments). L2 then forwards the data to L1-2 with S permission.

This protocol composes recursively: add an L3 coordinating multiple L2s with the same rules; go multi-chip with "Home Agents" coordinating L3s across processors. Each cache only ever talks to its parent (to get data/permission) and its children (to grant/revoke). And there are endless variations the simple model glosses over — O/F states, write-back vs write-through, snoop-broadcast vs snoop-filter, inclusive vs exclusive caches, and store buffers, which we haven't even touched.

### So why does `volatile` exist? (Hint: not cache flushing)

If caches are already coherent, why do languages like Java need `volatile`? Because coherence covers caches — and **registers are not part of that coherent system.** When the compiler loads a value into a CPU register, that register copy is *not* kept in sync with cache or memory. The compiler freely caches values in registers, decides when to write them back, and reorders instructions — all under the assumption that the code runs single-threaded. That assumption is what bites you in concurrent code.

So any data exposed to race conditions has to be protected manually with concurrency constructs — atomics, `volatile`, locks. For Java `volatile`, part of the fix is forcing reads/writes to **bypass local registers and go straight to the L1 cache.** Once the value lands in L1, the hardware coherence protocol takes over and guarantees every other thread sees it. That's how you get inter-thread coordination in ~1ns — no main-memory round trip required.

And it's not only registers: memory barriers (and `volatile`, which implies them) also enforce ordering against other internal CPU structures — on x86, chiefly the **store/write buffer**. The common thread: `volatile` and barriers are about registers, buffers, and ordering. They have nothing to do with flushing caches.

### What actually causes "stale reads"

The folklore blames stale caches. The real culprits are:

- **Register caching:** a thread reads a shared variable once into a register and never reloads it, so it never sees later writes — even though the cache underneath is perfectly coherent.
- **Instruction reordering and store buffers:** writes become visible in an order other than program order, so another thread observes an inconsistent snapshot.

None of these are fixed by "writing through to main memory." They're fixed by telling the compiler and CPU to stop optimizing across the racy access — which is exactly what concurrency constructs do.

### The portability footnote

Coherence is a guarantee much real-world code (and many memory models) depend on, so in practice relying on it is usually fine. But it isn't a law of physics. Non-coherent architectures exist (Intel's Single-Chip Cloud is the example raised), and a language targeting one would hold to the minimal guarantees of its memory model. The reason coherence is near-universal is economic: without it, the compiler and OS would have to insert expensive L1/L2 cache flushes everywhere, which would be a net performance loss.

## If You Build This

- **Don't reason about concurrency in terms of "flushing stale caches."** The hardware keeps caches coherent. Reason instead about registers, reordering, and store buffers — that's where visibility actually breaks.
- **Use the concurrency constructs even on single-core or single-threaded-feeling code.** Coherent caches never protected you; the compiler's register caching and reordering will still produce races without `volatile`, atomics, or locks.
- **Stop avoiding `volatile` for performance reasons.** A volatile read can be as cheap as an L1 hit (~1ns class), not a 200x-slower main-memory trip. The performance fear is based on a myth.
- **Reach for the right tool for the job:** `volatile` for visibility/ordering of a single field, atomics for read-modify-write, locks for compound invariants. They work by constraining compiler/CPU optimization, not by touching cache hardware.
- **Treat hot, contended writes as expensive.** A write to a Shared/sibling-held line triggers Request-For-Ownership and snoop-invalidations; "false sharing" of unrelated fields on one cache line will quietly serialize your cores. Lay out data accordingly.
- **Don't assume coherence in portable low-level code.** Program to the language's memory model, not to "x86 keeps my caches in sync," if your code might ever run on non-coherent hardware.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Myths about CPU Caches (Rajiv Prabhakar)](https://software.rajivprab.com/2018/04/29/myths-programmers-believe-about-cpu-caches/) · [archived copy](../archive/cpu-caches/01-myths-about-cpu-caches-rajiv-prabhakar.md)
