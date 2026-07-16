# REVIEW-NOTES — the human-gate ledger

> The `/research-paper` human-gate ledger for this whitepaper. It records the
> build command, the decisions already made, the judgment calls that are the
> owner's alone, the concern → defense posture, and the **gated** publish
> checklist. This is where the anti-slop gate is administered: nothing ships past
> the checklist below without Andrew's explicit go-ahead.

## Build command

```bash
cd paper && latexmk -pdf main.tex
```

Renders `paper/main.pdf` (8 pages, first full draft). Clean `article` class, no
venue branding; root owns preamble + metadata, one `\input` per section. This is
the provisional format (mise conventions: article-class LaTeX, ~5–8pp per OQ2);
if the Linux Foundation specifies a Google Doc / Markdown target, convert then.
Re-run the build after any edit.

## Decisions made

- **Thesis "Earned Autonomy" — LOCKED.** The full angle contract is in
  `research/angle-options.md`.
- **Methodology — LOCKED.** Built under the aaif `/research-paper` loop
  (`.claude/skills/research-paper/`; cookbook `refs/research-paper-pipeline.md`).
- **Steer capability — cadence today, automation forward.** The paper's posture
  (per rounds 2–3, do NOT revert): the review cadence (Steer as a rhythm with a
  clock and a rule, modeled on the standard's own tier governance) is mechanically
  expressible **today**; only the *closed-loop controller* that reads a metric and
  auto-rewrites policy is the forward agenda. Attribute / Evaluate / Serve are the
  write/read core the cadence runs on; boundary conditions stay first-class.
  (Earlier ledger framing "Steer IN as forward agenda, not a shipped system" was
  stale and backward — corrected 2026-07-16 so a gate-reviewer administering
  against this ledger does not "fix" the paper into the demoted-Steer posture.)
- **Format — provisional LaTeX (`article` class).** First full draft built under
  the `/research-paper` loop; convert if the LF specifies a Doc/Markdown target
  (OQ2). Single-column, 11pt, `natbib` numeric citations.
- **Subtitle — needs Andrew's confirmation.** Working: *"Conditioning Agent Trust
  on Delivered Outcomes, Not Task Accuracy"* (X-not-Y house syntax). Flagged in
  Owner judgment (d).
- **Layer name — "the delivery evidence layer" (leading candidate).** Named by
  its function (evidence feeds the authorizer; context feeds the actor). Survives
  being said aloud without a definition; contrasted with context-engineering's
  "context layer" on first use. Final pick is Andrew's (OQ3).
- **Fable round-3 applied (2026-07-16).** References hardened (Digital Apprentice
  authors + title corrected — the arXiv ID was real; Röder / NANDA / McKinsey
  landed with real URLs + years; AWS cut as tangential); Serve's two consumers
  named; the exhibit keyed to tier identities + a compile-evidence-into-identity
  sentence; agentgateway named with a portability guard; section 2 opens on the
  payoff; the attribution-gap claim softened to a causal-driver framing;
  em-dashes and "actually" removed; two not-X-it-is-Y recasts; skeptic meta-phrase
  cut; figure float fixed. Subtitle/layer-name/length still Andrew's calls.
- **Belts-and-suspenders revision + DORA-only + Stanford restore (2026-07-16).**
  Merged the adaptive/preventive reframe (outcome-conditioning is the *adaptive*
  half that complements *preventive* gates; §6 gained the AI-code-review
  complement, benchmark-grounded via `aibench2026`, vendor-neutral TBD cite).
  Competitor citations removed to hold vendor-neutral: the delivery-evidence-layer
  framing is now **DORA-only** (the second delivery-metrics framework and its bib
  entry cut; the attribution-gap point re-cited to `dora2025`). §1 Stanford
  adoption stat (78%→88%, AI Index 2025/2026) restored after the belts pass
  dropped it for space; held 8pp by tightening bib note fields only. All gates
  green (8pp · 0 undefined cites · competitor-scrub / vendor-neutral / no-MCP-1.0 /
  no-em-dash / no-"actually").
- **Round-4 editorial ship list applied (2026-07-16).** CORRECTNESS: §3 fixed a
  logic inversion — "ships the defect in the remaining cases" contradicted the
  "different measurements" point (the defective call *is* a correct call). §1 Röder
  spelling corrected (verified vs matthiasroder.com). PROTECT-THE-THESIS: §5 belts
  paragraph now says what the cadence *catches* (reverts/rework/unmerged that read
  clean at the tool boundary, fail in delivery) — it previously conceded the SQL
  example is invisible to outcome-conditioning without re-anchoring the adaptive
  layer's job; the "Stated plainly" paragraph compressed (was near-verbatim abstract
  reruns); "workflow configuration" glossed at first use. CLARITY/REDUNDANCY: §4
  opening triple-statement collapsed; abstract "every published ladder" scoped to
  "these autonomy ladders"; several garden-path/hedge fixes; figure caption trimmed
  (body-duplicating sentence + unresolvable data/ pointer cut). ACCURACY: the
  aibench2026 claims verified source-accurate against the report; dropped one double
  hedge to "up to five percentage points". Gates green, held 8pp.
- **Round-4b (Fable's round-4 review) applied (2026-07-16).** BLOCKER decided by
  Zig: `aibench2026` **KEPT**, URL resolved at publish (his employer/campaign call —
  not cut; the vendor-neutral asymmetry is his accepted risk, mitigated by the
  campaign carrying the data under the brand). §3 **RE-AIMED**: the indictment
  re-pointed from the SQL-injection example (which §5 concedes outcome-conditioning
  also misses) to "task accuracy's visibility ends at the call" — splitting two
  failure classes (latent defects → preventive gates; delivery failures → this
  paper's subject) with a §5 forward-reference, so §5's belts paragraph completes
  §3's promise instead of undermining it. CORRECTNESS: §2 restored the round-3
  SEP-2243 logic (servers reject header/body mismatch; gateway decides *without
  parsing the body* — the belts compression had wrongly made the gateway do it);
  §5 disambiguated "act without human review" from the universal automated screen.
  §5 "Stated plainly" referent fixed + sharpened scoped claim added ("delivered
  outcome is the only *adaptive* conditioning variable that closes the
  action-to-outcome loop"). §4 coined "attribution gap" at first use (lost its
  coiner when DX was cut) and moved the `dora2025` cite to the four keys (the
  attribution-limitation is now the paper's own observation). Figure caption:
  agentgateway tagged "(an AAIF project)". Steer ledger entry corrected. Gates
  green, held 8pp.
- **Round-4c — `aibench2026` NAMED, not anonymized (2026-07-16, Zig's call).**
  REVERSES the earlier "LinearB name OFF the paper" posture: Zig decided anonymizing
  the benchmark is not fully honest, so LinearB is named as the source. Implemented
  Fable's dominant honest-config: **(1) NAME** — §3 cites "LinearB's 2026 benchmark
  report" by name (parallel to how the paper names Veracode's analysis) and the bib
  entry credits LinearB with the real title + sample (report URL is the only
  remaining TBD, pending publication). **(2) DISCLOSE** — an author `\thanks`
  footnote states the COI (author employed by LinearB, which produced the cited
  benchmark; LinearB not affiliated with the standards/projects discussed).
  **(3) CITE ONCE** — the §6 product-recommendation use (the AI-code-review 5pp
  ranking) is CUT; a named employer stat backing a product-category recommendation
  is the positioning read, so the three preventive controls stand as a plain list.
  Two §3 line nits fixed (garden-path recast; "because" kept — verified as the
  report's own causal claim, not correlation). Vendor gate updated: **LinearB is an
  intentionally-named source now; its customers (Expedia/Adobe/Syngenta) stay OUT.**
  Gates green, 8pp. REMAINING (Zig's, org-level): confirm Ben's sign-off on the
  brand exposure; disclose the affiliation to the LF at submission (not at discovery).

### (a2) Final-recheck list (Fable round-3 — verify at Final / pre-publish)
- **Repoint the two draft-path URLs** post-Final: `mcpchangelog` + `deprecated`
  from `/specification/draft/` → `/specification/2026-07-28/` (they resolve now as
  the draft; the dated path goes live only after 7-28).
- **"required cache metadata" (SEP-2549)** is a normative MUST — re-verify against
  the Final text.
- **Tense pass** on "finalizing on 2026-07-28" if the paper lands in the Aug–Sep
  window (→ "finalized on").
- **NANDA** entry points at the canonical MIT NANDA page (the direct PDF
  302-redirects there); add a Wayback snapshot if a directly-openable PDF is wanted.
- **§2 SEP-2243 normative claim (round-4b restore)** — "requires servers to reject
  a request whose headers and body disagree" — re-verify against the SEP-2243 Final
  text (restored from the round-3 wording; confirm the server-rejection MUST holds).
- **`dora2025` scope (round-4b)** — cited for DORA's four keys; the
  attribution-limitation is stated as the paper's OWN analytic observation. If the
  2025 report carries a measurement-limitations discussion, the cite may also anchor
  that; otherwise leave the limitation uncited (it is definitional, not empirical).
- **`ibmcontext`** — still homepage-grade (`ibm.com/think`); land the actual IBM
  "structured context layer" artifact or swap to a canonical context-engineering
  source (§4's naming argument leans on it).
- **`progressiveautonomy`** — two vendor homepages as "representative industry
  usage"; tolerable as an explicitly-representative cite, but firm up if a canonical
  source exists.
- **`aibench2026` at publish** — Zig KEPT it; backfill the real author/URL when the
  report goes public. Fable's asymmetry flag (LinearB data in a DX-cut paper) is an
  accepted, Zig-owned risk.

## Owner judgment needed (these are Andrew's calls, at Final)

### (a) Accuracy gates — verify at Final

- **Conformance-gating scope.** Verify whether the conformance-gating covered the
  7-28 SEPs from birth or ships alongside them.
  - **SAFE claim:** "the release lands into a conformance-gated, SDK-tiered
    ecosystem."
  - **UNSAFE claim:** "every 7-28 SEP was gated from birth." Do not write this
    without direct verification.
- **Name it correctly.** It is **"the 2026-07-28 spec."** The spec is
  **date-versioned** — never refer to it with a semantic-version / marketing
  version-number label. The 2026-07-28 revision is a **Release Candidate until
  7-28**; current **Final is 2025-11-25**. Re-verify **every normative MUST/SHOULD
  claim at Final** before anything ships.
- **The Explicit-Handle Pattern is NOT an API** — no schema, no method, no wire
  concept. Calling it "the handle API" is the single most likely accuracy error.
- **The deprecated Logging is DIAGNOSTIC only** — don't overstate what it carried
  or imply it was a value/outcome ledger. (Drafted as diagnostic → stderr/OTel.)
- **Three citations need a canonical locator confirmed before publish** (flagged
  in `references.bib` `note` fields, not invented):
  - `roder` (Matthias Roder, "The Earned Autonomy Gradient") — cited by name per
    the spec; exact year + URL not captured in P0. Confirm or drop.
  - `digitalapprentice` (arXiv 2606.04321) — confirm the exact author list + title
    against the live arXiv record.
  - `nanda2025` — the report is real (MIT Media Lab, Project NANDA, "The GenAI
    Divide"); the canonical download URL was via an aggregator in P0. Confirm the
    primary URL. Every stat in the paper already carries an adjacent `\cite{}`.

### (b) The two honesty valves (non-negotiable framings)

- **Per-call authorization is an ENFORCEMENT POINT, not a scope engine.** The spec
  provides the point at which authorization is checked on every call; the *scope
  semantics* (what a given principal may do) remain the implementer's design.
  authN ≠ authZ-scope. Do not imply the protocol decides authorization policy.
- **Per-call identity attributes to the authenticated principal + client
  implementation — NOT to an individual agent or subagent.** Agent-level
  attribution is a **convention you build** on top (the workflow-configuration
  unit of trust from the angle contract), not something the protocol reports.

### (c) Format / length

Pending the LF target — length, sectioning depth, and citation style all follow
from it.

### (d) Voice + sign-off

Andrew's own voice pass (`/zig-voice`) and **final sign-off** before any submit.
Two items that are specifically his call: the **subtitle** ("Conditioning Agent
Trust on Delivered Outcomes, Not Task Accuracy") and the **layer name** ("the
delivery evidence layer"). This is a first full draft — a critic loop +
`/scrutinize` follow before the gate.

## Concern → defense table (seed)

| Anticipated concern | Defense |
|---|---|
| "Audit logs can't judge quality" (a truism) | Never anchor to the truism. Anchor to **what the spec makes measurable** — delivered-change attribution and held-in-production outcome signals — and to external evidence. The claim is about outcomes joined to changes, not about logs judging code. |
| "This reads naive on authz" | The **two honesty valves**: per-call auth is an enforcement point (not a scope engine), and per-call identity is the principal + client, not an individual agent. Both are stated up front, not hand-waved. |
| "aibench2026 resolves to the author's employer (LinearB)" | **Named + disclosed + cited once.** LinearB is cited by name as the benchmark source (as the paper names Veracode); an author footnote discloses the COI; the cite appears once, as §3 field evidence, with the §6 product-recommendation use cut. Disclosed employer-data citation is a known, forgivable practitioner-research pattern; the scandal pattern is undisclosed anonymization, which this removes. |
| "The framework (Steer) is speculative" | **The cadence is expressible today** (a review rhythm with a clock and a rule, modeled on the standard's own tier governance); only the **closed-loop controller** that auto-rewrites policy is forward agenda. **Boundary conditions first-class** (attribution lag, unstable identity, Goodhart, small-n). Attribute / Evaluate / Serve are the concrete core it runs on. |

## Publish checklist (GATED)

> **HARD GATE: never any step below without Andrew's explicit go-ahead.** Building
> and drafting locally is fine; anything that lands on an AAIF / LF surface stops
> here until Andrew green-lights it, every time. Prior approval never carries to
> the next step.

- [ ] `/aaif-review` — score-check, type/points, conformance, issue draft
- [ ] **Andrew manual sign-off** (voice pass + accuracy gates verified at Final)
- [ ] Linux Foundation publish (format-dependent; awaits the LF target)
- [ ] AAIF submit — Ambassador Contribution Submission issue (`azigler` · URL ·
      related project(s) · notes)
- [ ] Log in `SUBMISSIONS.md` (the public portfolio index)
- [ ] Amplify per `refs/program/brand-and-social.md`

## File inventory

| Path | What it is |
|---|---|
| `README.md` | Public, vendor-neutral overview: what the piece is, status, the loop it follows |
| `research/angle-options.md` | The LOCKED "Earned Autonomy" angle as a contract + alternatives considered |
| `refs/mcp-sep-grounding.md` | Verbatim-source pointer tier (SEP grounding + external-evidence base) |
| `data/.gitkeep` | Placeholder — the dir holds vendor-neutral reference-implementation evidence later |
| `REVIEW-NOTES.md` | This ledger |
| `paper/main.tex` | Root — preamble, metadata, executive summary (abstract), section includes |
| `paper/sections/01-question.tex` | §1 The question that predates the spec |
| `paper/sections/02-legible.tex` | §2 What the spec makes legible and enforceable (the SEP walk) |
| `paper/sections/03-record.tex` | §3 What the record cannot tell you (the trap + indictment) |
| `paper/sections/04-layer.tex` | §4 The delivery evidence layer (Attribute / Evaluate / Serve / Steer) |
| `paper/sections/05-earned-autonomy.tex` | §5 Earned autonomy (the spine) + the illustrative gateway-policy exhibit |
| `paper/sections/06-recommendations.tex` | §6 Recommendations + evaluation checklist |
| `paper/references.bib` | BibTeX — every cited source, verified in `research/p0-verified-findings.md` |
| `paper/main.pdf` | Built artifact (8 pages) |
