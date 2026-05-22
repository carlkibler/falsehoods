# Falsehoods about Names — With Examples (Shine Solutions)

> **Original:** <https://shinesolutions.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Programmers Believe About Names - With Examples - Shine Solutions Group

Falsehoods Programmers Believe About Names – With Examples

08 Jan 2018 Falsehoods Programmers Believe About Names – With Examples

Posted by tony rogers

In 2010, Patrick McKenzie wrote the now-famous blog “ Falsehoods Programmers Believe About Names ”, in which he listed 40 things that were not universally true about names.

Did programmers sit up, take notice and change their attitudes to names? Sadly, not really. We still get asked to fill our names out in online forms which assume we have a first name and a last name (in that order) and which refuse to allow us to continue unless we have filled out both. They assume our names can be entered in alphabetic characters, often only ASCII.

I fear that part of the reason that this blog post had less impact than I hoped was that Patrick did not give examples of how each assumption can be false. But having worked in a previous life on IBM’s Global Name Management product, I can assure you that it’s all true.

Still not convinced? In this post I’m going to list all 40 of Patrick’s original falsehoods, but give you an example (or two) drawn from my experiences working in this space. Ready? Let’s go!

People have exactly one canonical full name. It seems some people believe that you get a name and it never changes. Not so, even in Western countries, where a person may change their name when they marry. In Catholic tradition a person may get a middle name at time of confirmation.

People have exactly one full name which they go by. The author known most often as John Wyndham (author of The Day of the Triffids ) bore the name John Wyndham Parkes Lucas Beynon Harris, and published books under the names John Beynon and Lucas Parkes, as well as John Wyndham.

People have, at this point in time, exactly one canonical full name. A performer may have a stage name, completely separate from the name on their birth and marriage certificates – they may even have a passport in their stage name.

People have, at this point in time, one full name which they go by. Not so, even in Western countries, where a woman may choose to retain her unmarried name at work (where she is already known by that name), and use her husband’s surname on social occasions, and even on legal documents such as mortgages and loans.

People have exactly N names, for any value of N . An English name may traditionally consider of two given names (often called a first name and a middle name) and a surname, but that’s not required. A person may have no middle name, or may have several. A Portuguese name, for example, may have one or two given names, and up to four surnames (up to six in the case of a married woman), and those surnames may be phrases, such as da Silva or dos Santos, or even Costa e Silva).

People’s names fit within a certain defined amount of space . The renowned painter, best known simply as Picasso, had the full name “Pablo Diego José Francisco de Paula Juan Nepomuceno María de los Remedios Cipriano de la Santísima Trinidad Ruiz y Picasso”. Try fitting that name into a form which allows 30 characters for a name…

People’s names do not change. Given that we have already mentioned a person changing his or her name at the time they marry, this is clearly false. Moreover, Catholics may adopt an extra middle name at the time of their confirmation. It’s also common for a person to add a name, or change their name entirely, when converting to another religion – consider Cat Stevens becoming Yusuf Islam or Cassius Clay becoming Muhammed Ali when converting to Islam.

People’s names change, but only at a certain enumerated set of events. It was common, for some people in Thailand to change names to avert bad luck. That might happen without a recognised event. Sometimes a person will change their name when someone else with the same name becomes famous, or infamous – a notable example was people changing their surname from Hitler.

People’s names are written in ASCII. Patently false, if we consider that ASCII does not include the accented characters which appear in French and Portuguese names. Nor does it include the Greek alphabet used in Greek names, Cyrillic characters for Russian names. Then there are scripts like Devanagari for Indian names, Chinese characters (hanzi) and Japanese characters (Kanji), and many more.

People’s names can be written in any single character set. People have names that mix, for example, Kanji and Latin, or Hanzi and Latin, or Hangul and Latin characters. In many cases this is because they have a “Western given name” to cater for those of us unable to pronounce the given name in their native language.

