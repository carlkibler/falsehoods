# I Knew How to Validate an Email Until I Read the RFC (Haacked)

> **Original:** <https://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

I Knew How To Validate An Email Address Until I Read The RFC \| You’ve Been Haacked

Raise your hand if you know how to validate an email address. For those of you with your hand in the air, put it down quickly before someone sees you. It’s an odd sight to see someone sitting alone at the keyboard raising his or her hand. I was speaking metaphorically.

Before yesterday I would have raised my hand (metaphorically) as well. I needed to validate an email address on the server. Something I’ve done a hundred thousand times (seriously, I counted) using a handy dandy regular expression in my personal library.

This time, for some reason, I decided to take a look at my underlying assumptions. I had never actually read (or even skimmed) the RFC for an email address. I simply based my implementation on my preconceived assumptions about what makes a valid email address. You know what they say about assuming .

What I found out was surprising. Nearly 100% of regular expressions on the web purporting to validate an email address are too strict.

It turns out that the local part of an email address, the part before the @ sign, allows a lot more characters than you’d expect. According to section 2.3.10 of RFC 2821 which defines SMTP, the part before the @ sign is called the local part (the part after being the host domain) and it is only intended to be interpreted by the receiving host…

Consequently, and due to a long history of problems when intermediate hosts have attempted to optimize transport by modifying them, the local-part MUST be interpreted and assigned semantics only by the host specified in the domain part of the address .

Section section 3.4.1 of RFC 2822 goes into more detail about the specification of an email address (emphasis mine).

An addr-spec is a specific Internet identifier that contains a locally interpreted string followed by the at-sign character (“@”, ASCII value 64) followed by an Internet domain.  The locally interpreted string is either a quoted-string or a dot-atom .

A dot-atom is a dot delimited series of atoms. An atom is defined in section 3.2.4 as a series of alphanumeric characters and may include the following characters ( all the ones you need to swear in a comic strip )…

! \$ & \* - = ^ \` \| ~ \# % ‘ + / ? \_ { }

Not only that, but it’s also valid (though not recommended and very uncommon) to have quoted local parts which allow pretty much any character. Quoting can be done via the backslash character (what is commonly known as escaping) or via surrounding the local part in double quotes.

RFC 3696 , Application Techniques for Checking and Transformation of Names , was written by the author of the SMTP protocol ( RFC 2821 ) as a human readable guide to SMTP. In section 3, he gives some examples of valid email addresses.

These are all valid email addresses!

Abc@def@example.com

Fred Bloggs@example.com

Joe.\Blow@example.com

“Abc@def”@example.com

“Fred Bloggs”@example.com

customer/department=shipping@example.com

\$A12345@example.com

!def!xyz%abc@example.com

\_somename@example.com

Note: Gotta love the author for using my favorite example person, Joe Blow .

Quick, run these through your favorite email validation method. Do they all pass?

For fun, I decided to try and write a regular expression ( yes, I know I now have two problems. Thanks. ) that would validate all of these. Here’s what I came up with. (The part in bold is the local part . I am not worrying about checking my assumptions for the domain part for now.)

<sup>(?!.)(“(\[</sup>“\]\|\\“\])\*“\|(\[-a-z0-9!#$`%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)@[a-z0-9][\w\.-]*[a-z0-9]\.[a-z][a-z\.]*[a-z]`$

Note that this expression assumes case insensitivity options are turned on ( RegexOptions.IgnoreCase for .NET ). Yeah, that’s a pretty ugly expression.

I wrote a unit test to demonstrate all the cases this test covers. Each row below is an email address and whether it should be valid or not.

\[ RowTest \] \[ Row ( @“NotAnEmail” , false )\] \[ Row ( @“@NotAnEmail” , false )\] \[ Row ( @“““test\blah”“@example.com” , true )\] \[ Row ( @“““test”“@example.com” , false )\] \[ Row ( “"test\\"@example.com” , true )\] \[ Row ( “"test"@example.com” , false )\] \[ Row ( @“““test"”blah”“@example.com” , true )\] \[ Row ( @“““test”“blah”“@example.com” , false )\] \[ Row ( @“customer/department@example.com” , true )\] \[ Row ( @“$`A12345@example.com" , true )] [ Row ( @"!def!xyz%abc@example.com" , true )] [ Row ( @"_Yosemite.Sam@example.com" , true )] [ Row ( @"~@example.com" , true )] [ Row ( @".wooly@example.com" , false )] [ Row ( @"wo..oly@example.com" , false )] [ Row ( @"pootietang.@example.com" , false )] [ Row ( @".@example.com" , false )] [ Row ( @"""Austin@Powers""@example.com" , true )] [ Row ( @"Ima.Fool@example.com" , true )] [ Row ( @"""Ima.Fool""@example.com" , true )] [ Row ( @"""Ima Fool""@example.com" , true )] [ Row ( @"Ima Fool@example.com" , false )] public void EmailTests ( string email , bool expected ) { string pattern = @"^(?!\.)(""([^""\r\\]|\\[""\r\\])*""|" + @"([-a-z0-9!#`$%&’\*+/=?^\_\`{\|}~\]\|(?\<!.).)\*)(?\<!.)” + @“@\[a-z0-9\]\[.-\]*\[a-z0-9\].\[a-z\]\[a-z.\]*\[a-z\]\$” ; Regex regex = new Regex ( pattern , RegexOptions . IgnoreCase ); Assert . AreEqual ( expected , regex . IsMatch ( email ) , “Problem with ’” + email + “’. Expected” + expected + ” but was not that.” ); }

Before you call me a completely anal nitpicky numnut (you might be right, but wait anyways), I don’t think this level of detail in email validation is absolutely necessary. Most email providers have stricter rules than are required for email addresses. For example, Yahoo requires that an email start with a letter. There seems to be a standard stricter set of rules most email providers follow, but as far as I can tell it is undocumented.

I think I’ll sign up for an email address like phil.h@@ck@haacked.com and start bitching at sites that require emails but don’t let me create an account with this new email address. Ooooooh I’m such a troublemaker.

The lesson here is that it is healthy to challenge your preconceptions and assumptions once in a while and to never let me near an RFC.

UPDATES: Corrected some mistakes I made in reading the RFC. See! Even after reading the RFC I still don’t know what the hell I’m doing! Just goes to show that programmers can’t read . I updated the post to point to RFC 822 as well. The original RFC.

Found a typo or mistake in the post? suggest edit

Comments

206 responses

BCS • August

      20th,
      
      2007 

I once saw a ~3 PAGE regex that was supposed to correctly validate email addresses.

David Leadbeater • August

      20th,
      
      2007 

Actually you’ve interpreted the RFC slightly wrong ;) The RFC says  for escaping is only valid inside a qcontent, so in order to enter characters that need escaping (i.e. other than dot-atom) they need to be inside double quotes (last paragraph of section 3.2.2). e.g.: Abc@def@example.com becomes “Abc@def”@example.com I don’t know about .net but if you look at the source code to the Perl module Email::Valid, you’ll see a huge regex near the end. This actually validates according to the RFC. (Code at http://search.cpan.org/src/… .

Marcelo Calbucci • August

      20th,
      
      2007 

Hahaha… I went through the same issue about a year ago. I knew there was more to an email address than I was assuming, because back in the day I had an email address that looked more like a regular expression, something like: marcelo.calbucci%mandic@fapesp.com.br So, when I was writing my email validator in C# (regular expressions are too slow in some cases) I checked out the RFC, which is way more complex than anyone could ever imagine (except the people that wrote it). After a while I decided to limit the scope and not make it perfect, but good enough. The problem with making it match the spec is that somebody might mistype a symbol instead of a character and your regular expression will find it acceptable. I didn’t want that to happen. If somebody has a weird symbol on their email address we’ll simply reject it.

Jeff Schoolcraft • August

      20th,
      
      2007 

It seems regular expressions come up a lot when someone mentions validating email addresses. Curiously, and just as incorrect in my opinion, regex are also mentioned in the same sentence as parsing HTML. Notice the parsing bit, but that’s not the topic of this post. I’ve presented on the topic of regular expressions a number of times at usergroups and I always put up a slide showing this regex . It’s the regex used by the Perl module Mail::RFC822::Address and it’s nasty. My problem with validating email addresses is even though it conforms to the spec does not mean it’s an active, valid address and worse may not even belong to the user. So it seems we’d want to: 1. Catch simple mistakes to make a better user experience. 2. Have a valid email address that can be used. 3. Make sure the email belongs to the user. So how do we do that? 1. We could use a simple regex that’s not too restrictive to make sure it generally looks like an email address (something @ something probably with a .) We could also make the user type their email address twice, verifying it the same way we would make them verify their password. A quick check on equality either means they didn’t make a mistake, they consistently make that mistake in which case this hasn’t helped us, or they copied and pasted it. 2. We could use a really nasty regex. We could shoot off an external process that tries to verify the email address through the mail server of its domain. We could send some url with a hash and have the user confirm their email. An ongoing part of this solution might also be to cull through bounce mail from the server and invalidate the address. 3. I really don’t know how else to do this besides mailing the user something and requiring them to do something based on the contents of the email. This is the option from \#2 above with the email containing a url and some hash. Do this every time you get a new email address and you should be fairly confident that you can send email address to the user. My thought on this whole thing is: Why collect the data if you’re not going to use it; and why just guess at it’s validity when you could confirm it through user action?

Nathan • August

      21st,
        
      2007 

Firefox’s linkification plugin only identified “Abc@def”@example.com as a correct e-mail…all the others went unlinked.

Haacked • August

      21st,
        
      2007 

@David Hmm… I’m not so sure. The very first sentence of the last paragraph of RFC 2822 3.2.2 states…

Note: The “" character may appear in a message where it is not part of a quoted-pair. </block> Not to mention the examples by the author of the SMTP RFC in RFC 3696 RFC Page 6 shows that the  escaping happens outside of a double quoted string. Note that he says…

When quoting is needed, the backslash character is used to quote the following character.

And goes on to say… In addition to quoting using the backslash character, conventional double-quote characters may be used to surround strings. This implies there are two different ways to quote characters. I think the term quote here is confusing and probably should be escape . In any case, this only bolsters my point that reading a spec is difficult and all specs are ambiguous to the readers. ;)

Haacked • August

      21st,
        
      2007 

@Jeff I agree with your points, but would point out that these are not mutually exclusive points of validation. I think in general there are several levels of validation. I don’t want to try and send you a verification link (as is common) if I already know your email is a fake. Hence when collecting emails, I would do a fairly liberal email validation (for example, make sure there is an @ character). As you point out, this can be beneficial to the user experience to help prevent typos. What would be really bad for user experience is too strict validation where you reject a perfectly valid email that really does belong to the user.

David Leadbeater • August

      21st,
        
      2007 

I definitely agree they are hard to interpret. I’ve fixed bugs related to them on a fairly large email system. I’m not sure the specs are ambiguous in this case, though. The next sentence of section 3.2.2 says:

A “" character that does not appear in a quoted-pair is not semantically invisible. The only places in this standard where quoted-pair currently appears are ccontent, qcontent, dcontent, no-fold-quote, and no-fold-literal.

“not semantically invisible” meaning that it is not interpreted with any special meaning and is displayed as is. Also the reason I picked up on it is the original email RFC categorically states that it must be within double quotes. If anything I’d say it’s a mistake in RFC 3696 (which is only an informative RFC, so is likely to have had less scrutiny than a standards track one).

David Leadbeater • August

      21st,
        
      2007 

I just spotted this is corrected in the errata for RFC 3696.

Tim • August

      21st,
        
      2007 

I ran into something similar with domain name parsing… I never knew this, but non ‘english’ symbols are completely valid such as: http://www.hÔ tels.com/ is a different site than: http://www.hotels.com/ (Hopefully my comment here displays the first URL correctly, but if it doesn’t the letter o in the first URL has a circumflex (e.g a ^ symbol) above it. Searching for this in google requires you to put it in quotes else it will return words with the english ‘o’ in them.

Haacked • August

      21st,
        
      2007 

@David Nice catch, but damn you for creating more work for me! ;) I’ll try and update my post after lunch. :)

