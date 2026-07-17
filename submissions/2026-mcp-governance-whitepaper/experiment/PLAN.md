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
