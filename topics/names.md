# Falsehoods About Names

> Your name model is wrong, and it's wrong in ways that hurt real people.

## The Big Surprises

- **"Null" is a perfectly valid legal surname — and it breaks systems at Bank of America, American Express, and countless others.** Christopher Null, a technology journalist, spent *years* in a cordial email battle with Bank of America because the string "null" in his email address caused their systems to reject, loop, or crash. American Express regularly sent mail to his company addressed only to "Mr." — dropping the surname entirely because it evaluated to nothing.

- **Nearly 40% of Vietnamese people share the surname Nguyễn.** About 20% of South Koreans are named Kim. More than 10% of northern China shares the surname Wang. The Chinese name Zhang Wei is shared by over a quarter of a million people. Uniqueness is not a property of names.

- **Björk has no last name in any meaningful Western sense.** Her second name, Guðmundsdóttir, means "daughter of Guðmundur" — it's a patronymic, not a family name. Her father is Guðmundur Gunnarsson ("son of Gunnar"). Icelandic phone directories are sorted by *given* name. Calling her "Ms. Guðmundsdóttir" would be bizarre.

- **Picasso's full legal name was 23 words long.** "Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso." Your 30-character name field is not going to cut it.

- **Patrick McKenzie — who wrote the canonical post on this topic — has six different valid "full" names, and most systems he encounters accept precisely none of them.** He has lived in Japan for years and has personally broken many systems simply by being entered into them.

- **The Japanese family name 東海林 can be pronounced either Tōkairin or Shōji.** Four completely different kanji combinations — 庄司, 庄子, 東海林, 小路 — all romanize to "Shōji." You cannot reliably sort or look up Japanese names without a separate phonetic field.

- **In the Netherlands, Vincent van Gogh is sorted under G (for Gogh); in Belgium, the same name is sorted under V (for van Gogh).** There is no single correct ordering for names, even within Europe.

- **There are cultures where nobody has a last name at all.** The Indonesian presidents Suharto and Sukarno had exactly one name each. In parts of Southern India, Malaysia, and Indonesia, mononyms are common enough that requiring a surname field produces a flood of garbage data like "." or "Mr." entered just to escape the form.

- **Jennifer 8. Lee has the numeral 8 as her legal middle name**, chosen because 8 is associated with good fortune. Your alphanumeric validation just rejected a real person's real name.

- **Some people have no name at all — or at least not one your system can capture.** There is a documented isolated culture in which people used no personal names, referring to everyone by relational terms ("my mother's eldest sister"). And some languages have no associated writing system, making any Unicode representation impossible.

## Where It Gets Complicated

### Structure and Order

The assumption that names go given-name-then-family-name is a Western quirk, not a universal law. Chinese, Japanese, Korean, and Hungarian names are written family-name-first. In the name 毛泽东 (Mao Ze Dong), Mao is the family name. The middle character, Ze, is a generational name shared by all siblings — including 毛泽民 (Mao Ze Min) and 毛泽覃 (Mao Ze Tan). On familiar terms you'd use "Ze Dong," not just "Dong."

Vietnamese names like Nguyễn Tấn Dũng follow family-middle-given order, but even formally, this Prime Minister is addressed as *Mr. Dũng*, not *Mr. Nguyễn* — the opposite of the Chinese convention for the same surface structure.

The Kerala name Velikkakathu Sankaran Achuthanandan follows the order village-father's name-given name, typically abbreviated to V. S. Achuthanandan. The Rajasthani name Aditya Pratap Singh Chauhan encodes given name, father's name, surname, and caste name. The Arabic name Abu Karim Muhammad al-Jamil ibn Nidal ibn Abdulaziz al-Filistini translates as "Father of Karim, Muhammad, The Beautiful, Son of Nidal, Son of Abdulaziz, the Palestinian" — a genealogy, not a name in any Western sense.

### How Many Names?

The assumption that names have a fixed number of parts — typically two or three — fails immediately:

