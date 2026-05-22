# More Falsehoods about Time (Noah Sussman)

> **Original:** <http://infiniteundo.com/post/25509354022/more-falsehoods-programmers-believe-about-time>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

More falsehoods programmers believe about time;…: @noahsussman: Infinite Undo

Infinite Undo!

Data-Mining In The Git Log • Falsehoods About Time

Software As Narrative

How-To Articles

Devops Reading List

CC Sharealike © 2025 by Noah Sussman

Jun 20th Wed

More falsehoods programmers believe about time; “wisdom of the crowd” edition

A couple of days ago I decided to write down some of the things I’ve learned about testing over the course of the last several years. In the course of enumerating the areas that benefit most from testing, I realized that I had accumulated a lot of specific thoughts about how we as programmers tend to abuse the concept of time.

So I wrote another post called “ falsehoods programmers believe about time ,” where I included 34 misconceptions and mistakes having to do with both calendar and system time. Most of these were drawn from my immediate experience with code that needed to be debugged (both in production and in test).

A great many of the false assumptions listed were my own. Especially “time stamps are always in seconds since epoch” and “the duration of a system clock minute is always pretty close to the duration of a wall clock minute.” Whoa did I ever live to regret my ignorance in those two cases! But hey, apparently I’m not the only one who has run into (or inadvertently caused) such issues. A lot of people responded and shared similar experiences.

UPDATED: I’d like to say a big thanks to all the Redditors who have been discussing this post recently. I have read every single one of your comments :) and learned about fun stuff like the year zero and International Atomic Time .

I’d like to say an enormous thanks to everyone who contributed to the comment threads on BoingBoing and Hacker News as well as Reddit and MetaFilter and to everyone on Twitter who shared their strange experiences with time. In those thousand or so comments and tweets, there were a lot of suggestions as to “falsehoods 35 to 35+n.”

First and foremost was the omission of the false assumption that “time always moves forward,” as pointed out by Technomancy and many others. I enjoyed reading all the suggested falsehoods. When I was done reading, I realized that taken as a whole, these constitute a whole other blog post. So I collected some of your suggested falsehoods into a post and here it is.

All of these assumptions are wrong

All of these falsehoods were suggested by people who commented on the original post . Each contributor is credited below.

The offsets between two time zones will remain constant.

OK, historical oddities aside, the offsets between two time zones won’t change in the future.

Changes in the offsets between time zones will occur with plenty of advance notice.

Daylight saving time happens at the same time every year.

Daylight saving time happens at the same time in every time zone.

Daylight saving time always adjusts by an hour.

Months have either 28, 29, 30, or 31 days.

The day of the month always advances contiguously from N to either N+1 or 1, with no discontinuities.

There is only one calendar system in use at one time.

There is a leap year every year divisible by 4.

Non leap years will never contain a leap day.

It will be easy to calculate the duration of x number of hours and minutes from a particular point in time.

The same month has the same number of days in it everywhere!

Unix time is completely ignorant about anything except seconds.

Unix time is the number of seconds since Jan 1st 1970.

The day before Saturday is always Friday.

Contiguous timezones are no more than an hour apart. (aka we don’t need to test what happens to the avionics when you fly over the International Date Line)

Two timezones that differ will differ by an integer number of half hours.

Okay, quarter hours.

Okay, seconds, but it will be a consistent difference if we ignore DST.

If you create two date objects right beside each other, they’ll represent the same time. (a fantastic Heisenbug generator)

You can wait for the clock to reach exactly HH:MM:SS by sampling once a second.

If a process runs for n seconds and then terminates, approximately n seconds will have elapsed on the system clock at the time of termination.

Weeks start on Monday.

Days begin in the morning.

Holidays span an integer number of whole days.

The weekend consists of Saturday and Sunday.

It’s possible to establish a total ordering on timestamps that is useful outside your system.

The local time offset (from UTC) will not change during office hours.

Thread.sleep(1000) sleeps for 1000 milliseconds.

Thread.sleep(1000) sleeps for \>= 1000 milliseconds.

There are 60 seconds in every minute.

Timestamps always advance monotonically.

GMT and UTC are the same timezone.

Britain uses GMT.

Time always goes forwards.

The difference between the current time and one week from the current time is always 7 \* 86400 seconds.

