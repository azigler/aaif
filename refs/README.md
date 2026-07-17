# refs — the AAIF ambassador research archive

Active reference material the harness loads to do the work. The deliverable of
"comprehension first": grounded, greppable, and cited.

## Index

| File | What it is |
|---|---|
| [`aaif-overview.md`](aaif-overview.md) | What AAIF is — mission, the four projects, members, the GitHub org (working groups, public-agents, landscape), channels. |
| [`gateway-request-log-cookbook.md`](gateway-request-log-cookbook.md) | The verified DuckDB-over-SQLite query cookbook (schema, gotchas, tested queries) the `/agentgateway` skill's four components share. |
| [`research-paper-pipeline.md`](research-paper-pipeline.md) | The venue-neutral research-paper / whitepaper cookbook — the deep reference behind the `/research-paper` skill. |
| [`pulse-ledger.jsonl`](pulse-ledger.jsonl) | Append-only JSONL record of autonomous loop ticks (e.g. `aaif-radar`) and their outcomes/proof — so nothing runs unaccounted for. |
| [`session-handoff.md`](session-handoff.md) | The rotating handoff note written by `/offboard` — the state at the end of the last working session (open beads, what to do first next). |
| **`program/`** | The Ambassador Program itself. |
| [`program/ambassador-program.md`](program/ambassador-program.md) | **Authoritative mechanics** — commitment, contribution types, the submission workflow, the points table, scorecards, perks, renewal. Distilled from the handbook. |
| [`program/strategy-top-ambassador.md`](program/strategy-top-ambassador.md) | The playbook — what "top ambassador" means, Andrew's leverage, the cadence engine, selection heuristics, opening moves. |
| [`program/brand-and-social.md`](program/brand-and-social.md) | Badge kit, bio language, tagging/handles, year-round post formats. |
| [`program/voice-and-posting-examples.md`](program/voice-and-posting-examples.md) | Canonical exemplars of how Zig posts about AAIF — the register to match; pairs with `brand-and-social.md` and the global `/zig-voice`. |
| [`program/ship-gates.md`](program/ship-gates.md) | The ship gates — the hard verification checks a contribution clears before it ships (anti-slop, never-touch-AAIF-without-Zig, no-peer-gossip). |
| **`projects/`** | Per-project contribution-surface briefs (where to contribute, current state, 6 tailored ideas each). |
| [`projects/agents-md-and-public-agents.md`](projects/agents-md-and-public-agents.md) | AGENTS.md + public-agents — **Andrew's strongest lane.** |
| [`projects/goose.md`](projects/goose.md) | goose — local-first agent framework. |
| [`projects/agentgateway-and-working-groups.md`](projects/agentgateway-and-working-groups.md) | agentgateway + the 7 working groups + landscape. |
| [`projects/mcp.md`](projects/mcp.md) | MCP — the protocol. |
| **`brand/`** | Logos, the Credly badge, the announcement header. |

## Provenance

The program docs (`program/`) are distilled from the official AAIF Ambassador
Handbook + social sharing guide + aaif.io. **The source PDFs are held privately
(in the gitignored `.local/`), not republished here** — we share our distilled
notes, not AAIF's documents verbatim.

> 📎 **`.local/` is the private half of this archive.** It's gitignored (never
> committed/published) but it's still **reference material — read it like `refs/`**:
> the authoritative source PDFs live in `.local/program-pdfs/`, and the Asana
> planning-hub IDs + private notes in `.local/private-notes.md`. Consult it for
> grounding; never copy its contents into tracked files. (Harness rule in
> `../CLAUDE.md`.) The project briefs (`projects/`) were researched 2026-06-24
against the live repos via web fetch + the GitHub API; each carries its own
sources + accuracy flags. **Re-verify before publishing** — these projects move
fast.
