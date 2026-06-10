# UNDYING — Game Design Document

This is the living vision for the game. It's allowed to be ambitious here — the
[roadmap](ROADMAP.md) is where we make it realistic and sequence it. Think of this
as "the dream, written down" so we never lose sight of it while building small.

---

## 1. Vision statement

> A gritty, co-op survival game where you and a few friends carve out safety in a
> world owned by the dead — gathering, building, fortifying, and growing strong
> enough to push back. The trailer is the game. Skill and time make you powerful,
> never your wallet.

## 2. Working title

`UNDYING` is a placeholder. Candidates to decide on later:

- **UNDYING** — clean, ominous, easy to say.
- **AFTERLIGHT** — softer, post-apocalyptic mood.
- **DEADZONE** — punchy (but heavily used elsewhere).
- **THE LONG NIGHT** — leans into the day/night survival loop.
- **HOLDFAST** — leans into the base-building/defense fantasy.
- **REVENANT** — single-word, edgy.

We'll lock a name before first public build. Naming early doesn't matter; finishing does.

## 3. Design pillars

Every feature must serve at least one pillar. If it doesn't, it's cut or parked.

1. **Earned power.** You get stronger through play and mastery — never purchases.
   No timers, no energy, no premium currency that affects gameplay.
2. **The base is yours.** Building a home you're proud of, then defending it, is
   the emotional core. Walls should *feel* like they matter.
3. **Better with friends, fair solo.** Everything is playable alone, but co-op
   unlocks the best moments (hordes, raids, dividing labor).
4. **Honest tension.** Day is for preparing; night is for surviving. The loop
   creates real stakes without cheap punishment.
5. **Rich, not bloated.** Deep systems that interlock — crafting feeds building
   feeds defense feeds exploration — instead of a hundred shallow ones.

## 4. Core gameplay loop

```
        ┌─────────────────────────────────────────────┐
        │                  DAYTIME                     │
        │  Scavenge resources  →  Craft gear & parts   │
        │  Build / upgrade base →  Set traps & defenses│
        │  Explore for loot & quests                   │
        └───────────────────────┬─────────────────────┘
                                 │  night falls
                                 ▼
        ┌─────────────────────────────────────────────┐
        │                 NIGHTTIME                    │
        │  Zombies attack the base  →  Defend & fight  │
        │  Walls/traps tested  →  Survive till dawn    │
        └───────────────────────┬─────────────────────┘
                                 │  you survived
                                 ▼
        ┌─────────────────────────────────────────────┐
        │                PROGRESSION                   │
        │  Loot from kills  →  Skill XP  →  New unlocks │
        │  Bigger base, better gear, deeper world      │
        └───────────────────────┬─────────────────────┘
                                 │ repeat, harder & richer
                                 └──────────► (back to DAYTIME)
```

The short-term loop is **day → night → grow**. The long-term loop is **survive a
field → own a region → push into dangerous zones → take on raids/dungeons**.

## 5. The systems (the dream, full scope)

These are described at full ambition. The roadmap parks most of them for later.

### 5.1 Survival & needs
- **Health** — damage from zombies, falls, starvation.
- **Hunger / thirst** — gather and cook food, find/purify water.
- **Stamina** — sprinting, swinging tools, mining costs stamina.
- **Temperature** *(stretch)* — campfires and clothing matter at night/in biomes.

### 5.2 Resource gathering
- Chop trees (wood), mine rock/ore (stone, metal), scavenge ruins (scrap, cloth,
  electronics, ammo), forage/hunt (food).
- Tools tier up: stone → metal → powered. Better tools = faster, more yield.

### 5.3 Crafting
- Recipe-based crafting from a menu, unlocked by skill progression and found blueprints.
- Tiers: basic tools/weapons → structures/parts → advanced gear, traps, electronics.
- Workbenches/stations unlock deeper recipes (forge, workbench, cooking station).

### 5.4 Base building
- **Grid/snap building** (the beginner-friendly approach): foundations, walls,
  floors, doors, ramps, ceilings snap together.
- Material tiers: wood (weak/cheap) → stone → metal (strong/expensive).
- **Structural integrity** *(stretch)*: unsupported pieces collapse — adds depth.
- Defensive pieces: spike walls, gates, towers, trap floors.
- Storage, crafting stations, beds (respawn points) placed inside.

