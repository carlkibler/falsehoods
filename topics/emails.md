# Falsehoods About Emails

> Your email-validation regex is wrong, and the RFC is far weirder than you think.

## The Big Surprises

- **A valid email address can contain multiple `@` signs.** RFC5321 permits source routing syntax like `@1st.relay,@2nd.relay:user@final.domain`, and common public mail services accept and deliver it just fine.

- **`'\*+-/=?^_\`{\|}~#$@netmeister.org` is a real, working email address.** All those characters are explicitly allowed in the local part by RFC5321/5322. You can actually email the author of that RFC explainer at that address — if your mail client will let you.

- **Email addresses are case-sensitive — on the left side.** The RFC *mandates* that the local part MUST be treated as case-sensitive. `Jschauma@netmeister.org` and `jschauma@netmeister.org` do not have to go to the same mailbox. (The domain part follows DNS rules and is case-insensitive, so only the right half is safe to lowercase.)

- **Stripping `+` suffixes from addresses is wrong and will break real users.** `john+doe@example.com → john@example.com` is a common "normalization" that destroys a deliberately chosen address. Gmail, Outlook, and most MTAs support plus-addressing as a first-class feature; users rely on it to track who sells their data.

- **A bounce doesn't mean the address is invalid, and no bounce doesn't mean it's valid.** Addresses change without notice, valid addresses can temporarily reject mail, and spam filters silently swallow messages all the time. The only real validation is successful delivery.

- **You can put emoji in the local part.** RFC6531 permits UTF-8 if the server supports the `SMTPUTF8` extension, making `"💩"@domain` and `"🍺🕺🎉"@domain` syntactically valid. Gmail announced initial support for non-Latin addresses back in 2014.

- **The domain part doesn't need to contain a dot — or even resolve.** ICANN prohibits "dotless domains," but as of 2021 the root zone contained 25 TLDs with MX records, meaning `santa.cl@ws`, `m@tt`, and `ai@ai` are all technically valid email addresses. Any domain-shaped string is fair game even if it doesn't currently resolve.

- **If you send a URL in an email, the user will probably not be the first to click it.** Security scanners, link-preview services, and anti-spam systems routinely fetch URLs in emails before the recipient ever opens the message. Building any "magic link" flow that breaks on a second click will fail in the wild.

- **Nearly every email-validation regex on the internet is too strict, not too permissive.** The author of the Haacked post tested his assumptions against RFC 2821 and RFC 2822 and found that addresses like `customer/department=shipping@example.com`, `!def!xyz%abc@example.com`, and `_somename@example.com` are all valid — and most regexes reject them.

---

## Where It Gets Complicated

### The Local Part Is a Wild West

The portion before the `@` is defined as either a *dot-atom* or a *quoted string*, and both allow far more than `[a-zA-Z0-9._-]`.

**Allowed unquoted characters** include the full comic-strip swear-word set: `! $ & * - = ^ \` | ~ # % ' + / ? _ { }`. So `$A12345@example.com` and `!def!xyz%abc@example.com` are perfectly valid unquoted addresses.

**Dot rules are strict but subtle.** You cannot start or end the local part with a `.`, and you cannot have two consecutive dots. `.jdoe@domain`, `jdoe.@domain`, and `jd..oe@domain` are all invalid — but only in the *unquoted* form.

