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
- **Steer capability — IN as forward agenda**, not as a shipped system. The
  Attribute / Evaluate / Serve capabilities are the concrete core; Steer is framed
  as the direction the loop points, with the boundary conditions first-class.
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
| "The framework (Steer) is speculative" | **Steer is framed as forward agenda**, explicitly, with the **boundary conditions first-class** (attribution lag, unstable identity, Goodhart, small-n). The concrete core is Attribute / Evaluate / Serve. |

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