People’s names are all mapped in Unicode code points. The Unicode code standards team continue to add code points to the standard to accommodate rarer and rarer characters, and the vast majority of names are already covered, but there are still exceptions, such as the symbol that “the artist formerly known as Prince” adopted. Even if we eliminate such curiosities, there are (a few) alphabets which are not yet covered by Unicode (perhaps the most realistic example is Aymara, a script for a language spoken by well over a million people in South America; less realistic is Klingon, or the character sets invented by J R R Tolkien for his Middle Earth). Moreover, Unicode only includes a subset of Chinese and Japanese characters, and some of the omitted characters are used in names. To complicate matters further, there are languages which do not have associated scripts – they cannot be written down. There are no Unicode code points for such languages. Names in those languages might be captured in phonetic symbols, but that’s not particularly helpful, because the majority of people are unfamiliar with the phonetic alphabet.

People’s names are case sensitive. Many character sets are not case sensitive – Chinese and Japanese, for example – uppercase / lowercase is an idea that is simply not applicable.

People’s names are case insensitive. Some character sets are case sensitive – Latin, for example. More importantly, there are character sets where characters may be accented in lower case, but not in upper case, so it is not possible to provide a “round trip” from lower case to upper case and back to lower case. Correct capitalization can be very important to some people, such as the owners of the surnames Mackenzie and MacKenzie. The correct use of case is also important with surnames such as van Gogh, du Barry, da Costa, O’Brien, and D’Agostino, and given names like Jean-Pierre.

People’s names sometimes have prefixes and suffixes, but you can safely ignore those. Nothing could be further from the truth. The Dutch name Pieter van der Meer is not the same as Pieter Meer, even though “van der” is a prefix. You might consider Junior to be a suffix in Robert Downey Junior, but if you omit it, you are referring to his father, not to him. In Arabic names, the suffix al-Din means “of the faith” or “of the religion” – names such as Taj al-Din (“crown of the faith”) or Saif al-Din (“sword of the religion”) are not the same name when the suffix is suppressed. An Italian name such as di Stefano is not the same as Stefano. A Spanish woman with the surname “viuda de de la Cruz” is the widow of a man with the patronym “de la Cruz”. Omitting those prefixes changes the meaning of the name.

People’s names do not contain numbers. Even if we ignore the cases where the number is a generation (Thurston Howell III, for example), there are cases where a number is part of someone’s legal name. Jennifer 8 Lee chose to give herself the middle name of 8 because 8 is associated with good fortune.

People’s names are not written in ALL CAPS . In some countries (notably French speaking) it is convention to write a person’s surname in all caps to make it clear which part of the name is the surname. This convention has solidified to the point that rendering their surname not in all caps may be regarded as impolite.

People’s name are not written in all lower case letters . e e cummings preferred his name written in all lower case. So does k d lang. It’s polite to follow the pattern used by the name’s owner. There is an Irish / British surname ffrench which is conventionally written in all lower case, although that tradition is suffering from poorly designed software which insists on capitalizing it.

People’s names have an order to them.  Picking any ordering scheme will automatically result in consistent ordering among all systems, as long as both use the same ordering scheme for the same name . In the Netherlands, Vincent van Gogh would be indexed and sorted under G, for Gogh; in Belgium the same name would be indexed under V, for van Gogh. It’s not possible to adopt a single ordering for names which will yield a universally accepted order. The system used by many libraries is to apply the rule appropriate to the place of birth of the person in question (not a rule I’d want to try to apply in software).

People’s first names and last names are, by necessity, different . An Australian businessman and politician called Benjamin Benjamin died in 1905. Jerome K Jerome was an English humorous writer best known for Three Men in a Boat . Owen Owen was a Welshman who founded Owen Owen Ltd, operating a chain of department stores. And let’s not even get started on the wrestlers and actors who adopted repeated names for stage purposes.

People have last names, family names, or anything else which is shared by folks recognised as their relatives . In Java it was common for a person to be given a single name, and not to have a surname. The Indonesian presidents Suharto and Sukarno both had no surname, for example.

People’s names are globally unique . Tell that to anyone named John Smith! I have a somewhat less common name, yet I discovered a person with the same name working in the same industry in the same country (Australia).

People’s names are almost globally unique . Even with the tendency to use unusual spellings of names, it’s extremely common to find people who share a full name – try Googling your own name.

