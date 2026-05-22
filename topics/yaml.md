# Falsehoods About YAML

> YAML will turn your config into numbers, booleans, and the country of Norway.

## The Big Surprises

- **"Writing `no` in a list means the string `no`."** Nope. In YAML 1.1, `no` parses as the boolean `false`. A list of Nordic country codes — `dk, fi, is, no, se` — comes back as `["dk", "fi", "is", false, "se"]`. This is so infamous it has a name: the Norway problem.
- **"`22:22` is a string (a port mapping)."** In YAML 1.1, numbers from 0–59 separated by colons are sexagesimal (base-60) literals. So `22:22` parses as the integer `1342`. PyYAML (via libyaml) still does this today.
- **"My Postgres version `10.23` stays a version string."** Unquoted, `10.23` and `12.13` parse as floats, while `9.5.25` and `9.6.24` stay strings (three segments isn't a valid number). One config, two different types in the same list.
- **"Keys are always strings, like in JSON."** YAML keys can be any value, including booleans. `on:` becomes the boolean key `true` — which is exactly why GitHub Actions' `on:` trigger is a perennial source of confusion.
- **"Loading a YAML file just gives me data."** A `!`-prefixed tag tells the parser to call a constructor, so loading untrusted YAML can mean arbitrary code execution. In Python this is why `yaml.safe_load` exists and `yaml.load` is dangerous.
- **"The same document parses the same everywhere."** YAML is versioned, and 1.1 vs 1.2 differ substantially. The *same* file parses differently depending on which version your parser implements — and most parsers are still effectively 1.1.
- **"Syntax highlighting will warn me when a value isn't a string."** Vim, GitHub, Codeberg, and a typical blog generator each highlight the same document differently. No two pick out the same subset of values as non-strings.
- **"YAML is simple because it's human-friendly."** The spec is 10 chapters, nested four levels deep, with its own errata page. There's an entire website devoted to choosing among 63 different multi-line string syntaxes.

## Where It Gets Complicated

### Implicit typing turns text into other things

The root cause of nearly every YAML surprise: unquoted scalars get type-inferred, and the inference rules are broad and version-dependent. A value that *looks* like a string can silently become a boolean, integer, float, or null. You don't opt into typing — you opt out of it, and only if you remember to quote.

`~` is an alternative spelling of `null`. Integers with a leading `0` are octal literals (in YAML 1.1). None of this is visible until something downstream breaks.

### String surprises: the Norway problem

The literals `off`, `no`, and `n` (in various capitalizations, but — maddeningly — not *every* capitalization) all parse as `false` in YAML 1.1, with `on`, `yes`, and `y` as `true`.

```yaml
geoblock_regions:
  - dk
  - fi
  - is
  - no   # <- becomes false
  - se
```

YAML 1.2 removed these alternative boolean spellings, but they're so pervasive in real-world documents that strict parsers struggle. Go's yaml library split the difference: since v3.0.0 (May 2022) it treats `yes`/`no`/`on`/`off` as booleans *only* when decoding into a typed bool, and as strings otherwise. Earlier versions behaved differently — so even pinning to "Go's yaml" isn't enough; you have to pin the version.

### Numbers: sexagesimal and accidental floats

```yaml
port_mapping:
  - 22:22   # -> 1342 in YAML 1.1
  - 80:80   # -> "80:80" (81 > 59, so not sexagesimal)
  - 443:443
```

Colon-separated digits in 0–59 are base-60 numbers in YAML 1.1, silently removed in 1.2. The same `22:22` is `1342` or `"22:22"` depending on the parser.

Version strings are the everyday version of this trap:

```yaml
allow_postgres_versions:
  - 9.5.25   # string
  - 9.6.24   # string
  - 10.23    # float!
  - 12.13    # float!
```

What makes this insidious: many dynamically typed apps implicitly coerce the number back to a string when needed, so it works *most* of the time. This Jinja template accepts both `version: "0.0"` and `version: 0.0`, but only takes the true-branch for the quoted one — because `0.0` is falsy:

```jinja
{% if version %}Latest version: {{ version }}{% else %}Version not specified{% endif %}
```

Edit a config from `9.6.24` to `10.23` and the type changes underneath you. Would you remember to add the quotes?

### Non-string keys

JSON keys are always strings; YAML keys can be anything, including booleans.

```yaml
flush_cache:
  on: [push, memory_pressure]
  priority: background
```

Because `on` parses as the boolean `true`, you get a mapping with a boolean key. How that maps out is language-dependent — in Python it stringifies to `"True"`. The `on:` key is everywhere because GitHub Actions uses it for triggers.

### Anchors, aliases, and tags

`&name` defines an anchor; `*name` references it as an alias. Get the syntax slightly wrong (an alias with no matching anchor) and the document is simply invalid. Meanwhile a `!`-prefixed tag asks the parser to construct a richer host-language type, often by calling a named constructor with the following value — which is why loading untrusted YAML is unsafe. Given an unknown tag like `!.git`, PyYAML refuses to load the document, while Go's yaml package is lenient and returns an empty string. Same input, two outcomes.

### Version differences: YAML 1.1 vs 1.2

JSON's spec has been frozen for almost two decades. YAML's is actively versioned and evolving — 1.2.2 landed in October 2021 after years of work by a dedicated language team, who plan to keep evolving it. Sexagesimal numbers, octal-via-leading-zero, and the `yes`/`no` booleans all behave differently between 1.1 and 1.2. And "is it 1.1 or 1.2?" is rarely a choice you make consciously — it's whatever your parser happens to implement. libyaml (used by PyYAML) is still 1.1, more than a decade after 1.2 shipped.

### Complexity and footguns

Other arcana that round out the picture: directives, `?` introducing a complex mapping key, and the 63-flavors of multi-line strings. The deeper problem is that the format is too large to hold in your head, so you can't reliably predict how a given document parses. And **templating YAML is a terrible idea** — concatenating and escaping text fragments into valid, correct YAML, with significant whitespace on top, is meme-worthily hard to get right. Generating JSON is safer, easier, and more powerful.

## If You Build This

- **Quote everything ambiguous — ideally everything.** You can spot an experienced YAML engineer by how defensively they quote strings. Use `true`/`false`, never `yes`/`no`/`on`/`off`. Quote version strings, country codes, port mappings, and anything that could be read as a number, boolean, or null.
- **Prefer a different format when the choice is yours.** TOML has nearly the same data model, allows comments, and avoids the footguns because strings are always quoted — and it's in the Python standard library (YAML isn't). JSON-with-comments is another low-complexity option. Reach for these before YAML.
- **Pin your parser and its YAML version.** The same document parses differently across 1.1 and 1.2 and across library versions (e.g. Go's yaml pre/post v3.0.0). Choose a 1.2 parser deliberately and lock the version so behavior is reproducible.
- **Never load untrusted YAML with the unsafe loader.** Tags can trigger arbitrary code execution. Use `yaml.safe_load` (or your language's equivalent) for anything you didn't write yourself.
- **Don't template YAML — generate it.** YAML is a superset of JSON, so anything that emits JSON emits valid YAML. For repetitive configs (Kubernetes, GitHub Actions), use a real language — Nix, Python, or a typed config language like Dhall/Cue — and have it print JSON. You get abstraction and reuse without escaping hell.
- **Validate against a schema.** Don't trust that a value is the type you intended; check it. A schema catches the float-that-should-be-a-string before it reaches production.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [The YAML document from hell (Ruud van Asseldonk)](https://ruudvanasseldonk.com/2023/01/11/the-yaml-document-from-hell) · [archived copy](../archive/yaml/01-the-yaml-document-from-hell-ruud-van-asseldonk.md)
