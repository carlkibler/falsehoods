# Falsehoods about Prices (wiesmann)

> **Original:** <https://wiesmann.codiferes.net/wordpress/archives/22201>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods programmers believe about online shopping… – Thias の blog

☰

Selling stuff is a pretty old human activity, and merchants had found ways to distinguish themselves from their competition way before Archimedes had shouted Heúrēka . Trade is a complicated business, and online shopping has not made that simpler, quite the contrary. So when programmers build systems to support online shopping they tend to stumble on their own erroneous, assumptions.

This post is similar to the one I made about geographic assumptions , but about online shopping, again this list is not exhaustive, and some of the falsehoods are disputable.

A product has a price

Products sold on auction site do not yet have a price. The moment the price is known is actually the moment the item will not be on sale anymore.

Except for auctioned items, products have one price

Products do not have one price, they have many prices: with or without taxes, then there is the sale price, the regular price, the list price, the manufacturer approved price, the mandatory publisher price.

Products have one final total price

The total price paid typically depends on a lot of variables: time of the transaction, location of the buyer, shipping methods, memberships, sometimes even the profiling of the buyer.

A product has a strictly positive price

Many phones are sold for “free”, there is typically a subscription behind it. Some online shops also add samplers and documentation as free items to their inventory.

A price is a number

Without a currency, a price is meaningless on the internet.

A price is a floating pointer number and a currency

Using floating points for price is incorrect: no currency is defined for transaction below two decimal points, 3.1415 is a valid floating point number value, but USD 3.1415 is not a valid price for a transaction. Some currencies like the Japanese yen don’t accept any decimal position at all (the fraction of the yen, the sen, was removed from circulation in 1953). More generally floating point representation has rounding and approximation behaviour which are bad for monetary values which need to be exact.

Currencies need to be rounded to some decimal position

The Swiss franc needs to be rounded to five centimes.

Currencies symbols uniquely identify a currency.

The peso and dollar sign \$ is used my many countries: USA, Cananda, Australia, Brunei, Namibia. The ¥ sign is used both the Japanese Yen and the Chinese Yuan.

Currencies have a unicode symbol

The Swiss franc does not, and until 2010, neither did the India rupee.

Currencies have zero or one unicode symbol

The dollar and peso symbol appears three times in unicode: 0x24 (\$), 0xFF04 (＄), 0xFE69 (﹩)

Currencies have zero or one unicode symbol after normalisation

The Japanese yen can be represented by the following symbols: ¥, 円, 圓.

Currencies can be described by a single three letter code

The ISO 4216 code for the Russian ruble is RUB , the three letter code руб is widely used, so is CA\$ for the Canadian dollar.

Each stock keeping unit translates to a product

Some bulky items have to be kept in the warehouse as two or more boxes, hence two stock keeping units, but can only sold together as one product.

Each product has a picture

Many generic, or bulky items are sold online without pictures: pocket books in Japan, but also packs of screws etc.

You can put all products in database

Increasingly products can be customised: a shop that sells T-shirts with custom text has an infinite number of products, which won’t fit in a database. Even if you consider some good whose dimensions can be customised, the combinatorial growth of possibilities will quickly go beyond the capacity of a database.

There is a common keying system for products

GTINs are the closest thing, but many smaller manufacturer do not participate in the system, some items have multiple keys. The system also does not support custom goods.

There is a common system for annotating web-pages with products

There are multiple micro-data and micro-format variants.

In stock means the item is in the warehouse

Many online sellers do not have any actual warehouse, they ship directly from their suppliers ( Drop shipping )

Like this:

Like Loading…

Related

19 thoughts on “Falsehoods programmers believe about online shopping…”

– One more falsehood, in your own text: “no currency is defined for transaction below two decimal points” : that is/will probably be necessary with bitcoins. A bitcoin is more than 300 €: even 0.01 BC is too much to pay for my daily baguette. I wonder if there are more common currencies with this problem. And I’ve seen unit prices with 5 or 6 decimals, because the amounts were huge (how many barrels of oil per month through a pipeline?). Of course the final invoice was rounded.

– You can add another one : “You can convert from one unit to another one with a fixed number”. I was naive enough to think this until I had to compute the number of phones to put in boxes on a pallet, or the number of bottles (with different sizes) in a crate, all of this depending of course of the precise product. My last problem of the kind involved converting linear meters of drywall to kg or m3…

Reply

You are right, but this brings another point which is there are two prices, unit-price (which might be a smaller fraction) and transaction price. Note that with smaller fractions, using floating point is even more dangerous, as the rounding effects become more prevalent…

Reply

