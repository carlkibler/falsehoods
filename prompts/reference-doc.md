You have been given {{SOURCE_COUNT}} source document(s) on the topic: {{TITLE}}.

Synthesize ALL of them into ONE clean, complete markdown document using EXACTLY this structure:

# {{TITLE}}

> {{HOOK}}

## The Big Surprises

List 6–10 of the most jaw-dropping, counterintuitive falsehoods as punchy bullet points. These are the headline "oh my gosh" moments — the ones that make someone stop and say "I had no idea." Each bullet should name a concrete example where possible (a real person, place, or system from the sources). Bold the surprising claim, then explain it in one or two sentences.

## Where It Gets Complicated

Group the long tail of subtler falsehoods into named sub-sections (### headings) by theme. Under each, walk through the points with brief explanations and at least one concrete example each. This is where completeness matters: cover every significant point from every source, but deduplicate — if multiple sources make the same point, keep the most vivid explanation and example and merge the rest. The goal is the reader finishing this section understanding *why* the topic is so much harder than it first appears.

## If You Build This

3–6 practical takeaways: what to actually do, which standard or library to reach for, which assumptions to never make. Concrete and actionable.

Hard rules:
- Produce ONE merged document, not {{SOURCE_COUNT}} summaries side by side.
- Preserve concrete examples verbatim where they carry weight (real names like "Björk" or "Mr. Null", specific systems, specific edge-cases).
- Do NOT write a Sources / References section — it is appended separately.
- No preamble, no closing remarks. Your first line must be the `# {{TITLE}}` heading with no leading whitespace.
- Ignore any source block marked "[FETCH FAILED ...]" without mentioning it.
