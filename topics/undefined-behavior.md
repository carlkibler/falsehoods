# Falsehoods About Undefined Behavior

> Undefined behavior can cause literally anything — for a broader 'anything' than you imagine.

## The Big Surprises

- **UB can "time travel."** It's allowed to corrupt, undo, or prevent the outcomes of code that ran *before* the offending line — not just code that runs after it. The bug you're chasing may have damaged state that already executed.
- **Unreachable code can still bite you.** A line of UB sitting in dead code isn't safe just because it never runs. Optimizations can sometimes make dead code "live again," so a check you thought was unreachable changes how the rest of the program behaves.
- **One little UB poisons the whole program.** Even a single instance — even one that never executes, even one you don't know is there — means all bets are off for the entire program. There's no containment radius.
- **"It compiled, so it's fine" is 100% false** in C and C++. The compiler is under no obligation to detect UB, and a clean build says nothing about its absence.
- **UB is not purely a runtime phenomenon.** In Rust, misusing `#[no_mangle]` to overwrite a symbol with the wrong type triggers it; in C++, violating the One Definition Rule does — and the compiler isn't required to warn you first.
- **It can wipe your drive or damage hardware.** "Anything" includes overwriting open files, corrupting `stdout`, opening and clobbering new files, and writing garbage to device control registers that physically harm components. This is the lesson people learn the hard way.
- **Deleted security checks are a classic.** Compilers routinely exploit UB to remove "impossible" branches — which is how a null-check or bounds-check meant to protect you simply vanishes from the binary.
- **The full list of guarantees the compiler makes about UB outcomes is empty.** No, nothing was forgotten. That's the whole list.

## Where It Gets Complicated

### UB is not implementation-defined behavior (or unspecified behavior)

Program behaviors fall into three buckets, not two:

- **Specification-defined:** the language itself defines what happens. This is the vast majority of every program.
- **Implementation-defined:** the compiler, OS, or hardware decides, and must document and stick to its choice. Example: exactly how many bits are in a `char` or `int` in C++ (the spec guarantees at least 8 for `char`, at least 16 for `int`; the rest is the implementation's call).
- **Undefined:** anything is allowed to happen, and you might not have a computer left afterward. No outcome is a bug if UB caused it. Examples: signed integer overflow in C, or using `unsafe` to create two `&mut` references to the same data in Rust.

Unspecified behavior is a fourth, milder cousin — like implementation-defined but without the requirement to document and commit to a choice. None of these are UB. UB is the one where the rules stop applying.

The right mental model: "If my program contains UB and the compiler emits a binary that does X, is that a compiler bug?" No. It's not a compiler bug. The compiler is free.

### "UB only happens when the optimizer is on" — all false

None of these turn UB off:

- It only happens at `-O2` or `-O3`.
- Turning off optimizations with `-O0` removes it.
- Including debug symbols removes it.
- Running under a debugger removes it.

And the consolation prizes are false too — there's still UB, but it won't necessarily "do the right thing," and:

- It won't *necessarily* either work or cleanly `SIGSEGV`.
- It won't *necessarily* either work or crash *somehow*.
- It won't *necessarily* either work or crash or hang or deadlock.
- It won't run unrelated code from elsewhere in the program. (It can.)
- It won't run unreachable code the program contains. (It can — see dead code coming back to life.)

### The act of executing UB has no rules

Tempting beliefs, all wrong:

- If a UB line "did the right thing" before, it'll do the right thing next run.
- It'll at least keep doing the right thing for the rest of *this* run.
- You can detect after the fact that a previous line was UB and prevent the fallout.
- The damage is at least limited to code that uses values derived from the UB.
- The damage is at least limited to the same compilation unit.
- The damage is at least limited to code that runs *after* the UB line. (No — this is the time-travel case: UB may corrupt, undo, or erase the effects of earlier operations.)

### "At least it won't corrupt..." — it can corrupt all of it

There is no protected region. UB can corrupt:

- program memory generally,
- memory *outside* where the UB-affected data lived,
- the heap, the stack, the current stack frame (the "local variables are safely in registers" fallacy), the stack pointer,
- the CPU flags register or any other CPU state,
- the program's *executable* memory (W^X and hardware features make this unlikely, but self-modifying programs prove it's possible — there's certainly no guarantee against it),
- streams like `stdout`/`stderr`,
- files the program already had open,
- new files it opens and overwrites,
- the entire drive,
- and physical hardware, by writing bad values to device control registers.

The running joke at the end of the list — "at least it won't start playing Doom if the source wasn't already in the program" — is the point: even the absurd outcomes are spec-compliant. They're just wildly unlikely.

### "But it worked fine before" guarantees nothing

A UB-containing program that "worked fine" once gives you no promise that any of the following still produce a working binary:

- recompiling with no code changes,
- ...with the same compiler and flags,
- ...on the same machine,
- ...without rebooting since last time,
- ...with the same environment variables,
- ...at the same time of day, during a lunar eclipse, having sacrificed a fresh stick of RAM to the binary gods.

### UB is not self-consistent

Same build, same inputs, and still no guarantee of identical behavior across runs — not even if the program (ignoring the UB) is deterministic, not even if it's also single-threaded, not even if it also reads no external data.

### The debugger lies to you

Stepping through a UB-containing program will *not* reliably show state matching your source code. Since UB can corrupt behavior both before and after the offending line, the source in your editor no longer describes the executing program. You can still step through raw assembly and inspect registers — but optimized assembly is hard enough before UB starts rearranging reality. Best avoided entirely.

### Platform and language nuances

- Exotic platforms can offer *extra* guarantees (e.g. CHERI's pointer-safety powers). Most common platforms only guarantee OS-level process isolation — and even that is outside the scope of "what the spec promises."
- In Rust, the "it compiled, so no UB" claim is *almost* true: code that never uses `unsafe` should be UB-free, and triggering UB from safe Rust is considered a compiler bug (rare, and you're unlikely to hit one). The moment `unsafe` appears, all bets are off exactly like C and C++. This guarantee took engineer-centuries to build.

## If You Build This

- **Treat UB as a correctness bug, not a style nit.** "It runs fine in prod" is not evidence of safety — it's evidence that the dice landed your way this build. A recompile, a new compiler version, or a flag change can flip it.
- **Run the sanitizers.** UBSan, ASan, TSan, MSan, and tools like Valgrind catch many classes of UB the compiler will silently exploit. Make them part of CI, not a one-off.
- **Don't debug UB symptoms — eliminate the UB.** Because UB can corrupt state before and after the line and make the debugger misrepresent your source, chasing the visible symptom wastes time. Find and remove the undefined operation itself.
- **Prefer language and library features that make UB unreachable.** Safe Rust, bounds-checked containers, and well-defined integer operations push whole categories of UB out of your reach so the optimizer never gets the chance.
- **Never assume a clean compile means a clean program.** In C/C++ especially, add static analysis and warnings (`-Wall -Wextra`, clang-tidy) on top of the compiler, since detecting UB is not the compiler's job.
- **Remember there is no containment.** Don't reason about "blast radius." One UB anywhere — even in unreachable code — invalidates assumptions program-wide, so fix it rather than fencing it off.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Undefined Behavior (predr.ag)](https://predr.ag/blog/falsehoods-programmers-believe-about-undefined-behavior/) · [archived copy](../archive/undefined-behavior/01-falsehoods-about-undefined-behavior-predr-ag.md)
