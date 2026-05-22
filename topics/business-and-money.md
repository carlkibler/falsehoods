# Falsehoods About Business and Money

> Money, prices, and economics break software in expensive ways.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A price is just a number.** Without a currency, a number is meaningless — and even with one, floating-point arithmetic will silently corrupt it. USD 3.1415 is a valid float but an invalid price. The Japanese yen has no decimal positions at all (the sen was removed from circulation in 1953), while the Swiss franc must be rounded to the nearest five centimes.

- **Currency symbols uniquely identify a currency.** The `$` sign is shared by the US, Canada, Australia, Brunei, and Namibia. The `¥` sign covers both the Japanese yen and the Chinese yuan. The dollar sign alone appears *three separate times* in Unicode: `U+0024`, `U+FF04`, and `U+FE69`.

- **Wealth indicates competence or worth.** This one is baked into how a lot of software is designed — premium tiers, trust scores, credit systems. It's an assumption, not a fact.

- **IBANs are a global standard.** Australia's High Value Clearing Payments Association refused to explain their decision not to adopt IBAN for over 12 months, then refused to release any reasoning at all. Significant established interests actively resist financial systems integration.

- **IBAN country codes match ISO 3166-1 alpha-2 country codes.** Mostly, but dangerously not always. Kosovo uses the unofficial code `XK`, and various dependent territories may use their parent jurisdiction's code rather than their own.

- **Keeping an IBAN secret protects the account.** Bank account numbers are public identifiers. Any banking system exploitable purely through knowledge of an account number — like the US check clearance system — should have been fixed long before IBAN arrived. Security-through-obscurity arguments here are misguided.

- **"In stock" means the item is in the warehouse.** Many online sellers have no warehouse at all and ship directly from suppliers (drop shipping). And even if an item *is* in the warehouse, it may be damaged, unsellable, or simply not where the system thinks it is.

- **A product has a price.** Items on auction sites have no price until the auction closes — at which point they're no longer for sale.

- **Economics is morally neutral, racially neutral, and gender neutral.** The efficient markets hypothesis, rational actor models, and Econ 101 are not comprehensive, empirically grounded, or free of political content.

---

## Where It Gets Complicated

### Prices Are Not Simple Scalars

A product doesn't have *one* price — it has a family of prices: list price, sale price, manufacturer-approved price, mandatory publisher price, price with tax, price without tax. The final total paid depends on the time of the transaction, the buyer's location, shipping method, membership status, and sometimes explicit buyer profiling.

Some products have a price of zero. Phones sold "free" with a subscription are a classic case; free samplers and bundled documentation are another.

Some products have no price yet — auctioned items.

Some products have effectively infinite prices — a T-shirt shop offering custom text has an unbounded product catalog that cannot be stored in a database. Even customizable dimensions create combinatorial explosions that quickly exceed any practical database capacity.

### Floating Point and Decimal Traps

Using floating-point numbers to represent money is wrong. Floating-point types have rounding and approximation behaviors that are unacceptable for monetary values, which must be exact. The problem compounds at extremes: bulk industrial pricing (pipeline throughput, electronic components at $0.0225/unit for 10,000-unit orders) may require five or six decimal places on unit prices, while the final invoice rounds to two. Bitcoin operates to eight decimal places; a single satoshi (10⁻⁸ BTC) is a plausible item price, and total annual transaction volumes can easily exceed the entire supply cap of ~21 million BTC.

The "two decimal places" assumption also fails globally: several ISO 4217 currencies use three decimal places, some use none, and non-decimal currencies exist (Mauritania's ouguiya divides into five khoums; Madagascar's ariary into five iraimbilanja). Historical data makes this worse — Poland's złoty redenominated in the 1990s at 10,000:1, and Czechoslovakia's 1953 koruna reform happened with complex conversion rules and essentially no advance notice.

### Currency Codes, Symbols, and Unicode

The ISO 4217 three-letter code is the closest thing to a universal identifier, but it isn't universal. The Russian ruble's official code is `RUB`, but `руб` is widely used, and `CA$` is common for the Canadian dollar. The ruble's official symbol (a Cyrillic Р with a horizontal bar, adopted in 2013) still lacks consistent Unicode support.

The Swiss franc has no Unicode symbol. The Indian rupee had none until 2010. The Japanese yen can be represented by three different symbols: `¥`, `円`, and `圓`.

### Tax Is Not a Percentage You Store on a Product

Tax status depends on the product, the buyer, the buyer's circumstances, and the intended use — and it changes over time in unpredictable ways.

In the UK, 0% VAT and VAT-exempt are legally distinct categories; confusing them is unlawful. A deaf customer can buy an extra-loud phone ringer VAT-exempt; the same customer buying a large-digit clock (no visual impairment) pays VAT. If that same deaf customer buys a *second* extra-loud ringer as a gift for a hearing friend, they pay VAT on it. A gingerbread man with chocolate buttons is an exempt biscuit; reformulate it with chocolate *trousers* and it becomes a VAT-rated chocolate biscuit. A large bag of nuts for home baking is VAT-exempt food; a small bag for snacking is a taxed luxury. Pack size matters.

