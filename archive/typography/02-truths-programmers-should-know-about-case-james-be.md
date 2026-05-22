# Truths programmers should know about case (James Bennett)

> **Original:** <https://www.b-list.org/weblog/2018/nov/26/case/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Truths programmers should know about case Skip to content

Truths programmers should know about case

November 26, 2018 Django , Pedantics , Python , Unicode

A couple weeks ago I gave a talk about usernames at North Bay Python . The content came mostly from things I’ve learned in roughly 12 years of maintaining django-registration , which has taught me more than I ever wanted to know about how complex even “simple” things can be.

I mentioned toward the beginning of the talk, though, that it wasn’t going to be one of those “falsehoods programmers believe about X ” things. If you’re not familiar with those, you can just Google for “falsehoods programmers believe” and get a bunch of typical examples. My issues with the “falsehoods” articles is, basically, that they tell you a bunch of things they say are wrong, but many don’t tell you why those things are wrong or what they think you should do instead. Which I suspect will just lead people to read the article, pat themselves on the back, and then find new and exciting ways to be wrong that weren’t mentioned, because they haven’t actually learned about the underlying issues.

So I gave that talk, and I did my best to actually explain some of the problems and give suggestions for how to deal with them, because I like that approach a lot better . One of the topics I didn’t get to spend much time on (basically a single slide, and some asides on a couple others) was ways that case (as in uppercase and lowercase text) can be complex. For the problem I was discussing — case-insensitive comparison of identifiers — there is an official Right Answer™ and the talk provided the best implementation I know of using only the Python standard library (for details, see the section on case folding below).

But I hinted, briefly, at the deeper complexity of case in Unicode, and I want to take some time to talk about that in more detail, because it’s interesting and because understanding it can help you make better choices when designing and writing code that processes text. So here, in opposition to “falsehoods programmers believe”, is my inaugural “truths programmers should know”, on the topic of case.

And one final note before I begin: there’s a lot of terminology in Unicode. In this post I’m primarily using “uppercase” and “lowercase”, because the Unicode Standard uses those terms when talking about case. If you prefer other terms like “capital”/”small” or “majuscule”/”minuscule” that’s OK . I’ll also often use the term “character”, which to some people may seem incorrect. It is true that Unicode’s concept of “character” does not always match many people’s expectations, and thus it’s often a good idea to avoid “character” in favor of other terminology, but in this post I will use the term as Unicode uses it, to refer to a sort of abstract entity of which things may be predicated. When necessary for precision, I’ll use more concrete terms like “code point”.

There are more than two cases

Speakers of European languages are accustomed to the idea that their languages, written down, use case as a signifier. For example, in English we usually begin sentences with uppercase letters, and mostly continue them with lowercase letters. We also mark most proper nouns by beginning them with uppercase letters, and we handle many acronyms and initialisms via all-uppercase treatment.

For the most part we tend to think of there being only two cases. There’s “A” and there’s “a”. One is UPPER and one is lower, right?

But Unicode actually has three cases. There’s lowercase, and there’s uppercase. And there’s titlecase. Titlecase is most familiar to us from the way we write, well, titles. “Avengers: Infinity War” is titlecased. Normally, this means just uppercasing the initial letter of each word (depending on your style guide, some words, such as articles, conjunctions and prepositions, may not get initial-uppercased).

The Unicode Standard gives, as an example of a titlecase character, U+01F2 LATIN CAPITAL LETTER D WITH SMALL Z . It looks like this: ǲ.

Characters like this are needed sometimes to handle the fallout from one of Unicode’s early design decisions: round-trip compatibility with existing text encodings. Where Unicode would prefer you compose sequences using its combining-character facilities, many pre-existing systems already devoted space to encoding pre-composed sequences. For example: “é” had a precomposed form in ISO -8859-1 (“latin-1”), represented by the byte value 0xe9 . Unicode would prefer you write that using a standalone “e” and a combining accent, but to ensure lossless round-tripping to and from pre-existing encodings like latin-1, Unicode also assigned code points for the composed forms. U+00E9 LATIN SMALL LETTER E WITH ACUTE , for example. Note — although the code point matches the byte value from latin-1, don’t rely on that: encodings of Unicode are unlikely to preserve it. UTF -8, for example, encodes code point U+00E9 as the byte sequence 0xc3 0xa9 .

