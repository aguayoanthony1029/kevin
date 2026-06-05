# UNDYING — Tech Stack & Architecture

How we build it, and why. Tailored for **a beginner who wants to actually learn**,
building toward a 3D co-op survival game, with **zero budget and no royalty traps**.

---

## 1. Engine: Godot 4 ✅

**We're using [Godot 4](https://godotengine.org/).** Here's the honest comparison
of the three engines a beginner would consider:

| | **Godot 4** ✅ | Unity | Unreal Engine 5 |
|---|---|---|---|
| Cost / royalties | **Free forever, MIT license, zero royalties** | Free tier, but trust damaged by 2023 fee fiasco | Free until $1M revenue, then 5% |
| Beginner-friendly | **Very** — small, fast, clean | Friendly, huge tutorial pool | Steep; built for AAA teams |
| Language | **GDScript (reads like Python)** + C# | C# | C++ / Blueprints |
| Download size | **~100 MB, opens in seconds** | Multi-GB | ~30+ GB, heavy |
| 2D | **Best in class** | Good | Afterthought |
| 3D | Good and improving fast (4.x) | Strong | Best in industry (overkill for us) |
| Multiplayer | **Built-in high-level API** | Needs add-ons | Strong but complex |
| Right for *this* project | **Yes** | Maybe later | No (too heavy for a first game) |

**Why Godot wins for us specifically:**
- **GDScript is the gentlest real programming language** you can learn — it looks
  like plain English/Python, so "basically no coding experience" isn't a wall.
- **Free with no strings.** Aligns with our anti-greed ethos and your budget ($0).
- **Fast iteration.** It launches instantly and runs the game in one click, so you
  *see* results constantly — the best way to stay motivated while learning.
- **Capable enough** for everything in our realistic first release, including 3D and
  co-op multiplayer, with a clear path to grow.

> Note: if we ever hit a wall that genuinely needs Unreal-grade 3D, the *skills* you
> learn (game loops, state, scenes, components) transfer. We won't need it for years.

## 2. 2D or 3D for the prototype?

We'll **start the very first prototype in a simple 3D** *or* **top-down view** —
decided in Milestone 1. Leaning toward a **simple 3D third-person** because:
- It's the actual dream (Rust/Dragonwilds are 3D).
- Godot 4's 3D is beginner-approachable now.
- Free 3D asset packs (Kenney, Synty-style) let us prototype without art skills.

If 3D ever feels like too much friction early, we fall back to **top-down 2D/2.5D**
to nail the *gameplay loop* first, then re-skin to 3D. Fun > dimensions. The roadmap
keeps this flexible.

## 3. Language: GDScript (start here), C# (optional later)

- **GDScript** for everything to start. It's built for Godot, easiest to learn,
  and every Godot tutorial uses it.
- **C#** is available in Godot if we ever want it (you already might know it from
  other contexts) — but we won't reach for it early. One language at a time.

## 4. Tools we'll use (all free)

| Need | Tool | Notes |
|------|------|-------|
| Engine | **Godot 4** | The whole game. |
| Code editor | **Godot's built-in editor** (or VS Code + Godot plugin) | Built-in is fine to start. |
| Version control | **Git + GitHub** (this repo) | Already set up. Commit early, commit often. |
| 2D art / icons | **Krita**, **Aseprite** (paid but cheap), free packs | Don't make art early — use packs. |
| 3D models | **Blender** (free) + free asset packs | Blender *much* later. Packs first. |
| Audio | **Audacity**, free SFX libraries (freesound.org, Kenney) | Sound matters more than you think. |
| Project/task tracking | **GitHub Issues / this repo's docs** | Keep the roadmap honest. |

## 5. Project structure (how we'll organize the Godot project)

When we start building, the repo will grow into something like this:

```
undying/
├── project.godot              # Godot project file
├── README.md
├── docs/                      # these planning docs
├── scenes/                    # Godot scenes (.tscn) — the building blocks
│   ├── player/
│   ├── enemies/
│   ├── world/
│   ├── building/
│   └── ui/
├── scripts/                   # GDScript (.gd) files
│   ├── player/
│   ├── enemies/
│   ├── systems/               # survival, inventory, day/night, save
│   └── building/
├── assets/                    # art, models, audio, fonts
│   ├── sprites/
│   ├── models/
│   ├── audio/
│   └── fonts/
└── addons/                    # third-party plugins, if any
```

Godot is **scene-and-node based**: you compose the game from reusable "scenes"
(a Player scene, a Zombie scene, a Wall scene) made of "nodes." We'll learn this
hands-on in Milestone 1 — it's intuitive once you see it.

## 6. Multiplayer plan (for when we get there)

- **Target: small co-op, not a massive MMO.** 1–4 friends, host-and-join. This is
  realistic, fun, and avoids the bottomless pit of MMO server engineering.
- Godot has a **built-in high-level multiplayer API** (`MultiplayerSpawner`,
  `MultiplayerSynchronizer`, RPCs) that handles a lot for us.
- **Architecture:** one player *hosts* (acts as server), others join via IP or a
  relay. Later we can add dedicated servers if there's demand.
- **We do NOT build multiplayer first.** It's added in a later phase once the
  single-player loop is fun. Building netcode into an unfun game is wasted effort.

## 7. Saving / persistence

- Start simple: save game state (player stats, base layout, inventory, world seed)
  to a JSON or Godot `Resource` file on disk.
- This gets designed properly in the phase where bases need to persist between
  sessions. Don't over-engineer it early.

## 8. Performance & platform notes

- PC first. Keep poly counts and zombie counts sane — a "horde" can be faked with
  smart spawning and LOD long before we need hundreds of high-detail models.
- Mobile/iOS is a *later* target with its own performance and control rework. We
  design PC-first and port deliberately, not simultaneously.

## 9. What we are deliberately NOT using (yet)

- ❌ Unreal Engine — overkill, heavy, C++ barrier for a first project.
- ❌ Custom engine — never. Insane for a beginner; engines exist for a reason.
- ❌ Photorealistic art pipelines — a budget and time black hole.
- ❌ Blockchain / NFTs / "play to earn" — that's the greed we're fighting. No.
- ❌ Dedicated multiplayer servers / cloud infra — not until there's a game worth it.

## 10. First setup (when you're ready)

1. Download Godot 4 (the standard, **not** the .NET/C# build to start) from
   [godotengine.org/download](https://godotengine.org/download).
2. Tell me, and we'll create the Godot project in this repo together and start
   [Milestone 1](MILESTONE_1_PROTOTYPE.md).

No installs needed *yet* — read the [roadmap](ROADMAP.md) and
[learning path](LEARNING_PATH.md) first.
