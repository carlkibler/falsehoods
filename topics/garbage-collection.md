# Falsehoods About Garbage Collection

> GC doesn't mean you can't leak, and it isn't unpredictable magic.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **"GC always means long, large pauses."** True of the very first collectors, false of most modern ones for decades. Incremental GCs do a little work, let your program run, then do a little more — comfortably hitting pauses under 10ms.
- **"Games and multimedia rule out GC."** A 10ms pause blows a game's ~16ms frame budget, but a *concurrent* GC does most of its work on another thread and only pauses for hand-offs (start, stop, shared-object contention) — kept well under 1ms.
- **"Reference counting never pauses."** Drop the single reference to a huge object graph and every object in it must be decremented and freed, one after another. That cascade is a pause, just one nobody scheduled.
- **"Reference counting is predictable."** It's deterministic (you can reproduce it in a test), but you can't read a chunk of code and point to "here's where it'll pause." Deterministic and predictable are not the same thing.
- **"GC is inherently unpredictable."** GC can be made deterministic too — and there's a whole field of real-time GC for when you genuinely need bounded behavior. Sometimes non-determinism is even the *better* choice (see FreeGuard).
- **"GC won't reclaim my objects in a timely manner."** This one's actually true — and it usually doesn't matter. If you're not low on memory, why rush to reclaim it? The real bug is using GC to manage non-memory resources like file handles or sockets.
- **"Stack allocation always beats heap allocation."** Not in a generational GC: nursery allocation is a bump pointer, and an object that never leaves the nursery costs nothing to free. The real cost is objects that *survive* and have to be traced and moved.
- **"GC needs much more memory than manual management."** A semi-space copying GC reserves up to 2x the peak heap, yes — but it also compacts for free, packing the working set into less memory and improving cache and TLB efficiency. Most of the "extra" memory is a tunable throughput choice, not a tax.

## Where It Gets Complicated

The recurring theme: nearly every GC falsehood is *sometimes* true. The point isn't that the beliefs are always wrong — it's that they're not *always right*, and which way they fall comes down to tuning and what your application actually needs.

### Pauses & latency

"GC always pauses for a long time" was true of early collectors and is now the exception. Incremental GCs interleave their work with yours and hold pauses under 10ms — fine for most interactive apps.

But "GC sometimes pauses" survives as a real caveat. Some incremental collectors still do certain steps in one uninterruptible shot — classically, the initial scan of the program stack. Even that can be made incremental, and a good incremental GC should guarantee a maximum pause time (page faults and other out-of-its-control events aside).

For tighter budgets, the answer is a different design, not abandoning GC. Concurrent GCs move the bulk of collection to another thread, pausing the main thread only for hand-offs — sub-millisecond. Real-world numbers bear this out: the BDW GC in batch processing happily ran 500ms pauses because the user never saw them; Firefox's JS engine started at a 10ms incremental budget and now runs 5ms for most web apps, with room to go lower by tuning how often it pauses.

### Reference counting myths

RC gets sold as the pauseless, predictable alternative. Both claims overreach. It doesn't always pause cheaply: deleting the last reference to a large graph triggers a cascade of decrements and frees that can stall just like a collection. And while it's deterministic, it isn't predictable — you can't eyeball code and locate the pauses.

"RC is simpler, so it's better" misses that both RC and GC live on the same spectrum: each can be trivially simple (with long pauses and other problems) or richly detailed (with good performance). Many of their advanced techniques are mirror images of each other — delayed decrementing of reference counts is the RC analogue of lazy sweeping / incremental GC.

### Determinism & non-memory resources

GC is not doomed to be unpredictable: it can be made deterministic, and real-time GC exists for hard guarantees. Sometimes non-determinism is preferable (FreeGuard).

The genuinely-true falsehoods cluster around timing: "GC won't collect my objects in a timely manner" and "GC won't *always* collect my objects" are both real. Some GCs do lazy sweeping — even after a cycle finishes, blocks may go unswept if nothing is pressuring those object sizes; a later collection can refresh their mark bits without ever sweeping them, and that's fine. Conservative GCs guess whether a word is a pointer and, when unsure, answer "yes" to avoid freeing something live — so a non-pointer that *looks* like a pointer can retain memory that should have been freed. The conclusion in every case is the same: don't use GC to manage non-memory resources. It was never designed to promptly close your files.

### Allocation cost & the stack myth

"Allocation is the main cost to avoid, so stack-allocate everything" doesn't hold in a GC'd environment. Stack allocation can keep data alive longer than needed, and forces either manual escape analysis (C) or language support (Rust). A generational GC allocates via bump pointer — marginally slower than the stack — but an object that stays in the nursery costs nothing further, not even to free. The only real difference between stack and nursery allocation is what the data is co-located with, i.e. cache behavior. The actual GC cost is tracing (marking or moving) the objects that *survive* a collection.

### Memory usage & throughput vs. latency

The "GC wastes memory" claim has a kernel of truth — a semi-space copying GC reserves up to 2x peak heap (in practice ~2x the working set). Collectors also deliberately let the heap grow before collecting, because that buys throughput, and that's usually what you want. When it isn't, a good GC lets you tune those parameters. And the extra virtual memory can pay for itself: compaction (free in a copying GC) shrinks the working set into less physical memory, improving cache and TLB efficiency.

Underneath all of it is one trade-off, pause time versus throughput. A batch processor should happily take long pauses for better throughput; an interactive app shouldn't. Engineers need the ability to make that choice per application. Most GCs offer basic tuning, but there are credible reports that tuning alone couldn't hit required performance — which argues for more languages letting you *choose* the collector (so far, easily only on the Oracle JVM) with clear guidance on how to tune it.

## If You Build This

- **Match the collector to the workload.** Long pauses are fine for batch/throughput jobs; interactive apps want incremental; games and multimedia want concurrent (sub-1ms hand-offs). Pause time vs. throughput is the master trade-off — pick a side deliberately.
- **Never use GC to manage non-memory resources.** File handles, sockets, locks, and DB connections need explicit close / dispose / `with` blocks. GC collects "eventually," which is the wrong contract for anything but memory.
- **Don't reflexively stack-allocate or fear allocation.** In a generational GC, short-lived nursery objects are nearly free. Optimize for *survivorship* — fewer objects living long enough to be traced and promoted — not for raw allocation count.
- **Treat memory headroom as a throughput knob.** A bigger heap means fewer collections and better throughput. If your GC exposes tuning (heap growth, incremental budget, pause frequency), use it before concluding GC "doesn't work" for you.
- **Don't confuse deterministic with predictable.** Reference counting is reproducible but its pause locations are opaque, and its decrement cascades can stall. If you need bounded behavior, reach for a real-time / deterministic GC rather than assuming RC gives it to you.
- **Lean on the literature.** GC is one of the most thoroughly surveyed areas in systems — the Garbage Collection Handbook and Richard Jones' bibliography mean you rarely have to reason from first principles.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about garbage collection (Paul Bone)](https://paul.bone.id.au/blog/2018/10/19/gc-falsehoods/) · [archived copy](../archive/garbage-collection/01-falsehoods-about-garbage-collection-paul-bone.md)