### 5.5 Enemies — the dead (and others)
- **Walkers** — slow, numerous, the bread and butter of night hordes.
- **Runners** — fast, dangerous, force you to fight or flee.
- **Brutes** — tanky, smash structures; a wall-breaker threat.
- **Special/mutated** *(later)* — spitters, screamers (summon more), etc.
- **Night hordes** — scaling waves that target your base; the core threat.
- **Raiders/goblins-style faction** *(later, à la Dragonwilds)* — intelligent
  enemies that besiege your base and steal/destroy — adds variety beyond the dead.

### 5.6 Combat
- Melee first (cheap, no ammo): bats, axes, spears — stamina-driven swings, blocking.
- Ranged later: bows, then firearms with scarce ammo (ammo as a real resource).
- Hit feedback, stagger, weak points (headshots matter).

### 5.7 Progression & skill trees
- **Skill trees** by activity: Survival, Combat, Building, Crafting, Scavenging.
- XP from *doing* (chop wood → Gathering XP). Earned, not bought.
- Unlocks: new recipes, passive bonuses, ability tiers (e.g. faster build, more carry).
- **Unique items**: named/rare gear with distinct stats and looks — the loot chase.

### 5.8 World & exploration
- Start: small handcrafted area. Grow toward a **large open world** with biomes
  (forest, ruined town, industrial, wilds).
- Points of interest: abandoned towns, gas stations, military sites — risk/reward loot.
- **Dungeons / raids** *(end-game)*: instanced dangerous areas (a overrun hospital,
  an infested bunker) that you and friends clear for top-tier loot. Gear-gated.

### 5.9 Multiplayer & co-op
- **Co-op with a few friends** is the target (small private servers / host-a-game),
  *not* a thousand-player MMO. Realistic and where the fun is.
- Shared base, shared loot, divided roles (builder, fighter, scavenger).
- **Trading** with NPC survivors and/or other players *(later)* — a safe-hub economy.

### 5.10 NPCs & quests *(later)*
- Survivor camps / safe hubs: vendors, quest-givers, story breadcrumbs.
- Quests: fetch, clear-out, escort, build-something — give the world purpose.

## 6. Art direction

- **Mood:** gritty, grounded, "lived-in apocalypse." Not cartoony, not hyper-realistic
  (realism is a budget trap for beginners). Stylized-realistic is the sweet spot.
- **Palette:** muted earth tones by day; cold blues and firelight oranges by night.
- **Readability first:** the player must instantly read "threat," "loot," "resource,"
  "my base." Gameplay clarity beats visual flair.
- **Assets:** start with free/cheap asset packs (Kenney, Synty-style, Godot asset
  library) to prototype. Custom art comes *much* later, if ever. **Programmer art is
  fine and expected early — do not let art block gameplay.**
- **Audio:** ambient dread, distant moans, satisfying hit/craft/build sounds. Sound
  sells survival tension more than graphics do.

## 7. The "no cash-grab" promise (our anti-ads manifesto)

This is why we're building it. Written down so we never betray it:

- ❌ No energy timers, no "wait 4 hours or pay."
- ❌ No premium currency that affects power.
- ❌ No loot boxes / gacha.
- ❌ No pay-to-win, ever.
- ✅ Power comes from skill and time invested.
- ✅ If we ever monetize: a fair one-time price, or purely-cosmetic extras, or paid
  expansions that add real content. The base game promise is never compromised.
- ✅ **The trailer is the game.** We never show what we can't deliver.

## 8. Target platform (sequenced)

1. **PC first** (Windows/Linux/Mac). Easiest to develop, test, and play co-op.
2. **Mobile/iOS later** as either a port or a streamlined companion experience —
   *this* is where we could make "what the ads should have been" for a huge audience.
   But mobile UX + controls + monetization-pressure make it a poor *first* target.

## 9. Inspirations (study these, steal the fun, not the greed)

- **Rust** — base building, raiding tension, survival loop (we swap players-as-threat
  for zombies-as-threat to remove the toxicity).
- **RuneScape: Dragonwilds** — build your base, fend off besiegers, progression feel.
- **7 Days to Die** — day/night horde loop, voxel-ish building, crafting depth.
- **Valheim** — co-op survival/build done *right*, stylized art on a small team,
  honest design. **This is our north star for "small team, big heart."**
- **Project Zomboid** — depth of survival systems and grim tone.

## 10. Scope reality check

The above is the 5-year dream. A realistic first *shippable* version is roughly:
**single biome, a dozen enemy/loot/recipe types, grid base-building, day/night horde
loop, 1–4 player co-op.** Everything else (open world, dungeons, NPCs, trading,
mobile, mutated specials, raider faction) is post-first-release. See the
[roadmap](ROADMAP.md) for the honest sequence.
