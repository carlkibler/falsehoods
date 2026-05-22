# Falsehoods About Phone Numbers

> A phone number isn't a number, isn't unique, and won't hold still.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Kosovo has three country calling codes simultaneously.** Depending on when and where you got your number, a Kosovo phone may be reached via Serbia (+381), Slovenia (+386), or Monaco (+377). One territory, three codes, no clean answer.

- **Germany has legally assigned phone numbers longer than 15 digits** — violating the ITU-T E.164 specification that every standards-compliant system assumes as gospel. "Valid" and "spec-compliant" are not the same thing.

- **In Argentina, to dial a mobile number domestically, you don't just change the prefix — you surgically insert digits in the middle.** The "9" after country code +54 is removed, and "15" is inserted after the area code: `+54 9 2982 123456` becomes `02982 15 123456`. No purely prefix-based transformation handles this.

- **Dialing a longer string can connect you to a completely different endpoint than the shorter number.** In some countries, "12345678" and "123456" reach different people. A prefix of a valid number can itself be a valid, different number.

- **1-800-MICROSOFT is an invalid phone number that still calls Microsoft.** Extra digits beyond what's needed are silently discarded in some countries and on some networks. Conversely, "911 123" reaches emergency services in some places but not others.

- **Italy's leading zero is not decorative — it's load-bearing.** Since 1998, Italian numbers have the national prefix baked in, so `(01) 2345` became `012345` and must be dialed internationally as `+39 012345`, zero included. The common rule "drop the leading zero when dialing internationally" will silently misdial Italian numbers.

- **Phone numbers can contain `*` and letters.** Israel has advertising numbers starting with `*`; New Zealand uses `*555` for traffic incident reporting; the US has `1-800-Flowers`. Storing a phone number as an integer silently destroys all of this.

- **In Egypt, phone numbers are commonly written in native (Arabic-Indic) digits**, not ASCII. Your regex that matches `[0-9]+` will reject perfectly valid, correctly formatted numbers.

- **Old phone numbers are recycled.** The person who owned `+1 415 555 0100` last year is probably not the person who owns it today. Any property you cache against a number — including "this belongs to our user" — has an expiration date you can't know in advance.

## Where It Gets Complicated

### Identity and Ownership

**A phone number does not identify a person.** Households sharing a single fixed-line number remain common in parts of the world. Businesses routinely route dozens of calls through one number. A number identifies a *line*, not a human.

**One person can have many numbers**, and many people can share one. Neither direction of that mapping is 1:1.

**Phone numbers are reassigned.** Carriers recycle disconnected numbers. The number you verified a user with six months ago may now belong to a stranger. Do not treat a verified number as a permanent identity token.

**M2M SIM cards are not immune to voice calls.** Machine-to-machine SIMs — up to 15 characters long, normally used for data and SMS — can receive voice calls. Telecare and medical alarm systems, for instance, may receive automated voice messages or direct human calls via telephony APIs during an alarm event. "This is an M2M number, nobody will call it" is not a safe assumption.

### Geography and Country Codes

**One country calling code ≠ one country.** +1 covers the USA, Canada, and a raft of Caribbean islands. +7 covers Russia and Kazakhstan. The mapping is many-to-many in both directions.

**A phone number's area code says nothing reliable about where the user is, where they live, what time zone they're in, or what language they prefer.** Number portability lets people keep numbers when they move — sometimes even fixed-line numbers with area codes. People emigrate and keep their old SIM. VoIP lets anyone buy a number in any country. Geopolitical changes redraw borders around existing numbers. Blocking sign-ups based on country code is both unreliable and user-hostile.

**Not all country calling codes belong to countries.** Satellite services and Universal International Freephone Numbers (the +800 range) have their own codes. "Country calling code" is a misnomer.

### Dialability

**A number that works today may not work tomorrow — and may not even be free to call.** Numbers get disconnected. Number types (mobile vs. fixed-line) get reassigned. A range that's free to call today may become premium-rate. Never cache "this number is valid" or "this number is mobile."

**Dialability is not universal.** Some numbers only work within their country. +800 Universal International Freephone Numbers only work from participating countries. Some numbers are only dialable if you're a subscriber to a specific carrier.

