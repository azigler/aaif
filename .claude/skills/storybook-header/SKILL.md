---
name: storybook-header
description: Produce an on-brand post header in Andrew Zigler's pastoral-storybook aesthetic — a warm watercolor children's-book scene in golden-hour light over rolling farmland, starring a recurring white goose in a red aviator scarf. Maps the post's idea to a farm metaphor (never literal tech), carries one locked look across the feed via image-to-image style/character references, and outputs the exact OG-sized crop + `image:` frontmatter line. Use when a blog post / tutorial / thread / andrewzigler.com note needs a header image, or when refreshing an existing header to stay in the series.
when_to_use: A published or about-to-publish piece needs a header/OG image and it should match the goose storybook series (the /submission Publish step, /camp-publish frontmatter, or any standalone post). NOT for diagrams, screenshots, UI mockups, or literal product art — this skill is the pastoral-illustration lane only.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.1"
---

# /storybook-header — the pastoral-goose post-header aesthetic

Every post in the series wears the same coat: a warm **watercolor storybook**
scene, golden-hour light over gentle farmland, with a recurring goose mascot as
the protagonist. This skill is the recipe for producing a new one that lands
*inside* that series instead of next to it — so the feed reads as one cohesive
body of work, not a pile of one-off AI images.

The output is a single header image: a full-bleed illustration, cut to the exact
OG crop, hosted on the CDN, with the `image:` frontmatter line ready to paste.

## When to fire

- A written contribution is reviewed and heading to publish and needs its header
  (the `/submission` **Publish** step, or `/camp-publish` needs the `image:`
  frontmatter value).
- A standalone thread / andrewzigler.com note wants a header in the series.
- An existing header needs a remake to match the current locked look.

**Do NOT fire for** diagrams, architecture figures, screenshots, UI mockups, or
any literal depiction of a product. This is the illustration lane only.

## The locked look (do not drift)

The style is the brand. Hold every one of these on every generation:

- **Medium**: warm **watercolor storybook illustration** — children's-book feel,
  visible painterly texture, soft edges, hand-painted warmth.
- **Light**: **golden hour** — low warm sun, long soft shadows, glow.
- **Setting**: gentle rolling **pastoral farmland** — patchwork fields, hills,
  hedgerows, a barn or fence line, big soft sky.
- **Palette**: soft **amber / sage / coral** — warm and muted, never neon, never
  cold corporate blue-grey.
- **Mood**: serene, calm, whimsical, generous. It should feel like a page from a
  picture book, not a slide.

**Explicitly avoid** (these are the tells that break the series): robots,
screens, UI, code, terminals, circuit motifs, glowing holograms, servers, gears,
"AI brain" imagery, dry enterprise/corporate scenes, anything literal-tech. When
in doubt, lean **more pastoral**, not more literal. The concept is carried by the
*farm*, never by a rendered gadget.

## Stay authentic — two traps to avoid

The style sits near two crowded neighbors; steer away from both on purpose.

- **Not the industrial-AI-mascot lane.** Steve Yegge's "Gas Town" is a Mad Max
  wasteland of anthropomorphic **robot chimps** and animal-named "agents," also
  made with nano-banana. Being its opposite is the point: **serene, warm,
  pastoral, literary** — never industrial, chaotic, robotic, or gritty.
- **Not the generic-AI-cozy default.** The soft, sweet, over-warm "cozy AI
  illustration" is nano-banana's default and reads as anyone's. Fight it with
  **specificity**: reach for **particular, slightly surprising rural crafts and
  places** (a canal lock, a herb-drying loft, a rope ferry, a seed-library) over
  the first-things-the-model-draws clichés (an open **gate**, a **windmill**, a
  **market stall**, an **orchard**). Less generic = more ours.

The test: could this image belong to *anyone's* AI blog, or is it unmistakably
*this* series? Push toward the latter — one specific goose, one specific craft,
one hidden serial number.

