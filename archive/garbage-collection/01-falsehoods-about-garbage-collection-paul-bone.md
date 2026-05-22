# Falsehoods about garbage collection (Paul Bone)

> **Original:** <https://paul.bone.id.au/blog/2018/10/19/gc-falsehoods/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Programmers Believe about Garbage Collection — Paul Bone

It’s about time I joined the cottage industry of Falsehoods that programmers believe about X articles . So here’s my entry, falsehoods programmers believe about garbage collection.

I’m not the first to write about GC falsehoods, I know of the short list of folk myths associated with the Boehm-Demers-Weiser garbage collector (BDW GC), and the FAQ at memorymanagement.org which is the home of the Memory Pool System (MPS). While these sources and others are more informative and complete, they’re not presented in the popular style of a falsehoods article .

Edits 2018-10-20

I’ve made some edits, as some readers seemed to misunderstand what I wrote about pause times.

The falsehoods

GC always means long large pauses

While this was true for the first GCs, it hasn’t been true of most modern GCs for a long time. Many GCs are at least Incremental GCs , meaning they do their work in incrementally, doing some work, allowing the program to run, then doing a little more work. Long pauses (due to non-incremental GC) is best if what you care about is throughput (such as in some batch processing use case). Incremental GCs can comfortably manage pauses of less than 10ms, which is fine for most interactive applications (but not games or multimedia, read on for those) much shorter pauses also possible.

GC sometimes means long pauses

Some incremental GCs can still get stuck with performing some actions in a non-interruptible way. The initial scan of the program stack is often done in one shot. However, even scanning the call stack can be made incremental. A good incremental GC should be able to guarantee a maximum pause time (with the exception of page faults and other things out of its control).

But I write games, even short pauses are bad

10ms is a long time to interrupt a video game which has a frame budget of at most 16ms. These programs can use a very good incremental GC with shorter pauses, but they’re better off using a concurrent GC. In concurrent GC most of the work is done in another thread and therefore the main thread is only paused for hand-offs: when collection starts, when collection stops and when they both try to use the same object. These pauses can be kept well under than 1ms. This does affect throughput, point is, you can’t always assume that GCs always pause.

More about pauses

The characteristics, including pause times, of a GC is a trade off between multiple factors. The two main factors are probably pause time and throughput. Depending on what kind of system you’re building, you may prefer to have longer pauses in return for better throughput.

The first GC I worked on was the BDW GC, we used it for batch processing and therefore didn’t need to use its incremental mode. Pauses where as long as 500ms, but it didn’t matter, the user never observed this.

The GC I’m working on now is the one built into Firefox’s JS engine. When I started we had a default incremental budget of 10ms, now it’s 5ms and that seems to be good for most web apps. I’m sure we could reduce it farther if we tweaked other parameters, such as how frequently it pauses.

More falsehoods

Reference counting (RC) never pauses

If a large graph of memory objects is referred to by a single reference, and that reference is deleted, then all those objects need to be freed. Depending on the implementation this can pause while each object’s reference is decremented then the object’s memory is returned to a free list.

RC is predictable

I’ll concede that it’s deterministic (can be tested). But I wouldn’t call it predictable. I couldn’t look at some code and say “Here’s where it’ll pause”.

GC is not predictable

GC can also be deterministic, but it’s sometimes better when it’s not (see FreeGuard ). If you really need predictable GC, there’s a whole field of real-time GC.

RC is simpler, that makes it better!

Both RC and GC can be very simple (and have long pauses and other problems), or amazingly detailed (and have better performance). In fact, some of the improvements made to RC and GC are analogies of each other, such as delayed decrementing of reference counts vs lazy sweeping or incremental GC.

Allocation the main cost to avoid in GC’d environments

The claim is that things should be stack allocated rather than heap allocated. This is not always a win. First a stack allocated thing may actually live longer than it needs to, and either requires the programmer to perform their own escape analysis (as in C) or requires language support (as in Rust). Next a Generational GC will usually use bump-pointer allocation (slightly slower than stack allocation) to allocate the object. Provided the object isn’t moved out of the nursery it has no further cost; not even freeing it has a cost. The main difference between stack and nursery allocation is therefore what the data is co-located with and therefore how the cache behaves. What does have a cost for GC is objects that survive collections and are moved either within the nursery or into the main heap. During collection live objects are traced (marked or moved), this is their main cost.

GC won’t collect my objects in a timely manner

This one is true! But why should it matter. If you’re not low on memory, then why do you need to reclaim that memory right away? (Don’t use GC to manage non-memory resources!) In fact, some GCs perform lazy sweeping: even after they finish their GC cycle they might not sweep some blocks (which frees memory in those blocks) if there’s no allocation pressure for the kinds of objects that need to be allocated in those blocks. In fact a new collection may occur because of pressure elsewhere and those blocks still haven’t been swept, doesn’t matter, they’ll get more up-to-date mark bits and if there’s sufficient memory pressure later on then they might be swept.

GC won’t always collect my objects

Why is this still a problem? (Don’t use GC to manage non-memory resources!) Some GCs are conservative, meaning they guess whether something is a pointer or not (if they’re unsure then they’ll answer “yes” so as not to free any memory they shouldn’t). This means that sometimes something will look like a pointer, even when it’s not, and the memory it looks like it points to may be retained even when it should have been freed. Don’t use GC to manage non-memory resources! This also sounds like it could be

Memory usage

A sometimes cited claim is that a garbage collector requires more memory than a traditional heap. The most obvious example is a semi-space copying GC which will require at most 2x the peak heap size (but in practice only 2x the working set) in reserve. To maintain adequate throughput a garbage collector will often use more memory, allowing the heap to grow larger before a GC occurs. And usually this is preferred, but if its not your GC should allow you to tune these parameters. Many GCs can also perform compacting, semi-space copying GCs come by this naturally. Therefore, even if more virtual memory is used it may be possible for a GC to compact the set of working memory into less memory, leading to better cache and TLB efficiency. I previously wrote about memory fragmentation in BDW GC in this initial article and a follow-up ).

If you’ve noticed a theme here it’s that many things are trade-offs against one another. Unlike the other falsehood articles these GC falsehoods are softer, many of them are sometimes true , but the point is they’re not always true as some programmers may believe. A lot of them come down to tuning and what types of performance and other characteristics are required. A GC may pause or may be slow, but it depends on what’s important to your application. This means that engineers need to have the ability to make these choices for their application, and while many GCs allow you to do some basic tuning of parameters I’ve read a few claims that through tuning they still could not get the required performance. I think this means we need more languages that allow you to choose an appropriate GC (as far as I know only the Oracle JVM allows you to choose which GC to use easily) and provide easy to follow information about how to tune it.

I have also previously written about techniques such as Rust’s lifetimes and borrowing ( GC vs other memory management techniques ). To summarise that article I’d say: for most programs, most of the time, the developer should not be burdened with managing lifetimes.

Resources

GC is one of only a few areas that has been surveyed extensively. Meaning that not only do people publish papers in it, but that these papers are read, curated and organised further sometimes into books, both also into other sources of information. This means that although it’s a complex field, it’s not too hard to find prior work.

In addition to the links at the top of the page I can recommend:

The Garbage Collection Handbook

Richard Jones’ GC bibliography

Richard Jones’ GC page

memorymanagement.org
