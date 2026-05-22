#!/usr/bin/env bash
# build-topic.sh <slug> [--dry-run] [--model MODEL] [--format FMT] [--force]
# Fetches sources for a topic, synthesizes via agent, writes topics/<slug>.md
#
# Adjustable knobs (no need to edit this script):
#   --model   any agent shorthand or OpenRouter id (default: sonnet)
#   --format  selects prompts/<format>.md as the synthesis instruction (default: reference-doc)
#   prompts/system.md       the writer's voice/persona
#   prompts/<format>.md     the structure + rules, with {{TITLE}} {{HOOK}} {{SOURCE_COUNT}} placeholders
#   topics.json             the curated source map
#
# Division of labor: source RESEARCH/discovery uses cheap deterministic tooling
# (propose-topic.py, curl|pandoc). The SYNTHESIS/writing wants a strong, high-
# cohesion model — cheap models get disordered on multi-source packets long
# before their advertised context limit. Default is sonnet; use --model opus or
# --frontier for max quality, --model kimi-2.6 to economize on simple topics.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOPICS_JSON="$ROOT/topics.json"
TOPICS_DIR="$ROOT/topics"
SOURCES_DIR="$ROOT/sources"
PROMPTS_DIR="$ROOT/prompts"

SLUG=""
DRY_RUN=0
FORCE=0
MODEL="sonnet"
FORMAT="reference-doc"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)   DRY_RUN=1; shift ;;
    --force)     FORCE=1; shift ;;
    --model)     MODEL="$2"; shift 2 ;;
    --model=*)   MODEL="${1#*=}"; shift ;;
    --format)    FORMAT="$2"; shift 2 ;;
    --format=*)  FORMAT="${1#*=}"; shift ;;
    -*)          echo "Unknown option: $1" >&2; exit 2 ;;
    *)           SLUG="$1"; shift ;;
  esac
done

if [[ -z "$SLUG" ]]; then
  echo "Usage: build-topic.sh <slug> [--dry-run] [--model MODEL] [--format FMT] [--force]" >&2
  echo "Available slugs: $(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(', '.join(d.keys()))")" >&2
  echo "Available formats: $(ls "$PROMPTS_DIR" 2>/dev/null | grep -v '^system.md$' | sed 's/\.md$//' | tr '\n' ' ')" >&2
  exit 1
fi

SYSTEM_FILE="$PROMPTS_DIR/system.md"
FORMAT_FILE="$PROMPTS_DIR/$FORMAT.md"
if [[ ! -f "$SYSTEM_FILE" ]]; then echo "Missing $SYSTEM_FILE" >&2; exit 1; fi
if [[ ! -f "$FORMAT_FILE" ]]; then echo "Unknown format '$FORMAT' (no $FORMAT_FILE)" >&2; exit 1; fi

# --- Load topic metadata ---
TITLE=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(d['$SLUG']['title'])")
HOOK=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(d['$SLUG']['hook'])")
SOURCE_COUNT=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(len(d['$SLUG']['sources']))")

echo "=== Building: $TITLE ==="
echo "    hook: $HOOK"
echo "    sources: $SOURCE_COUNT"
echo "    model: $MODEL"
echo "    format: $FORMAT"
echo ""

# --- Fetch sources ---
TOPIC_SOURCES_DIR="$SOURCES_DIR/$SLUG"     # gitignored scratch (packet, sources section)
ARCHIVE_DIR="$ROOT/archive/$SLUG"          # COMMITTED preservation copies of each source
mkdir -p "$TOPIC_SOURCES_DIR" "$ARCHIVE_DIR"
PACKET="$TOPIC_SOURCES_DIR/_packet.md"
SOURCES_SECTION="$TOPIC_SOURCES_DIR/_sources.md"

{
  echo "# SOURCE PACKET: $TITLE"
  echo "# Hook: $HOOK"
  echo "# Sources: $SOURCE_COUNT"
  echo ""
} > "$PACKET"

python3 - "$TOPICS_JSON" "$SLUG" "$TOPIC_SOURCES_DIR" "$PACKET" "$ARCHIVE_DIR" "$SOURCES_SECTION" "$TITLE" <<'PY'
import json, sys, subprocess, os, re
from html.parser import HTMLParser

topics_json, slug, sources_dir, packet_path, archive_dir, sources_section_path, title = sys.argv[1:]
with open(topics_json) as f:
    topic = json.load(f)[slug]

sources = topic["sources"]
MAX_SOURCE_CHARS = 40000  # ~10k tokens each; enough for any blog post

ARCHIVE_NOTE = (
    "> **Archived for preservation.** This is a Markdown-extracted copy of the original, "
    "saved here in case it disappears from the web. Formatting and images are not preserved — "
    "please refer to the original (linked above) for the version as the author intended it.\n>\n"
    "> With gratitude to the author for compiling these notes, ideas, and facts."
)

