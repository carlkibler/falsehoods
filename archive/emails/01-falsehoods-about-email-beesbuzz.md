# Falsehoods about Email (beesbuzz)

> **Original:** <https://beesbuzz.biz/code/439-Falsehoods-programmers-believe-about-email>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Code: Falsehoods programmers believe about email

In the spirit of falsehoods programmers believe about names and time , here’s some falsehoods about email which are all too common.

Everyone has an email address

Everyone has exactly one email address

An email address never changes

Whenever an address does change, it’s under that user’s control

Whenever an address does change, it’s because the user specifically requested it to happen

Whenever an address does change, the old address will continue to work/exist

Any one email address refers to only one single person

Unique strings of characters all map to different addresses

All email is hosted by a centralized system

When email is sent to a user at a domain, it is delivered to a server whose address matches that domain

When email is sent by a user at a domain, it is sent by a server whose address matches that domain

All email comes from a .com , .net , .edu , or .org address

You can filter out email based on the TLD or ccTLD from which it originates

Having a particular ccTLD means that you prefer to receive communications in that country’s native language (for example, .fr → French)

Email addresses only contain letters

Email addresses only contain letters and numbers

Email addresses only contain letters, numbers, and a handful of common punctuation marks (e.g. . , \_ , and - )

Email addresses will have at least one letter in them

An email address like <sup>\_</sup>@example.com or +&#@example.com is invalid

Email is a reliable transport

Email is an instantaneous transport

Emails will be sent within a few minutes of their scheduling

Emails will be sent within a few hours of their scheduling

Emails will be sent within a few days of their scheduling

Emails will be received soon after they’re sent

When an email is sent it immediately goes to its destination server

If an email bounces, the address is invalid

If an email doesn’t bounce, the address is valid

An address which is valid will always be valid, and an address which is invalid will always be invalid

All email is sent via SMTP over TCP/IP port 25

All email is sent via SMTP over TCP/IP

All email is sent via SMTP over IP

All email is sent via SMTP

All email servers support the various vendor extensions by the current “everyone uses this vendor” vendor (Microsoft, Google, etc.)

An email can only have one From: address

The Date: header on a message is legitimate

The Received: headers will always be no earlier than the Date: header

All email clients support HTML attachments

All email clients support HTML message bodies

All email clients support MIME encoding

Email is secure

Encrypted email is secure

All email is accessed via webmail

All email is accessed via webmail or IMAP

All email is accessed via webmail, IMAP, or POP3

Nobody uses email anymore

See also: email is bad

Update I’m getting some good additions from folks’ responses and I’ll be adding them as I see them.

From elainemorisi :

Anyone with a .edu address is a student

Anyone with a .edu address is a student or faculty

Students and faculty will use their .edu address to sign up for all of their Internet accounts

Additional suggestions from a reddit thread :

All universities provide an .edu address

Domains will be handled uniformly between email and HTTP

Only the owner of an address can send mail from that address

Email attachment size will be accurate to the storage size of the attachment ; relatedly, attachment filenames are the correct filenames for those file types, and that it’s safe to extract attachments to those filenames

It is valid to remove +suffixes from email addresses (e.g. john+doe@example.com → john@example.com )

Users actually know their own email address

From Jens Alfke :

Email addresses are case-sensitive / can be compared by == or strcmp

A reply to an email sent to address X will come from X (this is the mistake made by things that say “Reply with REMOVE to unsubscribe”)

If you receive email at address X, you are capable of sending email whose From header is X.

A good one that was posted by many folks when this post went viral but seems to first be by benoliver999 on lobste.rs :

If you send a url in an email, the user will be the first to click it

Update, 9/1/2022: Wow, I am getting overwhelmed with comments and suggestions. This really struck a nerve, huh!

I don’t think I’ll be adding any more things to this list. But here’s a few threads you can follow and post comments on:

r/programming thread

lobste.rs thread

Hacker News thread

plush.city thread

Also, I moderate every single comment that comes to this site, so please be patient if a comment you post doesn’t appear immediately.

Finally, see this followup .

To see the comments on this entry, please log in . Alternately, send me an email , or join me on Discord !
