# Falsehoods About Art

> Art objects refuse every database schema you'd design for them.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **Every artwork has an artist.** Plenty don't have one you can name in a column. Some are attributed to "cultural makers" (anonymous traditions, workshops, peoples), others to a manufacturer rather than an individual. Your `artist_id` foreign key needs to be nullable, and probably needs a whole other table.

- **An artwork has exactly one artist.** Collaborations are everywhere. The relationship is many-to-many, not a single field — and attribution itself can be contested or shared across a workshop.

- **Every artwork is unique.** Editions, reproductions, prints, and series exist, and modeling the relationships between an "original," its editions, and its reproductions is genuinely nontrivial. One physical object, many conceptual siblings.

- **People don't buy art from JPEGs.** They do — and they buy art that hasn't been created yet. The transaction can precede the object's existence, which torpedoes any model assuming the artwork row exists before the sale row.

- **Every lot in an art auction is an artwork.** Some lots are "experiential" — a visit to an artist's studio, a dinner, an experience. Your auction schema can't assume every lot points to a tangible work.

- **An artwork belongs to one gallery / collector / auction house at a time.** Provenance is messy and there is *no canonical source of truth*. Ownership history branches, overlaps, gets disputed, and gets lost. There is no single authoritative ledger you can sync against.

- **"Untitled" means the work has no title.** Some works are literally *titled* "Untitled." Absence of a title and a title that reads "Untitled" are different states, and conflating them loses information.

- **All artwork titles fit in 512 characters.** They don't. Real titles run far longer; sizing a column to a "reasonable" limit guarantees truncated data eventually.

## Where It Gets Complicated

### Identity and authorship

Attribution rarely reduces to one person. Beyond solo artists you have collaborations, anonymous "cultural makers," and manufacturers. Treat the artwork-to-creator link as a many-to-many relationship with roles, and allow it to be empty or uncertain. The *"my kid could paint that"* reflex misses the point: the hard question is usually not skill but *who made it and why* — exactly the metadata that's hard to pin down.

### Titles and naming

Titles are optional, can be the word "Untitled," and have no sane length bound. Distinguish three states explicitly: no title, a title that happens to be "Untitled," and an arbitrarily long title. Don't let your UI or schema collapse them.

### Uniqueness, editions, and reproductions

A single creative work can manifest as many objects: an original, numbered editions, reproductions, posters, and series. The popular belief that *only rich people can afford "real" art and everyone else just buys posters* both insults the buyer and ignores that editions and prints are legitimate, collectible works in their own right. Modeling "this is an instance of that, which is a reproduction of this other thing" is a graph, not a column.

### Provenance and ownership

There's no canonical source of truth for who owns or has owned a work. Ownership passes between galleries, collectors, and auction houses; records conflict, go dark, and resurface. Design provenance as an append-only, possibly-contradictory history with confidence and gaps — not a single current-owner pointer.

### Categories and classification

The assumption that *an artwork has a natural, canonical category* is false. Categories are interpretive, overlapping, and shift with context and audience. There is also no single "art world": there are thousands of galleries worldwide specializing in everything from contemporary jewelry and emerging conceptual art to Chinese scroll painting and regional landscapes. A fixed category enum will fight reality forever.

### Display and rendering

*Art should always be rendered at its maximum size* is wrong — there are real business constraints and art-world norms (rights, gallery preferences, contextual presentation) governing how and how large a work may be shown. Display rules are first-class data, not a CSS afterthought.

### Why people buy

*People buy art mostly for its visual qualities* is false: people buy because of a story, because of what the work says, or because they can't stop thinking about it. Your value and recommendation models can't be purely visual or purely price-gated.

### Representation and notation (the deeper trap)

The hardest falsehood is that a creative work can be *fully written down* in any notation. Even where a formal notation exists, it captures the critical core and leaves the rest — style, period convention, performer or interpreter judgment — unwritten and often unwritable. The record is not the work. A score, a spec, a JPEG: each is a lossy projection of something that resists complete codification. Build for the projection while remembering it isn't the thing.

## If You Build This

- **Make creator a nullable many-to-many, with roles.** Never assume one artist, never assume any named artist. Support cultural makers, manufacturers, collaborations, and "attribution uncertain."

- **Model title as three distinct states.** No title, the literal title "Untitled," and arbitrarily long titles — and don't cap the length at a "reasonable" number. Use `TEXT`, not `VARCHAR(512)`.

- **Treat originals, editions, and reproductions as a graph.** One conceptual work can have many physical and reproduced instances; store the relationships explicitly rather than flattening to "is this unique: yes/no."

- **Store provenance as a contradictory, gappy history — not a current-owner field.** Assume no canonical source of truth; record confidence, conflicts, and unknowns.

- **Don't assume the lot is an artwork or that the object exists before the sale.** Auction lots can be experiences, and sales can precede creation. Decouple the transaction from the object's existence.

- **Keep categories soft and display rules explicit.** No canonical category, no single "art world," and no "always render at max size." Make classification multi-valued and presentation constraints first-class data.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Art (literateprogrammer)](https://literateprogrammer.blogspot.com/2016/07/falsehoods-programmers-believe-about.html) · [archived copy](../archive/art/01-falsehoods-about-art-literateprogrammer.md)
- [Programmer Misconceptions about Art (Artsy)](http://artsy.github.io/blog/2018/04/18/programmer-misconceptions-about-art/) · [archived copy](../archive/art/02-programmer-misconceptions-about-art-artsy.md)