class HTMLCleaner(HTMLParser):
    """Strip nav/footer/script/style bloat; keep article prose.

    Void elements (img, br, hr, …) have NO closing tag, so they must never
    change nesting depth — otherwise a single <img> in the SKIP set strands
    the depth counter and silently suppresses ALL following content. (Real bug:
    it killed every image-bearing blog post.)
    """
    SKIP = {'script','style','nav','header','footer','aside','noscript','form','button','select','option','iframe','svg','figure','figcaption'}
    VOID = {'area','base','br','col','embed','hr','img','input','link','meta','param','source','track','wbr'}
    BLOCK = {'p','li','h1','h2','h3','h4','h5','h6','article','section','main','blockquote','pre','dt','dd','th','td','tr','div'}

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.depth = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag in self.VOID:
            return
        if tag in self.SKIP:
            self.depth += 1
        elif self.depth == 0 and tag in self.BLOCK:
            self.parts.append('\n')

    def handle_startendtag(self, tag, attrs):
        return  # explicit self-closed (<img/>, <br/>) — never affects depth

    def handle_endtag(self, tag):
        if tag in self.VOID:
            return
        if tag in self.SKIP:
            self.depth = max(0, self.depth - 1)
        elif self.depth == 0 and tag in self.BLOCK:
            self.parts.append('\n')

    def handle_data(self, data):
        if self.depth == 0:
            text = data.strip()
            if text:
                self.parts.append(text + ' ')

    def get_text(self):
        combined = ''.join(self.parts)
        return re.sub(r'\n{3,}', '\n\n', combined).strip()


def clean_html(html_str):
    parser = HTMLCleaner()
    parser.feed(html_str)
    return parser.get_text()


def is_thin(content):
    nonws = re.sub(r'\s+', '', content)
    if len(nonws) < 500:
        return True
    jskws = ["enable javascript", "please enable", "you need to enable", "javascript required"]
    lower = content.lower()
    return any(kw in lower for kw in jskws)


def rewrite_github_blob(url):
    m = re.match(r'https://github\.com/([^/]+/[^/]+)/blob/(.+)', url)
    if m:
        return f"https://raw.githubusercontent.com/{m.group(1)}/{m.group(2)}"
    return url


manifest = []  # (label, url, archive_basename_or_None)

for i, src in enumerate(sources):
    label = src["label"]
    url = src["url"]                          # citation URL (shown in ## Sources)
    fetch_from = src.get("fetch_url", url)     # optional override for fetching (e.g. a Wayback mirror of a JS-walled page)
    base = f"{i+1:02d}-{re.sub(r'[^a-z0-9]+', '-', label.lower()).strip('-')[:50]}.md"
    out_file = os.path.join(archive_dir, base)
    raw_url = rewrite_github_blob(fetch_from)
    is_markdown = raw_url.endswith(".md") or "raw.githubusercontent.com" in raw_url

    print(f"  fetching [{i+1}/{len(sources)}] {label}")
    print(f"    url: {url}", flush=True)

    content = ""
    tier = "—"

    # Tier 1: curl + clean HTML + pandoc
    try:
        fetch = subprocess.run(
            ["curl", "-sL", "-A", "Mozilla/5.0 (compatible; falsehoods-builder)", "--max-time", "30",
             raw_url if is_markdown else fetch_from],
            capture_output=True, text=True, timeout=35
        )

        if fetch.returncode == 0 and fetch.stdout.strip():
            if is_markdown:
                content = fetch.stdout
                tier = "curl (raw markdown)"
            else:
                # Pre-clean HTML to strip nav/footer/script bloat, then pandoc
                cleaned_html = clean_html(fetch.stdout)
                if not is_thin(cleaned_html):
                    pandoc = subprocess.run(
                        ["pandoc", "-f", "markdown", "-t", "gfm", "--wrap=none"],
                        input=cleaned_html, capture_output=True, text=True, timeout=30
                    )
                    content = pandoc.stdout if pandoc.returncode == 0 else cleaned_html
                    tier = "curl+clean+pandoc"
    except Exception as e:
        print(f"    [tier1 error: {e}]", file=sys.stderr)

    if not content or is_thin(content):
        print(f"  ⚠  thin/failed fetch for: {label}  (tried: {fetch_from})", file=sys.stderr)
        print(f"  ⚠  try a Wayback mirror via \"fetch_url\" in topics.json, else PLAYWRIGHT", file=sys.stderr)
        content = f"[FETCH FAILED via curl/pandoc — model should skip this source's content: {url}]"
        tier = "failed"

    # Cap per-source size (for the synthesis packet only; the archive keeps the full text)
    packet_content = content
    if len(packet_content) > MAX_SOURCE_CHARS:
        packet_content = packet_content[:MAX_SOURCE_CHARS] + f"\n\n[...truncated at {MAX_SOURCE_CHARS} chars for packet size]"
        print(f"    ⚠ truncated to {MAX_SOURCE_CHARS} chars (packet only; archive keeps full text)")

    # Write the COMMITTED archive copy (attributed), but only for real fetches.
    if tier != "failed":
        with open(out_file, "w") as f:
            f.write(f"# {label}\n\n")
            f.write(f"> **Original:** <{url}>\n>\n")
            f.write(ARCHIVE_NOTE + "\n\n")
            f.write("---\n\n")
            f.write(content.strip() + "\n")
        manifest.append((label, url, base))
    else:
        manifest.append((label, url, None))

    print(f"    tier: {tier}  chars: {len(content)}")

    # Append to packet (gitignored scratch fed to the model)
    with open(packet_path, "a") as pf:
        pf.write(f"\n\n=== SOURCE {i+1}: {label} ===\n")
        pf.write(f"URL: {url}\n\n")
        pf.write(packet_content)
        pf.write("\n")

