# Falsehoods About Dates and Time

> Time isn't a line, a time zone isn't an offset, and the clock can run backwards.

## The Big Surprises

- **Unix time can go backwards.** Every time a leap second is added — 27 times as of 2019 — Unix timestamps repeat. At 23:59:60.50 UTC, if you wait half a second, the Unix timestamp decreases by half a second. Two different UTC moments share the same Unix timestamp.

- **A minute can last more than an hour.** This isn't a joke: older versions of KVM on CentOS had no awareness they were running inside a VM. When the host suspended the VM at 13:00 and resumed it at 15:00, the guest's system clock still said 13:00. Every idle period silently ate time. The VM's clock could drift by hours without any error.

- **"CST" is not a unique time zone.** It stands for Central Standard Time (USA), Cuba Summer Time, China Standard Time, *and* Central Standard Time (Australia). Same abbreviation, four wildly different offsets. If you want to identify "Pacific time in the USA" unambiguously, you need `America/Los_Angeles`.

- **Australia/Lord_Howe observes DST in 30-minute increments.** The widespread assumption that DST always shifts by exactly one hour is wrong. Lord Howe Island advances its clocks by only 30 minutes. Historical examples go further — some jurisdictions have shifted by 2 hours.

- **Morocco suspends DST in the middle of summer.** During Ramadan, Morocco cancels its summer time observance for a month, then resumes it. DST that starts, stops, and restarts within a single "summer" is not a theoretical edge case.

- **December 28, 2014 belongs to week 1 of 2015.** ISO week numbering means "week 1 of year N" can contain days from the previous December. The assumption that week 1 starts in January is simply false.

- **A timestamp for a future event stored in UTC can still be wrong.** If the time zone rules for that location change between when you store the event and when it occurs — which happened 10 times in 2014 alone, per the Olson database — converting back from UTC to local time gives the wrong wall-clock time.

- **Two subsequent calls to `getCurrentTime()` can return the same result, or the second can be *smaller* than the first.** Both are real behaviors, not theoretical ones. Leap seconds cause the repeat-or-skip; clock corrections and NTP adjustments cause the backwards jump.

---

## Where It Gets Complicated

### Calendar Arithmetic

The calendar is not a clean numeric sequence. Months have 28, 29, 30, or 31 days — and which one depends on the year, the calendar system, and sometimes the hemisphere. February is not always 28 days. Years are not always 365 days, nor are they always 365 or 366 days — some calendar systems diverge entirely from the Gregorian model (in the Jewish calendar, days start at sunset, not midnight).

Leap years are not simply "every year divisible by 4." The full Gregorian rule involves divisibility by 100 and 400, and even that rule has exceptions in some historical contexts. Non-leap years can contain leap days in edge cases involving calendar transitions.

The day of the month does not always advance from N to N+1. Historical calendar reforms introduced discontinuities — entire days were skipped. The assumption that each calendar date is followed by the next in sequence is false by historical precedent.

Merging two dates by taking the month from one and the day/year from another does not reliably produce a valid date — even if both source years are leap years.

### Hours, Days, and Weeks

There are not always 24 hours in a day. DST transitions create 23-hour and 25-hour days. Some historical DST rules have created even stranger lengths. Even in UTC, leap seconds mean some days have 86,401 seconds and some could theoretically have 86,399.

A 24-hour period does not always begin and end in the same day, week, month, or year. A week does not always begin and end in the same month or year.

The time `23:59:60` is not always invalid — it is the correct representation of a leap second. The time `2014-03-30 02:20:42` in `Europe/Copenhagen` does not exist at all, because DST jumped the clock forward from 02:00 to 03:00, deleting that hour.

Conversely, `2:17` during the autumn DST rollback is ambiguous: the clock passes 2:17 twice, and without additional context you cannot know which occurrence someone means.

Days do not universally begin at midnight. In the Jewish calendar, days begin at sunset.

Weeks do not universally start on Monday. The weekend is not universally Saturday and Sunday. Holidays do not always span whole days.

### Time Zones

Time zones are not just offsets. The offset for a given zone changes with DST, with government decisions, and with historical reforms. In 2014, the Olson/IANA timezone database was updated 10 times. As of January 2015, Ubuntu 14's `tzdata` package still contained data only from June 2014, missing the `2014j` release from November.

Time zones do not always differ by whole hours. Nepal is UTC+5:45. India is UTC+5:30. Some zones differ by 15-minute increments. The assumption that adjacent time zones are at most one hour apart is dangerous for avionics crossing the International Date Line.

You cannot determine a time zone from a city, state, or province. You cannot determine it from a country alone. You need an explicit IANA identifier like `America/Los_Angeles`.

GMT and UTC are not the same. Britain does not always use GMT — it uses BST (British Summer Time) during summer, which is UTC+1.

The local time offset does not stay constant during office hours. DST transitions happen at 2:00 AM in many jurisdictions — well within a business day in some edge cases — and government-mandated offset changes can happen with very little notice.

DST does not begin and end at the same time in every time zone, or even in the same hemisphere. Southern-hemisphere countries like Australia start DST in October and end it in March. The assumption that DST runs from spring to fall is northern-hemisphere parochialism.

### Unix Time and System Clocks

