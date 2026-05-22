# Falsehoods about REST APIs (slinkp)

> **Original:** <http://slinkp.com/falsehoods-programmers-believe-about-apis.html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

Falsehoods Programmers Believe about REST APIs - slinkp blog

slinkp blog

Blog

Bass

Music

Talks

About

In the spirit of “Falsehoods Programmers Believe” (my favorite is probably “Falsehoods Programmers Believe About Time” ), I offer this, about working with third-party REST APIs.

“Believe” is a bit of a strong word here. Beliefs are deep things that are resistant to change. These are more like assumptions or wishes that crumble on first contact with the API.

Some of these have been true of APIs I’ve worked on. More have been true of APIs I’ve interacted with. Hopefully it’s useful as a list of pitfalls to be mindful of when creating and documenting APIs. It’s hard out there for a client!

All of these assumptions are wrong!

Documentation

Common features of our public application will be available in the API.

The person implementing a client is already an expert user of our application.

Okay, the implementor knows something about our application.

Okay, the implementor has at least heard of our application.

Okay, the implementor at least knows something about the problems solved by our application.

Any jargon on our user-facing application is the same as terminology for the same concepts in our API. (counterexample?)

API documentation will have a glossary of the application jargon used.

If the documentation says that legal values for POSTing to resource B can be found by GET to resource A, then all returned values from A will work with B.

Documentation of old versions of the system will be preserved.

If there are similar-sounding concepts in the system, the differences will be well explained somewhere. We wouldn’t have all of “tags” and “topics” and “terms” and leave you to guess what they mean.

Errors

Successful status is always 200.

Successful status is always one of the documented statuses.

A 20x response indicates success.

An API that is documented as returning errors in JSON format will always return a parseable JSON error response.

If there are rate limits, the rate limit error message format will be documented.

For that matter, all error codes emitted by the system will be documented.

Least Surprise

A resource which accepts a POST request and whose path ends in .json expects a JSON-encoded body. Obviously.

Auth will be done by some common standard such as OAuth.

If it’s oauth, and I use a commonly available third-party oauth library, and authentication works, it won’t just stop working one day.

If the documentation says you can upload a 3 MB PNG image, then you can expect PNG images under 3 MB won’t cause 500 errors.

Moving Fast and Breaking Stuff

Breaking changes will be confined to explicit versions of the API.

There will be explicit versions of the API.

Features won’t just disappear from version N when version N+1 is released.

Backwards incompatible changes will be announced long before they are deployed.

Well, at least more than a week before.

Okay, at least there will be some documentation that a breaking change occurred sometime after deploying the changes. We wouldn’t just update the docs and pretend the old spec never existed.

If there is an announcement of breaking changes, then only the announced things will break.

If there is an announcement of breaking changes, it will explicitly call out the changes. changed. It won’t just be a dump of the entire new documentation.

Okay, if the announcement is just a dump of the entire new documentation, it will at least be in a text format that you can run diffs against.

Okay, if the announcement is just a dump in some binary format, it will at least be in a format that you can copy/paste text out of to generate some diffs. We wouldn’t use some weird PDF generator that inserts bizarro invisible whitespace between random characters within words.

Bug Reports

If you file a bug report and get an official response acknowledging it’s a bug, it will get fixed eventually.

If you file a bug report and get an official response acknowledging it’s a bug, and we say we’re removing the feature from the next version instead of fixing it, then at least we’ll update the docs for the old API version to reflect the breaking change.

There will be somewhere to report bugs.

Catch-22

If a client application requires approval to use some restricted or paid features, it will be possible to get that approval without putting the client into production.