Damien Guard • August

      21st,
        
      2007 

I’ve been using a regex that basically checks for at least one non-whitespace char before the @ sign, another one after, a dot and then another two. Looks like you haven’t touched on the international UTF-8 symbols and accented characters that are recommended to be valid (a later RFC perhaps - I think I saw it in the IETF DRUMS 08 on SMTP) \[)amien

Haacked • August

      21st,
        
      2007 

Ok, I finally corrected the post to fix my misinterpretation. Regarding international characters, I know that IRI (International Resourec Identifier) can be mapped to URI by hex encoding using the %HH sequence of bytes. I’m not well versed in this though. And yes, my regex does not take that into consideration at all. Check out the perl regex linked to by other commenters. I wonder if that does. ;)

Rik Hemsley • August

      21st,
        
      2007 

Why try to validate? If you’re being nice to the user, ask them to enter their address twice. If they get it wrong both times, tough luck. They’ll find out when they don’t get a message. If you really want to validate, you could be up tight about it and use a proper parser, but most software does it wrong, so you’ll be in the minority (along with me).

Gabe Krabbe • August

      21st,
        
      2007 

Of course, this is assuming that you’re not trying to parse an actual e-mail. See RFC 2822, section A.5, and think “arbitrary nesting” - it is not technically possible to use a regex and be fully compliant with the standard when trying to figure out the address, but if you want to use it for SMTP (where the comments aren’t allowed), you may have to give it a go. Yes, this has been a long-time favourite of mine to point out that regular expressions are sometimes not the best choice.

Haacked • August

      21st,
        
      2007 

@Rik I’m not sure making a user enter that twice is exactly being nice. I would find it annoying. Especially if you also make them enter their password twice. I think some simple validation is helpful to the user as long as the validation is liberal. As I mentioned in an earlier comment, I think validation on the client should be more liberal than the RFC. It’s fine to have false negatives (emails that are invalid, but you let through) but it’s not fine to have false positives (emails that are valid, but you flag as wrong).

Rik Hemsley • August

      21st,
        
      2007 

Phil, I think users would prefer to have to enter their email address twice (they can copy+paste - at least it makes them look at what they typed) if it means they avoid typos and therefore aren’t sitting wondering why they’re not getting messages - or, worse, that their messages are going to someone else (which is highly possible if they’re on a popular webmail service).

Haacked • August

      21st,
        
      2007 

@Rik I can copy and paste with my eyes closed. It’s an automatic action, like driving to work. Sometimes I drive to work when I mean to drive somewhere else. In other words, I don’t think it helps really. Even so, even with requiring a user enter their email twice, why wouldn’t you do some simple validation. At the very least make sure there is an @ sign.

Lamby • August

      21st,
        
      2007 

Has anyone considered accepting pretty much anything that’s not malicious and then looking up whether MX records for that domain exist? It actually catches typos, it’s not dependent on anyone’s interpretation of a dodgy specification, and it’s fairly future-proof too.

David • August

      21st,
        
      2007 

Yes, please get the word out. Do you know how many sites refuse my email address because it has a + sign in it? It’s very frustrating… The best compromise I’ve seen so far is to have it complain if you use a “weird” character, but then offer you a chance to say “no, that *really* is my email address”. That way it catches stupid mistakes, but lets you have the final say as to whether it’s valid or not. -David

Member Blogs • August

      21st,
        
      2007 

.NET (Phil Haack) knew How To Validate An Email Address Until (he) Read The RFC PowerShell: Using PowerShell

Prashant Rane • August

      21st,
        
      2007 

The O’Reilly “Mastering Regular Expressions” book has a one page regular expression that matches email address. Coming from the book of regular expressions; I assume it would be quite correct. It is towards the end of the book. Sorry, I don’t have it with me right now otherwise I would have given you the page number. Enjoy.

David Stone • August

      21st,
        
      2007 

You’ll find this page interesting: http://www.regular-expressi…

Rik Hemsley • August

      21st,
        
      2007 

Phil, local addresses don’t need an @ sign.

Samus_uy • August

      21st,
        
      2007 

hey! you didn’t validate the domains! perhaps between the two of us can we reach a complete solution :P http://forums.worsethanfail…

Jay Kimble • August

      21st,
        
      2007 

Thanks for getting the word out Phil… Something that isn’t common knowledge, but GMAIL has a neat little Email address hack that I like to try to use sometimes… With Gmail you can append a tag to your email address. So let’s say you have “name@gmail.com” you can give someone an email address of “name++sometag@gmail.com” and it will faithfully arrive in your inbox. The use of this for me is that I can track who’s selling my email address or at least who I gave my email to that is now abusing it. BTW, this site’s email address validator (for comments) is wrong. I just tried adding “++haacked” to my email address… you should fix that <grin />

Travis Illig • August

      21st,
        
      2007 

The comment re: the O’Reilly book is key - Mastering Regular Expressions by Jeffrey Friedl uses matching an email address as an example in chapter 7 (“Perl Regular Expressions”) of how to craft complex regular expressions. The Perl module that was mentioned, Mail::RFC822::Address includes the expression that is arrived at. Email addresses aren’t the only places you’ll find out there containing ridiculous simplifications that lead to incorrect validations. From a larger perspective, it also gets sort of interesting when you encounter someone from a non math/CS background who is a self-taught programmer that you try to explain regular languages to (so they understand why their regexes aren’t working right). Sometimes I feel like regular expressions are sort of a “lost art.”

bofe • August

      21st,
        
      2007 

PHP: http://www.iamcal.com/publi…

Bill Weiss • August

      21st,
        
      2007 

First: Your blog software fails at validating my email address. The only strange character in it is a plus (+). That leads me to my first real point. You said “I think I’ll sign up for an email address like phil.h@@ck@haacked.com and start bitching at sites that require emails but don’t let me create an account with this new email address. Ooooooh I’m such a troublemaker.” Guess what? You’ll get plenty of bitching in if you just use plus addresses. Your SMTP server probably copes with them out of the box. Some asshole’s validation software probably doesn’t. I’ve been on that path for a few years. Out of hundreds of complaints, guess what I’ve gotten? A large number of no response, a large (but smaller) number of indignant “that doesn’t work! Fix your address!”, some “wow, that’s strange. Oh well, our software doesn’t cope.”, and a single digit number of “hey! I’ll fix that to make my software correct!”. It’s not a fun passtime. Second, here’s the regex I use to validate email addresses: .+@\[^@\]+.\[^@\]+ Looks simplistic? It works ok. It’s not actually correct, as it doesn’t take local addresses correctly (me@foo is valid, assuming there’s a machine named foo around). That’s ok, it’s a strange edge case. The real test, of course, is handing the address off to my SMTP server and seeing if you get the email. If you do, congratulations, it’s a real address. If not, guess it wasn’t. You’re verifying those addresses first, right?

Haacked • August

      21st,
        
      2007 

@Bill Thanks for pointing that out. I need to make sure that fix gets into the next version of Subtext. I changed my email validation to be very liberal. .*?@.*

Aaron Jensen • August

      21st,
        
      2007 

I found this attempt at doing the same thing a month or so ago: http://www.iamcal.com/publi… . It is written in PHP, but the regular expression is easily converted to .NET. I haven’t tested it, but it looks pretty thorough. I repeat the comment I made on my web site: how come frameworks don’t come with a common set of regular expressions? How many times have developers had to write regular expressions to validate domains, e-mail addresses, phone numbers, zip codes, etc?

Steven • August

      22nd,
        
      2007 

Please repeat: THE ONLY WAY TO VALIDATE AN EMAIL ADDRESS IS TO DELIVER A MESSAGE TO IT! Warning to all online shopping developers: I am currently in the practice of abandoning a full shopping cart and sending a complaint to your client when your stupid code disallows + in an email address.

Steve • August

      22nd,
        
      2007 

You forget one: \[space\]@domain.tld is valid. GO SPACEBAR!

SeanG • August

      22nd,
        
      2007 

I ran across a website with the full regex built out of the BNF from the rfc and build a C# Method to do this: ///
<summary>

/// RFC822 complaint email address validation. /// see http://iamcal.com/publish/a… for explaination ///
</summary>

/// <param name="emailAddress">the email address to check</param> /// <returns>false if not valid email address, true otherwise</returns> private bool ValidEmailAddress(string emailAddress) { string qtext = “\[^\\x0d\\x22\\x5c\\x80-\\xff\]”; // \<any CHAR excepting \<“\>,”" & CR, and including linear-white-space\> string dtext = “\[^\\x0d\\x5b-\\x5d\\x80-\\xff\]”; // \<any CHAR excluding “\[”, ”\]”, “" & CR, & including linear-white-space\> string atom =”\[^\\x00-\\x20\\x22\\x28\\x29\\x2c\\x2e\\x3a-\\x3c\\x3e\\x40\\x5b-\\x5d\\x7f-\\xff\]+“; // *\<any CHAR except specials, SPACE and CTLs\> string quoted_pair = ”\x5c\[\x00-\x7f\]”; // ”" CHAR string quoted_string = string.Format(”\x22({0}\|{1})*\x22”, qtext, quoted_pair); // \<“\> *(qtext/quoted-pair) \<”\> string word = string.Format(”({0}\|{1})”, atom, quoted_string); //atom / quoted-string string domain_literal = string.Format(”\x5b({0}\|{1})*\x5d”, dtext, quoted_pair); // “\[” \*(dtext / quoted-pair) ”\]” string domain_ref = atom; // atom string sub_domain = string.Format(“({0}\|{1})”, domain_ref, domain_literal); // domain-ref / domain-literal string domain = string.Format(“{0}(\x2e{0})*”, sub_domain); // sub-domain* (”.” sub-domain) string local_part = string.Format(“{0}(\x2e{0})*”, word); // word* (”.” word) string addr_spec = string.Format(“{0}\x40{1}”, local_part, domain); //local-part “@” domain Regex re = new Regex(string.Format(“^{0}\$”, addr_spec)); return re.IsMatch(emailAddress); }

Mark • August

      22nd,
        
      2007 

I completely agree, ignoring the wider picture of what should be validated, how and when. In the straight forward case most regexes are NOT too simplistic. The specifications typically suggest that software generating email addresses must be as rigid (or more) than the spec, but … … software reading email addresses should be less rigid to make up for any crap software that fails to meet the spec. Mind you this leads to the exact same problem that Browsers cause (i.e. any HTML will do)!

Charles Curran • August

      22nd,
        
      2007 

hot air! Why haven’t you updated your comment form to accept any valid e’mail addresses. – We need to root out all the off-the-shelf modules that fail to recognize the local-part of an e’mail address can contain: digits, letters \[a-zA-Z\] (yes, you have to preserve case!), ! \# \$ % & ’ \* + - / = ? ^ \_ \` { \| } ~, and *internal* “.”s. – Later we can deal with utf8-local-part “@” utf8-domain.

Charles Curran • August

      22nd,
        
      2007 

hot air! Why haven’t you updated your comment form to accept any valid e’mail addresses. – We need to root out all the off-the-shelf modules that fail to recognize the local-part of an e’mail address can contain: digits, letters \[a-zA-Z\] (yes, you have to preserve case!), ! \# \$ % & ’ \* + - / = ? ^ \_ \` { \| } ~, and *internal* “.”s. – Later we can deal with utf8-local-part “@” utf8-domain.

