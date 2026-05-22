#!/usr/bin/env bash
# build-topic.sh <slug> [--dry-run] [--model MODEL] [--force]
# Fetches sources for a topic, synthesizes via agent, writes topics/<slug>.md
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOPICS_JSON="$ROOT/topics.json"
TOPICS_DIR="$ROOT/topics"
SOURCES_DIR="$ROOT/sources"

SLUG=""
DRY_RUN=0
FORCE=0
MODEL="kimi-2.6"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)  DRY_RUN=1; shift ;;
    --force)    FORCE=1; shift ;;
    --model)    MODEL="$2"; shift 2 ;;
    --model=*)  MODEL="${1#*=}"; shift ;;
    -*)         echo "Unknown option: $1" >&2; exit 2 ;;
    *)          SLUG="$1"; shift ;;
  esac
done

if [[ -z "$SLUG" ]]; then
  echo "Usage: build-topic.sh <slug> [--dry-run] [--model MODEL] [--force]" >&2
  echo "Available slugs: $(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(', '.join(d.keys()))")" >&2
  exit 1
fi

# --- Load topic metadata ---
TITLE=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(d['$SLUG']['title'])")
HOOK=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(d['$SLUG']['hook'])")
SOURCE_COUNT=$(python3 -c "import json; d=json.load(open('$TOPICS_JSON')); print(len(d['$SLUG']['sources']))")

echo "=== Building: $TITLE ==="
echo "    hook: $HOOK"
echo "    sources: $SOURCE_COUNT"
echo "    model: $MODEL"
echo ""

# --- Fetch sources ---
TOPIC_SOURCES_DIR="$SOURCES_DIR/$SLUG"
mkdir -p "$TOPIC_SOURCES_DIR"
PACKET="$TOPIC_SOURCES_DIR/_packet.md"

{
  echo "# SOURCE PACKET: $TITLE"
  echo "# Hook: $HOOK"
  echo "# Sources: $SOURCE_COUNT"
  echo ""
} > "$PACKET"

python3 - "$TOPICS_JSON" "$SLUG" "$TOPIC_SOURCES_DIR" "$PACKET" <<'PY'
import json, sys, subprocess, os, re
from html.parser import HTMLParser

topics_json, slug, sources_dir, packet_path = sys.argv[1:]
with open(topics_json) as f:
    topic = json.load(f)[slug]

sources = topic["sources"]
MAX_SOURCE_CHARS = 40000  # ~10k tokens each; enough for any blog post

class HTMLCleaner(HTMLParser):
    """Strip nav/footer/script/style bloat; keep article prose."""
    SKIP = {'script','style','nav','header','footer','aside','noscript','form','button','select','option','iframe','svg','figure','figcaption','img'}
    BLOCK = {'p','li','h1','h2','h3','h4','h5','h6','article','section','main','blockquote','pre','code','dt','dd','th','td'}

    def __init__(self):
        super().__init__()
        self.depth = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag in self.SKIP:
            self.depth += 1
        elif self.depth == 0 and tag in self.BLOCK:
            self.parts.append('\n')

    def handle_endtag(self, tag):
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


for i, src in enumerate(sources):
    label = src["label"]
    url = src["url"]
    out_file = os.path.join(sources_dir, f"{i+1:02d}-{re.sub(r'[^a-z0-9]+', '-', label.lower())[:50]}.md")
    raw_url = rewrite_github_blob(url)
    is_markdown = raw_url.endswith(".md") or "raw.githubusercontent.com" in raw_url

    print(f"  fetching [{i+1}/{len(sources)}] {label}")
    print(f"    url: {url}", flush=True)

    content = ""
    tier = "—"

    # Tier 1: curl + clean HTML + pandoc
    try:
        fetch = subprocess.run(
            ["curl", "-sL", "-A", "Mozilla/5.0 (compatible; falsehoods-builder)", "--max-time", "30",
             raw_url if is_markdown else url],
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
        print(f"  ⚠  thin/failed fetch for: {label}", file=sys.stderr)
        print(f"  ⚠  PLAYWRIGHT NEEDED: {url}", file=sys.stderr)
        content = f"[FETCH FAILED via curl/pandoc — model should note this source URL but skip its content: {url}]"
        tier = "failed"

    # Cap per-source size
    if len(content) > MAX_SOURCE_CHARS:
        content = content[:MAX_SOURCE_CHARS] + f"\n\n[...truncated at {MAX_SOURCE_CHARS} chars for packet size]"
        print(f"    ⚠ truncated to {MAX_SOURCE_CHARS} chars")

    with open(out_file, "w") as f:
        f.write(content)

    print(f"    tier: {tier}  chars: {len(content)}")

    # Append to packet
    with open(packet_path, "a") as pf:
        pf.write(f"\n\n=== SOURCE {i+1}: {label} ===\n")
        pf.write(f"URL: {url}\n\n")
        pf.write(content)
        pf.write("\n")

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
SYSTEM_PROMPT="You are a technical writer producing a single clean reference document. Follow the structure below exactly. Be concrete: keep specific examples, real names, real edge-cases, real numbers. Lead with the most surprising, jaw-dropping falsehoods. Be approachable and readable — this is for engineers who will share it. No preamble, no closing remarks. Do NOT write a Sources or References section — that will be appended separately."

SYNTHESIS_PROMPT="You have been given $(echo "$SOURCE_COUNT") sources on the topic: $TITLE.

Synthesize ALL of them into ONE clean, complete markdown document using EXACTLY this structure:

# $TITLE

> $HOOK

## The Big Surprises
List 6–10 of the most jaw-dropping, counterintuitive falsehoods as punchy bullet points. These are the headline 'oh my gosh' moments — the ones that make someone say 'I had no idea'.

## Where It Gets Complicated
Group the long tail of subtler falsehoods into named sub-sections (### headings). For each point include a brief explanation and at least one concrete example (real person names, real places, real edge-cases from the sources). Deduplicate across sources — if multiple sources cover the same point, keep the most vivid explanation and example. Cover every significant point from every source.

## If You Build This
3–6 practical takeaways: what to actually do, what library/standard to use, what assumptions to never make.

Rules:
- Merge and deduplicate across all sources — produce ONE document, not 4 summaries stapled together.
- Preserve concrete examples: if a source mentions 'Björk' or 'Mr. Null' or 'King of Tokyo' or a W3C script example, keep it.
- Do NOT write a Sources or References section.
- No preamble, no closing remarks. Start directly with the # heading."

echo "=== Calling $MODEL for synthesis ==="
RESULT=$(~/.claude/bin/agent "$MODEL" --file "$PACKET" --max-tokens 16000 --timeout 600 \
  --system "$SYSTEM_PROMPT" \
  "$SYNTHESIS_PROMPT")

# --- Append deterministic Sources section ---
SOURCES_MD=$(python3 - "$TOPICS_JSON" "$SLUG" <<'PY'
import json, sys
topics_json, slug = sys.argv[1:]
with open(topics_json) as f:
    topic = json.load(f)[slug]
print("\n## Sources\n")
for src in topic["sources"]:
    print(f"- [{src['label']}]({src['url']})")
PY
)

mkdir -p "$TOPICS_DIR"
{
  echo "$RESULT"
  echo "$SOURCES_MD"
} > "$OUT_FILE"

echo "  written: $OUT_FILE ($(wc -c < "$OUT_FILE" | tr -d ' ') bytes)"
echo ""
echo "Done. Review: topics/$SLUG.md"
