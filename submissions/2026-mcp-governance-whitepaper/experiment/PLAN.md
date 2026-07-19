# Earned Autonomy — the experiment + 3-altitude arc (staged 2026-07-17)

> **Read this first next session.** It stages everything Zig directed in the
> 2026-07-17 session. Context ran out mid-arc; nothing here has been executed yet.
> Companion beads carry the actionable units (see "Beads" at the end).

## The directive (Zig, 2026-07-17)

The blog/whitepaper argument is still too abstract. Zig cannot fully connect the
dots between **MCP's new shape** and **delivered outcomes**, and we never hand over
an **insider playbook** for how "earned autonomy" (give tools → audit tool usage →
add/remove tools on evidence) actually works in reality. Fix it by **running a real
experiment** — a contrived-but-fully-baked mini case study — that stands up the
governance layer on MCP and **demonstrates the per-call auditing loop with real
metrics, logs, trends, and graphs.** That data becomes the backbone for all three
altitudes.

**Calibration target:** ThoughtWorks / Martin Fowler's "Exploring Gen AI" local-models
articles (full analysis: `../research/thoughtworks-fowler-calibration.md`). That level
of usefulness — an evaluation *framework* with a clear beginning→end, real data,
screenshots + comparison graphics, honest limits, a reproducible setup, one clear
recommendation — is the bar.

## THE EXPERIMENT (the backbone)

**Goal:** show, not tell. Stand up the proposed governance layer and produce a mini
case study proving MCP's new shape makes agent **impact auditable and governable**.

- **Governance layer:** the live **agentgateway** (on `pico`; see infra + the
  `/agentgateway` skill). Per-call **tier-gated authz already validated** (whitepaper
  exhibit, commit `a05e454`): tool scope gated per workflow identity/tier.
- **Agents/workflows:** a small set of agent workflows performing a **defined,
  contrived task** (e.g. opening changes/PRs in a baked-up repo) under **different
  tool configs / permission tiers.**
- **The manipulation (the actual experiment):** **change / add / remove MCP tool
  permissions** across runs and observe the **downstream impact.** Link
  `config → tool usage (per-call gateway audit) → delivered outcome`.
- **Metrics — deliberately LinearB-synonymous** (so they map to what we already
  care about): merge rate, revert rate, rework, held-in-production, **cost-to-outcome**
  (tokens per merged-and-held change), PLUS the per-call audit (which tools each
  identity used, allow/deny counts). Deliver **trends a leader can watch** to quantify
  the **safety + impact of their MCP tools as connected to their agents.**
- **Data sources:** the agentgateway **SQLite request log** (query via the
  `/agentgateway` skill + the verified `refs/gateway-request-log-cookbook.md`) +
  the contrived repo's outcome data. **Beginning → intervention → end**; collect it all.
- **Output:** a mini case study — logs, snippets, computed metrics, **trend charts +
  screenshots + LaTeX diagrams** — foundational for the whitepaper; excerpts for the
  blog; teased in the LinkedIn post.

## THE AGENT-IDENTITY / CONFIG-HASH MODEL (the missing backbone)

Zig's key insight — *what do you attribute impact to?* The unit needs **two**
identities:

1. **A consistent identity** — the durable workflow (stable across runs).
2. **A variable / version identity — a HASH of the config snapshot:**
   `hash(prompt + MCP tools as configured)` (extend to model + policy as needed).
   - **Same hash ⇒ configured identically ⇒ runs are directly comparable.**
   - **Different hash ⇒ the setup changed** — and you can attribute the downstream
     delta to that change.

This is the backbone that makes the whole thing **actionable**: it lets you track a
workflow's behavior/impact **over time**, and **link permission changes to downstream
impact** (change/add/remove tools → new hash → measure the delta). Bake it into the
experiment AND deepen whitepaper **§5** (workflow-configuration-as-unit-of-trust gains
a concrete version key).

## THREE ALTITUDES (each carries the tangible playbook at its own depth)

Funnel: **LinkedIn → blog → whitepaper.** The experiment's data/graphs feed all three;
the "how to actually do it" playbook is sprinkled at three depths.

