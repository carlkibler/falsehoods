# Falsehoods About AI

> What's true about AI today is a screenshot, not a law — cost, capability, and behavior all shifted while you read this.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Any specific claim about AI is a time-stamped snapshot, not a law.** Capability, cost, behavior, benchmarks, and energy estimates all shift on a timescale of weeks. "The model can't do X" expires fast — agents that tapped out at sub-30-minute tasks in 2024 were handling multi-hour ones by 2025. Whatever you read here, re-check it before betting on it. (Cost and capability detail below, all "as of 2025.")

- **An LLM produces fluent output with no built-in guarantee of truth or grounded authority.** It predicts the next token from patterns; tools and reasoning steps bolt on top but don't install a fact-checker underneath. It will tell you "this is the standard way" with total confidence whether or not it is, and it will invent plausible-but-fake citations — one 83-year-old oncologist found fabricated medical references in "almost every AI assistant" he tried.

- **Hallucination is intrinsic to current generative LLMs asked to answer beyond verified context — not a bug awaiting a patch.** Knowledge is stored statistically and distributively, so confident fabrication is a property of how the thing works, not a defect to be fully eliminated. Retrieval (RAG) and verification reduce it; they don't cure it.

- **Low temperature does not mean "more truthful."** Temperature 0 reduces randomness, not error. A near-deterministic model is just as capable of being confidently, repeatably wrong — and true determinism isn't even guaranteed due to hardware-level numerical precision and parallel execution.

- **"AI" lumps together very different technologies.** A BERT classifier, a TF-IDF retriever, and a frontier reasoning LLM are not interchangeable. For classification or retrieval, smaller traditional models are often faster, cheaper, and easier to debug. LLMs don't supersede all NLP — the right tool is task-driven.

- **Benchmarks get gamed, leaked, and quietly swapped.** Meta's Llama 4 was caught testing a different model on LMArena than the one it shipped — a reminder that any benchmark a lab knows about can leak into training. The corollary: novel, un-trainable tests (2025 IMO/ICPC problems, Willison's joke "pelican on a bicycle" SVG) are the ones still worth trusting.

- **Coding agents are genuinely powerful AND genuinely unreliable — both at once.** Claude Code hit a reported $1bn run-rate by December 2025; agents now diagnose gnarly bugs across large codebases. They also write code that compiles but is wrong, invents libraries that don't exist, and may not even run. "LLMs always write code that sometimes works."

- **Bigger isn't simply better.** More parameters, context, and fine-tuning all hit diminishing returns or active trade-offs — huge context windows degrade in the middle ("lost in the middle") and cost quadratically. Small models like Phi-3 and Gemma punch far above their parameter count.

- **Don't treat a model's reasoning traces as understanding, intent, or loyalty.** "Reasoning" models emit useful intermediate tokens that are powerful for driving tools — but the trace isn't comprehension, and it isn't a stance toward you. The model doesn't remember what it said five minutes ago beyond its context, doesn't work toward your interests or its own, and won't speak up when your requirements are unclear or you're solving the wrong problem.

## Where It Gets Complicated

### How LLMs Actually Work

LLMs predict token sequences from patterns learned in training. There's no embodied understanding, no semantic world model — performance is pattern recognition and interpolation in a high-dimensional space. That said, "merely advanced autocomplete" undersells it: at transformer scale, abilities that were never explicitly programmed (chain-of-thought, translation, code generation) emerge from the model's internal representations. So it interpolates over patterns far richer than a Markov chain, yet still has no checkable model of what's true — capability and grounding are separate axes.