Unix time is not the number of seconds since January 1, 1970 00:00:00 UTC. It is that count *minus leap seconds*. As of 2019, 27 leap seconds have been inserted, all of which are absent from Unix time.

When a leap second is added, Unix time repeats the last second of the day. When a leap second is removed (not yet happened in practice, but defined behavior), Unix time skips a second — meaning if you wait one second starting at 23:59:58 UTC on such a day, the Unix timestamp advances by two.

`Thread.sleep(1000)` does not sleep for exactly 1000 milliseconds, and it does not guarantee sleeping for *at least* 1000 milliseconds. System clock corrections, NTP adjustments, and scheduler behavior all interfere.

The system clock is not always correct. It is not always approximately correct. It is not always off by a consistent amount. Server and client clocks can differ by decades — not just seconds — and that difference need not be consistent over time.

A timestamp does not necessarily represent the time an event actually occurred. A timestamp of high precision is not unique. Two date objects created in adjacent lines of code may not represent the same moment (a reliable Heisenbug generator). You cannot wait for exactly `HH:MM:SS` by sampling once per second — you may sample right over it.

The precision of a `getCurrentTime()` return type is not the same as the precision of the underlying function. If you convert a millisecond-precision timestamp to second precision, you cannot safely discard the fractional part — not even if it is less than 0.5.

Unix time is not completely ignorant of everything except seconds — its handling of leap seconds is itself a form of encoding calendar knowledge, just broken calendar knowledge.

### Timestamps, Formats, and Ordering

`05/07/11` is not a universally understood date format. It could be May 7, 2011; July 5, 2011; May 7, 1911; or July 11, 2005, depending on locale and convention.

Timestamps are not always in seconds since epoch. They are not always in the same format. They do not always have the same precision. You cannot establish a total ordering on timestamps that is meaningful outside your own system.

The difference between two timestamps is not an accurate measure of elapsed time if any leap seconds occurred between them, or if the system clock was adjusted.

Two-digit years are not safely assumed to fall between 1900 and 2099. Not every integer is a valid year — the standard library may not support negative years or years above 10,000. A date displayed with a four-character year field may not actually have four characters if the year is outside the expected range.

The format `P12Y34M56DT78H90M12.345S` (an ISO 8601 duration) and `--12Z` (a truncated date) are real formats you may encounter. W3C-published algorithms for adding durations to dates do not work in all cases.

There is no single timestamp for a given date and time that is unambiguous — a date/time combination without an explicit time zone offset can refer to many different moments.

### Relativistic and Exotic Edge Cases

Time does not pass at the same rate at the top of a mountain and at the bottom of a valley — general relativity is measurable with modern atomic clocks. All measurements on a given clock occur within a single frame of reference, but different clocks are in different frames. As Bruce Sterling noted, software running on a spacecraft orbiting a black hole would experience time dilation. This is not purely theoretical: GPS satellites require relativistic corrections to stay accurate.

---

## If You Build This

1. **Store times in UTC; store the IANA time zone identifier separately.** Never store only an offset. Offsets change. `America/Los_Angeles` does not. When displaying local time, convert at render time using the stored zone identifier and a current timezone database.

2. **Use a well-maintained, IANA-backed library.** Do not roll your own. Do not trust a library just because it exists — many were written by people who didn't know the domain, and they work fine until they don't. For Elixir, Java, Python, and most modern languages, there are libraries that consume the IANA `tzdata` directly. Keep that data updated: the OS package may lag by months (Ubuntu 14's `tzdata` was 5 months behind as of January 2015).

3. **Never store a future event as UTC alone.** Store the intended wall-clock time and the IANA zone name together. If the government changes the zone rules before the event occurs — which happened 10 times in 2014 — you can recompute the correct UTC time. If you only stored UTC, you're stuck with the wrong answer.

4. **Treat timestamps as approximations, not ground truth.** Do not assume two adjacent `getCurrentTime()` calls return different values, or that the second is larger. Do not assume `Thread.sleep(1000)` sleeps for exactly or at least 1000 ms. Do not assume a timestamp represents when something actually happened. Build systems that tolerate clock skew, repeated timestamps, and backwards jumps.

5. **Never parse or display dates with hand-rolled string logic.** `05/07/11` is not a date — it's an ambiguous string. Use ISO 8601 (`YYYY-MM-DD`) for interchange. Be aware that years outside 0–9999 may break format assumptions, and that displaying a stored datetime can silently change the year if the time zone conversion crosses a year boundary.

6. **Test against real calendar edge cases, not just "normal" dates.** Run tests against DST transition days, leap days, leap seconds, year boundaries, and ISO week-year boundaries (December 28 is in week 1 of the following year). The fact that a date-based function works today does not mean it will work on any date.

## Sources

- [Falsehoods about Time (Noah Sussman)](http://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time)
- [More Falsehoods about Time (Noah Sussman)](http://infiniteundo.com/post/25509354022/more-falsehoods-programmers-believe-about-time)
- [Falsehoods about Time and Time Zones (Creative Deletion)](https://www.creativedeletion.com/2015/01/28/falsehoods-programmers-date-time-zones.html)
- [Falsehoods about Unix Time (Alex Chan)](https://alexwlchan.net/2019/05/falsehoods-programmers-believe-about-unix-time/)
