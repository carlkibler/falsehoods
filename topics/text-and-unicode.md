# Falsehoods About Text and Unicode

> Unicode is not a character set, a character is not a code point, and string length is a lie.

## The Big Surprises

- **There ain't no such thing as plain text.** A string of bytes is meaningless until you know its encoding. The classic symptom: an email from your friends in Bulgaria arrives as `???? ?????? ??? ????`, or an American résumé sent to Israel turns up as `r sum s` because code point 130 is `é` on one machine and the Hebrew letter Gimel on another.

- **Unicode is not 16 bits, and was never "two bytes per character."** This is the single most common myth. The original UCS-2 plan assumed 65,536 characters would be enough for everyone; it wasn't, so since Unicode 2.0 (1996) UTF-16 encodes higher code points as four-byte surrogate pairs. The largest legal code point is U+10FFFF (1,114,112 total).

- **Unicode is not an encoding.** It's a standard that *includes* encodings (UTF-8, UTF-16, UTF-32) plus case mapping, character categories, the bidirectional algorithm, collation, and more. "The output file is encoded in Unicode" is a meaningless sentence — say UTF-8.

- **String length is not one number — it's about six.** The face-palm emoji `🤦🏼‍♂️` has length 17 in Rust (UTF-8 bytes), 7 in JavaScript (UTF-16 code units), 5 in Python (code points), and 1 in Swift (grapheme clusters). All are "correct"; they answer different questions.

- **A character is not a code point.** "é" can be two code points (`e` + combining accent). The flag `🇺🇸` is two code points (🇺 + 🇸). The name "मनीष" looks like three characters but is four code points. Code points have no intrinsic, cross-language meaning.

- **Equal-looking strings are not byte-equal.** "É" precomposed (U+00C9) and "É" decomposed (U+0045 U+0301) render identically but compare unequal until you normalize (NFC/NFD). In Python, `"É".startswith("E")` can be `True` or `False` depending on form.

- **Uppercase is not the inverse of lowercase.** German `ß` uppercases to `SS` (two characters); the Kelvin sign `K` (U+212A) lowercases to ordinary `k`. A real GitHub security bug in 2016 let an attacker hijack password-recovery email via an address that *normalized* to the victim's.

- **`toLowerCase()` is locale-dependent and will betray you.** In Java, `"IT".toLowerCase()` becomes `"ıt"` on a Turkish system because Turkish has dotless `ı`. Use `Locale.ROOT` explicitly.

- **One code point can be a whole phrase.** U+FDFA is a single code point that decomposes to 18 characters (an Arabic phrase, "may God honor him and grant him peace"). U+FDFD would decompose to ~35 if it were allowed to.

- **You don't need to index by code point — ever.** O(1) code-point indexing is a feature in search of a use. For slicing, UTF-8 byte indices work fine: the encoding guarantees you can always tell if a byte is a code-point boundary, and no code point is a subslice of another.

## Where It Gets Complicated

### Encodings and the byte/code-unit/code-point/grapheme confusion

In the beginning was ASCII, where byte = code unit = code point = grapheme, all called "character." Then all four diverged but kept the name, and confusion reigned. Languages disagree on what `char`/length means:

- **Bytes:** C, C++, Go, Lua, PHP, Ruby
- **UTF-16 code units:** C#, Java, JavaScript, Objective-C, old "narrow" Python builds, Visual Basic
- **Code points:** Perl 5, Python 3.3+, R
- **Graphemes:** Perl 6, Swift

Two-byte code-unit strings are insidious: almost everything is one code unit, so counter-examples (`'🐛'.length === 2` in JS) are rarely hit until production. Databases vary too, so a `VARCHAR` limit may count differently than your language's length function.

UTF-16 itself is "a hack to add variable-length encoding to UCS-2" so Java/JavaScript/Windows wouldn't need redesigning. It reserved two ranges of 1,024 surrogates each to encode 1,048,576 extra characters as pairs. That hack spawned a zoo of malformed-string bugs: out-of-range code points, truncated characters (a high surrogate with no low surrogate), decapitated characters (lone low surrogate), surrogates leaking into non-UTF-16 output, and overlong UTF-8 encodings. Many weren't illegal in the original specs, so broken implementations spread and got documented and named (e.g. CESU-8, WTF-8).