- A Portuguese name may include one or two given names and up to four surnames (up to six for a married woman), which may themselves be phrases: *da Silva*, *dos Santos*, *Costa e Silva*.
- Brazilians may have three or four family names: José Eduardo Santos Tavares Melo Silva is a real example.
- Spanish names typically follow paternal+maternal order; Portuguese Brazilian names follow maternal+paternal. Both can include connectors like *de* or *e*.
- Some people have no middle name. Others have many. Harry S Truman's middle name was literally just the letter S — not an initial for anything. U Thant had a single-letter given name.
- John Wyndham Parkes Lucas Beynon Harris published under John Beynon, Lucas Parkes, and John Wyndham — all simultaneously valid names for the same person.

### Names That Change — and When

Names change at marriage, obviously, but also:

- At Catholic confirmation (an extra middle name is added).
- When converting to a religion: Cat Stevens became Yusuf Islam; Cassius Clay became Muhammad Ali.
- To avert bad luck — a practice documented in Thailand that requires no recognized life event at all.
- When someone with the same name becomes famous or infamous (people changed their surname from Hitler).
- In Norway, you can change your full name to anything, at any time, for free.

And names aren't always assigned at birth. Scotland allows at least 3 weeks before registration; Australia allows at least 2 months. Some birth registrations still use "Baby Boy" or "Baby Girl." In some cultures, an adult name isn't chosen until puberty — before that, a child may have only a "milk name." Jewish children are traditionally unnamed for the first 8 days of life.

### The Same Person, Different Names Everywhere

Two systems holding data about the same person will almost certainly use different name strings. Tony Rogers (the author who documented these examples) appears in some systems with his middle name, in others without, and in others with a nickname. His wife appears under her maiden name in some systems, married name in others, with or without a middle name, and with two different spellings of her nickname. This is not an edge case — it's the normal state of affairs, and it's why an entire software category exists to reconcile identity databases.

Two different data entry operators hearing the same name over the phone will not produce the same string. Consider Thomson vs. Thompson; Johnson vs. Johnston vs. Johnstone vs. Jonsson. The problem compounds with transliteration: the Chinese character 周 appears in systems as Chow (Cantonese romanization), Chou (Wade-Giles), and Zhou (Hanyu Pinyin) — same name, three different strings, none of them wrong.

### Prefixes, Suffixes, and the Parts You Think You Can Drop

You cannot safely ignore particles and affixes:

- **Pieter van der Meer ≠ Pieter Meer.** The Dutch particle is part of the name.
- **Robert Downey Junior ≠ Robert Downey.** Drop "Junior" and you're referring to his father.
- **Taj al-Din** ("crown of the faith") is not the same name as Taj. The suffix *al-Din* is meaningful.
- **di Stefano** is not the same as Stefano.
- A Spanish woman with the surname *viuda de de la Cruz* is identified as the widow of a man with the patronym *de la Cruz*. Stripping the prefix changes her identity.
- Capitalization of particles is context-dependent: *van der Meer* with a given name present, but *Van der Meer* standing alone. The Dutch sort this under G (Gogh); Belgians sort it under V.

The Irish/British surname *ffrench* is conventionally written entirely in lowercase — and is being slowly destroyed by software that auto-capitalizes it.

### Case: Neither Fully Sensitive Nor Fully Insensitive

Chinese and Japanese have no concept of uppercase or lowercase — the entire case axis doesn't apply. Latin script is case-sensitive, but the rules are not "capitalize the first letter of each word":

- *McNamara* and *MacKenzie* require internal capitals.
- *van Gogh*, *du Barry*, *da Costa*, *O'Brien*, *D'Agostino* all have specific, meaningful capitalization.
- *Jean-Pierre* is a single given name (hyphenated). *Jean Pierre* is two given names. *Jeanpierre* is something else entirely.
- Some characters are accented in lowercase but not in uppercase, making round-tripping from lower to upper and back impossible.
- In French-speaking countries, writing a surname in ALL CAPS to distinguish it from the given name is a convention that has hardened into etiquette — rendering it in mixed case may be considered impolite.
- e e cummings and k d lang preferred their names in all lowercase. The tradition may be disputed for cummings, but the *expectation* that names follow standard capitalization rules is still wrong.

### Character Encoding

ASCII excludes accented Latin characters used in French and Portuguese. It excludes Greek, Cyrillic, Devanagari, Hanzi, Kanji, Hangul, and hundreds of other scripts. Even the name *Zoë* requires non-ASCII characters.