neliason • August

      24th,
      
      2007 

This would all be alot easier if we could still use the VRFY command of SMTP. Email spammers made verification alot harder.

Randy Aldrich • August

      24th,
      
      2007 

the ‘+’ character in E-mail addresses is a vital necessity. Its useful for filtering emails and finding out who’s selling your address and probably has 100 other uses. A previous commenter mentioned GMAIL as having the ‘auto-tagging’ feature by adding ++yourtaghere at the end of your username within your email address. For example, johndoe++haacked@gmail.com. This will automatically goto johndoe@gmail.com. In addition to this johndoe+haacked@gmail.com will also be sent to johndoe@gmail.com. However; the single + sign is built into almost all mail servers. I know it works with my company’s Exchange server, Gmail, Yahoo, my local cable company’s E-mail server and I’m sure most any web mail provider allows this. I’ve written about the + operator in your email address in the past. However I get very frustrated with websites which don’t allow it as I’m sure yours is about to do…

JD • August

      25th,
      
      2007 

Oh really intrigued to learn that the prefix to the @ was validated by the sending function. Hopefully I got the picture. Admitedly I skipped a few lines in between beer and TV.

Sara • August

      25th,
      
      2007 

Good job making a billion programmers look stupid…myself included :D

Boris Yeltsin • August

      30th,
      
      2007 

You missed another one… “name@tld” is a valid address. I was very jealous of a friend in the early 90s who had an address which was something like “joe@uk”. Perfectly valid, but 99.9% of all e-mail validation routines check for a “.” in the hostname and refuse it.

János Pásztor • September

      1st,
        
      2007 

One small side thought here: what’s an e-mail address good for if you can’t type it on a common keyboard? Anyway, you are validating e-mail addresses for use not for the RFC. So if the e-mail you got is perfectly valid but your MTA rejects it because of whatsoever spam filtering and stuff, your validation isn’t worth the bytes it takes up. The domain part is interesting, because accented characters are allowed, however most people register the domain names unaccented version as well, so it is safe to say that US-ASCII does the job. In short, you have to test against your mail delivery system and your target audience’s common mail domains, not the RFC.

Stefan • September

      3rd,
        
      2007 

I’ve been using a regex that basically checks for at least one non-whitespace char before the @ sign, another one after, a dot and then another two. Looks like you haven’t touched on the international UTF-8 symbols and accented characters that are recommended to be valid (a later RFC perhaps - I think I saw it in the IETF DRUMS 08 on SMTP)

Raisor • September

      3rd,
        
      2007 

Hi, I found this a “nice-to-read” article … I’m not surprised at all after reading it to end. I’ve once built an online “Email Check” service to validate mail addresses against their domains … what can I say … I’ve studied all applying RFCs and made it work contacting the concerned server using “HELO” … my service only works with a view servers … most providers like Microsoft, Yahoo and Freenet are not even responding to a request. My service still exists … but, as everyone can imagine, it’s worth nothing. My résumé is that RFCs mostly serve the big industry … but they do not serve any scrubby programmer like me! Best regards, Raisor

Joe Cheng \[MSFT\] • September

      5th,
      
      2007 

Don’t forget comments (which can nest). RFC2822 section A.5 has this lovely (valid) example: Pete(A wonderful ) chap) \<pete(his account)@silly.test(his host)\> I don’t think it’s possible to fully parse RFC2822 addresses with regex (at least not without some nesting mechanism, like \[only?\] .NET has). I personally had to use JavaCC/jjtree. http://svn.apache.org/viewv…

Simon Slick • September

      17th,
      
      2007 

To those of you who say things like <space>@domain.tld are valid email addresses. There is a difference between an address being valid (existing) and the format conforming to RFC spec. Existence does not constitute RFC conformance and non-existence does not constitute RFC non-conformance. RFC conformance and actual existence are two different things and validation of each is useful in their own right. For example: if running a mail system and wish to allow customers to create an email addresses in accordance to the full range of RFC spec (or as close as can reasonably get), just how is it supposed to verify when it doesn’t exist yet? Can’t be done by checking for existence now can it. Sometimes it is necessary to know a non-existent (before it is created) email address meets the RFC spec. http://SimonSlick.com/VEAF/…

GMW • September

      25th,
      
      2007 

So many here seem to forget that there is more to email validation that just wanting to correct user input… there is also the issue or parsing a list of emails (as just one example). If I cannot reliably recognise/validate a single email address (including all special characters and quoting rules) how can I possibly parse a string that contains a list of addresses?

Bear • October

      17th,
      
      2007 

Unless I’ve made any mistakes the following should cover everything necessary from RFC2822/2821. The only things lacking (other than TLD specific restrictions- which would require constant checking ; provision for the inclusion of a display-name- I’ve restricted the test to the addr-spec ; General-address-literal support beyond IPv6- unless anyone has any examples they’d expect to see supported ; and comments or folding-white-space between parts- as they break every system I’ve tested on ) are length restrictions (maximum of 64 characters in total) for the local-part(s) and (maximum of 255 characters in total) for the domain which—are only limits in respect of guaranteed support within SMTP implementations, and—would require the use of lookarounds or a second test (as you cannot both allow multiple word sections in the local-part or domain and simoultaneously restrict the overall lengths of these without lookarounds). I’m still looking into the validity of characters beyond the US-ASCII set. <sup>(?:\[</sup>()\<\>@,;:\\“.\[\]-07F-\]+(?:.\[^()\<\>@,;:\\”.\[\]-07F-\]+)*\|"(?:(?:(?:\[*)?\[+)?(?:\[-0B0C0E-1F-5B5D-7F\]\|\\-0B0C0D-7F\]))*(?:(?:\[*)?\[+)?")@(?:(?:[a-zA-Z](?:%5Ba-zA-Z\d-%5D%7B0,61%7D%5Ba-zA-Z\d%5D)?.)+\[a-zA-Z\]{2,}\|\[(?:IPv6:(?:\[1-9a-fA-F\]\[-fA-F\]{1,3}\|\[-fA-F\]\[1-9a-fA-F\]\[-fA-F\]{0,2}\|\[-fA-F\]{0,2}\[1-9a-fA-F\]\[-fA-F\]\|\[-fA-F\]{0,3}\[1-9a-fA-F\]):(?:(?:\[-fA-F\]{1,4}:){6}\|(?:\[-fA-F\]{1,4}:){4}:\|(?:\[-fA-F\]{1,4}:){3}:(?:\[-fA-F\]{1,4}:)?\|(?:\[-fA-F\]{1,4}:){2}:(?:\[-fA-F\]{1,4}:){0,2}\|(?:\[-fA-F\]{1,4}:):(?:\[-fA-F\]{1,4}:){0,3}\|:(?:\[-fA-F\]{1,4}:){0,4})(?:\[1-9a-fA-F\]\[-fA-F\]{1,3}\|\[-fA-F\]\[1-9a-fA-F\]\[-fA-F\]{0,2}\|\[-fA-F\]{0,2}\[1-9a-fA-F\]\[-fA-F\]\|\[-fA-F\]{0,3}\[1-9a-fA-F\])\|(?:(?:(?:0{1,4}:){5}(?:0{1,4}\|\[fF\]{4}):)\|(?:IPv6:::(?:\[fF\]{4}:)?))?(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\])(?:.(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\]?){2}.(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\]))\])\$ Hopefully I’ve copied that in ok.

Bear • October

      17th,
      
      2007 

Oh, and I didn’t bother with any of the obsolete tokens as these only have to be honored when interpreting messages but must be ignored when generating messages - so don’t matter when it comes to make using of the email addresses validated.

Bear • October

      17th,
      
      2007 

The local-part in that last one was a mix of characters not allowed (the atom class) and characters allowed (the qtext and quoted-pair classes) — the following rewrites the qtext and quoted-pair classes as disallowed character ranges which is perhaps easier to read: <sup>(?:\[</sup>()\<\>@,;:\\“.\[\]-07F-\]+(?:.\[^()\<\>@,;:\\”.\[\]-07F-\]+)*\|"(?:(?:(?:\[*)?\[+)?(?:\[^\\080-\]\|\\^\n\r\u0080-\uFFFF\]))*(?:(?:\[*)?\[+)?")@(?:(?:[a-zA-Z](?:%5Ba-zA-Z\d-%5D%7B0,61%7D%5Ba-zA-Z\d%5D)?.)+\[a-zA-Z\]{2,}\|\[(?:IPv6:(?:\[1-9a-fA-F\]\[-fA-F\]{1,3}\|\[-fA-F\]\[1-9a-fA-F\]\[-fA-F\]{0,2}\|\[-fA-F\]{0,2}\[1-9a-fA-F\]\[-fA-F\]\|\[-fA-F\]{0,3}\[1-9a-fA-F\]):(?:(?:\[-fA-F\]{1,4}:){6}\|(?:\[-fA-F\]{1,4}:){4}:\|(?:\[-fA-F\]{1,4}:){3}:(?:\[-fA-F\]{1,4}:)?\|(?:\[-fA-F\]{1,4}:){2}:(?:\[-fA-F\]{1,4}:){0,2}\|(?:\[-fA-F\]{1,4}:):(?:\[-fA-F\]{1,4}:){0,3}\|:(?:\[-fA-F\]{1,4}:){0,4})(?:\[1-9a-fA-F\]\[-fA-F\]{1,3}\|\[-fA-F\]\[1-9a-fA-F\]\[-fA-F\]{0,2}\|\[-fA-F\]{0,2}\[1-9a-fA-F\]\[-fA-F\]\|\[-fA-F\]{0,3}\[1-9a-fA-F\])\|(?:(?:(?:0{1,4}:){5}(?:0{1,4}\|\[fF\]{4}):)\|(?:IPv6:::(?:\[fF\]{4}:)?))?(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\])(?:.(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\]?){2}.(?:25\[0-4\]\|2\[0-4\]1\|\[1-9\]))\])\$

Bear • October

      17th,
      
      2007 

oops… starting to look like spam but in the first post the quoted-pair rule should read: \\-0B0C0E-7F instead of \\-0B0C0D-7F Just a simple change from 0D to 0E to discount the CR.

BradVin’s .Net Blog • October

      22nd,
        
      2007 

So every developer has (or should have) a utilities class for strings. It seems the built-in string class

Nuno Gomes • January

      4th,
      
      2008 

Email Regular Expression

wwheeler • February

      15th,
      
      2008 

Guys, http://www.ex-parrot.com/~pdw/Mail-RFC822-Address.html :-D

Professional Website Design • April

      14th,
      
      2008 

Very interesting and amusing. Can anyone say why the hell they made the RFCs so damned complicated? Two points: 1. One can do lots of really complicated things with Regular Expressions but sometimes they are just not appropriate and perhaps a state machine would work better. The problem I find with big regular expressions is that they are not exactly self documenting. In my view a regex longer than a single line might as well be line noise. But perhaps that’s just me getting past it. 2. When I was still a programmer I found that my colleagues, on the whole, didn’t have a clue about how to use regular expressions. One result of this was that they often did lots of repetitious editing while I would creat a regex to do it all in one step. Nick

ken • May

      1st,
        
      2008 

Reading these RFCs has only made me more confused. RFC 822 says: “… a specification such as: Full Name@Domain is not legal and must be specified as:”Full Name”@Domain …” but RFC 3696 says “Blank spaces may also appear, as in Fred Bloggs@example.com …” Who’s right? :%

Tagesgeld • May

      18th,
      
      2008 

