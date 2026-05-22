# Falsehoods About the Web

> HTML, URLs, and REST are all weirder than the spec lets on.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A URL can contain itself, recursively, and still be valid.** `https://https:⁄⁄www.netmeister.org@https://www.netmeister.org/https:⁄⁄www.netmeister.org⁄?https://www.netmeister.org=https://www.netmeister.org#https://www.netmeister.org` is a real, working URL — the inner "https" strings are simultaneously a username, a hostname, a directory name, a query key, a query value, and a fragment.

- **IANA has registered 341 URI schemes.** You know `http`, `https`, `ftp`, `mailto`. You probably don't know that `about` is a formally registered scheme, and that `about:dino` launches a hidden dinosaur game in Chrome while `about:surf` gives Edge its own surfing substitute.

- **The fragment (`#`) in a URL is never sent to the server — by design.** Systems like [privatebin.info](https://privatebin.info/) exploit this deliberately: the decryption key lives in the fragment, so the server literally cannot see it even if it wanted to.

- **`https://www.netmeister.org//////////////////` and `https://www.netmeister.org/` go to the exact same place.** Any number of leading slashes in a pathname collapses to root on a Unix filesystem. The server sees different requests; the filesystem resolves them identically.

- **A REST API documented as accepting a 3 MB PNG can still 500 on a 2.9 MB PNG.** Documentation of limits and documentation of actual behavior are two entirely separate things. The same goes for error formats: an API that says it returns JSON errors will, at some point, return an unparseable non-JSON error body.

- **HTML is Turing-complete** — given CSS and user input. No JavaScript required.

- **ePub, the dominant ebook format, uses XHTML.** So "nobody uses XHTML anymore" is false every time someone opens a Kindle book.

- **A favicon can be an animated GIF, a CMYK JPEG, a base64-encoded SVG, a playable arcade game,** or a file whose extension lies about its format (that `.ico` is actually a PNG). One developer spent 20+ hours and 15+ edge cases discovering this while writing what looked like a two-hour script.

- **A port field in a URL can be zero-padded to absurd lengths and is still valid.** RFC 3986 sets no maximum on the port string, making `https://www.netmeister.org:000000000000000000443/` a conforming URL.

---

## Where It Gets Complicated

### HTML Parsing and the "Standard"

HTML is not XML, and it never quite was. The `<li>` and `<p>` tags have implicit closing tags. `<img>` and `<input>` are self-closing. `<br>` and `<hr>` don't even need the self-close slash — and that slash is actively discouraged in HTML5. XHTML required it; HTML does not; they are different languages that look almost identical.

The HTML spec is not a fixed document. It is a **Living Standard** maintained by WHATWG, which is effectively the browser vendors. It has a visible "last changed" timestamp and can shift under you. It also doesn't stand alone: many HTML features are defined as JavaScript classes in companion DOM and JavaScript specifications.

There is not one doctype. There is not two. There are many, spanning HTML 1 through 4, XHTML variants, and HTML5 — and real websites in production use all of them, including HTML2 and HTML3.

### The DOM and the Browser

The claim that "modifying the DOM is slow" is largely React-era propaganda. The DOM is one of the most battle-hardened data structures in existence; browsers have spent decades optimizing it. The browser itself is not just an HTML parser — it is simultaneously a JavaScript runtime, a layout engine, a GPU-accelerated graphics toolkit (WebGL, font rendering), and effectively a small operating system with filesystem APIs, audio output, and more.

WebAssembly will not replace HTML and JavaScript. They occupy different niches: you cannot build an accessible, universally openable web page in WebAssembly alone.

SEO does not require a framework. Semantic HTML is trivially parseable by crawlers; JavaScript-generated markup is not. The complexity frameworks add often hurts, not helps.

### URL Schemes

The scheme (often called "the protocol," incorrectly — it describes the URL structure, not necessarily the wire protocol) is just the beginning of the weirdness. `http` and `https` are two of 341 registered URI schemes. Protocol-relative links like `//neverssl.com/` inherit whatever scheme the current page used — which on an HTTPS-enforcing page creates an obvious problem.

### Userinfo: The Phishing Component

After `//`, a URL can contain `username:password@` before the hostname. This is deprecated for HTTP authentication but still partially supported. Chrome strips it before sending the request; Firefox prompts the user. What the URL contains and what the client sends to the server are different things — Wireshark will show you that `curl` converts `jschauma:hunter2@www.netmeister.org` into an `Authorization: Basic anNjaGF1bWE6aHVudGVyMg==` header, not a literal credential in the URL.

The attack surface is obvious: `http://accounts.google.com:signin@evil.example.com` looks trustworthy. The real hostname is `evil.example.com`; everything before the `@` is a username and password.

### Hostnames Are Not What You Think

A hostname in a URL doesn't have to be a fully-qualified domain name. It can be:
- A partial hostname resolved via `/etc/resolv.conf` search domains (companies use this for internal `go/` link shorteners — `go/nuts` resolves to `go.example.com/nuts` if `search example.com` is in resolv.conf)
- A bare IPv4 address: `https://166.84.7.99/`
- An incomplete IPv4 address: `http://172.217.78` or `http://1.1`
- A fully decimal address: `http://2790524771`
- An IPv6 address in brackets: `https://[2001:470:30:84:e276:63ff:fe72:3900]/`

Let's Encrypt does not issue certificates for bare IP addresses. Other CAs do. `https://8.8.8.8` works.

The port field can be blank (`https://www.netmeister.org:/blog/urls.html` is valid), zero-padded arbitrarily, or omitted entirely to use the scheme default.

### Pathnames: Unix All the Way Down

The pathname component follows filesystem rules when the server is Unix-based — which means all the Unix edge cases follow you into URLs:

- Dot-segment resolution (`.` and `..`) happens **before** filesystem lookup per RFC 3986. You can `../` through directories that don't exist and still land on a real file. `curl -I https://www.netmeister.org/t/h/e/s/e/../../../../../blog/urls.html` returns HTTP 200.
- Directories can be named with spaces. `https://www.netmeister.org/blog/urls/%20/f` and `https://www.netmeister.org/blog/urls/ /f` (with a literal space) serve the same file from a directory literally named `" "`.
- Directories can be named `💩`. That's a valid URL path segment.
- Files can be named with Morse code: `https://www.netmeister.org/blog/urls/– -.– -. .- – . .. … – — .-. … . -.-. — -.. . …-.-/f`
- The `~username` expansion to `public_html` is **pure convention** — no RFC specifies it. Apache's behavior is also surprising: if `username` is a valid system user, it looks for `~username/public_html` even if that directory doesn't exist and a file named `~username` does exist in the document root. If `username` is *not* a valid user, normal path resolution happens, so a file named `~notauser` in the document root *will* be served.
- Path length limits are OS-specific. Individual segments max out at 255 characters (FFS_MAXNAMLEN); full paths hit PATH_MAX = 1024. Beyond that, Apache returns 404, but this is implementation-specific behavior, not spec behavior.

### Query Strings and Fragments

The query component (after `?`) is essentially undefined. The `key=value&key2=value2` convention is just that — a convention. The separator was historically also `;` in some systems. The query can contain `/` and `?` characters. `https://www.netmeister.org/blog/urls.html??????//?????` is valid.

The fragment (after `#`) is a client-side-only concept. HTTP clients strip it before sending requests. Apache returns 400 Bad Request if a `#` appears in the Request-URI; `bozohttpd` does not — it serves a file literally named with `#` in it. Neither behavior is mandated by RFC 2616.

### REST API Documentation Is Fiction

Every one of these assumptions is wrong:

**About documentation:** The person calling your API may not know what your product does. Jargon in the UI is often different from jargon in the API. If the docs say "valid values for POSTing to B can be found by GETting A," that does not mean all values from A will work with B.

**About errors:** A 20x response does not guarantee success. An API documented as returning JSON errors will, at some point, return a non-JSON error. Rate limit error formats are frequently undocumented. Not all emitted error codes appear in the docs.

**About versioning:** Breaking changes will not be confined to version boundaries. Features will disappear from version N when version N+1 ships. Announcements of breaking changes will sometimes be a full documentation dump in a PDF format with invisible whitespace characters inserted between letters, making diffing impossible.

**About bug reports:** An official acknowledgment that something is a bug does not mean it will be fixed. Sometimes the fix is "we're removing the feature in the next version" — and the old version's docs will not be updated to reflect this.

**About the catch-22:** If your client requires approval to use restricted features, you may be unable to get that approval without first putting the client into production.

### Favicons: A Case Study in Underestimated Complexity

Downloading the small icon in a browser tab looks like a one-liner. It is not. A production favicon fetcher must handle:

- 404 on the linked icon → fall back to `/favicon.ico`
- DNS failure, broken SSL, invalid certificates
- Sites that work on `www.example.com` but not `example.com` (and vice versa)
- Redirect loops when requesting an icon without a referrer header
- CDN or load balancer returning *different* favicons on successive requests
- Files whose extension lies: a `.ico` that is actually a PNG
- CMYK images that must be converted to RGB
- SVGs that must be rasterized
- Animated GIFs (yes, really)
- Corrupt downloaded files
- Non-square favicons
- Transparent pixels in GIF or alpha channels in PNG
- Favicons that are dynamically generated by JavaScript — one example, [p01.org/defender_of_the_favicon](http://www.p01.org/defender_of_the_favicon/), renders a playable arcade game in the favicon
- Multiple sizes per the HTML spec
- Apple, Android, and defunct Windows Mobile app icon meta tags as additional fallback locations

Valid link `rel` values include `.ico`, `.gif`, `.png`, `.jpg`, `.svg`, `.tiff`, and base64-encoded data URIs of any of those formats.

---

## If You Build This

1. **Never trust the URL you receive to be what the client sent.** Chrome strips userinfo before the request. `curl` converts it to a Basic Auth header. Apache ignores scheme and authority in the Request-URI. What arrives at your server may bear little resemblance to what the user typed.

2. **Normalize URLs before comparing or storing them.** `https://example.com`, `https://example.com/`, and `https://example.com//` are the same resource on most Unix servers but distinct strings. Dot-segment resolution must happen before any comparison. Use a proper URL parsing library (Python's `urllib.parse`, Go's `net/url`, Rust's `url` crate) — do not roll your own.

3. **When building or consuming a REST API, treat the documentation as a starting hypothesis.** Test every error path. Test what happens when you exceed documented limits. Test what the response body looks like when the API is rate-limited or returning a gateway error — it will often not be the documented JSON format.

4. **Write semantic HTML and skip the framework for content-heavy pages.** Crawlers index plain HTML directly; they execute JavaScript poorly or not at all. If SEO matters, `<article>`, `<nav>`, `<h1>` hierarchy, and `<meta>` descriptions will outperform a React app with no SSR every time.

5. **For anything that fetches remote resources (favicons, OpenGraph images, RSS feeds), build for failure from the start.** Plan for DNS failure, redirect loops, wrong content types, corrupt files, and format lies. Set aggressive timeouts. The happy path is a minority of real-world traffic.

6. **The fragment is your only truly private URL component.** If you need to pass a secret through a URL without the server seeing it — a decryption key, a one-time token — put it in the `#fragment`. Browsers and `curl` strip it before sending the request. (Caveat: browser history, referrer headers on navigation, and JavaScript `location.hash` all still expose it client-side.)

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about HTML (aartaka)](https://www.aartaka.me.eu.org/falsehoods-html) · [archived copy](../archive/web/01-falsehoods-about-html-aartaka.md)
- [Falsehoods about REST APIs (slinkp)](http://slinkp.com/falsehoods-programmers-believe-about-apis.html) · [archived copy](../archive/web/02-falsehoods-about-rest-apis-slinkp.md)
- [URLs: It's complicated… (netmeister)](https://www.netmeister.org/blog/urls.html) · [archived copy](../archive/web/03-urls-it-s-complicated-netmeister.md)
- [The Hidden Complexity of Downloading Favicons (simplecto)](https://www.simplecto.com/complexity-downloading-favicons-told-in-15-plus-edge-cases/) · [archived copy](../archive/web/04-the-hidden-complexity-of-downloading-favicons-simp.md)
