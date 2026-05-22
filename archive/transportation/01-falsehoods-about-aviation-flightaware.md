# Falsehoods about Aviation (FlightAware)

> **Original:** <https://flightaware.engineering/falsehoods-programmers-believe-about-aviation/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Programmers Believe About Aviation

Angle of Attack

a blog by the engineers @

At FlightAware, our software needs to gracefully handle all sorts of weird and wonderful situations. While we as engineers might hope for aviation data to be clean and well-standardized, the real world is messy.

There are a lot of assumptions one could make when designing data types and schemas for aviation data that turn out to be inaccurate. In the spirit of Patrick McKenzie’s classic piece on names , here are some false assumptions one might make about aviation. While many of these are simply common misconceptions, some of these assumptions have bitten our customers at various points, and others have caused issues in our own systems over the years.

Together they are illustrative of the situations that Hyperfeed, our flight tracking engine, is responsible for correctly interpreting in order to provide a clean and consistent data feed for our website, apps, and APIs.

Flights

Flights depart from a gate

Flights that depart from a gate only leave their gate once

Flights depart within a few hours of the time they were scheduled to

Flights depart within a day of the time they were scheduled to

Flights have schedules

Flights take off and land at airports

Airplanes (excluding helicopters) take off and land at airports

Flights are at most a dozen or so hours long

Okay, they’re at most a few days long

Flights are identified by a flight number consisting of an airline’s code plus some numbers, like UAL1234

Flights are identified by either an airline flight number like UAL1234, or the aircraft’s registration like N12345, B6459, or FHUVL

A flight identifier like B6459 is unambiguously either a registration ( B–6459 ), an airline flight number ( B6 459 ), or something else

Flights don’t have multiple flight numbers

Flights with multiple flight numbers unambiguously have one “main” flight number

A particular trip’s flight number(s) never change

The flight number shown on your ticket is what the pilots and air traffic control are using

Flights don’t use the code of some entirely unrelated airline in their flight identifier

No flights use the same flight number within a day

Surely at least no flights use the same flight number at the same time?

Okay fine, separate flights from the same major passenger airline that depart within a few minutes of each other would not both have the same flight number… right?

Airports

Airports never move

Terminal and gate numbers have a consistent naming scheme

Each runway is only used by one airport

Airports always have two unique identifiers: a 4-letter Civil Aviation Organization (ICAO) code and a 3-letter International Air Transport Association (IATA) code

Airports always have three unique identifiers: an ICAO, an IATA, and a regionally-administered location code

The U.S. Department of Transportation assigns one canonical code to each airport it oversees

No airports have multiple IATA codes

The ICAO code for airports in the U.S. always starts with the letter K

For U.S. airports whose ICAO code starts with K, the last three letters are its IATA code

You can tell which geographic region an airport is in from its ICAO code

Everything that has an IATA code is an airport

Everything that has an ICAO code is on Earth

Airports have at least one well-known identifier of some sort

Airlines

No two airlines share the same IATA code

No airlines use multiple IATA or ICAO codes

You can tell what airline is operating a flight by looking at the physical aircraft

Airlines assign flight numbers to specific routes

Airlines only assign flight numbers to flights they operate

Airlines only assign flight numbers to flights

Navigation

Waypoint names are unique

There is one agreed-upon definition of altitude

Flight information from Air Navigation Service Providers is accurate

Okay, pretty accurate; they wouldn’t indicate that a flight had departed unless it really had

If they indicate that a flight plan has been cancelled, then that flight definitely isn’t going to operate — it wouldn’t simply be due to someone editing the flight plan

At least their radar data accurately identifies each aircraft

Radars with overlapping coverage areas agree on the location of a target they can both see

If they send us a flight plan with the ICAO identifier of a known airport as the destination, then there must have been some intention of arriving there

If an aircraft diverts to another destination, it won’t divert again

Transponders and ADS-B

ADS-B messages only come from aircraft

ADS-B messages only come from aircraft and airport service vehicles

ADS-B messages only come from vehicles of some kind

The GPS position in ADS-B messages is accurate

The GPS position in ADS-B messages is accurate within some known uncertainty radius

ADS-B messages always include the correct flight identification

Transponders are correctly programmed to indicate the aircraft type (helicopter, airplane, balloon, etc)

You can always determine a aircraft’s registration number from its ADS-B messages

Transponders are programmed with the correct Mode S address

All of the transponders on a single aircraft are programmed with the same Mode S address

Nobody will ever set their flight identification to weird things like NULL

People will remember to update the transponder when the aircraft’s registration changes

ADS-B messages are always received exactly as they were transmitted

No one ever transmits false ADS-B messages

Transponders never break and rodents never chew through cables

Thanks to my colleagues who contributed to or reviewed this collection of falsehoods: Mark Duell, Paul Durandt, Karina Elizondo, Matt Higgins, Thomas Kyanko, Nathan Reed, and Amy Szczepanski.

Ben Burwell

Ben is a Senior Software Engineer on the Flight Tracking team.

Share Twitter Facebook LinkedIn Email

Show Comments

Back to home

flightaware.com

Terms of Use

Privacy Policy
