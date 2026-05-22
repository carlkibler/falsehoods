# Falsehoods about Networks (Errata Security)

> **Original:** <http://blog.erratasec.com/2012/06/falsehoods-programmers-believe-about.html>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Errata Security: Falsehoods programmers believe about networks

Monday, June 18, 2012

Falsehoods programmers believe about networks

Inspired by falsehoods programmers believe about time and usernames , I thought I’d start collecting falsehoods programmers have about networks. Data on the network cannot be altered.

Encrypted data on the network cannot be altered.

Data cannot be accidentally corrupted, because TCP has checksums and Ethernet has CRCs

If it’s inside my perimeter firewall, that means I have total control over it (@armorguy)

If it doesn’t return an error, then send() sent all the data that was asked of it.

Packets arrive in the order in which they were sent.

Segment boundaries on a TCP stream are meaningful to the application.

Segment boundaries on a TCP stream are not meaningful to the application.

If you can’t ping the target, then it doesn’t exist. (@jjarmoc)

If you can ping the target, then it does exist.

TCP RSTs come from end-nodes.

Bytes must be “swapped” from the network byte-order to the host CPU byte-order.

It’s an internal web app – outsiders won’t be able to discover where it is (@biosshadow)

The DHCP address will be the same after a reboot (@shewfig)

The DHCP address will remain the same until the next reboot.

Well, it’ll last a long time between changes

Packets/PDUs go up or down the network stack, never sideways. (@maradydd)

The IPv4 header is 20 bytes long starting with 0x45 (options are so rare we don’t have to worry about them) (@shewfig)

The DHCP server and local router are the same (@schrotthaufen) What’s fun is that you can see these errors happen by monitoring packets,

I started this list for programmers, but we inevitably drifted outside programmers to network administrators. It’s hard to draw the line, because some misconceptions are shared by both. There is no IPv6 on my network (@shewfig)

NAT automatically blocks all inbound attacks (@shewfig)

We know all the devices attached to our network at any given time (@armorguy)

VLANs are just as good as physical segmentation. (@jjarmoc)

Ok, VLANs aren’t as good, but they are good enough for now.

We have good WIPS/monitors, so we don’t have rogue access-points anywhere. (@armorguy)

No need to add it to the DNS; I’ll remember it. (@shewfig)

By Robert Graham

11 comments:

Mark Atwood said…

Source address checking is sufficient security. The local network has zero latency and infinite bandwidth. Packets are never duplicated. Duplicated packets are never corrupted. My edge routers won’t try to route out RFC1918 address packets. My edge routers won’t accept packets with RFC1918 addresses. The RFC1918 addresses I pick for this network will never collide with any other network that it may connect to or VPN to. The MTU is always 1500 octets. The MTU is never more than 1500 octets. Putting raw IPv4 addresses into higher layer content (such as URLs in web pages) is okay. The DNS resolver in the end node will round robin DNS servers. The DNS resolver in the end node will always pick the first DNS server. The DNS resolver in the end node will never repeat a query until it’s cache times out. The DNS resolver in the end node will cache queries. TCP connections will have *some* traffic at least every minute/hour/day/week. Packets coming from the local router with a from address of the local net are never valid. Packets coming from “surprising” sources with “surprising” From addresses are never valid. Nothing important is using multicast. I can block ICMP for “security reasons” without breaking anything important. I can block all packet types except ICMP, UDP, and TCP, for “security reasons”, without breaking anything important. I can block all ethernet packet types except for IPv4 without breaking anything important. The only address ever used in 127/8 is 127.0.0.1 Nobody uses 169.254/16 for anything important. 169.254/16 isn’t special. The same device will always get the same 169.254/16 address. I can hardcode a 169.254/16 address into my IP stack or configuration. What is this 169.254/16? Nobody uses dialup PPP anymore. Especially not over an expensive sat link. Ethernet MAC addresses are *always* unique. I can tell if I’m in a VM container by looking at the local interface’s MAC address. No manufacturer of Ethernet hardware has ever just made up a prefix without registering with the IEEE. No manufacturer of Ethernet hardware has ever just stolen someone else’s prefix. The same goes for manufacturers of cell phone towers. They would NEVER use a duplicated or unregistered tower ID. The network interfaces on an end node will always come up in the same order, with the same names and numbers, with the same MAC addresses, connected to the same networks, every time the node boots up. A network interface always has a unique MAC address. Or at least some sort of globally unique layer 2 address. Or at least some sort of locally unique layer 2 address. Or some sort of address at all?