Well, I´m quite confident with this one: “^(((\[a-z\]\|\[0-9\]\|!\|#\|$`|%|&|'|\*|\+|\-|/|=|\?|\^|_|`|\{|\||\}|~)+(\.([a-z]|[0-9]|!|#|`$\|%\|&\|’\|\*\|+\|-\|/\|=\|?\|^\|\_\|\`\|{\|\|\|}\|~)+)*)@(((((\[a-z\]\|\[0-9\])(\[a-z\]\|\[0-9\]\|-){0,61}(\[a-z\]\|\[0-9\]).))*(\[a-z\]\|\[0-9\])(\[a-z\]\|\[0-9\]\|-){0,61}(\[a-z\]\|\[0-9\]).(af\|ax\|al\|dz\|as\|ad\|ao\|ai\|aq\|ag\|ar\|am\|aw\|au\|at\|az\|bs\|bh\|bd\|bb\|by\|be\|bz\|bj\|bm\|bt\|bo\|ba\|bw\|bv\|br\|io\|bn\|bg\|bf\|bi\|kh\|cm\|ca\|cv\|ky\|cf\|td\|cl\|cn\|cx\|cc\|co\|km\|cg\|cd\|ck\|cr\|ci\|hr\|cu\|cy\|cz\|dk\|dj\|dm\|do\|ec\|eg\|eu\|sv\|gq\|er\|ee\|et\|fk\|fo\|fj\|fi\|fr\|gf\|pf\|tf\|ga\|gm\|ge\|de\|gh\|gi\|gr\|gl\|gd\|gp\|gu\|gt\| gg\|gn\|gw\|gy\|ht\|hm\|va\|hn\|hk\|hu\|is\|in\|id\|ir\|iq\|ie\|im\|il\|it\|jm\|jp\|je\|jo\|kz\|ke\|ki\|kp\|kr\|kw\|kg\|la\|lv\|lb\|ls\|lr\|ly\|li\|lt\|lu\|mo\|mk\|mg\|mw\|my\|mv\|ml\|mt\|mh\|mq\|mr\|mu\|yt\|mx\|fm\|md\|mc\|mn\|ms\|ma\|mz\|mm\|na\|nr\|np\|nl\|an\|nc\|nz\|ni\|ne\|ng\|nu\|nf\|mp\|no\|om\|pk\|pw\|ps\|pa\|pg\|py\|pe\|ph\|pn\|pl\|pt\|pr\|qa\|re\|ro\|ru\|rw\|sh\|kn\|lc\|pm\|vc\|ws\|sm\|st\|sa\|sn\|cs\|sc\|sl\|sg\|sk\|si\|sb\|so\|za\|gs\|es\|lk\|sd\|sr\|sj\|sz\|se\|ch\|sy\|tw\|tj\|tz\|th\|tl\|tg\|tk\|to\|tt\|tn\|tr\|tm\|tc\|tv\|ug\|ua\|ae\|gb\|us\|um\|uy\|uz\|vu\|ve\|vn\|vg\|vi\|wf\|eh\|ye\|zm\|zw\|com\|edu\|gov\|int\|mil\|net\|org\|biz\|info\|name\|pro\|aero\|coop\|museum\|arpa))\|((((\[0-9\]){1,3}.){3}(\[0-9\]){1,3}))\|(\[(((\[0-9\]){1,3}.){3}(\[0-9\]){1,3})\])))\$” It´s not perfect, but works fine.

PG • May

      28th,
      
      2008 

Using Regex for email syntax/format validation is something that I think shouldn’t be attempted. It’s the “holy grail” of regex writers and none have truly achieved it. The other issue I see, even looking atthe examples above, is that the patterns very quickly become so convoluted as to become unmaintainable. A few years ago I wrote a regex compare, and I’ve just updated it with your examples from the top - caused me to have to change my procedural code (so yes, I’m not perfect either :) but my point is fixing my procedure/function was done in seconds and 3rd party peer review is able to look at the code and say yes/no on the logic. http://www.pgregg.com/projects/php/code/showvalidemail.php IMHO, I think the search (and time) of email regex simply isn’t worth it.

HM2K • June

      10th,
      
      2008 

I had a crack at this myself, I wasn’t satisfied by what i’d seen here, so I went on to investigate it myself… The results are found here -\> www.hm2k.com/posts/what-is-a-valid-email-address Hope somebody finds this useful.

Ace • July

      4th,
      
      2008 

Email normalization presents similar challenges. Let’s say you have a system where you’d like to prevent a user from registering twice, based on unique email addresses. Granted, it’s easy enough to create a new one with the free services like Hotmail, GMail or Yahoo – but let’s say you’d like people to have to at least go to that level of effort before they’re allowed to create a new account. So an addresses like “user”@domain.tld and user@domain.tld and(comment)user@domain.tld and user@\[ip addr\] are all the same, and if the system supports tags, like GMail, then user+tag@domain.tld might also be the same.

Webdesign Hamburg • September

      18th,
      
      2008 

Very interesting stuff! Looks like I have to re-design all the contact forms on all my websites! Gosh! I’m not sure whether to love you or hate you…

Bear • October

      17th,
      
      2008 

oh dear oh dear — The question of whether the effort is worthwhile is valid one, after all mickey@disney.com is valid in terms of the RFC or STD but is almost certainly not the address of someone completing your form! But why do so many people feel it necessary to go on about how impossible, rather than how pointless, this is and then cite other peoples failed attempts at proof rather than get on with a serious attempt of their own! As for hard coding TLDs into the expression — personally, I don’t fancy having to keep track of the creation of new TLDs and updating my expressions when I know what the rules are that TLDs will have to follow. The only possible reason to go as far as to account for individual TLDs is if you then branch your code and include expressions to account for each TLDs domain name restrictions. I’d be interested to hear any faults with my expression beyond the limitations I already admitted and the only other remaining hurdle: internationalisation, which is poorly documented but important and will become even more important once ICANN complete their evaluation period for IDN TLDs ( http://idn.icann.org/ ). The following may be easier to follow as it excludes the alternation on the domain side that accounts for Address-Literals as this accounts for the bulk of the expression: (\[<sup>()\<\>@,;:".\[\]-07F-\]+(?:.\[</sup>()\<\>@,;:\\.\[\]-07F-\]+)*\|"(?:(?:(?:\[*)?\[+)?(?:\[^\\080-\]\|\\^\n\r\u0080-\uFFFF\]))*(?:(?:\[*)?\[+)?")@((?:[a-zA-Z](?:%5Ba-zA-Z\d-%5D%7B0,61%7D%5Ba-zA-Z\d%5D)?.)+\[a-zA-Z\]{2,})

The Silverback Programmer • October

      23rd,
        
      2008 

(sigh) I must be showing my age…guess I can’t get a job anymore. FizzBuzz solution (proven at runtime to be correct) written in python: for myCounter in range(1,100): if (myCounter % 3) == 0 or (myCounter % 5) == 0: if (myCounter % 3) == 0: print “fizz” if (myCounter % 5) == 0: print “buzz” if ((myCounter % 3) == 0) and ((myCounter % 5) == 0): print “fizzbuzz” else: print myCounter Total time to write it: about 7 minutes (5 minutes initial, 2 more to remove a stupid format problem in the program that printed a space). Like I said, it’s proven at runtime. I’ve already observed the output and it is correct. If you think it isn’t, go back and re-read the damn request. It’s simple. fizz at 3s, buzz at 5s, fizzbuzz at 3s and 5s, number otherwise. Jesus on a f’n pogo stick, if a mediocre programmer like myself can write it, then what the hell are the other “expert programmers” doing? And I can’t get a job elsewhere? What the hell?

alexoss • November

      4th,
      
      2008 

This was a VERY valuable chunk of info for me! Thank you! I especially liked the C# code above, but I wrote my own version using RFC 2822 instead of 822, with the exceptions that I don’t allow comments, folding (multiline) white space, white space generally (except within quoted-string and domain-literal), and obsolete syntax. This is a singleton static method. public static Regex GetInstance() { lock (syncObject) { if (theRegex == null) { string ALPHA = “(\[\x41-\x5A\]\|\[\x61-\x7A\])”; string DIGIT = “\[\x30-\x39\]”; string DQUOTE = “\x22”; string WSP = “\[\x09\x20\]”; string NO_WS_CTL = “\[\x01-\x08\x0B\x0C\x0E-\x1F\x7F\]”; string text = “\[\x01-\x09\x0B\x0C\x0E-\x7F\]”; string atext = “(” + ALPHA + “\|” + DIGIT + “\|\[\\\\\\$`\\%\\&\\'\\*\\+\\-\\/\\=\\?\\^_\\`\\{\\|\\}\\~])"; string qtext = "(" + NO_WS_CTL + "|[\\x21\\x23-\\x5B\\x5D-\\x7E])"; string dtext = "(" + NO_WS_CTL + "|[\\x21-\\x5A\\x5E-\\x7E])"; string dot_atom_text = atext + "+(\\." + atext + "+)*"; string dot_atom = dot_atom_text; string quoted_pair = "\\\\" + text; string qcontent = "(" + qtext + "|" + quoted_pair + ")"; string dcontent = "(" + dtext + "|" + quoted_pair + ")"; string quoted_string = DQUOTE + "(" + WSP + "?" + qcontent + ")*" + WSP + "?" + DQUOTE; string local_part = "(" + dot_atom + "|" + quoted_string + ")"; string domain_literal = "\\[(" + WSP + "?" + dcontent + ")*" + WSP + "?" + "\\]"; string domain = "(" + dot_atom + "|" + domain_literal + ")"; string addr_spec = "^" + local_part + "\\@" + domain + "`$”; theRegex = new Regex(addr_spec); } } return theRegex; }

Mark • November

      10th,
      
      2008 

in php: function verifyEmail(\$Email) { // returns 1 for valid, else 0 $`domain = substr(strrchr(`$Email,‘@’),1); $`normal = (preg_match('/^([^@]{1,64}|\".{0,62}\")@[^@]{1,255}`$/‘,\$number) == 1) ? true: false; $`normal = (preg_match('/^([^\.]{1,63}\.)*[^\.]{2,6}`$/’,\$domain) == 1) ? \$normal : false; $`pat = "/^(([\w!#`$%&’*+-/=?<sup>\`{\|}~\]+.)*(\[!#\$%&’*+-/=?</sup>\`{\|}~\]\|\\)+“; \$pat .=”\|"(\[^\\\]\|\\)*")“; \$pat .=”@“; \$pat .=”((((+-)\*)+.)+“; $`pat .= "|\[(([1-9]\d?|1\d{2}|2([0-4]\d|5[0-5]))\.){3}([1-9]\d?|1\d{2}|2([0-4]\d|5[0-5]))\])`$/”; return ($`normal === true) ? preg_match(`$pat,\$Email) : 0; } In this incarnation, no support for local or tld Email addresses \[johndoe@com, johndoe@machine3\] although it would be simple to add does the rfc support johndoe@123.123.123.123 or must it be johndoe@\[123.123.123.123\] ?

Mark • November

      10th,
      
      2008 

that first preg_match should be a match with \$Email, not \$number, incidentally.. :)

Mark • November

      10th,
      
      2008 

one more correction: $`pat = "/^(([\w!#`$%&’*+-/=?<sup>\`{\|}~\]+.)*(\[!#\$%&’*+-/=?</sup>`{|}~]|\\.)+"; $pat .= "|\"([^\"]|\\.)*\")"; should be [supposing "johndoe@machine3\"@domain.com is not valid] $pat = "/^(([\w!#$%&'*+\-\/=?^`{\|}<sub>\]+.)*(\[!#\$%&’*+-/=?^\`{\|}</sub>\])+“; \$pat .=”\|"(\[^\\\\\]\|\\)*")“; then it’ll need full utf-8 support..

mcv • December

      1st,
        
      2008 

I truly don’t see the point of extremely detailed email validation. It just won’t work, and you run the risk of refusing valid addresses. The only way to be really sure that the email belongs to the person filling in your web form, is by sending a conformation email. All you can do before that is just make sure there is an address in the first place, and it’s not complete garbage. So here are the steps of the best kind of email validation for a web form: 1. Does it contain at least one @ character? (More than one is allowed in certain circumstances) 2. Is there at least one character before the last @? 3. Is the string after the @ a legal domain name? 4. Does the domain name exist (look it up in DNS)? 5. Send the confirmation email. Does somebody respond? Anything beyond that just means you’re probably denying somebody access to your service. And you’re doing extra work for it too.

gjel1 • December

      11th,
      
      2008 

We have a “customer” database that they want us to spin through and validate the email addresses for. We have a tool that performs a DNS lookup on the email domain and then an SMTP session to the list of returned mail servers from the DNS lookup. The SMTP session does a VRFY and if that does not work, it will do a MAIL FROM and RCPT TO. The process would stop on the first mail server if it is a success. the database contains thousends of emails for “hotmail”, “yahoo” and “aol”, do you think that we would be listed as spammers on “hotmail”, “yahoo” or “aol” for doing this? Now for the big one … the list contains almost 3 million emails. What would you suggest we do as far as throttling and batching? We certainly do not want to get us on a SPAM list

Mark • December

      16th,
      
      2008 

I really see no need for world of warcraft, 2nd life, etcetera; however, there are clearly people who do see a need :) As a for instance, say your website has an ‘enter your Email address to subscribe to a newsletter’ input, people may not want to bother validating it as well. As long as it’s well written, it in fact does work, it in fact validates all valid Email addresses, plus some that less effective parsers would ignore - all potential customers! :)

Mark • December

      16th,
      
      2008 

Incidentally, it looks as though the code possibly got mangled there; this is a paste direct from the code that is definitely working, so unless the webpage modifies it, should work: \$pat = “/^”; \$pat .= “(”; $`pat .= "([\w!#`$%&’*+-/=?<sup>\`{\|}~\]+.)*(\[!#\$%&’*+-/=?</sup>\`{\|}~\]\|\\)+“; \$pat .=”\|“; \$pat .=”"(\[^\\\]\|\\)*"“; \$pat .=”)“; \$pat .=”@“; \$pat .=”(“; \$pat .=”(((+-)\*)+.)+“; \$pat .=”\|“; \$pat .=”\[((\[1-9\]\|1\|2(\[0-4\]5\[0-5\])).){3}(\[1-9\]\|1\|2(\[0-4\]5\[0-5\]))\]“; \$pat .=”)“; $`pat .= "`$/”;

manly • December

      22nd,
        
      2008 

return System.Uri.IsWellFormedUriString(“mailto:” + emailAddress, System.UriKind.Absolute); seemed like a much simplier approach to the problem

adderek • December

      29th,
      
      2008 

I knew that one already. Several years ago I did not, though. But it would not be a problem for me since my way of doing is “do it as the specification says”. Another thing that might be interesting for you is ISO-8601. I found that people doeas not know the INTERNATIONAL data/time/etc. format. If you see a date 01/02/03 or 01-02-03 or 01.02.03 or 123456 or …. what date is it ?!? Silly american format where less significant units (months) are first and most significant (years) last? or maybe stupid date format used in for example Poland: DD.MM.YYYY (sometime YY is used for year)? Just in a brief: 1) Use always YYYY-MM-DD (YYYYMMDD if you cannot use dashes) 2) Never use YYYYMM or YYMMDD 3) If possible, try using YYYY-MM-DD”T”HH:MM:SS Some point for you to consider: - When date is sorted from-most-significant-to-least then it is the same as numbers (most significant digit on the left) for “commonly used number systems”. - When date is sorted from-most-significant-to-least then you can sort it alphabetically - it would be the same as by date. - This is an international form. A standard. Use it. - Having thousands of date formats makes it easy to misunderstand dates.

Domy Ferraro • January

      7th,
      
      2009 

Hello, maybe it’s little bit off topic, but I wrote a .Net component that allows a good validation: it’s named df_mailstuff and it’s given for free. Regards

Moderator • January

      11th,
      
      2009 

Hi Domy, Could you tell us where to find that component. I’m a .NET developer too and would be quite interested to know. Thanks…

Shawn Martin • January

      19th,
      
      2009 

Thanks for this post. It’s a topic of interest to me lately since I’ve been working on an SMTP server. Here’s my 2 cents… I’d like to emphasize a point that made earlier - context is very important. The exact format of an SMTP address is different in a message envelope than it is in a message header and it’s yet again different in an HTML file. What’s allowed in a forward path is even different from what’s allowed in a reverse path. Also, there are new RFCs (\<a href” http://tools.ietf.org/html/rfc5321”\>5321 \<a href” http://tools.ietf.org/html/rfc5322”\>5322 ) as of October 2008 that replace 2821 and 2822. They’re a bit cleaner. For example the definition of quoted-string was a broken mess in 2821 and it’s now fixed.

Shawn Martin • January

      19th,
      
      2009 

One more try: 5321 5322

Dominic Sayers • February

      9th,
      
      2009 

Thanks for releasing this work under a commons license. I’d like to add your test cases to my test suite. Yes, I’ve got an email address validator too :-) Here’s a head-to-head comparison of various public-domain validators: http://www.dominicsayers.com/isemail/

Dominic Sayers • February

      12th,
      
      2009 

OK, I’m now adding your unit tests into my test suite described here: http://www.dominicsayers.com/isemail/ I’m having trouble interpreting this one: \[Row(“"test\\"@example.com”, true)\] Is that a Carriage Return in the middle there? I’m not too hot on .NET string literals. Anyway, I agree that Folding White Space is OK in a quoted-string (see RFC2822 Section 3.2.5). But I don’t agree that you can have an unquoted backslash in there. It looks like this test is semantically equivalent to this one: \[Row(@“““test”“@example.com”, false)\] which you correctly mark as false. What am I missing, Phil?

haacked • February

      13th,
      
      2009 

@Dominic hmmm… i think you’re right. Worth removing that one.

Alex Holland • February

      19th,
      
      2009 

I’ve been using your regex for sometime now to validate email addresses - it is the best I have encountered - thank you for putting it out there. However I just discovered that it seems to reject abc@q.com as invalid - is this intentional ? I ask because there do appear to be email addresses in use where the first part of the domain after the @ is a single letter.

Dominic Sayers • February

      19th,
      
      2009 

OK, I’ve now released version 1.0 of my PHP address validator. I’m sure somebody could transcribe it into C# quite easily. Thanks again to Phil Haack for putting his test cases in the public domain. blog.dominicsayers.com/…/email-address-valida…

haacked • February

      20th,
      
      2009 

@Alex Not sure if that was intentional. I’ve never seen a one letter domain before. Wow.

Dominic Sayers • February

      21st,
        
      2009 

How about a 180-degree change of opinion from last week? I’ve now discussed the issue of backslashes in the local part with Dave Child and Cal Henderson and the consensus is that they are fine in a quoted string whatever they are escaping. The only proviso is that they have to be escaping something, so a backslash can’t be the last character before the closing double quote. Sorry for any confusion :-) More here: http://www.dominicsayers.com/isemail

Richard Smith • March

      17th,
      
      2009 

I wrote an email validation with grouping expression a while ago and i have never needed anything more than this: /(+\[-.\]\*)@(+\[.\]{1}(com$`|gov`$\|mil$`|edu`$\|arpa$`|biz`$\|eu$`|info`$\|int $`|name`$\|nato$`|net`$\|org\$\|co.))/i It seems a little… simple and strict now that i have read this, but i doubt i will change this validation methed as it hasn’t failed me yet… that i know of \<.\<

oliver khoury • December

      14th,
      
      2009 

You’ve tried to sign in too many times with an incorrect e-mail address or password, or someone else is trying to sign in to the account

Joel • January

      28th,
      
      2010 

This fails on single character domain names ie me@e.com It isn’t tested but is probably worth adding to your tests.

chris • February

      8th,
      
      2010 

“I believe erratum ID 1003 is slightly wrong. RFC 2821 places a 256 character limit on the forward-path. But a path is defined as Path =”\<” \[ A-d-l “:” \] Mailbox “\>” So the forward-path will contain at least a pair of angle brackets in addition to the Mailbox. This limits the Mailbox (i.e. the email address) to 254 characters.” www.rfc-editor.org/errata_search.php?rfc=3696

emmanuel LEVY • February

      19th,
      
      2010 

This is an excellent work, and it is very clearly and very honestly presented. Thanks much! In my experience (our typical client is frankly non-geek), an email address which looks weird - and that would be accepted by a thoroughly RFC-compliant algorithm - is actually a typo. Ideally, what we would need would be an algorithm designed to exclude typos. For instance, our algorithm rejects addresses ending with @homail.com… (in France, we have a big ISP named wanadoo.fr - 10% of our users spell it wanado.fr , or wabadoo.fr or wannadoo.fr or various sometimes exhilarating variations)

shamiiii • February

      28th,
      
      2010 

I know a lot of you are wondering how to hack Yahoo..Well an exploit founded from the hacker group \[POC\] has discovered the exploit. Me, being a close friend of the leader, I have posted what he has sent me: Hey, I found this way to hack Yahoo, it’s actually pretty easy, here is what you do: 1.) Write in the body of the letter The person’s email address your hacking. 2.)Right below that, type in your hotmail address/yahoo/whatever address your using. 3.) Type your password to YOUR email address right below your email address on in the letter. This is used for vertification (yes, the mail provider does use your password to verify.) 4.) Here is an example of what this should look like: Joeschmo@yahoo.com Frank@yahoo.com password to frank@yahoo.com Joeschmo is the address your hacking, frank is your email address, and then the password to frank@yahoo.com is your password for your email address. Now the final, and MOST IMPORTANT STEP is to email all of this to email this to retrieve_mypass_608@yahoo.com, with this code pasted right below the password to your email address: adsflwro%$`#AR11345. That code is what will trigger the pw_retrieved@yahoo.com to send you back a message with the person's password. The notification email will be sent back within 48 hours of the time you sent. So here is what it will all look like in the end: Joeschmo@yahoo.com Frank@yahoo.com Password to frank@yahoo.com adsflwro%`$\#AR11345 And remember, send this to retrieve_mypass_608@yahoo.com

