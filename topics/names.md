 # Falsehoods About Names

> Your name model is wrong, and it's wrong in ways that hurt real people.

## The Big Surprises

- **Some people do not have a name at all.** There are individuals for whom no string of characters serves as an identifier, yet they still need to rent apartments, receive medical care, and pay taxes.
- **A person's legal name can be six different strings, and systems will accept none of them.** Patrick McKenzie acknowledges six distinct "full" names as correct, while John Graham-Cumming has been told his name contains "invalid characters."
- **The last name "Null" is a denial-of-service attack on corporate IT.** Technology journalist Christopher Null has spent years locked out of Bank of America email (which rejects `null@media.com`), receives American Express mail addressed only to "Mr.," and watches websites crash because his surname matches a reserved programming token.
- **Björk does not have a family name.** The Icelandic singer's second name, Guðmundsdóttir, is a patronymic describing her father's given name plus her gender; her father is Guðmundur Gunnarsson (son of Gunnar). Phone books in Iceland sort by given name.
- **A single Japanese name can be read in multiple ways, and you cannot algorithmically know which.** The characters 東海林賢蔵 may be pronounced Tōkairin or Shōji; four different kanji (庄司, 庄子, 東海林, 小路) can all be romanized as Shōji, losing critical identity information.
- **Only the children in a Hispanic family may share the same "family" name.** When Manuel A. Pérez Quiñones (son of Pérez Rodríguez and Quiñones Alamo) married someone with apellidos Padilla Falto, she became Padilla de Pérez, and their children were Pérez Padilla—meaning the parents do not share a name with each other or with their own parents.
- **In Vietnam, the Prime Minister is formally called "Mr. Dũng," not "Mr. Nguyễn."** Nguyễn Tấn Dũng's family name comes first, but in formal address you use the given name—while in China, Mao Ze Dong's generational name Ze is shared with his siblings and expected in full references.
- **"First name" and "last name" are meaningless in many cultures.** Southern Indians, Malays, and Indonesians may have only a single given name with no patronym or family name at all, while Brazilians can carry three or four family names (e.g., José Eduardo Santos Tavares Melo Silva).
- **You cannot losslessly transform or normalize a name.** There is no algorithm that maps names into a canonical form and back again, except the identity function.

## Where It Gets Complicated

### One Person Can Have Many Correct Names

**People have exactly one canonical full name.** Patrick McKenzie answers to six different correct full names, depending on the context. John Graham-Cumming has had systems reject his name outright for containing supposedly invalid characters.

**People have exactly one name they go by, and it does not change.** Names shift over time and for reasons beyond marriage. In the family described by Manuel A. Pérez Quiñones, apellidos morphed from Pérez Rodríguez and Quiñones Alamo into Pérez Quiñones, then Padilla de Pérez, then Pérez Padilla across a single generation.

**Names are assigned at birth, or at least pretty close to it.** McKenzie notes this assumption collapses for people whose names are assigned much later, or who change their names repeatedly throughout life.

**Two different systems containing data about the same person will use the same name.** McKenzie has seen systems fail to reconcile the same individual because the names differ. Even two careful data entry operators will not necessarily produce bitwise equivalent strings for the same person.

**People’s names are globally unique, or diverse enough that no million people share the same name.** They are not. Common names in populous countries routinely reach millions of bearers.

### Not Everyone Has a Family Name

**People have a last name or family name shared by relatives.** Icelanders like Björk Guðmundsdóttir use a patronymic (Guðmundsdóttir = daughter of Guðmundur), not a family name. Her father is Guðmundur Gunnarsson (son of Gunnar). Telephone directories in Iceland are sorted by given name, and Björk would not expect to be called Ms. Guðmundsdóttir.

**People have exactly N names, for any value of N.** In parts of Southern India, Malaysia, and Indonesia, many people have only a single given name with no patronym or family name whatsoever. If you require a family name, users in these cultures often enter garbage like "." or "Mr." just to escape the form.

