# Falsehoods About Event-Driven Systems

> Messages arrive once, in order, exactly as sent — and other comforting lies.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Events arrive in order.** Even with a single consumer, even when the producer's contract promises ordering, the messages your handler sees may be shuffled. A retry on message #2 can land it after message #3 has already been processed.
- **Events arrive exactly once.** They don't. Most real systems give you at-least-once, which means "once, plus sometimes again." Even an at-most-once queue can hand you a duplicate when a network blip causes a redelivery before the ack registers.
- **De-duplication on arrival makes duplicates go away.** A dedup window has a length, and your duplicate can show up after it closes — say a redelivery that arrives days later, long after the dedup cache forgot the first one.
- **An idempotency key makes your handler idempotent.** The key is a hint; idempotency is a property of your code. Two requests can carry the same key with *different* payloads, and now you have to decide which lie to believe.
- **Low-traffic systems don't get backed up.** A system doing 2 messages a minute can still build a backlog or get throttled — a slow downstream dependency or a sudden burst doesn't care about your average TPS.
- **A processing timeout of N seconds/minutes/hours is enough.** Whatever N you pick, some event will take N+1. Timeouts that are "obviously generous" are the ones that page you at 3am.
- **You can always order events.** Some events simply have no total order — concurrent events from different producers with clock skew may be genuinely unorderable, and a timestamp is not a tiebreaker you can trust.
- **The dead letter queue will hold a handful of events in a few neat categories.** When something breaks upstream, the DLQ fills with thousands of events spanning dozens of error shapes that resist easy sorting.
- **Recovery takes minutes.** Manual recovery can take days, will probably require editing events or asking the producer to regenerate them, and has a habit of coinciding with a second failure.

## Where It Gets Complicated

### Delivery guarantees

"Exactly-once" is mostly marketing for "at-least-once plus idempotency." Plan for duplicates as the normal case, not the exception.

- Events won't be duplicated — they will.
- Events won't be duplicated, even in at-most-once delivery queues — at-most-once reduces duplicates, it doesn't forbid them under the failure modes that actually happen.
- Events won't be duplicated, even if the producer contract says so — a contract is a promise, not an enforcement mechanism.
- Events won't be duplicated, even with de-duplication upon arrival — dedup operates over a bounded window; a late redelivery escapes it.
- Events will never be dropped — between producer bugs, consumer crashes, and misconfigured retries, some will be.

### Ordering

Ordering assumptions are where confident designs go to die. Each of these feels safe and isn't:

- Events will arrive in order.
- ...even with a single consumer (retries and partial failures reorder work).
- ...even if specified by the producer contract.
- ...even with days between messages (a delayed redelivery slots in wherever it lands).
- Events can always be ordered — some sets of events have no meaningful total order at all.

### Duplication & idempotency

The idempotency key is the most over-trusted object in event-driven systems. It's necessary but nowhere near sufficient.

- Adding an idempotency key ensures idempotency — it doesn't; your handler still has to *do* something idempotent with it.
- Equal idempotency keys mean identical payloads — two messages can share a key and carry conflicting bodies.
- An event timestamp is a valid idempotency key — timestamps collide, drift, and repeat across producers.
- Writing idempotent code is easy — it's one of the harder things to get right, especially across a write to a non-idempotent downstream.
- Maintaining and improving idempotent code is easy — every new branch and side effect is a fresh chance to break the property.
- Idempotency can be solved with a distributed lock plus an idempotency key — locks add their own failure modes (expiry, partitions, the holder dying mid-operation) and don't make the underlying work idempotent.
- Consumer downstream dependencies support idempotent calls — many don't, and that's where the duplicate quietly becomes a double charge.

### Timing, latency & load

Throughput intuitions built on the happy path collapse under real traffic.

- Low-TPS systems aren't subject to backlog — or to throttling. Both can hit a quiet system the moment a dependency slows or a burst arrives.
- A processing timeout of N seconds, minutes, *or* hours is sufficient — every fixed timeout eventually meets an event that exceeds it.
- Upstream dependencies' timeouts are properly configured — they're frequently default, mismatched, or longer than your own.
- The retry policy is properly configured — aggressive retries amplify load during exactly the incident you're trying to survive.
- Event processing time is constant and performance stays consistent under load — payload size, cache state, and contention all make per-event cost a moving target.

### Producer & consumer contracts

The producer is another system with its own bugs, outages, and bad days — being internal doesn't make it trustworthy.

- The producer can be trusted to always (or even generally) produce valid events.
- ...to produce non-conflicting events.
- ...to not overload the consumer.
- ...to send messages on time.
- ...to never, or even rarely, fail.
- ...even if it's an internal process — internal code fails too.
- The consumer is simple enough to never fail.
- The consumer doesn't need a scaling strategy — until the producer floods it.

### Dead letter queues & recovery

The DLQ is your incident's waiting room, and recovery is rarely the quick cleanup you imagine.

- Dead letter queues aren't necessary — without one, failed events vanish silently.
- The DLQ is properly configured — easy to forget, easy to misroute.
- Only a handful of events will end up there — a single upstream break can dump thousands.
- Even with many events, there are only a few representative error categories — and at least it'll be easy to sort them — both optimistic; real DLQs are messy and heterogeneous.
- The system doesn't need manual recovery.
- Manual recovery won't require modifying events, or asking the producer to regenerate messages — it often requires both.
- Manual recovery won't coincide with another failure — it loves to.
- Recovery completes within minutes / hours / days — pick the largest unit you fear, then add one.
- Pending recovery, events can simply stay in the queue — queues have retention limits and visibility timeouts; "just leave it" can quietly drop your backlog.

### Architecture

There is no architecture that makes the above go away.

- Orchestrated architectures are better and simpler.
- Choreographed architectures are better and simpler. (Pick your tradeoff; neither is free.)
- Unbounded queues are better than bounded queues — unbounded queues just defer the failure into an OOM or a multi-day backlog.
- Event-driven architectures are simpler to reason about — they trade local simplicity for distributed, emergent, hard-to-trace behavior.

## If You Build This

- **Assume at-least-once and make every handler idempotent.** Treat duplicates and replays as routine input. Derive a real idempotency key from stable business identity — not a timestamp — and make the *operation*, including downstream writes, safe to repeat.
- **Never assume ordering.** Design handlers to tolerate out-of-order, delayed, and stale events. If you truly need order, enforce it explicitly with sequence numbers or version checks, and reject or reconcile events that arrive out of sequence.
- **Plan for the failure path first.** Configure a DLQ, expect it to fill with thousands of heterogeneous errors, and build tooling to triage, edit, and replay events before you need it. Set retries, timeouts, and backoff with the incident — not the happy path — in mind.
- **Budget for slow, messy recovery.** Assume manual recovery takes days, may require editing or regenerating events, and will overlap with another failure. Watch queue retention and visibility timeouts so a "we'll get to it" backlog doesn't expire.
- **Don't trust the producer, even the internal one.** Validate every event at the consumer, handle conflicting and malformed payloads, and give the consumer its own scaling and backpressure strategy so a producer flood doesn't take it down.
- **Test under load and under failure, not just correctness.** Per-event cost varies; low average TPS still backs up and throttles. Inject duplicates, delays, reordering, and dependency timeouts in testing so production isn't the first place you meet them.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Event-Driven Systems (dimtion)](https://dimtion.fr/blog/falsehoods-event-driven/) · [archived copy](../archive/event-driven-systems/01-falsehoods-about-event-driven-systems-dimtion.md)
