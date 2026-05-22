---
name: falsehoods-doc-builder
description: "Build consolidated, consistently-formatted 'falsehoods programmers believe about X' reference docs in the falsehoods repo (~/dev/me/falsehoods). Use whenever the user wants to research, generate, regenerate, or fan out falsehoods/myths/misconceptions documents on a topic (names, addresses, phone numbers, time, unicode, etc.), add a new topic, change the synthesis model or prompt, or produce a new output format from the curated sources. Also use when reviewing or improving the falsehoods pipeline itself."
---

# Falsehoods Doc Builder

Turn the scattered "falsehoods programmers believe about X" blog posts into one clean, complete, approachable reference doc per topic — big surprises first, then the long tail, examples intact, sources credited.

The whole point of this repo is **reproducibility**: every knob (sources, model, prompt, output format) is externalized so you can re-run, re-style, or re-model any topic in seconds without rehashing the process from scratch.

## Repo location and layout

Everything lives in `~/dev/me/falsehoods/`:

```
topics.json            curated source map: slug → {title, hook, sources[]}   ← the durable input
prompts/
  system.md            the writer's voice/persona
  reference-doc.md     structure + rules with {{TITLE}} {{HOOK}} {{SOURCE_COUNT}} placeholders
  <format>.md          add more for other output types (presentation, cheatsheet, …)
scripts/
  build-topic.sh       fetch sources → synthesize via cheap model → write topics/<slug>.md
  propose-topic.py     pull candidate sources for a topic out of the awesome-falsehood list
topics/<slug>.md       the deliverables
sources/<slug>/        gitignored cache of fetched source markdown + _packet.md
```

## The core insight (read this before changing anything)

Two separate principles drive the design:

**1. The fetcher has no web access, so split fetch from synthesis.** The `agent` CLI is a pure LLM completion — it cannot browse. So:
- **You (the orchestrator)** fetch source pages to disk with `curl | pandoc` so the page text never enters your context — near-zero token cost.
- **A model** does the token-heavy reading and writing, turning the on-disk packet into a polished doc.

Don't WebFetch sources into your own context to "help" — that defeats the purpose and burns tokens. The only time you touch a page directly is the Playwright fallback below.

**2. Cheap models for research, strong models for writing.** Use cheap/deterministic tooling for the *discovery* work (source listing via `propose-topic.py`, fetching). But the *synthesis* — merging four messy sources into one coherent, high-quality doc — wants a strong, high-cohesion model. Cheap models get disordered on multi-source packets well before their advertised context window, producing repetition and dropped points. This is a quality task, usually run once per topic, so spend on it:
- **Default `--model sonnet`** — strong cohesion, the right baseline.
- **`--model opus` or `--frontier`** — for maximum quality.
- **`--model kimi-2.6`** — only to economize on a simple/short topic.
- If a packet is large (many or long sources), prefer a stronger model or trim sources; don't hand a giant packet to a cheap model and hope.

## Workflow

### 1. Curate sources for the topic

If the topic exists in [kdeldycke/awesome-falsehood](https://github.com/kdeldycke/awesome-falsehood), start there:

```bash
scripts/propose-topic.py --list                  # see all sections
scripts/propose-topic.py "Postal Addresses"      # print candidate sources as a topics.json snippet
```

Then apply judgment — this is the part that can't be automated:
- Keep the **best 2–4 sources**, not all of them. The canonical original + one "with examples" elaboration + one cross-cultural/standards reference + one human-impact war story is a great recipe.
- Drop links that won't yield prose: YouTube talks, Twitter/X threads, raw images, library API docs, dead links.
- Write a one-line **hook** — the gut-punch version of why this topic is hard.

For topics *not* in awesome-falsehood, find sources via web search yourself, then hand-write the `topics.json` entry. Prefer primary sources (the original essay) over aggregators.

Add the finalized entry to `topics.json` (or use `propose-topic.py "Section" --slug foo --merge` then trim).

### 2. Dry-run the fetch

```bash
scripts/build-topic.sh <slug> --dry-run
```

Confirm each source fetched with a healthy character count and the packet looks sane. Watch stderr for `⚠ PLAYWRIGHT NEEDED` — that source is JS-rendered or bot-walled (see fallback below).

### 3. Build

```bash
scripts/build-topic.sh <slug>            # default model sonnet, format reference-doc
scripts/build-topic.sh <slug> --force    # overwrite an existing doc
```

The script: fetches each source (3-tier: `curl|pandoc` → thinness check → flag for Playwright), assembles `sources/<slug>/_packet.md`, calls `agent <model> --file packet …` with the externalized prompts, strips any leading whitespace, and appends a **deterministic `## Sources`** list from `topics.json` (never model-generated, so links never hallucinate).

It then runs a **truncation guard**: if the output is missing the final `## If You Build This` section, the model hit its output-token ceiling and the doc is cut off mid-sentence. The script warns; rebuild with a stronger model, more `--max-tokens` headroom (currently 32000), or fewer/smaller sources.

### 4. Review the output

Read `topics/<slug>.md` and check:
- Structure matches the template (Big Surprises → Where It Gets Complicated → If You Build This → Sources).
- The big surprises are genuinely punchy and lead with concrete examples.
- Vivid examples survived (real names, places, war stories — not flattened into abstractions).
- The `## Sources` list is correct.

If it's off, adjust a knob and rebuild (see "Adjusting knobs"). Synthesis is cheap; iterate freely.

### 5. Fan out

Repeat per topic. Update the topic index table in `README.md`. Commit.

## Adjusting knobs (the reason this is a repo, not a one-off)

- **Different model:** `--model deepseek` / `--model grok` / `--model "<openrouter/id>"`. See `~/.claude/bin/agent` for shorthands. Good for comparing voice or cost.
- **Different prompt/voice:** edit `prompts/system.md` (persona) or `prompts/reference-doc.md` (structure + rules). No script changes needed.
- **Different output type:** copy `prompts/reference-doc.md` to `prompts/<format>.md`, rewrite the structure (e.g. a step-through `presentation` with one surprise per slide), then `build-topic.sh <slug> --format <format>`. The `{{TITLE}} {{HOOK}} {{SOURCE_COUNT}}` placeholders are interpolated for any format.
- **Different sources:** edit the topic's `sources[]` in `topics.json` and `--force` rebuild.

## Playwright fallback for JS-rendered sources

When the fetch flags `⚠ PLAYWRIGHT NEEDED <url>`, `curl` got a near-empty shell because the page renders content with JavaScript. To rescue that source, see `references/playwright-fetch.md` for the exact procedure (navigate with the Playwright MCP, extract the article DOM, write cleaned text into the source file, rebuild). Only do this for sources worth the effort — a doc built from 3 of 4 sources is usually still excellent, and the missing source stays credited in `## Sources`.

## Conventions

- Scripts are dry-run-friendly (`--dry-run` fetches without calling the model). Synthesis writes a file — that's the intended effect, not a mutation to guard.
- `sources/` is gitignored and fully reproducible; never commit it.
- Commit `topics.json`, `prompts/`, `scripts/`, `topics/`, and this skill.