**Members of the same family share the same family name.** In China, wives typically keep their own name after marriage. If the Malay girl Zaiton married Isa bin Osman, she might remain Mrs. Zaiton or become Zaiton Isa. In some Hispanic families, only the children share the same apellidos. Men sometimes take their wife’s name on marriage, which is why "Previous name" is more accurate than "Maiden name" or "née."

**"First name" and "last name" are meaningful distinctions everywhere.** For someone like Isa bin Osman, "bin" simply means "son of." In Malaysia, he might be addressed as Encik Isa, not Mr. Osman.

### The Order and Number of Name Parts Varies Wildly

**People’s names have a consistent global order.** In Chinese, 毛泽东 is family name Mao, generational name Ze, given name Dong; his siblings share Ze (毛泽民, 毛泽覃, 毛泽紅). Chinese names have no spaces. Among non-familiar contacts he is 毛泽东先生 or 毛先生; familiar contacts might use 泽东, not just 东. Japanese, Korean, and Hungarian also put family name first. A slightly less formal Russian order puts family name first: Ельцина Наина Иосифовна.

**People have exactly one family name.** Spanish-speaking people commonly have two family names (María José Carreño Quiñones, paternal Carreño + maternal Quiñones). Brazilians may have three or four (José Eduardo Santos Tavares Melo Silva), and Portuguese names often use maternal+paternal order rather than paternal+maternal. Particles like de or e appear between names (Carreño de Quiñones, Tavares e Silva).

**Middle initials follow the same rules everywhere.** Americans like John Q. Public use a middle initial for a given name. Filipinos like Maria J. Go use a middle initial for the mother’s maiden name before marriage (Jimenez), and that single initial may represent multiple names such as Dela Cruz.

**People’s first and last names are, by necessity, different.** Russian patronymics and family names change endings by gender: Boris Nikolayevich Yeltsin vs. Naina Iosifovna Yeltsina.

### One Text Field Cannot Capture a Name

**A single "full name" field is enough for everyone.** Many names carry information that cannot be flattened into one string without loss. The Arabic name Abu Karim Muhammad al-Jamil ibn Nidal ibn Abdulaziz al-Filistini encodes lineage, titles, and geography. Indian names like Kogaddu Birappa Timappa Nair (village-father-given-last) or Aditya Pratap Singh Chauhan (given-father-surname-caste) or Madurai Mani Iyer (town-given-caste) embed location and caste.

**Nicknames are derived from formal names.** In Thailand, former prime minister Thaksin Shinawatra goes by the nickname Maew (แม้ว), used in all non-formal situations and often introduced to Westerners because it is easier to pronounce.

**A single letter name is just an initial.** Some people have legal names that are one letter long. Forms that refuse single-letter names block real users.

**Japanese names sort like Western names.** Because ideographic characters can have multiple pronunciations, 東海林賢蔵 may be read as Tōkairin or Shōji. Four different kanji (庄司, 庄子, 東海林, 小路) can all be romanized as Shōji. Japanese users commonly need a separate phonetic kana field just so the system can sort and retrieve their names correctly.

**You can defer complexity by localizing forms per culture.** If you centralize data from multiple locales into one database, localized form layouts only postpone the pain. The underlying storage still needs to handle Icelandic patronymics, Chinese generational names, and Arabic lineages in the same table.

### Writing Systems and Case Are Not Uniform

**People’s names are written in ASCII, or in any single character set, or all mapped in Unicode code points.** Even English names use non-ASCII characters (Zoë). If you accept names in native script, you need UTF-8 end-to-end; a four-character Japanese name in UTF-8 can require 12 bytes.

**People’s names are case sensitive, or case insensitive.** Both assumptions are wrong. Names like McNamara contain mid-word capitals, and van der Waals contains lowercase particles. Coercing names to Title Case destroys them.

