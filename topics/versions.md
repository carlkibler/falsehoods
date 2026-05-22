# Falsehoods About Software Versions

> A version number is not a number, and it isn't ordered the way you think.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Versions are numbers.** They look like `2.5.1`, but a version is structured text — a sequence of fields with their own rules. Treat `1.10` as the float `1.1` and you've just declared version 10 equal to version 1.
- **Versions always increase.** A `latest` tag can point backward, a hotfix can ship under an *older* line (`2.4.9` after `2.5.0`), and yanked releases vanish. Monotonic increase is a hope, not a guarantee.
- **`"10"` is not a valid single field.** A version field isn't a single digit — `0.9.0` → `0.10.0` is a normal increment, and naive code that sorts character-by-character will happily rank `0.9.0` above it.
- **The last group is the least significant.** Pre-release suffixes flip this: `1.0.0-alpha` is *less* than `1.0.0`. The trailing chunk can make a version smaller, not finer-grained.
- **If two versions share a number they're equivalent.** Build metadata, channels, and architecture tags mean `1.2.3` and `1.2.3+build.99` (or two different `1.2.3` artifacts in two archives) can be different code.
- **A major number ≥ 1 means a stable API,** and **same major number means same API.** Plenty of `0.x` libraries are rock-solid; plenty of post-1.0 projects break things in minor releases. The number is a promise some people keep.
- **Semantic versions max out at three positions and never hit double digits.** None of that is true: you'll see four-part versions, and fields routinely climb into double and triple digits.
- **Version numbers carry no runtime information.** Sometimes the version *is* the behavior switch — feature flags, protocol negotiation, and compatibility shims read it at runtime.

## Where It Gets Complicated

The Big Surprises above are the *what*. This is the *why* — the mechanisms that make each one bite, plus the cases the headline list skips.

### Parsing & format

- **Why a version isn't a string, decimal, or integer.** Each coercion loses something specific: strcmp gets ordering wrong, a decimal collapses `1.10` into `1.1`, and an integer can't hold the structure at all. It's a multi-field token, and only field-aware parsing preserves it.
- **What "structured text" actually contains.** Beyond numbers, periods, and a leading `v`, real versions carry letters, hyphens, plus signs, underscores, dates, git hashes, and codenames — `1.0.0-rc.1+exp.sha.5114f85`, `2024.05`, `v3-beta`. Your parser has to expect all of it.
- **Wire and human-readable forms are not losslessly convertible.** A compact wire encoding may drop pre-release labels, build metadata, or original formatting you can't reconstruct — so don't round-trip through one and assume you got the same version back.

### Ordering & comparison

- **What "compared correctly" requires.** Numeric fields compare numerically, pre-release fields compare field-by-field, and a pre-release is *lower* than its release. `1.0.0-alpha < 1.0.0` is why the trailing group can *lower* a version — significance isn't strictly left-to-right.
- **Length is its own ordering question.** `1.2` vs `1.2.0` vs `1.2.0.0` — equal or not? Comparing versions of different lengths needs defined rules, not intuition.
- **Why both naive sorts fail.** Lexical sort puts `1.10.0` before `1.9.0`; numeric coercion collapses distinct versions into one. Neither produces correct order.

### Semver assumptions

- **Plenty of versions aren't semantic at all.** Dates, sequential build numbers, marketing versions, and ad-hoc schemes are all in the wild — and date-based schemes (`2024.05`, Ubuntu's `24.04`) are legitimate, often clearer than semver for release cadence. Semver is one convention among many, not the standard.
- **Why "same major = same API" fails in practice.** Semver describes *intent*, not enforced reality. Maintainers break the contract, intentionally or not, so the major number is a promise, not a guarantee.
- **Increments aren't uniform steps.** Fields jump (`1.0` → `2.0`), skip numbers, and reset lower fields to zero. Don't assume a version went up by exactly one.

### Identity & uniqueness

- **Why equal numbers needn't mean equal code.** Two artifacts tagged `1.2.3` can differ by build metadata, platform, or channel — same label, different bits.
- **One archive or project can hold many versions.** Monorepos, vendored dependencies, and independently versioned components break "all code shares one version." Conventions also vary wildly between ecosystems and even between projects in one.
- **`latest` is a mutable human-set pointer.** It can lag, point to a pre-release, or track a non-semver line entirely — never assume it's the newest semver.

## If You Build This

- **Use a real version-comparison library** for your ecosystem (semver, PEP 440, RPM/dpkg, Maven). Don't hand-roll comparison — the edge cases will find you.
- **Never sort versions lexically or numerically.** `1.10.0` must rank above `1.9.0`, and pre-releases must rank below their releases. Field-aware comparison only.
- **Don't assume monotonic increase.** Handle backports, hotfixes on older lines, yanked releases, and `latest` pointing somewhere unexpected.
- **Treat versions as opaque structured tokens, not numbers or strings.** Parse into fields; never coerce to float or `int`.
- **Don't trust semver as a contract.** Pin and test dependencies; assume minor and patch bumps *can* break you, and that pre-1.0 can be stable.
- **Allow multiple versions to coexist** within one project, archive, or build, and preserve full version strings (including pre-release and build metadata) end to end.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Versions (xenoterracide)](https://github.com/xenoterracide/falsehoods/blob/master/versions.md) · [archived copy](../archive/versions/01-falsehoods-about-versions-xenoterracide.md)
