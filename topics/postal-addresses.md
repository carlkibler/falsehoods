# Falsehoods About Postal Addresses

> An address isn't a string, isn't a location, and sometimes isn't even necessary.

## The Big Surprises

- **There is a building numbered "Minus Three."** Negative house numbers exist across the UK — Minusone Priory Road in Newbury, Minus Two on Woodend Lane in Cam, Stroud, and Minus Three at Chalton Heights, Chalton, Luton. And a house in Owls Green, a village of about 20 houses near Ipswich, is numbered 2820.

- **An address can refer to something that no longer exists — and still get mail delivered.** In Costa Rica, addresses are routinely given relative to an *antiguo higuerón* — a fig tree felled decades ago — or to a corn mill that closed ten years back. The address lives on even when the landmark doesn't. A 2010 study found this system costs Costa Rica $720 million annually in lost mail and lost productivity.

- **"50 miles west of Socorro, New Mexico, USA" is a valid mailing address.** Kirk Kerekes spent years receiving deliveries at "2 mi N then 3 mi W of Jennings, OK 74038." The Very Large Array radio telescope received mail at "50 miles (80 km) West of Socorro, New Mexico, USA." A Tulane study abroad program used "50 meters north of the Hypermas/Walmart of Curridabat, San José, Costa Rica."

- **Japan Post's official postal code CSV is so broken it's become a programmer legend.** Fields overflow into multiple rows with no consistent break point; a catch-all string meaning "except the following" must be string-matched and excluded; and the string 一円 ("one yen") appears as a note to be stripped — except in exactly one neighborhood in Shiga where that *is* the actual name (〒522-0317). One postal code, 〒452-0961 in Haruhi, Aichi, spans a stunning 66 rows.

- **"Ten Post Office Sq, Boston MA 02109" and "10 Post Office Sq, Boston MA 02109" are different buildings.** A building name that is a spelled-out number is not the same address as the same number written in digits. Separately, Apartment 001 and Apartment 1 at 101 Alma St, Palo Alto were on different floors.

- **A single building can have multiple postcodes — and one of those postcodes might route to the sorting office PO Box, not the building at all.** DVLA Swansea processes V5Cs at SA99 1BA and driving licences at SA99 1AB. The London Borough of Enfield's Civic Centre has five postcodes for five departments — and the postcode listed on the council's own contact page, EN1 3XY, is a PO Box at the sorting office.

- **Canada's official postal code for Santa Claus is H0H 0H0.** Germany routes his mail to DK-3900 Nuuk. The UK delivers to Father Christmas, Santa's Grotto, Reindeerland, XM4 5HQ. Israeli army unit postcodes physically move with the units.

- **A street can have two different names simultaneously — one per side of the road.** In Gateshead, Cambridge Terrace and Oxford Terrace are two names for opposite sides of a single-carriageway road, each with its own sequential numbering, so 1 Richmond Terrace faces 1 Ashgrove Terrace across the same tarmac.

---

## Where It Gets Complicated

### Building Numbers Are Not What You Think

The assumption that a building number is a single positive integer is wrong in almost every direction you can push it.

**Not always present.** The Royal Opera House's address is simply: Royal Opera House, Covent Garden, London, WC2E 9DD. No number.

**Not always numeric.** 1A Egmont Road, Middlesbrough, TS4 2HT. Or a range: 4-5 Bonhill Street, London, EC2A 4BX.

**Zero and negative.** Multiple UK streets have a house number 0 (Baker Street, Middlesbrough; Egmont Road, Middlesbrough; Coxes Road, Selsey). Negative numbers exist: Minus One on Kingsway, Orpington; Minus Two on Woodend Lane, Cam, Stroud; Minus Three at Chalton Heights, Luton. Databases often render "Minusone" as a word rather than -1.

**Fractions.** UK house numbers include "99 & A Half, Western Road, Brighton, BN1 2AA"; "1 1/2, Disbrowe Road, Hammersmith"; and "6.5, St Peter's Grove, York, YO30 6AQ." On High Street, Earl Shilton, Leicestershire, five consecutive properties are numbered: 75, 75a, 75b, 75½, 75¾. One property in Wicklewood, Norfolk, is simply named Pi. In Pittsburgh, fractional *street* numbers exist: 43rd ½ St, writable as Unicode (43rd ½ St), slash notation (43 1/2), or decimal (43.5).