**There are more than two dialing contexts (domestic and international).** In Brazil, calling across certain internal geographical boundaries requires explicitly dialing a carrier code. In Nepal, whether you omit the leading zero depends on whether your originating phone is mobile or fixed-line. In New Zealand, you dial the area code even within the same area — unless you're "close enough," defined by something approximating city boundaries.

**EFTPOS terminals, fax machines, and mobile data dongles may not accept inbound voice calls.** "I have a phone number for this device" does not mean "I can call this device."

### SMS and Text Messages

**Fixed-line phones generally can't receive SMS.** A lot of people still only have fixed-line numbers. If your product requires SMS verification, you are excluding them by design.

**But some fixed-line numbers *can* receive SMS.** Certain providers support text to fixed-line numbers. Skype and similar services blur the line further. "Only mobile phones can receive texts" is also false.

### Number Format and Structure

**Phone numbers are not numbers.** `007`, `07`, and `7` are the same integer but potentially three completely different phone numbers. Leading zeros are semantically significant in many countries. Never store a phone number as `INT`, `BIGINT`, or any numeric type.

**The plus sign in international format is not optional and `00` is not a universal substitute.** `+1 555 123 4567` is E.164. `1-555-123-4567` (common in North America) is technically wrong. The international dialing prefix varies by country: Japan uses `010`, so from Japan you'd dial `010 1 555 123 4567`. The `+` is the portable, unambiguous form.

**Numbers can have multiple valid prefixes simultaneously during transitions.** In Iceland in the mid-1990s, when the country migrated from 5–6 digit numbers to 7 digits, a Reykjavik number could be reached as `nnnnn` or `55nnnnn` locally, and `91-nnnnn` or `55nnnnn` from outside — four valid forms for one endpoint, simultaneously.

**A leading zero is not always droppable when dialing internationally.** Italy since 1998 bakes the national prefix into the number itself. `+39 012345` is correct; dropping the zero silently fails.

**Published numbering plans do not reflect reality.** ITU-administered national numbering plans represent government and carrier *intentions*. They may be published before, during, or after actual implementation. The date a number range goes live may not match the official announcement.

### What Users Actually Type

**Users will put non-phone-number data in phone number fields.** Birthdays, notes, and other personal data end up in contact list phone fields. Unless you've verified it, treat user input as an opaque string.

**Phone numbers are not always ASCII.** Egyptian users commonly write phone numbers in Arabic-Indic digits. A digit-matching pattern that only handles `0-9` will reject valid input.

**Alpha characters appear in real phone numbers.** `1-800-Flowers` is a real, dialable number. Your input validation needs to account for this, or at minimum not destroy the data.

## If You Build This

1. **Use [libphonenumber](https://github.com/google/libphonenumber) and trust it over your own regex.** It encodes thousands of country-specific rules — Argentina's mid-number insertion, Italy's leading zero, Nepal's mobile/fixed-line distinction — that no hand-rolled pattern will get right.

2. **Store phone numbers as strings, always.** Never use a numeric type. Leading zeros are meaningful. `*555` is a valid number. Extensions exist. Treat the field as opaque text until you need to parse it.

3. **Store in E.164 format (`+` followed by digits) for canonical storage.** Use `formatForMobileDialling` when you need what the user should actually dial from their device — those are two different things.

4. **Never cache number type or validity.** A number that is mobile today may be fixed-line tomorrow. A number that is valid and free today may be disconnected or premium-rate tomorrow. Call the library fresh when you need to know.

5. **Don't infer location, timezone, or language from a phone number's country code.** Number portability, emigration, VoIP, and geopolitical change all make this unreliable. Ask the user directly.

6. **Don't require a phone number unless you genuinely need one, and don't assume it's callable, textable, or unique to one person.** Build fallbacks for users who can't receive calls (hearing disabilities, EFTPOS terminals) and for those who can't receive SMS (fixed-line users). Verify capability at the time you need it, not at sign-up.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Phone Numbers (Google libphonenumber)](https://github.com/google/libphonenumber/blob/master/FALSEHOODS.md) · [archived copy](../archive/phone-numbers/01-falsehoods-about-phone-numbers-google-libphonenumb.md)
