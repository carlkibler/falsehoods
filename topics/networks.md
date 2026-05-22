# Falsehoods About Networks

> The network is not reliable, an IP address has many spellings, and DNS is not what you think.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **`ping 167772673` reaches `10.0.2.1`.** An IPv4 address isn't just four dotted octets — it can be written as a single decimal integer, hex (`0xA000201`), leading-zero octal (`012` = decimal 10), or with omitted octets (`127.1` → `127.0.0.1`). Input filters that block `10.0.2.1` may pass `167772673` right through.

- **`ping 0` pings `127.0.0.1` on Linux — and `0.0.0.0` (a null route) on macOS.** The same input produces entirely different behavior across OSes. The "obvious" form of an IP address is platform-dependent.

- **You can replace every character in `curl.se` with Unicode lookalikes and the request still succeeds.** IDN normalization maps Mathematical Monospace Small C (U+1D68C), Halfwidth Ideographic Full Stop (U+FF61), and thirteen other variants of the letter 'c' alone back to ASCII — silently, before DNS ever sees them. The letter 'c' has at least 15 Unicode variants that all normalize to ASCII 'c'.

- **A Unicode question mark can hijack a URL's hostname.** The Latin Capital Letter Glottal Stop (U+0241) looks like `?` in most fonts. `curl https://google.com?.fake.com` resolves to `google.xn--com-sqb.fake.com` — not Google. HTTPS doesn't save you; nothing stops an attacker from getting a valid cert for that punycode domain.

- **`send()` returning success does not mean all your data was sent.** Robert Graham's packet sniffers have caught this in production: partial BASE64 lines appear at email gateways because programmers assume `send()` is all-or-nothing. iPhones continued using expired DHCP leases until 2010 — visible on the wire to anyone sniffing.

- **The Fallacies of Distributed Computing were formalized in 1994 — and engineers are still writing code that violates all eight.** They accreted at Sun Microsystems: Bill Joy and Tom Lyon framed the first four, and L. Peter Deutsch consolidated and published a list of seven around 1994 — the network is reliable; latency is zero; bandwidth is infinite; the network is secure; topology doesn't change; there is one administrator; transport cost is zero. James Gosling added the eighth in 1997: the network is homogeneous. Deutsch later added a ninth — "the party you are communicating with is trustworthy."

- **Zero-width spaces (U+200B) are silently stripped from domain names.** `cu%e2%80%8brl.se` resolves to `curl.se`. You can scatter invisible characters throughout a URL and it still works — making malicious URLs that are byte-for-byte different from what they appear to be.

- **NAT does not block inbound attacks.** It reduces the attack surface by not forwarding unsolicited packets, but it is not a firewall, and treating it as one leaves real holes. Similarly, VLANs are not equivalent to physical network segmentation, despite being widely deployed as if they were.

---

## Where It Gets Complicated

### TCP Is Not What You Think

TCP gives you a reliable, ordered byte stream — but the abstractions leak in ways that burn engineers repeatedly.

**Segment boundaries are simultaneously meaningful and not meaningful.** The application cannot assume that one `write()` on the sender corresponds to one `read()` on the receiver — TCP can coalesce or split segments freely. Yet some code (particularly legacy protocol parsers) implicitly expects segment boundaries to align with message boundaries. Both assumptions are wrong in different contexts.

**`send()` can succeed partially.** On a blocking socket, `send()` may return having written fewer bytes than requested. The correct pattern is a loop that checks the return value and continues from where the previous call left off. Graham's team has seen the evidence of this bug in BASE64 email streams captured on the wire.

**TCP RSTs don't necessarily come from the endpoint you think.** Middleboxes — firewalls, load balancers, intrusion detection systems — inject RST packets. Code that trusts a RST as a definitive signal from the peer is mistaken.

**Stateful firewalls time out.** A TCP connection left idle long enough will have its state entry evicted from the firewall's table. Sending data on that socket an hour later may silently fail or be dropped, even if both endpoints still consider the connection open.

### IP Addresses Are Slippery

**One address, many spellings.** `10.0.2.1` is also `167772673` (decimal), `0xA000201` (hex), `10.0.513` (overflowed octet — 513 = 2×256+1), `10.50.0.1` (from `10.50.1` with zero-fill), and more. Security filters that normalize on the dotted-decimal form are bypassable.

