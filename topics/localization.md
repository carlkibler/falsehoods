# Falsehoods About Localization

> Translating the strings is the easy 10%. Plurals, dates, money, and word order are the other 90%.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A single English word has no single translation.** "Back" might mean "go back" or "not the front"; "Post" might mean "submit" or "mail"; "file" is a noun or a verb. Hand a translator a bare YAML string and they're guessing — and they'll get some of it wrong.

- **"Two versions for gender" doesn't cover it.** Languages have masculine/feminine, or add neuter (German, Russian, Polish), or go to four (Czech). Adjectives often agree with the noun, so a sentence with two gendered nouns explodes: "Your friend sees your teacher" becomes four sentences in Spanish.

- **Templating one sentence can fork it into many strings.** "Your friend is wearing a `#{garment.color} #{garment.type}`" needs the color to agree with the garment's gender in many languages — so you need a red-for-shirts and a red-for-hats, and the code has to know which.

- **Word order is not universal.** Irish and Welsh are verb-first; Czech and German allow nearly free order. Concatenating `device + "is connected"` is untranslatable to Irish, where the device belongs *between* the words.

- **Plurals aren't one-vs-many.** Languages have between one and six plural forms with different rules. Branching on `n == 1` is an English-only assumption.

- **Short English words are short by luck.** "Post" → "Publish", "food" → German *Lebensmittel* (3x longer), "please" → Irish *le do thoil* (three words). Pixel-perfect buttons and tab bars break.

- **The same number looks wrong in another locale.** `80,763.00` in English is `80.763,00` in German and `80'763.00` in Switzerland. Get the separators backwards and you've off-by-1000'd someone's invoice.

- **Converting a temperature *difference* is not the same as converting a temperature.** The Guardian once turned a 20 °C rise into "68 °F above average" by adding the 32-degree offset that only applies to absolute readings. A 20 °C *change* is 36 °F.

- **Geolocation does not equal language.** A tourist in Portugal who speaks no Portuguese is a counterexample. You can guess once; you must let users choose.

## Where It Gets Complicated

### "Sentences in all languages template like English: {user} is in {location}."

They don't, and the breakage isn't only about gender. The preposition itself can change shape based on what follows it, and the location word can need a different form than your database stores.

- Czech: *v koupelně* "in the bathroom" but *ve sklepě* "in the basement" — the "in" itself changes.
- Czech placenames flip the preposition entirely: *v Čechách* "in Bohemia" vs *na Moravě* "in Moravia" (literally "on").
- The article can fuse with the preposition: German *der Vatikan* → *im Vatikan*; Irish *an Vatacáin* → *sa Vatacáin*.
- The slot value needs inflecting: Czech *Praha* "Prague" → *v Praze*; Irish *fillteán* "folder" → *i bhfillteán* (initial consonant mutates).

Even the supposedly safe `#{user.name}` is fraught. In Russian a past-tense verb agrees with the subject's gender, so "`#{user.name}` liked your post" needs two translations of "liked" depending on who liked it.

### "Pluralization is just singular vs plural."

English has two forms; many languages have more, with rules that don't map to "is n equal to 1." CLDR catalogs categories like *zero, one, two, few, many, other*, and a language can use up to six of them with thresholds you'd never guess (Polish treats 2–4 differently from 5–21). You cannot get this right with an `if (count == 1)` and string concatenation. Use a plural-category API and let the data decide which form fires.

### "Two genders, or one, are the only options — and gender only affects nouns."

Wrong on both counts. German, Icelandic, Russian, and Polish have three grammatical genders; Czech has four. And gender doesn't stay put on the noun: adjectives agree with it, and (in Russian) past-tense verbs agree with the subject. The "garment color" case is the canonical trap — a red shirt and a red hat use different forms of "red" because *shirt* and *hat* have different genders. With two gendered slots in one sentence you get a combinatorial fan-out before you've even left the two-gender languages.

### "Concatenating UI fragments is fine if the pieces are translated."

It is not, because the pieces have to move. "`{device}` is connected" is translatable; `device + " is connected"` is not, because Irish needs the subject wedged into the middle of the verb phrase. Any glued-together string assumes English word order and freezes it. Build whole-sentence templates with named placeholders the translator can reorder freely (`"%1 since %2"`), never string-plus-string.

