# REVIEW-NOTES — the human-gate ledger

> The `/research-paper` human-gate ledger for this whitepaper. It records the
> build command, the decisions already made, the judgment calls that are the
> owner's alone, the concern → defense posture, and the **gated** publish
> checklist. This is where the anti-slop gate is administered: nothing ships past
> the checklist below without Andrew's explicit go-ahead.

## Build command

**TBD** — pending the Linux Foundation publishing format answer (LaTeX vs
Doc/Markdown). The `paper/` directory and its build command are deferred until
that target is known; everything else in this folder is format-agnostic and
proceeds now.

## Decisions made

- **Thesis "Earned Autonomy" — LOCKED.** The full angle contract is in
  `research/angle-options.md`.
- **Methodology — LOCKED.** Built under the aaif `/research-paper` loop
  (`.claude/skills/research-paper/`; cookbook `refs/research-paper-pipeline.md`).
- **Steer capability — IN as forward agenda**, not as a shipped system. The
  Attribute / Evaluate / Serve capabilities are the concrete core; Steer is framed
  as the direction the loop points, with the boundary conditions first-class.
- **Format — DEFERRED** (see Build command).

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
  or imply it was a value/outcome ledger.

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
| `paper/` | **DEFERRED** — added once the LF publishing format is known |