**The MTU is not always 1500 bytes.** It is 1500 on standard Ethernet, but PPP links, VPNs, tunnels, and jumbo-frame configurations all change it. Code that hardcodes 1500 will silently corrupt or fragment traffic on non-standard paths.

**RFC 1918 addresses collide.** If you pick `10.x.x.x` for your internal network and later VPN into a partner who also picked `10.x.x.x`, routing breaks in confusing ways. Edge routers that neither filter outbound RFC 1918 packets nor reject inbound ones with RFC 1918 source addresses compound the problem.

**`127.0.0.1` is not the only loopback address.** The entire `127.0.0.0/8` block is loopback. Similarly, `169.254.0.0/16` (link-local) is not just a curiosity: devices use it for APIPA when DHCP fails, and hardcoding any address in that range into a stack or config is a mistake.

**The IPv4 header is not always 20 bytes.** It starts with `0x45` only when there are no options. The options field exists and is used; code that assumes the header is always 20 bytes will misparse packets.

**MAC addresses are not reliably unique.** Manufacturers have shipped hardware with duplicate or unregistered OUI prefixes. The same applies to cell tower IDs. In virtual environments, MAC addresses are often software-assigned and may collide. A MAC address tells you nothing reliable about whether you're in a VM.

### DHCP and Network Identity

**DHCP leases expire.** iPhones kept using expired DHCP addresses until 2010 — visible to anyone with a packet sniffer. The address will not necessarily survive a reboot, will not necessarily last until the next reboot, and may be reassigned to a different device mid-session.

**The DHCP server and the default gateway are not the same device.** In many enterprise and home setups they happen to be the same box, but this is an implementation detail, not a protocol guarantee.

**You don't know what's on your own network.** Rogue access points, unregistered devices, and shadow IT mean the set of devices attached at any moment is larger and stranger than the asset register suggests. Network interface names, MAC addresses, and interface ordering are not stable across reboots in all environments.

**There is no IPv6 on my network** is almost certainly false. Modern operating systems enable IPv6 by default, and link-local IPv6 addresses appear on interfaces even without a configured IPv6 prefix. Traffic you think is IPv4-only may have an IPv6 path you haven't accounted for.

### DNS and Naming

**DNS is not a simple lookup.** Resolvers have their own caching behavior that varies by implementation: some round-robin servers, some always pick the first, some cache aggressively, some re-query before TTL expiry. None of these behaviors are guaranteed to be consistent across client OSes.

**IDN homograph attacks are not just a browser problem.** Browsers show punycode when they detect mixed scripts, but command-line tools like curl do not have a URL bar. A carefully crafted URL using visually identical Unicode characters can route a `curl | sh` pipeline to an attacker's server while appearing to fetch from a trusted one. HTTPS and a valid certificate do not prevent this — the attacker just needs to register the punycode domain and get a cert for it.

**IDN heterograph attacks work the other way too.** Unicode characters that *look* different may normalize to the *same* ASCII name. A user typing what appears to be a different domain may end up at the same destination — useful for bypassing HSTS or other domain-keyed security controls.

**The Fraction Slash (U+2044) looks like `/` but is not.** In a URL, it becomes part of the hostname. `https://google.com/.curl.se` with a fraction slash resolves to `google.xn--com-qt0a.curl.se`. The Viewdata Square (U+2317) mimics `#` similarly.

### Security Assumptions That Aren't

**"Internal" does not mean "safe."** Being inside a perimeter firewall does not give total control — lateral movement, rogue devices, and misconfigured VLANs all undermine the assumption. Internal web apps are discoverable by outsiders through DNS leakage, certificate transparency logs, and search engine caches.

**Encrypted data can still be altered.** Encryption without authentication (integrity protection) is malleable — an attacker can flip bits in ciphertext and produce predictable changes in plaintext. TCP checksums and Ethernet CRCs detect accidental corruption but are not cryptographic; they don't stop deliberate tampering.

