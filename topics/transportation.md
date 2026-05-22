# Falsehoods About Transportation

> Aviation data is messier than the planes, and a seat map is not a grid.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Two flights from the same major airline can depart within minutes of each other and share the same flight number.** Not a data error — it actually happens.

- **A seat map is not a grid.** On the American Airlines Boeing 787-8, Business Class seats between the aisles are *staggered* relative to window seats in the same row. Aligning by column letter produces a lie.

- **The British Airways Boeing 747-400 Layout 1 arranges its cabins as: First, Premium Economy, Business, Economy** — front to back. Premium cabins do not always stack neatly toward the nose.

- **Something with an ICAO code doesn't have to be on Earth.** ICAO assigns location indicators to things that are emphatically not terrestrial airports.

- **ADS-B messages — the system air traffic control relies on to track aircraft — can be transmitted by things that are not aircraft, not vehicles, and not anything moving at all.** Someone has also deliberately set their flight identification to `NULL`.

- **The flight number on your boarding pass may not be what the pilots or air traffic control are using.** Codeshare arrangements mean the operating carrier can be flying under a completely different airline's code, and the cockpit crew may be using yet another identifier entirely.

- **On the American Airlines Boeing 777-200, toilets and galleys are placed where seats would normally be** — mid-cabin, not at the ends. Lavatories do not only appear before or after seat blocks.

- **Airports move.** An airport's location is not a static fact — it has already changed in the real world.

- **Ryanair's Boeing 737-800 skips row 13.** Seat row numbers are not guaranteed to be consecutive — and if you're computing row count from the highest row number, you're off by at least one.

- **The letter "I" is omitted from seat columns** on the Virgin Atlantic Boeing 747-400 to avoid confusion with the number 1. Column letters are not a clean A–Z sequence.

---

## Where It Gets Complicated

### Flight Identity

A flight is not a simple, stable, unique thing.

**Flight numbers aren't unique.** The same flight number can appear multiple times in a single day, and two flights from the same airline can share a number while departing minutes apart. This is not a data quality problem — it's a feature of how airlines operate.

**A single flight can have multiple flight numbers simultaneously**, and there's no unambiguous "main" one. Codeshare arrangements mean an American Airlines flight might also be listed as a British Airways flight and a Qantas flight, all at once.

**The identifier `B6459` is genuinely ambiguous.** It could be aircraft registration B-6459, or it could be flight number B6 459 (JetBlue flight 459). You cannot tell from the string alone.

**Flight numbers change.** The number on your ticket when you booked may not be the number on your ticket at the gate, and neither may match what the crew filed in the flight plan.

**Flights don't always use their own airline's code.** A flight can operate under the IATA code of a completely unrelated airline — not just a partner, but an entirely different carrier.

### Schedules and Timing

**Flights don't always depart from gates.** Remote stands, tarmac boarding, and general aviation operations all exist.

**Flights can sit at the gate more than once before departure.** A plane that pushes back and then returns is not the same event as a departure.

**Flights can be delayed by more than a day**, making "scheduled departure date" an unreliable key. Flights also exist with no schedule at all — charter and general aviation operations are common examples.

**Flight duration has no firm upper bound.** While most commercial flights are under 18 hours, some operations legitimately run longer, and "a few days" is not an absurd outer limit for certain ferry flights or unusual operations.

### Airports and Identifiers

**Airports can have no well-known identifier of any kind.** Small strips and private fields may lack both ICAO and IATA codes.

**Multiple IATA codes can belong to the same airport**, and the same airport can have multiple ICAO codes. Neither system is a clean bijection.

**Not everything with an IATA code is an airport.** Train stations and bus terminals in some markets have IATA codes. Heliports do too.

**The "K-prefix" rule for U.S. airports has exceptions.** Not every U.S. airport's ICAO code starts with K, and for those that do, the last three letters are not always the IATA code.

**ICAO codes don't reliably indicate geography.** Knowing the first letter doesn't reliably tell you what country or region you're dealing with.

**Runways can be shared between airports.** Two separate airports can use the same physical runway.

**The U.S. DOT, ICAO, and IATA can all assign different codes to the same airport**, and none of them is guaranteed to agree with the others or with local signage.

### Airlines

**Two airlines can share the same IATA code.** This has happened historically and creates real ambiguity in historical data.

**A single airline can have multiple IATA or ICAO codes**, especially after mergers, rebrands, or regional subsidiary arrangements.

**The livery on the plane doesn't tell you who's operating the flight.** Wet leases, codeshares, and ACMI arrangements mean the aircraft you board may be owned and crewed by an airline whose name appears nowhere on your ticket.

**Airlines assign flight numbers to things that aren't flights** — gate holds, operational placeholders, and other administrative constructs can appear in flight number spaces.

### Navigation and Data Accuracy

