# Falsehoods about Undefined Behavior (predr.ag)

> **Original:** <https://predr.ag/blog/falsehoods-programmers-believe-about-undefined-behavior/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods programmers believe about undefined behavior

Falsehoods programmers believe about undefined behavior November 27, 2022 compilers intro

Undefined behavior (UB) is a tricky concept in programming languages and compilers. Over the many years I’ve been an industry mentor for MIT’s 6.172 Performance Engineering course , \[Sidenote: An excellent class that I highly recommend. It’s very thorough and hands-on, at the expense of also requiring a lot of work at a very fast pace. When I took it as an undergrad, that was a great tradeoff, but YMMV. \] I’ve heard many misconceptions about what the compiler guarantees in the presence of UB. This is unfortunate but not surprising!

For a primer on undefined behavior and why we can’t just “define all the behaviors,” I highly recommend Chandler Carruth’s talk “Garbage In, Garbage Out: Arguing about Undefined Behavior with Nasal Demons.”

You might also be familiar with my Compiler Adventures blog series on how compiler optimizations work. An upcoming episode is about implementing optimizations that take advantage of undefined behavior like dividing by zero, where we’ll see UB “from the other side.”

Undefined behavior != implementation-defined behavior

Undefined behavior is not the same as implementation-defined behavior. \[Sidenote: Undefined behavior is also not the same as unspecified behavior , which is similar to implementation-defined behavior minus the requirement that the implementation document its choices and stick to them. Here we’re focusing on undefined behavior, not unspecified behavior, so we’ll lump unspecified behavior and implementation-defined behavior together. \] Program behaviors fall into three buckets, not two:

Specification-defined: The programming language itself defines what happens. This is the vast majority of every program.

Implementation-defined: The exact behavior is defined by your compiler, operating system, or hardware. For example: how many bits exactly are in a char or int in C++. \[Sidenote: The specification guarantees at least 8 bits for char and at least 16 bits for int . The rest is implementation-defined. \]

Undefined behavior : Anything is allowed to happen, and you might no longer have a computer left after it all happens. No outcome is a bug if caused by UB. For example: signed integer overflow in C, or using unsafe to create two &mut references to the same data in Rust. \[Sidenote: Wikipedia has an excellent list of examples if you’d like to see more. \]

Here’s the list of guarantees compilers make about the outcomes of undefined behavior:

That’s the whole list. No, I didn’t forget any items. Yes, seriously.

It is possible to analyze how UB affects a specific program when compiled by a specific compiler or executed on a specific target platform . For example, there exist exotic compilers, operating systems, and hardware that offer additional guarantees \[Sidenote: Like CHERI , with awesome powers around pointer safety. \] relative to most common platforms, which only guarantee OS-level process isolation . We aren’t talking about those in this post.

The mindset for this post is this: “If my program contains UB, and the compiler produced a binary that does X, is that a compiler bug?”

It’s not a compiler bug.

All of the following assumptions are wrong

Falsehoods about when UB “happens”

Undefined behavior only “happens” at high optimization levels like -O2 or -O3 .

If I turn off optimizations with a flag like -O0 , then there’s no UB.

If I include debug symbols in the build, there’s no UB.

If I run the program under a debugger, there’s no UB.

Okay there’s still UB with all of these, but my code will “do the right thing” regardless.

It will either “do the right thing” or crash with a Segmentation Fault ( SIGSEGV signal).

It will either “do the right thing” or crash somehow .

It will either “do the right thing” or crash or infinite-loop or deadlock.

At least it won’t run some unrelated code from elsewhere in the program.

At least it won’t run any unreachable code the program might contain.

Falsehoods around the behavior of executing UB

If a line with UB previously “did the right thing,” then it will continue to “do the right thing” the next time we run the program.

The UB line will at least continue to “do the right thing” while the program is still running.

It’s possible to determine if a previous line was UB and prevent it from causing problems.

At least the impact of the UB is limited to code which uses values produced from the UB.

At least the impact of the UB is limited to code which is in the same compilation unit as the line with UB.

Okay, but at least the impact of the UB is limited to code which runs after the line with UB. \[Sidenote: UB is explicitly allowed to alter the behavior of other code, even including operations preceding it! “Alter” here encompasses corrupting, undoing, or altogether preventing (as if it never happened) the outcomes of that other code. To learn more and see examples of UB causing “time travel,” check out this blog post . Thanks to these two Reddit posts for suggesting better wording for these items. For the original text, see the Errata section at the end of this post. \]

Falsehoods about the possible outcomes of UB

At least it won’t corrupt the memory of the program.

At least it won’t corrupt the memory of the program other than where the UB-affected data was located.

At least it won’t corrupt the heap.

At least it won’t corrupt the stack.

At least it won’t corrupt the current stack frame. (My name for this is the “local variables are safely in registers” fallacy.)

At least it won’t corrupt the stack pointer.

At least it won’t corrupt the CPU flags register / any other CPU state.

At least it won’t corrupt the executable memory of the program. \[Sidenote: OS and hardware security features like W^X can make this unlikely, but self-modifying programs can be built so it’s in principle possible through UB as well. Certainly there’s no guarantee that UB won’t do this! \]

At least it won’t corrupt streams like stdout or stderr.