Tax rules change through legislation (predictable) and court rulings (not predictable). You cannot safely store tax status as a static field.

### Product Identity and Inventory

There is no universal keying system for products. GTINs are the closest thing, but many smaller manufacturers don't participate, some items have multiple keys, and the system doesn't support custom goods. There are also multiple competing micro-data and micro-format variants for annotating web pages with product information.

A single SKU does not always equal one product. Bulky items may be stored and shipped as two or more separate SKUs but can only be sold together as one product.

Many products have no photograph. Generic items, pocket books in Japan, and packs of screws are commonly sold online without images.

Products don't always have a physical form requiring a shipping address. Software downloads and music files ship nowhere. And even physical deliveries may go somewhere with no conventional postal address: Amazon Lockers, building sites (some of which are in the UK Royal Mail "not yet built" database), roadworks locations, and festival fields on private tracks that don't have road numbers.

### IBANs Are Not What You Think

IBAN is managed by SWIFT — a nominally Belgium-registered international cooperative with significant affinity for US interests and de facto monopoly status. The only entities that can create IBAN endpoints are existing financial institutions in countries holding an ISO 3166-1 alpha-2 country code, which excludes innovators, non-state actors, and states with limited international recognition.

IBAN is not clearly published. The dual-format publishing process used by SWIFT has significant documented problems.

IBANs are not written consistently. Some countries continue to use legacy spacing within the IBAN. Others concatenate the whole thing into a single machine-readable string. The standard human format uses four-character blocks (`XXXX YYYY ZZZZ 0000`). Which you use matters: human format for manual transcription, machine format for copy-paste (and watch out for adjacent punctuation being swept along).

IBAN's checksum catches errors but doesn't tell you *where* the error is. A robust implementation needs additional mistranscription error detection to actually help users fix problems.

Pre-IBAN national checksum systems are a minefield: there's no reliable way to determine whether a given country had one, whether it applied to all banks (central banks are known exceptions), or whether it's still in operation after IBAN adoption.

### Economic Assumptions Baked Into Systems

A cluster of assumptions that quietly shape software design and are simply false:

- Price indicates cost. Price indicates value. (Neither is reliably true.)
- Advertising doesn't distort markets — or at least doesn't distort *my* decisions.
- "Rational" means the same thing to everyone.
- Rational actors exist at all.
- Externalities are the same as inefficiencies.
- Pareto efficiency and information symmetry exist in practice.
- Just-so stories make effective public policy or predictive models.
- The system working for you means it works for everyone.
- Politics is unrelated to economics.

---

## If You Build This

1. **Never use floating-point for money.** Use a fixed-point or arbitrary-precision decimal type. Java has `BigDecimal`; Python has the `decimal` module; most languages have an equivalent. Store amounts as integers in the smallest currency unit (cents, pence, fen) and convert only for display.

2. **Store currency alongside every amount, always.** Use ISO 4217 three-letter codes (`USD`, `JPY`, `CHF`) as the canonical identifier — not symbols, which are ambiguous and inconsistently encoded in Unicode.

3. **Never hardcode decimal places.** Look them up from ISO 4217. JPY has 0, KWD has 3, CHF rounds to 0.05 in practice. Your assumption of two decimal places will be wrong in production.

4. **Treat tax as a function, not a field.** Tax depends on product type, buyer identity, buyer circumstance, jurisdiction, intended use, and date. It changes via legislation and court rulings. Any system that stores a static tax percentage on a product record will eventually be wrong and potentially unlawful.

5. **Validate IBANs structurally but don't rely on country-code assumptions.** Use a library (like `php-iban`) that handles the full range of country-specific formats, pre-IBAN checksum quirks, and mistranscription detection. Don't assume IBAN country codes match ISO 3166-1 or IANA codes — they mostly do, but the exceptions are real.

6. **Never assume a product has exactly one price, one SKU, one photo, one tax rate, or a physical shipping destination.** Model prices as a set of typed values (list, sale, tax-inclusive, tax-exclusive). Model inventory as separate from product definition. Make shipping address optional and accommodate non-postal destinations.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Prices (wiesmann)](https://wiesmann.codiferes.net/wordpress/archives/22201) · [archived copy](../archive/business-and-money/01-falsehoods-about-prices-wiesmann.md)
- [Falsehoods about Economics (exple.tive)](http://exple.tive.org/blarg/2016/09/22/falsehoods-programmers-believe-about-economics/) · [archived copy](../archive/business-and-money/02-falsehoods-about-economics-exple-tive.md)
- [Falsehoods about IBANs (php-iban)](https://github.com/globalcitizen/php-iban/blob/master/docs/FALSEHOODS.md) · [archived copy](../archive/business-and-money/03-falsehoods-about-ibans-php-iban.md)
