# Falsehoods About Systems of Measurement

> Units don't convert as cleanly as grade-school math promised.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A gallon is not a gallon.** There's the US liquid gallon, the US dry gallon, the Imperial gallon, and the "ten-gallon hat" — which holds nowhere near ten gallons of anything. Pick the wrong one and your volume calculation is silently wrong.

- **The kilogram is the SI base unit of mass — and it has a prefix baked in.** Every other SI base unit is prefix-less (meter, second, ampere…), but the kilogram ships with "kilo" already attached. This breaks the clean rule that prefixes are always added on top of base units.

- **The liter isn't an official SI unit, but the gallon is an official Imperial unit.** The systems are not symmetric mirrors of each other. The liter is merely "accepted for use" with SI; the gallon is a first-class citizen of Imperial.

- **Fractional-exponent units exist in real engineering formulas.** The radar beam height formula uses a constant expressed in nautical miles per foot^(1/2) — a unit with a fractional dimensional exponent. This is not a textbook curiosity; it's load-bearing in actual radar systems.

- **"Calorie" and "calorie" are different things.** Case matters: a food Calorie (capital C) is a kilocalorie. A lowercase calorie is 1/1000th of that. The same written word, different capitalisation, a factor of 1,000 apart.

- **The hour and minute are not base-ten, and they're officially accepted SI companions.** SI is supposed to be decimal, but the minute (base 60) and hour (base 60²) are on the accepted list anyway — blame Babylonian astronomy and the moon's orbital mechanics.

- **"h" is both an hour and the Planck constant.** Unit symbol namespaces collide in practice. Context is the only disambiguator, and context can be wrong.

- **Joules and Newton-meters are dimensionally identical but not always interchangeable.** Whether you keep plane and solid angle units in your expression changes what you get, so reducing everything to "the same" derived unit can silently discard meaningful physical distinctions.

## Where It Gets Complicated

### There's more than one metric system

Most engineers treat "metric" as a single unified system. It isn't. MKS (meter-kilogram-second) and CGS (centimeter-gram-second) are both "metric," but their base units differ, which means derived units differ too. Electromagnetic quantities in CGS don't map cleanly onto SI equivalents without numerical factors. Treating "metric" as one monolithic system is how cross-system bugs hide.

### Base units aren't as fundamental as they look

**Non-metric systems have base units too** — this surprises people who think "base unit" is a purely SI concept. More confusingly, the Imperial gallon is officially a base unit of the Imperial system, yet it measures *volume*, which is a derived dimension (length³). So you can have a "base unit" that is itself made of a derived dimension. The gallon is simultaneously base and derived depending on which axis you're looking at.

The liter pulls a similar trick from the other direction: it's defined off the decimeter (1 L = 1 dm³), which is why it doesn't need a numerical proportionality constant. The pint has an analogous geometric relationship — the author coined the unit *yardsInOneDimensionOfAPint* to name it, noting that a little more than 11 of them fit in a yard — but nobody talks about it because Imperial units aren't usually taught that way.

### Heterogeneous and fractional units are real

It's tempting to assume that mixing unit systems in a single formula is always a mistake. The radar beam height formula demolishes this: its constant is expressed in **nautical miles per foot** — two different length systems in one ratio — and the exponent on the foot is **1/2**, a fractional dimension. Both "heterogeneous units are useless" and "fractional dimensions are useless" are false, and the same formula refutes both at once.

### Absolute vs. relative measurements are not the same thing

Temperature is the canonical trap. Converting 20 °C to Kelvin for an *absolute* measurement gives 293.15 K. But a *temperature difference* of 20 °C is exactly 20 K — you do not add 273.15. Fahrenheit has the same problem. Code that applies the full conversion formula to a delta will be wrong by 273 (or 459) degrees and may never trigger an obvious error.

### Symbol and name representation is not standardised

- **Derived unit symbols differ across systems.** Miles per hour is written `mph`; kilometers per hour is `km/h`. These are not stylistic choices — they reflect genuinely different conventions between Imperial and SI notation.
- **Unit names in prose are not case-insensitive.** `Calorie ≠ calorie`, and treating string comparison as case-insensitive will merge them into the same thing, introducing a silent factor-of-1000 error.
- **Unit ordering in compound expressions isn't universal.** Whether you put capital-symbol units first, positive-exponent units first, or length-dimension units first varies by convention and field. There is no single correct order.

### Namespace collisions in unit symbols

`h` means hour in everyday use and the Planck constant in physics. These are not edge cases in obscure subfields — both appear in engineering contexts. Any system that stores unit symbols as plain strings without a namespace or type tag will eventually collide them.

## If You Build This

1. **Never treat "metric" as one system.** Store which variant (SI/MKS, CGS, etc.) alongside every value; don't assume metric-to-metric conversion is always a no-op.

2. **Distinguish absolute measurements from relative ones at the type level.** A temperature and a temperature *difference* must be different types or you will apply offset conversions to deltas. This is not a theoretical concern — it has caused real calculation errors in production systems.

3. **Treat unit symbols as case-sensitive and namespaced.** `h` ≠ `H`, `Calorie` ≠ `calorie`. Use a controlled vocabulary or enum, not raw strings, and include a source-system tag to resolve collisions like hour vs. Planck constant.

4. **Support fractional exponents in your dimensional analysis engine.** If you hard-code integer exponents, you cannot represent the radar beam height constant (nautical miles · foot^(-1/2)) and will either crash or silently drop the unit.

5. **Don't assume all "base units" reduce to pure base dimensions.** The Imperial gallon is a base unit of volume — a derived dimension. Your data model needs to handle base units that are themselves dimensionally compound.

6. **Pick an authoritative unit library and extend it rather than rolling your own.** The number of real exceptions documented here (fractional exponents, dual-gallon systems, CGS vs. SI, symbol collisions) is large enough that a hand-rolled converter will miss several of them. Start from a tested foundation.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Systems of Measurement (Steve Moser)](https://www.stevemoser.org/posts/dev/falsehoods-programmers-believe-about-systems-of-measurement.html) · [archived copy](../archive/systems-of-measurement/01-falsehoods-about-systems-of-measurement-steve-mose.md)