Unicode covers the vast majority of scripts but not all. Aymara — spoken by over a million people in South America — has a script not yet fully covered. Some Chinese and Japanese characters used in names are not in Unicode. The symbol Prince adopted as his name has no Unicode code point. Some languages have no writing system at all, making any encoding a lossy approximation.

People also mix scripts within a single name: Kanji combined with Latin characters, or Hanzi combined with Latin, often because the person adopted a "Western given name" for those unable to pronounce their native name. A Japanese name may require three separate fields: ideographic form (Kanji), phonetic form (Hiragana or Katakana), and Latin romanization.

A four-character Japanese name in UTF-8 requires 12 bytes, not 4. Size your columns accordingly.

### Uniqueness and Filtering

Names are not unique. They are not almost unique. They are not even close. Beyond the statistics above (Kim, Wang, Nguyen), even moderately uncommon names collide: Tony Rogers discovered a person with the same name working in the same industry in the same country.

The "bad words" filter problem is real and cuts both ways: words that are profane in one language are ordinary names in another, and some names happen to be reserved strings in programming languages. "Null" is the canonical example, but it is not the only one. Filtering on a dictionary of bad words will, with certainty, reject someone's legitimate name.

### Formality and Honorifics

Addressing someone by their given name on first contact is friendly in Silicon Valley and potentially rude in the UK, where it implies prior acquaintance. In Germany, *Herr Schmidt* may need to be *Herr Professor Doktor Schmidt*. In Japan, *Tanaka-san* is baseline polite; a department head named Tanaka is *Tanaka-buchō*. In Vietnam, the Prime Minister Nguyễn Tấn Dũng is formally addressed as *Mr. Dũng* — his given name — not *Mr. Nguyễn*.

Titles also reveal marital status for women (*Miss/Mrs./Ms.*) but not for men — a structural asymmetry worth examining before you make a title field mandatory. And "maiden name" assumes gender; "previous name" does not.

---

## If You Build This

1. **Use a single free-text "full name" field wherever possible.** The moment you split into "first" and "last," you've made a cultural assumption that will be wrong for a significant fraction of your users. If you must split, label fields "given name" and "family name" — never "first name" and "last name" — and make the family name field optional.

2. **Add a "how would you like to be addressed?" field** rather than constructing a salutation algorithmically. You cannot reliably extract a given name from a full name across cultures. Just ask. This also sidesteps the formality problem: some users want "Dear María José," others want "Dear Ms. Carreño Quiñones," and no algorithm gets this right.

3. **Store names in UTF-8 throughout your entire stack** — forms, APIs, databases, logs, email templates. A name like Björk Guðmundsdóttir or 毛泽东 must survive every hop without corruption. Size your database columns for Unicode: a 4-character Japanese name needs 12 bytes in UTF-8, not 4.

4. **Never run a name through a reserved-word filter, a bad-word list, or a NULL check.** Christopher Null's last name will fail all three. Test your system by entering "Null," "O'Brien," "van der Meer," "María José," "田中太郎," and a 100-character string before you ship.

5. **Do not normalize case.** Do not auto-capitalize. Store exactly what the user typed. *ffrench* is lowercase. *McNamara* has an internal capital. *van der Meer* is lowercase when a given name precedes it and capitalized when it stands alone. You cannot reconstruct this from a rule.

6. **Read the W3C guidance at https://www.w3.org/International/questions/qa-personal-names** before finalizing any name-handling design. For Japanese name systems specifically, plan for a separate phonetic field (kana) — you cannot sort or look up ideographic names without knowing how they are pronounced, and there is no algorithm that reliably provides this.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Names (Patrick McKenzie)](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/) · [archived copy](../archive/names/01-falsehoods-about-names-patrick-mckenzie.md)
- [Falsehoods about Names — With Examples (Shine Solutions)](https://shinesolutions.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/) · [archived copy](../archive/names/02-falsehoods-about-names-with-examples-shine-solutio.md)
- [Personal Names Around the World (W3C)](https://www.w3.org/International/questions/qa-personal-names) · [archived copy](../archive/names/03-personal-names-around-the-world-w3c.md)
- [Mr. Null — My Name Makes Me Invisible to Computers (WIRED)](https://www.wired.com/2015/11/null/) · [archived copy](../archive/names/04-mr-null-my-name-makes-me-invisible-to-computers-wi.md)
