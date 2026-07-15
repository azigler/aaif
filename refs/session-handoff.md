# Session handoff — 2026-07-15 3436b5d8

## State at offboard
- Current branch: `main`, clean, pushed. Last commit `14f7d33`.
- Open beads: 21; in-progress: 0; deferred: 11. No in-flight subagents. No dirty files.
- Markers: `.offboard-pending` cleared.

## The live arc (where the fresh session picks up): the MCP whitepaper + blog

Andrew was tapped by the Linux Foundation to help with the 2026-07-28 MCP spec education
campaign — a **solo-authored governance whitepaper** at engineering-leader altitude (Aug–Sep
tentpole; post-launch timing is fine) plus a **near-term companion blog** for andrewzigler.com
that feeds a Dev Interrupted Friday news segment. Two beads carry the full state:

- **`aaif-51g`** — the whitepaper. **Read its description first; it is the cold-start anchor.**
- **`aaif-uf3`** — the blog (near-term, week-of-the-28th target).

**Private research + strategy is in `.local/research/` — consult ALL before drafting:**
`mcp-committee-output.md` (current thinking + the reframe + spine + roundup), `mcp-whitepaper-reorientation.md`, `mcp-whitepaper-strategy.md`. These hold the audience, the evidence base, the campaign contacts, and the positioning context that must **never** touch committed content.

### >>> THE KEY STEERING for next session (Zig, 2026-07-15): fix the polarity <<<
A committee workflow produced an "accountability-trap" thesis (statelessness, SEP-2567, makes the
governed plane and the delivered plane distinct by design). Zig **agrees the two planes are
distinct by design**, but the pitch has the **wrong polarity and is still fuzzy**. Reframe:
- The problem (can't tell if autonomous work is worth it; can't govern AND understand what agents
  do) was **always there** — MCP does not create it.
- **The 2026-07-28 spec is the ENABLER that now lets you leverage fixing it** — lead by celebrating
  MCP, not by faulting it.
- **But only paired with a higher-level context / delivery-outcome layer** — that layer is what
  gives the view that turns MCP's new governability into an actual fix. The second plane is the
  complement MCP finally makes actionable, not MCP's blind spot.
- **Sharpen the fuzzy part:** make concrete what that higher-level context / delivery-outcome layer
  actually IS and DOES. This pulls the context-engine angle back to center.

### Accuracy discipline (load-bearing)
Call it **"the 2026-07-28 spec," not "MCP 1.0"** (date-stamped, not semver). RC until 7-28;
re-verify normative claims at Final; current Final is 2025-11-25. Ground every claim in a specific
SEP (`refs/projects/mcp.md`). Explicit-Handle Pattern is NOT an API. Vendor-neutral always.

### Deps Zig owns
Ask the LF contact for the existing LF whitepaper (so ours complements it), the format/length +
past examples, and the latest spec pointer. VP-DevEx demo ideas + the AWS-maintainer interview
(routed to the DI agent) feed in later.

## Also shipped earlier this session (done; context only)
- **Triage:** closed 8 beads, deferred 11; **retired the monthly skill-drop arc** (skills live in
  this repo now); refreshed `aaif-715`.
- **`/aaif-radar` W28** landscape scan (report + note bead + ledger).
- **LiteLLM vs agentgateway** analysis → idea bead **`aaif-sw2`** ("two gateways, two problems").
- **Config cleanup:** removed the `omni` MCP server + swept the claude.ai disabled entries from
  `~/.claude.json` (backups at `~/.claude.json.bak-*` — Zig can `rm` once verified); made the
  `cc-*` toggles routing-only in dotfiles (pushed). Zig is disconnecting the 3 claude.ai MCP
  connectors at the claude.ai account level.

## What's next (fresh session)
1. **`/onboard`, then open `aaif-51g`** and rework the whitepaper thesis per the polarity reframe
   above — celebrate MCP as the enabler; make the higher-level delivery-outcome/context layer
   concrete. Read the `.local` research docs first.
2. Decide whether to **draft `aaif-uf3` (the blog)** now so it's ready to publish week-of-the-28th.
3. Only after the thesis lands: scaffold `submissions/2026-mcp-governance-whitepaper/` and run the
   mise-derived pipeline (spec-with-test-cases → drafts → critic loop → gated publish).

## Warnings / watch-outs
- Hard rule stands: **nothing ships to any AAIF/LF surface without Zig's explicit go-ahead.**
- Keep the whitepaper + blog **strictly vendor-neutral**; the strategy/positioning tie is private
  (`.local`) and must never appear in committed or published content.
- The explainer lane is saturated (7 ambassadors, ~110 pts booked); our white space is the
  governance + eng-leader altitude. Don't drift into "what changed in the stateless core."
