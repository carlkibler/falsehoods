# Falsehoods About Postal Addresses

> An address isn't a string, isn't a location, and sometimes isn't even necessary.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A building can have a negative house number.** "Minusone Priory Road, Newbury" is a real, deliverable UK address. The lowest confirmed number in the HM Land Registry data is Minus Three, Chalton Heights, Chalton, Luton. Someone in Stroud has Minus Two.

- **An address can refer to something that no longer exists — and still work.** In Costa Rica, entire neighborhoods navigate by *el antiguo higuerón*, a fig tree felled decades ago. One sample address from Managua, Nicaragua: "From where the Chinese restaurant used to be, two blocks down, half a block toward the lake, next door to the house where the yellow car is parked." Mail still arrives.

- **Japan's postal CSV is so broken that people joke the punishment in Hell is parsing it forever.** The file splits single records across multiple lines when a neighborhood name exceeds 38 characters, duplicating every other field. One postal code — 〒452-0961 in Kiyosu City — spans 66 rows. Some Kyoto entries require 8 rows just to describe an intersection-based address like "North Town (Up Lower Godsroad from the West, Down Turtle Street from the East…)."

- **"Just use house number + postcode" is a myth.** In the UK, postcode CV4 7AL covers the entire University of Warwick campus (6,000 students), and DVLA Swansea uses *different postcodes for different departments* — V5Cs go to SA99 1BA, driving licences to SA99 1AB. Meanwhile, postcode CV12 8UE covers seven differently-named roads (Gatehouse Lane, Emes Walk, Bucklers Yard, Homers Yard, Lye Corner, Sleets Yard, Old Penns Yard) that all share overlapping house numbers.

- **A building can have the number Pi.** Pi, Green Lane, Wicklewood, Wymondham NR18 9ET is a real UK address. There are also houses numbered 99½, 75¾, 1¼, and — at 44½ D, Claypath, Durham — a fractional number with a letter suffix.

- **An address can be undeliverable through one carrier but required by another, simultaneously.** XaspR8d's road is known as "S Hwy X", "Highway X", and "South County Rd X" depending on the database. The only addresses that passed his vendor's validator failed his bank's, and vice versa. Jon Peterson's apartment on "Quail Ridge East Lane" is recognized by USPS and the city electric utility, but everyone else requires "Quail Rdg E" — so when UPS hands a package to USPS, it comes back undeliverable.

- **Costa Rica's informal address system costs $720 million a year.** A 2010 study quantified the economic damage from lost mail and lost productivity. Ambulances get lost. And yet the system persists, because it is "a language, an insider's code" that people actively love.

- **The same street can have two different names — one per side — with separate, independently-numbered houses facing each other.** In Gateshead, 1 Richmond Terrace faces 1 Ashgrove Terrace across a single-carriageway road. In Edinburgh's Colonies housing, Lady Menzies Place faces Alva Place on one side and Regent Place on the other.

---

## Where It Gets Complicated

### Building Numbers

The assumption that a building has one clean, unique, numeric identifier dissolves almost immediately.

**Numbers aren't always numbers.** "Ten Post Office Sq, Boston MA 02109" is not the same address as "10 Post Office Sq, Boston MA 02109." Apartment 001 and Apartment 1 at 101 Alma St, Palo Alto are on different floors. A condo association in Tampa ran blocks A through Z, then continued with Alpha, Beta, Gamma, Delta, and Theta — mail for Alpha routinely went to A.

**Numbers can be zero, negative, or fractional.** Zero exists at multiple UK addresses (0 Egmont Road, Middlesbrough). Negative numbers go down to at least −3 (Minus Three, Chalton Heights, Luton). Fractions appear as written words ("Ninety Nine & A Half, Western Road, Brighton"), as digits with slashes (1 1/2, Disbrowe Road, London W6), and as Unicode (43rd ½ St, Pittsburgh). On High Street, Earl Shilton, Leicestershire, five consecutive properties are numbered 75, 75a, 75b, 75½, and 75¾.

