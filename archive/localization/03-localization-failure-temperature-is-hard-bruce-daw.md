# Localization Failure: Temperature is Hard (Bruce Dawson)

> **Original:** <https://randomascii.wordpress.com/2023/10/17/localization-failure-temperature-is-hard/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Localization Failure: Temperature is Hard \| Random ASCII – tech blog of Bruce Dawson

Random ASCII – tech blog of Bruce Dawson

Forecast for randomascii: programming, tech topics, with a chance of unicycling

Skip to content

Home

About

← 32 MiB Working Sets on a 64 GiB machine

Life, death, and retirement →

Localization Failure: Temperature is Hard

Posted on October 17, 2023 by brucedawson

The Guardian is one of my favorite news sources. I’m a subscriber (support news organizations!) and I read it daily. But it is not immune to errors, as this headline shows:

68 ° F above average is a lot. For a tropical country it is not credible for temperatures to be that much warmer than average because the average is too high to give enough headroom. So what gives?

Reading the article I found this:

parts of Malawi saw a maximum temperature of 43C (109F), compared with an average of nearly 25C (77F)

As I expected the actual temperature increase was 32 ° F, not 68 ° F. So what’s up with that headline? Here’s a hint: this is what the headline might say if you set your location to somewhere other than the United States:

Now “nearly 20C” is an odd way of saying “18 ° C”, but I guess they really like round numbers, and that’s not the problem. The problem is that somebody – the localization team? an algorithm? – decided that 20 ° C was equivalent to 68 ° F. And they’re not wrong. And yet they are.

When converting from a temperature in Celsius to one in Fahrenheit you have to multiply by 1.8 (because each degree Celsius covers a range 1.8 times as large as a degree Fahrenheit) and you have to add 32 ° F (because the freezing point in Fahrenheit is 32, compared to 0 in Celsius). However if you are converting a temperature difference you just multiply by 1.8.

That is, if the temperature goes up by 1 ° C then it has gone up by 1.8 ° F. If it goes up by 10 ° C then it has gone up by 18 ° F. If it goes up by 20 ° C then it has gone up by 36 ° F. Adding 32 ° F in this context is just wrong.

This is just another version of the fallacy involved when somebody says that it is “twice as hot” when the temperature goes from 5 ° C to 10 ° C – note that this is equivalent to going from 278 K to 283 K, or 41 ° F to 50 ° F, so clearly not “twice as hot” in any meaningful way.

In short, translating 20 ° C requires examining the context and there are at least three possible translations:

“The temperature is 20 ° C” translates to “The temperature is 68 ° F”

“It’s 20 ° C warmer than yesterday” translates to “It’s 36 ° F warmer than yesterday”

“The temperature is minus 20 ° C” translates to “The temperature is minus 4 ° F”

So 20 ° C is either 68 ° F, 36 ° F, or (minus) 4 ° F.

Reported here:

https://twitter.com/BruceDawson0xB/status/1714406661904007624

Hacker news discussion here .

Share this:

Email a link to a friend (Opens in new window) Email

Share on Reddit (Opens in new window) Reddit

Share on X (Opens in new window) X

Like Loading…

Related

About brucedawson I’m a retired programmer, ex-Google/Valve/Microsoft/etc., who was focused on optimization and reliability. Nothing’s more fun than making code run 10x as fast. Unless it’s eliminating large numbers of bugs.

I also unicycle. And play (ice) hockey. And sled hockey. And juggle. And worry about whether this blog should have been called randomutf-8.

2010s in review tells more: https://twitter.com/BruceDawson0xB/status/1212101533015298048 View all posts by brucedawson →

This entry was posted in Math , metric , Rants and tagged Celsius , Fahrenheit , localization . Bookmark the permalink .

← 32 MiB Working Sets on a 64 GiB machine

Life, death, and retirement →

5 Responses to Localization Failure: Temperature is Hard

anon says:

October 17, 2023 at 11:40 pm

Two mistakes at the end. 20°C is 68°F, not 78°F

Reply

brucedawson says:

October 18, 2023 at 8:07 am

Thanks. Fixed.

Reply

another anon says:

October 18, 2023 at 12:40 am

And the unit for absolute temperature is kelvin, not degrees Kelvin. So from 278 K to 283 K.

Reply

brucedawson says:

October 18, 2023 at 8:08 am

Gotcha. So many subtleties!

Reply

Severin Pappadeux says:

November 1, 2023 at 12:54 pm

Affine transformation is not linear transformation

Reply

Leave a comment Cancel reply

This site uses Akismet to reduce spam. Learn how your comment data is processed.

Recent Posts

Reflections on My Tech Career – Part 2

Reflections on My Tech Career – Part 1

Finding a VS Code Memory Leak

Acronis True Image Costs Performance When Not Used

Google Maps Doesn’t Know How Street Addresses Work

Categories

AltDevBlogADay

Bugs

Chromium

Code analysis

Code Reliability

Commuting

Computers and Internet

Debugging

Documentation

Drinks

Environment

Floating Point

Fractals

Fun

Gaming

Investigative Reporting

Linux

Math

memory

metric

Performance

Programming

Quadratic

Rants

Security

Symbols

Travel

uiforetw

Uncategorized

Unicycling

Visual Studio

WLPG

Xbox 360

xperf

Meta

Create account

Log in

Entries feed

Comments feed

WordPress.com

Random ASCII – tech blog of Bruce Dawson

Blog at WordPress.com.

Comment

Reblog

Subscribe Subscribed

Random ASCII - tech blog of Bruce Dawson

Already have a WordPress.com account? Log in now.

Random ASCII - tech blog of Bruce Dawson

Subscribe Subscribed

Sign up

Log in

Copy shortlink

Report this content

View post in Reader

Manage subscriptions

Collapse this bar

%d