And, of course, some pre-existing encodings had characters which needed or represented special handling for titlecase, meaning they were incorporated into Unicode as-is. If you want to see more of them, search your favorite Unicode database for characters with general category Lt (“Letter, titlecase”).

There’s more than one way to determine case

The Unicode Standard (§4.2) provides three different definitions of case. Which one you use may be a choice already made for you by your programming language; if not, the choice will depend on what you’re trying to accomplish. The three definitions are:

A character is uppercase if its general category is Lu (“Letter, uppercase”), and lowercase if its general category is Ll (“Letter, lowercase”). The Unicode Standard admits this is a very limiting definition, because each character gets only one general category, so many characters which “should be” uppercase or lowercase may fail this definition on account of their general category indicating something else.

A character is uppercase if it has the derived property Uppercase , and lowercase if it has the derived property Lowercase . These are based on combining the characters in definition (1) with characters possessing other properties which indicate case.

A character is uppercase if applying the Unicode case mapping to uppercase (“uppercasing it”) leaves it unchanged, and lowercase if applying the Unicode case mapping to lowercase (“lowercasing it”) leaves it unchanged. This is comprehensive, but may also behave unintuitively (see later sections).

If you know that you only handle a restricted subset of characters (specifically, letter characters), definition (1) can work for you. If you need a larger repertoire of characters including many “letter-like” but non-letter characters, definition (2) can work for you. The Unicode Standard recommends, in §4.2:

Programmers concerned with manipulating Unicode strings should generally be dealing with the string functions such as isLowerCase (and its functional cousin, toLowerCase), unless they are working directly with single character properties.

The functions mentioned here are defined in §3.13 of the Unicode Standard; formally, definition (3) consists of using the isLowerCase and isUpperCase functions of §3.13, which are defined in terms of fixed points of toLowerCase and toUpperCase , respectively.

If your programming language of choice provides functions or methods for testing or transforming the case of strings or individual characters, it’s worth looking into which of the above definitions (if any) is used in the implementation. The isupper() and islower() methods of Python 3’s str type, if you’re curious, use definition (2).

You can’t tell a character’s case from looking at it (or from its name)

There are many characters you can look at and tell what case they are. For example, “A” is uppercase. And it’s even in the name ( LATIN CAPITAL LETTER A ). But there are times when those methods fail. Consider the code point U+1D34 . It looks like this: ᴴ And the name Unicode gives it is MODIFIER LETTER CAPITAL H . So it’s uppercase, right?

Well, it actually has the derived property Lowercase , and so by definition (2) above it’s lowercase, despite visually resembling an uppercase H and having “ CAPITAL ” in its name.

Some characters have no case

Definition 135 in §3.13 of the Unicode Standard says:

A character C is defined to be cased if and only if C has the Lowercase or Uppercase property or has a General_Category value of Titlecase_Letter.

This means a huge number of characters in Unicode — the majority, in fact — are not cased. Questions about their case are not meaningful, and case mappings have no effect on them. Definition (3) of case above will still return an answer for them, though.

Some characters may appear to have multiple cases

A consequence of the above is that if you use definition (3) of case to ask whether a character that isn’t cased is uppercase or lowercase, you can get an answer of “yes”.

The Unicode Standard gives the example (Table 4-1, row 7) of U+02BD MODIFIER LETTER REVERSED COMMA (which looks like: ʽ). This character has neither the Lowercase nor the Uppercase derived property, and does not have a general category of Lt , so it’s not cased. But applying case mapping to uppercase doesn’t change it, and applying case mapping to lowercase doesn’t change it, so by definition (3) of case, this character answers “yes” to both “are you uppercase?” and “are you lowercase?”

This may seem like it would introduce needless confusion, but it means definition (3) works on any sequence of Unicode characters, and allows case mapping algorithms to be simpler (characters that aren’t cased just map to themselves).

Case is context-sensitive

It’s easy to think, since Unicode provides case-mapping tables covering all its characters, that performing case mapping (transforming a string from one case to another) is just a simple lookup. For example, the Unicode database says the lowercase mapping for U+0041 LATIN CAPITAL LETTER A is U+0061 LATIN SMALL LETTER A . Easy, right?

One example that fails here is in Greek. The character Σ — that’s U+03A3 GREEK CAPITAL LETTER SIGMA — maps to either of two characters when lowercasing, depending on its position. If it occurs in final position (end of a word), it lowercases to ς ( U+03C2 GREEK SMALL LETTER FINAL SIGMA ). In any other position, it lowercases to σ ( U+03C3 GREEK SMALL LETTER SIGMA ).