**Numbers can be astronomically high for no obvious reason.** The highest legitimate sequential house number in England and Wales is 2679 Stratford Road, B94 5NH. But a house near Beccles, Suffolk is numbered 9156 on a road with no other houses above 2000 — apparently someone chose it as a name.

**A building can have both a name and a number, or multiple numbers.** Idas Court, 4-6 Princes Road, Hull, HU5 2RD has both. Flat 1.4, Ziggurat Building, 60-66 Saffron Hill, London, EC1N 8QX has a flat number, a building name, and a range of building numbers. In Hong Kong: 15/F, Cityplaza 3, 14 TaiKoo Wan Road — both a road number (14) and a building-group number (3).

**The same number can appear twice in the same postcode.** 1-4 Jubilee Cottages and 1-4 Cedar Cottages both sit on Warwick Road, B94 6AZ. Three separate properties at The Chase, HA5 5QP are each numbered 1.

**Numbers can be skipped, distance-based, or grid-based.** In rural Finland and Antibes, France, building numbers reflect distance from the start of the road (Longroad 65 = 750m from the start). Mannheim, Germany assigns block coordinates: Institut für Deutsche Sprache lives at R 5, 6-13. Menomonee Falls, Wisconsin uses Milwaukee County's grid, producing addresses like N88 W16541 Foobar St.

---

### Street Names

**Streets don't always have names.** Many driveways, on-ramps, and car park aisles are unnamed. In Japan, the dominant addressing system uses districts, blocks, and lot numbers — street names are largely irrelevant. Kirk Kerekes spent years successfully receiving mail at "2 mi N then 3 mi W of Jennings, OK 74038." Mike Riley mailed the Very Large Array radio telescope at "50 miles (80 km) West of Socorro, New Mexico, USA."

**Streets don't always have unique names — even nearby.** London has at least 15 distinct "High Street" addresses, each with a valid postcode. In Bocholt, Germany, several roads in close proximity are all named Up de Welle. The UK has three towns called Newport, each with a "10 High Street."

**Street names can contain numbers, fractions, or be entirely composed of descriptors.** Plein 1944 in Nijmegen is a street name with a year as a number. In Lelystad, "Gondel 2695" means area Gondel, street 26, number 95 — no separator. "17 Hill Street" and "Avenue Road, Toronto" are real addresses where the descriptor is the whole name, or doubled. Piccadilly, London has no descriptor at all.

