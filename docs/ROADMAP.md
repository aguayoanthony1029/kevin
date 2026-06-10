# UNDYING — Development Roadmap

The honest, sequenced path from "empty Godot project" to "playing with friends."
Each phase ends in a **playable build**. We never move on until the current phase
is fun. Time estimates assume part-time, learning-as-we-go — they're rough and
that's fine. **Finishing each phase matters more than speed.**

> The cardinal rule: **build the smallest fun thing, then add one layer.** If you
> ever feel the urge to "just add multiplayer and the open world too" — that urge is
> exactly what kills these projects. We resist it on purpose.

---

## Phase 0 — Foundations & first steps 🟡 *(we are here)*
**Goal:** Tools installed, fundamentals understood, project created.
**Outcome:** You can move a character around a test scene and understand why it moves.

- [x] Write the plan (this repo).
- [ ] Install Godot 4.
- [ ] Do the beginner track in [`LEARNING_PATH.md`](LEARNING_PATH.md) (at least Week 1–2).
- [ ] Create the Godot project in this repo.
- [ ] "Hello world": a controllable cube/character on a flat plane.

*Est: 1–2 weeks of evenings. Don't rush — this is where the foundation is poured.*

---

## Phase 1 — The Vertical Slice (Milestone 1) 🎯
**Goal:** The *core fun* in its crudest form. Detailed in [`MILESTONE_1_PROTOTYPE.md`](MILESTONE_1_PROTOTYPE.md).
**Outcome:** Single player, one small area. You gather wood, place a wall, and
survive a night where a few zombies walk toward you and you fight/block them.
Programmer-art cubes and capsules — and it's already *kind of fun*.

- [ ] Player: move, look, melee swing.
- [ ] One resource: chop a "tree" → get wood.
- [ ] Place one buildable: a wall (snap to a simple grid).
- [ ] One enemy: a "walker" that pathfinds to the player and deals damage.
- [ ] Day/night timer: night triggers a few spawns.
- [ ] Win/lose: survive till dawn = win; die = restart.

*Est: 3–6 weeks. **This is the most important milestone in the whole project.**
If this loop is fun with cubes, the game will work. If it's not, we fix the loop
before adding anything.*

---

## Phase 2 — A Real Survival Loop
**Goal:** Turn the slice into an actual survival game (still single-player).
**Outcome:** A loop you'd play for 30+ minutes.

- [ ] Multiple resources (wood, stone, scrap) + a second tool tier.
- [ ] Inventory + hotbar UI.
- [ ] Crafting menu (recipes: tools, walls, a weapon).
- [ ] Health + hunger needs; food you gather and eat.
- [ ] Base building: foundations, walls, doors, a storage box — snap building.
- [ ] 2–3 enemy types (walker, runner, brute) + scaling night hordes.
- [ ] Basic save/load so a base persists between sessions.

*Est: 2–4 months. This is where it starts to feel like a real game.*

---

## Phase 3 — Progression & Depth
**Goal:** Reasons to keep playing — the grow/get-stronger fantasy.
**Outcome:** Earned power. A session-to-session sense of progress.

- [ ] Skill XP from activities (gathering, combat, building, crafting).
- [ ] Skill trees with meaningful unlocks (recipes, passives).
- [ ] Gear tiers + a few **unique/named items** (the loot chase).
- [ ] Material tiers for building (wood → stone → metal) with real durability.
- [ ] Defensive structures: spikes, traps, gates, a watchtower.
- [ ] Sound design pass + basic art pass (swap cubes for asset-pack models).

*Est: 2–4 months.*

---

## Phase 4 — Co-op with Friends 👥
**Goal:** The thing that makes it special — survive together.
**Outcome:** You and 1–3 friends in the same world, same base.

- [ ] Godot high-level multiplayer: host + join.
- [ ] Sync players, enemies, building, loot.
- [ ] Shared base + shared/role-divided survival.
- [ ] Co-op-scaled hordes (more players = bigger nights).
- [ ] The inevitable netcode bug-squashing pass.

*Est: 3–6 months. Multiplayer is hard — but the single-player game underneath is
already fun, so this is additive, not make-or-break.*

---

## Phase 5 — World, Content & Polish
**Goal:** From "a fun loop" to "a game worth telling people about."
**Outcome:** A first **public/shareable release** (itch.io, friends, small community).

- [ ] A larger world / multiple areas or biomes.
- [ ] Points of interest with risk/reward loot.
- [ ] First **dungeon/raid** (instanced, gear-gated, co-op).
- [ ] NPC survivor hub: vendor + a few quests.
- [ ] Menus, settings, controls remapping, tutorial onboarding.
- [ ] Optimization, bug-fixing, and a real art/audio polish pass.
- [ ] **Ship a v0.1 release.** 🚀

*Est: ongoing. A "release" here is small and proud, not perfect.*

---

## Phase 6+ — The Dream (post-first-release)
Only after a real release exists. In rough priority:

- Big open world with multiple biomes.
- Trading economy (NPC and/or player).
- Mutated specials + an intelligent raider faction (Dragonwilds-style besiegers).
- More dungeons/raids and an end-game progression curve.
- **Mobile/iOS** — "what the ads should have been" — as a deliberate, separate effort
  with reworked controls and our anti-greed monetization.
- Story/lore layer, factions, world events.

---

## How to use this roadmap

- **Work top to bottom. No skipping.** Each phase assumes the last one is done and fun.
- **End every phase with a build you can actually play.** Momentum comes from playing
  what you made, not from a pile of half-finished systems.
- **Park ideas, don't chase them.** When inspiration for a Phase 6 feature hits during
  Phase 1, write it in the design doc's backlog and get back to work. Capturing it
  scratches the itch without derailing you.
- **It's okay to be slow.** You're learning to code *and* making a game. Every phase
  you finish is a genuine, rare accomplishment most people never reach.

## Definition of "done" for the whole vision

We'll know we made it when a couple of friends can hop into your world on a Friday
night, build up a base, sweat through a horde, clear a dungeon, and say *"this is
what those ads should have been."* That's the win. Everything in this roadmap exists
to get to that one evening.