UTF-8 is the right default. UTF-7 keeps the high bit clear for draconian email systems; UCS-4/UTF-32 wastes four bytes per code point. The byte-order mark (FE FF / FF FE) exists only because early implementors stored two-byte code units in either endianness.

### "UTF-8 is unfair to CJK"

ASCII is one byte in UTF-8 vs. two in UTF-16; most CJK is three bytes vs. two. But the big consumer of a universal encoding is the web, and even CJK HTML is mostly ASCII tags. CJK languages also pack more meaning per character. See "UTF-8 Everywhere."

### You cannot guess or detect an encoding

There are dozens of encodings mapping the same bits to different characters; ~95% of encoding bugs are decoding with the wrong one, producing *mojibake*. Plain text contains no statement of its encoding (rich formats like HTML/PDF/Word should, and sometimes do). 100% reliable charset detection is impossible in principle and impractical in practice. Internet Explorer famously guessed by letter-frequency histograms and would declare a Bulgarian page to be Korean. Don't open files "without an encoding" — you're really using a hidden OS/runtime default, which corrupts files moved between machines. Set encoding explicitly.

### Databases have encodings too

Text in a database is not encoding-free, doesn't automatically match the rest of the system, and a single database may not use one encoding throughout. Access libraries usually encode/decode transparently; trouble strikes when app and DB encodings disagree, or a low-level programmer assumes they match.

### Normalization is mandatory

Because Unicode's prime directive is lossless round-tripping with *every* legacy charset — some of which precompose `ñ` and some of which use `n` + combining tilde — the same character often has multiple encodings. Skip normalization and you get: identical-looking strings sorting to different places, de-dup that misses duplicates, search that finds some matches but not others. Convert everything entering your system to a canonical form (NFC or NFD).

Edge cases pile up:
- **Strings of different lengths can be equal:** `Á` (U+00C1) vs. `Á` (U+0041 U+0301).
- **Part order varies:** `Ą́` can be U+0041 U+0328 U+0301 *or* U+0041 U+0301 U+0328.
- **Case changes can de-normalize:** `ǰ̣` uppercases to a form whose canonical order differs; ancient Greek's iota subscript (`ᾷ`) is another trap. Normalize, then change case, then maybe re-normalize.
- **Concatenating two normalized strings isn't always normalized** — but only the join boundary needs fixing.

NFKC/NFKD go further, collapsing compatibility variants: `①` → `1`, the `ﬃ` ligature → `ffi`. But compatibility normalization does **not** merge look-alikes from the same script (`1iIlL`, `oO0`) or identical glyphs across scripts: Latin `O` (U+004F), Cyrillic `О` (U+041E), and Greek `Ο` (U+039F) stay distinct, as do `Ω`/Ω-sign and `Å`/Ångström-sign.

### Case is not a tidy two-state toggle

There are three cases, not two: upper, lower, and **title** (for ligatures, first letter up). Many scripts are unicase with no case at all. There's no clean one-to-one upper↔lower map (`ß` → `SS` breaks "this fits back in the database"; Greek `Σ` lowercases to `ς` word-finally, `σ` elsewhere). Superscripts/subscripts are all officially lowercase even when they look uppercase. Roman numerals, circled letters, and other non-letters have case too.

For case-insensitive comparison, neither `lower(a)==lower(b)` nor `upper(a)==upper(b)` is correct: `lower("ss") != lower("ß")` but `upper("ss") == upper("ß")`; conversely `upper("K") != upper("K")` (Kelvin) but `lower("K") == lower("k")`. Use Unicode **case folding**: `casefold("ß") == casefold("ss")`.

### Locale governs almost everything

A "hidden global variable" as dangerous as the default encoding. The same operations need a locale:

- **Case:** the Turkish/Azeri dotted-`İ`/dotless-`ı` rules, Lithuanian's accented `i`/`j`.
- **Sorting:** German sorts `ä/ö/ü` as the bare vowel (dictionaries) or as `ae/oe/ue` (phone books); Swedish puts `Ä Ö` after `Z` while German puts them with `A O`; `æ` sorts near `a` in French but like `a` in Swedish; French needs whole-word comparison (`cote < côte < coté < côté`); Chinese is often sorted phonetically, and the same character's reading varies by context. Code-point order is arbitrary and fine only as a map/set key or for known-ASCII.
- **Splitting into characters:** Czech/Slovak `ch`, Dutch `ij`, Tagalog `ng` are single units that must not be split.
- **Splitting into words:** some languages use no spaces; English treats contractions as one word, French as two; Early Modern English and Swedish used colons in contractions.
- **Line-breaking:** where hyphens are allowed differs (en-GB stricter than en-US); East Asian text breaks between almost any character; Korean breaks differently in formal vs. informal text. And "resort" vs. "re-sort" shows you can't blindly drop hyphens.
- **Quoting and punctuation:** a bewildering number of quotation marks and conventions; French inserts narrow non-breaking spaces before `: ? ! «»`.