**Waypoint names are not unique.** The same five-letter waypoint name can exist in multiple regions of the world, and a flight plan referencing one doesn't tell you which one without additional context.

**"Altitude" has no single agreed definition.** Pressure altitude, density altitude, GPS altitude, and height above ground level are all different numbers, and systems that conflate them will produce errors.

**Air Navigation Service Providers make mistakes.** They have indicated flights as departed when they haven't, cancelled flight plans that then operated normally, and misidentified aircraft on radar. Treating ANSP data as ground truth will eventually burn you.

**Overlapping radar systems can disagree on where the same aircraft is.** Two radars with coverage of the same airspace can report different positions for the same target.

**Aircraft divert more than once.** A flight that has already diverted to an alternate can divert again from that alternate.

### Transponders and ADS-B

**ADS-B messages come from non-aircraft sources.** Ground vehicles, fixed installations, and other transmitters emit ADS-B. Some of these are airport service vehicles; some are not vehicles at all.

**GPS positions in ADS-B messages can be wrong** — not just imprecise, but actively incorrect, with no reliable uncertainty radius attached.

**Transponders can be programmed with the wrong aircraft type**, misidentifying a helicopter as a fixed-wing aircraft or vice versa.

**Multiple transponders on the same aircraft can be programmed with different Mode S addresses**, which are supposed to be unique aircraft identifiers.

**Transponders are sometimes never updated when an aircraft changes registration.** An aircraft that was re-registered years ago may still be broadcasting its old identity.

**Someone has set their ADS-B flight identification to `NULL`.** This is not hypothetical.

**False ADS-B messages are transmitted.** Spoofing is real, and your system will see it.

**Transponders fail, and rodents chew through cables.** Hardware faults are not edge cases; they are scheduled maintenance items.

### Seat Map Geometry

**Seat rows are not always the same width.** Near emergency exits and in tail sections, rows have fewer seats. The British Airways Airbus A321neo Layout 2 is a concrete example.

**When a row loses a middle seat, the remaining seats keep their original letters.** On the American Airlines Boeing 777-200, the aisle and window seat letters are preserved and the middle is simply absent — aligning seats by column letter produces gaps that look like misaligned rows.

**Seats shift by half a position across rows in tail sections.** On the Eurowings Airbus A330-200, rows start aligned with the rest of the cabin and gradually converge toward a half-seat offset across multiple rows. There is no clean column grid here at all.

**Seats face backward.** Business and First Class cabins routinely include rear-facing seats. The British Airways Boeing 747-400 Layout 1 is a well-documented example.

**Cabin order is not First → Business → Premium Economy → Economy.** The same British Airways 747-400 Layout 1 runs First, World Traveller Plus (Premium Economy), Club World (Business), World Traveller (Economy) from nose to tail.

---

## If You Build This

1. **Never use flight number + date as a unique key.** Two flights can share a flight number on the same day, even from the same airline. Use the combination of operating carrier, flight number, departure airport, and scheduled departure time — and even then, build in collision handling.

2. **Treat all airport and airline identifiers as potentially ambiguous and context-dependent.** Store the source system alongside every code (ICAO, IATA, DOT, local). Never assume the last three letters of a K-prefixed ICAO code are the IATA code, and never assume an IATA code refers to an airport.

3. **Do not model a seat map as a 2D grid indexed by row number and column letter.** Row numbers skip (no row 13 on Ryanair's 737-800), column letters skip (no "I" on Virgin Atlantic's 747-400), rows have variable widths, and seats shift by fractional positions across rows. Represent each seat as an independent object with explicit coordinates or a relative position, not a derived grid address.

4. **Validate ADS-B data against multiple sources before trusting it.** Position, aircraft type, registration, and flight identification can all be wrong simultaneously. Cross-reference Mode S addresses against registration databases and flag anomalies rather than accepting them silently.

5. **Build your flight tracking pipeline to handle the same physical flight appearing under multiple flight numbers, and the same flight number appearing on multiple physical flights.** Hyperfeed at FlightAware exists precisely because naive one-to-one mappings fail constantly in production.

6. **When displaying seat maps, render from explicit seat data, not inferred geometry.** Use an API or data model that gives you the actual position and properties of each seat — facing direction, offset, presence/absence — rather than reconstructing layout from row/column pairs. Duffel's Seat Map API and SeatGuru's data both demonstrate that inference from sparse metadata reliably produces wrong layouts on real aircraft.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Aviation (FlightAware)](https://flightaware.engineering/falsehoods-programmers-believe-about-aviation/) · [archived copy](../archive/transportation/01-falsehoods-about-aviation-flightaware.md)
- [Falsehoods about Airline Seat Maps (Duffel)](https://duffel.com/blog/falsehoods-about-seat-maps) · [archived copy](../archive/transportation/02-falsehoods-about-airline-seat-maps-duffel.md)
