# Falsehoods

Everything you're sure about — names, time, addresses, Unicode, money, even file paths — is wrong in ways that'll page you at 3am.

The "falsehoods programmers believe about X" genre is sharp and scattered: dozens of great posts, every one a different shape and depth. This pulls the best sources for each topic and merges them into one clean doc — the gut-punch surprises first, then the long tail of why it's harder than it looks, then what to actually do.

33 topics so far. Click any one; they render right here on GitHub.

## Topics

### People & identity

| | |
|---|---|
| **[Names](topics/names.md)** | Your name model is wrong, and it's wrong in ways that hurt real people. |
| **[Job Applicants](topics/job-applicants.md)** | Your assumptions about applicants and their histories are mostly wrong. |

### Places, maps & movement

| | |
|---|---|
| **[Postal Addresses](topics/postal-addresses.md)** | An address isn't a string, isn't a location, and sometimes isn't even necessary. |
| **[Geography](topics/geography.md)** | Places don't have one name, borders move, and coordinates lie. |
| **[Transportation](topics/transportation.md)** | Aviation data is messier than the planes, and a seat map is not a grid. |

### Time

| | |
|---|---|
| **[Dates and Time](topics/dates-and-time.md)** | Time isn't a line, a time zone isn't an offset, and the clock can run backwards. |

### Contact details

| | |
|---|---|
| **[Emails](topics/emails.md)** | Your email-validation regex is wrong, and the RFC is far weirder than you think. |
| **[Phone Numbers](topics/phone-numbers.md)** | A phone number isn't a number, isn't unique, and won't hold still. |

### Text, language & type

| | |
|---|---|
| **[Text and Unicode](topics/text-and-unicode.md)** | Unicode is not a character set, a character is not a code point, and string length is a lie. |
| **[Typography](topics/typography.md)** | Fonts lie about their metrics, and case is not a simple toggle. |

### Numbers & data formats

| | |
|---|---|
| **[Floating Point](topics/floating-point.md)** | 0.1 + 0.2 ≠ 0.3, and that's the least of your problems. |
| **[Systems of Measurement](topics/systems-of-measurement.md)** | Units don't convert as cleanly as grade-school math promised. |
| **[CSVs](topics/csvs.md)** | CSV has a spec, and almost nothing in the wild obeys it. |
| **[YAML](topics/yaml.md)** | YAML will turn your config into numbers, booleans, and the country of Norway. |
| **[Software Versions](topics/versions.md)** | A version number is not a number, and it isn't ordered the way you think. |

### Systems & low-level

| | |
|---|---|
| **[Null Pointers](topics/null-pointers.md)** | Null pointers are more cursed than pointers, and pointers are already cursed. |
| **[Undefined Behavior](topics/undefined-behavior.md)** | Undefined behavior can cause literally anything — for a broader 'anything' than you imagine. |
| **[CPU Caches](topics/cpu-caches.md)** | What you believe about CPU caches is quietly breaking your concurrency. |
| **[Garbage Collection](topics/garbage-collection.md)** | GC doesn't mean you can't leak, and it isn't unpredictable magic. |
| **[File Paths](topics/file-paths.md)** | A path is not a string, and Windows paths are a different animal entirely. |
| **[/dev/urandom](topics/urandom.md)** | Everything everyone repeats about /dev/urandom vs /dev/random is wrong. |

### Networks, web & distributed systems

| | |
|---|---|
| **[Networks](topics/networks.md)** | The network is not reliable, an IP address has many spellings, and DNS is not what you think. |
| **[The Web](topics/web.md)** | HTML, URLs, and REST are all weirder than the spec lets on. |
| **[Event-Driven Systems](topics/event-driven-systems.md)** | Messages arrive once, in order, exactly as sent — and other comforting lies. |
| **[Search](topics/search.md)** | Search is not SELECT … LIKE '%query%'. |
| **[Pagination](topics/pagination.md)** | Page 2 is not simply the rows after page 1. |

### Security

| | |
|---|---|
| **[CVEs](topics/cve.md)** | A CVE is not a vulnerability, and 36 other confusions. |

### Domains

| | |
|---|---|
| **[Business and Money](topics/business-and-money.md)** | Money, prices, and economics break software in expensive ways. |
| **[Cryptocurrency](topics/cryptocurrency.md)** | Crypto's clean abstractions hide jagged, irreversible edges. |
| **[Multimedia](topics/multimedia.md)** | Video and music metadata break every clean assumption you bring to them. |
| **[Art](topics/art.md)** | Art objects refuse every database schema you'd design for them. |
| **[Game Development](topics/game-development.md)** | Even a single door is a bottomless pit of design decisions. |
| **[Computer Science](topics/computer-science.md)** | The tidy abstractions you were taught leak everywhere in practice. |

## How it's made

Cheap models find and fetch the sources; a strong model does the writing. Reference lists and the archived source copies are generated, not hand-tended. The whole pipeline is a reusable skill: [`skills/falsehoods-doc-builder`](skills/falsehoods-doc-builder/SKILL.md).

Add a topic to [`topics.json`](topics.json), run `scripts/build-topic.sh <slug>`, done. Sources rot, so each one is also saved under [`archive/`](archive/) with credit and a link home.

## Credit

This is a remix. The hard part was done by the people who hit these walls first and wrote it down — every topic's **Sources** section names them, with a link to the original and to the archived copy. Go read the originals; they're worth your time.

## License

- **The docs** (`topics/`): [CC BY 4.0](LICENSE). Share and adapt them, just credit back here.
- **The tooling** (`scripts/`, `prompts/`, `skills/`): [MIT](LICENSE-CODE).
- **The archived sources** (`archive/`): still their original authors' work, kept for preservation. Their rights, not mine.