At least it won’t overwrite any files the program already had open.

At least it won’t open new files and overwrite them.

At least it won’t completely wipe the drive.

At least it won’t damage or destroy any hardware components. \[Sidenote: Not all devices have the same level of self-protection against bad inputs written to their control registers. This is the kind of lesson one tends to learn the hard way. \]

At least it won’t start playing Doom if the program didn’t already have the Doom source code in it. \[Sidenote: I’d be quite impressed if you made a compiler that makes programs run Doom when they encounter UB. Consider it a challenge! \]

Falsehoods like “but it worked fine before”

If a UB-containing program “worked fine” previously, recompiling the program without any code changes will still produce a binary that “works fine.”

Recompiling without code changes and with the same compiler and flags will produce a binary that still “works fine.”

Recompiling as above + on the same machine will produce a binary that still “works fine.”

Recompiling as above + if you haven’t rebooted the machine since the last compilation will produce a binary that still “works fine.”

Recompiling as above + with the same environment variables will produce a binary that still “works fine.”

Recompiling as above + at the same time of day and day of week as before, during a Lunar eclipse, having first sacrificed a fresh stick of RAM to the binary gods, will produce a binary that still “works fine.”

Falsehoods about self-consistent behavior of UB

Multiple runs of the program compiled as above and with the same inputs will produce the same behavior in each run.

Those multiple runs will produce the same behavior if the program, ignoring the UB, is deterministic.

But they will if the program is also single-threaded.

But they will if the program also doesn’t read any external data (files, network, environment variables, etc.).

Community-contributed falsehoods around UB

Using a debugger on a UB-containing program will show program state that corresponds to the source code. \[Sidenote: This is a corrolary of falsehood \#16 , further explained in this post . UB can corrupt the behavior of the program both before and after the UB, so the source code you see in your editor no longer matches the actual executing program. Of course, you can still use the debugger to step through assembly instructions and view register state. But highly optimized assembly isn’t easy to understand to begin with, and UB-induced weirdness will only make it harder. Overall, a situation that is best avoided. Contributed here . \]

Undefined behavior is purely a runtime phenomenon. \[Sidenote: In Rust, a counter-example is misusing \#\[no_mangle\] to overwrite a symbol with an incorrect type . A C++ counter-example is violations of the One Definition Rule (ODR) , some of which the compiler is not required to report before causing havoc. \]

False expectations around UB, in general

Any kind of reasonable or unreasonable behavior happening with any consistency or any guarantee of any sort.

The moment your program contains UB, all bets are off . Even if it’s just one little UB. Even if it’s never executed. Even if you don’t know it’s there at all. Probably even if you wrote the language spec and compiler yourself. \[Sidenote: Speaking from experience. Hopefully not one you have to relive to believe. \]

This is not to say that all outcomes in the list above are equally likely, or even plausible. \[Sidenote: Especially the one about running Doom. \] But they are all allowed, valid, spec-compliant behavior.

It’s perfectly possible that your program has UB, and it’s been running fine for years without issues. That’s great! I’m happy to hear it! I’m not even saying you need to go back and rewrite it to remove the UB. But as you make your decisions, it’s good to know the full picture of what the compiler will or won’t guarantee for your program.

Honorable mention for one special assumption

“If the program compiles without errors then it doesn’t have UB.”

This is 100% false in C and C++.

It’s also false as stated in Rust, but with one tweak it’s almost true. If your Rust program never uses unsafe , then it should be free of UB. In other words: causing UB without unsafe is considered a bug in the Rust compiler . These are rare and you are quite unlikely to run into them.

When Rust unsafe is used, then all bets are off just as in C or C++. But the assumption that “Safe Rust programs that compile are free of UB” is mostly true .

This is not an easy feat. We owe a debt of gratitude to the folks who cumulatively put engineer-centuries into making it so. It’s Thanksgiving, and I thank you!

Errata and edit history

2022-11-29: Items 13-16 corrected and updated

The original version of this post contained the following items at positions 13-16 in the list:

But if the line with UB isn’t executed, then the program will work normally as if the UB wasn’t there.

Okay, but if the line with UB is unreachable (dead) code , then it’s as if the UB wasn’t there. \[Sidenote: Surprising, right? It isn’t obvious why code that should be perfectly safe to delete would have any effect on the behavior of the program. But it turns out that sometimes optimizations can make some dead code live again . EDIT: This was originally footnote \#6 before being moved down here. \]

If the line with UB is unreachable code, then the program won’t crash because of the UB.

If the line with UB is unreachable code, then the program will at least stop running somehow and at some point .

This wording was not precise enough, and as a result the claims were arguably incorrect as stated. I have updated the post near those claims to better capture the subtleties involved.

2022-11-29: Added community-contributed items

The “False expectations around UB, in general” section now contains a selection of community-suggested items. Previously it only contained a single item (the last one in the current list) at position number 41.

Thanks to arriven , Conrad Ludgate , sharnoff , Brian Graham, and a few folks who preferred to remain unnamed, for feedback on drafts of this post. Any mistakes are mine alone.

Machine-friendly markdown version with the same content: https://predr.ag/blog/falsehoods-programmers-believe-about-undefined-behavior.md
