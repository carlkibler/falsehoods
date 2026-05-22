# Falsehoods

Consolidated, consistently-formatted docs on all the ways programmers get common concepts badly wrong — names, addresses, phone numbers, time, and more.

Each document merges the 2–4 best sources on a topic into one complete, readable, approachable reference. Big surprises first, then the long tail of subtler complexity, with concrete examples throughout.

## Topics

| Doc | Summary |
|-----|---------|
| [Names](topics/names.md) | Your name model is wrong, and it's wrong in ways that hurt real people. |
| [Postal Addresses](topics/postal-addresses.md) | An address isn't a string, isn't a location, and sometimes isn't even necessary. |
| [Dates and Time](topics/dates-and-time.md) | Time isn't a line, a time zone isn't an offset, and the clock can run backwards. |

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