**Not unique per street.** 50 Ammanford Road, Tycroes and 50 Ammanford Road, Llandybie are about 4 miles apart. In France and rural Finland, some buildings are numbered by distance from the start of the road — Longroad 65 means the building 750m from the start.

**Not the only number in an address.** Flat 18, Da Vinci House, 44 Saffron Hill, London, EC1N 8FH contains three numbers. A Japanese address example contains fifteen digits across six separate number fields: zip, prefecture, city, ward, district, sub-district-block-lot, and flat.

**Extremely high.** The highest legitimately sequential house number in England and Wales is 2679 Stratford Road, B94 5NH. A house in Owls Green near Ipswich is numbered 2820 despite being in a village of about 20 houses.

**Buildings can have both a name and a number.** Idas Court, 4-6 Princes Road, Hull, HU5 2RD. Flat 1.4, Ziggurat Building, 60-66 Saffron Hill, London, EC1N 8QX.

**A building name can itself be a number.** Ten Post Office Sq, Boston MA 02109 is not the same as 10 Post Office Sq.

**Leading zeros matter.** Apartments 1 and 001 at 101 Alma St, Palo Alto were on different floors.

**Numbers can be skipped, duplicated, or bizarre.** Victoria Embankment in London has a run that goes: 40, 58, 50, 56, 60. Hempshaw Lane in Stockport has an unexplained gap of over 100 numbers. Portland Road in Dorking has houses lettered A–Q rather than numbered, with the letters built into the walls.

---

### Street Names Are Stranger Than You Remember

**No descriptor required.** Piccadilly, London, W1J 9PN. In Cumbria there is a road simply called Street. In Somerset there is Street Road, which leads to a town called Street.

**Descriptor in the wrong place.** French addresses prefix with 'rue', 'avenue', 'place'. English has "17 Hill Street" and "Avenue Road, Toronto." The descriptor can be in the middle: 3 Bishops Square Business Park, Hatfield, AL10 9NA.

**Numbers in street names, written as digits.** Plein 1944 in Nijmegen, Netherlands. And when a numbered street abuts a building number, there may be no separator: Gondel 2695, Lelystad means area Gondel, street 26, number 95.

**The same street name recurs within a single city.** London has at least sixteen distinct streets called or containing "High Street," each with its own buildings. Bocholt, Germany has several roads in close proximity all called "Up de Welle."

**Streets with no name at all.** Many driveways, onramps, and carpark aisles are unnamed. Japan's prevalent addressing system works on districts, blocks, and lots rather than road names. In rural America, some homes use Rural Route addresses: Box 1234, R.R. 1, Winthrop, ME 04364.

**One road, many names.** Goswell Road in London and Regent Road in Edinburgh are both segments of the 410-mile A1. There may be only one "1 Goswell Road" and only one "1 Regent Road," but there are multiple buildings numbered 1 on the A1. Roads in Ireland carry names in both English and Irish. In Edinburgh, streets like Haddington Place/Elm Row have different names depending on which direction you're travelling. In Gateshead, each side of a single carriageway has its own name and its own numbering sequence.

