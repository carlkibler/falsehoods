# Falsehoods About Dates and Time

> Time isn't a line, a time zone isn't an offset, and the clock can run backwards.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Unix time can literally go backwards.** When a leap second is added (it's happened 27 times since 1972), UTC gets an extra second — 23:59:60 — but Unix time has no room for it, so it *repeats* the last second. If you're at 23:59:60.50 UTC and wait half a second, your Unix timestamp goes *down*.

- **A KVM virtual machine's clock can fall hours behind reality without anyone noticing.** Older KVM on CentOS had no awareness it was virtualized: suspend the VM at 13:00, resume it at 15:00, and the guest clock still says 13:00. Depending on idle time, the drift could be enormous — and nothing complained until something broke.

- **"CST" identifies at least four different time zones.** Central Standard Time (USA), Cuba Summer Time, China Standard Time, and Central Standard Time (Australia) all share the abbreviation. Same goes for PST: Pakistan Standard Time and Pacific Standard Time. If you want unambiguous, use `America/Los_Angeles`.

- **Morocco suspends Daylight Saving Time in the middle of summer — for Ramadan.** DST is paused for roughly a month each year depending on the Islamic calendar, meaning a single calendar year in Morocco can contain *two* DST transitions in each direction.

- **Australia/Lord_Howe Island adjusts clocks by only 30 minutes for DST**, not an hour. The assumption that DST is always a one-hour shift is false on a currently-inhabited island.

- **December 28, 2014 belongs to week 1 of 2015.** ISO week numbering doesn't care about calendar years. Week 1 is defined as the week containing the first Thursday of the year, so days at the very end of December can legally belong to the *following* year's week 1.

- **Two subsequent calls to `getCurrentTime()` can return the same value, or the second can be *smaller* than the first.** Clock resolution, leap seconds, and NTP corrections all conspire against the assumption of strict monotonic increase. Building unique IDs from timestamps is a trap.

- **Storing a future event as UTC and a time zone is not enough to guarantee you can recover the correct wall time.** If the region's time zone rules change between when you store the event and when it occurs — and they do: the Olson/tz database received 10 updates in 2014 alone — converting back from UTC may produce the wrong local time.

---

## Where It Gets Complicated

### Days, Hours, and Seconds Aren't What You Think

A day is not always 24 hours. DST transitions produce 23-hour and 25-hour days (and historically, transitions of 30 minutes or 2 hours have existed). Even a "UTC day" isn't always 86,400 seconds: leap seconds produce days of 86,401 or, theoretically, 86,399 seconds.

Unix time sidesteps this by *assuming* every day is exactly 86,400 seconds and either repeating or omitting a timestamp to compensate. As of 2019, this means Unix time is running 27 seconds behind true UTC — the 27 inserted leap seconds are simply missing from the count. The formal definition is: *Unix time is the number of seconds since 1 January 1970 00:00:00 UTC, minus all leap seconds.*

Minutes are not reliably 60 seconds either. When a leap second is inserted, a minute has 61 seconds, and `23:59:60` is a valid timestamp. Negative leap seconds (a 59-second minute) haven't happened yet but are theoretically possible.

`Thread.sleep(1000)` does not guarantee sleeping for exactly 1,000 milliseconds, or even *at least* 1,000 milliseconds. And if a process runs for *n* seconds and then terminates, approximately *n* seconds will not necessarily have elapsed on the system clock — especially if the clock was adjusted mid-run.

### The Calendar Is a Patchwork

Months do not have 30 or 31 days — February alone can be 28 or 29. Years are not always 365 days. Leap years are not simply "every year divisible by 4"; the actual rule involves divisibility by 100 and 400.

The day of the month does not always advance from N to N+1. Historical calendar reforms introduced discontinuities. And the day before Saturday is not *always* Friday — at the International Date Line, flying across it can skip or repeat a day entirely.

There is not one calendar system. The Jewish calendar begins days at *sunset*, not midnight. ISO week numbers, Gregorian dates, and Julian dates coexist. The year zero exists in some systems and not others. The standard library may not support negative years or years above 10,000.

Merging dates carelessly — taking the month from one date and the day/year from another — can produce invalid results, even if both source dates were individually valid and both years were leap years.

### Time Zones Are Not Offsets

A time zone abbreviation is not a unique identifier. A UTC offset (`+05:30`) is not a time zone. A time zone is a named rule set (like `Asia/Kolkata`) that encodes the full history of offset changes, DST rules, and exceptions for a region.

Offsets between two time zones do not stay constant. They change when one region observes DST and the other doesn't, or when a government simply decides to change its offset — sometimes with very little notice. Two adjacent time zones are not necessarily within one hour of each other (the International Date Line is the extreme case). Time zones don't always differ by whole hours: India is UTC+5:30, Nepal is UTC+5:45, and some historical zones have differed by seconds.

You cannot determine a time zone from a city, a state, or a province alone. Indiana counties historically observed different rules. China spans five geographic time zones but uses only one (UTC+8). And GMT and UTC are *not* the same thing: UTC is a time standard; GMT is a time zone. Britain uses GMT in winter but switches to BST (UTC+1) in summer.

DST does not start and end on the same date everywhere, or even in the same half of the year. In the Southern Hemisphere, "summer time" begins in October and ends in March. Reading a client's clock and comparing to UTC is not a reliable way to determine their time zone — many time zones share the same offset.

The local time offset will not necessarily stay constant during office hours. Governments have changed DST rules mid-year. The Olson database had 10 releases in 2014; as of January 2015, Ubuntu 14's `tzdata` package was still on the June 2014 snapshot, missing the November 2014 `2014j` release.

### Ambiguous and Non-Existent Times

A local date-time combination is not always valid. In `Europe/Copenhagen`, `2014-03-30 02:20:42` does not exist — clocks spring forward from 02:00 to 03:00, vaporizing that hour.

A local time is not always unambiguous. In any region that falls back, the clock passes through the same hour twice. If someone tells you the local time was `2:17` during a fall-back transition, you cannot know which `2:17` they mean without additional information.

### Clocks, Servers, and Distributed Systems

The system clock is not always set to the correct time, or even close to it. It is not always ahead of or behind by a consistent number of seconds. The server clock and the client clock may differ by seconds, minutes, hours, or *decades* — and if they're out of sync, the delta is not necessarily consistent.

Two subsequent calls to `getCurrentTime()` may return the same value (limited resolution), or the second may be smaller than the first (NTP step correction, leap second). A timestamp does not reliably represent the time an event *actually* occurred — it represents what the clock said, which may be wrong.

A timestamp of high precision is not safely unique. Two events occurring in rapid succession on the same or different machines can receive identical timestamps.

Establishing a total ordering on timestamps across systems is not reliable. You cannot build an ordering on timestamps that stays meaningful once it leaves your own system.

### Human-Readable Formats

`05/07/11` is not universally understood. Is that May 7, 2011? July 5, 2011? July 11, 2005? The format is ambiguous across locales.

`24:12:34` is not necessarily an invalid time — some systems and standards permit hour values of 24 to indicate midnight of the following day.

Not every integer is a valid year. Not every year has four digits. If you have a date in `YYYY-MM-DD` format, the year part is not guaranteed to be exactly four characters for years before 1000 or after 9999. Displaying a datetime does not guarantee the displayed year matches the stored year — or that the difference is less than 2.

You cannot reliably parse a datetime format character by character without backtracking. Formats like `--12Z` or `P12Y34M56DT78H90M12.345S` are valid ISO 8601 constructs that will break naive parsers.

Two-digit years are not safely assumed to fall in 1900–2099.

---

## If You Build This

1. **Use IANA time zone names, never abbreviations or raw offsets.** `America/Los_Angeles` is unambiguous. `PST` is not. Store the IANA name alongside any timestamp that will be displayed in local time.

2. **Store future events as wall time + IANA zone, not just UTC.** UTC alone cannot survive a government changing its DST rules. Keep the original local time and zone name so you can recompute UTC after a rule update.

3. **Keep your tz database current and automate it.** The Olson database had 10 releases in 2014. Ubuntu 14's package lagged by five months. Pin to a library that ships its own tz data (e.g., Java's `java.time` with `tzdata` updates, or Noda Time on .NET), or build tz updates into your deployment pipeline.

