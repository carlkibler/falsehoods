# Falsehoods About Multimedia

> Video and music metadata break every clean assumption you bring to them.

**[Sources & credits ↓](#sources)**

## The Big Surprises

- **A file can be simultaneously a legal JPEG and a legal MP3.** This isn't a bug or a corruption artifact — it's an inherent consequence of how both formats are structured. Your heuristic-based filetype detection is already wrong.

- **H.264 hardware decoding silently degrades your video.** Even though H.264 decoding is theoretically bit-exact, APIs like DXVA2, D3D11VA via ANGLE, and VDPAU will post-process the decoded frames before you can touch them — converting to RGB, dropping chroma subsampling, or rounding 10-bit content down to 8-bit. You asked for a decoder; you got a pipeline.

- **A track can be 4,723 hours, 54 minutes, and 37 seconds long.** Bull of Heaven's *209: Blurred With Tears And Suffering Beyond Hope* is a real, catalogued release. Your duration field is not a `short`.

- **Tchaikovsky has 31 different names on MusicBrainz.** Пётр Ильич Чайковский is a real internationalisation stress-test, not a hypothetical. If your system stores "one canonical artist name," you've already lost.

- **Frame timestamps are not guaranteed to be monotonically increasing — even if you haven't seeked.** Modern container formats including MKV can and do produce non-monotonic timestamps in normal, uninterrupted playback.

- **Aphex Twin has a track literally named ∆Mᵢ⁻¹=−α ∑ Dᵢ[η][ ∑ Fjᵢ[η−1]+Fextᵢ [η⁻¹]].** That is the track title. Store it, search it, sort it, and display it correctly. Good luck.

- **Nine Inch Nails' *Broken* has 99 tracks, most of which are 4 seconds of silence.** Tracks 7 through 97 are silent placeholders. Your "skip silence" logic and your track-count assumptions both fail here.

- **A song called X5O!P%@AP[4(P^)7CC)7}$`EICAR-STANDARD-ANTIVIRUS-TEST-FILE!`$H+H\* exists and is a real release.** Laughing Mantis named a track after the EICAR antivirus test string. Your antivirus may helpfully delete your music library's metadata.

- **The video's color space, resolution, frame rate, and even codec can all change mid-stream.** These are not theoretical edge cases — they are valid in multiple container formats and you must handle them.

- **There is no ASS subtitle specification.** The subtitle format used by the majority of fansub releases has no authoritative spec. Whatever you implement, you're guessing.

---

## Where It Gets Complicated

### Decoding Is Not Neutral

The assumption that a decoder is a transparent window onto the bitstream is wrong in practice, even when it's true in theory.

H.264 is indeed bit-exact by spec, but hardware decoder APIs (DXVA, DXVA2, D3D11VA through ANGLE, CrystalHD, VAAPI through GLX, VDPAU) intercept the output and may convert it to RGB, alter chroma subsampling, or silently truncate 10-bit content to 8-bit before you ever see it. The only currently safe paths are VAAPI EGL interop and CUDA — and both require copying back to system RAM, adding round-trip bandwidth cost.

Not all H.264 decoders can decode all H.264 files — this applies to both hardware and software decoders. Hardware decoding is not always faster than software decoding. Video decoding is not trivially parallelizable.

### Timing Is a Fiction You Agree to Believe

The display clock, the audio clock, and the video file's timestamps are three separate things that are never perfectly synchronized and cannot be perfectly measured.

- The display refresh rate is not guaranteed to be an integer multiple of the video frame rate.
- You cannot accurately measure either the display clock or the audio clock.
- Frame timestamps are not guaranteed to be monotonically increasing, not guaranteed to be unique, and not guaranteed to be precise — even in modern formats like MKV.
- The duration of the final video frame is not always known.
- Seeking to a position does not necessarily produce the same output as decoding to that position from the start. You cannot seek to a specific frame number in the general case.
- Videos do not have a fixed frame rate — the frame rate can change mid-stream.
- Adjacent frames are not guaranteed to have similar durations.