This also means that case is neither bijective nor transitive. Another example is ß ( U+00DF LATIN SMALL LETTER SHARP S , also known as Eszett ). It uppercases to “ SS ”, although an uppercase form (ẞ, U+1E9E LATIN CAPITAL LETTER SHARP S ) now exists. And “ SS ” lowercases to “ss”, so (using the Unicode Standard’s terminology for applying case mappings) toLowerCase(toUpperCase(ß)) != ß .

Case is locale-sensitive

Similarly, different languages have different rules for case mapping. The most common example is probably that i ( U+0069 LATIN SMALL LETTER I ) and I ( U+0049 LATIN CAPITAL LETTER I ) transform into each other in most locales, but not all . In locales az and tr (the Turkic languages), i uppercases to İ ( U+0130 LATIN CAPITAL LETTER I WITH DOT ABOVE ), and I lowercases to ı ( U+0131 LATIN SMALL LETTER DOTLESS I ). There are times when getting this right is literally a matter of life and death .

Unicode itself does not handle all possible locale-sensitive case rules. The Unicode database provides a general locale-insensitive mapping for the entire range of Unicode, and provides special-case rules for: some ligatures and composed forms; Lithuanian; the Turkic languages; and some of the unique features of Greek. But it omits everything else; §3.13 of the Unicode Standard mentions this, and recommends supplementing with locale-aware case rules when needed.

One example that will be familiar to English speakers is how to titlecase certain names: “o’brian” should titlecase to “O’Brian” (not “O’brian”). But at the same time, contractions like “it’s” should titlecase to “It’s”, not “It’S”. Another example not handled by Unicode is Dutch “ĳ”, which must titlecase as a single unit when occurring in initial position. The large inland bay in the Netherlands is thus properly titlecased “Ĳsselmeer”, not “Ijsselmeer”. Unicode does provide Ĳ U+0132 LATIN CAPITAL LIGATURE IJ and ĳ U+0133 LATIN SMALL LIGATURE IJ , if you need them, and the default case mappings of Unicode will transform those into each other (though Unicode normalization forms that use compatibility equivalence will decompose them into “ IJ ” and “ij” sequences, even if you use the ligature forms).

Case-insensitive comparison requires case folding

Finally, getting back to the material covered in the talk, the complexity of case in Unicode means that case-insensitive comparisons should not be done using standard lowercasing or uppercasing functions common to many programming languages. For purposes of case-insensitive comparisons, Unicode provides the concept of case folding , and §3.13 of the Unicode Standard defines a toCaseFold case mapping and an isCaseFolded function.

It’s tempting to think of case folding as similar to lowercasing — and I call out Python’s documentation for this mistake in the talk — but it isn’t. The Unicode Standard cautions that a case folded string is not necessarily lowercase, and points out Cherokee as an example of a script where case folding produces a result containing uppercase characters.

A slide in the talk adopts the recommendations of Unicode Technical Report \#36 as closely as possible in Python, by normalizing to NFKC and then calling the casefold() method (only available in Python 3+) of the resulting string. Even this skips some edge cases and is not precisely what’s recommended for comparing identifiers. So first, the bad news: Python doesn’t expose enough Unicode properties to filter out characters that aren’t in XID_Start or XID_Continue or those with Default_Ignorable_Code_Point; it doesn’t support the NFKC_Casefold mapping, as far as I’m aware; and it doesn’t provide an easy way to use the modified NFKC of UAX \#31§5.1.

The good news is that most of those edge cases have to do with identifiers which otherwise would cause the set of identifier characters not to be closed under NFKC normalization, and not with any actual security risks posed by the characters in question. And case folding is defined not to be a normalization-preserving operation in the first place (hence the NFKC_Casefold mapping, which re-normalizes to NFC after case folding). Generally what you care about when performing a comparison is not whether both strings are still normalized after preprocessing, but whether the preprocessing is consistent and ensures that only strings which “should” differ afterwards will differ afterwards. You can manually re-normalize after case folding if you’re worried about it.

Enough for now

Like the talk at North Bay, this post is still not exhaustive on its topic, and likely no single blog post ever can be. But hopefully it is a useful general overview of the complexities of the topic, with enough pointers for you to go do further reading if you’re interested, and that’s as good a place as any to stop.

Also, is it too much to hope that other people will be inspired to stop writing “falsehoods programmers believe” and start writing more “truths programmers should know”?