## The mascot — the through-line goose (unnamed)

A friendly white **goose** in a **red aviator scarf** is the recurring
protagonist across every post — the continuity anchor a reader recognizes the
series by. **He has no name.** Do not call him "ZIG-00" / "ZIG-OO": that was only
the **tail number painted on the first biplane**, and it seeds the Easter-egg
convention below.

- Keep him **consistent**: white goose, red aviator scarf, warm and expressive,
  same storybook proportions. The red scarf is his signature — always present.
- He is always the **protagonist**; the surroundings carry the post's idea.
- **One goose, not a menagerie.** The lead stays the same goose across posts. Do
  NOT rotate in a cast of other cute animals as the protagonist — a single
  consistent character is ownable, while a parade of anthropomorphic-animal
  "agents" drifts straight into the crowded generic lane (see "Stay authentic").
- **Established scenes** (extend the vocabulary; don't reinvent the character):
  - *First header* — the goose piloting a little **"TINY-TOOLS" biplane** (tail
    number **ZIG-00**) over patchwork farmland — the **anchor image** for the
    series (see "Continuity technique").
  - *Differentiated set* — the goose at specific, less-generic rural crafts: a
    **canal lock**, a **grain-sorting floor**, a **seed-library**, a **rooftop
    dovecote**, a **hilltop weather-station**. Same goose, new specific chore.

## The ZIG-NN Easter egg — the serial signature

The series **counts up.** The first biplane carried **ZIG-00**; every header
after it hides the **next number** — `ZIG-01`, `ZIG-02`, … — somewhere subtle
in-scene: a **crate stamp**, a **drawer label**, a **lock plaque**, a **boat
hull near the waterline**, a **lantern tag**, a **chalk slate**.

- **Subtle, integrated, an Easter egg** — never a headline. Small, on a natural
  in-world surface.
- **Exactly one** per image, incrementing across the published series — **track
  the last number used** so the next header takes the next integer.
- It is the **only** readable text allowed in the image; everything else stays
  wordless (no other signs, labels, or letters). nano-banana renders a short tag
  like `ZIG-03` legibly on a plaque or label — verify it in the output, and clean
  it with a small post-overlay only if it garbles.

## The metaphor method — map the idea to the farm

The post's idea never appears literally. You **translate it into a pastoral
scene** where farm elements carry the concept:

| The idea is about… | The farm carries it as… |
|---|---|
| boundaries / tiers / permissions | **gates** and **fences** (which are open, which closed) |
| measurement / metrics / accounting | a **tally board** / **ledger** ZIG-OO reads |
| delivered outcomes / results | the **harvest** — full baskets, gathered crops |
| a fleet / many agents | a **flock** ZIG-OO shepherds |
| earning trust / more scope | a **wider pasture** opening up |
| tools / capabilities | the **TINY-TOOLS biplane** / farm implements |

The method: name the post's core idea in one phrase, pick the farm object that
means that, and stage ZIG-OO doing something with it. Metaphor first, always.

## Continuity technique — feed a prior image as the reference

This is what makes the feed cohere. **On every new generation, pass a prior
published image as an image-to-image style + character reference** (the
`/openrouter` helper's `--ref`). The model then inherits the palette, the
painterly texture, and — critically — the goose's look, so ZIG-OO stays himself
across posts.

- **Default anchor**: the **TINY-TOOLS biplane header** —
  `https://cdn.zig.computer/aaif/every-goose/header-remake-v2.png`. Use it as the
  reference unless you're deliberately extending a newer sub-series, in which case
  reference the most recent published header in that set.
- Referencing keeps the series from slowly drifting off-model with each new
  image. Never generate a series header with **no** `--ref`.

## Mechanics

Generation is **nano-banana 2** via the `/openrouter` skill's image helper:

```bash
~/.claude/skills/openrouter/openrouter-image.sh \
  "<the pastoral prompt>" out.png \
  --ref <anchor>.png \
  --aspect 16:9 \
  --size 1K
```

- **Cost-aware**: roughly **~$0.07 per 1K image**. State the cost in your
  acknowledgment; generate deliberately. Do **not** fan out speculative variants —
  align on the concept first (see Hard Rule 3), then generate the batch you agreed
  to.
- **Aspect / size**: draft at `--aspect 16:9 --size 1K` for review batches. The
  final **header target is 1200×630** (the OG image ratio, ~1.9:1 — slightly wider
  than 16:9), cut from a clean high-res render (see the workflow).
- **Diversity without drift** — use `/randomize` to roll the *incidental* scene
  accents so a batch doesn't collapse to the AI-default pastoral: roll the
  **season**, the **props**, a **companion critter**, time-of-day within
  golden-hour, weather. Randomize the accents; **never** randomize the locked
  style, the palette, or the goose. Record the `/randomize` provenance block so
  the roll is real, not narrated.

## HARD RULES (learned in production — hold these)

1. **FULL BLEED, always.** The scene fills the frame edge to edge. **No white
   border, no painterly margin, no matte frame.** If the model paints one in
   anyway (nano-banana likes to), **crop it off** with a deterministic PIL crop
   rather than shipping it — do not accept a bordered header.
2. **Bold, legible props.** At header scale, small fussy details vanish into
   noise. Prefer **a few clear, large elements** over many tiny ones. (A
   pencil-behind-the-ear once read as visual mush and got removed — that's the
   bar.) If a prop won't read at 1200×630, make it bigger or cut it.
3. **PROPOSE the concept to Zig BEFORE generating.** Generation is cheap;
   alignment is what saves rounds. Pitch the metaphor(s) in words first — "ZIG-OO
   reads a ledger at the pasture gate" — get the nod, *then* spend credits.
4. **Deliver a batch for phone review over the private mesh.** Serve the candidate
   images from a small ad-hoc web gallery reachable on Zig's **private mesh
   network**, so he can view and iterate from his phone. (Describe the technique
   generically — a tiny local static server exposed only on the private mesh;
   never hardcode any IP, hostname, or port in committed content.)
5. **After the pick: cut the final + host + emit frontmatter.** Render/crop a
   clean **2K** final for archival, cut the exact **1200×630** OG crop, host it via
   `/cdn` (stable public URL under `aaif/…`), and emit the `image:` frontmatter
   line pointing at that URL.

## The workflow (end to end)

1. **Name the idea** → one phrase; pick the farm metaphor (see the table).
2. **Propose** the concept(s) to Zig in words. Wait for the nod. *(Hard Rule 3.)*
3. **Randomize the accents** — roll season / props / companion critter with
   `/randomize`; keep the locked style + ZIG-OO fixed. Record the provenance block.
4. **Generate the batch** at `16:9 / 1K` with `--ref <anchor>`, stating the cost.
5. **Review over the mesh** — serve the batch to a phone-viewable private-mesh
   gallery; Zig picks / iterates. *(Hard Rule 4.)*
6. **Finalize the pick** — deterministic PIL crop to kill any border *(Hard Rule
   1)*, cut a clean **2K** master + the exact **1200×630** OG crop.
7. **Host + emit** — `/cdn up` the OG crop to a stable public URL; output the
   `image:` frontmatter line for the post. *(Hard Rule 5.)*

## Pairs with

- **`/openrouter`** — the nano-banana 2 generation helper (`--ref`, `--aspect`,
  `--size`).
- **`/randomize`** — roll incidental accents so batches diversify without breaking
  the locked style.
- **`/cdn`** — host the final crop at a stable public URL for the `image:` line.
- **`/zig-voice`** — for any header text, caption, or alt text in Andrew's voice.
- **`/impeccable`** — palette refinement / craft pass on the amber-sage-coral
  scheme when a header needs tuning.