### "Text is roughly the same length in any language."

Translations tend to run *longer* than the original, not equal — partly because the translator is constrained by the source author's choices. German compounds (*Lebensmittel*), Irish multi-word phrases (*le do thoil* for "please"), Czech *zastávka autobusu* for "bus stop" all blow past their English counterparts. Horizontal layouts — menus, tabs, fixed-width buttons — are where this surfaces first. Design for expansion (commonly +30–50%) and let containers grow.

### "Dates, numbers, and currency format the same everywhere."

They vary by *locale*, not just language:

- Decimal/thousands separators swap: English `80,763.00`, German `80.763,00`, Swiss `80'763.00`.
- Ordinals are English-specific: "3rd of May" is *3. Mai* in German, *3 мая* (no punctuation) in Russian.
- Temperature carries a units-vs-delta hazard: 20 °C is 68 °F as a reading, 36 °F as a difference, and "minus 20 °C" is "minus 4 °F." Converting requires knowing which one you have.

Don't hand-roll any of this. Format numbers, dates, and money through a locale-aware formatter, and pass the *quantity plus its semantic role*, not a pre-formatted string.

### "Locale detection is reliable; one country, one language."

Geolocation is a first guess at best — the holidaymaker abroad breaks it. And the country↔language mapping is many-to-many: Switzerland has four national languages, Canada two, Belgium two or three; German is "national" in Germany, Austria, Switzerland, and Luxembourg. Even `en` splinters into `en-US`, `en-GB`, `en-CA` with different spelling, dates, and number formats. Detect as a default, then let the user pick and remember the choice. Also: country flags are not language symbols, and pun-based emoji (🔑 for "key importance", 🤞 for "good luck") don't carry across cultures.

### "Sorting Latin-script text is the same A–Z everywhere."

The base order matches; the extra characters don't. Swedish sorts *Ä* after *Z*; German sorts *Ä* as if it were *AE*, so *München* lands between *Mud* and *Muf*. Naive byte or codepoint sorting produces an order that looks broken to a native speaker. Use a locale-aware collator (ICU) and pass the locale.

## If You Build This

- **Use ICU/CLDR through a real i18n library** (ICU MessageFormat, FormatJS/`react-intl`, gettext, Fluent). It already encodes plural categories, gender selection, number/date/currency formats, and collation per locale. Don't reinvent any of it.
- **Never concatenate translated fragments.** Make the whole sentence the translatable unit and use named, reorderable placeholders (`{device} is connected`, `%1 since %2`) so translators can move them where the grammar needs them.
- **Use plural-category and gender-select APIs**, not `if (n == 1)` or two hand-written variants. Let the locale data choose among *zero/one/two/few/many/other* and among gender forms.
- **Give translators context.** A bare word ("Post", "file", "open") is a coin flip. Supply screenshots, comments, the part of speech, and the list of possible values for each slot — that's how the *garment.color/garment.type* agreement gets resolved.
- **Don't hardcode locale formatting.** Route every number, date, currency, and sort through locale-aware formatters and collators. For temperature, track whether a value is an absolute reading or a delta before converting.
- **Detect, then defer to the user.** Geolocation and `Accept-Language` are starting guesses; offer an explicit language picker, persist it, and never use a flag to stand in for a language. Plan layouts for text expansion and RTL mirroring from the start — in a proper Arabic UI, the whole interface flows right-to-left, not just the text.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Language (Ben Hamill)](http://garbled.benhamill.com/2017/04/18/falsehoods-programmers-believe-about-language) · [archived copy](../archive/localization/01-falsehoods-about-language-ben-hamill.md)
- [Falsehoods about Languages (Lexiconista)](https://www.lexiconista.com/falsehoods-about-languages/) · [archived copy](../archive/localization/02-falsehoods-about-languages-lexiconista.md)
- [Localization Failure: Temperature is Hard (Bruce Dawson)](https://randomascii.wordpress.com/2023/10/17/localization-failure-temperature-is-hard/) · [archived copy](../archive/localization/03-localization-failure-temperature-is-hard-bruce-daw.md)
