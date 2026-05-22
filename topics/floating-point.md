# Falsehoods About Floating Point

> 0.1 + 0.2 ≠ 0.3, and that's the least of your problems.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **`0.1 + 0.2` does not equal `0.3`.** In most languages it prints `0.30000000000000004`. Your language isn't broken — it's doing IEEE 754 binary floating point, and neither `0.1` nor `0.2` can be stored exactly.
- **Most decimal fractions can't be represented at all.** A base-2 system can only cleanly express fractions whose denominator is a power of 2. So `1/2`, `1/4`, and `1/8` are exact, but `1/10` and `1/5` are infinite repeating fractions in binary — exactly like `1/3` is `0.333...` in decimal.
- **`NaN` is not equal to itself.** `NaN == NaN` is `false`. It's the only value in the language where `x == x` returns false, which is also the standard trick for detecting it.
- **There are two zeros.** `+0.0` and `-0.0` are distinct bit patterns. They compare as equal (`+0.0 == -0.0` is `true`), but `1.0 / +0.0` is `+Inf` while `1.0 / -0.0` is `-Inf`.
- **Addition is not associative.** `(a + b) + c` can differ from `a + (b + c)`. Reordering a sum — or letting a compiler or parallel reducer reorder it — changes the result.
- **The number you typed isn't the number you got.** `0.1` is really stored as `0.1000000000000000055511151231257827021181583404541015625`. Printing routines hide this by rounding to the shortest string that round-trips, which is why `0.1` *looks* fine until you add something to it.
- **"It prints `0.3`" doesn't mean it equals `0.3`.** Many languages (PHP, Lua, MATLAB, Python 2) print `0.3` only because the default formatter rounds for display. Under the hood the value is still `0.30000000000000004`. Ask for 17 digits and the truth appears.
- **Single precision is wronger in a different way.** `0.1f + 0.2f` is `0.30000001192092896`, not `0.30000000000000004`. The error depends on the precision (32-bit `float` vs 64-bit `double` vs 80/128-bit) you used.

## Where It Gets Complicated

### Representation

Computers natively store integers. Decimal fractions get approximated in binary, and a base can only represent a fraction exactly if the fraction's denominator is built from the base's prime factors.

- Base 10's prime factors are 2 and 5, so `1/2`, `1/4`, `1/5`, `1/8`, `1/10` terminate, while `1/3`, `1/6`, `1/7`, `1/9` repeat.
- Base 2's only prime factor is 2, so only denominators that are powers of 2 terminate. `1/10` and `1/5` become repeating binary fractions, get truncated to fit the mantissa, and the leftover error surfaces when you convert back to decimal.

This is why `0.1 + 0.2` lands at `0.30000000000000004` in C, C++, Go, Rust, Java, JavaScript, Python 3, and most everything else using IEEE 754 doubles. The exact stored value of that sum is `0.3000000000000000444089209850062616169452667236328125` (and a language like Go will print the full value if you ask).

### Comparison

- **Never test floats for exact equality.** `0.1 + 0.2 == 0.3` is `false`. Compare with a tolerance (epsilon) instead.
- **Some environments hide this with built-in tolerance.** APL's `0.3 = 0.1 + 0.2` returns `1` (true) because of a default comparison tolerance (`⎕CT`) around 10⁻¹⁴; set `⎕CT` to 0 and it returns `0` (false). The inequality was always there.
- **Display precision lies.** R prints `0.3` by default but `0.30000000000000004` with `digits=17`. PostgreSQL ≤11 printed `0.3`; PostgreSQL 12 switched to shortest-precise output. Same bits, different formatter.

### Special values: NaN, Inf, signed zero

- **`NaN` (Not a Number)** poisons everything it touches: any arithmetic with `NaN` yields `NaN`, and every comparison (`<`, `>`, `==`) with `NaN` returns `false`. Detect it with `x != x`.
- **Infinities** are real values. Overflow and division by zero produce `±Inf` rather than throwing. `Inf - Inf` and `Inf / Inf` produce `NaN`.
- **Signed zero**: `+0.0` and `-0.0` are equal under `==` but distinguishable by what they produce (e.g. reciprocal sign), which matters for branch cuts and some numerical code.

### Arithmetic laws that quietly don't hold

- **Associativity fails**: `(a + b) + c ≠ a + (b + c)` in general, because each step rounds.
- **Distributivity fails**: `a * (b + c) ≠ a*b + a*c` in general.
- **Subtracting near-equal numbers ("catastrophic cancellation")** wipes out significant digits — `(0.1 + 0.2) - 0.3` is about `5.55e-17`, not `0`.
- **Order of operations is now load-bearing.** Summing a list left-to-right vs. sorted vs. in parallel can give different answers. This is real, not academic.

### Accumulation error

Small per-operation errors compound. Adding `0.1` to a running total ten times will not land exactly on `1.0`. Loops that increment a float and compare against a target can overshoot, undershoot, or never terminate. For long sums, use a compensated summation algorithm (e.g. Kahan summation) or accumulate in a wider/exact type.

## If You Build This

- **Never compare floats with `==`.** Use an absolute *and* relative epsilon (`abs(a - b) <= eps * max(1, abs(a), abs(b))`), sized to your domain. A fixed `1e-9` is wrong for both astronomical and atomic-scale numbers.
- **Use exact types for money.** Integer cents, or a decimal/`BigDecimal` type — C#'s `decimal`, Java's `BigDecimal`, Python's `decimal.Decimal`, Swift's `Decimal`. Floats and currency don't mix; `0.10 + 0.20` billed a million times will drift.
- **Reach for rationals when you need exactness.** Many languages (Python `fractions`, Ruby `1/10r`, Raku, Clojure, Julia `1//10`) give exact `3/10` results. Use them when correctness beats speed.
- **Guard against `NaN` propagation.** Validate inputs, check `isnan` at boundaries, and remember that sort comparators and `min`/`max` misbehave when `NaN` sneaks in (since all comparisons return false).
- **Don't loop on a float counter.** Iterate with an integer index and compute the float from it, rather than repeatedly adding a fractional step.
- **Control your output precision deliberately.** Don't trust the default formatter to tell you the truth. When debugging, print 17 significant digits for doubles (9 for singles) so you see the real value.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Floating Point Math (0.30000000000000004.com)](https://0.30000000000000004.com) · [archived copy](../archive/floating-point/01-floating-point-math-0-30000000000000004-com.md)