The difference between two timestamps is an accurate measure of the time that elapsed between them.

24:12:34 is a invalid time

Every integer is a theoretical possible year

If you display a datetime, the displayed time has the same second part as the stored time

Or the same year

But at least the numerical difference between the displayed and stored year will be less than 2

If you have a date in a correct YYYY-MM-DD format, the year consists of four characters

If you merge two dates, by taking the month from the first and the day/year from the second, you get a valid date

But it will work, if both years are leap years

If you take a w3c published algorithm for adding durations to dates, it will work in all cases.

The standard library supports negative years and years above 10000.

Time zones always differ by a whole hour

If you convert a timestamp with millisecond precision to a date time with second precision, you can safely ignore the millisecond fractions

But you can ignore the millisecond fraction, if it is less than 0.5

Two-digit years should be somewhere in the range 1900-2099

If you parse a date time, you can read the numbers character for character, without needing to backtrack

But if you print a date time, you can write the numbers character for character, without needing to backtrack

You will never have to parse a format like —12Z or P12Y34M56DT78H90M12.345S

There are only 24 time zones

Time zones are always whole hours away from UTC

Daylight Saving Time (DST) starts/ends on the same date everywhere

DST is always an advancement by 1 hour

Reading the client’s clock and comparing to UTC is a good way to determine their timezone

The software stack will/won’t try to automatically adjust for timezone/DST

My software is only used internally/locally, so I don’t have to worry about timezones

My software stack will handle it without me needing to do anything special

I can easily maintain a timezone list myself

All measurements of time on a given clock will occur within the same frame of reference.

The fact that a date-based function works now means it will work on any date.

Years have 365 or 366 days.

Each calendar date is followed by the next in sequence, without skipping.

A given date and/or time unambiguously identifies a unique moment.

Leap years occur every 4 years.

You can determine the time zone from the state/province.

You can determine the time zone from the city/town.

Time passes at the same speed on top of a mountain and at the bottom of a valley.

One hour is as long as the next in all time systems.

You can calculate when leap seconds will be added.

The precision of the data type returned by a getCurrentTime() function is the same as the precision of that function.

Two subsequent calls to a getCurrentTime() function will return distinct results.

The second of two subsequent calls to a getCurrentTime() function will return a larger result.

The software will never run on a space ship that is orbiting a black hole.

Seriously? Black holes?

Hey, if Bruce Sterling says that my software needs to be resilient against time distortions caused by black holes , I’m going to take him at his word.

Corrections

Daniel Morrison pointed out that it’s daylight saving time and not daylight savings time. Thanks, I’ve been saying it wrong my whole life!

Rohan Jayasekera suggested a couple of corrections. Thanks!

Credits

Thanks again to everyone who commented. I read everything that you wrote, even if I didn’t wind up including it above.

I made the list above by going through each of the comment threads on Hacker News, Reddit, MetaFilter and BoingBoing (in that order) and finding all(?) of the places where folks had broken out “falsehood 35 to 35 + n ” as a bulleted list. I then selectively copied those lists – in the order that I found them . I made small edits for readability and occasionally I paraphrased (this is noted below).

From Hacker News

1-8: JoshTriplett, 9-10: lambda, 11: hc5, 12: chris_wot, 13: einhverfr, 14: masklinn, 15: rmc, 16: jimfl, 17: einhverfr, 18-20: aardvark179, 21-22: bazzargh, 23: my paraphrase of mikeash’s comment, 24-26: edanm, 27: my paraphrase of Mvandenbergh’s comment, 28: derleth, 29: finnw, 30: michaelochurch, 31: cpeterso, 32-33: dfranke, 34: arohner, 35: TazeTSchnitzel, 36: technomancy, 37: sses, 38: DanWaterworth

From Reddit

39-55: benibela2, 56-64: Darkhack, 65: ericanderton, 66: Taladar

From MetaFilter

69-69 : Joe in Australia

From BoingBoing

70-75: Paul

From Twitter

76-79: cmchen

An acknowledgment

This post – like the one before it – owes a great debt to Patrick McKenzie’s canonical blog post about user names, which I have read over and over throughout the years and from which I have shamelessly cribbed both concept and style. If you haven’t yet read this gem, go and do so right now. I promise you’ll enjoy it.

Previous « » Next