**An address can have more than one street.** Royal Mail's "dependent street" system: 6 Elm Avenue, Runcorn Road, Birmingham, B12 8QX — Runcorn Road is the main street; Elm Avenue is a stub that isn't unique within the city. Some addresses have no street at all: Oakland, Fairseat, Sevenoaks, TN15 7LT is delivered by name alone (it's actually on Vigo Road).

**Addresses can contain special characters you're not expecting.** 's-Gravenhage (The Hague) starts with an apostrophe-s and contains a hyphen. Westward Ho!, Bideford, EX39 1AQ contains an exclamation mark. 1 Acre View, Bo'ness, EH51 9RQ contains an apostrophe mid-word. UK company law permits company names including ! LTD (company 08209948), @ LTD (08209882), $ LTD (08209885), and % LTD (04487680).

---

### Postcodes and Zip Codes

**Not every country has them.** The Republic of Ireland historically had no postcodes outside Dublin. Hong Kong has none. When Singapore is asked for city, county, and country separately, the answer is "Singapore, Singapore, Singapore."

**They don't always start with a non-zero digit.** Darwin, Australia: 0800. Boston, MA: 02109. Helsinki: all postcodes start with two zeros; some special codes start with four (00002 HELSINKI). Jena, Germany: 07737. French postcodes use the département number as a prefix, and département 06 (Alpes Maritimes) requires the leading zero — mail addressed to 6130 Grasse gets routed to département 61, Orne. Corsica is départements 2A and 2B, but the post office kept the former code 20 (Ajaccio: 20000, Bastia: 20200).

**One postcode ≠ one building.** The University of Warwick has postcode CV4 7AL for 6,000 students and all campus staff. French postcode 75015 covers over 230,000 people. The Empire State Building has its own zip code: 10118. DVLA Swansea uses separate postcodes per department. The London Borough of Enfield's Civic Centre has five postcodes for five departments — and the one on the council's own website routes to a PO Box at the sorting office.

**One zip code ≠ one city.** Zip code 33334 covers Oakland Park, Wilton Manors, and Fort Lauderdale, all in Florida.

**Not all box numbers are PO Boxes.** A university campus pigeonhole — Timothy L. Kay, Box 256-80, Pasadena, CA 91125 — had its zip code automatically "corrected" to 91102, the zip for Pasadena PO Boxes, causing mail failures.

**The Falkland Islands share a single postcode: FIQQ 1ZZ.** The British Virgin Islands, by contrast, have their own system. Santa's Canadian postcode is H0H 0H0.

---

### Cities, Counties, and Countries

**Two towns with the same name in the same country, with duplicate street names.** The UK has three towns called Newport. There are "10 High Street" addresses in Newport, PO30 1SS (Isle of Wight); Newport, NP20 1FQ (Wales); and Newport, TF10 7AN (Shropshire). The Netherlands has two cities called Eursinge in the same province.

**Counties are unreliable.** The Royal Mail stopped using postal counties in 1996. Belgium requires only a street, postcode, and city: Boulevard Frère Orban, 27, 4000 Liège. Oslo is simultaneously a By, Tettsted, Kommune, and Fylke — but appears only once in a written address.

**Addresses can require more than one country.** An address on Kerguelen Island reads: District de Kerguelen, Terres Australes et Antarctiques Françaises, via la Réunion, France.

**Administrative boundaries shift.** Addresses move between counties with local government reorganisation. Streets in eastern Europe were renamed when Lenin fell out of political favour. One condo in Tampa changed address four times: Lutz → Tampa (new post office) → Tampa (zip change) → new street name entirely, ending at 14410 Hanging Moss Circle, #101, Tampa, FL 33613.

---

### Ordering, Encoding, and Format

**Addresses aren't always written most-to-least specific.** Japanese addresses go from largest to smallest: prefecture → ward → district → block → lot → building. Norwegian and Dutch addresses put the building number after the street name but before the town. Hungarian addresses change order depending on how many lines are available — one-line format runs least-to-most specific; multi-line format starts with the street.

**Not ASCII, not Latin, not even consistent within one address.** The Greek tax office address is Χανδρή 1 & Θεσσαλονίκης, Τ.Κ. 18346, Αθήνα. A Cyrillic-addressed parcel was once delivered to Russia after a postal worker reverse-engineered a character encoding corruption. International mail may specify the destination country in both the sender's and recipient's character sets simultaneously.

**Addresses can be very long.** Department For Environment Food & Rural Affairs (D E F R A), State Veterinary Service, Animal Health Office, Hadrian House, Wavell Drive, Rosehill Industrial Estate, Carlisle, CA1 2TB — well over 100 characters. The longest street name in Germany is Bischöflich-Geistlicher-Rat-Josef-Zinnbauer-Straße in Dingolfing, Bavaria. A street in Bihac, Bosnia runs to 89 characters.

**You cannot round-trip newlines through commas.** Organisation names contain commas: Society of College, National & University Libraries, 102 Euston Street, London, NW1 2HA. Some addresses need 8 lines plus country, not 5.

**The same address is spelled differently in different databases.** A road the Royal Mail calls "Top O'The Lane, Brindle, Chorley, PR6 8PA" appears elsewhere as "Top o' th' Lane," "Top oth Lane," "Top o' the Lane," "Top of the Lane," "Workhouse Lane," and "Denham Lane." These are all the same road.

---

### Addresses as Concepts, Not Locations

**An address is not a point on a map.** The National Museum of Computing, Bletchley Park, Sherwood Drive, Bletchley, MK3 6EB is 346m from Sherwood Drive but only accessible via Sherwood Drive. Farms and country houses can be at the end of private driveways several hundred metres long.

**Addresses move, or don't exist, or exist without buildings.** Royal Mail's *Not Yet Built* database assigns temporary postcodes to construction sites. Demolished buildings remain in Royal Mail and Ordnance Survey databases. New buildings can be absent from databases for months after construction.

**One address, many validators — and they may all disagree.** One user's road is variously known as "S Hwy X," "Highway X," and "South County Rd X." The only addresses that passed his vendor's validator failed his bank's, and vice versa. A USPS-recognised address in a condo community — Quail Ridge East Lane — is unknown to UPS; packages handed off between carriers were returned as undeliverable.

**People don't have fixed addresses.** Houseboat owners can move between towns or countries. "Snowbird" clients alternate between two addresses seasonally. Divorced parents both want the dentist's appointment reminder. Japan Post's official romanisation file converts "JA ビル" to "JIEIEIBIRU" by phonetically expanding the Latin acronym into Japanese kana and then back — while the word "Hills" becomes "Hiruzu."

**An address can correspond to no recipient location at all.** PO boxes, Reply Paid addresses, locked bags, parcel lockers, GPO boxes, and community mail agents are all valid Australian postal addresses that describe a collection point, not a place. Santa's addresses in Canada (H0H 0H0), Germany, and the UK (XM4 5HQ, Reindeerland) are handled by actual postal services.

---

## If You Build This

1. **Use a structured data model, not a string.** An address is not `varchar(255)`. At minimum, model it as a collection of typed fields — and accept that the set of relevant fields varies by country. A flat in Tokyo needs ward, district, block, lot, and floor; a Costa Rican business needs a landmark description and a distance.

2. **Never validate against a single format or regex.** The USPS, Royal Mail, and most national postal authorities publish their own validation rules — and they contradict each other. If you must validate, do it per-country, and build in an escape hatch for addresses that are real but won't pass any validator.

3. **Treat postcodes as strings, never as integers.** Leading zeros are significant. 02109 ≠ 2109. Store and display them exactly as provided. The same applies to apartment numbers: 001 ≠ 1.

4. **Use a standards-based international format.** The Universal Postal Union's S42 standard and its successor work describes international address fields. Libraries like Google's libaddressinput implement per-country address formats and handle field ordering, required fields, and postal code formats for you. For Japan specifically, Japan Post's ken_all.csv is the canonical source — but use a pre-processed wrapper like `posuto` rather than parsing the raw file yourself.

5. **Allow addresses to change, and record when they changed.** Counties are abolished, streets are renamed, zip codes are reassigned, and a condo can change address four times in a decade. Store address history. Don't assume the address on file is still valid.

6. **Never assume an address uniquely identifies a building, or that a building has exactly one address.** The same postcode can cover multiple buildings with identical house numbers (CV12 8UE in Huddersfield covers seven different roads sharing house numbers). The same building can have multiple postcodes (DVLA Swansea). If you need to uniquely identify a property in Great Britain, use the Unique Property Reference Number (UPRN).

## Sources

- [Falsehoods about Addresses (mjt.me.uk)](https://www.mjt.me.uk/posts/falsehoods-programmers-believe-about-addresses/)
- [UK Address Oddities (Paul Plowman)](https://paulplowman.com/stuff/uk-address-oddities/)
- [Parsing the Infamous Japanese Postal CSV (dampfkraft)](https://www.dampfkraft.com/posuto.html)
- [Why doesn't Costa Rica use real addresses?](https://www.crcdaily.com/p/why-doesnt-costa-rica-use-real-addresses)
