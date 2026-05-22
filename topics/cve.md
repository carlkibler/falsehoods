# Falsehoods About CVEs

> A CVE is not a vulnerability, and 36 other confusions.

**[Sources & credits ↓](#sources)**

CVE™ is everywhere — in tickets, release notes, investor decks, breach reports — and almost everywhere it's misunderstood. People use it interchangeably with "vulnerability," "exploit," and "security flaw," and assume that every CVE comes with technical details, a fix, a CVSS score, and a confession from the developer who wrote the bug. None of that is reliably true. Inspired by *Falsehoods Programmers Believe About Names*, here's what people wrongly believe about CVEs.

## The Big Surprises

- **A CVE and a vulnerability are the same thing.** They're not. A CVE is an *identifier and catalog entry* for a publicly known issue — it's a label, not the flaw itself. The flaw can exist without a CVE, and (awkwardly) a CVE can exist without a real flaw behind it.
- **A CVE being assigned means a vulnerability must exist.** Assignment is a human process, and humans get it wrong. CVEs get reserved, mis-filed, and later disputed or rejected because the underlying "vulnerability" turned out not to be one.
- **Every publicly disclosed vulnerability has a CVE.** Plenty don't. A bug can be demoed on stage at a security conference, written up in a blog, and patched — and still never get a CVE assigned, that year or ever.
- **A CVE has a fix.** Nothing about a CVE guarantees a patch exists. Many describe vulnerabilities that are unpatched, won't-fix, or in end-of-life software nobody is maintaining.
- **A CVE is guaranteed to be exploitable.** A CVE can describe a theoretical weakness with no working exploit, or one that's only reachable under conditions that don't occur in practice.
- **A product with more CVEs is less secure (and one with zero is more secure).** Both backwards. Lots of CVEs often means lots of *eyes* — active researchers, a responsive vendor, a mature disclosure process. Zero CVEs frequently means nobody is looking, or nobody can get one assigned.
- **CVE is a US government program run by NIST/NVD.** It's run by MITRE, is internationally scoped, and is *separate* from the NVD. The NVD enriches CVE data; it doesn't own or run the CVE program.
- **The CVE system is free from politics and run by an infallible committee.** It is neither. CNAs, vendors, and researchers all have incentives, and descriptions get written to nudge scores. Mistakes are routine.

## Where It Gets Complicated

### What a CVE ID is (and isn't)

- A CVE is not a vulnerability. It's an identifier for a publicly known issue.
- A CVE existing does not mean the underlying issue was actually disclosed in any useful detail — or that it exists at all.
- A CVE being assigned does not mean a vulnerability must exist; assignments get disputed and rejected.
- A CVE is not reserved only for big, dramatic bugs. Trivial issues get CVEs too — assignment doesn't track severity.
- A CVE is not software-only. Hardware vulnerabilities (think Spectre/Meltdown-class CPU flaws) absolutely get CVEs.
- A CVE is not always one-to-one with a single vulnerability — one ID can cover multiple related flaws.
- A CVE is not always tied to a single product. One ID can span many affected products.
- A CVE is not always fixed in a single version. The fix may land across multiple releases, branches, or never.
- A CVE is not guaranteed to be unique. Duplicate CVEs for the same underlying issue happen.
- A CVE is not guaranteed to be exploitable.
- A CVE in end-of-life software does not follow the same assignment rules as maintained software — EOL changes how (and whether) issues get IDs and fixes.

### Timing and the year in the ID

- **The year in `CVE-[YEAR]-NNNN` is the year the CVE was *reserved*, not the year it was published.** A CVE-2023 ID can be published in 2025.
- A CVE is not assigned and published the same day a vulnerability is disclosed. There's often a gap — sometimes a long one.
- A CVE is not even guaranteed to be assigned and published within the same year disclosure happened.
- A vulnerability discussed at a security conference will not necessarily get a CVE — not after the talk, not within a year, sometimes not ever. "Surely someone followed up" is wishful thinking.

### CVSS scoring myths

- A CVE does not necessarily contain enough information to compute its CVSS score.
- It may not contain enough to determine the severity at all.
- It may not even contain enough to determine which product is affected. The recurring assumption that "a CVE contains sufficient information" is exactly that — an assumption. Often, it just doesn't.
- **A CNA absolutely *would* write a CVE description carefully to influence the score NIST assigns.** Descriptions are framed strategically, downplaying or emphasizing details to nudge the resulting CVSS. The data is not a neutral physical measurement.

### The assignment and CNA process

- Both the vendor and the researcher do not have to agree a vulnerability exists for a CVE to be assigned. One side can push it through over the other's objection.
- Getting a CVE assigned is not uniformly *hard* — nor is it uniformly *easy*. It depends entirely on the CNA, the product, and the politics involved. Both "you'll never get one" and "anyone can get one" are wrong.
- CVE is not a government program. It's not run by the NVD. It *is* run by MITRE.
- CVE is not exclusive to the USA — the CNA network is international.

### Data quality, disputes, and rejections

- A CVE is not never withdrawn or disputed. Disputes and rejections are a normal part of the lifecycle.
- A CVE is not produced by an all-knowing, infallible committee. Errors, duplicates, and bad data are baked into the system.
- The CVE system is not free from politics. Vendor reputation, scoring incentives, and disclosure disputes all shape what gets assigned and how it's described.
- CVE counts are not a security metric. High counts can signal scrutiny and a healthy disclosure process; zero counts can signal neglect or an inability to get IDs assigned. Don't read either as a security grade.

## If You Build This

- **Treat a CVE ID as a pointer, not a verdict.** Resolve it to the actual affected versions, the real fix status, and whether an exploit exists — don't let the existence of an ID drive triage on its own.
- **Don't trust the year in the ID as a date.** Use the reservation, publication, and modification timestamps separately; the `CVE-YEAR` prefix tells you when it was reserved, not when anything happened.
- **Separate CVE data from NVD enrichment in your pipeline,** and handle the cases where CVSS, affected-product, or severity fields are missing, late, or disputed. Build for "insufficient information," because that's the common case.
- **Never rank vendors or products by raw CVE count.** If you surface counts in a dashboard, pair them with context (disclosure maturity, fix latency) or you'll reward silence and punish transparency.
- **Handle the full lifecycle:** reserved, published, disputed, rejected, duplicated, and withdrawn are all states your tooling will encounter. Re-fetch and reconcile rather than caching a CVE as immutable truth.
- **Read CVSS scores as argued, not measured.** Descriptions can be framed to influence scoring, so weight your own reachability and exploitability analysis above the published number.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about CVEs (Jonathan Leitschuh)](https://medium.com/@jonathan.leitschuh/falsehoods-people-believe-about-cves-85c1d063ffda) · [archived copy](../archive/cve/01-falsehoods-about-cves-jonathan-leitschuh.md)
