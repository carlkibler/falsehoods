#!/usr/bin/env python3
"""build-readme.py — regenerate README.md from topics.json.

The topic index is generated, not hand-maintained, so adding a topic is just an
edit to topics.json + a rerun. Edit GROUPS below to change ordering/grouping;
edit the prose blocks (INTRO, OUTRO_*) to change the surrounding copy.

Any topic not listed in GROUPS is appended to a "More" group with a warning,
so a new topic is never silently dropped and the build never hard-fails.

Usage: scripts/build-readme.py
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOPICS_JSON = os.path.join(ROOT, "topics.json")
README = os.path.join(ROOT, "README.md")

# (group heading, [slugs in display order]). Reorder freely.
GROUPS = [
    ("People & identity", ["names", "job-applicants", "emails", "phone-numbers"]),
    ("Places, maps & movement", ["postal-addresses", "geography", "transportation"]),
    ("Time", ["dates-and-time"]),
    ("Text, language & type", ["text-and-unicode", "typography"]),
    ("Numbers & data formats", ["floating-point", "systems-of-measurement", "csvs", "yaml", "versions"]),
    ("Systems & low-level", ["null-pointers", "undefined-behavior", "cpu-caches", "garbage-collection", "file-paths", "urandom"]),
    ("Networks, web & distributed systems", ["networks", "web", "event-driven-systems", "search", "pagination"]),
    ("Security", ["cve"]),
    ("AI", ["ai"]),
    ("Domains", ["business-and-money", "cryptocurrency", "multimedia", "art", "game-development", "computer-science"]),
]

INTRO = """\
# Falsehoods

Everything you're sure about — names, time, addresses, Unicode, money, even file paths — is wrong in ways that'll page you at 3am.

The "falsehoods programmers believe about X" genre is sharp and scattered: dozens of great posts, every one a different shape and depth. This pulls the best sources for each topic and merges them into one clean doc — the gut-punch surprises first, then the long tail of why it's harder than it looks, then what to actually do.

{count} topics so far. Click any one; they render right here on GitHub.

## Topics
"""

OUTRO = """\
## How it's made

Cheap models find and fetch the sources; a strong model does the writing. Reference lists and the archived source copies are generated, not hand-tended. The whole pipeline is a reusable skill: [`skills/falsehoods-doc-builder`](skills/falsehoods-doc-builder/SKILL.md).

Add a topic to [`topics.json`](topics.json), run `scripts/build-topic.sh <slug>`, then `scripts/build-readme.py` to refresh this index. Sources rot, so each one is also saved under [`archive/`](archive/) with credit and a link home.

## Credit

This is a remix. The hard part was done by the people who hit these walls first and wrote it down — every topic's **Sources** section names them, with a link to the original and to the archived copy. Go read the originals; they're worth your time.

## License

- **The docs** (`topics/`): [CC BY 4.0](LICENSE). Share and adapt them, just credit back here.
- **The tooling** (`scripts/`, `prompts/`, `skills/`): [MIT](LICENSE-CODE).
- **The archived sources** (`archive/`): still their original authors' work, kept for preservation. Their rights, not mine.
"""


def short_title(title: str) -> str:
    s = title.replace("Falsehoods About ", "")
    return "The Web" if s == "the Web" else s


def main():
    topics = json.load(open(TOPICS_JSON))

    placed = [s for _, slugs in GROUPS for s in slugs]
    groups = [(name, list(slugs)) for name, slugs in GROUPS]

    unplaced = [s for s in topics if s not in placed]
    if unplaced:
        print(f"warning: {len(unplaced)} topic(s) not in GROUPS, appended to 'More': "
              f"{', '.join(unplaced)}", file=sys.stderr)
        groups.append(("More", unplaced))

    # Drop any slug listed in GROUPS that no longer exists in topics.json.
    missing = [s for s in placed if s not in topics]
    if missing:
        print(f"warning: GROUPS references unknown slug(s): {', '.join(missing)}", file=sys.stderr)

    out = [INTRO.format(count=len(topics))]
    for name, slugs in groups:
        slugs = [s for s in slugs if s in topics]
        if not slugs:
            continue
        out.append(f"### {name}\n")
        for s in slugs:
            out.append(f"- **[{short_title(topics[s]['title'])}](topics/{s}.md)** — {topics[s]['hook']}")
        out.append("")
    out.append(OUTRO)

    open(README, "w").write("\n".join(out).rstrip() + "\n")
    print(f"README.md regenerated: {len(topics)} topics across {len(groups)} groups")


if __name__ == "__main__":
    main()