1. **LinkedIn post** *(NEW — highest altitude).* Very **Zigler-coded**: his voice,
   **short, sweet, fun, quirky.** Calibrate to his **inaugural "I've just been selected
   as ambassador"** post (the fun/quirky spirit everyone loves). Teases into the blog,
   mentions the paper lightly. Light sprinkle of the tangible idea. → **`/zig-voice`.**
2. **Blog** *(v4 exists — `blog/drafts/v4-actionable.md`; reshape).* Mid-depth playbook +
   **experiment excerpts, snippets, and 1–2 graphs.** Absorbs the identity/hash idea at
   mid depth. (v4 status: good actionability, but grew to 1045w — trim during reshape.)
3. **Whitepaper** *(`aaif-51g`; deepest).* **Fold in all 5 actionability ideas**
   (bead `aaif-51g.1`, Zig confirmed "fold all 5") + the **experiment case-study data +
   graphs (LaTeX diagrams — lean on LaTeX)** + the **agent-identity/config-hash model** +
   the full insider playbook.

## PROCESS CONSTRAINTS (Zig)

- **NO Fable — too expensive.** Use the **Workflow** tool dispatching **regular
  sub-agents**: scientific runners to execute the experiment, a **critic**, and a
  **synthesizer** to tie it together. Use **beads** throughout.
- **Scope the experiment properly:** a clear beginning + end, collect the data, **map
  the trend/behavior, and give real examples** (logs/snippets/graphs).
- Prefer contrived-but-fully-baked over waiting on real production data.

## STAGED ARTIFACTS (all preserved / regenerable)

