# UNDYING — Milestone 1: The Vertical Slice

> **This is the most important document in the repo.** If the loop described here is
> fun with ugly cube-and-capsule placeholder art, the whole game will work. If it's
> not fun, we fix *this* before adding anything else. We do not skip ahead.

**Goal:** The smallest possible version of the core fun: *gather → build → defend → survive the night.*
**Scope:** Single player. One small flat area. Placeholder art (cubes, capsules, cylinders).
**Definition of done:** You can play a full day→night→dawn cycle, and it feels *tense*.

---

## What it looks like when it's done

> You spawn (a capsule) in a small field with a few "trees" (green cylinders). You
> walk up to one, hold to chop, and collect wood. You place a wooden wall (a flat box)
> in front of you on a grid. A timer counts down the day. Night falls — the light dims
> — and 3–5 "walkers" (red capsules) spawn at the edges and shamble toward you. They
> have to path around or break your wall to reach you. You swing your bat (a melee hit)
> to kill them. If you survive until the sun comes up: **you win**. If they kill you:
> **restart.**

That's it. That's the whole milestone. It's intentionally tiny — and it already
contains the soul of the game.

---

## Feature checklist (each is small on purpose)

### 1. Player
- [ ] A capsule/character you control: WASD to move, mouse to look (3rd or 1st person).
- [ ] A health value (e.g. 100). Takes damage when a zombie is in range and attacking.
- [ ] A melee "swing": left-click does damage in front of you on a short cooldown.
- [ ] Death → simple "You Died — Restart" screen.

### 2. One resource: wood
- [ ] "Trees" = green cylinders placed around the field.
- [ ] Walk up + hold interact (E) → after a moment, tree depletes and you gain wood.
- [ ] A simple on-screen counter: `Wood: 12`.

### 3. One buildable: a wall
- [ ] Press a build key (e.g. B) → a ghost/preview wall follows your aim, snapped to a grid.
- [ ] Left-click to place it if you have enough wood (e.g. costs 5 wood).
- [ ] Placed wall is solid: zombies can't walk through it; it has health and can be broken.

### 4. One enemy: the walker
- [ ] Red capsule that spawns at the map edge at night.
- [ ] Pathfinds toward the player (Godot's `NavigationAgent3D` or simple "move toward").
- [ ] If a wall is in the way, it attacks the wall (wall loses health) or paths around.
- [ ] Touches player → deals damage on a cooldown.
- [ ] Has health; player's melee kills it. Dies → despawns (and maybe drops nothing yet).

### 5. Day/night cycle
- [ ] A timer: e.g. 90 seconds "day," then "night."
- [ ] Visual cue: lighting dims at night, brightens at dawn (even just changing a light's energy).
- [ ] Night = spawn a small wave of walkers (start with 3–5).
- [ ] Survive until dawn → **you win** screen. (One night is enough for Milestone 1.)

### 6. Minimal UI
- [ ] Health bar or number.
- [ ] Wood counter.
- [ ] Day/night indicator or timer.
- [ ] Win screen + Lose screen, each with a "Restart" button.

---

## Explicitly OUT of scope for Milestone 1 (resist these!)

These are great ideas. They are **not now**. Park them in the design doc backlog:

- ❌ Multiplayer / friends (Phase 4)
- ❌ Inventory grids, multiple resources, crafting menus (Phase 2)
- ❌ Multiple enemy types, hordes that scale (Phase 2)
- ❌ Skill trees, leveling, unique loot (Phase 3)
- ❌ Hunger/thirst/stamina (Phase 2)
- ❌ Nice art, models, animations (much later — cubes are fine and *correct* for now)
- ❌ Saving/loading (Phase 2)
- ❌ Open world, biomes, dungeons (Phase 5+)
- ❌ Sound (a couple of placeholder SFX are fine, but don't polish audio yet)

If you catch yourself adding any of these "while I'm in here" — stop. That instinct is
the project-killer. Write it down, move on.

---

## Suggested build order (we'll do this together, step by step)

Build in this order so you *always* have something runnable:

1. **Flat ground + a player capsule that moves.** (You'll have done this in the learning path.)
2. **A camera that follows/looks.** Now it feels like a game.
3. **Trees + chopping → wood counter.** First "gather" verb. Satisfying already.
4. **Wall placement on a grid.** First "build" verb. Now you're building.
5. **One walker that walks toward you and hurts you.** First threat.
6. **Melee swing that kills the walker.** First "fight" verb. The combat is born.
7. **Walls block/are attacked by walkers.** Now building *matters* defensively.
8. **Day/night timer + a night wave + win/lose screens.** The loop closes. **It's a game.**

After step 8, you have a complete, playable vertical slice. **Play it. Have a friend
play it. Watch where it's fun and where it drags.** That feedback shapes Phase 2.

---

## How we'll work on this (your "mix of both" preference)

- **I scaffold** the project structure, the trickier bits (navigation/pathfinding, the
  grid-snapping math, the day/night state machine), and explain them.
- **You write and own** the core gameplay code — the gather, the swing, the build —
  with me guiding. That's the stuff worth learning, and it's the most fun.
- We commit after each working step, so progress is saved and visible.

## Ready check

Before we start Milestone 1, you should be able to (from the [learning path](LEARNING_PATH.md)):
- [ ] Move a character around a 3D scene.
- [ ] Spawn an object (like an enemy) into the scene.
- [ ] Write a simple `if` and change a variable (like reducing health).

Got those (even shakily)? Then say the word — **we build.** 🧟