# Write the deterministic ## Sources section: original link + local archived copy.
with open(sources_section_path, "w") as sf:
    sf.write("\n## Sources\n\n")
    sf.write("Consolidated from the works below. Each is linked to its original and to a "
             "Markdown copy archived in this repo for preservation; please visit the originals.\n\n")
    for label, url, base in manifest:
        if base:
            sf.write(f"- [{label}]({url}) · [archived copy](../archive/{slug}/{base})\n")
        else:
            sf.write(f"- [{label}]({url})\n")

print("", flush=True)
PY

PACKET_SIZE=$(wc -c < "$PACKET" | tr -d ' ')
echo "  packet assembled: $PACKET ($PACKET_SIZE bytes)"
echo ""

if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "=== DRY RUN — first 60 lines of packet ==="
  head -60 "$PACKET"
  echo ""
  echo "(dry run complete — no API call made)"
  exit 0
fi

# --- Check if output exists ---
OUT_FILE="$TOPICS_DIR/$SLUG.md"
if [[ -f "$OUT_FILE" && "$FORCE" -eq 0 ]]; then
  echo "  $OUT_FILE already exists; use --force to overwrite"
  exit 0
fi

# --- Synthesis via agent ---
# Prompts live in prompts/ so they can be workshopped without touching this script.
# system.md = voice; <format>.md = structure + rules with {{TITLE}} {{HOOK}} {{SOURCE_COUNT}}.
SYSTEM_PROMPT=$(cat "$SYSTEM_FILE")
SYNTHESIS_PROMPT=$(SOURCE_COUNT="$SOURCE_COUNT" TITLE="$TITLE" HOOK="$HOOK" \
  python3 -c "import os,sys; t=open('$FORMAT_FILE').read(); print(t.replace('{{SOURCE_COUNT}}',os.environ['SOURCE_COUNT']).replace('{{TITLE}}',os.environ['TITLE']).replace('{{HOOK}}',os.environ['HOOK']))")

echo "=== Calling $MODEL for synthesis (format: $FORMAT) ==="
# Dense topics can produce long docs; give generous output headroom to avoid
# mid-sentence truncation (the model silently stops at the token ceiling).
RESULT=$(~/.claude/bin/agent "$MODEL" --file "$PACKET" --max-tokens 32000 --timeout 600 \
  --system "$SYSTEM_PROMPT" \
  "$SYNTHESIS_PROMPT")

mkdir -p "$TOPICS_DIR"
# Clean leading whitespace, and insert a jump-to-Sources link right under the
# hook (so readers see from the top that sources/credits exist). Deterministic,
# not model-written, so the #sources anchor is always correct.
CLEAN_RESULT=$(printf '%s' "$RESULT" | python3 -c "
import sys
lines = sys.stdin.read().lstrip().split('\n')
out, done = [], False
for l in lines:
    out.append(l)
    if not done and l.lstrip().startswith('>'):
        out.append('')
        out.append('**[Sources & credits ↓](#sources)**')
        done = True
print('\n'.join(out))
")
# Sources section was generated deterministically during fetch (original + archived copy links).
{
  echo "$CLEAN_RESULT"
  cat "$SOURCES_SECTION"
} > "$OUT_FILE"

echo "  written: $OUT_FILE ($(wc -c < "$OUT_FILE" | tr -d ' ') bytes)"

# Truncation guard: the model silently stops at the token ceiling, leaving the
# doc cut off mid-sentence with no final section. Flag it so you can rebuild
# with a higher --max-tokens or trimmed sources rather than ship a partial doc.
if ! grep -q "## If You Build This" "$OUT_FILE"; then
  echo ""
  echo "  ⚠ WARNING: '## If You Build This' section missing — output may be TRUNCATED."
  echo "    The doc likely hit the output token ceiling. Re-run with more headroom"
  echo "    (raise --max-tokens in this script) or fewer/smaller sources."
fi
echo ""
echo "Done. Review: topics/$SLUG.md"