Don't trust default `<`/`==`: `bird < Bird < birds`, `"page 2" < "page 10"` (numeric vs. lexicographic) all need real collation. Use the **Unicode Collation Algorithm** with **CLDR** tailorings.

### Code points are weirder than they look

- **A code point may represent nothing, or many things:** control codes, surrogate halves, BOMs, designated non-characters; three control codes (80, 81, 99) were in a draft, rejected, escaped into the wild, and are now stuck forever.
- **A code point can be ambiguous:** typewriter-era merges left U+002D doing duty for hyphen/dash/minus, U+0027 for apostrophe and single quotes, U+0022 for both double quotes. Treating an apostrophe as a quote (or hyphen as minus) causes real bugs.
- **Different code points can be the "same" character:** Ω/Ohm-sign, Å/Ångström-sign, `;`/Greek question mark (U+037E) — same glyph, encoded differently by usage.
- **There is no name for every code point.** Most of the 17 planes are unassigned; planes 4–13 are entirely empty. Private Use Areas (137,468 code points, e.g. Font Awesome icons) have no names — their meaning is defined by whoever produced them.
- **Code points aren't one column wide.** They bunch into characters; `ﷺ`/`﷽` (U+FDFD) can render ~12 columns wide. Querying the font is the only reliable way, and even "fixed-width" fonts give CJK ideographs two columns (East Asian width).
- **Editing operates on grapheme clusters, not code points.** Selection grabs whole clusters; backspace decomposes by typing-history heuristics (it'll peel an accent off a letter, but delete `🇺🇸` whole). The Hangul string `ᄀᄀᄀ각ᆨᆨ` renders as no single glyph yet behaves as one selectable unit everywhere.

### Grapheme clusters are the closest thing to "character"

A grapheme cluster (UAX #29's programmatic stand-in for "user-perceived character") is what you usually mean by "character." Brahmic scripts attach vowels to consonants; Korean composes syllable blocks; emoji combine via ZWJ (`👨‍👨‍👧‍👧`). Swift makes the grapheme cluster its default `Character` and indexes strings by it — great for correctness, but as a basis for *algorithmic* indexing it's risky.

Why grapheme indices are not durable: the segmentation algorithm depends on character properties, which depend on the Unicode database *version*, which ships a new release every year. Store a grapheme index today, reload it next year on an upgraded toolchain, and it may point somewhere else — a trivially imaginable security exploit.

### "My language is Unicode-aware, so I'm fine"

Unicode-aware encodings killed the one-byte-per-character myth but not the one-code-point-per-character myth.

- **Python**'s code-point-array semantics don't mean UTF-32 internally; it optimizes all-ASCII and BMP-only strings to one or two bytes.
- **JavaScript** (V8/SpiderMonkey) special-cases ASCII despite UTF-16 semantics.
- **Go** strings are UTF-8 *by convention* but may hold invalid UTF-8 — don't feed them to a strict UTF-8 API unchecked.
- **Rust** strings are *enforced* UTF-8: `String::from_utf8` validates in linear time and can fail; the constant-time `from_utf8_unchecked` is `unsafe`. Rust's `char` is a code point and the stdlib has no grapheme awareness (use the `unicode-segmentation` crate).
- Even **`\d` in regex** isn't `[0-9]` in many languages (Python, Perl, Rust, ripgrep): it matches Unicode category Nd, including Arabic `٣`, Devanagari `६`, math `𝟙`. Likewise `\w`/`\p{L}` match accented and non-Latin letters, and `\p{L}` (General_Category) differs subtly from `\p{Alphabetic}` (a boolean property) — categories partition code points and dump edge cases into one bucket, while boolean properties catch everything that "looks remotely like" what you want.

### Writing systems break Latin assumptions

- The Latin alphabet isn't 26 letters once you count case, accents (`á ç ñ`), variants (`ø ł đ`), ligatures (`æ œ`), digraphs/trigraphs, and borrowed letters like Icelandic thorn `þ`. English itself keeps accents in "résumé," diaeresis in "coöperate," grave in "learnèd."
- Alphabets differ and change: `ñ` is a distinct Spanish letter, Welsh has seven digraph letters, Hungarian has `dzs`; Swedish puts variants at the end; Estonian puts `Z` between `S` and `T`; Hawaiian lists vowels first; capital `ẞ` joined German officially in 2017.
- Not all writing systems are alphabets or small: syllabaries have 50–500 symbols; logographic systems (Chinese, Egyptian, Mayan) are *open*, inventing new characters continuously, with tens of thousands of entries.
- One language, multiple scripts (Serbian/Azeri Cyrillic-or-Latin, Uzbek three ways, Hindi/Urdu = one language split by Devanagari vs. Arabic). Mutually unintelligible spoken "Chinese" languages share one writing system. One text mixes scripts: Japanese uses kanji + hiragana + katakana + Latin at once.
- Text isn't always left-to-right top-to-bottom: Arabic/Hebrew are RTL, traditional CJK is vertical RTL, Mongolian is vertical LTR, and quoted text keeps its native direction inside the host text. Even in RTL scripts, digits read left-to-right (math notation is effectively its own logographic system).

### Unicode is neither purely visual nor purely semantic, nor elegant

It contains invisible semantic-only characters (the invisible times in `a⁢b` that screen readers voice as "a times b"). Yet it also refuses to encode every semantic nuance: Roman numerals are just Latin letters, and there's no dedicated curved apostrophe — the apostrophe shares a glyph with the closing single quote. And it's not elegant by design: to meet its round-trip goal it absorbed the flaws and incompatible principles of every prior encoding, producing a combinatorial mess. "Really, it's a little surprising that Unicode usually just works."

## If You Build This

- **Always declare encodings explicitly.** Use UTF-8 everywhere — files, network, databases, HTTP headers, the HTML `<meta charset>`. Never open a file "without an encoding" (you're using a hidden default) and never guess or auto-detect one.
- **Normalize all input on the way in.** Pick NFC (usually) and normalize before you compare, sort, de-dup, or store. For comparison and equality, normalize *and* apply Unicode **case folding** — never `lower(a)==lower(b)`.
- **Use real Unicode algorithms, not ad-hoc code.** The Unicode Collation Algorithm + CLDR tailorings for sorting/searching, UAX #29 grapheme segmentation for "characters," and locale-aware case mapping (pass an explicit locale; default to `Locale.ROOT` when you want stability).
- **Index strings by bytes, slice on UTF-8 boundaries.** You never need O(1) code-point indexing. Don't persist grapheme-cluster indices across Unicode-version upgrades.
- **Pick the right "length" for the job:** bytes for storage limits and packets, grapheme clusters for visual length (approximate), and never code points for either.
- **Assume nothing about characters:** not 26 letters, not one code point each, not one column wide, not one byte or two bytes, not LTR, not case-symmetric, not safely matchable with `[a-zA-Z]` or `[0-9]`. Support characters outside the BMP — that's where the emoji and math symbols live. A Unicode-aware language helps, but it does not let you stop thinking.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [The Absolute Minimum About Unicode (Joel Spolsky)](https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/) · [archived copy](../archive/text-and-unicode/01-the-absolute-minimum-about-unicode-joel-spolsky.md)
- [Falsehoods about Plain Text (Jeremy Hussell)](https://jeremyhussell.blogspot.com/2017/11/falsehoods-programmers-believe-about.html) · [archived copy](../archive/text-and-unicode/02-falsehoods-about-plain-text-jeremy-hussell.md)
- [Unicode Misconceptions (Jean Abou Samra)](https://jean.abou-samra.fr/blog/unicode-misconceptions/) · [archived copy](../archive/text-and-unicode/03-unicode-misconceptions-jean-abou-samra.md)
- [Let's Stop Ascribing Meaning to Code Points (Manish Goregaokar)](https://manishearth.github.io/blog/2017/01/14/stop-ascribing-meaning-to-unicode-code-points/) · [archived copy](../archive/text-and-unicode/04-let-s-stop-ascribing-meaning-to-code-points-manish.md)
