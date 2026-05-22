# Falsehoods About Pagination

> Page 2 is not simply the rows after page 1.

## The Big Surprises

- **The number of items on a page is fixed for all time.** It isn't. You ship a "20 per page" UI, then product asks for 50, or adds an "items per page" selector, or a mobile client requests 10. Any pagination scheme that hard-codes a page size will outlive that assumption.
- **The number of items per page is the same for every user.** Different clients, different preferences, different screen sizes. One user's page 3 covers rows 41–60; another's covers rows 21–30. "Page N" is meaningless without knowing whose page it is.
- **The page size is fixed for one result set.** Even a single user paging through one query can change page size mid-stream — resize the window, toggle "show more." Page 1 had 20 rows; page 2 now wants 50. Offset arithmetic that assumed a constant size silently skips or repeats rows.
- **Nobody pages backwards.** People hit "Previous," jump to the last page, then scroll back up. If your cursor or token only knows how to move forward, half your navigation is broken.
- **No item will be added to the result set while you're paging through it.** Someone inserts a row that sorts before your current position, everything shifts down by one, and the row that was last on page 1 reappears as the first row of page 2. The user sees a duplicate and assumes a bug.
- **No item will be removed while you're paging.** A delete (or a row that no longer matches the filter) shifts everything *up* by one, so the first row of page 2 quietly slides onto the end of page 1 — which the user already passed. They never see it. Offset pagination loses rows just by existing in a live dataset.
- **The sort order is stable.** `ORDER BY created_at` over a column with ties has no defined tiebreak; the database is free to return equal rows in a different order on each query. Page boundaries land in different places run to run, so the same row can appear on two pages or none.
- **Only one page is ever fetched at a time, in order, promptly.** Tabs, prefetching, retries, and slow networks all break this. Page 3 can arrive before page 2; "page 2" requested now may be served from a dataset that's minutes newer than the page 1 the user is still looking at.
- **It's fine for two users to see different pagination of the same items at the same time.** Sometimes it genuinely is — but if they're collaborating ("look at the third one on page 2"), divergent pagination turns into a confusing, irreproducible support ticket. (Falsehood contributed by @ronburk.)

## Where It Gets Complicated

### Page size is not a constant

Three separate assumptions all fail here, and they compound:

- **Across time:** the configured page size changes between releases. Bookmarked or cached "page 5" links point at different rows after the change.
- **Across users:** clients negotiate their own page sizes. There is no global "page 5"; there's only "page 5 *for this request*."
- **Within one result set:** the same user can change page size while paging. If you compute the offset as `page × size`, a mid-stream size change makes the offset land in the wrong place — skipping a band of rows or re-showing ones already seen.

The deeper problem: "page number" is a derived, lossy coordinate. It only means something when combined with a size, and the size is not yours to assume.

### Offset/limit is unstable under concurrent writes

`LIMIT 20 OFFSET 20` says "skip 20 rows, give me the next 20" — evaluated *fresh* each time, against whatever the data looks like at that moment. Between fetching page 1 and page 2:

- **An insert before your position** pushes every later row down by one. The last row of page 1 now sits at offset 20 — the first slot of page 2. The user sees it twice.
- **A delete before your position** pulls every later row up by one. The row that *would* have been the first of page 2 is now the last of page 1, which the user already scrolled past. It's silently skipped — never rendered on any page.

Offset pagination guarantees correctness only against a frozen snapshot. Real databases under real traffic are not frozen, so the failure mode isn't "rare race condition" — it's the steady state for any actively-written dataset.

### Ordering must be stable and total

Pagination assumes a single, consistent ordering across every page request. That requires the sort to be both stable and *total* (no ties):

- `ORDER BY created_at` where two rows share a timestamp has no defined order between them. The engine may break the tie differently on each call, so the boundary between page 1 and page 2 shifts, duplicating or dropping the tied rows.
- The fix is to order by something with a unique tiebreaker, e.g. `ORDER BY created_at, id`. Now every row has exactly one position and page boundaries are reproducible.

Without a total order, even a static dataset can paginate inconsistently — no concurrent writes required.

### Pages aren't fetched one-at-a-time, in order, or quickly

The naive model is a single client walking forward, page by page, each request close behind the last. Reality:

- **Concurrency:** multiple tabs or prefetchers request several pages at once, against a moving dataset. Each page is a snapshot from a slightly different instant.
- **Out of order:** page 3 may be requested or arrive before page 2 (prefetch, user jumping around, retries).
- **Backwards:** "Previous" and "jump to last page" mean navigation isn't monotonic forward.
- **Slow:** a request can sit for seconds or minutes (slow network, backgrounded tab). By the time "page 2" is served, the underlying data has drifted well past the "page 1" still on screen, widening the duplicate/skip window dramatically.

### Total counts and shared views are lies-in-waiting

- **"Showing 1–20 of 1,482"** assumes the total is stable for the life of the paging session. Insert and delete activity moves it constantly; on a busy table the count is stale the instant you compute it, and computing it accurately can be expensive.
- **Two users, same query, same moment** may legitimately see different pages — different sizes, different timing relative to a write. Fine in isolation, painful when they're coordinating off page/position references, because the shared coordinate doesn't actually point at the same row.

## If You Build This

- **Prefer keyset (cursor) pagination over offset/limit.** Instead of "skip N rows," carry the last row's sort key and ask for "rows after this key." Inserts and deletes elsewhere in the set no longer shift your position, so you stop silently duplicating or dropping rows.
- **Order by a stable, total key.** Append a unique tiebreaker (e.g. `ORDER BY created_at, id`) so every row has exactly one position and page boundaries are reproducible across requests.
- **Make the cursor work both directions.** Support forward and backward navigation explicitly; don't assume users only ever click "Next."
- **Don't trust total counts.** Treat "of N" as approximate on live data, or omit it. If you must show one, decide whether a stale or expensive count is acceptable, and don't let pagination correctness depend on it.
- **Don't bake page size into the protocol.** Let the client request a size per page, tolerate it changing between requests, and never compute correctness from `page × size` against a moving dataset.
- **Assume the data moves between page fetches.** Design for concurrent inserts/deletes, out-of-order and delayed requests, and parallel clients as the normal case — not as rare races to patch later.


## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Pagination (Matt Palmer)](https://www.hezmatt.org/~mpalmer/blog/2018/12/12/falsehoods-programmers-believe-about-pagination.html) · [archived copy](../archive/pagination/01-falsehoods-about-pagination-matt-palmer.md)
