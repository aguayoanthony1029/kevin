# Project UNDYING

> A co-op zombie survival & base-building game — the game the "Dark War Survival"
> ads *pretend* to be, but real. No cash-grab. No pay-to-win. Just survive, build,
> grow, and clear it out with your friends.

**Working title:** UNDYING *(placeholder — see alternatives in the design doc)*
**Status:** 🟡 Planning / Pre-prototype
**Engine:** [Godot 4](https://godotengine.org) (free, open source, no royalties)
**Made by:** Anthony (and friends, eventually)

---

## The pitch in one paragraph

You wake up in a world overrun by the dead. You scavenge wood, scrap, and food.
You build a shelter and fortify it. When night falls, the zombies come — and your
walls are the only thing between you and them. As you survive, you grow: better
gear, bigger base, deeper into the world. Eventually you bring in a few friends,
trade with survivors, and clear out dungeons and hordes that one person never
could. Think **Rust's** build-and-survive tension and **RuneScape: Dragonwilds'**
base + progression, but the enemy is the endless dead, not griefers.

## Why this project exists

Mobile "survival" ads promise a rich, gritty, skill-driven world and deliver a
timer-gated, wallet-draining husk. We're building the honest version:

- **The game matches the trailer.** What you're sold is what you play.
- **Skill and time, not money, make you stronger.** No paywalls, no energy timers.
- **Rich content:** real crafting, meaningful skill trees, unique loot, co-op raids.
- **Built to actually be fun** for you and a couple of friends on a Friday night.

## ▶️ How to run it (the game now exists!)

This repo is a real, runnable **Godot 4 project**. You can walk around a 3D world
right now. Two ways to get it onto your PC:

**Easiest — download the ZIP:**
1. On this branch's GitHub page, click the green **`Code`** button → **Download ZIP**.
2. Unzip it somewhere you'll remember (e.g. `Documents/Undying`).
3. Open **Godot 4** → in the Project Manager click **Import** → browse to the unzipped
   folder and pick **`project.godot`** → **Import & Edit**.
4. Press **`F5`** (or the ▶️ Play button, top-right). You're walking around. 🎮
   - **WASD** move · **mouse** look · **Shift** sprint · **Space** jump · **Esc** free the mouse.

**Or with git (if you set it up):** `git clone` this repo, checkout the branch, and
import the folder in Godot the same way.

> First launch takes a few seconds while Godot builds its cache. If anything errors,
> copy the message to me and we'll fix it together.

## This repo right now

The **plan** lives in `docs/`, and a **playable skeleton** lives at the repo root
(`project.godot`, `main.tscn`, `player.tscn`, `scripts/`). Start here:

| Doc | What's in it |
|-----|--------------|
| [`docs/GAME_DESIGN.md`](docs/GAME_DESIGN.md) | The full vision: pillars, gameplay loop, every system, art direction, the "no cash-grab" promise |
| [`docs/TECH_STACK.md`](docs/TECH_STACK.md) | Why Godot, what tools we use, how the project is structured, multiplayer plan |
| [`docs/ROADMAP.md`](docs/ROADMAP.md) | The phased plan from "empty project" to "playable with friends" — milestone by milestone |
| [`docs/LEARNING_PATH.md`](docs/LEARNING_PATH.md) | A beginner's track to go from zero coding to building this, week by week |
| [`docs/MILESTONE_1_PROTOTYPE.md`](docs/MILESTONE_1_PROTOTYPE.md) | The exact spec of the first tiny thing we build — small enough to finish |

## The golden rule of this project

**Scope is the enemy. Finishing is the win.**

Every game like this that dies, dies from trying to build the dream all at once.
We build the *smallest fun thing* first, then add one layer at a time. The full
open-world co-op MMO-ish dream is the destination — the single-player "survive one
night in a field" prototype is step one. We don't skip steps.

## What's next

Read [`docs/ROADMAP.md`](docs/ROADMAP.md), then [`docs/MILESTONE_1_PROTOTYPE.md`](docs/MILESTONE_1_PROTOTYPE.md).
When you're ready, say the word and we'll install Godot and build Milestone 1 together.