**Quoted strings break all those rules.** Wrapping the local part in double quotes allows leading/trailing dots, consecutive dots, spaces, horizontal tabs, and most other visible ASCII characters (with `\` and `"` escaped). These are all valid:

- `".jdoe"@domain`
- `"jd..oe"@domain`
- `" "@netmeister.org` (yes, a single space)
- `"Austin@Powers"@example.com`
- `"Abc@def"@example.com` (the `@` inside quotes is fine)

RFC 821 from 1982 allowed any of the 128 ASCII characters in this position, including newline and NUL. Good times.

**Length limits exist and are routinely violated.** The local part is capped at 64 octets by the RFC. The full forward path can be up to 256 octets. In practice, at least one mail server (netmeister.org, in testing) accepted a local part of 526 characters with no complaint.

### The `@` Sign Is Not a Reliable Delimiter

**Source routing puts multiple `@` signs in a valid address.** RFC5321 Section 4.1.2 allows forward path syntax: `@1st.relay,@2nd.relay:user@final.domain`. Most servers ignore the routing hints and deliver to `user@final.domain`, but they accept the address.

**Bang paths (`!`) and the percent hack (`%`) are also valid — and dangerous.** `relay.domain!user@domain` and `user%final.domain@1st.relay` are syntactically valid per RFC5321. Some servers (including Postfix) interpret these as relay attempts and reject them with `554 5.7.1 Relay access denied` or `501 5.1.3 Bad recipient address`. The character is allowed; what the server *does* with it is implementation-defined.

### The `+` Sign: Special Everywhere, Special Nowhere

The `+` is just another ordinary character per RFC5321 — no different from `!` or `%`. But Gmail, Outlook, and most modern MTAs have independently decided it means "subaddress": `jdoe+whatever@domain` and `jdoe+somethingelse@domain` both deliver to `jdoe@domain`. RFC5233 ("Sieve Email Filtering: Subaddress Extension") formalizes this behavior.

The practical consequence: sites that reject `+` in email fields are breaking a widely-used, RFC-documented feature. One commenter reported filing hundreds of complaints over years of using plus-addressed emails and receiving exactly a single-digit number of fixes.

### Dots on the Domain Side

Gmail treats dots in the local part as completely insignificant: `jdoe@gmail.com` and `j.d.o.e@gmail.com` land in the same inbox. This is Gmail's own policy, not an RFC requirement, and it creates normalization headaches — you cannot deduplicate Gmail addresses by string comparison.

The domain part follows standard DNS rules and is legitimately case-insensitive, unlike the local part.

### The Domain Is Not What You Think

**No dot required.** If a TLD has an MX record, mail to `user@tld` is valid. As of April 2021, the root zone contained 25 TLDs with MX records, including `ai.`, `ws.`, `tt.`, `ua.`, and others. ICANN discourages this; it happens anyway.

**No resolution required.** A syntactically valid domain that doesn't currently resolve is still a syntactically valid domain. Someone could register it tomorrow.

**IP address literals are valid domains.** RFC5321 allows "address literals" in brackets:
- `jschauma@[166.84.7.99]`
- `jschauma@[IPv6:2602:f977:800:0:e276:63ff:fe72:3900]`
- `jschauma@[IPv6:::1]`

**Internationalized domain names are valid.** Punycode encoding allows non-ASCII TLDs: `香港`, `сайт`, `مصر.` (right-to-left). Combining these with emoji local parts gives you `"🌮"@i❤️tacos.ws` — a valid address.

**`.onion` is fair game.** `local@gtfcy37qyzor7kb6blz2buwuu5u7qjkycasjdf3yaslibkbyhsxub4yd.onion` is a valid email address if you configure your MTA to route through Tor.

**TLDs don't imply language or geography.** A `.fr` domain does not mean the user reads French. A `.edu` address does not mean the holder is a student, or even faculty — and not all universities issue `.edu` addresses. Users frequently don't use their institutional address for anything outside the institution.

### Headers Lie, and Delivery Is Not Instantaneous

**The `Date:` header is not trustworthy.** It's set by the sender; nothing enforces accuracy. `Received:` headers can appear with timestamps *earlier* than `Date:`, which is technically impossible but observed in the wild.

**Email is not a reliable or instantaneous transport.** The RFC allows retries for days. An email might be queued for hours or days before delivery, or silently dropped. A non-bounce does not confirm delivery; a bounce does not confirm the address is permanently dead.

**Only the owner of an address can send from it** — false. SMTP has no built-in authentication of the `From:` header. Anyone can forge it. This is why SPF, DKIM, and DMARC exist, and why "Reply with REMOVE to unsubscribe" schemes are broken by design: a reply to address X will come from wherever the user's reply-to is configured, which may have nothing to do with X.

**Attachment size and filenames are not trustworthy.** Email encoding (typically Base64) inflates binary attachments by roughly 33%. The filename in a MIME attachment header is attacker-controlled and should never be used as-is when writing to disk.

### Assumptions About Users and Addresses

- Not everyone has an email address. Not everyone has exactly one. Addresses change, sometimes without the user's knowledge or consent (employer changes providers; university deactivates alumni accounts).
- An address that is valid today may be invalid tomorrow, and vice versa — a previously invalid address might become valid if someone registers the domain.
- Users often don't know their own email address precisely — they mistype it, forget capitalization conventions, or confuse `+` subaddresses.
- Unique character strings do not necessarily map to unique mailboxes. Gmail's dot-ignoring policy means `jdoe@gmail.com` and `j.doe@gmail.com` are the same inbox. Plus-addresses multiply this further.

---

## If You Build This

1. **Use the loosest validation that catches obvious typos, not the strictest that matches the RFC.** A regex like `.+@[^@]+\.[^@]+` catches "no @ sign" and "no dot in domain" without rejecting legitimate addresses. Anything stricter will eventually block a real user. The only characters you can safely reject outright are whitespace and control characters in an unquoted context.

2. **Never reject an address solely because it contains `+`, `/`, `!`, `%`, `=`, `~`, `'`, `{`, `}`, `|`, `^`, or backtick.** All of these are explicitly allowed in the local part. If your validation form rejected the commenter at haacked.com because of a `+` sign, you're the bug.

3. **The only real validation is sending a message and requiring the user to act on it.** Regex validation catches format errors; it cannot tell you whether the address exists, whether it belongs to the user, or whether mail will actually be delivered. Send a confirmation link with a short-lived token and require a click. Do this every time you collect a new address.

4. **Do not normalize or transform addresses without explicit user consent.** Don't lowercase the local part (it's case-sensitive by spec). Don't strip `+` suffixes. Don't remove dots. Don't assume `j.doe@gmail.com` and `jdoe@gmail.com` are the same person — even if Gmail treats them identically, you don't know the user's intent.

5. **Treat bounces as signals, not verdicts.** A bounce warrants a retry and eventually a soft-disable, not an immediate hard delete of the address. Transient failures, spam filters, and full mailboxes all produce bounce-like signals from addresses that are perfectly valid.

6. **Reach for a real parser, not a regex, if you need RFC compliance.** The Perl module `Mail::RFC822::Address` contains a regex that runs to roughly three pages and still has edge cases. For production use, prefer a well-maintained library in your language (e.g., Python's `email.headerregistry`, or a dedicated validation package) over a hand-rolled pattern. If you're parsing address headers — not just validating user input — regex is categorically the wrong tool: RFC2822 Section A.5 allows arbitrarily nested comments, which are not a regular language.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Email (beesbuzz)](https://beesbuzz.biz/code/439-Falsehoods-programmers-believe-about-email) · [archived copy](../archive/emails/01-falsehoods-about-email-beesbuzz.md)
- [I Knew How to Validate an Email Until I Read the RFC (Haacked)](https://haacked.com/archive/2007/08/21/i-knew-how-to-validate-an-email-address-until-i.aspx/) · [archived copy](../archive/emails/02-i-knew-how-to-validate-an-email-until-i-read-the-r.md)
- [Your E-Mail Validation Logic is Wrong (netmeister)](https://www.netmeister.org/blog/email.html) · [archived copy](../archive/emails/03-your-e-mail-validation-logic-is-wrong-netmeister.md)