4. **Never use wall-clock time for measuring elapsed duration.** Use a monotonic clock. Wall clocks can jump forward, jump backward (NTP correction, leap second, VM resume), or stall. `System.nanoTime()` in Java, `CLOCK_MONOTONIC` in POSIX, `time.monotonic()` in Python — these exist for a reason.

5. **Treat timestamps as approximate, not exact or unique.** Don't generate unique IDs from timestamps alone. Don't assume two calls to `now()` return different values. Don't assume the second call returns a larger value. Add a sequence number, a random component, or use UUIDs.

6. **Test at boundary conditions, not just "today."** DST transitions, leap years, week-year boundaries (December 28–January 3), and the end of a month are where date bugs live. A date function that works today may silently break on December 31 or at 01:59:59 on a spring-forward Sunday.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Time (Noah Sussman)](http://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time) · [archived copy](../archive/dates-and-time/01-falsehoods-about-time-noah-sussman.md)
- [More Falsehoods about Time (Noah Sussman)](http://infiniteundo.com/post/25509354022/more-falsehoods-programmers-believe-about-time) · [archived copy](../archive/dates-and-time/02-more-falsehoods-about-time-noah-sussman.md)
- [Falsehoods about Time and Time Zones (Creative Deletion)](https://www.creativedeletion.com/2015/01/28/falsehoods-programmers-date-time-zones.html) · [archived copy](../archive/dates-and-time/03-falsehoods-about-time-and-time-zones-creative-dele.md)
- [Falsehoods about Unix Time (Alex Chan)](https://alexwlchan.net/2019/05/falsehoods-programmers-believe-about-unix-time/) · [archived copy](../archive/dates-and-time/04-falsehoods-about-unix-time-alex-chan.md)
