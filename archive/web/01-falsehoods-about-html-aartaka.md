# Falsehoods about HTML (aartaka)

> **Original:** <https://www.aartaka.me.eu.org/falsehoods-html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Programmers Believe About HTML

Falsehoods Programmers Believe About HTML By Artyom Bologov Web is beautiful. Web is ugly. Web is astonishing. A part of this appeal is HTML, with its historical quirks. Many a programmer believe many things about HTML. And some of the beliefs are not necessarily true. So let’s explore some falsehoods programmers believe about HTML.

Language & Parsing HTML is just XML. All tags have matching closing tags. Some tags (like
<li>

or
<p>

) have implicit closing tags: HTML is almost XML. All tags have closing tags, even if implicit <img> and <input> are self-closing: Okay, okay, HTML is not XML. But all elements either have closing tags or self-close <br> and
<hr>

don’t even need a self-close slash. Actually, self-close slash is mostly optional (and discouraged) in HTML , so the difference is less pronounced.

Standard HTML is defined by the standard It’s defined by browser vendors and WHATWG (= browser vendors) The standard does not change after validation The standard is “Living”, and you can see (a very recent) date of last change at Living Standard page. The standard is self-contained (relating to HTML only) HTML is also relating to a group of standards, including DOM and JavaScript. In fact, many features of HTML are defined as JavaScript classes. There is only one (two? three?) doctypes for HTML documents Oh my sweet summer child…

Practices

All websites follow the standard.

No one uses HTML4.

No one uses HTML3 anymore.

No one uses HTML2 anymore.

No one uses HTML1 anymore.

No one uses tables for markup anymore. No one uses XHTML ePub, a widespread ebook format, uses XHTML for content markup. It sucks, but it’s a practice.

Runtime Modifying DOM is slow React propaganda is probably to blame for this illusion. DOM is the most optimized data structure out there. Whatever you put in it—it’ll sustain. React will not. Browsers are just messy HTML parsers Browsers are JS evaluators. Browsers are layout engines. Browsers are computer graphics toolkits (WebGL and fonts). Browsers are OSes (they have file system interfaces, audio output, and many other APIs). SEO is hard and you need frameworks for it Not really if you write simple semantic HTML. Because it’s easy to parse and index, especially compared to JS-generated markup. WebAssembly will deprecate HTML and JS These are different niches. You can’t really make accessible websites with WebAssembly. So if you want universal pages openable everywhere, you have to stick with HTML etc. HTML is not Turing-complete It is, given CSS and user input.

Did I Forget Any?

In case you haven’t found your favorite falsehood, feel free to suggest more! This post will likely be on Reddit and Hacker News, so use comments there. Or use the contacts from the About page!

Leave feedback! (via email)
