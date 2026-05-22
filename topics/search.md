# Falsehoods About Search

> Search is not SELECT … LIKE '%query%'.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Search engines work like databases.** They don't. A database matches rows; a search engine tokenizes, analyzes, ranks, and guesses intent. `WHERE title LIKE '%foo%'` will never give you relevance, stemming, or "did you mean?"
- **`C programming` and `C++ programming` produce different results.** Often they don't — the default tokenizer throws away the `++`, so both queries collapse to `c programming`. Punctuation is meaning, and most analyzers eat it for breakfast.
- **`401k` and `401(k)` produce the same results.** Same trap: the parentheses change tokenization, so two strings a human reads as identical become two completely different tokens to your index.
- **Customers notice their own misspellings.** They don't — and they fully expect *you* to fix them. Worse: a misspelled word is sometimes a different correctly-spelled word, so "correction" can quietly break a valid query.
- **You can pass the customer query directly into your search engine.** Until someone pastes a whole document into the search bar, leaves a quote unbalanced, types `OR` meaning Oregon, or tries to inject an attack through the box. Every query is hostile input.
- **The default settings will deliver a good search experience.** Out-of-the-box tokenization, stop words, and ranking are a starting point, not a destination. They are right for *someone's* corpus — almost never yours.
- **You can build a search that works like Google.** You can't, you shouldn't target it, and customers will compare you to it anyway. One bad result — minor and rare — still reflects on your whole product.
- **Once set up, search works the same way forever.** Not forever, not for a while, not even for the next week. Content drifts, language changes, and lemmatization dictionaries go stale.

## Where It Gets Complicated

### Tokenization & Analysis

Tokenization — how text gets chopped into searchable units — is where most "obvious" assumptions die.

- The out-of-the-box tokenizer is **not** right for your content and queries by default.
- You can't tune one tokenizer to satisfy your *entire* corpus and *all* queries — or even *most* of them. There's always a trade-off that hurts some documents to help others.
- Tokenization can't be cleanly made conditional, and **you should not roll your own tokenizer** — it's a deep, well-trodden problem you will get wrong.
- You *will* have a debate about tokenization. It is not a settled question on any real team.
- **Regular expressions for tokenization are not a good idea**, do not have minimal performance impact, and will trigger their own arguments.
- Case sensitivity feels easy ("just lowercase everything") but making *certain* things case sensitive selectively is hard, and broad case sensitivity is usually a bad idea.

### Relevance & Ranking

Returning matches is easy; returning the *right* matches in the *right order* is the entire job. And when you finally show perfect results, customers won't necessarily notice — or reliably click the thing they wanted. You also can't assume the logs will tell you whether they found it: you have to monitor queries, results, and clicks together, and that logging touches privacy nerves and GDPR. A search should arguably always return *something*, however absurd; empty result pages frustrate users, and "they won't mind zero results" is false.

The fancier remedies are no shortcut either:

- **Personalized search is not easy.** Neither is learning-to-rank: it is not "just install a plugin," you probably don't have enough training data, and you may never curate enough over time.
- **Facets**: Google not using them doesn't mean your customers don't need them. Facet hit counts aren't always correct, facets *do* cost performance, and you can't just cache queries to make them fast.

### Language, Stemming & Synonyms

Human language refuses to be a clean key-value lookup.

- **Stop words**: you should remove them; you should *not* remove them; you don't actually know what the right list is; and the list changes over time. (And `in` isn't always a stop word — sometimes it's Indiana.) The wrong list silently drops meaning some of your users were counting on.
- **Synonyms** are not easy. They don't always improve recall the way you want, they don't carry the same relevance across all documents, and acronym/abbreviation synonyms misbehave. Extracting them from your corpus with NLP — or with Word2Vec — is not the free win it sounds like.
- **Stemming will not solve your recall problems.** Neither will lemmatization — and lemmatization dictionaries are not static, because languages change.
- **NLP tools do not work perfectly**, and folding them into your analysis pipeline is not straightforward. Search queries are usually *not* complete sentences, so part-of-speech tagging on them is unreliable.
- **Suggestions / autocomplete** are not easy: out-of-the-box engine suggestions aren't enough, and incorporating customer query logs is necessary but messy (and exposes you to whatever offensive or malicious things people type).

### Exact vs. Fuzzy & Query Parsing

The gap between what users type and what they mean is enormous.

- Customers don't always know what they're looking for — and when they do, they won't search for it the way you expect.
- They don't search for "just a few terms." They paste paragraphs. They leave quotes and parentheses unbalanced — and still expect phrasing and grouping to work.
- The same query run twice can legitimately be expected to return *different* results (freshness, personalization, context).
- **You cannot write a query parser that always succeeds**, you *will* have to surface parse errors to users, and `OR` does not always mean the boolean operator (sometimes it's Oregon).
- **Spelling correction**: you can't enumerate all misspellings or write one algorithm to handle them all. Not all customers want corrections, and they don't all expect correction to behave the same way.
- **Highlighting** matters — customers rely on it to see *why* a result matched. Default highlighters aren't good enough for all content, and a "custom highlighter is just string matching" right up until it costs you the better part of a year.

### Content, Scale & Latency

What you index is as much a problem as how you query it.

- **Content is not well formed** — not mostly, not predictably. Text-extraction engines produce text that needs post-processing, markup doesn't strip the way you expect, and database-plus-template content isn't shaped consistently.
- Formatting content for the engine is real, ongoing work. Content teams do **not** treat search as their top priority, manually improving content for search isn't easy, and automating those improvements isn't cheap.
- **Caching will not solve your performance problems** — it's a patch over a design, not a fix.
- Customers **do** expect near-real-time updates. A 30-second commit time is not short enough for everyone.
- Search is **not** a feature like any other. It cannot be added well, quickly, *or* with reasonable effort — and choosing the "right" engine is neither easy nor a decision you'll stay happy with.

## If You Build This

- **Use a real search engine.** Elasticsearch, OpenSearch, Solr, Vespa — purpose-built for tokenization, ranking, and analysis. `LIKE '%query%'` is not search; it's a substring match wearing a search costume.
- **Invest in analysis and tokenization early.** This is where `C++`, `401(k)`, casing, and stop words live or die. Don't roll your own tokenizer, and treat the default analyzer as a hypothesis to test against your real corpus and real queries.
- **Measure relevance with real data.** Log queries, results, and clicks (lawfully and with privacy in mind) so you can tell good search from bad — instead of guessing. You can't improve what you don't observe.
- **Treat every query as hostile input.** Pasted documents, unbalanced quotes, injection attempts, offensive terms, ambiguous tokens like `OR`. Parse defensively and be ready to fail gracefully with a useful message.
- **Plan for content as an ongoing program, not a one-time import.** Content is messy and drifts; budget for extraction post-processing, formatting, and continuous re-tuning. Search is never "set up and done."
- **Set expectations against Google honestly.** You won't match it and shouldn't target it, but users will compare you to it regardless — so focus on relevance, freshness, suggestions, and highlighting where they matter most for *your* users.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Search (OpenSource Connections)](https://opensourceconnections.com/blog/2019/05/29/falsehoods-programmers-believe-about-search/) · [archived copy](../archive/search/01-falsehoods-about-search-opensource-connections.md)
