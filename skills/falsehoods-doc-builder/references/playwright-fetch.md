# Playwright fallback — rescuing a JS-rendered source

When `build-topic.sh <slug> --dry-run` prints `⚠ PLAYWRIGHT NEEDED <url>` on stderr, `curl` received a near-empty HTML shell because the page builds its content with JavaScript (common with modern blog CMSes, Cloudflare interstitials, and SPA-based sites). The cheap model and `curl` both lack a JS engine, so the orchestrator (you) fetches it with the Playwright MCP.

This is the **only** step where source page text legitimately enters your context. Reserve it for sources actually worth the cost — a doc built from 3 of 4 sources is usually still excellent, and any skipped source remains credited in the `## Sources` list.

## Procedure

1. Identify the failed source file: `sources/<slug>/NN-<label>.md`. After a fetch attempt it contains a `[FETCH FAILED …]` placeholder.

2. Navigate and extract with the Playwright MCP:
   - `mcp__plugin_playwright_playwright__browser_navigate` → the URL.
   - `mcp__plugin_playwright_playwright__browser_evaluate` with a function that returns the article text, e.g.:
     ```js
     () => (document.querySelector('article, main, .post-content, .entry-content') || document.body).innerText
     ```
   - Prefer `innerText` of the narrowest article container to avoid nav/footer cruft. If the page is paginated or lazy-loads, scroll/evaluate again as needed.

3. Write the extracted text over the failed source file:
   ```
   sources/<slug>/NN-<label>.md
   ```
   Keep it plain text/markdown; strip obvious nav and comment-section noise if it slipped in.

4. Rebuild the packet and doc. The simplest reliable path is to re-run the build — but that re-fetches and would re-fail the JS source, overwriting your rescue. So instead, **re-assemble the packet manually** or temporarily point the topic's source at a working mirror (e.g. a `web.archive.org` snapshot URL in `topics.json`, which often *does* serve static HTML that `curl|pandoc` handles). The archive route is usually less effort than scripting around the rebuild:

   - In `topics.json`, swap the source `url` to its Wayback snapshot: `https://web.archive.org/web/<timestamp>/<original-url>` (or use `https://web.archive.org/web/2024/<original-url>` to let the Wayback Machine pick a capture).
   - `scripts/build-topic.sh <slug> --force` — the archived page typically fetches cleanly via Tier 1, no Playwright needed.

   Keep the *original* URL in the doc's `## Sources` by leaving the human-readable `label` intact; if you want the citation to point at the live page rather than the archive, set the source back after a successful build (the cached `sources/<slug>/` packet persists, so a subsequent build without `--force` won't refetch).

## Rule of thumb

Try the Wayback snapshot in `topics.json` *first* — it's a one-line edit and keeps everything inside the cheap `curl|pandoc` path. Fall back to live Playwright extraction only when no usable archive exists.
