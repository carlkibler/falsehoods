# Falsehoods About Typography

> Fonts lie about their metrics, and case is not a simple toggle.

## The Big Surprises

- **Two fonts set to the same size — say, 16px — will not look the same size.** Font size is a box, not a measurement of any visible part of the letterform. What fills that box is entirely up to the type designer.

- **The width of "a" plus the width of "b" does not equal the width of "ab".** Kerning and contextual spacing mean glyph widths don't add linearly. This breaks every naive text-measurement implementation.

- **The letter "M" is not one em wide.** The em is a unit of measurement, not a description of the M's actual width. The M in most fonts is narrower than one em.

- **Greek capital Σ (Sigma) lowercases to two different characters depending on where it appears in a word.** Final position → ς; anywhere else → σ. Case mapping is not a lookup table; it's a function of context.

- **The German ß uppercases to "SS" (two characters), and "SS" lowercases to "ss" — so `toLowerCase(toUpperCase(ß)) ≠ ß`.** Case transformation is neither bijective nor transitive.

- **In Turkish and Azerbaijani, `i` uppercases to `İ` (with a dot), and `I` lowercases to `ı` (dotless).** Getting this wrong in the wrong domain is, per the Unicode Standard, literally a matter of life and death.

- **A character can answer "yes" to both "are you uppercase?" and "are you lowercase?" at the same time.** U+02BD MODIFIER LETTER REVERSED COMMA (ʽ) is not a cased character, so case mapping leaves it unchanged in both directions — making it simultaneously "uppercase" and "lowercase" under Unicode's definition (3).

- **U+1D34 MODIFIER LETTER CAPITAL H (ᴴ) looks uppercase, has "CAPITAL" in its name, and is actually classified as lowercase.** You cannot determine a character's case from its appearance or its Unicode name.

- **Fonts can contain security vulnerabilities.** They are not "just a bunch of outlines" — font rendering involves complex, executable logic (hinting programs, layout rules), and malformed fonts have been used as attack vectors.

- **The Dutch word "ĳsselmeer" must titlecase as "Ĳsselmeer", not "Ijsselmeer"** — the digraph ĳ titlecases as a single unit. Unicode provides U+0132/U+0133 for this, but most titlecasing implementations get it wrong.

---

## Where It Gets Complicated

### Font Metrics Are Not What You Think

**Font size ≠ visible size.** The specified size (e.g. `16px`) defines an abstract em-square. Type designers fill that square however they like, which is why Georgia and Arial at the same point size look dramatically different in apparent height.

**Font size ≠ line height.** Line height is a separate property. Assuming one determines the other will break your layout.

**The em is not the width of "M".** It's a unit inherited from metal type; the actual M glyph in most fonts is narrower than one em.

**Glyph widths don't add.** Kerning pairs and contextual spacing adjustments mean that measuring individual glyphs and summing them will not give you the width of the composed string. You must measure the whole run.

**Every glyph does not have the same codepoint across fonts.** A glyph at position X in one font may represent a completely different character in another. Icon fonts make this especially treacherous.

---

### Glyphs and Characters Are Not the Same Thing

**One character ≠ one glyph, and one glyph ≠ one character.** A ligature like "fi" is one glyph representing two characters. A character like ǲ (U+01F2 LATIN CAPITAL LETTER D WITH SMALL Z) is one codepoint representing what looks like two glyphs in two different cases simultaneously — it is, in fact, a titlecase character, one of Unicode's three cases (not two).

**You cannot always map a glyph on screen back to a character in source text.** OpenType substitution, ligatures, and contextual alternates can make the glyph-to-character relationship many-to-many.

**Not all text will render in your chosen font.** If a character isn't in the font, the system falls back — but "the system will do the right thing" is optimistic. Fallback behavior varies by OS, browser, and application, and the fallback glyph may come from a font with completely different metrics, breaking your layout.

---

### Case Is Not a Simple Toggle

**Unicode has three cases, not two.** Lowercase, uppercase, and titlecase. Titlecase characters (general category `Lt`) exist to handle pre-composed sequences from legacy encodings that needed special case treatment. Example: ǲ (U+01F2).

**There are three different definitions of "uppercase" and "lowercase" in the Unicode Standard (§4.2):**
1. General category `Lu`/`Ll` — simple but limiting; many "obviously uppercase" characters don't qualify.
2. Derived properties `Uppercase`/`Lowercase` — broader, recommended for most work; used by Python 3's `str.isupper()` and `str.islower()`.
3. Fixed points of `toUpperCase`/`toLowerCase` — comprehensive but counterintuitive; a non-cased character like ʽ answers "yes" to both.

**Most Unicode characters have no case at all.** Cased characters are the minority. Asking whether `?` or `4` is uppercase is a meaningless question, though definition (3) will still give you an answer.

**Case mapping is context-sensitive.** Greek Σ lowercases to σ mid-word and ς at word-end. You cannot implement correct lowercasing with a character-by-character lookup table.

**Case mapping is locale-sensitive.** The `i`/`I` pair behaves differently in Turkish (`tr`) and Azerbaijani (`az`) than in every other locale. The Unicode Standard provides special-case rules for Lithuanian, the Turkic languages, Greek, and some ligatures — but explicitly omits everything else and recommends supplementing with locale-aware rules.