- **Blog drafts v1–v4:** `blog/drafts/` (v4 = current best).
- **Actionability menu** (blog-light vs whitepaper-deep split): `blog/actionability-menu.md`.
- **ThoughtWorks/Fowler calibration analysis:** `../research/thoughtworks-fowler-calibration.md`.
- **Image work:** APPROVED = the **differentiated goose set** (canal lock / grain-sort /
  seed-library / dovecote / weather-station / rope-splice; each hides a serial `ZIG-0N`
  Easter egg). Prompts saved in `blog/motif-prompts/`; the PNGs live in this session's
  scratchpad gallery + are **regenerable via the `/storybook-header` skill** (v1.1, which
  encodes the whole aesthetic + the ZIG-NN egg convention + the "stay authentic /
  not-Yegge / not-generic-cozy" rules). **TODO next session:** cut 2K finals of the
  keepers, `/cdn`-stash, log a manifest with the ZIG-0N numbers reserved in order.
- **Live review server** (dies with this session): `http://zig-computer.tailfb4637.ts.net:19234/`
  had the headers + both motif stashes + the blog. Regenerate the gallery next session if needed.

## NEXT-SESSION EXECUTION ORDER

1. Read this + `../research/thoughtworks-fowler-calibration.md` + the `/agentgateway`
   skill + `refs/gateway-request-log-cookbook.md`.
2. Lock the experiment design: the contrived repo + task, the workflow configs, the
   permission interventions, the config-hash definition, the metric set.
3. Stand up the governance layer on the gateway (per-call tier-gated authz — the
   exhibit pattern already works).
4. Run **baseline → intervention → measure** with scientific sub-agents (Workflow, no Fable).
5. Pull the gateway request log + repo outcomes; compute metrics + **trends**; make graphs.
6. Write the case study (Fowler-calibrated: framework, data, graphs, honest limits, setup).
7. Fold into the whitepaper: all 5 ideas + the data + graphs (LaTeX) + the hash model.
8. Reshape the blog (excerpts + graphs + mid-depth playbook; trim).
9. Draft the LinkedIn post (Zigler voice, calibrate to the inaugural post).
10. **STOP at the Zig submit-gate** (hard rule — nothing to AAIF/andrewzigler.com/LinkedIn without his go-ahead).

## OPEN DECISIONS CARRIED FOR ZIG

- Blog v4 disposition (trim to ~900 vs ship) — likely moot; the experiment reshapes it.
- Image keepers to finalize/`/cdn`-stash + the ZIG-0N numbering.
- ~~The exact contrived experiment task/repo (propose 1–2 next session, align).~~ → **RESOLVED, see DESIGN LOCKED below.**
- Harness decision beads still open: `18o.45` (handoff tier), `18o.46` (August anchor).

---

## DESIGN LOCKED — 2026-07-17 (session 2, the benchmark pivot)

Zig reshaped the experiment away from a hand-crafted **seeded bench** (Goldilocks-unbeatable
for a capable local model — you can't reliably build a fake edge case where the *tool* is the
measurable difference; he's tried, it doesn't work) toward a **governed tool-ablation on a real
benchmark.** Every decision below is Zig's explicit call this session.

**Locked design:**
- **Frame:** hold the subject agent FIXED, vary ONLY the gateway-gated toolset → any outcome
  delta is attributable to tools alone (cleaner than the published 50%-vs-19% swing, which
  changed the whole agent framework and conflated scaffold-quality with tool-set).
- **Runtime:** **goose 1.41.0** (already on zig-computer) + model **qwen3-coder:30b** (local, on
  pico) + MCP tools via the **pico agentgateway** (identity `goose`, per-call authz + audit).
- **Tasks:** curated subset of **SWE-bench Verified** (~15–25 medium-difficulty instances;
  benchmark-native hidden tests = objective, standard scoring — no contrivance from us).
- **Evidence weighting:** **audit-spine (bulletproof, already-real gateway data) + outcome-bonus
  (robust because it's a RELATIVE delta across configs, not an absolute score).**
- **Ablation strategy:** **full baseline + leave-one-out (isolate each tool's marginal
  contribution + STAGE) + one bloated config (>20 tools → distraction cliff).** Answers "which
  tool matters, why, at what stage" AND the U-shape sweet-spot = "earned autonomy" arc.
- **config-hash backbone:** `hash(prompt + tool manifest)` per config; same hash ⇒ comparable,
  different hash ⇒ attribute the downstream delta to the change.
- **Compute:** **PILOT FIRST** — 3–5 instances × 2 configs (full vs one load-bearing tool
  removed) to prove the `goose → gateway → SWE-bench` harness end-to-end, confirm the effect
  direction shows, and TIME one run to size the full matrix. Then decide the full run together.

**Why Goldilocks is off the table (the homework, 2026-07-17):**
- SWE-bench Verified for qwen3-coder-30b-a3b: **~50–52%** (OpenHands, 100-turn rich scaffold) vs
  **~18.8%** (bash-only mini-swe-agent) — a **~30-point swing from tooling alone**, published for
  this exact model. The effect is real, large, measurable; LiveCodeBench 40.3 (headroom).
- Ablation literature is a **U-shape:** too few load-bearing tools → can't complete (CompAgent F1
  0.93→0.68 on core-tool removal); too many → distraction/hallucination cliff past ~20 tools
  (OSWorld-MCP 20.5→15.5 exposing all 158; Block/goose + Copilot cite a 5–15 sweet spot).

**Infra grounding:** Docker daemon running on zig-computer (132 GB free, 12c/45 GB); local 30B
inference on pico is the throughput bottleneck. Gateway request DB is live on pico; goose reaches
its MCP tools through the pico gateway (identity `goose`, nucleus allowlist already configured).

**Feasibility risks to surface AT the pilot:** (1) SWE-bench eval = per-repo Docker images (disk +
setup); (2) local 30B inference is slow (throughput bounds the matrix size); (3) the
tool-variation mechanism — gateway `mcpAuthorization` allowlist per config vs a DEDICATED
experiment-gateway instance on a spare port — must be chosen so we never disturb the live gateway
or pollute its request DB with experiment traffic.

**Pilot execution order (this arc):**
1. Scaffold `experiment/` workspace (harness/ · data/ · configs/ · results/).
2. `pip install swebench`; pull SWE-bench Verified; pick 3–5 medium instances (Python, headroom).
3. Inventory the tools the gateway exposes to goose (`tools/list`); define full-set + the
   leave-one-out target.
4. Choose + stand up the tool-variation mechanism (dedicated experiment gateway preferred).
5. Write config-hash + the per-run harness (run goose on an instance under a config → capture
   trajectory → SWE-bench eval → pull the gateway log window).
6. Run pilot; time it; check effect direction; report to Zig to size the full run.
   **Workflow + regular sub-agents (NO Fable) for the RUN fan-out; setup is orchestrator/worktree.**

### SUBSTRATE PROVEN — 2026-07-17 s2 (the governance layer is live end-to-end)

- **Isolated experiment gateway stands up on pico** (spare ports 25000/25001/25003, own DB
  `exp-requests.db`, fresh `sk-exp` key, launched with PATH so npx/uvx spawn). NEVER touches
  the live gateway. Config lives at `/tmp/exp-gateway.yaml` on pico (key in `/tmp/exp-gw.key`).
- **Both audit paths work:** LLM cost → the request DB (`llm|qwen3-coder:30b|exp|in|out|200`);
  MCP tool calls → the **access log** (`/tmp/exp-gateway.log`), tagged `agent="exp"`, carrying
  `gen_ai.tool.name` / `mcp.method.name` / `mcp.target` / `mcp.session.id` / status / duration.
- **MCP logging is METADATA-ONLY, doc- + empirically-confirmed:** a marker string passed as a
  `write_file` arg and returned as a `read_text_file` result appears NOWHERE in the logs/DB.
  Contents (`mcp.tool.arguments`/`mcp.tool.result`) are opt-in CEL fields we never add. Native
  SQLite/UI persistence is LLM-only; MCP lives in the access log (+ OTLP). Zig's live gateway
  ALREADY logs MCP metadata (5,666 lines) — the blind spot was already closed; DB/UI for MCP
  isn't native.
- **goose driver PROVEN:** goose (zig-computer, isolated via `XDG_CONFIG_HOME=/tmp/expcfg`,
  provider host/key via env `OPENAI_HOST`/`OPENAI_API_KEY`) executes NATIVE tool calls through
  the exp gateway (`honk` extension → `:25001/mcp`, model → `:25003`). Earlier text-format
  failures were transient COLD-START (npx/model warm-up), not config. Ablation lever = the
  `mcpAuthorization` allowlist for the `exp` identity (full=14 fs tools+fetch / nucleus=6 /
  bloated=pad >20). Tool inventory confirmed via `tools/list`.
- **Architecture:** gateway+filesystem-MCP on pico (repo working copies there), goose on
  zig-computer, model inference on pico; SWE-bench Docker eval on zig-computer (pull the diff).
- **NEXT:** load SWE-bench Verified → pick ~3–5 mid-difficulty pilot instances → clone one on
  pico + root the fs MCP there → goose run under the full toolset → extract diff → SWE-bench
  eval → pull the tool audit. That's the pilot smoke test; then the full ablation matrix.

### PILOT SMOKE COMPLETE + THE OUTCOME FLOOR — 2026-07-17 s2 (definitive)

**Full pipeline PROVEN end-to-end:** a real goose run through the governed gateway →
MCP `edit_file` → diff → SWE-bench Docker eval → **RESOLVED 1/1** (`psf__requests-1142`,
devstral forced run; gold patch also validated → resolved; eval ~20s once the image is built).

**Two harness fixes found + applied:** (1) goose runs must **disable the built-in
`developer`/shell extension** — otherwise the agent bypasses the governed MCP tools via
ungoverned local shell (which also ran on the wrong host); forcing all tool use through the
MCP surface is both the fix AND a whitepaper point ("the gateway only governs what flows
through it"). (2) Run cap ~300–500s; ollama **one model in memory** (unload via
`POST /api/generate {keep_alive:0}` before switching).

**THE FLOOR (Zig's delegated find), characterized as a clean gradient — robust across
qwen3-coder:30b AND devstral-small-2:**
- Raw problem statement → model **diagnoses correctly, plans (todo), but NEVER calls
  edit_file** → empty diff → unresolved.
- "You MUST apply the edit" forcing prompt → still no edit → unresolved.
- Exact fix spelled out + edit forced → **applies it correctly (== gold) → RESOLVED.**

So **autonomous SWE-bench resolution floors** on these local agents: task-understanding far
outruns delivered outcome — they read/plan but won't self-commit to the edit. The edit *path*
works (proven); the wall is autonomous *commitment*.

**This REINFORCES the thesis** (not a setback): "diagnose but don't deliver" is exactly
*delivered-outcome > task-accuracy*, observed live — and the gateway audit makes the gap
visible. Resolution can't give a tool-config differential (floors ~0 across configs), but the
**rich audit signal is very much tool-sensitive**: read/edit ratio, localization behavior,
tokens/cost, convergence-vs-flailing, stage-of-use, allow/deny — all measurable per config.

**RESHAPED OUTCOME METRIC (proposed):** primary signal = **tool-use behavior from the audit**
(how the ablation changes HOW the agent works the tools); resolution reported honestly as a
**floor finding** that demonstrates accuracy≠outcome, with the forced run as proof the pipeline
resolves. Ablation across full / nucleus / leave-one-out / bloated then measures the behavior
delta (e.g. does bloat increase flailing/tokens? does removing search break localization?).

### OUTCOME METRIC LOCKED — 2026-07-18 (Zig): BEHAVIOR-PRIMARY, STAY LOCAL

Empirically grounded: **three local models all floor on autonomous resolution** (qwen3-coder:30b
read-heavy + missed edit; devstral diagnosed→`analyze` misfire→to-do→no edit; qwen3:32b read once
then stalled in reasoning). Mechanism = **weak action closure** (gather/plan/reason without
committing to the state-changing edit) — a capability gap a frontier model would close, but that
trades away the self-hosted framing. Zig's call: keep it **local**, outcome = **tool-use behavior
from the audit**, resolution = the floor finding (which IS the accuracy≠delivered-outcome thesis,
live; the gateway audit makes the gap visible).

**Ablation mechanism (built):** one gateway, **five config-identities** — `exp-full` (all ~15
tools), `exp-nucleus` (6), `exp-nosearch` (5), `exp-noedit` (5, must write_file), `exp-readonly`
(3, no write/edit at all). Each is an apiKey with its own `mcpAuthorization` allowlist, so the
audit auto-attributes tool calls per config with NO per-run gateway restart. Subject fixed =
goose + qwen3-coder:30b, shell disabled (forced through the governed MCP surface). Driver:
`harness/run_ablation.sh`. Behavior metrics per config: tool counts, reads-per-edit / gather-vs-act,
localization, denials (removed-tool attempts), tokens (from DB), stage-of-use, diff-produced.
First matrix (5 configs × psf__requests-1142) RUNNING; then more instances + a bloated config.

### FIRST ABLATION RESULT — 2026-07-19 (5 configs × psf__requests-1142, n=1, qwen3-coder:30b)

Resolution floored uniformly (**0/5 produced a diff**) — confirms resolution is config-independent
(→ behavior is the signal). But **tool-use behavior IS tool-config-sensitive**, measurably, even at n=1:

| config | tool calls | denied | tool kinds | composition | LLM tokens |
|---|---|---|---|---|---|
| full (~15) | 10 | 0 | 4 | read 6, list_dir 2, **list_allowed_dirs 1**, search 1 | **114,184** |
| nucleus (6) | 8 | 0 | 3 | read 5, list_dir 2, search 1 | 96,019 |
| nosearch (5) | 9 | 0 | 2 | **read 7**, list_dir 2 | 96,161 |
| noedit (5) | 9 | 0 | 2 | read 7, list_dir 2 | 98,132 |
| readonly (3) | 10 | 0 | 3 | read 7, list_dir 2, search 1 | 99,205 |

**Signals (n=1, suggestive — firm up with more instances):**
- **Over-provisioning is inefficient:** the full toolset burned **~19% more tokens (114k vs 96k nucleus) for the same zero outcome** — the "more tools, more cost, no gain" arm, observed in our own data.
- **Extra tools → wasteful exploration:** only `full` reached for `list_allowed_directories` (a low-value tool present only in the big set) — distraction from the larger surface.
- **Removing a localization tool shifts behavior:** `nosearch` did MORE reads (7 vs 5) — the agent compensates for missing `search_files` by reading more.
- **Removal is SILENT (0 denials everywhere):** the allowlist hides gated-out tools from `tools/list`, so the model never *attempts* them — the ablation acts by absence, not deny-friction. (A finding in itself: governance-by-hiding vs governance-by-denial.)

Every config = pure read/list/search, zero edits — the action-closure floor is universal across configs.

**NEXT:** scale to 2–4 more instances to firm the direction; add a **bloated** config (>20 tools, needs
extra MCP servers) to probe the distraction cliff harder. Per Zig's "pilot direction + literature" scope,
this n≈few direction + the token/behavior deltas + the floor finding may be sufficient evidence.