Concerned • March

      15th,
      
      2010 

I don’t know how gullible you think we all are shamiiii. I’ve reported this phishing attempt to yahoo and they will be deleting your accounts.

Michael Zeitarbeit • March

      18th,
      
      2010 

Thank you for your coding tips!

Marius Gedminas • March

      29th,
      
      2010 

Would you please fix the spelling of “odd sight”?

McConnell Group • May

      4th,
      
      2010 

Thank you for the coding tips i will start to use them, Shawn

evoisard • May

      26th,
      
      2010 

Back to the local-part escaping and special chars issue: Apparently, distinction must be made if we consider characters that are permitted in email addresses as they appear in the fields of the header of an actual message (RFC 2822, formerly RFC 822) and in email addresses as they must be during the sending of a message with SMTP (RFC 2821, formerly RFC 821). In RFC 821, I find nothing against ‘' escaping US-ASCII chars in dot-string. see page 30,31: <char> ::= <c> \| “" <x> with: <x> ::= any one of the 128 ASCII characters (no exceptions) While in”clarifications” in ch 3.4.2 of RFC 822 it’s made clear that’' escaping must be within a quoted-string. Then, both RFC 2821 and RFC 2822 say that ’' escaping (quoted-pair) must only be within a quoted-string. This is also backed in RFC 3696 errata. But in addition to this, page 37 of RFC 2821 says: “Systems MUST NOT define mailboxes in such a way as to require the use in SMTP of non-ASCII characters (octets with the high order bit set to one) or ASCII”control characters” (decimal value 0-31 and 127). These characters MUST NOT be used in MAIL or RCPT commands or other commands that require mailbox names.” If I understand it, this limits considerably the need for escaping special chars, and also the variety of “true” email addresses (I mean not as they can be formatted in messages headers but as they must really be for being correctly processed with SMTP by the MTAs)… Doesn’t this indicate that we cannot rely only on RFC 822 and RFC 2822 for deciding what a valid email address is? Eric