Regarding the code for Russian ruble: in 2013 a symbol looking like a “P” with a horizontal bar was officially adopted by the Russian Central bank (and it was sometimes used even before its official recognition: http://www.artlebedev.ru/kovodstvo/sections/159/ ). AFAIK, it has not yet found its way to Unicode, and often the three-letter rub. or руб. is still used – and for the new symbol, you have to do dirty tricks in HTML and CSS ( http://www.artlebedev.ru/tools/technogrette/html/rouble/ ).

Reply

> Products have one final total price

Other cases where this is not true: If the product is sold in various countries it might have multiple prices because of different taxes or just because the people selling it fell like the Europeans can afford a higher price than the Americans.

Maybe another point to add:

> Products have a physical representation (that has to be shipped to a physical address)

Not true for software or song downloads etc.

Reply

About Swiss Francs and 5 Rappen: this is not totally true. – the smallest coin in general is 5rp and the 1 & 2rp aren’t coined anymore, but they’re still valid (but I think can be rejected in shops). – you can have items tagged as \*.99, usually it’s then rounded after the total. One shop used to do this and also give out 1rp coins ~20 years ago, not sure about today. – bank accounts also can have weird amounts like “564.83+”, signifying that it was rounded down and can be rounded up next time. – there’s also the question when to round: each step, sometimes, only at the end. Also VAT at 8%. Which one is rounded, with or without?

Reply

“Using floating points for price is incorrect: no currency is defined for transaction below two decimal points”

Uh. This isn’t true. Bitcoin has 8 decimal digits of precision. Worse, unlike dollars, where using a 32-bit fixed point might be (relatively) unlikely to cause a disaster (2^31 cents is a ridiculous amount of money, about 21 million dollars), fixed points to represent Satoshi (10^-8 BTC) could plausibly be the price of a singular item, as that’s only 21 bitcoins, which is as of this writing worth a̶b̶s̶o̶l̶u̶t̶e̶l̶y̶ ̶n̶o̶t̶h̶i̶n̶g̶ \$22000 USD.

A bitcoin-specific falsehood might be “I’ll never have to deal with any amount more than the supply cap of ~21 MegaBTC, or a 2.1 quadrillion Satoshi.

Whilst it’s clearly impossible to have that many bitcoins, things like the total transaction value for a year could, and probably do, easily exceed this hard cap.

Reply

> All currencies are decimal.

Mauritania has five khoums to the ouguiya, Madagascar has five iraimbilanja to the ariary. Although the subunits would be a tiny fraction of a US cent so probably not relevant. If you have to work with historical data for any reason there are a vast array of non-decimal systems.

> You can convert currency at market rates.

The seller might want to set their own prices in different currencies.

> Prices are always before tax / always after tax.

Practice differs by country, and also by whether you’re selling to end consumers or to businesses.

> Tax does not depend on product.

Yes it does.

> You can just store the tax on a product as a percentage.

In the UK some items have 0% VAT and some items are exempt from VAT. These are not the same! Getting them wrong is unlawful and the taxman won’t be happy.

Reply

A product is always taxed at the same rate.

Not true. In the UK goods for people with disabilities are exempt from VAT if ordered by a person with a disability and the good is related to that disability. The shipping may also be VAT-exempt accordingly.

A customer will always pay the same tax rate.

Not true. A UK deaf customer can get the extra-loud phone ringer VAT-exempt (or is that zero-rated?), but the large digit wall clock will be VAT-rated if the customer does not also have a visual impairment.

A customer will always pay the same tax rate on the same product.

Not true. The UK deaf customer who’s buying a second extra-loud phone ringer as a gift for a friend who isn’t deaf but has got a big garden has to pay the VAT.

A product will never change tax status.

Not true. Tax rules change, through legislation (which is predictable) and court rulings (which aren’t).

A product will never change tax status.

Not true. The manufacturer may change the formulation of a product. A gingerbread man with chocolate buttons is an exempt biscuit. If the manufacturer launches New! Improved! gingerbread man with chocolate trousers, he becomes a chocolate biscuit and is VAT-ed. 

Pack size does not affect tax status.

Not true. A big bag of fruit or nuts intended for home baking is VAT exempt (food). A small bag intended for consumption is VAT-ed (snack/luxury).

Reply

Prices with more decimal points. I have seen prices quoted in US Dollars with more than two decimals.

Low cost electronic parts, for example, might be quoted at \$0.0225, so you buy 10,000 of them and it’s \$225.00.

I assume the payments are made to two decimal places.

Reply

no currency is defined for transaction below two decimal points

Not true. Multiple currencies use three decimal points, some use no decimal points, et cetera. See ISO 4217: https://en.wikipedia.org/wiki/ISO_4217

Also:

currency parameters do not change…

Not true. Polish old złoty (PLZ) became new złoty (PLN) in the 1990s, with a “conversion” rate 10000:1

…and if they do, it’s a straightforward calculation, with plenty advance notice; the currency code will probably change, too

Not true, the Czechoslovak Koruna was “reformed” in 1953, “effective immediately”, with a complex conversion from the old to the new https://en.wikipedia.org/wiki/Czechoslovak_koruna#Third_koruna

Reply

Pingback: A curated list of falsehoods programmers believe in \| Dardo Tech

Pingback: kdeldycke/awesome-falsehood - News Himalaya

Pingback: kdeldycke/awesome-falsehood \| My Blog

What the Warehouse Software thinks is in the warehouse and what is in the warehouse are not the same

Reply

Even if it’s in the warehouse, it may be broken or damaged and not sellable. Even if it’s in the warehouse, it may not be where it’s supposed to be.

Reply

\[Panzi\] Products have a physical representation (that has to be shipped to a physical address)

Products that have to be shipped to a location may not be going to anywhere that has an address.

Amazon Lockers and other drop boxes don’t have postal addresses, but do have address data that is courier-specific.

Building sites might or might not have an address (in the UK Royal Mail has a “not yet built” database for housing developments). Roadworks locations don’t have an address but may have a road name or number. Festivals in fields may be off private tracks which don’t even have a road number. (I think this was why what3words was originally invented.)

Reply

Pingback: Awesome Falsehood – Massive Collection of Resources – Learn Practice & Share

Pingback: Ti Point Tork » Blog Archive » Nat’s 2022 Technical Link Pile: Random

Pingback: Falsehoods Programmers Believe In – Veritas Reporters

Leave a Reply Cancel reply

This site uses Akismet to reduce spam. Learn how your comment data is processed.

Loading Comments…

%d
