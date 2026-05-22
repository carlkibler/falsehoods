# Falsehoods

Consolidated, consistently-formatted docs on all the ways programmers get common concepts badly wrong — names, addresses, phone numbers, time, and more.

Each document merges the 2–4 best sources on a topic into one complete, readable, approachable reference. Big surprises first, then the long tail of subtler complexity, with concrete examples throughout.

## Topics

| Doc | Summary |
|-----|---------|
| [Names](topics/names.md) | Your name model is wrong, and it's wrong in ways that hurt real people. |

## How These Are Built

Sources are fetched via `curl | pandoc` into per-topic packets, then synthesized by kimi-2.6 into the consistent template. Reference lists are script-appended — not model-generated — so links are always accurate.

```
scripts/build-topic.sh <slug> [--dry-run] [--model MODEL]
```

The `sources/` directory (gitignored) caches cleaned source markdown for reruns.

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
