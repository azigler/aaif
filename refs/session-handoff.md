# Session handoff — 2026-07-08/09

Marathon session on the AAIF gateway tutorial. Ended with a Zig-directed re-architecture
spec'd into **`aaif-yw5`** for a FRESH session to execute end-to-end (this context is saturated —
that's the point: a clean window drives it better).

## THE NEXT ACTION (read this first)
Onboard, then execute spec bead **`aaif-yw5`** (`br show aaif-yw5`) end-to-end:
Phase 0 — consolidate the 5 `gateway-*` skills into ONE `agentgateway` skill →
Phase 1 — substance-first rewrite of the tutorial (fix the real gaps) →
Phase 2 — workflow hardening (parallel fresh-eyes critiques incl. a dedicated **story-fidelity**
agent → synthesis → final cold read) →
Zig review → push to the **GIST FIRST**, then metis vault.
Private execution specifics (infra, IPs, keys, asset IDs, screenshot rig, delivery paths, config
ground truth, full fact list): **`.local/goose-tutorial-execution.md`** — read it like `refs/`.

## State at offboard
- Branch `main`, clean/pushed after this commit. Tutorial working files are gitignored (`submissions/`).
- The tutorial lives in a SECRET review gist (id `11ee0236e263b31d9d2237070941e961`); current content =
  the v5 "nursery-rhyme" draft that Zig **rejected** as over-whimsical / vaporous / structurally gapped.
  `aaif-yw5` is the plan to replace it. The whimsy over-rotated; the substance (model setup, MCP
  virtualization + per-agent scoping) is missing.
- Header v2 (branded: ZIG-00 wing / TINY-TOOLS fuselage / AAIF-logo roundel, 1200x630) is LIVE on the
  gist + the publish file. Keep it.
- Delivery HELD (nothing to metis). Metis Obsidian vault is the source (git flows FROM metis); deliver
  gist-first after Zig's explicit okay.

## What happened this session (highlights)
- dotfiles committed (cc-gw toggle rework, effortLevel xhigh, Hermes PATH). Vendored the
  aaif-blog/brand-guidelines skills into `~/aaif/.claude/skills` (fixed broken dotfiles symlinks).
- `/aaif-radar` W27 delta (AGENTS.md→tooling; agentgateway governance content appearing; note `aaif-hip`).
- Gateway forensics: the "CC still routing through the gateway days later" traffic = **stale
  `ANTHROPIC_BASE_URL` baked into long-running CC processes** on zig-computer (an `~/explore` session +
  2 linearb ones), NOT metis; the iPhone `Anthropic`-SDK rows were smoke tests. cc-direct config is
  clean; the leak is per-process env, not config. RC-vs-gateway coexistence is un-retestable from the
  gateway log (no CC version / no RC visibility) — documented, do not re-flip the memory.
- Tutorial arc: fact-checked → applied Fable's editorial review → honk→tiny-tools → Goose capitalized →
  retitled to the mouse-cookie snowclone → full v5 rewrite → header remade (nano-banana, 2 gens ~$0.20)
  → **Zig rejected v5 for over-whimsy/no-substance** → the `aaif-yw5` re-architecture spec.

## Warnings / watch-outs
- The rewrite must be SUBSTANTIVE + technical ("wouldn't earn a technical leader's respect" was the
  verdict). Whimsy = a CORRECT, light "If You Give a Mouse a Cookie" touch in the SECTION HEADERS only,
  not scattered cutesy lines. Verify every fact (the `.local` fact list) survives hardening.
- Two-tier rule: no pico IPs/paths/keys/ollama-baseUrl in committed content or the tutorial (generalize
  to `localhost`). New screenshots (the Models view) need redaction (regenerate leaky cells).
- Hard rule stands: never submit to any AAIF surface without Zig's explicit go-ahead. The gist is a
  personal review draft (editable); the AAIF submission is separate + gated.
- `/openrouter` + the Workflow tool are cost/token-heavy; Zig explicitly authorized the workflow for
  `aaif-yw5`.