Alright alright but surely people’s names are diverse enough such that no million people share the same name . The Chinese name Zhang Wei is reported to be shared by over a quarter of a million people. If we limit the question to surnames, about 20% of the population of South Korea have the surname Kim. About 10% of the population of northern China share the surname Wang, while more than 10% of the population of southern China share the surname Chen. Li comes next in both northern and southern China, making it the most common surname across the country. And nearly 40% of Vietnamese have the surname Nguyen. Names are far from unique.

My system will never have to deal with names from China. Migration has spread names from every culture to (almost) every country. The days when immigrants were renamed on entry to a country have passed, mostly (for example, Vietnam still requires that an applicant for citizenship takes a Vietnamese name). It is unrealistic to expect to avoid names from other countries, although you may see them in a transliterated form. So a Chinese name like 周 潤 發 may appear in your system as Chow Yun-fat, or Chow Yun Fat, or even Yun Fat Chow (Chow is his surname).

Or Japan. see above.

Or Korea. see above.

Or Ireland, the United Kingdom, the United States, Spain, Mexico, Brazil, Peru, Russia, Sweden, Botswana, South Africa, Trinidad, Haiti, France, or the Klingon Empire, all of which have “weird” naming schemes in common use. see above.

That Klingon Empire thing was a joke, right? It’s difficult to find examples of people using Klingon names as their official names, but should we stop someone doing so? Once we can handle the things required for other cultures (such as the embedded apostrophe for “O’Brien”), we can support Klingon names without extra work.

Confound your cultural relativism!  People in my society , at least, agree on one commonly accepted standard for names. And will your software only be dealing with people named by your society?

There exists an algorithm which transforms names and can be reversed losslessly.  (Yes, yes, you can do it if your algorithm returns the input.  You get a gold star.) There is no algorithm (short of remembering the original format) which can transform a name in a guaranteed reversible way.

I can safely assume that this dictionary of bad words contains no people’s names in it. This is a common mistake – many “bad words” are not bad words in other languages, and some are used in names. Moreover, not every society restricts what words may be used in a name; it’s perfectly possible that someone’s name may have been established in such a jurisdiction.

People’s names are assigned at birth. Births are recorded in most countries, but the effectiveness of the system varies. The exact rules vary by jurisdiction, but all allow for some delay in registering a birth. The length of the allowed delay varies from at least as short as 3 weeks (Scotland) to at least 2 months (Australia), and there is provision for registering births later. The child’s name may be recorded at the time that the birth is registered, but it doesn’t always happen (birth registrations with a name like “Baby Boy” or “Baby Girl” still happen, when the parents have trouble choosing a name, or the child is a foundling, for example).

OK, maybe not at birth, but at least pretty close to birth.

Alright, alright, within a year or so of birth.

Five years?

You’re kidding me, right? There are cultures where a person’s adult name is not chosen until puberty. Prior to this the child may have a “milk name”, or a temporary name.

Two different systems containing data about the same person will use the same name for that person. If this were true, then there would be no market for software which reconciles different databases. In my own case, some systems contain my formal name, including my middle name. Others have just my first given name and surname, or my nickname and surname. And I’m a simple case. My wife was in some systems with her maiden name, in others with her married name, with or without her middle name, with her full first given name or with either of two spellings of her nickname.

Two different data entry operators, given a person’s name, will by necessity enter bitwise equivalent strings on any single system, if the system is well-designed. Imagine what happens when a name is entered by a person hearing it over the telephone. Consider cases like Thomson and Thompson; or Johnson, Johnston, Johnstone, and Jonsson.

People whose names break my system are weird outliers.  They should have had solid, acceptable names, like 田中太郎 . No, your system is badly designed. This particular example name is perhaps best known as the name of an alien in an anime series (and a manga). There have also been real people with this name.

People have names. This one is perhaps the most difficult for which to give solid examples. There was an isolated culture in which no one had names – they referred to everyone in relative terms, such as “my mother’s eldest sister”.

Let’s Wrap This Up

