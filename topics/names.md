# Falsehoods About Names

> Your name model is wrong, and it's wrong in ways that hurt real people.

## The Big Surprises

- **Some people have no name at all.** It is not universally true that every human possesses a name — there are real individuals for whom the concept simply does not apply, and any required "name" field instantly breaks.

- **"First name" and "last name" are meaningless concepts in entire countries.** In Iceland, telephone directories sort by given name because there are no inherited family names — only patronymics like Björk Guðmundsdóttir — while in parts of Indonesia and Malaysia many people have a single given name and nothing else.

- **A person's legal surname can be a system-killing reserved word.** Technology journalist Christopher Null has spent years battling forms that reject his last name as empty data; Bank of America once blacklisted his entire nullmedia.com domain after a system upgrade, and American Express routinely addresses him as simply "Mr." after dropping "Null" from the label.

- **The same written name can be pronounced completely differently even by native speakers.** The Japanese name 東海林賢蔵 might be read as Tōkairin or Shōji, and four distinct kanji combinations can all be romanized as Shōji — making sorting and search impossible without a separate phonetic field.

- **Marriage does not create a shared family name, and "maiden name" is a parochial assumption.** In Hispanic naming, a couple may be Padilla de Pérez and Pérez Quiñones while their children are Pérez Padilla; in China, wives keeping their own name is standard, and men sometimes take their wife's name too.

- **There is no such thing as a single "canonical" full name — including yours.** Patrick McKenzie acknowledges six different full names as correct, and John Graham-Cumming's system once rejected his last name for containing "invalid characters" that were, in fact, perfectly valid.

- **Millions of people can share the exact same name, and it is not a database edge case.** The assumption that names are "almost globally unique" collapses immediately in places like Vietnam, where Nguyễn is extraordinarily common, and no amount of additional fields fixes the collision problem.

## Where It Gets Complicated

### Names Are Not Fixed, Singular, or Atomic

People do not have exactly one canonical full name. Patrick McKenzie will acknowledge as correct any of six different "full" names, and he has broken every professional system he has been introduced to. You also cannot assume a person has exactly one name they go by, or exactly N names for any value of N — some have one, some have many, and some have no name at all.

Names change, but not only at the enumerated events you might expect (marriage, divorce, legal petition). They are not necessarily assigned at birth, or within a year, or within five. The assumption that everyone receives a name shortly after being born is simply wrong.

The idea that people have a "first name" and "last name" that are different by necessity fails globally. In China, Japan, Korea, and Hungary, the family name comes first: in 毛泽东, Mao is the family name and Ze Dong is the given name, with Ze being a generational name shared by his siblings (毛泽民, 毛泽覃, 毛泽紅). Spanish-speaking people commonly carry two family names, as in María José Carreño Quiñones; Brazilians may carry three or four, such as José Eduardo Santos Tavares Melo Silva, and may insert particles like *de* or *e* between them. The order itself shifts: Spanish names tend toward paternal+maternal, while Portuguese names in Brazil may be maternal+paternal.

In Iceland, there are no inherited family names in the Western sense. Björk Guðmundsdóttir is the daughter of Guðmundur Gunnarsson; the second part is a patronymic, not a surname, and Icelanders expect to be called by their given name — telephone directories sort by given name. Patronymics appear elsewhere: Malays use *bin* or *binti* (Isa bin Osman), and Russians use a patronymic as a middle name (Boris Nikolayevich Yeltsin).

Some cultures construct names from village, father, caste, or religious reference. The Kerala name Velikkakathu Sankaran Achuthanandan is usually written V. S. Achuthanandan (familyName-fathersName-givenName). The Indian name Kogaddu Birappa Timappa Nair follows villageName-fathersName-givenName-lastName. The Arabic name Abu Karim Muhammad al-Jamil ibn Nidal ibn Abdulaziz al-Filistini layers parenthood, geography, and religion into a single string.

Even when a name looks structurally familiar, address rules diverge. In Vietnam, Nguyễn Tấn Dũng is formally referred to as Mr. Dũng, not Mr. Nguyễn. Chinese people interacting with Westerners may adopt additional given names, so Yao Ming might write himself as Fred Yao Ming or Fred Ming Yao, introducing yet more variation for the same person.

### Characters, Case, and the Limits of Text

People's names are not written in ASCII. They are not written in any single character set, and they are not all mapped in Unicode code points. Even names encountered in English may contain non-ASCII characters, such as Zoë.

Case is not a safe axis for manipulation. Names like **McNamara** contain capital letters that are not the first letter; others like **van der Waals** contain words that are intentionally not capitalized. Normalizing to Title Case or lowercasing for storage destroys correct representations. Names also appear in ALL CAPS and in all lower case, legitimately.

They can contain numbers. They can contain punctuation such as hyphens and apostrophes. Spaces may belong inside a single name — Rose Marie may be considered one name, not two. Prefixes like *de*, *von*, and suffixes like *Jr.* are part of the name and cannot be safely ignored.

And don't assume a single-letter name is an initial. People do have names that are one letter long; forms that block submission on "minimum length" create garbage data like "." or "Mr." as users fight their way through validation. In particular, do not assume that a four-character Japanese name in UTF-8 will fit in four bytes — you are likely to actually need 12.

### Software Assumptions That Eat People

Christopher Null's last name is a reserved string in many programming languages. Software frequently uses "null" to ensure a data field is not empty, so forms reject his name, crash, or loop back insisting the field is blank. His workarounds include typing "Null." with a period, or combining his middle name with his last name. American Express drops "Null" from mailing labels, addressing him simply as "Mr." Bank of America went further: after a system upgrade, it could not handle the string "null" anywhere in his email domain, blocking all of nullmedia.com and forcing him to switch to Gmail.