**Source address checking is not sufficient security.** IP source addresses are trivially spoofable on networks that don't implement BCP 38 (ingress filtering). Packets arriving from "surprising" sources with "surprising" source addresses are not impossible — they're routine on the open internet.

**ICMP blocking breaks things.** Blocking all ICMP for "security reasons" breaks Path MTU Discovery, which relies on ICMP Type 3 Code 4 (Fragmentation Needed) messages. Similarly, blocking all non-TCP/UDP/ICMP traffic breaks protocols that legitimate applications depend on.

### Distributed Systems Assumptions

The eight Fallacies of Distributed Computing, assembled at Sun Microsystems — seven published by Deutsch around 1994, the eighth added by Gosling in 1997 — remain the canonical list of what engineers get wrong at scale:

1. **The network is reliable** — it isn't; design for partial failure.
2. **Latency is zero** — it isn't; unbounded traffic assumptions cause dropped packets.
3. **Bandwidth is infinite** — it isn't; senders who ignore limits create bottlenecks.
4. **The network is secure** — it isn't; malicious actors continuously adapt.
5. **Topology doesn't change** — it does; route changes affect both latency and bandwidth.
6. **There is one administrator** — there isn't; rival subnet admins institute conflicting policies.
7. **Transport cost is zero** — it isn't; hidden build-and-maintain costs must appear in budgets.
8. **The network is homogeneous** — it isn't; mixed hardware, OS, and protocol stacks are the norm.

Deutsch later added a ninth: **the party you are communicating with is trustworthy** — an extension of the security fallacy beyond the physical network boundary.

In 2020, Mark Richards and Neal Ford added three more for modern distributed systems: **versioning is simple**, **compensating updates always work**, and **observability is optional**.

---

## If You Build This

1. **Loop on `send()`.** Never assume a single call delivers all bytes. Check the return value and resume from the offset. The evidence that this is broken in production is on the wire, in email gateways, right now.

2. **Normalize IP addresses before comparing or filtering them.** Parse to a canonical binary representation first. The string `10.0.2.1`, the integer `167772673`, the hex `0xA000201`, and the overflowed `10.0.513` are the same address. Use a proper IP parsing library — not string matching.

3. **Normalize and validate IDN inputs before any security decision.** Run domain names through IDN/Punycode normalization (IDNA 2008 or UTS#46) before comparing against allowlists, HSTS records, or certificate pinsets. Treat the punycode form as the canonical form. Be aware that zero-width spaces and confusable characters can make two strings look identical while being byte-for-byte different — or look different while being semantically identical.

4. **Never hardcode DHCP-assigned addresses.** Leases expire. Addresses change between reboots, mid-session, and mid-lease. If you need a stable address, assign it statically or use a service-discovery mechanism. Add things to DNS.

5. **Design for the Fallacies.** Add timeouts and retries with backoff on every network call. Instrument everything — observability is not optional. Assume topology changes, assume multiple administrators with conflicting policies, assume latency is non-zero and variable. Applications that stall indefinitely waiting for a network response are exhibiting Fallacy 1 in production.

6. **Do not treat NAT, VLANs, or perimeter firewalls as security boundaries.** They reduce exposure; they do not eliminate it. Authenticate and authorize at the application layer regardless of network position. Assume the internal network contains devices you don't know about and traffic you haven't anticipated.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [Falsehoods about Networks (Errata Security)](http://blog.erratasec.com/2012/06/falsehoods-programmers-believe-about.html) · [archived copy](../archive/networks/01-falsehoods-about-networks-errata-security.md)
- [Fallacies of Distributed Computing (Wikipedia)](https://en.wikipedia.org/wiki/Fallacies_of_distributed_computing) · [archived copy](../archive/networks/02-fallacies-of-distributed-computing-wikipedia.md)
- [There's more than one way to write an IP address (ma.ttias.be)](https://ma.ttias.be/theres-more-than-one-way-to-write-an-ip-address/) · [archived copy](../archive/networks/03-there-s-more-than-one-way-to-write-an-ip-address-m.md)
- [IDN is crazy (Daniel Stenberg)](https://daniel.haxx.se/blog/2022/12/14/idn-is-crazy/) · [archived copy](../archive/networks/04-idn-is-crazy-daniel-stenberg.md)