So there you have it: examples for (almost) all forty of Patrick McKenzie’s “ Falsehoods Programmers Believe About Names . If you’re feeling a little overwhelmed, here are what I think are the most important facts to consider the next time you’re designing a system that processes names:

Do not use terms like “first name” or “Christian name” – “given name” is the most commonly accepted term in English.

Keep in mind that half of the world orders names with the family name first.

Many cultures use something other than a single surname inherited by all members of the family – some use a patronym or matronym (or even more than one); while some do not have a surname at all.

Punctuation can be a vital part of a name – the Irish surname O’Hara is not the same as the Japanese surname Ohara. Jean-Pierre is not the same as Jeanpierre, nor is it the same as Jean Pierre – Jean-Pierre is a single given name, while Jean Pierre is two separate given names.

Spaces do not necessarily separate parts of a name – de la Cruz is a single surname, not three separate names; Chinese names written in hanzi are written without any spaces.

Capitalization is not as simple as making the first letter of each word uppercase – van der Meer may have a capital V when used without a given name, but has a lowercase v when the given name is present.

Use the name as a whole, rather than trying to break it into parts. For example, do not try to address a man using Mr last-word-of-name – this can fail in many different ways: Where the surname is written first (eg: Chinese)

Where the correct usage is of the patronym, and it is not last eg: Spanish, Russian

Where the surname is more than one word, eg: Spanish, such as de la Torre

Where the name contains a suffix, such as Junior

And finally, I highly recommend the guidance in this short article published by the W3C: https://www.w3.org/International/ questions /qa-personal-names

Tags: names

Tony Rogers tony.rogers@shinesolutions.com

31 Comments

Koriit Posted at 22:29h, 30 November Reply

Thanks for bringing it up again. This time I’m going to bookmark it and keep it in my collection of important links!

As in original article, I have again laughed at point 28. 😀

Loading…

Marten Posted at 08:34h, 11 December Reply

Another point that could be made is that the same name can be written in different ways.

One of the examples used the Chinese family name 周 and wrote it as “Chow”. This is however some bastardized romanization of it. My MIL has the same name and writes it as Chou (wade-giles romanization), me and my son also has it and writes it Zhou (hanyu pinyin romanization). Same name just different ways of writing it in systems that don’t support chinese characters.

Loading…

tony rogers Posted at 09:57h, 04 January

A very good point which I did not address. That single character is someone’s family name, and ideally the system should be able to capture it that way. Unfortunately, there are far too many systems which are not able to do so, so people are forced to transliterate it into a character set which the system can handle. Chinese characters can be transliterated in multiple ways, as you say, resulting in strings which can be difficult to match. As an aside: the origin of “Chow” as a romanization of the character is suggested by Wikipedia as originating from the Cantonese pronunciation of the name.

The problem is exacerbated when we consider that the same character may also be part of a Japanese name written in Kanji, with multiple different romanizations based on different “readings” of the character: I gather that particular character may be read as Shuu, Amane, Kane, Susaki, Suzaki, and several others. This is why systems handling Japanese names may require fields to hold the name in written form (using Kanji characters) and in spoken form (using Hiragana characters). Without something like that it can be difficult telephone someone and ask a question as simple as “Am I speaking to …?”.

The problem of not knowing how to pronounce someone’s name is not restricted to Japanese names, of course. One of my favourite examples is the English name “Featherstonhaugh” pronounced “Fan-shaw”.

Loading…

HaHa You are Kidding, Right Posted at 22:44h, 30 November Reply

Dont forget “John Null”

A valid name, that some systems cant handle on exchanging data

Loading…

danrooti7 Posted at 01:09h, 01 December Reply

Interesting – I hadn’t thought of some of these. One issue that comes to mind immediately given the guidelines above – how on earth does one properly *sort* in such a system? Imagine a system that has multiple names for each person, each with a “given name” and “family name” and “preferred name”. It contains people of all cultures. In US culture “given name” is “first name” and “family name” is “last name”. In hanzi the whole name goes in the “given name” field? Now, the user needs an ordered list of all people. I can see Susie Q’s eyes glazing over trying to explain the above when “all she asked for was a report sorted by last name” 😉