There is no algorithm that transforms names and can be reversed losslessly, short of returning the input unchanged. Two different systems containing data about the same person will often use different names for that person. Two different data entry operators, given the same name, will not necessarily enter bitwise-equivalent strings, even on a well-designed system.

People whose names break your system are not weird outliers who should have had solid, acceptable names like 田中太郎. The insistence that your system will never need to handle names from China, Japan, Korea, Ireland, the United Kingdom, the United States, Spain, Mexico, Brazil, Peru, Russia, Sweden, Botswana, South Africa, Trinidad, Haiti, France, or the Klingon Empire is wrong — all of these have "weird" naming schemes in common use. And if you maintain a dictionary of bad words, it probably contains someone's real name.

### Titles, Gender, and Formality

Russian names inflect for gender. The wife of Boris Nikolayevich Yeltsin is Naina Iosifovna Yeltsina; her patronymic and family name both take feminine *-a* endings, even though the patronymic derives from her father.

Middle initials mean different things in different places. Americans often write John Q. Public, but in the Philippines a middle initial represents the mother's maiden name before marriage: in Maria J. Go, the J stands for Jimenez, and an initial may represent more than one name (D for Dela Cruz). Brits may have multiple middle names but do not typically initialize them the way Americans do.

Titles and formality are not universal. In the UK, contacting a stranger by given name implies you have previously met. In Germany, titles stack: Herr Professor Doktor Schmidt. In Japan, honorifics attach to names (Tanaka-san, Tanaka-sama, or Tanaka-bucho for a department head). In Thailand, people commonly use short nicknames in informal settings — former prime minister Thaksin Shinawatra goes by Maew (แม้ว), and will introduce himself to Westerners with that nickname.

Because conventions vary, do not require a title field. If you are using Mr./Mrs./Ms. to infer gender, ask for gender directly — and remember that titles around the world vary significantly. On forms, ask for "Previous name" rather than "Maiden name" or "née"; men take their wife's name in some cultures, and in China wives normally keep their own name. Members of the same family may not share a family name at all. In the Hispanic example given by Manuel A. Pérez Quiñones, his parents' apellidos were Pérez Rodríguez and Quiñones Alamo. He married Padilla Falto; she became Padilla de Pérez, and their children were Pérez Padilla — so only the siblings share the same apellidos.

### Sorting and Display

Alphabetical order is not a universal constant. Icelandic and Thai telephone directories sort by given name, not family name. In the Spanish-speaking world, María José Carreño Quiñones might expect to find herself under Carreño in one region and Quiñones in another. Name particles such as *von*, *de*, and *van* may or may not be significant for sorting, depending on the locale.

Japanese names present a special retrieval problem. Ideographic characters can have multiple pronunciations: the family name in 東海林賢蔵 may be read Tōkairin or Shōji. Worse, different kanji can share the same pronunciation — 庄司, 庄子, 東海林, and 小路 all romanize as Shōji. Because automatic sorting and retrieval are typically pronunciation-based, Japanese people commonly provide a phonetic version in kana. Without that extra field, your search index is essentially guessing.

## If You Build This

- **Use a single full-name field unless you have a hard requirement to split it.** Asking for "given name" and "family name" already fails for Icelanders, Indonesians, and anyone with only one name. If you must atomize, avoid the labels "first name" and "last name," and add an extra field asking **"What should we call you?"** — this covers Thai nicknames like Maew, Japanese honorific norms, and the fact that Vietnamese prime ministers are Mr. Dũng, not Mr. Nguyễn.

- **Accept everything the user types, preserve its casing, and use UTF-8 everywhere.** That means UTF-8 in the page, the database, and every layer between. Do not normalize case — **McNamara** and **van der Waals** depend on it. Allow spaces, hyphens, apostrophes, and particles like *de* and *von*. Do not require a family name; do not reject single-character names as initials. And do not assume a four-character Japanese name in UTF-8 fits in four bytes — you are likely to need 12.

- **Never use a name as a unique identifier, and never assume two systems will agree on the spelling.** There is no lossless parsing algorithm. Data entry operators will produce different strings for the same person. Plan for collisions, aliases, and phonetic fields — especially for Japanese names, where you need a kana pronunciation field to sort and search reliably because the same kanji can be read as **Tōkairin** or **Shōji**.

- **Scrub your reserved-word and profanity filters against real names.** If your system treats **"Null"** as empty data, or if your bad-word list blocks real people, you are the bug. Test against names from the cultures you think you don't serve — because you do, even if only via ex-pats, immigrants, and edge cases.

- **Ask for "Previous name," not "Maiden name," and make titles optional.** Men change names on marriage too, and not all cultures follow the Western default. If you need to know how to address someone, ask directly rather than inferring from a title dropdown that forces a German honorific or an American marital-status choice.

- **If you localize forms, remember the database still has to hold the world.** Even within a single country you will find foreigners, multiple ethnic groups (Singaporeans may have Chinese, Malay, or Tamil names), and regional variation. Localized layouts defer complexity; they do not eliminate it. Centralized storage must accommodate every variation you allowed locally.

## Sources

- [Falsehoods about Names (Patrick McKenzie)](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
- [Falsehoods about Names — With Examples (Shine Solutions)](https://shinesolutions.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/)
- [Personal Names Around the World (W3C)](https://www.w3.org/International/questions/qa-personal-names)
- [Mr. Null — My Name Makes Me Invisible to Computers (WIRED)](https://www.wired.com/2015/11/null/)
