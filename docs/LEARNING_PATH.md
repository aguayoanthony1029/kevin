# UNDYING — Beginner Learning Path

You said your coding experience is **basically none**. That's totally fine — this
is the best possible reason to learn, and a survival game is a fun way to do it.
This is your track from "never coded" to "building UNDYING with me."

**Mindset:** You don't need to "learn all of programming" before making a game. You
learn *just enough*, then learn the rest *by building*. We pair — I scaffold and
handle the hard parts, you learn the core gameplay code. You won't be alone on any
of this.

---

## How learning game dev actually works (read this first)

1. **You learn by building, not by reading.** Watch/read a little, then *do* a lot.
2. **Tiny wins compound.** Moving a cube with arrow keys is a real milestone. Celebrate it.
3. **Being confused is the job.** Every developer googles constantly and feels lost
   daily. That feeling never fully goes away — you just get comfortable with it.
4. **Done beats perfect.** Ugly code that works > elegant code that doesn't exist.

---

## The core concepts you'll pick up (don't memorize — you'll absorb these)

| Concept | Plain-English meaning | Where you'll meet it |
|---------|----------------------|----------------------|
| Variable | A labeled box that holds a value (`health = 100`) | Everywhere |
| Function | A named recipe of steps you can run | Player movement, attacks |
| Condition (`if`) | "If this is true, do that" | "If health ≤ 0, die" |
| Loop | "Repeat this" | Spawning a horde |
| Node / Scene (Godot) | Lego-like building blocks of your game | Player, Zombie, Wall |
| Signal (Godot) | "Tell other things something happened" | "Zombie hit player!" |
| `_process` / `_physics_process` | Code that runs every frame | Movement, AI |

You will learn every one of these *by using it in the game*, not from a textbook.

---

## Suggested schedule (flexible — go at your pace)

Think in "evenings," not deadlines. Skip ahead if it clicks; slow down if it doesn't.

### Week 1 — Get comfortable with the engine
- Install **Godot 4** ([godotengine.org/download](https://godotengine.org/download) —
  the standard version, not .NET).
- Do the official **"Your first 2D game"** tutorial in the Godot docs (the "Dodge the
  Creeps" game). It teaches nodes, scenes, signals, and basic GDScript in one sitting.
  - 📖 [docs.godotengine.org → Getting Started → Your first 2D game](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)
- **Goal:** finish that tutorial game. You'll understand 70% of what we need.

### Week 2 — GDScript basics + first 3D
- Read the Godot docs' **GDScript basics** page (variables, functions, if, loops).
  - 📖 [GDScript reference](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/index.html)
- Do the official **"Your first 3D game"** tutorial (a 3D squash-the-monster game) —
  it teaches 3D movement, physics, and spawning, which is exactly our genre.
  - 📖 [Getting Started → Your first 3D game](https://docs.godotengine.org/en/stable/getting_started/first_3d_game/index.html)
- **Goal:** move a character in 3D and spawn enemies. This is the literal skeleton of UNDYING.

### Week 3 — Reinforce + a survival-flavored mini-project
- Watch a beginner Godot 4 series on YouTube (pick one and stick with it — channels
  like **Brackeys** (returned for Godot), **HeartBeast**, **Godotneers**,
  **GDQuest** are beginner-solid). Don't channel-hop; finish one series.
- Build a *tiny* thing of your own: a top-down character that picks up an item and
  shows a count on screen. (That's gathering + inventory in miniature.)
- **Goal:** make something small that *wasn't* in a tutorial. That's the leap from
  "following" to "building."

### Week 4+ — Start Milestone 1 with me
- By now you can move a character, spawn things, and write simple logic.
- We start [`MILESTONE_1_PROTOTYPE.md`](MILESTONE_1_PROTOTYPE.md) **together** — I
  scaffold the structure and tricky bits; you write and understand the gameplay code.

---

## Best free resources (curated — don't drown in options)

- **Godot official docs & tutorials** — genuinely excellent, start here. Free.
- **Godot YouTube series** — Brackeys (Godot 4 intro), GDQuest, HeartBeast, Godotneers.
  Pick *one* beginner series and finish it before starting another.
- **GDQuest** ([gdquest.com](https://www.gdquest.com/)) — high-quality Godot learning,
  free and paid.
- **r/godot** and the **Godot Discord** — friendly, beginner-tolerant communities for
  when you're stuck.
- **This repo + me** — ask me anything, anytime. "What does this line do?" is always
  a valid question. No such thing as a dumb one.

## Anti-overwhelm rules

- 🚫 Don't try to learn Blender, art, audio, *and* code at once. **Code + engine first.**
  Use free asset packs for everything visual until much later.
- 🚫 Don't compare your Week 3 to someone's Year 5 on YouTube. They were where you are.
- 🚫 Don't start three tutorials at once. Finish one.
- ✅ Do commit your work to git often — even broken progress. It's a safety net and a
  visible record of how far you've come.
- ✅ Do take the wins. A wall you placed that a zombie has to break through? You *made* that.

## When you're ready

Finish at least Week 1–2, then tell me. We'll install/confirm Godot, create the
project, and start building Milestone 1 side by side. I've got you.