Lines • July

      12th,
      
      2010 

I still have my problems with coding in this manner, but i think, i should ask a friend who is an expert.

Matthew Fedak • July

      13th,
      
      2010 

I never really rely on the RFC email standards that much, I set the field to varchar(255) in my mysql db and then just use a simple validate email regex i found for php on the web. If people have weird punctuation in their email thats their problem. Their probably arkward people in general who you wouldn’t want as customers in your online shop anyhow. I guess having said that though, it does give them another reason to be arkward about there email being refused.

junk yards • July

      22nd,
        
      2010 

Wanted, but not needed is a module that would function sort of like a MySpace area for each user. Pictures, Videos, Blog, profiles, maybe some games, etc…

tom • July

      25th,
      
      2010 

I have this below issue in Perl. I have a file which I get as an input. This file contains a list of email addresses. I would like to parse the name before ‘@’ and store in an array. For eg. in : abcdefgh@gmail.com, i would like to parse the name abcdefgh. My intention is to get only the string before ‘@’. But while I use regular expression : \$mail =~ “@” in Perl, it’s not giving me the result. Also, how will I find that the character ‘@’ in which index of the email ID? I appreciate if you can help me out. \#! usr/bin/perl $`mail = "abcdefgh@gmail.com"; if (`$mail =~ “@” ) { print(“my name = good!”); } else { print(“my name = bad!”); } if (\$mail =~ “@” ) will work only if \$mail = “abcdefgh@gmail.com”; but in my case, i will be getting the input with email address as its. Not with an escape character. Waiting for a solution from you… Thanks, Tom

Michael • August

      7th,
      
      2010 

Interesting article and discussion… Thanks. But why not just initiate SMTP session and listen to responce for MAITO: command? That is if you really need to have live address and it is YOU, who need it, not the user?

Michael • August

      8th,
      
      2010 

Typo: MAITO:-\>RCPT To:

Tagesgeld.info • August

      12th,
      
      2010 

A very interesting theme. The most importantquestion for me is why the hell they made the RFCs so damned complicated?

Michael • August

      13th,
      
      2010 

It might also be worth noting, for those who don’t know, that PHP has an in-built function for validating email addresses: filter_var(\$email_address, FILTER_VALIDATE_EMAIL)

Christian • August

      26th,
      
      2010 

“odd sight” not “odd site” (third sentence)

Paul • September

      13th,
      
      2010 

This does not work for: a@a.com or any 1 character username before @

Paul • September

      13th,
      
      2010 

correction: this does not work for 1 char domains like t.co

Bob • October

      27th,
      
      2010 

Great article, now it’s time to try this out for myself.

Brandon • October

      31st,
        
      2010 

