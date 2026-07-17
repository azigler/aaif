# Session handoff — 2026-07-17 (b0518df0 — the big Earned-Autonomy session)

## ⭐ START HERE NEXT SESSION: the experiment arc

Zig's new direction (end of session): the Earned-Autonomy argument is too abstract.
**Run a real experiment** that demonstrates the MCP governance/auditing loop with real
data, then render it at **three altitudes** (LinkedIn → blog → whitepaper).

**→ Read `submissions/2026-mcp-governance-whitepaper/experiment/PLAN.md` — it stages
EVERYTHING** (the experiment design, the agent-identity/config-hash backbone, the
ThoughtWorks/Fowler calibration, the 3 altitudes, the whitepaper fold-in, the process
constraints, and the next-session execution order). Nothing executed yet — context ran out.

**Beads for the arc:**
- `aaif-51g.2` — the EXPERIMENT (scope + run + mini case study). The backbone.
- `aaif-51g.3` — the agent-identity + **config-hash** model (Zig's missing-backbone insight).
- `aaif-51g.1` — fold **all 5** actionability ideas into the whitepaper (Zig confirmed "all 5").
- LinkedIn-post bead + image-stash bead (both under epic `-18o`; titles: "LinkedIn post — Earned Autonomy tease" / "finalize + /cdn-stash the differentiated goose motif set").

**Process (Zig, firm):** **NO Fable — too expensive.** Use the **Workflow** tool with
**regular sub-agents** (scientific runners + critic + synthesizer) + beads. Calibration
ref: `submissions/2026-mcp-governance-whitepaper/research/thoughtworks-fowler-calibration.md`.
Experiment data comes from the agentgateway request log (`/agentgateway` skill +
`refs/gateway-request-log-cookbook.md`); the gateway is on `pico`.

## What SHIPPED this session (all pushed to main)

**Whitepaper (`aaif-51g`, 8pp, gates green via the new `gates.sh`):**
- Belts revision merged; **DORA-only** competitor removal; §1 Stanford stat restored.
- Fable rounds 4 / 4b / 4c applied. **Key reversal: LinearB is now NAMED** as the
  benchmark source in §3 + bib (Zig's honesty call — anonymizing wasn't honest), with a
  **byline affiliation "Andrew Zigler, LinearB"** and the §6 product-rec use **cut**
  (cite-once). §3 re-aimed (two failure classes), §5 sharpened, §2 SEP-2243 restored.
  Full trail: the submission's `REVIEW-NOTES.md` changelog (rounds 4/4b/4c).
- Final-recheck list carries the pre-publish items (07-28 Final re-verify, etc.).

**Harness improvements (Fable review → 4 workers merged):** scoring ladder fixed
(`18o.35`, was live-wrong); `ship-gates.md` + `gates.sh` runner (`18o.36`); amplify
engine — `/amplify` skill + SUBMISSIONS pulse table (`18o.38`); doc-drift true-up +
`UNIGNORE-REVIEW.md` (`18o.40`, flagged a **real tailnet-IP leak** in the gitignored
tutorial `article.md` — redact before any un-ignore). 15 harness beads filed
(`18o.35`–`18o.49`); remaining ones + `18o.37` (07-28 timer — infra, unwired) queued.

**`/storybook-header` skill (v1.1)** created + updated: the goose aesthetic, the
**ZIG-NN serial Easter-egg** convention, and "stay authentic" (not-Yegge-industrial,
not-generic-AI-cozy). The goose is **unnamed** — "ZIG-00" was only the biplane tail number.

**Images (approved by Zig):** the **differentiated goose motif set** (canal lock /
grain-sort / seed-library / dovecote / weather-station / rope-splice, each hiding a
`ZIG-0N` egg). Prompts: `blog/motif-prompts/`. PNGs in scratchpad (regenerable via the
skill). Earlier: the Earned-Autonomy header candidates (far-pasture/ledger/shepherd,
pencil removed, full-bleed) + a first 9-motif animal stash. All need `/cdn`-stash (bead).

**Blog (`aaif-uf3`):** drafts v1→v4 in `blog/drafts/` (v4 = current best, actionable,
1045w). Zig's latest: it's close but needs the EXPERIMENT data + the insider playbook +
the identity/hash backbone — i.e. reshape once the experiment exists. Actionability
menu (blog-light vs whitepaper-deep): `blog/actionability-menu.md`.

## Open decisions carried for Zig
- `18o.45` — session-handoff tier (public vs `.local`); `18o.46` — pick August's anchor.
- Blog v4 length (likely moot; the experiment reshapes it).
- The exact contrived experiment task/repo (propose 1–2 next session, align first).

## Warnings
- **HARD GATE:** nothing publishes/submits to AAIF / andrewzigler.com / LinkedIn / DI
  without Zig's explicit go-ahead — every time.
- **No Fable** for the experiment arc (cost). Fable WAS used earlier this session with
  Zig's explicit per-task OK; the standing guardrail (memory `feedback-no-fable-without-permission`)
  still holds — ask first.
- The ad-hoc **tailnet review server (`:19234`) dies with this session** — regenerate the
  gallery next session from `blog/motif-prompts/` if Zig wants to review images again.
- **End turns needing Zig's input with AskUserQuestion**, not trailing prose (he flagged
  this — prose reads as idle/✅, not 🔔).
