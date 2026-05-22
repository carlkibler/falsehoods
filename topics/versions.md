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

### Parsing & format

- **Versions are strings / decimals / numbers.** A version is none of these cleanly. It's not a string (you can't strcmp it), not a decimal (`1.10 ≠ 1.1`), and not an integer. It's a structured token.
- **Versions have numbers, periods, and maybe a leading `v`.** Real versions include letters, hyphens, plus signs, underscores, dates, git hashes, and codenames — `1.0.0-rc.1+exp.sha.5114f85`, `2024.05`, `v3-beta`.
- **`"10"` is not a valid single field.** Fields are multi-digit. `0.9.0 → 0.10.0` is correct; anything that treats each character as a position breaks here.
- **Semantic versioning cannot be represented as a number or decimal.** Correct, and that's the point — any attempt to coerce it into one loses ordering information.
- **Over-the-wire and human-readable versions are losslessly convertible.** They aren't. A compact wire encoding may drop pre-release labels, build metadata, or original formatting you can't reconstruct.

### Ordering & comparison

- **At least a semantic version can be compared correctly.** Only if you implement the actual rules: numeric fields compare numerically, pre-release fields compare field-by-field, and a pre-release is *lower* than its release.
- **The least significant group is the last one.** `1.0.0-alpha < 1.0.0` shows the trailing group can lower the version. Significance isn't strictly left-to-right.
- **Length doesn't matter as long as versions increase.** `1.2` vs `1.2.0` vs `1.2.0.0` raise real questions — are they equal? Comparing versions of different lengths needs defined rules, not intuition.
- **Sorting by string or number works.** Lexical sort puts `1.10.0` before `1.9.0`; numeric coercion collapses distinct versions. Neither produces correct order.

### Semver assumptions

- **Versions are semantic.** Many aren't. Dates, sequential build numbers, marketing versions, and ad-hoc schemes are all in the wild.
- **Semver is always the best choice / is always the standard.** It's one convention among many, and not always the right fit.
- **Semantic versions only have three positions / never reach double or triple digits.** Both false — extra positions and large fields are common.
- **Major ≥ 1 implies a stable API; same major implies same API.** Semver describes intent, not enforced reality. Maintainers break the contract, intentionally or not.
- **Dates are bad for versions.** Date-based schemes (`2024.05`, Ubuntu's `24.04`) are legitimate and often clearer than semver for release cadence.
- **Versions increase by exactly one.** Fields jump (`1.0` → `2.0`), skip numbers, and reset lower fields to zero. Increments aren't uniform steps.

### Identity & uniqueness

- **Equal numbers mean equal code.** Two artifacts tagged `1.2.3` can differ by build metadata, platform, or channel — same label, different bits.
- **All code in an archive shares one version,** and **versions are consistent within a project.** Monorepos, vendored dependencies, and independently versioned components mean a single archive or project can hold many versions at once.
- **Versions are consistent across a language or community.** Conventions vary wildly between ecosystems and even between projects in the same one.
- **`latest` always points to the newest semver.** `latest` is a mutable pointer set by humans and tooling. It can lag, point to a pre-release, or track a non-semver line entirely.
- **Version numbers convey no runtime information.** They can — code reads the version to negotiate protocols, gate features, or apply compatibility shims.

## If You Build This

- **Use a real version-comparison library** for your ecosystem (semver, PEP 440, RPM/dpkg, Maven). Don't hand-roll comparison — the edge cases will find you.
- **Never sort versions lexically or numerically.** `1.10.0` must rank above `1.9.0`, and pre-releases must rank below their releases. Field-aware comparison only.
- **Don't assume monotonic increase.** Handle backports, hotfixes on older lines, yanked releases, and `latest` pointing somewhere unexpected.
- **Treat versions as opaque structured tokens, not numbers or strings.** Parse into fields; never coerce to float or `int`.
- **Don't trust semver as a contract.** Pin and test dependencies; assume minor and patch bumps *can* break you, and that pre-1.0 can be stable.
- **Allow multiple versions to coexist** within one project, archive, or build, and preserve full version strings (including pre-release and build metadata) end to end.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Versions (xenoterracide)](https://github.com/xenoterracide/falsehoods/blob/master/versions.md) · [archived copy](../archive/versions/01-falsehoods-about-versions-xenoterracide.md)
