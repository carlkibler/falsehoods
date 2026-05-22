# Falsehoods About Game Development

> Even a single door is a bottomless pit of design decisions.

## The Big Surprises

- **A door is not a door — it is a design problem.** "Are there doors in your game? Can the player open them? Can they open *every* door, or are some decoration?" Liz England's "Door Problem" starts with the most mundane object imaginable and shows it instantly fractures into dozens of decisions someone has to actually make.

- **Game design isn't the flashy part.** There's an impression that design is about crazy ideas and fun all the time. The reality cuts straight to the everyday practical considerations — which is exactly why "Let me tell you about doors…" is a better explanation of the job than anything involving "vision."

- **"Can you open it?" is the easy question.** The hard ones follow: How does the player *know* the difference between a usable door and a decorative one? Green vs. red? Trash piled in front? Removed doorknobs? Every affordance you assume is obvious had to be deliberately authored.

- **One door, ~30 disciplines.** A creative director, project manager, designer, concept artist, art director, environment artist, animator, sound designer, audio engineer, composer, FX artist, writer, lighter, legal, programmers of five flavors, level/UI/combat/systems/monetization designers, QA, UX researchers, localization, producer, publisher, CEO, PR, community, and support all touch the same door.

- **Multiplayer turns a door into a physics-and-state nightmare.** Two players: does it lock after both pass through? If the level is too big to all exist at once and one player lingers, the floor may vanish under them. Do you block progress until they regroup, or teleport the straggler?

- **Size is a hidden constraint that cascades.** A door must fit the player — but also co-op partners, following allies who shouldn't get stuck, and mini-bosses larger than a person. Change the enemy roster and you may have to resize every door in the game.

- **The most expensive door is the one nobody notices.** The article's punchline is the Player: "I totally didn't even notice a door there." The mark of good work is invisibility — which makes the effort impossible to see and easy to undervalue.

- **This is every interactive system, not just doors.** Commenters who'd never made a game recognized it immediately: any non-trivial software has a "door problem" hiding in its most ordinary feature.

## Where It Gets Complicated

### The questions a single door raises

Before anyone builds anything, a designer has to answer a stack of questions that the player will never consciously think about:

- **Can it open at all, and can the player tell?** Openable vs. decorative doors need a *legible signal* — color coding, blocked entrances, missing doorknobs. "Did you just remove the doorknobs and call it a day?"
- **Locked vs. permanently shut.** What communicates "this opens later" versus "this never opens"? And how does the player unlock it — a key, a hacked console, a solved puzzle, a story beat?
- **Doors you can open but never enter.** Where do enemies come from? Do they pour in through doors, and do those doors lock behind them?
- **The mechanics of opening.** Auto-slide on approach? Swing? A button press? Each is a different animation, input, and feel.
- **Doors that lock behind you,** and what that means for pacing and player anxiety.

These aren't trivia — "SOMEONE has to solve The Door Problem, and that someone is a designer."

### When players multiply

Co-op detonates the simple cases:

- **Locking with two players:** the door should only lock after *both* pass through — now you're tracking per-player state.
- **Streaming huge levels:** if the world can't all be loaded at once and one player stays behind, their floor can disappear. The fix is a *design* call dressed as an engineering one: gate progress until players reunite, or teleport the laggard.
- **Doorway blocking:** if player 1 stands in the doorway, do they block player 2? How many trailing allies need to squeeze through without jamming?

### Why size is never just size

A door's dimensions are a contract with every entity that uses it:

- Big enough for the player.
- Big enough for co-op players who may crowd the threshold.
- Wide enough that following allies don't get stuck.
- Tall and wide enough for enemies — including mini-bosses larger than a human.

Get the roster wrong and a late character-art change ("you need to increase the door height so our larger enemy can fit") ripples back through level layout and animation.

### What each discipline must do with the same door

The door passes through the whole org, and each role's "done" is different:

- **Direction & planning** — Creative Director greenlights doors; Project Manager schedules them; Producer asks whether doors are a feature or a pre-order bonus; Publisher and CEO frame and bless the effort.
- **Art pipeline** — Concept Artist paints doors; Art Director picks the one true style; Environment Artist turns the painting into an in-engine object; Character Artist only cares "until it can start wearing hats."
- **Motion, sound & feel** — Animator opens and closes it; Sound Designer makes the open/close sounds; Audio Engineer makes those sounds change with player position and facing; Composer writes the door a theme song; FX Artist adds sparks; Lighter puts a red light on it when locked, green when open.
- **Programming** — Gameplay Programmer makes it open by proximity and lock via script; AI Programmer teaches enemies and allies whether they can pass; Network Programmer asks if all players must see it open simultaneously; Core Engine Programmer optimizes for up to 1024 doors; Tools Programmer makes placing doors easier; Release Engineer says "in by 3pm or it's not on the disk."
- **Design specializations** — Level Designer places and gates it behind an event; UI Designer adds an objective marker and a map icon; Combat Designer scripts enemies spawning behind it with cover fire (and a fallback door if the player is watching); Systems Designer attaches XP and gold costs; Monetization Designer offers "$.99 now or wait 24 hours."
- **Words & law** — Writer authors the "Hey look! The door opened!" line; Legal makes the artist scrub the accidental Starbucks logo before the lawsuit; Localization translates "Door" into a dozen languages and scripts.
- **Validation** — QA walks, runs, jumps, lingers, saves/reloads, dies/reloads, and throws grenades at the door; UX/Usability Researcher recruits people off Craigslist to watch them fail at it.
- **Audience-facing** — PR hype-tweets it; Community Manager promises fixes "in an upcoming patch"; Customer Support patiently explains to a confused player how doors work.

And the Player, at the end of all of it: "I totally didn't even notice a door there."

### How scope explodes

The structure of the problem is the lesson. A feature that sounds like a one-line task ("add doors") is actually:

- A web of dependent decisions, where answering one question ("locked?") spawns three more ("how shown? how unlocked? what if two players?").
- A coordination problem across roughly thirty roles, each with its own definition of finished and its own trade-offs to negotiate.
- A trade-off engine: technical considerations (framerate, memory, programmer time, workarounds) constantly bargaining against design considerations (does the player care? does it serve the experience?), with someone empowered to be the arbiter — escalating to a Creative Director only when needed.

## If You Build This

- **Audit your "doors."** Find the most boring, taken-for-granted element in your product and ask the door questions: can users act on it, can they tell, what happens at the edges (two users, huge state, locked-behind), and what signals communicate all of that. The mundane things are where complexity hides.

- **Estimate by dependency, not by appearance.** "Add doors" is never one task. Before committing, trace how many decisions and how many disciplines a feature touches — a single visible object can pull in art, audio, AI, networking, localization, monetization, and QA.

- **Assign an owner per piece of the system.** The doors get built because someone is the designated arbiter for doors, empowered to make calls, negotiate trade-offs, and know when to escalate. Cross-discipline features stall without a clear owner and clear buy-in.

- **Make affordances explicit, then test them on strangers.** Don't assume players know which door opens. Author the signal (color, blocked path, marker) and put real people in front of it — the UX-researcher-with-Craigslist move catches what builders are blind to.

- **Budget for the edges and the invisible win.** Multiplayer state, streaming, and entity sizing are where the real cost lives, and the payoff is a feature nobody notices. Plan for that asymmetry instead of being surprised by it — and resist re-deriving the same edge cases each time by capturing the patterns once.

## Sources

Consolidated from the works below. Each is linked to its original and to a Markdown copy archived in this repo for preservation; please visit the originals.

- [The Door Problem (Liz England)](https://lizengland.com/blog/2014/04/the-door-problem/) · [archived copy](../archive/game-development/01-the-door-problem-liz-england.md)
