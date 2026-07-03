# Session handoff — 2026-07-03 (GRADUATED to ~/aaif; gateway o11y skill bundle shipped + demoed)

## ⭐ Just graduated
This project **graduated out of `~/explore/aaif` (submodule) to `~/aaif` (top-level project)
on 2026-07-03** via `/graduate`. Claude state + memory now live under the
`-home-ubuntu-aaif` slug; this session reads only the global `~/.claude/CLAUDE.md` + this
repo's `CLAUDE.md` — no more explore umbrella. `br` in `~/aaif/.beads` works unchanged.
(A `~/.claude.json.pre-graduate-aaif-backup` was kept.)

## ⚠️ ACTION REQUIRED — restore `.local/` (lost in the graduation)
`/graduate` clones the repo, which **does not carry the gitignored `.local/`** — and
`git submodule deinit -f` **deleted the original** `~/explore/aaif/.local/` with the old
working tree. No backup was found on this box. **`~/aaif/.local/` must be restored from
your originals** before tutorial/submission work: the AAIF Handbook + social-guide PDFs
(`.local/program-pdfs/`), the Asana planning-hub IDs, and `.local/private-notes.md`. The
PDFs and Asana IDs are recoverable from source; check whether `private-notes.md` had
anything not already distilled into `refs/` + memory. **Skill gap:** `/graduate` should
migrate `.local/` (copy the private dir across) — worth fixing in the toybox skill.

## State at offboard
- Location: `~/aaif` · branch `main` · clean + pushed (remote `azigler/aaif`, public).
- Open beads: run `br ready`. Top P1s: `aaif-715` (the shippable tutorial), `aaif-49y`
  (monthly-drop pipeline), the `.5`/`.6` submissions.
- No in-flight subagents; no worktrees.

## What happened this session
1. **Shipped the gateway o11y skill bundle** (all verified against a live request-log
   snapshot, all committed + pushed):
   - `refs/gateway-request-log-cookbook.md` — the verified DuckDB-over-SQLite query
     foundation (SQLite-write / DuckDB-read split; schema; empirical gotchas).
   - `/gateway-cost` (tokens + cache economics + $-only-when-priced), `/gateway-watch`
     (near-real-time threshold alerts), `/gateway-trace` (one request/session, id-keyed,
     privacy-gated payloads), and a `/gateway-audit` retrofit (DuckDB as preferred source,
     text log as fallback). Registered in `CLAUDE.md` (routing + layout).
   - Beads closed: `aaif-jwq`, `aaif-jl8`, `aaif-ou1`, `aaif-e7t`, `aaif-wx6`,
     `aaif-ambassador-program-18o.27`, and the human bead `aaif-46m` (Zig walked the plane).
2. **Demoed all four skills live** against the running gateway (526 calls). Real findings
   ready as tutorial material: `cache_read` ≈ 35.9M tokens (99.6% of input from cache —
   CC's repeated compaction), `cost` NULL → tokens-only (honesty gate working), 403 (goose
   local-model Origin rejects) + 429 (CC rate-limit) clusters, p95 ~52s / max ~135s.
3. **Two tempered-realism findings** captured in `~/explore/agentgateway/refs/capability-map.md`:
   the 2 MiB `maxBufferSize` compaction-503 (fixed → 32 MiB), and Remote Control being
   disabled when CC runs through the gateway (custom base URL → no first-party control plane).
4. **Cookbook Pattern B hardened from the live demo**: a 77 MB DB (payload capture bloats it
   fast) truncated under a plain `scp` → `database disk image is malformed`; fix = gzip the
   remote snapshot + `PRAGMA integrity_check` both ends.

## What's next — phase 2: the tutorial (`aaif-715`), the monthly anchor
- Clean setup → full instrumentation walkthrough (goose + local ollama + Claude + the
  cc-gw toggle). **EXCLUDE Tailscale/tailnet** (bind localhost/LAN). Section-by-section,
  tempered-realism, applied-academic voice, "As above, so below."
- **Self-made screenshots** via Playwright on this box (Zig only reviews). The live demo
  reports above are ready-made section material.
- **Zig's architecture decision (2026-07-03):** frontier **CC stays direct** (keeps Remote
  Control + first-party features); the **goose/local fleet goes behind the gateway** (where
  per-agent `apiKey` identity + o11y + allowlists are the point, and keyed rows give cleaner
  attribution). This split IS the tutorial's spine — the two findings above are the "why."

## Warnings / watch-outs
- Hard rules unchanged: **never publish/submit to AAIF without Zig's explicit go-ahead**;
  no ambassador gossip in committed content; two-tier knowledge rule (private infra/keys →
  `.local/`, generalize in public refs); SSH+tmux (plain URLs, no images); always commit + push.
- The gateway runs on the home Mac over the mesh; its request-log DB is at
  `~/.local/share/agentgateway/requests.db` (generalize infra names in public refs).
- This handoff was written by the graduating session; the old `~/explore/aaif` slug is retired.