Loading…

Natalie M. Amery Posted at 03:04h, 02 December Reply

At one point I knew both a Mr Van Den Bos and a Mr van den Bos.

I knew someone who used a middle initial when writing their name as Ms S P Example but didn’t actually have a middle name so was officially just Ms Susan Example (and used that form if asked for First and Last names).

Loading…

Name Posted at 04:53h, 02 December Reply

Please fill in actual examples for the “there are cultures where…” ones.

Loading…

Pingback: Falsehoods Programmers Believe About Names – BrianChan.us Posted at 08:15h, 24 February Reply

\[…\] https://shinesgio.wpcomstaging.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/ \[…\]

Loading…

Eileen Quintero Posted at 05:52h, 06 March Reply

Hi,

Do you have any recommendations for what this implies for how “search” would work? For example, I think that if a person types Renee it should show results for this name with and without accents; however I have seen some systems that allow the INPUT of accents but then those are excluded from results (to get an accent in the result you need to type an exact match, which sort of defies the search button function).

Thoughts? We are trying to design an inclusive name database and need to think about search also. Thank you!

Loading…

J Posted at 04:21h, 22 March Reply

“People have names.”

If you expand this to something like “you know a person’s name(s)”, I think it becomes easier to find examples. Unconscious people brought to hospitals, people who are unable or unwilling to give their name to medical staff or law enforcement, genealogical trees and databases using records in which some names are unavailable or unrecorded, etc.

Loading…

tony rogers Posted at 07:23h, 22 March Reply

True, someone may have a name, but be unwilling to provide it. Or they simply may not have provided it to your application. Not the same as someone not having a name, but it raises similar problems.

