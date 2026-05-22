# Falsehoods about Time (Noah Sussman)

> **Original:** <http://infiniteundo.com/post/25326999628/falsehoods-programmers-believe-about-time>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods programmers believe about time: @noahsussman: Infinite Undo

Infinite Undo!

Data-Mining In The Git Log • Falsehoods About Time

Software As Narrative

How-To Articles

Devops Reading List

CC Sharealike © 2025 by Noah Sussman

Jun 17th Sun

Falsehoods programmers believe about time

Over the past couple of years I have spent a lot of time debugging other engineers’ test code. This was interesting work, occasionally frustrating but always informative. One might not immediately think that test code would have bugs, but of course all code has bugs and tests are no exception.

I have repeatedly been confounded to discover just how many mistakes in both test and application code stem from misunderstandings or misconceptions about time. By this I mean both the interesting way in which computers handle time, and the fundamental gotchas inherent in how we humans have constructed our calendar – daylight savings being just the tip of the iceberg.

In fact I have seen so many of these misconceptions crop up in other people’s (and my own) programs that I thought it would be worthwhile to collect a list of the more common problems here.

All of these assumptions are wrong

There are always 24 hours in a day.

Months have either 30 or 31 days.

Years have 365 days.

February is always 28 days long.

Any 24-hour period will always begin and end in the same day (or week, or month).

A week always begins and ends in the same month.

A week (or a month) always begins and ends in the same year.

The machine that a program runs on will always be in the GMT time zone.

Ok, that’s not true. But at least the time zone in which a program has to run will never change.

Well, surely there will never be a change to the time zone in which a program hast to run in production.

The system clock will always be set to the correct local time.

The system clock will always be set to a time that is not wildly different from the correct local time.

If the system clock is incorrect, it will at least always be off by a consistent number of seconds.

The server clock and the client clock will always be set to the same time.

The server clock and the client clock will always be set to around the same time.

Ok, but the time on the server clock and time on the client clock would never be different by a matter of decades.

If the server clock and the client clock are not in synch, they will at least always be out of synch by a consistent number of seconds.

The server clock and the client clock will use the same time zone.

The system clock will never be set to a time that is in the distant past or the far future.

Time has no beginning and no end.

One minute on the system clock has exactly the same duration as one minute on any other clock

Ok, but the duration of one minute on the system clock will be pretty close to the duration of one minute on most other clocks.

Fine, but the duration of one minute on the system clock would never be more than an hour.

You can’t be serious.

The smallest unit of time is one second.

Ok, one millisecond.

It will never be necessary to set the system time to any value other than the correct local time.

Ok, testing might require setting the system time to a value other than the correct local time but it will never be necessary to do so in production.

Time stamps will always be specified in a commonly-understood format like 1339972628 or 133997262837.

Time stamps will always be specified in the same format.

Time stamps will always have the same level of precision.

A time stamp of sufficient precision can safely be considered unique.

A timestamp represents the time that an event actually occurred.

Human-readable dates can be specified in universally understood formats such as 05/07/11.

UPDATED: There’s more! Read the rest of the falsehoods…

That thing about a minute being longer than an hour was a joke, right?

No. 

There was a fascinating bug in older versions of KVM on CentOS. Specifically, a KVM virtual machine had no awareness that it was not running on physical hardware. This meant that if the host OS put the VM into a suspended state, the virtualized system clock would retain the time that it had had when it was suspended. E.g. if the VM was suspended at 13:00 and then brought back to an active state two hours later (at 15:00), the system clock on the VM would still reflect a local time of 13:00. The result was that every time a KVM VM went idle, the host OS would put it into a suspended state and the VM’s system clock would start to drift away from reality, sometimes by a large margin depending on how long the VM had remained idle.

There was a cron job that could be installed to keep the virtualized system clock in line with the host OS’s hardware clock. But it was easy to forget to do this on new VMs and failure to do so led to much hilarity. The bug has been fixed in more recent versions.

An acknowledgment

This post owes a great debt to Patrick McKenzie’s canonical blog post about user names, which I have read over and over throughout the years and from which I have shamelessly cribbed both concept and style. If you haven’t yet read this gem, go and do so right now. I promise you’ll enjoy it.

UPDATED: Thanks for your comments and anecdotes!

I’d like to say thanks to everyone who contributed to the comment threads about this post on BoingBoing and Hacker News as well as Reddit and MetaFilter and to everyone on Twitter who shared their strange experiences with time.

You have provided so many interesting edge cases I had forgotten about as well as many oddities of which I wasn’t aware. For instance: in the Jewish calendar, days start at sunset not midnight . And as Bruce Sterling pointed out , I didn’t even think about what happens when the computer is on a spaceship orbiting a black hole.

There’s more than enough material for another (longer!) post about this topic. But first I’ll have to finish reading all \>500 of your comments as well as the wealth of awesome research material that has been linked.

UPDATED AGAIN: Read the Web’s collective thoughts on More Falsehoods About Time!

I’ve written another post collecting the many other falsehoods that were suggested by your comments at BoingBoing and Hacker News as well as Reddit and MetaFilter and also Twitter .

Thanks again for your enthusiasm and for the mind-boggling level of detail. I learned a lot about time in the last 24 hours. Fellow nerds, I salute you.

UPDATED 2017:

FalsehoodsAboutTime.com

Falsehoods Programmers Believe About Time now has a canonical permalink you may use when referring to this post.

FalsehoodsAboutTime.com

Special thanks to SWAlchemist , who helped me to recover this TLD after I accidentally lost it!

UPDATED 2025:

Because this post was cited in the AlphaCode (2022) paper, I have converted both posts into a citeable white paper with a DOI: 10.5281/zenodo.17070518

Because CS professors like to throw up a slide full of Time Falsehoods to freak out the undergrads, Falsehoods Programmers Believe About Time has now informed the work of a generation of computer scientists. They can now properly cite this influential work.

Previous « » Next