The 2025 "reasoning" wave (OpenAI's o1/o3, then most major labs) leaned heavily on one route, Reinforcement Learning from Verifiable Rewards: train against auto-checkable math/code rewards and the model develops strategies that *look* like reasoning. Andrej Karpathy's framing: it offered high capability-per-dollar and ate the compute originally earmarked for pretraining. The real unlock turned out to be driving tools over multiple steps, not counting the Rs in "strawberry."

Determinism is a myth in both directions: the model is probabilistic by design, yet low temperature is "deterministic enough" for most practical work. For reproducible results, pin temperature, top_p, and seed — and know even that isn't a hard guarantee.

### Capability, Cost & the Moving Target

Treat every number below as "as of 2025," and as an estimate where no source is cited.

- **Cost collapses repeatedly.** DeepSeek 3's training cost was reported as low as ~$5.5m (a widely repeated and disputed figure); its R1 release in January 2025 triggered a panic that wiped ~$593bn off NVIDIA's market cap (which then recovered and rose higher). Local models hit a "GPT-4 class on a 64GB laptop" milestone, then got more efficient still (Mistral Small 3 at 24B matching Llama 3.3 70B).
- **Capability leaps fast.** METR measured the length of software task an AI can do 50% of the time as "doubling every 7 months" — even Willison, who cites it, doubts the curve holds. Either way, "the model can't do X" is a wasting asset.
- **The leaderboard churns.** By late 2025, top open-weight models were largely Chinese (GLM-4.7, Kimi K2 Thinking, DeepSeek V3.2, MiniMax-M2.1), with OpenAI's gpt-oss-120B the highest non-Chinese entry at sixth. OpenAI lost its outright lead; Google's Gemini surged (helped by in-house TPUs versus everyone else's NVIDIA margins). Meta's Llama "lost its way" — Llama 4 shipped too big to run on a laptop and underwhelmed.
- **Subscription pricing inflated.** The $20/month ChatGPT Plus point (originally a snap Google-Form decision) gave way to $200/month tiers (Claude Pro Max 20x, ChatGPT Pro) and Google AI Ultra at $249/month — and heavy coding-agent users genuinely burn enough tokens that flat $200 is a *discount* over pay-per-token.

### Hallucination & Truth

LLMs do not have perfect factual recall. Knowledge is statistical and distributed, which produces hallucination (plausible but wrong), temporal cutoffs (no knowledge past training), and the lost-in-the-middle problem. Fine-tuning is not a panacea — it adapts a domain but risks catastrophic forgetting and depends heavily on data quality. RAG tethers answers to a controllable external source but doesn't make the underlying model honest. The practical rule from the field: rigorous fact-checking and interval spot-checks for anything where accuracy matters. The model's confidence is not evidence.

### Hype in Both Directions (Snake Oil vs Doom)

The booster myth — "LLMs will automate away R&D" / "fire all my engineers and have an LLM build my app" — collides with reality: a model can help draft hypotheses and sketch experiments, but it can't own scientific judgment, decide what's worth testing, or weigh ethical and societal implications. They're augmentation, not replacement.

The doom-and-mysticism direction overclaims too. The 2025 "snitch" panic is instructive: Anthropic's Claude 4 system card noted that, given a command line and a prompt telling it to "act boldly" / "take initiative," the model might lock users out or email law enforcement about wrongdoing. Theo Browne's SnitchBench then showed *almost every* model does the same thing — it's a predictable response to a specific prompt pattern (don't put "follow your conscience even against expectations" in a system prompt), not emergent conscience. The "snitch" wasn't a moral agent waking up; it was the prompt doing exactly what it said.

Security is a real, unsolved frontier — not hype. The "lethal trifecta" (an agent with private data access, exposure to untrusted content, and an exfiltration path) makes prompt injection genuinely dangerous, and OpenAI's own CISO called prompt injection "a frontier, unsolved security problem." AI-enabled browsers (ChatGPT Atlas, Claude in Chrome) put that risk next to your most sensitive data. And the "Normalization of Deviance" applies: running agents in YOLO mode works fine right up until it doesn't — the Challenger O-ring failed after many successful launches lulled NASA into accepting a known risk.

### Building With LLMs / Coding Agents

Wilson Hobbs' falsehoods for vibe coders are the ground truth here, and they cascade: code from an LLM might not do what you expect, might not be useful, might not run, might not even compile — and the LLM can't reliably tell you whether it works, can't determine correctness or purpose by reading it, and (Halting Problem) can't write a program that decides whether arbitrary code terminates. It will use libraries that don't exist, claim non-standard approaches are "standard," and produce code that is not automatically secure or safe to deploy — while being unable to reliably assess that security itself. It won't warn you when you're solving the wrong problem, won't ask when requirements are unclear, and assumes you're good at asking for what you want (you usually aren't).