With the growing tendency to use an email address as someone’s “identity” in many applications we can find ourselves with that email address as a user’s “proxy name”. So we can find ourselves with strings like “wombat76359@gmail.com”, for example, as our only means of identifying a user. Still, an email address has a couple of advantages – it’s unique (making a good key in a database, and we can confirm that a user has some claim to it.

Loading…

azurelunatic Posted at 06:44h, 12 November

Only unique if you assume that the email address is used by only one person.

Two examples I encountered when doing data entry last month, suitably redacted:

hansonfamily@example.com – used for two adult memberships, presumably after the landline household communication point model

bcrusher@example.com – adult membership for Beverly, kid-in-tow membership for Wesley, who wasn’t yet old enough to hold his own email address in the US but for planning purposes required his own membership and name label

Loading…

azurelunatic Posted at 06:53h, 12 November

Additionally, there is user error when the email is self-reported but not confirmed. My friend Nadyne was an early arrival to her email provider. She has an unreliable narrator list of some of the other Nadynes in the world who seem to believe that if they say their email address is nadyne@example.com often enough, it will become true.

Loading…

tony rogers Posted at 07:46h, 12 November

By unique, I mean that there is exactly one email account (mailbox if you like) which corresponds to that email address. Sure, you can have multiple people using the same email address, but that’s not the same as having a hundred people all called “Tom Jones”.

Loading…

Hennes Posted at 23:50h, 17 November

email is sadly not unique, when people switch providers they get a new mail and the old email may be handed out to a new client of the old ISP. Granted, that was more common in the 1990 when resources where limited and there are few reason for ISP not to mark the old one as reserved, or even forward mail. But you cannot guarantee that.

That means we may end up with: (unique user 1) login user1.isp1.tld Old email user1.isp1.tld Mail needs to be sent to user1.differentISP.tld

Same for phone numbers. I even have a practical example for that. I got a new phone and migrated my old number to that. THe telefom provided provided my with an account where the loginname was choosen by them and which is the temporaily number which I had for 5 days. It is not the phone number on which I am reachable.

So basically and contact details should not be ID details.

Loading…

tony rogers Posted at 07:45h, 18 November

True – I have a similar experience, in that I am getting spam for the previous (5 years before I got it) holder of a business email address, but at a given time, a given email address is unique.

You are right in pointing out that an email address is not permanently unique, but there is no identifier which is permanently unique.

Loading…

Peter Crabb Posted at 21:52h, 02 April Reply

Things seem to have gone backwards since I first went to work as a clerk in the early 70s. Then, with a clunky IBM mainframe, we identified and recorded a customer’s name in several formats so that we had the full formal name, with appropriate titles, and the format by which correspondence was to be addressed.

A simple example of poor system design was the hospital that my mother attended in the last years of her life. Nurses insisted on calling her by the first of her two given names. Two of her four sisters shared the same name and all were known exclusively by their second names. It was all rather confusing for her in the early stages of dementia to suddenly be given a new name.

Loading…

tony rogers Posted at 08:56h, 05 April Reply

There are cultures in which it is common for children to share a first given name – Maria is a common case. So you might have Maria Clare and Maria Beatrice, with the children normally known as Clare and Beatrice (and the force of their full names saved for when they were misbehaving 🙂 ).

The sensitive way of dealing with this is to have a “known as” field, which can also be used in cases such as a man whose official name is John, but who is always called Jack.

Loading…

gorn Posted at 22:04h, 23 May Reply

Very good article!

I however disagree with recommendation to replace “first name” with “given name” which is against several observations made. My suggestion would be to use one field only “name” (or “full name”) and preserve it as is.

If you really need to do some sorting, than the only one hope I see is to introduce whole new field “sorting name” (“surname” in most cases).

Loading…

tony rogers Posted at 06:42h, 24 May Reply

I agree with the idea of using a single “name” or “full name” field, but where someone wants / needs to refer to a person’s given name, I strongly recommend the term “given name” over alternatives. The term “first name” presumes the order of the parts of the name, for example.

Sorting names is problematic. To establish a complete order on names requires more than the surname. Asking a person to enter their name in a way which will produce a good sort is difficult (few of the people entering their names will have librarian training!). Moreover, if people are able to enter their name in Unicode, we will be faced with some entering a Chinese name in Hanzi, and others entering it in Roman characters, using Pinyin or other transliterations. Sorting these together is challenging.

Loading…

nerosnm Posted at 20:50h, 20 July Reply

Really well written article. One addition that could be made to the last point: rather than trying to break someone’s name into parts in order to address them by their given name only, just ask them if they have a preferred name! If they don’t enter anything, use their full name.

Loading…

Chakat Firepaw Posted at 12:38h, 14 August Reply

Here’s an example from the other side for \#37: There is an entire cottage industry in the US based around comparing voter databases with other official records looking for discrepancies¹. Said discrepancies are then used to try and justify changes aimed at gaining electoral advantage.

Of course, I also have an example of “more than one name known by,” and an atypical name structure. I’m Firepaw some places online, (it’s a ‘what-who’ structure, Firepaw being a Chakat), and Rick {Surname}² others and offline.

1: Such as the voter rolls having “Bob Q Smith” and the DMV having “Robert Quincy Smith, Jr”.

2: No, my surname isn’t {Surname}. That’s just a placeholder in stead of the real one.

Loading…

W. Wesley Groleau (伟思礼) Posted at 09:07h, 08 October Reply

\#40 is a myth. But here’s one to replace it: A name can’t be only a single character. Counters: Harry S Truman U Thant W. Wesley Groleau (the accursed forms won’t allow the dot, so, …) But I can’t be too hard on my fellow programmers—I’ve seen print forms where the zip code field is bigger than the name field.

Loading…

CJ Dennis Posted at 15:43h, 20 October Reply

Points 29 and 32 need to be fleshed out properly.

29. Confound your cultural relativism! People in my society, at least, agree on one commonly accepted standard for names. And will your software only be dealing with people named by your society?

That’s a poor response and misses the point. For example, is there a single standard for English names? If not, point 29 is disproved. E.g. my eldest brother was deliberately named so that his middle name is what he’s called. His first name is only ever used on official documents, and by telemarketers which is useful for him to identify phone calls he doesn’t want to continue! The rest of us use our first names as our common names.

32. People’s names are assigned at birth. Births are recorded in most countries, but the effectiveness of the system varies.

Traditionally, Jewish children are not named for the first 8 days of their lives. This is different from being given a name and having it not immediately recorded.

Loading…

Some Name Posted at 20:03h, 05 December Reply

In Norway, it is possible to change the full name without any reason or charge to any other name. I could go by Tor Jonson today and by Birk Nilsen tomorrow. Also, especially in certain European countries, it becomes more and more common for the husband to adopt his wife’s family name.

Loading…

simpleduckman Posted at 02:29h, 10 April Reply

That E. E. Cummings preferred his name decapitalized is very much in dispute. It’s probably not a great example here.

http://faculty.gvsu.edu/websterm/cummings/caps.htm

Loading…

Erica Ginter Posted at 03:56h, 30 December Reply

There’s also the problem of insufficient “room” for a long name. In high school I was Erica Van Dommelen, which was one character too long for the school’s system. And names were entered last name first, so I became Van Dommelen Eric, a problem when gym and health classes were concerned.

Loading…

tony rogers Posted at 09:15h, 04 January Reply

That’s an example of a poor form design resulting in an unfortunate outcome for you. Sorry to hear that, but it does make a good example of the impact of poor name handling.

Entering names “last name first” makes an assumption about the order of the elements of the name (surname vs given name). At least they handled the surname “Van Dommelen” as a unit.

Also an assumption of gender based on name, but that’s a separate issue, and one which has become much more sensitive now.

Loading…

Jerzy Posted at 13:06h, 05 January Reply

For \#21 through 23: A few cultures use birth order names. For example, AFAIK, (parts of) Balinese names literally mean “eldest” and so on. And they do not generally use family names (though it’s more complicated than that) — so if you only ask for given and family name, you’d get a *lot* of people who appear to be named “eldest.”

Loading…

Pingback: Exploring How To Build Non-Discriminatory Web Applications \| Matthew Robbins Kirby Posted at 09:13h, 24 March Reply

\[…\] I’ll never do justice explaining just how wrong you probably think about names. You need to read Patrick McKenzie’s famous 2010 article “Falsehoods Programmers Believe About Names” and then follow that up by taking a look at Tony Roger’s 2018 article “Falsehoods Programmers Believe About Names – With Examples.” \[…\]

Loading…

Pingback: Falsehoods programmers believe about names – with examples (2018) - The web development company Posted at 08:25h, 08 November Reply

\[…\] Article URL: https://shinesolutions.com/2018/01/08/falsehoods-programmers-believe-about-names-with-examples/ \[…\]

Loading…

Leave a Reply Cancel reply

“The collective knowledge of my workmates is amazing, and it’s always on hand to help me improve my own skills. Whenever I need tools or resources to do my job, they are provided without hesitation. The leadership team truly believes that our people are our best asset, and it shows in the way the organisation is run. I am always proud to say that I work for Shine.”

Matthew

“I’ve been with Shine almost 15-years, and it’s the leadership that makes Shine a great place to work. The founders of Shine are…wait for it…’real people’! I have always felt that they are genuinely caring of their staff – approachable, honest, open. They definitely want to see their staff be the best they can be and provide the support and guidance needed to do just that. I love working here.”

James

“Since I joined Shine in 2017, I have been surrounded by brilliant, friendly and talented people, where work-life balance is a priority. I always seek new challenges in my career and Shine gave me the opportunity to become a People Lead last year and I have been promoted recently as a Senior Software Engineer. Shine is definitely a great place to grow and develop both professionally and personally.”

Marcela

“Working at Shine has been great for me. It’s challenging, yet rewarding. The Shine team are professional, highly skilled, and great fun to be around. Shine has a respectful inclusive culture and focuses not only on skill growth but also personal wellbeing. The thing I value the most is the trust that Shine puts in me to do the job the way I think it should be done.”

Trudi

“It’s the leadership that makes Shine a great place to work. The founders of Shine are…wait for it…’real people’! I have always felt that they are genuinely caring of their staff – approachable, honest, open. They definitely want to see their staff be the best they can be and provide the support and guidance needed to do just that. I love working here.”

Doug

%d bloggers like this:
