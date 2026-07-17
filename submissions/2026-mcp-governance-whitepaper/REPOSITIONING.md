# REPOSITIONING — folding the governed tool-ablation into the whitepaper

> **A proposal for Zig + the orchestrator. Nothing here is applied.** This doc
> does not touch `paper/*`, does not publish, and does not submit. It is the
> plan for how the experiment pivot (PLAN.md "DESIGN LOCKED — 2026-07-17") lands
> in the paper, the blog (`aaif-uf3`), and a new LinkedIn post — for review
> before any rewrite. Tracking bead: `aaif-p9f`.
>
> **The load-bearing constraint, stated once:** the inverted-U is *empirical
> support for* earned autonomy, not a replacement thesis. The current spine —
> delivered-outcome > task-accuracy, enabled by the 2026-07-28 per-action
> boundary, joined by a delivery evidence layer, governed by a rolling cadence —
> **survives intact.** Everything below builds on it. The one editorial danger to
> watch the whole way through (see Risks) is letting the toolset story read as a
> *second, stapled-on paper* instead of evidence for the one we have.

---

## 1. THESIS — does the headline/abstract shift?

**Headline: NO shift.** "Earned Autonomy" stays. The subtitle
("Conditioning Agent Trust on Delivered Outcomes, Not Task Accuracy") stays — it
is still the organizing contrast, and the experiment is the first hard evidence
*for* it, not a reason to change it.

**What changes:** the paper stops only *arguing* the thesis and starts *showing*
it. The abstract gains 2–3 sentences that (a) name the empirical result and (b)
give the workflow-configuration unit of trust a concrete, computable identity
(the config-hash). The conceptual claim is unchanged; it acquires a floor.

**The bridge that keeps it one paper (state this explicitly, everywhere):** a
workflow's *toolset* is one axis of its configuration. Earned autonomy governs
that axis exactly the way it governs the authority axis — you don't grant the
maximal toolset any more than you grant maximal scope; you converge on the
*load-bearing* set by measuring the **delivered-outcome delta** of adding or
removing each tool, and you enforce the result per call at the same boundary.
Task accuracy can't find that set — a tool can lift call-level correctness and
still not move (or actively hurt) the delivered outcome. The inverted-U is the
measured shape of "earned autonomy over the toolset," and it only appears when
you grade on delivered outcome and audit real usage — which is what the thesis
told you to do.

### One crisp before/after (abstract tail)

**BEFORE** (current, `main.tex` lines 66–70):

> …The paper walks what the release makes legible and enforceable, defines a
> *delivery evidence layer* that joins governed actions to their delivered
> outcomes, and describes earned autonomy: a rolling trust cadence, modeled on
> the standard's own governance by measurement, that grants and revokes agent
> authority on evidence.

**AFTER** (proposed — same claim, now demonstrated):

> …The paper walks what the release makes legible and enforceable, defines a
> *delivery evidence layer* that joins governed actions to their delivered
> outcomes, and describes earned autonomy: a rolling trust cadence, modeled on
> the standard's own governance by measurement, that grants and revokes agent
> authority on evidence. We ground the framework in a governed tool-ablation on a
> public coding benchmark: holding the agent fixed and varying only the
> gateway-gated toolset, delivered outcome traces an **inverted U** — too few
> load-bearing tools and the work cannot complete, too many and a distraction
> cliff sets in — so the toolset a workflow has *earned* is neither the minimal
> nor the maximal one but the measured sweet spot. A per-configuration version
> key, `hash(prompt + tool manifest)`, makes each config-to-outcome link
> attributable, giving the workflow-configuration unit of trust a concrete
> identity.

*Honest-framing note for the gate:* the AFTER does not claim the cadence
closed-loop is demonstrated (it isn't — see the §5 figure-caption edit in the
table). It claims the **sensor** (per-call audit + outcome measurement) and the
**actuator** (per-call authz) are demonstrated, and the inverted-U is measured.
That is true and is the honest ceiling of the experiment.

*(Optional, Zig's call — NOT recommended):* a subtitle variant foregrounding the
toolset ("…on Delivered Outcomes — and the Toolset You Earn"). Recommend
**keeping the current subtitle**; the toolset is the evidence, not the headline.

---

## 2. Per-section CHANGE / BUILD / REMOVE (walk 01 → 06)

Proposed section architecture: **insert a dedicated case-study section after §5
(the framework) and before Recommendations.** Recommendations renumbers 6→7. See
the §5/§6 rows and Risk R-4 for the "new section vs fold-in" argument.

| § | KEEP | BUILD (new material lands here) | REMOVE / CUT / RESCOPE |
|---|---|---|---|
| **§1 The question that predates the spec** | The ROI/attribution stakes (NANDA 95%, Stanford adoption, the scale argument, the named-answer-in-the-field survey). Unchanged spine. | One forward-pointer at the close: the paper doesn't only argue the variable swap — it *demonstrates* it on a public benchmark (one clause, teasing §6). Optionally seed the scaffold-swing number here as motivation for "tools decide outcomes" (SLOT-INVU-2), framed as external motivation, not our result. | Nothing. Resist over-building §1 — it is the stakes, not the evidence. |
| **§2 What the spec makes legible and enforceable** | All five properties (identity-bound, typed, traceable, **enforceable**, fleet-scalable) verbatim in substance. | In the **Enforceable** paragraph, a half-sentence forward-ref: the same per-call boundary that gates a *safety* scope is where a *performance-tuned* toolset is enforced — the actuator the experiment writes to. Keeps §2 celebratory of the spec (angle-contract rule: spec is enabler, never faulted). | Nothing. Do not import experiment detail here; §2 stays about the protocol. |
| **§3 What the record cannot tell you** | The clean-record trap; the two-failure-class split (latent defects → preventive gates; delivery failures → this paper's subject) — this split is hard-won (round-4b) and must not be diluted. | At most one sentence extending the accuracy indictment: task accuracy at the call also can't tell you whether a tool is *load-bearing or distracting for delivered outcome* — the same visibility gap, on the toolset. Place carefully or defer to §5; do not blur the two-class split. | Nothing. **Risk of over-build here** — keep §3 tight; the toolset point is better made in §5 where the evidence lives. |
| **§4 The delivery evidence layer** | Attribute / Evaluate / Serve / Steer; one-store-two-faces; the write-path/read-path framing. | **The config-hash lands here as the concrete join key.** §4 closes on "keyed to the unit an organization wants to govern" (line 63) — instantiate that: the key is `hash(prompt + tool manifest)` (extend to model + policy). It makes **Attribute**'s join deterministic (same hash ⇒ same config ⇒ comparable) and makes **Evaluate**'s per-config deltas well-defined. One or two sentences; low risk, high payoff. | Nothing. Hold the STANDING GATE: no LinearB-shaped product specificity creeps into §4's capability language. |
| **§5 Earned autonomy (the spine)** | The conformance-culture port; the four boundary-condition dials; the two honesty valves; the CNCF precedent; DORA amplifier; the gateway exhibit. All spine, all kept. | (1) **config-hash deepens the "unstable identity" dial:** the durable unit is the configuration, and now it has a *computable* identity — same hash ⇒ directly comparable across runs; different hash ⇒ attribute the downstream delta to the change. (2) **A compact statement of the inverted-U as the empirical shape of earned autonomy over the toolset** (2–3 sentences + a forward-ref to the §6 case study), so §5 is not evidence-free. (3) Optional: a third honesty note — benchmark-resolved outcome is a controlled *stand-in* for held-in-production (see R-7). | **RESCOPE the figure caption** (lines 123–133): today it says the sensor "and the policy (the cadence) are described in this paper, not demonstrated here." Post-experiment that is no longer fully true — the **sensor** (per-call audit + outcome measurement) and the **actuator** are demonstrated; only the **closed-loop cadence** remains forward agenda. Rewrite to claim exactly that and no more. This is an over-claim-*avoidance* edit, gated. |
| **§6 (NEW) Earned autonomy, demonstrated: a governed tool-ablation** | — (new) | The Fowler-calibrated case study: **setup** (goose + a local 30B coder + an MCP gateway with per-call authz/audit — infra generalized, no private host names; SWE-bench Verified subset), **framework/funnel** (full baseline → leave-one-out → bloated >20-tool config, each a config-hash), **data** (the four figures below), **honest limits** (small-n pilot, benchmark-resolved ≠ production, local-inference throughput bound, contrivance stated openly), **one clear recommendation** (audit usage → converge on the load-bearing set → enforce per call). This is the "show, not tell" backbone; it is what turns the paper from essay to case study. | — |
| **§7 Recommendations (was §6)** | The Monday cadence-as-process; the preventive-gate complement; the sequencing argument; the five-question checklist. | Add a Monday move drawn from the experiment: **read your gateway log, list the tools each workflow actually calls, drop the never-called ones, and measure whether the delivered-outcome number moved** — the cheapest instance of "earned autonomy over the toolset." Optionally a sixth checklist question: *"Does it measure the delivered-outcome delta of adding/removing a tool, or only that the tool was available?"* | Renumber cross-refs. Nothing cut. |

---

## 3. New-citation SLOTS (coordinate with `research/evidence-roundup-inverted-u.md`)

The sibling roundup is **not present at time of writing** — these are
clearly-labeled slots, pre-seeded with sources I verified so the rewrite isn't
starting cold. When the roundup lands, reconcile IDs/exact figures against it
(it is the authority on the external-evidence numbers).

| Slot | Claim it supports | Attaches at | Seed source (verify against roundup) |
|---|---|---|---|
| **SLOT-INVU-1** | Too **many** tools → distraction/bloat cliff (the high side of the U). | §5 inverted-U statement; §6 bloated-config figure (Fig A right tail). | **OSWorld-MCP**, arXiv 2510.24563 — exposing all 158 tools without RAG filtering measurably drops performance (long-context distraction, tool collision). Verified via search. |
| **SLOT-INVU-2** | Toolset/scaffold decides delivered outcome (motivates the whole ablation). | §1 close (motivation) and/or §6 setup. | **Qwen3-Coder-30B-A3B** on SWE-bench Verified: ~18.8% bash-only (mini-swe-agent) vs ~50–51.6% OpenHands 100-turn — a ~30-point swing. Sources: Qwen model card + Nebius reproduction. **Frame as MOTIVATION only** — the published swing conflates scaffold quality with toolset; our experiment isolates the toolset (R-3). |
| **SLOT-INVU-3** | Too **few** load-bearing tools → can't complete (the low side of the U). | §5 inverted-U statement; §6 leave-one-out figure (Fig B) + Fig A left tail. | PLAN cites **CompAgent F1 0.93→0.68 on core-tool removal**. LEAVE AS SLOT — let the roundup pin the canonical paper/figure before citing. |
| **SLOT-INVU-4** | A ~5–15-tool sweet spot is the practitioner consensus. | §5 (naming the sweet spot); §7 recommendation. | PLAN cites Block/goose + Copilot guidance; dev.to "MCP Tool Overload" is practitioner corroboration, not primary. LEAVE AS SLOT — roundup to supply the primary. |
| **SLOT-EXP** | Our own measured result (the inverted-U curve, the leave-one-out deltas, cost-to-outcome). | Every figure + the §5 result sentence + §6 throughout. | Self-reference to the §6 case study / a released harness + data appendix. No external cite; state reproducibility Fowler-style (config-hashes, seeds, versions). |

*Note:* the config-hash needs **no** citation — it is our method. But the §6
setup must state it precisely enough to reproduce (what goes into the hash, how
configs map to hashes).

---

## 4. FIGURES the experiment must produce (TikZ/LaTeX-friendly specs)

All figures read from two sources: the **gateway request log** (SQLite → DuckDB
per the cookbook — tool = `Mcp-Name`, per-call allow/deny, tokens) and the
**SWE-bench eval** (per-instance resolved/unresolved). Every figure is keyed by
**config-hash**. Small-n honesty (error bars / CIs / raw n) is mandatory on
every quantitative panel — it is the Fowler credibility move, not optional.

### Figure A — the inverted-U: delivered outcome vs toolset size *(the headline figure)*
- **Plot:** x = toolset size/scope (configs ordered minimal → leave-one-out set → full sweet-spot → bloated >20), y = delivered-outcome rate (SWE-bench resolved %). A curve that rises off the too-few floor, peaks at the load-bearing set, and falls past the bloat threshold. Mark the peak: **"earned / load-bearing toolset."**
- **Data:** SWE-bench resolved % per config-hash; gateway audit confirms tools actually exercised.
- **Argues:** earned autonomy over the toolset is an *optimization, not a maximization* — the whole thesis in one shape. This is the figure the blog and LinkedIn reuse.
- **LaTeX:** `pgfplots`, smooth `mark=*` plot through the config points with `error bars/.cd, y dir=both`. Optionally an annotated reference band for the external anchors (SLOT-INVU-1/3). Caption must state pilot n and that the curve interpolates discrete configs.

### Figure B — per-tool leave-one-out marginal contribution
- **Plot:** horizontal bar chart; one bar per tool; bar length = Δ delivered-outcome when that tool is removed (full-set − leave-one-out). Positive Δ (removal hurts) = load-bearing; ≈0 = inert; negative (removal helps) = distractor. Zero line marked; color load-bearing vs distractor.
- **Data:** full config vs each leave-one-out config (each a distinct config-hash); SWE-bench delta per tool.
- **Argues:** tools are not equal, and the load-bearing set is *identifiable by measured delivered-outcome delta* — the audit-usage → converge move made concrete. The actionable core.
- **LaTeX:** `pgfplots` `xbar`, `symbolic y coords` = tool names, sorted by Δ, `nodes near coords` for the value, distinct fill for negative bars.

### Figure C — stage-of-use: tool-call sequence over task phases
- **Plot:** heatmap, rows = tools, columns = normalized task phases (localize → read → edit → test → iterate), cell shading = call frequency in that phase (aggregated across instances). (Swimlane timeline is the alternative if a single exemplar trajectory reads better.)
- **Data:** gateway log ordered by timestamp within each run, bucketed into phases by a stated heuristic.
- **Argues:** tools are load-bearing at *different stages* — a low-volume tool can be critical at one phase — so "which tools to keep" means covering every phase, not just keeping the high-count ones. Explains the *why/when* behind Figure B.
- **LaTeX:** `pgfplots` `matrix plot` / `TikZ` grid with `\shade`; a `colorbar` for frequency. Caption must own the phase-segmentation heuristic as *our* definition (honest limit).

### Figure D — cost-to-outcome per config-hash
- **Plot:** Pareto view — x = delivered-outcome rate, y = tokens (or $) per resolved instance (cost-to-outcome, lower = better); each config-hash is a labeled point; the sweet-spot config sits at the lower-right knee, the bloated config drifts up-left (more cost, no outcome gain).
- **Data:** gateway token accounting (the `/agentgateway` cost lens) ÷ SWE-bench resolved count, per config-hash.
- **Argues:** the earned toolset is not only more *effective* but more *efficient* — bloat buys longer context and wandering, not outcomes. The CFO artifact; ties to §4 Evaluate's cost-to-outcome signal and the fleet-as-portfolio move.
- **LaTeX:** `pgfplots` scatter, `nodes near coords` = config label; optional Pareto-frontier line through the non-dominated points.

### Figure E — the governance-loop systems diagram *(recommended; the Fowler "conceptual" figure)*
- **Plot:** TikZ boxes-and-arrows: `[workflow config: prompt + tool manifest] → [hash] → [gateway: per-call authz + audit] → [delivered outcome: SWE-bench / merge-and-hold] → [evidence layer: Attribute + Evaluate] → [cadence: set toolset + tier] →` back to the config (a *new* hash). Label each arrow with the concrete artifact (the hash, the gateway log row, the resolved result).
- **Argues:** carries the conceptual complexity — where every paper concept sits in one loop, and how the config-hash closes it. Fowler's calibration explicitly asks for this systems diagram; it may sit at the head of §6 (or replace the current lone exhibit as the paper's spine diagram).
- **LaTeX:** `TikZ` `node`/`edge`; keep it single-column-safe.

---

## 5. BUBBLE-UP — how the reposition changes the blog and the LinkedIn post

**Blog (`aaif-uf3`, best draft `blog/drafts/v4-actionable.md` — the accessible
lead).** v4 today is all *authority* dimension: the grant-inventory table +
hand-run-the-join-once. The reposition gives it a concrete, visual, experiential
hook it currently lacks — *the inverted-U*. Reshape so the middle pivots on "I
ran the experiment, here's the shape": embed two graphs (Figure A the curve,
Figure B the leave-one-out bars) and add a third Monday move beside the existing
two — **audit your toolset**: read the gateway log, see which tools your agent
actually calls, drop the dead weight, and check whether the delivered-outcome
number moved. The config-hash lands at blog depth as "give each config a
fingerprint so two runs are comparable." Keep the grant-table closer and the
do-it-once-by-hand register (native to Zig); the picture *replaces* a chunk of
the abstract argument, which should net **shorten** the draft toward the ~900w
target the PLAN flagged. Keep the single closing AAIF-cohort line.

**LinkedIn (new post — Zigler voice: short, quirky, teasing; calibrate to the
inaugural "just selected as ambassador" post).** The angle is one surprising,
counterintuitive result: *everyone is bolting more tools onto their agents;
past a point it makes them **worse**.* Lead with the tease — there's a Goldilocks
toolset, and you find it not by guessing but by reading your own logs. One
image (the inverted-U curve, or a goose-motif riff on "too many tools in the
knapsack"). Tease the blog for the how-to, mention the paper lightly as the deep
version, tag **@AgenticAIFdn** + **#AAIFAmbassador** + the badge. The quirk
carries it: "I gave my agent every tool I had. It got dumber. Here's the curve."
Draft the angle only — final copy runs through `/zig-voice` and stops at Zig's
gate.

---

## 6. RISKS / open questions for Zig

- **R-1 (the central editorial risk): two-papers-stapled.** The thesis governs
  *authority*; the inverted-U is about *toolset performance*. If the bridge (§1)
  isn't made explicit — the toolset is an axis of the workflow configuration, and
  earned autonomy governs it the same way — a reviewer reads two papers. The fix
  is the "one bridge" paragraph in §1 above; confirm it lands before drafting §6.
- **R-2 (small-n honesty vs a "curve").** The pilot is 3–5 instances × 2 configs
  — that proves *direction on one edge*, not a full U. Figure A needs enough
  distinct configs (minimal / several leave-one-out / full / bloated) to actually
  trace the U. **Decision:** does the paper wait on the full matrix, or ship
  pilot-as-direction + external literature (SLOT-INVU-1/3/4) for the full shape?
  Shipping a "curve" from two points would be slop.
- **R-3 (conflation trap).** The published ~30-point scaffold swing (SLOT-INVU-2)
  mixes scaffold quality with toolset. Our experiment isolates the toolset. Frame
  the external swing strictly as *motivation*, and position our result as the
  cleaner isolation — or a reviewer conflates them and the novelty evaporates.
- **R-4 (section architecture — Zig's call).** NEW §6 case-study section (my
  recommendation — preserves §5's spine, gives the figures/limits/setup a Fowler
  frame) vs fold-into-§5 (risks a 12-page §5, buries the figures). This couples to
  paper length: today 8pp; a full case study adds ~2–4pp. Does the LF target
  tolerate 10–12pp? (OQ2 in REVIEW-NOTES is still open on the LF format.)
- **R-5 (figure-caption honesty).** The §5 exhibit caption's "not demonstrated
  here" becomes partly false post-experiment (sensor + actuator demonstrated;
  closed-loop cadence still not). The rescope must claim *exactly* that — neither
  over- (don't imply the cadence is closed-loop) nor under-claim.
- **R-6 (vendor-neutrality + private infra).** goose and agentgateway are AAIF
  projects (championable — good). External benchmark numbers are public research
  (fine). But **no private host names** (`pico`/`zig-computer`/`metis`) may reach
  any published figure caption or setup prose — generalize to "a local inference
  box / a self-hosted MCP gateway." Confirm the STANDING GATE still holds: no
  LinearB-shaped product specificity in §4/§7.
- **R-7 (proxy ≠ claim).** SWE-bench "delivered outcome" is *benchmark-resolved*
  (hidden tests pass), not *held-in-production*. The thesis metric is production.
  State benchmark-resolved as a clean, objective *stand-in* in a controlled
  setting; don't let the proxy quietly become the production claim.
- **R-8 (config-hash scope).** `hash(prompt + tool manifest)` suffices for the
  experiment (model held fixed) but §5's configuration = model + prompt + tools +
  policy. State the hash's scope explicitly: experiment-narrow (prompt + tools)
  vs the general four-part configuration identity. Trivial to get wrong in a
  reviewer's eye.

---

## Executive summary

1. **The thesis does not move.** "Earned Autonomy" and its delivered-outcome >
   task-accuracy subtitle stay; the experiment is evidence *for* the spine, not a
   replacement — the whole reposition hinges on protecting that.
2. **The new empirical claim:** hold the agent fixed, vary only the gateway-gated
   toolset, and delivered outcome traces an **inverted U** — too few load-bearing
   tools can't complete, too many hit a distraction cliff; the *earned* toolset is
   the measured sweet spot, not the maximal one.
3. **The config-hash** (`hash(prompt + tool manifest)`) gives §5's
   workflow-configuration unit of trust a concrete, comparable identity and lands
   in §4 as the join key.
4. **Section plan:** §1–§5 keep their spine with targeted builds; a **new
   Fowler-calibrated case-study section** lands after §5 (Recommendations → §7);
   the §5 exhibit caption is rescoped to claim only what the experiment shows.
5. **Four figures** (inverted-U curve, per-tool leave-one-out, stage-of-use
   heatmap, cost-to-outcome Pareto) plus a recommended governance-loop diagram —
   all keyed to config-hash, all with small-n honesty.
6. **Bubble-up:** the blog gains the inverted-U hook + two graphs + an
   audit-your-toolset Monday move (and should net shorten); the LinkedIn post
   teases the counterintuitive "more tools made it worse" result in Zigler voice.
7. **Citations** are seeded as labeled slots (OSWorld-MCP and the Qwen scaffold
   swing verified; too-few-tools and 5–15 sweet-spot left for the sibling roundup
   to pin).
8. **Top risks for Zig:** the two-papers-stapled bridge (R-1), small-n vs a real
   curve (R-2), the scaffold-vs-toolset conflation (R-3), and the section/length
   call (R-4).

**Output file:** `/home/ubuntu/aaif/submissions/2026-mcp-governance-whitepaper/REPOSITIONING.md`

---

## DECISIONS — Zig walk-through (2026-07-17 s2)

Human-gate outcomes that now govern the rewrite (walked with Zig):

- **Bridge (R-1): HOLDS — ship it.** One paper. State the bridge explicitly in §1: the
  toolset is one axis of workflow configuration; earned autonomy governs it the same way
  it governs authority (converge on the load-bearing set by delivered-outcome delta,
  enforce per call).
- **Scope (R-2): pilot-direction + literature for the shape.** Our experiment shows the
  effect DIRECTION (honestly small-n); the full inverted-U shape leans on the cited
  literature (both arms sourced). **Close the paper mise-en-place-style — on proposed
  next experiments / ways to extend the study** (that "future work / extend this" section
  is the honest home for the full-swept-curve ambition).
- **Length (R-4): argument-driven, tight.** No new section-count mandate; ~8–10pp is
  already "kinda high." Expect to REMOVE existing material that isn't serving the thesis
  or isn't as strong, to make room — don't pad to a length, don't cut arbitrarily to one.
  Get the full argument we can make, in the scope we have; no grandiosity. Likely ~7–9pp.
- **Figures:** anchor on A (inverted-U curve — labeled honestly as direction + literature),
  B (leave-one-out), E (governance-loop diagram); C/D only if they earn their space.
- **Subtitle:** keep as-is (the toolset is the evidence, not the headline).
- **Gateway logging (Zig, same session):** enable MCP tool-call **metadata** logging on the
  LIVE gateway (payloads stay OFF — contents already live in transcripts and are sensitive;
  metadata is the blind spot the gateway uniquely fills, incl. denials). Verify no-contents
  empirically on the experiment gateway first, then port the validated config to live. Feeds
  §2 (legible/enforceable) + §4 (attribute): the gateway is the governed audit *without*
  holding the payload.