Hardware contexts can disappear mid-playback (your user's screensaver kicked in, the display was unplugged). You cannot always request a new one after the old one vanishes. Silently erroring and quitting is the wrong response.

### Pixel Formats Are a Combinatorial Explosion

Start with the assumption that video is 8-bit RGB and you're already wrong in at least five directions simultaneously.

- Bit depth: video can be 8, 10, 12, or more bits per channel, and different channels in the same frame can have different bit depths.
- Samples per pixel: not always 3, not always 3 or 4, not always *n* — the model of "pixels have a fixed number of samples" breaks down.
- Chroma subsampling: 4:2:0 is not the only option. Chroma location within a 4:2:0 block is not standardized — it differs between file types.
- Color range: "TV range" and "full range" YCbCr are different things. Full-range YCbCr does exist. Standards bodies cannot agree on what full-range YCbCr means. An 8-bit full-range value of 255 does not simply map to float 1.0. TV-range YCbCr is not the same as TV-range RGB.
- Interlacing: interlaced video still exists. You cannot reliably detect whether a file is interlaced from its metadata alone.

### Color Spaces Are Not Simple

There is not one RGB color space. There is not one YCbCr color space per RGB color space. An RGB triple does not unambiguously specify a color. An RGB triple plus primaries does not unambiguously specify a color. Even a CIE XYZ triple does not unambiguously specify a color (observer metamerism).

BT.601 and BT.709 are visibly different — users notice. There is also not just one BT.601. Not all HD video is BT.709. Color space, pixel format, resolution, and frame rate can all change mid-stream independently.

"Linear light" does not mean one thing. HDR encoding is not simply about making images brighter or blacker. PQ and HLG are not straightforwardly interconvertible, even when you know the mastering display metadata. HDR metadata is not guaranteed to match the video stream. Converting A→linear→B does not give the same result as converting A→B directly. Converting A→B is not the inverse of B→A in the general case.

Not all ICC profiles contain tables for conversion in both directions. Not all CMMs implement color conversion correctly — including professional ones. Dithering is required even when the target color space has the same or higher bit depth. Converting between bit depths is neither a simple logical shift nor a simple multiplication.

### Display Hardware Assumptions

- Not all displays are 60 Hz. Not all refresh rates are integers. Not all displays have a fixed refresh rate.
- Not all displays are sRGB, or even approximately sRGB.
- Not all displays have square pixels, a D65 white point, or 8-bit color.
- Not all displays have a contrast of ~1000:1; some have infinite contrast (OLED), some far less.
- vsync timings are not consistent even at a fixed refresh rate. Two displays with the same refresh rate do not vsync at the same time.
- Users will use multiple displays simultaneously, and may move a video window between them mid-playback.
- OpenGL is not well-supported on all operating systems. Waiting for vsync in OpenGL is not simple. Video drivers do not always correctly implement the texture formats they advertise.

### Artist and Album Names Are Not Strings You Can Reason About

The assumption that an artist or album name is a well-behaved Unicode string that fits in a filename and has one canonical form is wrong at every level.

**Symbols as names:** Prince released *Love Symbol* under a name that was literally an unpronounceable glyph — and changed his stage name to that symbol in 1993. Justice's album is titled †. David Bowie's is ★. Sigur Rós released an album called (). Caravan Palace released `<|°_°|>`. A band exists whose name is `!!!`. Another is `A`. Another is `The The` — good luck with your "strip leading articles" normalization.

**Filesystem hostility:** MASTER BOOT RECORD names their albums after things both Windows and Linux dislike. The You Suck Flying Circus released `///////-//-/////` on Linux. Marco.V has a track named `C:/del*mp3`. Auto!Automatic!!'s *Another Round Won't Get Us Down* contains tracks named `\` and `//////////`.

**Unicode edge cases:** Spın̈al Tap uses a dotless i and a genuine n-diaresis (not n + combining umlaut). Magma's Kobaïan language uses custom diacritics that don't exist in UTF-8. KEYGEN CHURCH released albums titled `░█░█░░█░█░█░` and `░ ▒ ▓ █`. Coldplay's *Music of the Spheres* uses emoji as track titles.

**Long names:** Fiona Apple's album title is a 90-word sentence. Bring Me the Horizon released an album whose title is a 30-phrase tilde-separated list. Eximperituserqethhzebibšiptugakkathšulweliarzaxułum released an album whose title runs to several hundred characters in Belarusian.

**Empty or null names:** Rammstein, Led Zeppelin, and KoЯn all released untitled albums. Aphex Twin's *Selected Ambient Works Volume II* has tracks with no titles. Autechre's *EP7* has an untitled track in the pregap and a track explicitly named "Left Blank." A band called `brouillard` has a single member called `brouillard`, every album named `brouillard`, and every track named `brouillard`.

### Artist Identity Is Not One-to-One

One artist name does not map to one artist. "Emperor" could be: the Norwegian black metal band, a drum'n'bass producer, a trance artist, a Japanese metal band (originally named Rommel, not to be confused with the other Rommel from Japan), or a virtual penguin hip-hop artist from the game *Arknights*. There are eight distinct bands called "Live" and a dozen called "LP." Two different Israeli jazz musicians are both named Avishai Cohen — both active, both recording.

One artist may have many names. Aphex Twin also records as Blue Calx, Caustic Window, Polygon Window, Power-Pill, The Tuss, user48736353001, Richard D. James, and roughly a dozen others. GZR was `g//z/r` on their first album, `geezer` on their second, and `GZR` on their third. Ghost was "Ghost B.C." — but only in the USA. Suede was "The London Suede" — but only in the USA. Zoviet France has been `:$OVIET:FRANCE:`, `Soviet France`, `:Zoviet-France:`, and `:zoviet*france:`.

### Album and Track Identity Is Not Stable

A release is not a fixed object. Consider:

- Sybreed's *Antares*: the Japanese edition has track 11 as "Technocracy"; the US edition has track 11 as "Plasmaterial"; the Russian and Swiss promo editions have 11 tracks total; the European promo has 8.
- The Art of Noise's *Close-Up* single: 4 UK versions, same catalogue number, same sleeve, different tracks — including one version that didn't contain "Close-Up."
- Godspeed You Black Emperor's *All Lights Fucked on the Hairy Amp Drooling*: original 1994 cassette with 27 tracks, 2022 re-release with 4 tracks, bootleg with 31. The band also changed their name from "Godspeed You Black Emperor!" to "Godspeed You! Black Emperor" in 2002 — note the exclamation mark moved.
- The Police's *Synchronicity* has 36 cover variations. Ian Dury & The Blockheads' *Do It Yourself* had at least 34 different sleeves.
- MF DOOM re-recorded *MM..FOOD* in 2007 because the original 2004 release contained an uncleared Sesame Street sample.
- Taylor Swift remastered her entire back catalog specifically to regain ownership.

Album names themselves are unstable: Ministry's *Psalm 69* is officially titled ΚΕΦΑΛΗΞΘ. The Beatles' self-titled double album is universally called "The White Album" but that's not its name. Ozzy Osbourne's *Speak of the Devil* was released as *Talk of the Devil* in the UK. Weezer has released multiple albums all titled *Weezer*, sometimes more than one per year.

The Autechre album is *untilted*, not *untitled*. The Byrds have an album called *(untitled)*. R. Kelly has one called *untitled*. Meghan Trainor has one called *Title*. The +/- album is called *Self-Titled Long-Playing Debut Album*. These are all different albums.

### Track Duration and Count Are Not Bounded

Duration is not a reasonable integer. Bull of Heaven's *209: Blurred With Tears And Suffering Beyond Hope* runs 4,723 hours, 54 minutes, and 37 seconds. *The Rise and Fall of Bossanova* by Pipe Choir Three is 13 hours, split across 5 parts. NǽnøĉÿbbŒrğ VbëřřĦōlökäävsŦ has a single track lasting nearly 7 hours, with the full album running just under 23 hours.

Track count is also not a reasonable small integer. Nine Inch Nails' *Broken* has 99 tracks. Tracks 7 through 97 are 4 seconds of silence each. The GRAY (그레이) track *119 REMIX* credits 119 different featured artists.

---

## If You Build This

1. **Never store a single canonical name for anything.** Artists, albums, and tracks all have aliases, alternate spellings, regional variants, and transliterations. MusicBrainz's database schema exists specifically to model this; study it before designing your own schema.

2. **Treat all timestamps, durations, and frame counts as approximate.** Use 64-bit integers or arbitrary-precision types for durations. Do not assume monotonicity, uniqueness, or precision of frame timestamps. Never seek by frame number; seek by time and accept that the result is approximate.

3. **Never assume a fixed pixel format, color space, or frame rate — not even within a single file.** Any of these can change mid-stream. Build your pipeline to handle format change events, not just initial setup.

4. **Use a hardware decoder only if you can verify what you're actually getting back.** DXVA2, D3D11VA via ANGLE, and VDPAU will silently post-process your frames. If pixel-accurate output matters, use VAAPI EGL interop or CUDA, or copy back to system RAM and accept the bandwidth cost.

5. **Validate your UTF-8 handling against real adversarial titles before shipping.** Test with: Spın̈al Tap (dotless i + combining diacritic), Aphex Twin's formula track title, Coldplay's emoji track names, and the EICAR test string as a track name. If your antivirus, filesystem, or database rejects any of these, you have a production bug.

6. **Assume nothing about album versions.** The same album name + artist + track count is not a unique identifier. Track numbers are not stable across regional releases. Cover art is not unique to a release. Build version/release as a first-class concept, not an afterthought.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals. Authors: if you'd rather your archived copy not live here, just ask and I'll remove it — but it's so valuable and appreciated that I hope a credited copy here is acceptable.

- [Falsehoods about Video (haasn)](https://haasn.xyz/posts/2016-12-25-falsehoods-programmers-believe-about-%5Bvideo-stuff%5D.html) · [archived copy](../archive/multimedia/01-falsehoods-about-video-haasn.md)
- [Horrible edge cases when dealing with music (dustri)](https://dustri.org/b/horrible-edge-cases-to-consider-when-dealing-with-music.html) · [archived copy](../archive/multimedia/02-horrible-edge-cases-when-dealing-with-music-dustri.md)