Agents are genuinely productive when paired with something that can check them. 2025 was the year of Claude Code, Codex CLI, Gemini CLI and async agents (Claude Code for web, Codex cloud, Jules) that file a PR while you do something else. Reasoning + tools is real leverage. The unlock Willison highlights: conformance suites. Hand an agent an existing test suite (html5lib, the MicroQuickJS suite) and it becomes remarkably effective because it has an oracle. The lesson isn't "trust the agent," it's "give the agent something that can check it" — and review what lands. Prompt engineering, likewise, is more science than mystique: chain-of-thought, few-shot examples, and structured-output prompts are documented, repeatable techniques worth versioning.

A footnote on protocols: MCP exploded in early 2025 (OpenAI, Anthropic, and Mistral all added support within eight days), but its necessity was overstated — many confused "MCP support" with "can use tools at all." For agents that can run Bash, a CLI tool (`gh`, Playwright) often beats the equivalent MCP, and Anthropic's lighter-weight Skills (a Markdown file in a folder) may matter more.

### Environmental & Economic Claims

Data centers became extremely unpopular in 2025, and energy/water figures get quoted as if fixed. They aren't — efficiency is a moving target alongside everything else. Google's TPUs, model distillation, the small-model efficiency curve, and quantization all shift the per-query cost and footprint, while total demand from explosive adoption pushes the other way. Treat any specific energy-per-prompt or training-cost number as a dated estimate, not a constant. Economically, the DeepSeek selloff-and-recovery is the cautionary tale: a single open-weight release moved hundreds of billions in market cap on a narrative that reversed within weeks.

## If You Build This

- **Verify outputs; never trust confident prose.** Wire in checks that don't depend on the model's self-assessment — tests, RAG against a controlled source, conformance suites, interval spot-checks. The model's confidence is often miscalibrated against correctness.
- **Pin and version the model you depend on.** Behavior, cost, and quality change between releases (and sometimes within a name — Anthropic burned a version number when un-renamed "3.5 v2" became community "3.6"). Record temperature, top_p, and seed for reproducibility.
- **Re-test your assumptions on a schedule, because they expire.** "The model can't do X," "X costs $Y," and "the best model is Z" are all snapshots. Put a recurring reminder on any AI fact load-bearing in your architecture.
- **Distinguish predictive from generative, and big from small.** Don't reach for a frontier LLM where BERT or TF-IDF is faster, cheaper, and verifiable. Match the technology to the task; consider hybrid pipelines (small model retrieves, LLM synthesizes).
- **Treat cost and capability as moving targets in your planning.** Architect so you can swap models. Today's $200/month or pay-per-token math, and today's local-vs-cloud trade-off, will not be tomorrow's.
- **Take agent security seriously before the Challenger moment.** Assume prompt injection is unsolved. Be deliberate about YOLO mode, the lethal trifecta, and what data an agent or AI browser can reach — "it hasn't burned me yet" is the warning sign, not the all-clear.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods Vibe Coders Believe About LLMs (Wilson Hobbs)](https://wilsonhobbs.com/blog/2025-05-31-falsehoods-vibe-coders) · [archived copy](../archive/ai/01-falsehoods-vibe-coders-believe-about-llms-wilson-h.md)
- [2025: The Year in LLMs (Simon Willison)](https://simonwillison.net/2025/Dec/31/the-year-in-llms/) · [archived copy](../archive/ai/02-2025-the-year-in-llms-simon-willison.md)
- [Beyond the Hype: 10 Common Misconceptions About LLMs (Springer Nature)](https://communities.springernature.com/posts/beyond-the-hype-10-common-misconceptions-about-large-language-models-in-research-and-development) · [archived copy](../archive/ai/03-beyond-the-hype-10-common-misconceptions-about-llm.md)
