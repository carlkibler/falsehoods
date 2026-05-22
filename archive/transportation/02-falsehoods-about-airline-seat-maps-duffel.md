# Falsehoods about Airline Seat Maps (Duffel)

> **Original:** <https://duffel.com/blog/falsehoods-about-seat-maps>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods Programmers Believe About Aircraft Seat Maps \| Duffel

Engineering Falsehoods Programmers Believe About Aircraft Seat Maps

Michał Szewczak · November 2021

At Duffel, we are working towards making the complex world of selling flights accessible to anyone. When designing our Seat Map API, we’ve investigated hundreds of real seat maps along with multiple existing seat map display systems. The findings were quite surprising!

In the spirit of the classic Falsehoods Programmers Believe About Names blog post, here are 12 assumptions seat map display designers often make about seat maps. All of these assumptions are wrong!

Seat map examples are courtesy of SeatGuru .

The same aircraft model always has the same seat map

Airlines are free to outfit their aircraft as they please.

Examples

British Airways A321

American Airlines A321

The same aircraft model, operated by the same airline, always has the same seat map

Sometimes, even the same airline will outfit the same model of aircraft differently for different purposes.

Examples

British Airways A321 Domestic

British Airways A321 European

The order of cabins in the aircraft is always: First, Business, Premium Economy, Economy

Not necessarily! Airlines will prioritise efficient use of cabin space over keeping the ordering. For example, the British Airways Boeing 747-400 Layout 1 has First, World Traveller Plus (Premium Economy), Club World (Business), World Traveller (Economy) from front to back.

Aircraft seats always face forward

Half of Business class seats in the cabin often face backwards. Business Class and First Class seats can also be positioned at an angle.

Example

British Airways Boeing 747-400 Layout 1

Seat rows are numbered with consecutive numbers

Some airlines skip row numbers, especially row number 13.

Example

Ryanair Boeing 737-800

Seats in a row are numbered with consecutive letters

The “I” letter is often not used to avoid confusing it with the number 1.

Example

Virgin Atlantic Boeing 747-400

Seat rows always have the same number of seats in a single cabin

Sometimes, seats are missing, especially near emergency exits or in the tail section.

Example

British Airways Airbus A321neo Layout 2

The seat in front or behind always has the same letter

Sometimes, when there are fewer seats in a row, the letters of the aisle and window seats are preserved, and only middle seats are removed. This is often the case in Business Class or when there are fewer seats in a tail section.

Lots of seat map displays make the mistake of aligning the seats in columns by letter, which leads to misrepresentation of what the row really looks like!

Example

American Airlines Boeing 777-200

Toilets and galleys are always placed before or after blocks of seats

Sometimes toilets and galleys are placed where seats would normally be. This often occurs in the tail section which has narrower sides but can still provide more seats in the middle.

Example

American Airlines Boeing 777-200

Seats are aligned in rows in a cabin

In wide-body aircrafts, the seats between the aisles are often “staggered” in respect to the seats near the windows in the same “row” to fill cabin space more efficiently.

Example

American Airlines Boeing 787-8

Seats are aligned in columns in a cabin

Sometimes, when a seat is missing in a row, the remaining seats will be shifted by half a seat to keep them centered.

Example

American Airlines Airbus A330-200

Seats are aligned in columns in a cabin or shifted half a seat

Not even that! In tail sections, rows with missing seats can start out aligned with the other rows and slowly converge towards being shifted half a seat across multiple rows.

Example

Eurowings Airbus A330-200

Duffel Seat Map API

Aircraft seat maps are very complex. At Duffel, we have a Seat Map API which allows you to display complex seat arrangements like these in a very simple and intuitive way. See the documentation for more information.

We have also have a drop-in Seat Selection Component which you can include in your website directly and we’ll handle all the displaying of seat maps for you. Learn more about Duffel Components in our blog post here .

Share on Linkedin Share on Twitter

Michał Szewczak

Latest posts

Product Updates

Introducing Duffel Cars: one API for flights, stays and now car rentals

Duffel Cars is here. Businesses can now embed car rentals from 40 global providers across 40,000+ locations in 200 countries, alongside Flights and Stays, through the same Duffel API — making Duffel a more complete one-stop shop for embedded travel.

Steve Domin · April 2026

Customer Stories

Rippling chooses Duffel to power Rippling Travel

Rippling chose Duffel to power Rippling Travel, bringing flights and stays into its Spend Management suite so employees can book trips easily while finance teams manage travel spend in real time.

Steve Domin · July 2025

API

Data-Driven Travel: Using Analytics from the Duffel API to Make Smarter Business Decisions

Our latest blog post explores how companies and developers can use this tool to make smarter business decisions. Learn how to leverage booking data, implement dynamic pricing models, and use predictive modeling for future planning.

James Wair · May 2024

Product Updates

Introducing Duffel Cars: one API for flights, stays and now car rentals

Duffel Cars is here. Businesses can now embed car rentals from 40 global providers across 40,000+ locations in 200 countries, alongside Flights and Stays, through the same Duffel API — making Duffel a more complete one-stop shop for embedded travel.

Steve Domin · April 2026

Customer Stories

Rippling chooses Duffel to power Rippling Travel

Rippling chose Duffel to power Rippling Travel, bringing flights and stays into its Spend Management suite so employees can book trips easily while finance teams manage travel spend in real time.

API

Data-Driven Travel: Using Analytics from the Duffel API to Make Smarter Business Decisions

Our latest blog post explores how companies and developers can use this tool to make smarter business decisions. Learn how to leverage booking data, implement dynamic pricing models, and use predictive modeling for future planning.
