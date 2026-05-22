# Falsehoods About Null Pointers

> Null pointers are more cursed than pointers, and pointers are already cursed.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Dereferencing a null pointer immediately crashes the program.** Your first `*(int*)NULL` probably gave you a `Segmentation fault (core dumped)` or `STATUS_ACCESS_VIOLATION` — but tools like Crashpad install a signal handler (Unix) or vectored exception handler (Windows) and print a tidy backtrace before anything dies.
- **Dereferencing a null pointer eventually terminates the program.** It's recoverable. Go turns nil dereferences into panics you can `recover` from; Java turns them into a catchable `NullPointerException`. Crashing-then-recovering is an *optimization* — checking every pointer against null costs cycles in the common case, while signal handling is zero-cost until it fires.
- **Dereferencing a null pointer always gets rejected by hardware.** On x86 real mode, addresses `0`–`1024` held the interrupt table — address 0 was just memory. Still true on many embedded platforms, where reading address 0 reads address 0.
- **Even on modern platforms, address 0 is always unmapped.** Linux's `MMAP_PAGE_ZERO` personality (`setarch -Z`, or `sysctl vm.mmap_min_addr=0`) maps a page of zeroes at 0. And WebAssembly maps memory at address 0 by default — isolation inside a wasm sandbox is pointless, so null dereferences just *work*.
- **The null pointer has address 0.** The C standard only requires that `(void*)0` (with a constant-zero expression) yields a null pointer and that `if (p)`/`!p` treat it as false. The bit pattern is unspecified — real architectures and C interpreters use non-zero null pointers. `fullptr` is not entirely a joke.
- **The null pointer has address 0 on modern hardware.** On AMD GCN and NVIDIA Fermi GPUs, address 0 is accessible memory. On AMD GCN the null pointer is represented as `-1`.
- **Null pointers are stored as all-zero bits.** On CHERI, a pointer carries a 128-bit capability alongside the 64-bit address — any pointer with address 0 is null, so there are ~2¹²⁸ distinct null pointers, only one of which is all-zero. Pointer-to-member null is commonly stored as `-1`, because offset 0 is a valid member.
- **`(void*)0` and a runtime `(void*)x` where `x==0` are the same thing.** Only the *constant* expression is guaranteed to be null. A runtime int-to-pointer cast is implementation-defined and may produce something else entirely.

## Where It Gets Complicated

### What "address 0" even means

The crashing intuition comes from virtual memory, not from null pointers being special. Before virtual memory, and still on embedded systems and wasm, address 0 is ordinary accessible memory; dereferencing a null pointer there reads address 0 just like any other access. If you genuinely need address 0, two sound routes: write it in assembly (no UB there), or, if the hardware ignores the top address bits, reach 0 via `0x80000000` from C. Historically the HP-UX C compiler had a flag to map a page of zeroes at 0 so `*(int*)NULL` returned `0`; programs that relied on this had to be patched or run under a personality flag for modern OSes.

### Dereferencing and UB

Dereferencing a null pointer is UB, but "UB" has drifted. In the old days the C standard read like guidelines, UB was closer to implementation-defined behavior, and optimizers were too dumb for the difference to matter — on most platforms a null dereference compiled and behaved exactly like accessing address 0. The modern "spooky action at a distance" UB, where the optimizer assumes the dereference can't happen and rewrites code accordingly, is a newer development. The behavior didn't change in the standard; the compilers did.

### Provenance: equal bits, different pointers

Two pointers with identical bit patterns can behave differently, because pointers carry provenance the hardware can't see.

```c
int x[1];
int y = 0;
int *p = x + 1;  // may compare == &y
if (p == &y) {
    *p;          // UB anyway — p's provenance is x, not y
}
```

Consequences when address 0 is dereferenceable:

- A pointer *to an object* is never a null pointer, even at the same address. `int tmp=123; int *p=&tmp;` may sit at address 0 and `*p` yields `123`, while `int *q=NULL;` (from constant zero) has the same bits but `*q` is UB.
- C requires pointers to objects to compare *unequal* to `NULL` even if the object lives at address 0. So addresses alone don't determine pointer equality — and since provenance isn't a runtime quantity, the compiler can only resolve such comparisons at compile time. Round-tripping a real pointer through `(void*)(uintptr_t)p` keeps it unequal to NULL by transitivity. Practically: if an object might cross an FFI boundary, you can't realistically place it at address 0. (Rust forbids placing objects at address 0 outright.)
- `int x=0; (void*)x` is a *runtime* cast: implementation-defined. It may give a null pointer, an invalid pointer, or even a dereferenceable pointer to an object at 0 — and it's allowed to compare unequal to `NULL`. Some compilers leaned on exactly this so `int zero=0; int *q=(void*)zero; *q;` could soundly read address 0, whereas `int *p=(void*)0; *p;` is UB. `void* p; memset(&p,0,sizeof(p));` is likewise not guaranteed null. Most non-C languages don't distinguish compile-time from runtime int-to-pointer casts and behave consistently.

### Representation: the bits aren't the address

The integer "address" exposed by casts need not match the in-memory bit pattern, much as casting an int to a float doesn't preserve bits.

- **Segmented addressing** was the classic case.
- **ARM pointer authentication** stores a cryptographic signature in the top byte of a pointer, verified on dereference. Pointers in `__ptr_auth` regions are signed; Apple deliberately left null pointers *unsigned* (so their compile-time values stay predictable) — a choice, not a standard requirement.
- **CHERI** attaches a 128-bit capability to guard against use-after-free and out-of-bounds. Address 0 means null regardless of the capability bits, hence the many distinct null representations, and equality comparison can differ from bitwise comparison.
- **Pointers to members** are essentially field offsets; 0 being a valid offset, `(int Class::*)nullptr` is typically stored as `-1`.

## If You Build This

- **Don't treat C as portable assembly.** It has its own abstract machine. Translate intent into C's semantics, not into "what the hardware does" — that mismatch is what created these traps.
- **Reach for the right primitives.** Use `= {0}` instead of `memset` when you can; use `uintptr_t` (never `size_t`) if you must cast a pointer to an integer; use `void*` as your untyped/unaligned pointer type instead of round-tripping through integers at all.
- **Let the compiler do pointer tricks.** Write `flag ? p : NULL` instead of hand-rolled `(void*)((uintptr_t)p * flag)`. Store flags beside the pointer if possible; if you must pack them, prefer `(char*)p + flags` over `(uintptr_t)p | flags` so provenance survives.
- **Never assume null is address 0, that null is all-zero bits, or that equal bits mean equal pointers.** Embedded targets, GPUs, wasm, CHERI, and pointer authentication each break one of these.
- **When unsure, escalate in order:** the C standard, then your compiler's docs, then the compiler developers themselves. Don't trust "common sense" and don't assume current behavior is permanent.
- **When you can't avoid an assumption, document it.** It's the difference between a future porter cursing your name and understanding your constraints.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about null pointers (purplesyringa)](https://purplesyringa.moe/blog/falsehoods-programmers-believe-about-null-pointers/) · [archived copy](../archive/null-pointers/01-falsehoods-about-null-pointers-purplesyringa.md)
