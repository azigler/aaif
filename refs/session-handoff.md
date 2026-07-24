# Session handoff — the Earned-Autonomy EXPERIMENT is complete (result in hand)

## ⭐ STATE: experiment done + committed; write-up phase awaits Zig's review

Zig chose **"take stock first — you review"** at the experiment's completion. Nothing in the
write-up phase has started. Everything below is committed + durable. Resume when Zig steers.

## WHERE TO REVIEW (Zig's take-stock)
- **The result:** `submissions/2026-mcp-governance-whitepaper/experiment/PLAN.md` → the
  "FULL MATRIX RESULT" + "Resolution IS tool-sensitive" sections (the headline finding).
- **Figure data:** `experiment/results/matrix-behavior.json` (per-config tokens/calls/edits/
  composition + per-cell timing/diff — ready for the figures).
- **The reposition plan:** `submissions/2026-mcp-governance-whitepaper/REPOSITIONING.md`
  (thesis-preserving; new §6 case study; 5 figures; blog + LinkedIn angles; risks) +
  `research/evidence-roundup-inverted-u.md` (11 cited sources + BibTeX + honesty flags).

## THE RESULT (what the experiment proved — measured in our own data)
A governed tool-ablation (goose + qwen3-coder:30b, tools gated per-identity at an isolated
agentgateway on pico, audited per call). 6 configs × 4 SWE-bench-Verified instances. The
**inverted-U holds across three axes**:
- **Cost (tokens):** U-shape, MIN at nucleus-6 (340k); readonly-3 (733k) + bloated-38 (476k) higher.
- **Productivity (edits):** inverted-U, edit calls peak at nucleus (5), 0 at readonly.
- **Resolution/efficiency** (on the engageable instance pylint-6903): readonly (no edit tools)
  **can't resolve** (left arm); all edit-capable configs resolve but **bloated is 2.6× slower**
  than nucleus (right arm). SWE-bench Docker eval verified (gold-validated pipeline).
- **Governance findings:** extra tools pull the agent to low-value actions (full→
  `list_allowed_directories`, bloated→`sequentialthinking` distractor); **0 denials everywhere =
  governance-by-hiding** (allowlist hides gated tools from tools/list; agent never attempts them).
- **The honest floor:** 3/4 instances the model diagnoses but won't commit to editing — **weak
  action closure** (robust across qwen3-coder, devstral, qwen3:32b); a frontier model would close
  it but trades the self-hosted framing. This IS *accuracy≠delivered-outcome*, live — on-thesis.

## LOCKED DECISIONS (all Zig's, this arc)
- Experiment = governed tool-ablation on SWE-bench (not a hand-crafted bench — Goldilocks-proof).
- Outcome metric = **behavior-primary, stay local**; resolution = the floor finding.
- Whitepaper: **bridge holds (one paper)**; **pilot shows direction + literature carries the shape
  + mise-style close on next-experiments**; length argument-driven/tight (~7–9pp, prune weak parts).
- MCP metadata logging is **metadata-only, no contents** (doc- + empirically-confirmed).

## NEXT PHASE (the write-up — human-gated, awaits Zig's steer)
1. Build the figures from `matrix-behavior.json` (cost-vs-toolset U curve; per-config edit
   productivity; pylint efficiency gradient; stage-of-use). 2. Draft whitepaper **§6** case study
   per REPOSITIONING.md. 3. Reshape the blog (`aaif-uf3`) + draft the LinkedIn post. 4. **STOP at
   Zig's submit-gate** — nothing ships to AAIF / andrewzigler.com / LinkedIn without his go-ahead.

## INFRA STATE (on pico)
- The **isolated experiment gateway is still UP** on pico (spare ports 25000/25001/25003, 6
  config-identities, 5 MCP servers). Reusable for more figures/data. Tear down when done:
  `ssh pico "pkill -f 'agentgateway -f /tmp/exp-gateway.yaml'"`. It never touched the live gateway.
- Keys in `/tmp/exp-keys.json` on pico (NOT committed — secrets). Workspace `/tmp/exp-workspace`.
- ollama: qwen3-coder:30b loaded (shared with live goose — same model, no clobber). One-model rule
  honored (`keep_alive:0` to unload before switching).
- The **live gateway** already logs MCP metadata (5,666+ lines, no contents) — Zig's blind-spot
  question is answered; DB/UI for MCP isn't native (access-log only).

## WARNINGS
- **Zig's submit-gate** — nothing to AAIF/andrewzigler.com/LinkedIn/DI without explicit go-ahead.
- **No Fable** without permission (this whole arc used regular sub-agents + local models).
- Experiment key + tailnet IP (100.72.47.4) are in pico-side files only — never commit them
  (two-tier rule); generalize private infra in any published figure/caption (REPOSITIONING R-6).
- `/aaif-radar` W29 ran this session (note bead aaif-1ax, ledger row) — landscape confirms the
  agentgateway-governance lane is under-served (whitepaper well-positioned); blog over-rotated
  (differentiate the companion blog).
