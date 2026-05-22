# Falsehoods about Systems of Measurement (Steve Moser)

> **Original:** <https://www.stevemoser.org/posts/dev/falsehoods-programmers-believe-about-systems-of-measurement.html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Programmers Believe About Systems of Measurement

When starting UnitsKit I had many false assumptions about how irregular systems of measurement could be. Even after studying the subject and other existing libraries I was surprised by how many more irregularities I found. Inspired by Patrick McKenzie’s post about ‘Falsehoods Programmers Believe About Names’ I have set out to form a non-complete list of irregulars when working with systems of measurement and converting between them.

There is more than one variant of the metric system. (MKS vs CGS)

All base SI units are prefix-less. (The kilogram is the base unit of mass)

All derived metric units are derived of base SI units. (The liter is based off of decimeters)

Heterogenous units are of no practical use. (Radar beam height formula uses a constant expressed in nautical miles per foot)

Fractional dimensions are of no practical use. (Radar beam height formula uses a constant expressed in nautical miles per foot^(1/2) )

Non-metric systems have base units as well.

Just as liters has decimeters so that it doesn’t need a numerical proportionality constant, pints has yardsInOneDimensionOfAPint . (I made up my own unit for this, a little more than 11 of them fit in a yard).

A gallon is treated much like a liter in their respective systems of measure. (Liter is not an official SI unit but a gallon is an official Imperial unit).

All base units are made of base dimensions. (The gallon ‘base’ unit is made of the derived volume dimension)

A gallon is a gallon is a gallon. (Did you mean a liquid or dry gallon, US, Imperial, or a ten-gallon hat?)

Written out unit names are not case-sensitive (Calorie vs. calorie)

Base units always reduce to the same derived units. (Did you mean a Joule or a Newton meter? You might know but then you have to keep track of plane and solid angle units.)

Written out base units should always be presented in the same order (Are capital symbols, units with positive exponents, or length dimension units first?)

There is no need to differentiate between absolute and relative measurements. (Kelvin and Fahrenheit)

Derived unit symbols are represented the same way across systems of measure (mph vs km/h)

All units accepted for use with the SI are base ten (the hour and minute are base 60, Sexagesimal, blame the moon)

You will never have any namespace issues. (Is that h an hour or the Planck constant?

Related Posts
