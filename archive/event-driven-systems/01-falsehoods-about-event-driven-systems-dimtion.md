# Falsehoods about Event-Driven Systems (dimtion)

> **Original:** <https://dimtion.fr/blog/falsehoods-event-driven/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods Software Developers Believe About Event-Driven Systems · Blog · Loïc Carr

Loïc blog photos notes

Falsehoods Software Developers Believe About Event-Driven Systems 2024-06-30

When building a distributed system, a common design pattern is to follow the event-driven approach. Event-driven systems can range from a simple in-memory queue to a serverless AWS Lambda with a preceding queue, or even connected Kafka clusters. when reviewing code implementing an even driven architecture, I see common mistakes that cause toil or even operational incidents once deployed to production. Here are unordered misconceptions developers have about event-driven architectures. Use this as a checklist for design and code review. Message ordering

Events will arrive in order Events will arrive in order, even with a single consumer Events will arrive in order, even if specified by the producer contract Events will arrive in order, even with days between messages Events can always be ordered Message duplication

Events won’t be duplicated Events won’t be duplicated, in at-most-once delivery queues Events won’t be duplicated, even if specified by producer contract Events won’t be duplicated, even with de-duplication upon arrival Idempotency

Adding an idempotency key ensures idempotency Equal idempotency keys mean identical payloads Event timestamp is a valid idempotency key Writing idempotent code is easy Maintain and improve idempotent code is easy Idempotency can be solved via adding a distributed lock and an idempotency key Load management

Low TPS systems are not subject to backlog Low TPS systems are not subject throttling Processing timeout of XX seconds is sufficient Processing timeout of XX minutes is sufficient Processing timeout of XX hours is sufficient Upstream dependencies’ timeouts are properly configured Retry policy is properly configured Event processing time is constant and performance will remain consistent under load Producer contract

Event producer can be trusted to always produce valid events Event producer can be trusted to generally produce valid events Event producer can be trusted to produce non-conflicting events Event producer can be trusted to not overload the consumer Event producer can be trusted to send message on time Event producer can be trusted to never fail Event producer can be trusted to rarely fail Event producer can be trusted, even if it is an internal process Consumer contract

Event consumer is simple enough to never fail Event consumer does not need a scaling strategy Event consumer downstream dependencies support idempotent calls Events will never be dropped Dead letter queues

Dead letter queues are not necessary Dead letter queue is properly configured Only a handful events will end up in the dead letter queue Even if there are many events in the DLQ, there are only a few representative error categories At least it will be easy to sort out the different error categories Recovery

System does not need manual recovery Manual recovery won’t require modifying events Manual recovery won’t require the producer to regenerate messages Manual recovery won’t coincide with another system failure Manual recovery will be completed within minutes Manual recovery will be completed within hours Manual recovery will be completed within days Pending manual recovery, events can simply stay in the queue Architecture

Orchestrated architectures are better and simpler Choreographed architectures are better and simpler Unbounded queues are better than bounded queues Event-driven architecture are simpler to reason about \[list to be updated\]

⤺ ◦ ⤻
