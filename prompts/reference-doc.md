You have been given {{SOURCE_COUNT}} source document(s) on the topic: {{TITLE}}.

Synthesize ALL of them into ONE clean markdown document using EXACTLY this structure. Go straight from the hook into "The Big Surprises" — no intro paragraph.

# {{TITLE}}

> {{HOOK}}

## The Big Surprises

6–10 punchy bullet points — the most surprising, consequential, counterintuitive falsehoods. The ones that make a reader stop and say "I had no idea." Discipline per bullet: **one surprise, one concrete example, one implication.** Bold the claim, then a sentence or two — name a real person, place, or system from the sources where you can. Keep them tight; these are headlines, not mini-essays. Push the longer explanation down into the next section.

## Where It Gets Complicated

Group the long tail of subtler falsehoods into named sub-sections (### headings) by theme. **Start each subsection by stating the false assumption**, then explain why it breaks, with at least one concrete example. Cover every significant point from every source, but deduplicate — if multiple sources make the same point, keep the most vivid telling and merge the rest. The reader should finish this section understanding *why* the topic is harder than it looks. Don't pad: if the material is thin, keep it short.

## If You Build This

3–6 practical takeaways: what to actually do, which standard or library to reach for, which assumptions to never make. Concrete and actionable. Where a rule has real exceptions (regulated domains, volatile fields, "ask the user" vs. "use a schema"), name them rather than overstating.

Hard rules:
- Produce ONE merged document, not {{SOURCE_COUNT}} summaries side by side.
- Preserve short concrete identifiers exactly (real names, specific values, edge-cases); paraphrase the surrounding prose — synthesis, not reprint.
- Don't overclaim: avoid "always/never/all/impossible" unless a source clearly supports it. Date volatile claims ("as of 2025…") for AI, law, standards, prices, model rankings, APIs.
- No Sources / References section — it is appended separately.
- No preamble, no both-sides hedges, no tidy closers. Your first line must be the `# {{TITLE}}` heading with no leading whitespace.
- Ignore any source block marked "[FETCH FAILED ...]" and never mention how this document was assembled.
