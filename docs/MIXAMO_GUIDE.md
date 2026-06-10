# Getting real rigged zombies from Mixamo (step by step)

Mixamo is Adobe's **free** library of rigged, animated 3D characters. It's the best
free path to gritty, realistic zombies that actually walk and attack. It's locked
behind a free Adobe login, so **you** download the files and **I** convert and wire
them into the game.

**Your whole job:** download a few `.fbx` files and drop them in
`assets/models/zombie/`. That's it. No Blender, no converting — I handle all of that.

---

## Step 1 — Log in
1. Go to **https://www.mixamo.com**
2. Click **Sign up / Log in**. Use a free Adobe account (no credit card, no payment).

## Step 2 — Pick a zombie character
1. Click the **Characters** tab (top left).
2. In the search box, type **zombie**.
3. Click a zombie you like (e.g. "Zombie", "Warzombie", "Zombiegirl"). It loads in the
   big preview on the right. *(If you don't love any, any humanoid works — the zombie
   walk animation is what makes it shamble.)*

## Step 3 — Add and download animations
Now the important part. For **each** animation below:

1. Click the **Animations** tab (top left).
2. Search for the animation name, click it — it previews on your chosen character.
3. If there's an **"In Place"** checkbox on the right, **tick it ON** (keeps the
   character from sliding around — our game code does the moving).
4. Click the big **Download** button (top right). In the popup, set:
   - **Format:** `FBX Binary (.fbx)`
   - **Skin:** `With Skin`
   - **Frames per Second:** `30` (default is fine)
   - **Keyframe Reduction:** `none` (default is fine)
5. Click **Download**, and **rename the file** as noted below.

| Search for | Tick "In Place"? | Save the file as |
|------------|------------------|------------------|
| **Zombie Walk** (or "Walking") | ✅ Yes | `zombie_walk.fbx` |
| **Zombie Idle** (or "Idle") | — (no checkbox is fine) | `zombie_idle.fbx` |
| **Zombie Attack** (or "Zombie Punching") | ✅ Yes | `zombie_attack.fbx` |
| **Zombie Death** (or "Dying") | — | `zombie_death.fbx` |

> **Shortcut:** if this feels like a lot, just grab **`zombie_walk.fbx`** first. That
> one file is enough for me to put a real, walking, rigged zombie into the game. We
> can add idle/attack/death right after.

## Step 4 — Put the files in the project
1. Move the `.fbx` files into the **`assets/models/zombie/`** folder of the project.
2. Either commit & push them, **or** just send them to me in the chat — whichever's
   easier for you.

## Step 5 — Hand off to me
Tell me they're in. I'll:
- convert the FBX to the format Godot uses (.glb),
- replace the blocky code-built zombies with your rigged models,
- hook up the walk / attack / death animations to the game's AI, and
- **render screenshots so you can see it before you even download it.**

---

### Optional: a player character + weapon later
The same process works for a survivor character and animations (idle, run, swing).
But the player is first-person, so you barely see yourself — let's nail the **zombies**
first, since those are what fills your screen at night.

### Licensing note
Mixamo content is free to use in your projects under Adobe's terms, including games.
You're clear to use these. 👍
