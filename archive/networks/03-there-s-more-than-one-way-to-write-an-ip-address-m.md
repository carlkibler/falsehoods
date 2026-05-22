# There's more than one way to write an IP address (ma.ttias.be)

> **Original:** <https://ma.ttias.be/theres-more-than-one-way-to-write-an-ip-address/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

There’s more than one way to write an IP address

There’s more than one way to write an IP address

July 9, 2019

Mattias Geniar

Most of us write our IP addresses the way we’ve been taught, a long time ago: 127.0.0.1 , 10.0.2.1 , … but that gets boring after a while, doesn’t it?

Luckily, there’s a couple of ways to write an IP address, so you can mess with coworkers, clients or use it as a security measure to bypass certain (input) filters.

Not all behaviour is equal \#

I first learned about the different ways of writing an IP address by this little trick.

On Linux:

\$ ping 0 PING 0 (127.0.0.1) 56(84) bytes of data. 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.053 ms 64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.037 ms

This translates the \`\` to 127.0.0.1 . However, on a Mac:

\$ ping 0 PING 0 (0.0.0.0): 56 data bytes ping: sendto: No route to host ping: sendto: No route to host

Here, it translates \`\` to a null-route 0.0.0.0 .

Zeroes are optional \#

Just like in IPv6 addresses , some zeroes (0) are optional in the IP address.

\$ ping 127.1 PING 127.1 (127.0.0.1): 56 data bytes 64 bytes from 127.0.0.1: icmp_seq=0 ttl=64 time=0.033 ms 64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.085 ms

Note though, a computer can’t just “guess” where it needs to fill in the zeroes. Take this one for example:

\$ ping 10.50.1 PING 10.50.1 (10.50.0.1): 56 data bytes Request timeout for icmp_seq 0

It translates 10.50.1 to 10.50.0.1 , adding the necessary zeroes before the last digit.

Overflowing the IP address \#

Here’s another neat trick. You can overflow a digit.

For instance:

\$ ping 10.0.513 PING 10.0.513 (10.0.2.1): 56 data bytes 64 bytes from 10.0.2.1: icmp_seq=0 ttl=61 time=10.189 ms 64 bytes from 10.0.2.1: icmp_seq=1 ttl=61 time=58.119 ms

We ping 10.0.513 , which translates to 10.0.2.1 . The last digit can be interpreted as 2x 256 + 1 . It shifts the values to the left.

Decimal IP notation \#

We can use a decimal representation of our IP address.

\$ ping 167772673 PING 167772673 (10.0.2.1): 56 data bytes 64 bytes from 10.0.2.1: icmp_seq=0 ttl=61 time=15.441 ms 64 bytes from 10.0.2.1: icmp_seq=1 ttl=61 time=4.627 ms

This translates 167772673 to 10.0.2.1 .

Hex IP notation \#

Well, if decimal notation worked, HEX should work too – right? Of course it does!

\$ ping 0xA000201 PING 0xA000201 (10.0.2.1): 56 data bytes 64 bytes from 10.0.2.1: icmp_seq=0 ttl=61 time=7.329 ms 64 bytes from 10.0.2.1: icmp_seq=1 ttl=61 time=18.350 ms

The hex value A000201 translates to 10.0.2.1 . By prefixing the value with 0x , we indicate that what follows, should be interpreted as a hexadecimal value.

Octal IP notation \#

Take this one for example.

\$ ping 10.0.2.010 PING 10.0.2.010 (10.0.2.8): 56 data bytes

Notice how that last .010 octet gets translated to .8 ?

Using sipcalc to find these values \#

There’s a useful command line IP calculator called sipcalc you can use for the decimal & hex conversions.
