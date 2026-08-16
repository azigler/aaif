---
description: The AAIF line-art visual lane — flat vector illustration and hand-built SVG diagrams in the AAIF brand system (thick black outlines, white ground, orange #FF702D + lavender #B6B0D0 accents only), for headers/OG images and inline figures on AAIF-related posts. Style approved by Zig 2026-08-16; carries the verified nano-banana style-transfer recipe, the OG-crop step, and the hard process rules (never frontload image generation; never ship the obvious literalization; /randomize the concept, not just the layout).
when_to_use: An AAIF-related post/tutorial/talk asset needs a header, OG image, or inline diagram in AAIF branding (the "looks legit" lane) rather than the pastoral storybook-goose lane (/storybook-header). Fire ONLY after the piece's text is locked — this skill's first rule is that imagery never frontloads. Also load before hand-building any brand-palette SVG diagram.
---

# /aaif-line-art — the AAIF brand illustration + diagram lane

Two lanes, one palette. Born on the 2026-08 anchor (aaif-51g): Zig approved the
**style** ("really amazing job on the theming and styling") and rejected the first
**compositions** ("they just look like slop. be intentional. dont frontload the
image creation, and dont do the obvious. use /randomize"). Both halves of that
verdict are this skill's law.

## The style contract (approved — do not drift)

- Flat vector line-art. **Thick black outlines** on every shape. No gradients, no
  shading, no texture.
- Palette EXACTLY four colors: `#000000` · `#ffffff` · orange `#FF702D` ·
  lavender `#B6B0D0` (the AAIF secondary palette; see /aaif-brand-guidelines).
  White ground; black-and-white foundation; orange for the *mechanism/emphasis*,
  lavender for the *fleet/population* works well but is not mandatory per image.
- Robots/agents: mascot-adjacent to the Ambassador badge — simple round heads,
  friendly, geometric (style ref: `assets/style-ref-badge.png`).
- No text, lettering, or logos inside generated images (tally marks are fine).
- Tone per the brand: confident, geometric, calm, trustworthy — never chaotic,
  never generic-AI aesthetics.

## Process rules (the part that was paid for)

1. **Never frontload.** Generate images only after the piece's text is locked
   (Zig-approved draft). The concept must serve the final piece's actual
   metaphors, and rejected batches are wasted spend.
2. **Never ship the obvious literalization.** The first concept the thesis
   suggests (gateway → toll booth; ledger → receipt) is the slop attractor —
   it is what got rejected. The subject roll must include genuinely oblique
   candidates, and "the obvious one" losing the roll is a feature.
3. **/randomize the CONCEPT, not just the layout.** Real entropy
   (`openssl rand -hex 4` → modulo → choice), provenance block written BEFORE
   generation, committed alongside the images (RANDOMIZE.md in the submission's
   images/ dir). Candidate list must span at least 5 concepts across different
   metaphor DOMAINS (not five arrangements of one domain).
4. **One image at a time, cost-confirmed** (~$0.07/1K via /openrouter). Two
   candidates max per round; iterate on feedback rather than fanning out.

## Generation recipe (verified 2026-08-16)

```bash
~/.claude/skills/openrouter/openrouter-image.sh \
  "Flat vector line-art illustration in the exact style of the reference image: \
bold thick black outlines, clean white background, flat colors limited STRICTLY \
to black #000000, white #ffffff, orange #FF702D, and soft lavender #B6B0D0 -- no \
gradients, no shading, no other colors. Scene: <THE ROLLED CONCEPT>. Wide 16:9 \
composition, generous white space, no text or lettering anywhere, no logos. \
Confident, geometric, professional open-source-foundation aesthetic." \
  ./header-cand-a.png --aspect 16:9 --size 1K \
  --ref ~/aaif/.claude/skills/aaif-line-art/assets/style-ref-badge.png
```

The style ref does the heavy lifting — nano-banana holds the palette and the
mascot register from it reliably (measured: both 2026-08-16 candidates were
on-palette first try).

OG crop (1200×630) from the 1376×768 render:

```python
from PIL import Image
im = Image.open('header-cand-a.png'); w,h = im.size
tw,th = 1200,630; ar = tw/th
cw = min(w, int(h*ar)); ch = int(cw/ar); x=(w-cw)//2; y=(h-ch)//2
im.crop((x,y,x+cw,y+ch)).resize((tw,th), Image.LANCZOS).save('header-og.png')
```

## Diagram lane (hand-built SVG, same palette)

Inline architecture/flow figures are **hand-authored SVG**, never generated —
genAI diagrams hallucinate labels. Same palette; `Instrument Sans` with
sans-serif fallbacks; monospace for header/column names; the brand type scale
(/aaif-brand-guidelines) for sizes. Worked example:
`submissions/2026-08-gateway-ledger/images/diagram-ledger.svg`.

⚠️ **Render-check with a real browser engine, not ImageMagick.** `convert` on
this box silently drops stroke outlines and mangles paths on SVG (measured
2026-08-16 — the same file was broken in `convert` output and pixel-perfect in
Chrome). Use:

```bash
google-chrome --headless --disable-gpu --screenshot=out.png \
  --window-size=1200,700 --default-background-color=FFFFFFFF "file://$PWD/fig.svg"
```

…and look at the PNG before shipping.

## Boundaries

- Pastoral/storybook watercolor (the goose) → `/storybook-header`, not here.
- Brand rules, logo assets, type scale → `/aaif-brand-guidelines` (authored by
  AAIF; this skill applies it to the illustration lane, never overrides it).
- Anything generated here that will PUBLISH goes to the CDN only after Zig's
  sign-off (pre-approval assets stay in the gitignored submission folder).
