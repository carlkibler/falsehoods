# The weird world of Windows file paths (Fileside)

> **Original:** <https://www.fileside.app/blog/2023-03-17_windows-file-paths/>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.
>
> If you're the author and would rather this copy not live here, just ask and I'll remove it — but this work is so valuable and appreciated that I hope a fully-credited preserved copy is welcome.

---

The weird world of Windows file paths \| Fileside

File system paths on Windows are stranger than you might think. On any Unix-derived system, a path is an admirably simple thing: if it starts with a / , it’s a path. Not so on Windows, which serves up a bewildering variety of schemes for composing a path.

When I implemented the path autocompletion feature in Fileside 1.7 , I needed to take a closer look at this to make sure I had all bases covered. This blog post shares my findings.

Note that this article limits itself to the type of paths seen by the user of Windows apps (dictated by the Win32 API). There are even more curiosities to be found below this layer, mostly of concern only to people writing hardware drivers and such.

At a glance

Absolute path formats

Name

Example

Drive path

C:Files

UNC path

\Media\1000 words

Device path (literal)

\\:

Device path (normalized)

\\:Genome

Relative path formats

Name

Examples

Current directory-relative

., ..

Current drive-relative

Drive’s current directory-relative

D:Warsaw

Disallowed characters

Characters

Validity

\< \> ” /  \| ? \*

Never allowed

.

Disallowed as final character  

Disallowed except for with data streams

Length limits

Item

Maximum length

Path

32,767 (or 260) characters

File or directory name

255 characters

Windows path schemes

There are three different kinds of absolute path, and three different kinds of relative path on Windows.

Absolute paths

Absolute, or fully qualified, paths are complete paths, that on their own uniquely identify a location in the file system.

Drive paths

Drive paths are the good old-fashioned paths we all know and love, consisting of a drive letter and a sequence of directories.

D:preferencesjam in

UNC paths

UNC stands for Universal Naming Convention and describes paths that start with \\ , commonly used to refer to network drives. The first segment after the \\ is the host, which can be either a named server or an IP address, like so:

\Work \192.168.1.15

UNC paths can also be used to access local drives in a similar way:

\localhost$`\Users\Andrew Fletcher
\\127.0.0.1\C`$Wilder

Or by using the computer name:

\Pipeline\$Gore

The \$ sign in C\$ indicates a hidden administrative network share , and is not a substition for the drive colon : , as the first version of this article claimed. The C\$ -style drive shares are simply convenient shortcuts automatically created by Windows. Accessing drives through them will only work if you’re logged in as an administrator.

Note also that \Pipeline is not a valid directory path in itself, as it only identifies a server. The name of a share must be appended to arrive at an actual folder.

Device paths

A device path starts with either of these two beauties:

\\ 

\\ 

They can be used to address physical devices (disks, displays, printers etc) in addition to files and folders. Not something you’ll ever use in day-to-day file management, but useful to know about if you come across one in the wild.

The syntax for accessing a local folder using a device path is either of:

\\: \\:

If you really want to get obscure for the sake of it, you can also substitute an equivalent device identifier for Z: :

\\

Here, Volume{59e01a55-88c5-411e-bf0a-92820bdb2549} happens to be the identifier for the disk volume on which Z: resides on the computer on which I’m writing this.

There’s also a special syntax for representing UNC paths as device paths:

\\\$

With device paths, the bit that comes after the \\ or \\ is a name defined in Windows’s internal Object Manager namespace. For those curious to explore what’s available in this namespace, you can download the WinObj tool and take a look.

Normalised and literal device paths

So what’s the difference between \\ and \\ , you ask.

Normally, when you pass a path to Windows, it starts off by cleaning it up before using it. This process is referred to as normalisation . But more about that later .

A \\ path skips this cleaning step, while a \\ path doesn’t. Hence, we can refer to \\ paths as literal device paths , and \\ as normalised device paths .

Say you, for whatever incomprehensible reason, have a file named .. (it could have been created on a network drive through a different system for example). You would normally not be able to access it, as normalisation would resolve it to the parent directory, but with a literal device path, you can do so.

Relative paths

Relative paths are incomplete paths, that need to be combined with another path to uniquely identify a location.

Paths relative to the current directory

These are paths that use the current directory as their starting point, e.g. .refers to a subdirectory of the current directory, and ..refers to a subdirectory of the parent of the current directory.

In Fileside, the current directory is taken to mean the folder shown in the pane where you enter your path.

Paths relative to the root of the current drive

If you start a path with a single  , it’s interpreted relative to the root of the current drive. So, if you’re currently anywhere on the E: drive and type in , you’ll end up in E:.