@Paul: Modified regex that fixes this, I believe it’s still sound: <sup>(?!.)(““(\[</sup>““\]\|\\““\])\*““\|(\[-a-z0-9!#$`%&'*+/=?^_`{|}~]|(?<!\.)\.)*)(?<!\.)@[a-z0-9][\w\.-]*[a-z0-9]*\.[a-z][a-z\.]*[a-z]`$

Tagesgeld • November

      13th,
      
      2010 

Thanks for the explantion - I tried it by myself and it worked fine at all - thank you…

Xel-ha • December

      6th,
      
      2010 

Sadly, almost none of these combinations works in Hotmail! It’s supposed they should follow the standards, but if you want to send an email to abc!def@somethig.tld is not possible… so, if you have a friend with a valid account that uses a ! in his email, you cannot send him emails using hotmail… :S I tested other valid combinations, and none of them seems to be valid by Hotmail… They’re all valid in Gmail and Yahoo, and other email servers. I don’t understand why Hotmail it’s always the exception….

Bernd Jendrissek • December

      13th,
      
      2010 

Stefan:

I’ve been using a regex that basically checks for at least one non-whitespace char before the @ sign, another one after, a dot and then another two.

That fails for some Sean in Anguilla: lists.gnupg.org/…/016994.html

SPB • December

      18th,
      
      2010 

You have a beneficial Blog the following Mate. Love your articles really informative, Please keep up the good work.

Lodewijk Andre de la Porte • January

      5th,
      
      2011 

.*?@.*?./.\*? I never really quite see the problem with matching very exactly, it’s only going to get you into trouble for getting it wrong. When used while entering a form this is accurate enough and even when it gets to the backend and the server can’t mail to it there’s no real problem. It should just treat it like any other not functional email adres (that was or was not valid). Robust and simple. That should be everyones design philosophy.

haacked • January

      5th,
      
      2011 

@Lodewijk I totally agree! In fact, that was the point of my follow up blog post .

Tagesgeld-Zinsen • February

      6th,
      
      2011 

This does not work for 1 char domains like t.co . Is it possible to make it work for such 1 char domains too?

Dorian Muthig • April

      2nd,
        
      2011 

A valid email address must consist of at least three characters, contain the @ character at least once, and the last character may never be the @ character. There, simple. Now, for verifying internet email addresses, it must consist of at least six characters, contain the @ character at least once and the last four characters must contain one dot, where neither the first nor the last two of those four may be either the @ character or the dot character. There, a bit more complicated, but also rather simple.

Geldanlage Vergleich • April

      21st,
        
      2011 

I also prefer this method: “^(((\[a-z\]\|\[0-9\]\|!\|#\|$`|%|&|'|\*|\+|\-|/|=|\?|\^|_|`|\{|\||\}|~)+(\.([a-z]|[0-9]|!|#|`$\|%\|&\|’\|\*\|+\|-\|/\|=\|?\|^\|\_\|\`\|{\|\|\|}\|~)+)*)@(((((\[a-z\]\|\[0-9\])(\[a-z\]\|\[0-9\]\|-){0,61}(\[a-z\]\|\[0-9\]).))*(\[a-z\]\|\[0-9\])(\[a-z\]\|\[0-9\]\|-){0,61}(\[a-z\]\|\[0-9\]).(af\|ax\|al\|dz\|as\|ad\|ao\|ai\|aq\|ag\|ar\|am\|aw\|au\|at\|az\|bs\|bh\|bd\|bb\|by\|be\|bz\|bj\|bm\|bt\|bo\|ba\|bw\|bv\|br\|io\|bn\|bg\|bf\|bi\|kh\|cm\|ca\|cv\|ky\|cf\|td\|cl\|cn\|cx\|cc\|co\|km\|cg\|cd\|ck\|cr\|ci\|hr\|cu\|cy\|cz\|dk\|dj\|dm\|do\|ec\|eg\|eu\|sv\|gq\|er\|ee\|et\|fk\|fo\|fj\|fi\|fr\|gf\|pf\|tf\|ga\|gm\|ge\|de\|gh\|gi\|gr\|gl\|gd\|gp\|gu\|gt\| gg\|gn\|gw\|gy\|ht\|hm\|va\|hn\|hk\|hu\|is\|in\|id\|ir\|iq\|ie\|im\|il\|it\|jm\|jp\|je\|jo\|kz\|ke\|ki\|kp\|kr\|kw\|kg\|la\|lv\|lb\|ls\|lr\|ly\|li\|lt\|lu\|mo\|mk\|mg\|mw\|my\|mv\|ml\|mt\|mh\|mq\|mr\|mu\|yt\|mx\|fm\|md\|mc\|mn\|ms\|ma\|mz\|mm\|na\|nr\|np\|nl\|an\|nc\|nz\|ni\|ne\|ng\|nu\|nf\|mp\|no\|om\|pk\|pw\|ps\|pa\|pg\|py\|pe\|ph\|pn\|pl\|pt\|pr\|qa\|re\|ro\|ru\|rw\|sh\|kn\|lc\|pm\|vc\|ws\|sm\|st\|sa\|sn\|cs\|sc\|sl\|sg\|sk\|si\|sb\|so\|za\|gs\|es\|lk\|sd\|sr\|sj\|sz\|se\|ch\|sy\|tw\|tj\|tz\|th\|tl\|tg\|tk\|to\|tt\|tn\|tr\|tm\|tc\|tv\|ug\|ua\|ae\|gb\|us\|um\|uy\|uz\|vu\|ve\|vn\|vg\|vi\|wf\|eh\|ye\|zm\|zw\|com\|edu\|gov\|int\|mil\|net\|org\|biz\|info\|name\|pro\|aero\|coop\|museum\|arpa))\|((((\[0-9\]){1,3}.){3}(\[0-9\]){1,3}))\|(\[(((\[0-9\]){1,3}.){3}(\[0-9\]){1,3})\])))\$” Work’s fine for me!

Bear • May

      3rd,
        
      2011 

Updated expression to take into account 5322/5321 and associated errata while adding in length checks (although I’ve omitted the IP-domain-literal forms for clarity, they remain unchanged from above) \[code\]<sup>(?=.{1,64}@\[</sup>@\]{4,}$`)(?=.{6,254}`$)(?:\[<sup>()\<\>@,;:".\[\]-07F-\]+(?:.\[</sup>()\<\>@,;:\\.\[\]-07F-\]+)*\|"(?:(?:(?:\[*)?\[+)?(?:\[-5B5D-7E\]\|\\-7E\]))*(?:(?:\[*)?\[+)?")@(?:[a-zA-Z](?:%5Ba-zA-Z\d-%5D%7B0,61%7D%5Ba-zA-Z\d%5D)?.)+\[a-zA-Z\]{2,}\$\[/code\]

Klaus Hott • May

      22nd,
        
      2011 

Have a look at the Zend_Validate_EmailAddress class it splits through the \[at\] sign first and handles the hostname and local parts separately. The localpart is first checked against the dot-atom format and if it fails against the double-quotes format. The hostname uses its own validator which checkes for TLD and IDN which have their rules according each TLD and also checkes for chinese and japanese characters. Maybe it can be quite stressfull to understand it fully, but the simple parts are quite easy and can help build a powerfull validator which not only checks if the email is valid or invalid acording a regex but actually help the user pinpoint where he misspelled something.

Phantom • June

      22nd,
        
      2011 

Hi Phil I used your regular expression and it worked like magic until our client decided to use IE6 and IE7 and it broke. The culprit is lookahead/lookbehind. Can you give me an equivalent regex without lookarounds ?? Thank you.

MagicMike • July

      25th,
      
      2011 

hehe… sooooo… how you guys feel about the new changes coming to domain naming conventions in 2013?…. :-p Sure to make regex of emails even THAT much more fun…

haacked • July

      27th,
      
      2011 

@MagicMike, what changes?

aar@q.com • August

      17th,
      
      2011 

er@q.com email address fails but its a valid email addres

Not Haacked • August

      19th,
      
      2011 

@haacked - Running a Google search turns up a recent article mentioning ICANN approving a process whereby they are opening up gTLDs for 500 applicants. Startup cost is something like \$200,000 (total) and requires a \$20,000 annual fee to keep it. On a side note, regular expressions are not the answer to e-mail address validation. I’ve found that regular expressions are good for filtering but they are not good for validation. The correct way to validate e-mail addresses is to use a state engine. A quick Google search turns up: barebonescms.com/…/ultimate_email_toolkit/ Which supposedly contains a state engine to validate e-mails. So at least one person out there knows what they are doing.

Raimundo • September

      2nd,
        
      2011 

function strIsEmail(email) { /\* De acuerdo con www.remote.org/… y http://wikipedia.com/E-mail_address la parte local de los los nombre de emails pueden contener letras, números, ., -, +, y \_ en cualquier combinación con las sgts. excepciones y sugerencias: No se permiten puntos (..) consecutivos ni punto (.) al inicio o al final de la parte local del nombre. No se recomienda usar el guión (-) como primer caracter en la dirección de correo porque podrí parecer una opción de una instrucción de línea de comando. Estos caracteres: & ’ \* / = ? ^ { } ~ ! \# \$ % \` \| podrín ser usados en la parte local del nombre, pero algunos serín contraproducentes para el programador o para algunos sistemas, mientras que otros pudieran ser confusos para los usuarios, por lo tanto no los tomaremos en cuenta en este script. Algunos servicios de hosting que he administrado no permiten utilizar el caracter + como primer caracter en la dirección de correo, asi que, también tomaremos esto en cuenta. Los dominios pueden contener letras, números, y guiones (-) en cualquier combinación exepto guiones (-) al comienzoo al final antes del punto (.). Después del (.) las extensiones de dominio pueden ser de dos a cuatro letras, seguidas, dependiendo el caso, de otro punto y la extensión de país (.com\|.net\|.info\|.com.do( co.do )\|.info.do\|.do). Según lo ante expuesto, estas serín direcciones de correo válidas: \_0.1.rc.-s0fT-+@01 -c0dig-0-pixel-0.com.do \_0.1.rc.-s0fT-+@01 -c0dig-0-pixel-0.co.do La expresión creada en este bloque acepta puntos consecutivos en la parte local del el nombre, por eso se usa la segunda expresión. Una forma de hacer esta validación serí buscar la primera aparición de la @, separar la parte local y el dominio y evaluarlos por separado. */ var regEx = /[^1]+(\[-\_+.\]+\[-\_+\]+\|\[-\_+\]*)@+(\[-\]++)\*.($`|\w{2,4}\.\w{2}`$)/i; var puntos = /../; return regEx.test(email) && !puntos.test(email); }

Wolf Loescher • November

      9th,
      
      2011 

Good post and follow up discussion. I created my own post (based on SeanG’s code sample) here: wloescher.blogspot.com/…

Phantom • December

      13th,
      
      2011 

your expression is not accepting me@u.com as valid email address. and if it is replaced with me@uu.com it is accepted. notice the extra ‘u’ Any info why this is happening ??Is there a mistake in expression or the email is invalid. Regards

sibudi • December

      20th,
      
      2011 

Thanks Phil, this post is very useful for me

geld anlegen • January

      30th,
      
      2012 

Abc@def”@example.com. customer/department=shipping@example.com $`A12345@example.com These are no valid e-mail adresses. I have not try all. My method (Javasricpt):var re_email = /^([_a-zA-Z0-9-]+)(\.[_a-zA-Z0-9-]+)*@([a-zA-Z0-9-]+\.)+([a-zA-Z]{2,3})`$/;

ashley • February

      17th,
      
      2012 

maybe it’s been mentioned, but the host part at a minimum matches “@aa.aa”, which excludes email to a TLD such as @ca, although “user@ca” is a valid email address (not that i’ve seen such an address). it will also match “@a…\_.-.a.a…a” which is horrible for several reasons: multiple dots in a row, a label beginning or ending with a minus sign, and an underscore being anywhere. i can’t begin to parse the local part at it seems quite different from anything one would find in perl or java.

extinct fish • March

      1st,
        
      2012 

When I got my first external email address I worked for digital equipment. The local part of that email address was firstname space lastname, enclosed in double quotes. I was sending emails, well, all over the world.

Scott • May

      10th,
      
      2012 

For email validation we have found Email Answers to do a great job for batch files and there cost is reasonable. There link for this service is www.emailanswers.com/services/email-list-cleaning/

William Humphreys • May

      11th,
      
      2012 

I always use this and its served me well http://isemail.info/about http://code.google.com/p/isemail/downloads/list

vitomd • July

      2nd,
        
      2012 

I think that the best solution , it’s the simplest solution. It will depends on your needs, but for me the email validation it’s only a small step to denied gibberish mail address. The you can add a confirmation email to be sure.

oliver khoury • July

      18th,
      
      2012 

You’ve tried to sign in too many times with an incorrect email address or password.

Dan M • August

      28th,
      
      2012 

Even the domain part can be difficult to validate. A TLD could have an e-mail address (e.g., support@com), and you can now get a vanity TLD if you have enough money (me@examplecom could be valid). Plus, you can specify an IP address (e.g., me@\[1.2.3.4\] or me@\[1::3F\]). Finally, a domain doesn’t NEED an MX record. If one doesn’t exist, the CNAME or A record will be used instead. So, it’s not easily possible to validate an address without just trying it, though you could try to weed out the most unlikely ones if you want to.

Lelala • September

      16th,
      
      2012 

I truly don’t see the point of extremely detailed email validation. It just won’t work, and you run the risk of refusing valid addresses. The only way to be really sure that the email belongs to the person filling in your web form, is by sending a conformation email. All you can do before that is just make sure there is an address in the first place, and it’s not complete garbage.

nrkn • November

      19th,
      
      2012 

If you’re in .NET and you’re using System.Net.Mail to send: ///
<summary>

/// Returns true if the string appears to be a valid email address ///
</summary>

public static Boolean IsValidEmail( this string input ) { try { new MailAddress( input ); } catch( Exception ) { return false; } return true; } I was originally using something based on reading this and several other articles, but after a couple of mishaps I realised it’s no use having a technically correct solution if the mailer still rejects it, and I’d be better off checking if the mailer is going to be happy with the address.

ROBERT GREEN • January

      10th,
      
      2013 

Thanks Nik!  Easy solution to implement!  Regards, RAG…

JoeyJoJo • January

      25th,
      
      2013 

I find it strange to see so many people coming up with solutions using a-z or a-zA-Z when domain names have allowed extended and double-byte characters for years now e.g. voilà.fr which might have an email address such as admin@voilà.fr.

Bob • January

      31st,
        
      2013 

“ask them to enter their address twice” Say hello to my friend copy&paste. Seriously, I never type my email twice.

Bob • January

      31st,
        
      2013 

“Most email providers have stricter rules than are required for email addresses.” Don’t expect this to help you: I have a domain and a catch-all, so I can enter those crazy addresses whenever I feel like and they all should arrive! (BTW: this comment system does not allow my valid and working email address i just tested)

Gene • February

      19th,
      
      2013 

Except for those clever sites that don’t let you copy and paste into certain fields.  Obviously these sites were created by cyborgs who hate humanity.

Emailtor • February

      25th,
      
      2013 

Hi Phil, super post on email validation. Article is 5 years old and still relevant!

plus-user • March

      11th,
      
      2013 

I agree 1000% with the question “why validate?” It’s a waste of time. If it bounces, it wasn’t valid. Validation does not prevent the problem of someone’s email going to someone else because that wrong address will ALSO pass validation tests.

You will also find that most of the sites that validate incorrectly send a validation link to that email address. So, not only do they incorrectly validate email addresses by a regex, they do the right thing in the end by sending an email to see if it gets through. Why validate by regex when you do it the right way in the end anyway?

plus-user • March

      11th,
      
      2013 

There is no requirement for a domain to have an MX record. That’s why you can’t use looking up an MX record as a test of validity. By testing using MX, you’re creating a dodgy interpretation of a reasonable standard.

Guest • March

      18th,
      
      2013 

I found this library for verifying email addresses in .net:

http://www.kellermansoftwar…

Craig Pickering • March

      24th,
      
      2013 

And for the love of \$DEITY, NEVER reject an email address because you can’t find an ‘A’ record. I use a whole bunch of perfectly valid email addresses on perfectly valid email-only domains which have only ‘MX’ records and no ‘A’ records. The number of times my email addresses are rejected by broken “validators” is .. annoying, to say the least.

Craig Pickering • March

      24th,
      
      2013 

…but you’re WRONG. That’s kind of the point of the article. The fact that ^ this response was two years ago (2011) is no excuse either – the “.museum” TLD was introduced TEN YEARS earlier in 2001.

If you want to know if the domain component of an email address is valid, there’s only one way to do it and it’s painfully obvious – do a DNS lookup. But don’t reject it if you find no ‘A’ record, that’s a broken approach too. Search first for an MX record, failing that for an A record.

Or better still, trust the user to know their own damn email address better than you do. If they don’t get your emails, worse for them. If they don’t respond to a validation request, delete them.

Asava Samuel • March

      26th,
      
      2013 

This is an excellent library for verifying email addresses:

http://www.kellermansoftwar…

ɐɯɹɐʞ ɐɯɹɐʞ • April

      17th,
      
      2013 

Best method is to send a confirmation email.

lawrencehutson • May

      1st,
        
      2013 

the absolute sure way to validate the email address is just talk to the smtp server - and ask it if the email exist with whatever the user inputs.

coche • June

      27th,
      
      2013 

Never trust the internet. This reg-expression considers this address as valid:

papapa@papapa.commmm

So forget it, and try another one. Damn, everyone I find has the same problem!!

1)  No, I don’t want to write a regex myself, it hurts too much

2)  Programmers can’t test their own code. The first test I made failed miserably. Oh dear…

3)  I know this is old. I don’t care. DNS should be validated always.

4)  ..

5)  profit!!

Thanks anyway for wasting your time and wasting mine. Tests things next time BEFORE they’re indexed by google.

Anon • July

      5th,
      
      2013 

It will not validate a single letter domain correctly.

Joel • August

      1st,
        
      2013 

You mean this one? http://www.ex-parrot.com/~p…

Joel • August

      1st,
        
      2013 

… except the small problem that papapa@papapa.commmm is actually a valid email address. Sure, no one owns the .commmm TLD, but that doesn’t mean someone could own it in the future…

dfsf • August

      11th,
      
      2013 

Well, before html5, i never used regular expression to validate email address…. Just, set theory….

tuexss • October

      14th,
      
      2013 

I haven’t seen any email-provider that allows all addresses that are possible within this RFC.

phani • February

      20th,
      
      2014 

what is the result of validating this scenario “xyz@gmail.com.com.com.com.com.com.com.com.in.com.in.com

robsoles • March

      23rd,
        
      2014 

I hate the back teeth out of stupid forms making anybody repeating anything that is not a password (ie., only ever displayed as asterisks).

I have written ‘spamyourselves@yourstupiddomain.tld’ twice into plenty of forms being hosted by websites that would not have come to my attention without spamming me or someone I know - not even signing up, just leaving a message telling them exactly how clever I thought their marketing departments were.

Let us enter our email address once and do nothing more (with us) until we have confirmed our ability to access emails sent to that address - prompt us perhaps, onsubmit, to review our email address (in a huge font, make it blink if you think that is clever) and confirm that we are happy with what we entered with yet another click but even expecting me to copy and paste my first response into the second box is asking too much at times - I have foregone posting/joining on plenty of occasions where the importance of passing on my opinion was outweighed by my hatred and sheer loathing of the idea of entering something that isn’t a password (being set or reset, no less) twice.

So far the box below is offering me to post as a guest and only asking me to type my email address once, I hope it isn’t just setting me up…

Note for admin: If you read the email address I am using and wonder if it is valid and reachable I urge you to send me a confirmation email :)

BillStewart2012 • April

      19th,
      
      2014 

Back when the TLD for Anguilla was run out of a friend’s bedroom in Berkeley, California, USA, there were a number of email addresses of the form name@ai, including n@ai (which belonged to Ian), and \$@ai . Since there are only about 10,000 people on the island, they could just about do name@ai for everybody there, except there are probably a few duplicate names.

BillStewart2012 • April

      19th,
      
      2014 

Yes! There are a number of systems that use user+tag@domain.tld or user-tag@domain.tld . In both cases, “user” identifies the recipient, and “tag” can be arbitrary alphanumerics, typically used for sorting mail into mailboxes, or for providing different tagged addresses to each person who might send you mail, so that you can easily identify mail from useful senders or probable spammers.

ShadowPhantom • June

      16th,
      
      2014 

I think this method should be according to your context :

http://msdn.microsoft.com/e…

Vicky • July

      15th,
      
      2014 

Hello , I like the way you validate the email from but if i want to validate my email by valid domain name like .com or .net . so can anyone have idea how could i implement this using lua or java programming language. Thank you

Taylor • October

      13th,
      
      2014 

7 years later and this is still an issue that most people don’t want to touch. With e-mail providers supporting characters like ‘+’ in e-mail addresses, you’d think people would step up their validation.. But nope. The number of sites I can’t use e-mail addresses containing plus signs on is pretty large, and consequently pretty annoying.

mutanic • November

      9th,
      
      2014 

That’s one freaking long regex I ever saw…

Mohammad • January

      5th,
      
      2015 

God damn you, you seriously very funny. I hope I see you in person one day. Thanks ;-)

mARK • January

      27th,
      
      2015 

a single @ will pass that test. liberal indeed.

Faisal • February

      10th,
      
      2015 

///

<summary>

/// Validates the email if it follows the valid email format

///
</summary>

/// <param name="emailAddress"></param>

/// <returns></returns>

public static bool EmailIsValid(string emailAddress)

{

{

//if string is not null and empty then check for email follow the format

return string.IsNullOrEmpty(emailAddress)?false : new Regex(@“<sup>(?!.)(””(\[</sup>”“\]\|\\““\])\*““\|(\[-a-z0-9!#\$%&’\*+/=?^\_\`{\|}~\]\|(?

darren • March

      8th,
      
      2015 

Excellent article, I’ve been using javascript and PHP Sessions to prevent form spamming for a while now, but hadn’t considered this angle. Great information, and I’ll be putting it to use immediately as one more item my arsenal in the on-going war against spam.

kuldip • March

      27th,
      
      2015 

What is the used of ” ? ” in email format

Régis • April

      30th,
      
      2015 

Yes, many implementations would break with these unusual email addresses. Do you know an email provider that support these extended ranges? I’d like a “foo@bar”@example.com address :-)

Roger Willcocks • May

      5th,
      
      2015 

Heh, the ones that P!SS me off are 1. Not accepting capital letters in the ‘user name’ portion of the email RogerW != rogerw 2. Not accepting ‘-’ in the domain name (because my domain has them)

claudecundiff • June

      22nd,
        
      2015 

This is important stuff that should not be taken lightly. For those who do, hackers thank you.

Philip Whitehouse • September

      14th,
      
      2015 

You should test for:

a@b

which should be valid - you can have an email account with a TLD (the common usage is localhost but webmaster@myFancyTLD would be valid

Paul M Edwards • October

      28th,
      
      2015 

This is a great article; thank you. However, the article should be updated to point to RFC 5322 which has obsoleted RFC 2822. https://tools.ietf.org/html…

Sean Ryan • December

      31st,
        
      2015 

Hi guys, I hope I am not missing something, but the bottom of pg 6 and top of pg. 7 of RFC 822 demonstrates an example address where sections of an email address contained in parenthesis are treated as “comments.”

The example is:

Muhammed.(I am the greatest) Ali @(the)Vegas.WBA

And it resolves to:

Muhammed.Ali@Vegas.WBA

So, presumably the text within and the parenthesis themselves are valid but otherwise ignored, does that sound correct?

Andy Edwards • January

      5th,
      
      2016 

Is it just me or does it seem like a lot of ancient internet standards are way overcomplicated? This reminds me of the complexity of SGML and XML. It seems like there was a culture back then of thinking waaaaaay too hard about how to handle all possible use cases.

troubledemailer • April

      25th,
      
      2016 

Interested to know the rules about the domain part. Is example@example.com.au a valid email address? Can we have double .com?

Babak • May

      1st,
        
      2016 

Is this a valid email `----@yahoo.com`?

BJ • July

      25th,
      
      2016 

Found a small bug. The email address a@b.com does not match. The error is in the domain name:

@\[a-z0-9\]\[.-\]\*\[a-z0-9\].

requires a least 2 letters or digits. It should be

@(\[a-z0-9\]\|\[a-z0-9\]\[.-\]\*\[a-z0-9\]).

allowing a 1 letter/digit domain name.

haacked • July

      25th,
      
      2016 

See, I still don’t know how to validate an email address. :P This is why I pretty much don’t do it.

haacked • July

      25th,
      
      2016 

Nice catch! I thought single letter domains weren’t allowed, but apparently a few have been grandfathered in. If we wanted to be really accurate, we’d need to special case all of them.

https://en.wikipedia.org/wi…

Richard Gadsden • October

      18th,
      
      2016 

Lots of new domains don’t validate properly in the domain-part.

.online causes enough places to refuse to validate that I have a gmail address that forwards just to get past stupid validators.

If you’re feeling smug, then can you validate a .рф address? What about .中国 and .中國 ?

Роман Оныщук • February

      10th,
      
      2017 

You can probably cut heaps out of your list with a simple PHP script that queries the mail server and checks if the address is deliverable. Some mail servers won’t respond properly to this but enough will to give you a better bounce rate.

You could also do some more things like checking if the domain is registered and if it has MX records.

If you want I can do this for you and customize a script that will work with other providers that do not respond correctly to the above. Please send me a PM if you would like to discuss it. good solution ( https://proofy.io/)

Роман Оныщук • March

      13th,
      
      2017 

by the way I hered about this service https://goo.gl/eXS2pn – it’s good for sturtups

James Kennard • May

      22nd,
        
      2017 

I literally HATE the individual that wrote this… All that work for a spec that people just made up in their heads!

I bet the insurance site I just tried to sign up with uses that, as it ditched my ENTIRE order because I used a .uk (not .co.uk) address, and worse is that it didn’t even barf until I’d filled in EVERYTHING!

Lewis Cowles • June

      4th,
      
      2017 

What I’m slightly taken back by is the RFC specs don’t seem to provide any unit tests (that I’ve found so far). It’s probably why none of them are implemented as intended even in 2017.

mgd020 • June

      9th,
      
      2017 

You’re probably safe with a simple regex as most email providers don’t support such interesting local names. This is what I came up with: https://gist.github.com/mgd…

1999.11.22 • July

      3rd,
        
      2017 

1999.11.22 2

1999.11.22 • July

      3rd,
        
      2017 

Siyans315@gni.lcom

fnu neena • September

      22nd,
        
      2017 

abd@8787.97778678 is it valid?

Rachael Rosander • November

      15th,
      
      2017 

How do i know email address is verify or can be deliver to sender

Alexander Christiaan Jacob • January

      8th,
      
      2018 

The beauty of it is that not even that is bullet proof. (As far as I know, no RFC perfect regex exists.)

Todd O’Bryan • January

      18th,
      
      2018 

Note that RFC5322 obsoleted RFC2822 and makes this a little less problematic. In particular, backslashes aren’t allowed in the local part anymore. There’s a nice list of valid and invalid addresses in the Wikipedia article on Email Address.

Fred Fnord • July

      12th,
      
      2018 

For information’s sake: ! in an email address is a relic from email in the pre-internet era (before, or by places that were not connected to, ARPANET or BITNET, typically). At that point, uucp was used to copy data in batches from one machine to another, by modem. If your machine didn’t connect directly to another machine, and didn’t know a valid route to it, you would have to give it the route: machine1!machine2!machine3. Another such mechanism was the percent sign. If you knew the way to a machine that knew the way to where you wanted to send your email, you could just say  someone%destination@somewhere-else. Your server would send the message to somewhere-else, which would strip off ‘@somewhere-else’ and replace ‘%’ with ‘@’ and see ‘someone@destination’ and happily send it off where it should go, assuming it knew. The thing about these mechanisms was that they would just work, and nobody was policing anyone’s use of them: you could use anyone’s machine to bounce your email to anybody else.

And then there was BITNET. I vaguely recall that it had a very similar email address scheme to regular @ addressing, without TLDs. Maybe?

Babak • August

      26th,
      
      2018 

The validation fails on \`a.example@gmx.ch’ which it’s a correct email address. Any idea?

talha2k • December

      4th,
      
      2018 

Guess I am joining the bandwagon quite late but my regex passed all except 4th and 5th. :D

Gene Hightower • December

      30th,
      
      2018 

https://tools.ietf.org/html/draft-seantek-mail-regexen-03

Comet • August

      16th,
      
      2019 

https://en.m.wikipedia.org/wiki/International_email The following are all valid international email addresses:

用户@例子.广告 (Chinese, Unicode) अजय@डाटा.भारत (Hindi, Unicode) квіточка@пошта.укр (Ukrainian, Unicode) θσερ@εχαμπλε.ψομ (Greek, Unicode) Dörte@Sörensen.example.com (German, Unicode) коля@пример.рф (Russian, Unicode)

The set of Internet RFC documents RFC 6530, RFC 6531, RFC 6532, and RFC 6533, all of them published in February 2012, define mechanisms and protocol extensions needed to fully support internationalized email addresses.

TheArcticGiant • May

      18th,
      
      2020 

The best way to validate email addresses (in my experience), is when a person signs up, sent them a verification email; If they are able to receive and respond, the email is clearly valid. Any “verification” on your part just introduces the possibility of excluding a valid address. There are exceptions, of course.

Ray Wright • June

      17th,
      
      2021 

There was a CPAN Perl Regex years ago that was 3 pages long and only covered RFC822. Today, any regex shorter than 10 pages long is going to be incorrect. Hmm…maybe you’re doing it wrong if you use a regex!

Validating an email address against the IETF standard REQUIRES using a state engine tokenizing parser.  If you are using a regular expression, you are actually unable to follow the EBNF notation that the IETF put together and are 100% guaranteed to get it wrong.

Here’s a library that does it right and even handles edge-cases like comments (yup, email addresses can have comments in them…why?  I have no idea):

https://github.com/cubiclesoft/ultimate-email

SMTP::MakeValidEmailAddress() not only implements a state engine parser, it is also able to autocorrect common typing mistakes (e.g. gmail,com instead of gmail.com) as it parses the email address.  Can a regex do that?  No.  A state engine, however, can.  It is also far more readable/comprehensible than a 3+ page regex.

One interesting aspect of that library is that it parses email address strings in reverse!  The most likely reason is that finding an ‘@’ by starting from the left doesn’t mean you’ve found the domain portion of the address but if you start from the right, it’s a lot easier to separate the local vs. domain portions and parse them accordingly.  Now that’s what I call actual intelligence!  A software developer using their brain and thinking about the easiest way to parse a complex string.

While state engines aren’t pretty, they are both the only correct method of implementing any IETF standard AND the most correct way to write software in general.

Gilbert • December

      8th,
      
      2021 

When I copy your regexp and paste it at https://regex101.com/ Every single option on the left produces an error : PCRE, ECMAScript, etc. What is the notation you have used there ?

Haacked • December

      9th,
      
      2021 

You can test the regex in http://regexstorm.net/tester

Allen in Iowa • August

      8th,
      
      2022 

I’m so glad I ended up reading this. I had no idea until I heard a podcast reference an RFC about e-mail. Nice.

[^1]: \_
