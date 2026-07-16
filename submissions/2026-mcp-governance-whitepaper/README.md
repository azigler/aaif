# Earned Autonomy — MCP governance whitepaper

A solo-authored, **Linux-Foundation-published** technical whitepaper on the
**2026-07-28 MCP spec**, written at **engineering-leader altitude** on
**governance and enterprise scale**. Byline: **Andrew Zigler**.

## What this piece is

The 2026-07-28 revision of the Model Context Protocol turns agent activity into
structured, attributable, enforceable events at the protocol layer. This paper
takes that as its foundation and argues a thesis — **"Earned Autonomy"** — about
how an organization governs fleets of autonomous agents on top of it: autonomy
granted in proportion to delivered outcomes, adjusted at the per-call enforcement
point the spec provides.

It is written for the person who has to answer for the fleet — the engineering
leader deciding how much autonomy to grant, on what evidence, and how to walk it
back. The spec is celebrated as the enabler throughout; the paper never faults it.

## Status

- **Thesis: LOCKED** — "Earned Autonomy." See `research/angle-options.md` for the
  full angle contract (title, the bridge, the six-section spine, boundary
  conditions, and the alternatives considered → reframed).
- **Methodology: LOCKED** — built under the aaif `/research-paper` loop:
  bootstrap → verbatim refs → angle-lock → per-section beads draft → read-only
  critic loop → REVIEW-NOTES human-gate → gated publish. Skill:
  `.claude/skills/research-paper/`. Deep reference / cookbook:
  `refs/research-paper-pipeline.md` (both at the repo root).
- **Format: DEFERRED** — the `paper/` directory is intentionally absent until the
  Linux Foundation publishing target is known (LaTeX vs Doc/Markdown). Everything
  else here is format-agnostic and can proceed now.

## Companion blog

A companion blog post is the **higher-altitude rendering of the same idea** — one
idea, two altitudes. The blog is the accessible lead; this whitepaper is the
grounded, technical treatment. Both draw from the single locked foundation in
`research/angle-options.md`; the blog ships via the lighter publish path, this
paper via the full `/research-paper` loop.

## The hard gate

Nothing here publishes or submits to **any AAIF or Linux Foundation surface**
without Andrew's **explicit go-ahead**, every time. Building and drafting locally
is encouraged; anything that lands in the spotlight stops at the gate. See
`REVIEW-NOTES.md` for the gated publish checklist.

## Layout

```
2026-mcp-governance-whitepaper/
├── README.md              ← this file
├── refs/                  ← verbatim source material (SEP grounding + external-evidence pointers)
│   └── mcp-sep-grounding.md
├── research/              ← our own analysis
│   └── angle-options.md   ← the LOCKED angle as a contract + alternatives considered
├── data/                  ← vendor-neutral reference-implementation evidence (accrues later)
│   └── .gitkeep
├── REVIEW-NOTES.md        ← the human-gate ledger (build cmd · decisions · owner judgment · concern→defense · publish checklist)
└── (paper/  DEFERRED — added once the LF publishing format is known)
```

`data/` will hold vendor-neutral reference-implementation evidence gathered during
the build (e.g. measurements against public reference implementations).

## A note on grounding

Private strategy, source documents, and infrastructure specifics live in the
repo's `.local/` tier — **never committed, never quoted here**. Everything in this
folder is strictly **vendor-neutral and public**: it points only to the category /
capability and to external, citable evidence.