11:20 PM

RPM said…

Unfortunately, the list of stupid things network guys think about systems or code would be much, much longer. Networking is, in reality, orders of magnitude less complex than server operating systems or applications. Dijkstra’s algorithm and gossip protocols are not complicated. Networks are way too expensive and slow and haven’t kept up with the rest of the industry.

12:07 AM

Anonymous said…

-1 ? Ha. Ha.

6:30 AM

Unknown said…

Just what we need, more ‘engineering discipline warfare’. How about everyone just show each other a little mutual respect. Oh, this was a joke? I swear, I can’t find the punchline - Because there is none. It is just somebody bashing programmers as if they are all the same. That is called stereotyping, which I could easily do about ‘networking guys’. I agree with RPM. Maybe this is funny to those who wish they could be a programmer, I dunno.

6:35 AM

Robert Graham said…

To Jeremy Collake: This isn’t about bashing programmers. It’s about putting a sniffer on the wire and noticing common mistakes. Non-programmers spend an enormous amount of time debugging why networks don’t work, which is why they come to the realization that so many programmers believe falsehoods about how networks work. For example, monitor any email gateway and you’ll notice that programmers widely believe that “send()” either succeeds/fails, because you’ll sometimes see partial lines in the BASE64 data – a clear indication that send() didn’t send all the data it was asked. If we didn’t see such failures so often in network traffic, we wouldn’t believe that programmers believed in such falsehoods.

2:37 AM

Noah Sussman said…

This comment has been removed by the author.

8:20 AM

Noah Sussman said…

Wrt Jeremy Collake’s comment, the intent of posts like this one is to remind all of us that although the systems we work on are complex, the causes of severe failures often turn out to be a combination of several simple errors, interacting in an unexpected way. The fact that smart people tend to get bitten by simple mistakes imho a fascinating topic of research and not just in the computer world – see The Checklist Manifesto for an examination of this phenomenon in the worlds of aviation, restaurant cooking and surgery. Anyway, checklists of common errors – like this one – help me to remember to be appropriately humble when I design and debug systems. Also ” the DHCP address will remain the same until the next reboot. ” I used to believe the same things about IP addresses :-(

8:21 AM

Unknown said…

I can leave a TCP stream open and send data to that socket an hour after opening it and expect the stateful firewall to let it through…

10:43 AM

Unknown said…

I will agree that we often have issues because of the multitude of engineering disciplines the tech field has diverged into, and their interoperability. And, yes, members of each respective discipline often don’t fully grasp the fundamentals of other disciplines. However, it goes in *all* directions… I dunno, I just didn’t find it funny I guess, and personally do NOT make these assumptions. Most of these assumptions are real bone-head stuff, like assuming a DHCP acquired network address won’t expire? Really? Who would make that assumption? In fact, I’ve seen NETWORKING GUYS make many of these assumptions. E.G. Blocking all ICMP traffic. Any good programmer surely knows enough about networking to NOT make MOST ALL of these assumptions. That said, there are a lot of bad programmers, and a lot of bad networking guys too. I’ve met plenty of BOTH.

9:52 PM

Robert Graham said…

I think people are missing the point. We see these errors in open-source code, and more importantly, on the wire with packet-sniffers. Arguing that they don’t exist or that “good programmers would never make these mistakes” is futile in the face of overwhelming evidence that such errors exist. We know programmers assume DHCP IP addresses are still valid because we put a packet-sniffer on the wire and see IP addresses continue to be used after the DHCP lease has expired. Indeed, iPhones had that bug until 2010.

12:42 PM

Brent said…

This comment has been removed by a blog administrator.

12:48 PM

Post a Comment

Newer Post Older Post Home

Subscribe to: Post Comments (Atom)
