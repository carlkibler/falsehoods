# Falsehoods About Geography

> Places don't have one name, borders move, and coordinates lie.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A 6,200-ton building in Zürich was physically moved 60 meters** to make way for railway tracks. Buildings do not move — except when they do, taking their address with them.

- **Switzerland has no capital.** The federal government sits in Bern, but Bern is not constitutionally the capital. If your database has a non-nullable `capital` field for every country, Switzerland will break it.

- **A dam in Geneva has two street addresses simultaneously** — one in Switzerland, one in France — because it spans the Rhône and therefore an international border. One building, two countries, two addresses, neither wrong.

- **All coordinates are not in latitude/longitude.** Plenty of real-world systems use entirely different coordinate reference systems, and handing someone a pair of numbers without specifying the CRS tells them almost nothing useful about where they are.

- **Knowing the lat/lon still doesn't tell you exactly where you are** — not without knowing which geodetic datum those coordinates reference. The same number pair means different physical spots depending on the datum.

- **The shortest path between two points is not a straight line** — at least not on a globe. On a sphere, the shortest route is a great-circle arc, which looks curved on most map projections and can take you over the Arctic when flying between continents.

- **Web Mercator distorts area so severely it's unsuitable for many purposes.** Greenland appears roughly the size of Africa on a Mercator projection; Africa is actually about 14 times larger.

- **Australian postcodes suggest a state — until they don't.** The postcode range 2000–2999 is New South Wales and 3000–3999 is Victoria, except Barooga, NSW sits directly across the river from Cobram, VIC, and both share postcode 3644.

- **100° is either a pleasant day or a medical emergency**, depending entirely on whether you're using Celsius or Fahrenheit — and there are additional temperature scales beyond those two. A bare temperature number carries no unit.

---

## Where It Gets Complicated

### Names Are Never Simple

**One place, many official names.** Geneva is simultaneously *Genève* (French), *Genf* (German), and *Ginevra* (Italian). All three are official. A single `name` column handles none of them correctly.

**One place, multiple official names in the same language.** The hill behind a flat in Zürich appears as "Äntlisberg" on Swiss military topographic maps and "Entlisberg" on city maps. Both are official. Neither is wrong. Your deduplication logic will pick one and silently discard the other.

**Place names predate spelling rules.** German has a rule that "ue" substitutes for "ü" — because the "üe" sound died out. Except the hill overlooking Zürich is named *Üetliberg*, which breaks that rule because the name is older than the rule.

**Place names use characters outside the country's standard character set.** One of the Kerguelen Islands (French territory) is called *Île de Croÿ* — and most French people have no idea how to type "ÿ". Meanwhile, Paris has a *Béla Bartók* square; the "ó" is not valid in French orthography. A country's character set is not a ceiling on what its place names contain.

**Romanization isn't consistent within a single city.** In Taipei, street name romanization historically used different rules depending on the quarter, so two streets in the same city could follow different official transliteration systems.

---

### Addresses Are Not What You Think

**Street addresses don't always contain street names.** In many remote parts of Europe, the hamlet name alone is considered a sufficient postal address. No street, no number.

**Not every address has a street number — or even a street.** This is true globally, not just in rural Europe. The W3C's internationalization guidance notes it explicitly.

**One building can have multiple valid addresses.** The Geneva dam example again: physically one structure, legally two addresses in two countries. Any unique-address constraint will fail.

**Language codes don't match country codes.** Japan's country code is `jp`; its language code is `ja`. Assuming `language = country_code.toLower()` is a reliable shortcut will produce silent, hard-to-debug errors.

---

### Maps, Projections, and Coordinate Systems

**There is no single "right" map projection.** Every projection trades off something — area, shape, distance, direction. Web Mercator is ubiquitous on the web but preserves none of those properties at a global scale. Choosing a projection is a domain decision, not a technical default.

**Scale bars don't work correctly on screen.** A scale printed on a paper map is fixed. On a screen, the physical size of a pixel varies by display, zoom level, and latitude (especially on Mercator projections). A "1:50,000" label on a web map is often meaningless.

