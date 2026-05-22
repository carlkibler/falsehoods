#!/usr/bin/env bash
# build-all.sh [--dry-run] [--force] [--model MODEL] [--format FMT]
# Runs build-topic.sh for every slug in topics.json.
# Without --force, skips topics whose topics/<slug>.md already exists.
# Passes --dry-run / --model / --format straight through.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TOPICS_JSON="$ROOT/topics.json"
TOPICS_DIR="$ROOT/topics"

PASS_ARGS=()
DRY_RUN=0
FORCE=0
for a in "$@"; do
  case "$a" in
    --dry-run) DRY_RUN=1; PASS_ARGS+=("$a") ;;
    --force)   FORCE=1 ;;  # handled here (per-file skip), not passed through
    *)         PASS_ARGS+=("$a") ;;
  esac
done

mapfile -t SLUGS < <(python3 -c "import json; print('\n'.join(json.load(open('$TOPICS_JSON')).keys()))")

built=0; skipped=0; warned=0; failed=0
WARN_LIST=()

for slug in "${SLUGS[@]}"; do
  if [[ "$FORCE" -eq 0 && "$DRY_RUN" -eq 0 && -f "$TOPICS_DIR/$slug.md" ]]; then
    echo "··· skip $slug (exists)"
    skipped=$((skipped+1))
    continue
  fi
  echo ""
  echo "==================== $slug ===================="
  extra=()
  [[ "$FORCE" -eq 1 ]] && extra+=("--force")
  if out=$("$SCRIPT_DIR/build-topic.sh" "$slug" "${PASS_ARGS[@]}" "${extra[@]}" 2>&1); then
    echo "$out" | grep -E 'tier:|thin/failed|packet assembled|written:|WARNING' || true
    if echo "$out" | grep -q "WARNING"; then warned=$((warned+1)); WARN_LIST+=("$slug (truncated?)"); fi
    if echo "$out" | grep -q "thin/failed"; then WARN_LIST+=("$slug (fetch gap)"); fi
    built=$((built+1))
  else
    echo "$out" | tail -5
    echo "!!! FAILED: $slug"
    failed=$((failed+1))
  fi
done

echo ""
echo "================================================"
echo "build-all done: built=$built skipped=$skipped failed=$failed truncation-warnings=$warned"
if [[ ${#WARN_LIST[@]} -gt 0 ]]; then
  echo "Needs attention:"
  printf '  - %s\n' "${WARN_LIST[@]}"
fi