When the current directory is accessed via a UNC path, a current drive-relative path is interpreted relative to the current root share, say \Earth.

Paths relative to a drive’s current directory

Less commonly used, paths specifying a drive without a backslash, e.g. E:Kreuzberg , are interpreted relative to the current directory of that drive. This really only makes sense in the context of the command line shell, which keeps track of a current working directory for each drive.

This is the only type of path that Fileside does not support, as it has no concept of a current directory per drive. Only panes have a current directory.

Normalisation

As alluded to above, all paths except literal device paths go through a normalisation process before they’re used. This process consists of the following steps:

Replace forward slashes ( / ) with backslashes (  )

Collapse repeated backslash separators into one

Resolve relative paths replacing any . or ..

Trim trailing spaces and periods

It’s thus generally possible to specify Windows paths using forward slashes as well.

Windows naming rules

Now we’ll turn our focus to the individual segments that make up a path. There are a number of restrictions on what names you can use for files and folders.

Disallowed characters

You can’t use any of the following characters in a name:

\< \> ” /  \| ? \*

Any non-printable character with an ASCII value below 32 is equally out of the question.

The cunning colon

For the most part, : is also banned.

However, there is an exotic exception in the form of NTFS alternate data streams, where the colon is used as a separator within a name. It is a little known fact that you can store a hidden piece of data inside a file in certain contexts by appending a suffix preceded by a colon to its name.

The perilous period

A . is fine anywhere within, or at the start of, a name, but is disallowed as a final character.

Leading and trailing spaces

Curiously, Windows allows spaces at the beginning of names, but not at the end. As a name with spaces around it often looks identical to one without, these are generally a terrible idea, and Fileside automatically trims them off when you rename or create files.

Disallowed names

For historical reasons, you can’t use any of the following names either:

CON , PRN , AUX , NUL , COM0 , COM1 , COM2 , COM3 , COM4 , COM5 , COM6 , COM7 , COM8 , COM9 , LPT0 , LPT1 , LPT2 , LPT3 , LPT4 , LPT5 , LPT6 , LPT7 , LPT8 , and LPT9 .

That includes usage with an extension tacked on. If you call a file COM1.txt for example, it gets converted into \\ internally, and gets interpreted as a device by Windows. Not what you want.

Case sensitivity

For the most part, Windows doesn’t make a distinction between lower- and upper-case characters in paths.

C:hamlet , c:Hamlet , C:Hamlet , or C:hAMlET are considered exactly the same thing.

However, since the Windows 10 April 2018 Update , NTFS file systems do have the option of enabling case sensitivity on a per-folder basis .

Length limits

We’re not quite done yet, the lengths of things have limits too.

Paths

Traditionally, a path on Windows could not exceed a total of 260 characters . Even today, this is still the case for some apps, unless they have taken care to implement a workaround.

This workaround consists of transforming every path into a literal device path under the hood before passing it to Windows. Through doing so, we can bypass the 260 character limit, and increase it to a much more generous 32,767 characters instead. Fileside implements this workaround.

Names

Individual file and folder names cannot be longer than 255 characters.

So many ways to say the same thing

Armed with all this knowledge, we realise that we can construct an almost unlimited number of different path strings that all refer to the same directory.

C:

c:

C:/\\/\\//Chameleon

C:....

\localhost\$

\127.0.0.1\$

\\:

\\:

\\\$

\\

\\

etc.

That’s what sticking to a policy of total backwards compatibility for several decades gets you!

Updated on 24 April 2023 based on some helpful corrections from this Hacker News thread and this Reddit thread .

Looking for a better file manager?

Fileside is a modern multi-pane file manager for Mac and Windows.

Its customisable workspaces of tiled panes make it a breeze to keep your projects and collections organised.

Learn more Try it now

More from the blog

Over the past year I’ve had a steady stream of emails asking if a Fileside version 2 is coming. One even wondered whether the project is still being maintained. The short answer is yes. Fileside 2.0 is deep in…

After a recent flare-up of RSI-related wrist pain, I decided to make a serious attempt at becoming proficient at speech computing. My hope was to be able to add an alternative input method in order to offload my hands, and allow them some rest even during my daily work. I’m now four weeks in and this post summarises my impressions. The journey has had its fair share of frustrations, but also brought some surprising insights.

A quick search for “Full Disk Access” reveals plenty of results , although some are misleading if not outright dishonest. Many come from application vendors suggesting that if we don’t grant their Mac apps Full Disk Access, they might not work as intended. In fact, the vast majority of applications should have no reason to need Full Disk Access.

Here’s a quick tip for keeping your Firefox tabs and windows organised, achieving a workflow similar to Fileside’s saved layouts. Without installing a thing!
