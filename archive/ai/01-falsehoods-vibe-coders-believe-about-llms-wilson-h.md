# Falsehoods Vibe Coders Believe About LLMs (Wilson Hobbs)

> **Original:** <https://wilsonhobbs.com/blog/2025-05-31-falsehoods-vibe-coders>
>
> **Archived for preservation.** This is a Markdown-extracted copy of the original, saved here in case it disappears from the web. Formatting and images are not preserved — please refer to the original (linked above) for the version as the author intended it.
>
> With gratitude to the author for compiling these notes, ideas, and facts.

---

Falsehoods Vibe Coders Believe About LLMs — Wilson Hobbs

May 31, 2025

Falsehoods Vibe Coders Believe About LLMs

Patrick McKenzie wrote a blog post 15 years ago called Falsehoods Programmers Believe About Names . It’s approachable enough that even people with no coding experience will gain a new appreciation for the sheer variance of human names and the absurdity of software engineering.

In the last two years of vibe coding in various capacities, AI has expanded my knowledge of strategies and tactics for approaching new projects, but has also blindly led me down the completely wrong path for some problems. While I was in the rabbit hole of clean code , hexagonal architecture , and event-driven distributed systems , I was watching friends and family gain the capability to build their own apps, scripts, and tools using AI-powered coding products like Cursor , Windsurf , and Github Copilot .

As a public service, here are some of the falsehoods I have seen newcomers believe about LLM-generated code, with some misconceptions about LLMs and software development at large for good measure. All of these are wrong. You likely don’t believe all of them, but you may believe a few of them. But unlike Patrick McKenzie’s never seeing a system handle names correctly, I have seen people vibe code safely, and you can vibe code safely too.

LLMs sometimes write code that always works

LLMs always write code that sometimes works

LLMs can determine whether a piece of code works or not

LLMs can write a program to determine if a piece of code works or not

Code written by an LLM is correct if it does what you expect it to

Code written by an LLM will do what you expect it to do the way you expect it to be done

Code written by an LLM will do what you expect it to do

Code written by an LLM will do something useful

Code written by an LLM will do anything at all

If the code written by an LLM compiles , it is correct

Code written by an LLM will compile

If the code written by an LLM runs, its correct

Code written by an LLM will run

Code written by an LLM will eventually stop running

An LLM can determine whether a piece of code will ever stop running or not

An LLM can write a program to determine whether a piece of code will ever stop running or not

LLMs can determine the correctness of a piece of code by looking at it

LLMs can determine the purpose behind a piece of code by looking at it

LLMs can accurately describe the behavior of a piece of code by looking at it

LLMs will attempt to use the code you have already written

LLMs only use libraries and APIs that exist

LLMs can generate code for any package as long as the docs are good

When an LLM says “this is the standard way”, it is the standard way

Code written by LLMs is secure

Code written by LLMs is safe to deploy to production

Code written by LLMs is safe to run locally

LLMs can assess the security of a piece of code

LLMs know about the causes and mitigations of most security vulnerabilities

LLMs are alive

LLMs are thinking

LLMs are reasoning

LLMs remember what they told you 5 minutes ago

LLMs work towards your best interests

LLMs work towards their own best interests

Software bugs happen because the code is wrong, not because the human is wrong

LLMs warn you when you’re solving the wrong problem

LLMs can “fill in the blanks” when it’s not sure

LLMs will speak up when the requirements are unclear

People are good at asking for what they want

You are good at asking for what you want

This list is by no means exhaustive. If you need examples of AI generated code that disproves any of the above misconceptions, I am happy to provide you with some. Feel free to add other misconceptions in the comments (how do I do a comments section on this thing now that Disqus is dead?), and refer people to this post the next time they suggest a genius idea like “I’ll just fire all my engineers and use an LLM to build my app”.