**Case folding is not the same as lowercasing.** The Unicode Standard warns explicitly that a case-folded string is not necessarily lowercase. Cherokee is the canonical example: case folding produces uppercase characters. Case folding exists specifically for case-insensitive comparison, not for display.

**`toLowerCase(toUpperCase(x)) ≠ x` in general.** The ß → SS → ss chain is the textbook example. Case transformation is lossy and non-invertible.

---

### Font Licensing Is a Minefield

**"Free" is not a license.** Fonts that came bundled with your OS almost certainly cannot be freely uploaded to your web server. A desktop license and a web license are different products.

**"Someone else will check the license" is how lawsuits happen.** Font licensing is the responsibility of whoever deploys the font, not whoever bought it or whoever designed the site.

**You are not automatically allowed to subset or modify a font.** Many licenses explicitly prohibit subsetting (removing glyphs) or modification, even for performance optimization.

**WOFF and WOFF2 are container formats, not font formats.** They wrap TrueType or CFF outlines with compression and metadata. A `.ttf` file does not necessarily contain TrueType outlines, and an `.otf` file does not necessarily contain CFF/OpenType outlines.

---

### Rendering Is Complicated and Inconsistent

**Font rendering is not uniformly handled by the OS or the application — it's both, neither, and sometimes something else entirely.** Different browsers on the same OS can render the same font differently. Hinting, antialiasing, and subpixel rendering decisions are made at multiple layers.

**Hinting still matters.** The claim that modern displays have made hinting irrelevant ignores the large installed base of 96dpi screens, Windows ClearType rendering, and small text sizes.

**FOUT (Flash of Unstyled Text) and FOIT (Flash of Invisible Text) are both avoidable** — but neither is the default behavior across all browsers, and writing a `@font-face` rule is not sufficient to control which one you get. You need explicit `font-display` control.

**Fonts cannot always be hosted on a CDN like other static assets.** CORS headers must be set correctly, or browsers will refuse to load cross-origin fonts. This is a common and silent failure mode.

**Faux bold and faux italic are not equivalent to real bold and italic fonts.** The browser synthesizes them by transforming the regular face algorithmically. The result is typographically inferior and metrically different from a purpose-drawn bold or italic.

**Color fonts exist.** The assumption that a font renders in a single foreground color has been false since the introduction of OpenType SVG, COLR, CBDT/CBLK, and sbix font tables.

**Bitmap fonts still exist.** They are used in embedded systems, game consoles, and terminals. Assuming all fonts are vector outlines will break your rendering pipeline in those contexts.

**Icon fonts are a fragile delivery mechanism.** They map icons to Private Use Area codepoints, which means accessibility tools read gibberish, copy-paste produces garbage, and any font substitution breaks the UI entirely.

---

### Case-Insensitive Comparison Deserves Its Own Section

**Do not use `toLowerCase()` or `toUpperCase()` for case-insensitive string comparison.** They are locale-sensitive and non-invertible in ways that will produce wrong answers.

**Use Unicode case folding (`toCaseFold`).** In Python 3, this is `str.casefold()`. The Unicode Standard defines this in §3.13 specifically for comparison purposes.

**For comparing identifiers**, the Unicode Technical Report #36 recommendation is: normalize to NFKC, then apply case folding. In Python: `import unicodedata; unicodedata.normalize('NFKC', s).casefold()`. This still skips some edge cases (Python doesn't expose `XID_Start`/`XID_Continue` filtering or `NFKC_Casefold` directly), but covers the practical security-relevant cases.

**Case folding is not normalization-preserving.** Re-normalize to NFC after folding if you need a normalized result.

---

## If You Build This

1. **Never measure text by summing individual glyph widths.** Use the platform's text-measurement APIs (Canvas `measureText()`, Core Text, DirectWrite, HarfBuzz) on the full string. Kerning and contextual spacing make per-glyph addition wrong.

2. **Specify `font-display` explicitly in every `@font-face` rule.** Without it, FOIT or FOUT behavior is browser-defined. `font-display: swap` gives you FOUT; `optional` avoids layout shift entirely at the cost of possibly not loading the font on slow connections.

3. **For case-insensitive comparison, use case folding — not lowercasing.** In Python 3: `unicodedata.normalize('NFKC', s).casefold()`. In other environments, reach for ICU's `foldCase()`. Never assume `toLowerCase()` is safe for comparison across locales.

4. **Treat font licenses as seriously as software licenses.** Audit separately for desktop use, web embedding, app embedding, server-side rendering, and subsetting rights. The fonts bundled with macOS or Windows are not free for web hosting.

5. **Test your font stack's fallback behavior explicitly.** Remove your web font and check what the fallback renders — its metrics will differ, causing layout reflow. Use `size-adjust`, `ascent-override`, and related `@font-face` descriptors (where supported) to minimize the shift.

6. **Never assume case operations are locale-neutral.** If your system handles Turkish, Azerbaijani, Lithuanian, or Greek text, use a locale-aware case library (ICU, CLDR) rather than your language runtime's default string methods. The `i`/`İ`/`ı` distinction in Turkic locales is the most common way to get this wrong in production.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Fonts (RoelN)](https://github.com/RoelN/Font-Falsehoods) · [archived copy](../archive/typography/01-falsehoods-about-fonts-roeln.md)
- [Truths programmers should know about case (James Bennett)](https://www.b-list.org/weblog/2018/nov/26/case/) · [archived copy](../archive/typography/02-truths-programmers-should-know-about-case-james-be.md)
