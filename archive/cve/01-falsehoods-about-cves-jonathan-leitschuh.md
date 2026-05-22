# Falsehoods about CVEs (Jonathan Leitschuh)

> **Original:** <https://medium.com/@jonathan.leitschuh/falsehoods-people-believe-about-cves-85c1d063ffda>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods People Believe about CVE’s \| by Jonathan Leitschuh \| Apr, 2025 \| Medium

Open in app

Sign in

Write

Sign in

Falsehoods People Believe about CVE’s

CVE ≠ Vulnerability (And 36 Other Confusions Regarding CVE)

Jonathan Leitschuh

· Follow

3 min read · Just now

–

Billions of dollars are spent on security tooling, vulnerability scanners light up dashboards in every SOC, and somewhere in the middle of it all is a humble acronym: CVE™. It shows up in reports, tickets, release notes, investor decks, press releases, and breach reports. It is often used interchangeably, often incorrectly, with “vulnerability,” “exploit,” and “security flaw.”

Despite its ubiquity, there is widespread confusion about what a CVE actually is. Many people — some of them in charge of large enterprises— believe a CVE is the same thing as a software vulnerability. Or that every software vulnerability has a CVE. Or that a CVE always includes technical details, a fix, a CVSS score, and a confession from the developer who introduced the bug.

Inspired by Falsehoods Programmers Believe About Names , this is a list of things people (wrongly) believe about CVEs. Some are naive. Some are overly optimistic. A few are just wishful thinking.

All of them are false.

A CVE and a vulnerability are the same thing

A CVE exists for all publicly disclosed vulnerabilities

A CVE existing means the vulnerability was disclosed

A CVE exists

A CVE being assigned means that a vulnerability must exist

A CVE is only for big, dramatic bugs — nobody bothers with a CVE for trivial issues

A CVE has never been assigned for a hardware vulnerability

A CVE is always assigned to a single vulnerability

A CVE is always assigned to a single product

A CVE is always fixed in a single version of the software

A CVE’s year (CVE-\[YEAR\]) the is the year the CVE was published

A CVE will always be assigned and published on the same day the vulnerability is disclosed

A CVE will always be assigned and published within the same year that the vulnerability is disclosed

A vulnerability that has been discussed at a security conference will, of course, have a CVE assigned to it

Surely someone will have followed up after the conference, right?

Within a year?

A CVE has a fix

A CVE is never a duplicate of another CVE

A CVE is guaranteed to be exploitable

The rules governing assigning a CVE in end of life (EOL) software is exactly the same as maintained software

A CVE contains sufficient information to compute it’s CVSS score

A CVE contains sufficient information to determine the severity of the vulnerability

A CVE contains sufficient information to determine what product is affected

A CVE contains sufficient informa… 🙄

A CNA would never write a CVE description carefully and specifically to influence NIST to assign a specific CVSS score

Both the software vendor and the security researcher must agree a vulnerability exists for a CVE to be assigned

A CVE is never withdrawn or disputed

A software product that has lots of CVEs must be less secure

A software product with no CVEs must be more secure

A CVE is hard to get assigned for a vulnerability

A CVE is easy to get assigned for a vulnerability

CVE is a government program

CVE is run by the National Vulnerability Database (NVD)

CVE is run by MITRE

CVE is exclusive to the USA

The CVE system is free from politics

CVEs are assigned by an all-knowing, infallible committee that never makes mistakes

This list is by no means exhaustive. If you’re skeptical that these misconceptions exist, I invite you to attend one vulnerability disclosure panel, or read through a few dozen CVE entries. Or better yet, try requesting one yourself.

Feel free to suggest more falsehoods in the comments, and share this post the next time someone insists that every CVE has a fix, a proof-of-concept exploit, a CVSS score, and universal agreement on whether it’s even real.

Thanks: Special thanks to everyone at Vuln Con 2025 who offered their own falsehoods and helped proofread this blog post.

Cybersecurity

Security

Cve

Software Security

Some rights reserved

Written by Jonathan Leitschuh

1K Followers

· 15 Following

Software Engineer, Security Researcher, Public Speaker, Open Source Contributor

No responses yet

Help

Status

About

Careers

Press

Blog

Privacy

Rules

Terms

Text to speech
