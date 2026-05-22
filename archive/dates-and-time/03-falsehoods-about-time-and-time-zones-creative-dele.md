# Falsehoods about Time and Time Zones (Creative Deletion)

> **Original:** <https://www.creativedeletion.com/2015/01/28/falsehoods-programmers-date-time-zones.html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods programmers believe about time and time zones

Every day has 24 hours

Counter example: Because of daylight saving time (DST) some days could have 23 hours and some could have 25 hours. Or some other amount of hours - whole or not.

OK, but every day without DST changes is 86400 (60 \* 60 \* 24) seconds long

Some times the UTC offset for a time zone is changed.

… at least in UTC

Leap seconds cause some days to have an extra second. And theoretically there could be negative leap seconds. Although negative leap seconds have not happened yet because the rotation of the earth so far has been slower than UTC, as it were, and not faster.

Week one of a year starts in January every year

January 1st is not always a monday so some days of an ISO week will be in different years. Example: 2014 December 28th belongs to week 1 of 2015.

If I know what time zone someone is in and they just tell me the date and local time, I can always use software to find out what time that is in UTC

If they are in the middle of changing from summertime to wintertime, the clock will be set back one hour. This means that an hour exists twice, so to speak. If the clock is set back to 2:00 and someone tells you that the local time was 2:17 for instance, you do not know if he is talking about 2:17 before the clocks were set back or 2:17 after the clocks were set back.

DST always sets the clock back and forth by exactly one hour

Throughout history there are examples of DST rules that set the clocks back and forth 2 hours or 30 minutes. A current example (h/t Derick Rethans ) is Australia/Lord_Howe which advances the clocks by 30 minutes for DST.

Countries that observe DST begin observing DST in the first half of the year and end observing DST in the last half of the year

Not in the southern hemisphere, where summer time might begin in October and end in March.

OK, but DST always starts around spring and continues until fall

Except for Morocco, where in the middle of summer, DST is suspended for a month during Ramadan (depending on which year it is).

If I have a timestamp for a future event, I can convert it to UTC, store it as UTC along with the time zone and be sure that I can reliably convert it back to the correct “wall time” in the future

If time zone rules change in the mean time for the time zone in question, converting back from UTC to “local time” might produce a different result. Follow this link for a solution .

Time zone rules do not change

In 2014 there were 10 updates to the Olson database released during the year.

If I keep my operating system up to date by installing updates, my operating system will have all the newest time zone updates

As of January 2015 the newest tzdata package for Ubuntu 14 has data from June 2014 and not the latest 2014j release from November 2014.

CST is a unique identifier for a time zone (Central Standard Time in the USA)

CST is also used for: Cuba Summer Time, China Time, Central Standard Time (Australia). PST is used for Pakistan Standard Time and Pacific Standard Time. If you want a unique identifier for the time zone in the Pacific West of the USA it looks like this: “America/Los_Angeles”.

If you have two UTC timestamps it is possible to calculate how many seconds will be between them even if one of the timestamps are a year into the future

There might be leap seconds introduced, but you cannot be sure when or how many. However they are announced at least 6 months in advance, so if none of the two times are more than 6 months in the future and you keep up with news about leap seconds you can calculate it.

The date-time combination 2014 March 30th 2:20:42 is always valid

In central European time zones such as Europe/Copenhagen, that time does not exist in local time because of DST making the clocks being advanced by an hour from 2:00 to 3:00. This causes an hour to be skipped.

The time 23:59:60 is always invalid

When leap seconds are inserted, a minute will be 61 seconds long.

I can trust that if someone has written a library to handle date and time, it will work reasonably well

Many people write libraries without knowing much about the domain. And developers who also do not know much about the domain will use those libraries. Often things will work fine for a long time if for instance you only deal with timezones in a few countries where the time zone rules do not change a lot. It works fine - until it does not. It can become a case of the blind library developers leading the blind library users.

This text was inspired by other “falsehoods programmers believe” posts. And also by my experiences building a tzdata parser and date-time library for Elixir and using other date-time libraries through the years.

PS. This was meant as a thought provoking eye opener. But all of this might seem negative and not constructive. Pointing out problems without any solutions. What can you do, to avoid having these issues cause problems in the systems you develop? I plan to write posts about solutions, so check back here soon.

If you liked this post you might want to follow me on twitter for updates on new posts and more. Twitter handle: @laut

Tweet

More blogposts:

A cable can improve your audio and video calls

You might not need the Calendar or Timex libraries

Adding a function to the Elixir standard library that I hope will not be used
