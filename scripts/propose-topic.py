#!/usr/bin/env python3
"""propose-topic.py — extract candidate sources for a topic from the awesome-falsehood list.

Encodes the "research and collection" phase: given a section name from
kdeldycke/awesome-falsehood (e.g. "Emails", "Postal Addresses", "Dates and Time"),
fetch the list, pull the links under that section, and emit a topics.json snippet
ready to paste/merge (after you trim it to the best 2-4 sources and write a hook).

Usage:
    scripts/propose-topic.py "Emails"
    scripts/propose-topic.py --list          # show all available sections
    scripts/propose-topic.py "Emails" --slug emails --merge   # merge into topics.json

This is a *starting point*, not the final word. Human judgment still picks the best
2-4 sources, drops dead/video/paywalled links, and writes the one-line hook.
"""
import json
import re
import subprocess
import sys
import os

RAW_CANDIDATES = [
    "https://raw.githubusercontent.com/kdeldycke/awesome-falsehood/main/readme.md",
    "https://raw.githubusercontent.com/kdeldycke/awesome-falsehood/master/readme.md",
    "https://raw.githubusercontent.com/kdeldycke/awesome-falsehood/main/README.md",
]
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOPICS_JSON = os.path.join(ROOT, "topics.json")


def fetch_readme():
    for url in RAW_CANDIDATES:
        try:
            r = subprocess.run(["curl", "-sL", "--max-time", "20", url],
                               capture_output=True, text=True, timeout=25)
            if r.returncode == 0 and "## " in r.stdout and "alsehood" in r.stdout:
                return r.stdout
        except Exception:
            continue
    # Fallback: gh api
    try:
        r = subprocess.run(["gh", "api", "repos/kdeldycke/awesome-falsehood/readme",
                            "--jq", ".content"], capture_output=True, text=True, timeout=25)
        if r.returncode == 0:
            import base64
            return base64.b64decode(r.stdout).decode("utf-8")
    except Exception:
        pass
    sys.exit("Could not fetch awesome-falsehood readme (tried raw URLs and gh api).")


def sections(readme):
    """Return {section_name: [lines]} for level-2 headings."""
    out = {}
    current = None
    for line in readme.splitlines():
        m = re.match(r"^##\s+(.+?)\s*$", line)
        if m:
            current = m.group(1)
            out[current] = []
        elif current is not None:
            out[current].append(line)
    return out


def extract_links(lines):
    """Pull [label](url) pairs from bullet lines; first link per bullet wins."""
    sources = []
    seen = set()
    for line in lines:
        if not line.strip().startswith("-"):
            continue
        for label, url in re.findall(r"\[([^\]]+)\]\((https?://[^)]+)\)", line):
            if url in seen:
                continue
            seen.add(url)
            sources.append({"label": label.strip(), "url": url.strip()})
    return sources


def main():
    args = [a for a in sys.argv[1:]]
    if "--list" in args:
        readme = fetch_readme()
        skip = {"Contents", "Meta", "Contributing", "Footnotes"}
        for name in sections(readme):
            if name not in skip:
                print(name)
        return

    do_merge = "--merge" in args
    args = [a for a in args if a != "--merge"]
    slug = None
    if "--slug" in args:
        i = args.index("--slug")
        slug = args[i + 1]
        del args[i:i + 2]

    if not args:
        sys.exit("Usage: propose-topic.py \"Section Name\" [--slug SLUG] [--merge] | --list")

    section = args[0]
    readme = fetch_readme()
    secs = sections(readme)
    if section not in secs:
        near = [s for s in secs if section.lower() in s.lower()]
        hint = f"  did you mean: {', '.join(near)}" if near else ""
        sys.exit(f"Section '{section}' not found. Use --list to see options.\n{hint}")

    sources = extract_links(secs[section])
    if not slug:
        slug = re.sub(r"[^a-z0-9]+", "-", section.lower()).strip("-")

    entry = {
        "title": f"Falsehoods About {section}",
        "hook": "TODO: write a one-line hook — the gut-punch version of why this is hard.",
        "sources": sources,
    }
    snippet = {slug: entry}

    if do_merge:
        with open(TOPICS_JSON) as f:
            topics = json.load(f)
        if slug in topics:
            print(f"⚠  '{slug}' already in topics.json — printing snippet instead of overwriting.", file=sys.stderr)
            print(json.dumps(snippet, indent=2, ensure_ascii=False))
            return
        topics[slug] = entry
        with open(TOPICS_JSON, "w") as f:
            json.dump(topics, f, indent=2, ensure_ascii=False)
            f.write("\n")
        print(f"Merged '{slug}' into topics.json with {len(sources)} candidate sources.", file=sys.stderr)
        print("Now: trim to the best 2-4 sources, drop video/paywalled/dead links, write the hook.", file=sys.stderr)
    else:
        print(json.dumps(snippet, indent=2, ensure_ascii=False))
        print(f"\n# {len(sources)} candidate sources for '{section}' (slug: {slug}).", file=sys.stderr)
        print("# Trim to the best 2-4, write a hook, then add to topics.json (or rerun with --merge).", file=sys.stderr)


if __name__ == "__main__":
    main()
