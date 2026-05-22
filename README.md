# Falsehoods

Consolidated, consistently-formatted docs on all the ways programmers get common concepts badly wrong — names, addresses, phone numbers, time, and more.

Each document merges the 2–4 best sources on a topic into one complete, readable, approachable reference. Big surprises first, then the long tail of subtler complexity, with concrete examples throughout.

## Topics

33 consolidated references, grouped by theme.

### People & Identity

| Doc | The gist |
|-----|----------|
| [Names](topics/names.md) | Your name model is wrong, and it's wrong in ways that hurt real people. |
| [Job Applicants](topics/job-applicants.md) | Your assumptions about applicants and their histories are mostly wrong. |

### Places, Maps & Movement

| Doc | The gist |
|-----|----------|
| [Postal Addresses](topics/postal-addresses.md) | An address isn't a string, isn't a location, and sometimes isn't even necessary. |
| [Geography](topics/geography.md) | Places don't have one name, borders move, and coordinates lie. |
| [Transportation](topics/transportation.md) | Aviation data is messier than the planes, and a seat map is not a grid. |

### Time

| Doc | The gist |
|-----|----------|
| [Dates and Time](topics/dates-and-time.md) | Time isn't a line, a time zone isn't an offset, and the clock can run backwards. |

### Contact Details

| Doc | The gist |
|-----|----------|
| [Emails](topics/emails.md) | Your email-validation regex is wrong, and the RFC is far weirder than you think. |
| [Phone Numbers](topics/phone-numbers.md) | A phone number isn't a number, isn't unique, and won't hold still. |

### Text, Language & Type

| Doc | The gist |
|-----|----------|
| [Text and Unicode](topics/text-and-unicode.md) | Unicode is not a character set, a character is not a code point, and string length is a lie. |
| [Typography](topics/typography.md) | Fonts lie about their metrics, and case is not a simple toggle. |

### Numbers & Data Formats

| Doc | The gist |
|-----|----------|
| [Floating Point](topics/floating-point.md) | 0.1 + 0.2 ≠ 0.3, and that's the least of your problems. |
| [Systems of Measurement](topics/systems-of-measurement.md) | Units don't convert as cleanly as grade-school math promised. |
| [CSVs](topics/csvs.md) | CSV has a spec, and almost nothing in the wild obeys it. |
| [YAML](topics/yaml.md) | YAML will turn your config into numbers, booleans, and the country of Norway. |
| [Software Versions](topics/versions.md) | A version number is not a number, and it isn't ordered the way you think. |

### Systems & Low-Level

| Doc | The gist |
|-----|----------|
| [Null Pointers](topics/null-pointers.md) | Null pointers are more cursed than pointers, and pointers are already cursed. |
| [Undefined Behavior](topics/undefined-behavior.md) | Undefined behavior can cause literally anything — for a broader 'anything' than you imagine. |
| [CPU Caches](topics/cpu-caches.md) | What you believe about CPU caches is quietly breaking your concurrency. |
| [Garbage Collection](topics/garbage-collection.md) | GC doesn't mean you can't leak, and it isn't unpredictable magic. |
| [File Paths](topics/file-paths.md) | A path is not a string, and Windows paths are a different animal entirely. |
| [/dev/urandom](topics/urandom.md) | Everything everyone repeats about /dev/urandom vs /dev/random is wrong. |

### Networks, Web & Distributed Systems

| Doc | The gist |
|-----|----------|
| [Networks](topics/networks.md) | The network is not reliable, an IP address has many spellings, and DNS is not what you think. |
| [The Web](topics/web.md) | HTML, URLs, and REST are all weirder than the spec lets on. |
| [Event-Driven Systems](topics/event-driven-systems.md) | Messages arrive once, in order, exactly as sent — and other comforting lies. |
| [Search](topics/search.md) | Search is not SELECT … LIKE '%query%'. |
| [Pagination](topics/pagination.md) | Page 2 is not simply the rows after page 1. |

### Security

| Doc | The gist |
|-----|----------|
| [CVEs](topics/cve.md) | A CVE is not a vulnerability, and 36 other confusions. |

### Domains

| Doc | The gist |
|-----|----------|
| [Business and Money](topics/business-and-money.md) | Money, prices, and economics break software in expensive ways. |
| [Cryptocurrency](topics/cryptocurrency.md) | Crypto's clean abstractions hide jagged, irreversible edges. |
| [Multimedia](topics/multimedia.md) | Video and music metadata break every clean assumption you bring to them. |
| [Art](topics/art.md) | Art objects refuse every database schema you'd design for them. |
| [Game Development](topics/game-development.md) | Even a single door is a bottomless pit of design decisions. |
| [Computer Science](topics/computer-science.md) | The tidy abstractions you were taught leak everywhere in practice. |


## How These Are Built

Sources are fetched via `curl | pandoc` into per-topic packets (keeping page text out of the orchestrator's context), then synthesized into the consistent template by a strong model (default `sonnet`). Cheap/deterministic tooling does the research and fetching; the writing gets a high-cohesion model for quality. Reference lists are script-appended — not model-generated — so links are always accurate.

```
scripts/propose-topic.py "Section Name"                  # pull candidate sources from awesome-falsehood
scripts/build-topic.sh <slug> [--dry-run] [--force] \
    [--model MODEL] [--format FORMAT]                     # fetch → synthesize → write topics/<slug>.md
```

Every knob is externalized for easy re-runs and re-styling:

- **Sources** live in `topics.json`.
- **Voice** lives in `prompts/system.md`; **structure + rules** in `prompts/<format>.md` (with `{{TITLE}} {{HOOK}} {{SOURCE_COUNT}}` placeholders).
- **Model** is the `--model` flag; **output type** is the `--format` flag (add new `prompts/<format>.md` files for presentations, cheatsheets, etc.).

The `sources/` directory (gitignored) caches cleaned source markdown for reruns.

The whole process is captured as a portable skill (Claude / Codex / other harnesses) at [`skills/falsehoods-doc-builder/`](skills/falsehoods-doc-builder/SKILL.md) so it can be re-run and refined anytime.

## Doc Template

Each topic follows this structure:

```
# Falsehoods About <Topic>

> One-line hook — why this is harder than you think.

## The Big Surprises
- 6–10 jaw-dropping headline falsehoods, punchy.

## Where It Gets Complicated
### <grouped sub-themes with examples>

## If You Build This
- Practical takeaways.

## Sources
- curated list of original resources
```

## Source Curation

`topics.json` maps each slug to its title, hook, and curated source URLs. Adding a new topic = adding an entry there, then running `build-topic.sh`.