**The earth is not round, and not even properly ellipsoidal.** It's an oblate spheroid as a first approximation, but the real surface (the geoid) is lumpy and irregular. GPS and mapping systems use specific mathematical models (datums) to approximate it, and which model you use changes where your coordinates actually point.

**The GPS satellites don't know where you are.** They broadcast signals; your receiver calculates its own position from those signals. The satellites are indifferent to your location.

**Caching background map tiles doesn't always improve things.** Stale cached tiles can show roads, borders, or place names that no longer exist — a subtle correctness problem that's easy to miss.

**The whole world is not thoroughly mapped.** Large areas have sparse, low-quality, or entirely absent coverage. "Just look it up" is not always an option.

**Geocoding (address → coordinates) is not easy.** Looking up a street address and getting back a reliable position involves ambiguity, data quality issues, and international variation in address formats that make it a genuinely hard problem.

**Offline maps are not as easy as Google Maps.** Serving, updating, and rendering map tiles offline involves significant infrastructure complexity that Google abstracts away entirely.

---

### Weather and Environmental Measurement

**Temperature is not a single number.** Air temperature, "feels like" temperature, humidity, wind speed, and sun exposure all interact. The Humidex (1965) and Heat Index (1979) exist precisely because raw air temperature is an inadequate proxy for human thermal comfort. An IoT sensor reporting "23°C" without context is telling an incomplete story.

**"Cold" and "hot" are relative to the observer.** What registers as cold in one culture is unremarkable in another. Localized weather descriptions carry cultural calibration that raw numbers don't.

**Seasons are hemisphere-dependent.** December is midsummer in the Southern Hemisphere. Calendars, holiday imagery, and seasonal UI metaphors built on Northern Hemisphere assumptions are wrong for roughly a third of the world's population.

---

## If You Build This

1. **Store place names in a structure that allows multiple values per language, and multiple languages.** A single `name` field is wrong from the start. Use a locale-keyed map and accept that "official" can be plural even within one language.

2. **Never store or transmit coordinates without their coordinate reference system (CRS) and datum.** A bare `(lat, lon)` pair is ambiguous. WGS84 is the most common baseline, but always make it explicit. Use established libraries (PROJ, GeoPandas, PostGIS) rather than rolling your own transforms.

3. **Don't assume addresses have a canonical structure.** No street name, no street number, multiple valid addresses for one building, cross-border addresses — all of these are real. Follow the W3C's internationalization guidance on address formats and treat address as a bag of optional fields, not a fixed schema.

4. **Pick your map projection deliberately, not by default.** Web Mercator is fine for tile display but wrong for area calculations, distance measurements, or anything where visual accuracy matters at scale. PostGIS, QGIS, and most serious GIS libraries let you reproject; use that capability.

5. **Always attach units to measurements.** Temperature without a scale (°C, °F, K), distance without a unit, or speed without specifying the unit system (the Met Office Android app famously displays wind speed in whatever unit you've set in preferences — without labeling it) are all bugs waiting to manifest.

6. **Treat country-level assumptions as hypotheses, not facts.** No capital? Switzerland. Postcodes crossing state lines? Barooga, NSW. Characters outside the "national" set? Béla Bartók in Paris. Every "this is always true for country X" rule has at least one exception; build in the flexibility to handle it before you discover the exception in production.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Geography (wiesmann)](https://wiesmann.codiferes.net/wordpress/archives/15187) · [archived copy](../archive/geography/01-falsehoods-about-geography-wiesmann.md)
- [Falsehoods about Maps (atlefren)](http://www.atlefren.net/post/2014/09/falsehoods-programmers-believe-about-maps/) · [archived copy](../archive/geography/02-falsehoods-about-maps-atlefren.md)
- [Falsehoods about Weather (shkspr.mobi)](https://shkspr.mobi/blog/2024/06/falsehoods-programmers-believe-about-weather/) · [archived copy](../archive/geography/03-falsehoods-about-weather-shkspr-mobi.md)