**People’s names do not contain numbers, are not written in ALL CAPS, are not written in all lower case, and do not have prefixes or suffixes.** These formats all exist in real data. Prefixes like de, von, and Jnr/Jr are integral to the name and cannot be safely stripped.

**You can algorithmically normalize a name and reverse it losslessly.** McKenzie notes that no such algorithm exists; the only lossless transformation is the identity function.

### "Null" and Bad Words Are Not the Only Landmines

**A dictionary of bad words contains no people’s names.** Filters meant to block profanity often catch legitimate names.

**The name "Null" is safe to store in a string field.** Christopher Null routinely watches websites crash, forms reject his name as blank, and databases corrupt his record because "null" is a reserved token. Bank of America blocked his email `null@media.com` entirely after an upgrade, and American Express sends him mail addressed to "Mr." or "Media LLC" after dropping his surname. His workaround is adding a period: "Null."

**Systems can safely split, parse, or auto-format names.** Implied "n" optimization (v-card / h-card) fails on Chinese family-first names. Auto-parsing Spanish or Portuguese multi-part names without cultural knowledge misidentifies which portion is the family name.

### Sorting and Addressing Differ by Culture

**Names sort by family name everywhere.** Thai and Icelandic telephone directories sort by given name, not family name. Spanish sorting conventions vary by region: María José Carreño Quiñones may expect to be found under Carreño Quiñones or under Quiñones. Prefixes like von, de, and van are sometimes significant for sorting and sometimes ignored.

**Formality is uniform.** In the UK, addressing a stranger by given name implies you have already met. In Germany, titles accumulate: Herr Professor Doktor Schmidt. In Japan, coworkers expect Tanaka-bucho (Department-head Tanaka) or Tanaka-san; attaching -san to a given name in the workplace is unusual. Vietnamese Prime Minister Nguyễn Tấn Dũng is formally Mr. Dũng, not Mr. Nguyễn.

### Titles, Gender, and Marital Status

**You need a title to address someone correctly.** Many people do not use titles at all. If you require Mr./Mrs./Ms. to guess gender, you force women to reveal marital status while men do not, and you fail non-binary users. Titles vary globally (Encik, Herr Professor Doktor, -san) and do not reliably indicate gender.

## If You Build This

- **Prefer a single "full name" field.** If you absolutely need to split names, ask for the specific fragment you need—such as "What should we call you?"—rather than using "first name" and "last name," which are meaningless in many cultures.
- **Use UTF-8 in every layer.** The database, the backend, and the frontend must all speak Unicode. A four-character Japanese name can require 12 bytes, and English names still contain non-ASCII characters like Zoë.
- **Store exactly what the user types.** Do not coerce case (McNamara, van der Waals), strip punctuation or spaces (de, von, Jnr), or auto-parse into fixed columns. The only lossless transformation is the identity function.
- **Never use reserved strings as stand-ins for "empty."** Treating "Null" as a sentinel value will lock out real people, crash forms, and corrupt mailing lists. Validate inputs as user data, not programming tokens.
- **Ask for a display name and a sort key separately.** If you need to address someone informally or sort a list, ask how they prefer to be called and provide a phonetic field—especially for Japanese kanji, Thai, Icelandic, and Spanish multi-part names.
- **Drop mandatory titles and gender inference.** Do not require Mr./Mrs./Ms., and replace "Maiden name" with "Previous name." Titles vary globally and do not reliably indicate gender or marital status.

## Sources

- [Falsehoods about Names (Patrick McKenzie)](https://www.kalzumeus.com/2010/06/17/falsehoods-programmers-believe-about-names/)
- [Falsehoods about Names — With Examples (Shine Solutions)](https://shinesolutions.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/)
- [Personal Names Around the World (W3C)](https://www.w3.org/International/questions/qa-personal-names)
- [Mr. Null — My Name Makes Me Invisible to Computers (WIRED)](https://www.wired.com/2015/11/null/)