**A street name can include punctuation you'll never expect.** 's-Gravenhage (The Hague's official Dutch name) starts with an apostrophe and contains a hyphen. Westward Ho!, Bideford has an exclamation mark — omitted in some databases. Bo'ness has an apostrophe. "3 Bishops Square Business Park, Hatfield" has a descriptor in the middle of the name.

**The same road can have multiple names simultaneously.** Goswell Road in London and Regent Road in Edinburgh are both segments of the 410-mile A1. "Top O'The Lane, Brindle, Chorley, PR6 8PA" appears in different databases as "Top o' th' Lane," "Top oth Lane," "Top of the Lane," and "Workhouse Lane" (a historical name) — all referring to the same road.

**Streets can have different names on each side.** Edinburgh's Haddington Place and Elm Row are the same physical road, named by direction of travel. In Gateshead, Cambridge Terrace and Oxford Terrace are opposite sides of a single-carriageway road, each with its own independent numbering sequence.

---

### Postcodes and Zip Codes

**Postcodes don't start with a nonzero digit.** Darwin, Australia: 0800. Helsinki, Finland: all postcodes start with two zeros; some special codes start with four (00002 HELSINKI). Northeastern US zip codes start with zero (Boston: 02109). Jena, Germany: 07737. Israeli army unit postcodes start with zeros and *move with the units*.

**One postcode ≠ one city, and one city ≠ one postcode.** US zip code 33334 covers Oakland Park, Wilton Manors, and Fort Lauderdale simultaneously. French postcode 75015 covers over 230,000 people in the XVth arrondissement of Paris. The Empire State Building has its own zip code: 10118. DVLA Swansea uses a separate postcode per department within one building. The Enfield Civic Centre has five postcodes — and the council's own website lists a sixth (EN1 3XY) that Royal Mail maps to a PO Box at the sorting office.

**Postcodes can be assigned to things that don't exist yet, or no longer exist.** Royal Mail's *Not Yet Built* database product exists for a reason. Temporary postcodes are assigned to building sites. Demolished buildings linger in databases.

**Santa Claus has official postcodes.** Canada: H0H 0H0. UK: Father Christmas, Santa's Grotto, Reindeerland, XM4 5HQ. Greenland: Santa Claus, Julemandens Postkontor, 3900 Nuuk.

---

### Address Structure and Ordering

**Addresses don't follow a universal structure.** A Japanese address runs from most-general to most-specific: prefecture → ward → district → subdistrict → block → lot → building → flat. English addresses run the opposite way. Hungarian addresses change *order depending on how many lines are available* — one-line format differs from envelope format differs from multi-line format. In some Canadian regions, suite 123 in building 456 on TheStreet is written "123 456 TheStreet"; in others, "456 TheStreet #123."

**An address can require more lines than your form allows.** Five lines and country is a common UI assumption. The actual requirement can be eight: GB Technical Services, Unit W7a, Warwick House, 18 Forge Lane, Minworth Industrial Park, Minworth, Sutton Coldfield, B76 1AH, United Kingdom. A Japanese address from Sendai packs fifteen digits across six separate numbers.

**An address can contain commas, apostrophes, brackets, ampersands, dots, hyphens, and exclamation marks** — all in the same address. St. Judes & St. Pauls C of E (Va) Primary School, 10 Kingsbury Road, London, N1 4AZ. UK company law permits company names including "! LTD" (company 08209948), "@ LTD" (08209882), and "% LTD" (04487680).

**Addresses can be written in non-Latin scripts, mixed scripts, or the wrong encoding entirely.** The Greek tax office address is Χανδρή 1 & Θεσσαλονίκης, Τ.Κ. 18346, Αθήνα. A Russian parcel once arrived with its Cyrillic address garbled through wrong encoding, hand-transcribed from the screen — and a Russian postal worker reverse-engineered the encoding and delivered it anyway. International mail may specify the destination country in *both* source and destination character sets.

---

### What an Address Actually Refers To

**An address is not a location.** PO Boxes, Reply Paid addresses, locked bags, parcel lockers, CMAs, CPAs, CMBs — Australia Post alone has over a dozen non-geographic address types. The Falkland Islands' entire territory shares one postcode: FIQQ 1ZZ.

**An address can correspond to no fixed location at all.** A houseboat can move between towns and countries. "Snowbird" clients alternate between two addresses seasonally. The State of Illinois officially instructs residents without a street address to describe their home using "cross streets, roads, landmarks, mileage and/or neighbors' names."

**Addresses change.** Douglas Perreault's condo changed address four times: city changed (Lutz → Tampa), zip code changed (33612 → 33613), then the block naming scheme changed entirely, yielding a completely different street name and number. Streets are renamed when political winds shift — Lenin Street became something else across eastern Europe. The county of Gwent no longer exists. New postcodes are assigned to existing buildings.

**An address with a street name may not be near that street.** The National Museum of Computing, Bletchley Park, Sherwood Drive, Bletchley, MK3 6EB is 70 meters from Roche Gardens and 346 meters from Sherwood Drive — only accessible by entering via Sherwood Drive.

**One person can have multiple addresses; one address can serve multiple people.** Tibor Schütz notes people commonly have different home and work addresses. Many doctors' offices cannot mail reminders to both parents of a child after a divorce. Tower 42, 25 Old Broad Street, London, EC2N 1HQ hosts over 90 organizations.

**Military addresses follow none of the above rules.** BFPO, BF1 4FB is the address of the Royal Navy vessel HMS Example. Israeli army unit postcodes physically travel with the unit.

---

### The Limits of Validation

**Every address validator will reject valid addresses.** "Top O'The Lane" fails systems that don't allow apostrophes. Addresses in new developments don't exist in postal databases yet. Addresses in demolished buildings still do. The Electoral Reform Society Ltd, London, N1 1RS is a complete, deliverable UK address with no street line at all.

**Addresses can contain rude words — legitimately.** Beyond Middlesex and Scunthorpe, Gary Gale has compiled a map of genuinely rude-sounding UK place names. Profanity filters on address fields will reject real places.

**"Reasonable length" is not a safe assumption.** The longest street name in Germany: Bischöflich-Geistlicher-Rat-Josef-Zinnbauer-Straße, Dingolfing, Bavaria. In Bosnia: Aleja Alije Izetbegovića Prvig Predsjednika Predsjedništva Republika Bosna i Hercegovina — 89 characters, one street. A full organizational address can easily exceed 200 characters: Department For Environment Food & Rural Affairs (D E F R A), State Veterinary Service, Animal Health Office, Hadrian House, Wavell Drive, Rosehill Industrial Estate, Carlisle, CA1 2TB, United Kingdom.

---

## If You Build This

1. **Never store an address as a single string you intend to parse back into components.** Commas appear in organization names. Newlines and commas are not interchangeable. Store structured fields and a free-text fallback; round-tripping through string manipulation will corrupt real data.

2. **Use the Universal Postal Union's S42 standard or a country-specific schema (like BS7666 in the UK) rather than inventing your own field structure.** Most homebrew schemas assume five lines, one postcode, one country. Real addresses need dependent streets, sub-building identifiers, and organizational hierarchies.

3. **Never make a postcode or zip code field numeric.** Leading zeros are real (00002 HELSINKI, 02109 Boston, 0800 Darwin). Alphanumeric codes are real (WC2E 9DD, FIQQ 1ZZ, H0H 0H0). A VARCHAR, not an INT.

4. **Never validate by rejecting characters.** Apostrophes, hyphens, ampersands, dots, exclamation marks, brackets, non-Latin scripts, and accented characters all appear in legitimate addresses. If you must validate, whitelist conservatively and log rejections for human review rather than silently blocking delivery.

5. **Treat the postal database as a hint, not ground truth.** New buildings aren't in it yet. Demolished buildings still are. The same address can appear in different forms across Royal Mail, Ordnance Survey, and local authority gazetteers. If you need a stable, unique identifier for a property, use a UPRN (Unique Property Reference Number) in the UK, not the address string itself.

6. **Ask users for their address; don't infer it.** Postcode-to-address lookup works most of the time, but CV12 8UE covers seven roads with overlapping numbers, and CV4 7AL covers 6,000 people. A user who lives on a houseboat, in a new development, or at a military address will need a free-text escape hatch — and so will anyone whose address contains a landmark that was demolished before your lookup database was compiled.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Addresses (mjt.me.uk)](https://www.mjt.me.uk/posts/falsehoods-programmers-believe-about-addresses/) · [archived copy](../archive/postal-addresses/01-falsehoods-about-addresses-mjt-me-uk.md)
- [UK Address Oddities (Paul Plowman)](https://paulplowman.com/stuff/uk-address-oddities/) · [archived copy](../archive/postal-addresses/02-uk-address-oddities-paul-plowman.md)
- [Parsing the Infamous Japanese Postal CSV (dampfkraft)](https://www.dampfkraft.com/posuto.html) · [archived copy](../archive/postal-addresses/03-parsing-the-infamous-japanese-postal-csv-dampfkraf.md)
- [Why doesn't Costa Rica use real addresses?](https://www.crcdaily.com/p/why-doesnt-costa-rica-use-real-addresses) · [archived copy](../archive/postal-addresses/04-why-doesn-t-costa-rica-use-real-addresses.md)
