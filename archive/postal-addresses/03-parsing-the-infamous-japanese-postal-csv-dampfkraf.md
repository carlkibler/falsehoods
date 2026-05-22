# Parsing the Infamous Japanese Postal CSV (dampfkraft)

> **Original:** <https://www.dampfkraft.com/posuto.html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Parsing the Infamous Japanese Postal CSV

Parsing the Infamous Japanese Postal CSV

This post is part of collections on Code and Computers , Projects , and Japanese Language Technology .

Late last year I released posuto , a package presenting Japanese postal code data in an easy-to-use format. It’s based on data released by Japan Post , which is infamous for being widely used but hard to parse.

I first became aware of the postal data when I entered my postal code in an online form and it auto-completed my address as “XXX-borough (except the following buildings)”. I had no idea what that parenthetical was referring to, so I looked for a common source of postal data, found the CSV, and found the issue. It turns out the CSV file contains parenthetical notes for anyone reading the CSV file and makes reference to the order of the rows.

This causes problems. The data is mainly useful one row at a time, where the parenthetical is meaningless. Since CSV is a field-delimited format, there’s also no need for parentheticals - you could just add a note field.

This is only one of many issues with ken_all.csv . You can find people complaining about it regularly on Twitter , and there was even briefly a blog just collecting posts from all over the web about it. A particularly amusing tweet describes people who expect computers to bend to the will of humans being punished in Hell by having to parse ken_all.csv forever.

The README for the file explains that lines with overly long fields will be broken up into multiple lines. Specifically, if the neighborhood name is over 38 characters, or if the half-width katakana ( half-width katakana ) pronunciation field is over 76 characters, the line will be split into two lines. The overly-long neighborhood field will be continued and all other fields will be duplicated. This is an abbreviated sample of what that looks like:

12345,Tokyo,Minato,This place name is really 12345,Tokyo,Minato,very long it didn’t fit in 12345,Tokyo,Minato,a single line so we had to 12345,Tokyo,Minato,split it

The motivation for this is not explained. Maybe there was a fixed-width buffer for storing a line somewhere thirty years ago. I used to process CSV and other files from hundreds of different providers at an old job and I saw many horrors, but I’ve never seen this particular formatting choice anywhere else. It should also be noted that while the length limits are as stated, the location where line breaks are inserted in long lines appears random, occurring neither at the character limit nor at normal word boundaries.

It’s worth noting not all the issues with the CSV are inherently technical; postal codes are always complicated. The postal code with the most rows in the CSV - a stunning 66 - is 〒452-0961, which refers to the Haruhi region of Kiyosu City in Aichi Prefecture. This has that many lines because every neighborhood gets a separate line. (This particular case may be related to Haruhi having been the smallest town by area in Japan from 2006 until 2009, when it was incorporated into Kiyosu City.)

In contrast, the longest continued line, using the line break rules above, is the entry for 〒602-8368 or 〒602-8374, both with eight lines. These are both in one of a few areas in Kyoto that uses a unique, bizarre system of intersection-based addressing . The entry looks a bit like this:

12345,Kyoto,Kyoto,“North Town (Up Lower Godsroad from” 12345,Kyoto,Kyoto,“the West, Down Turtle Street from the” 12345,Kyoto,Kyoto,“East, Up Old Temple Road from the” 12345,Kyoto,Kyoto,“West)”

I have used quoted fields here, but the actual CSV doesn’t quote fields and instead uses a different kind of comma.

There are other issues. There are catch-all postal codes for many areas, where the neighborhood is given as “except the following”, and the only thing to do is look for that exact string and exclude it. There’s a variety of similar strings, and it’s hard to be sure I’ve caught them all.

An example of another comment is 一円. Normally this would mean “one yen”, but it also means “the area surrounding”, and is a note in the CSV that should be removed from neighborhood names, except for exactly one neighborhood in Shiga where that’s actually the name (〒522-0317).

There’s also a separate romaji file offered by JP Post. It’s updated less frequently than the main files, is often out of sync, and the provided romaji are extremely low quality. For the moment I’m still providing the data in posuto in the name of consistency, but honestly you should just use cutlet . To give an example of bad romaji:

大手町 JAビル OTEMACHI JIEIEIBIRU

What’s happening here is that “JA” is being converted to the phonetic reading in Japanese, “ジェイエイ”. Then ジェ, which is written “large ji small e” but pronounced “je”, is being converted to “jie” by treating the small character as though it were large, and the other characters are translated as-is, turning something already in the latin alphabet into alphabet soup. For contrast, cutlet has no problem converting “JAビル” into “JA building” (case handling admittedly needs some work still). Similar issues turn “Roppongi Hills” into “Roppongihiruzu”, and “Sweden Hills” into “Suedenhiruzu”.

Anyway, dealing with the file was a humbling lesson in the amount of complexity it’s possible to pack into one place. I’ve glossed over many details, but you can find them covered in posuto’s README.

You can use posuto as a library, or if you’re not using Python, just download the pre-processed JSON and make use of that. If you find a good use for it I’d be delighted to hear about it.

Oh, and if you need a Win3.1 or DOS program to copy the data onto an IBM H floppy disk, just check the bottom of JP Post’s page - they’ve got you covered. Ψ

2020-11-07T20:11:58+09:00
