---
name: research-paper
description: The venue-neutral research-paper / whitepaper production loop (bootstrap → verbatim refs → angle-lock → per-section beads → read-only critic loop → REVIEW-NOTES human-gate → gated publish); the heavy long-form build branch of /submission (the paper-lane equivalent of /cfp+/talk). Every claim gets a grep-able test case; the loop STOPS at the Zig submit-gate. The optional academic layer (Zenodo/arXiv/ORCID/EasyChair) points to the global /cfp arc. Deep cookbook: refs/research-paper-pipeline.md.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /research-paper — build a long-form paper the disciplined way

The **heavy long-form build branch of `/submission`**. When a contribution is a
research paper, position paper, or whitepaper — not a blog, thread, or recipe — it
earns the same bead-driven, critic-looped, claim-tested discipline that produced
`~/cfp/mise` (a real paper written → compiled → submitted → revised). This skill is
the thin "when / how to fire" layer; the full phase-by-phase mechanics, directory
skeleton, QA gates, and REVIEW-NOTES pattern live in
**`refs/research-paper-pipeline.md`** (compose from it; don't duplicate it here).

`/research-paper` is the paper-lane sibling of `/cfp`+`/talk`: it fills the gap
`/submission` Step 3 leaves for long-form. **Fire it from `/submission` Step 3**
(when the picked contribution is a paper), then **hand back to Step 4
(`/aaif-review`)** for the score-check and **Step 5 (`/camp-publish`)** to publish
the accessible version to andrewzigler.com. The paper itself is the anchor; a blog
lead of the same thesis is a separate lighter track.

## The two hard gates (non-negotiable — CLAUDE.md)

- **The Zig submit-gate.** This loop ends at *ready to submit*. It NEVER opens a PR,
  issue, form, or comment on any AAIF surface. Building and drafting locally is
  encouraged; anything that lands in AAIF's spotlight waits for Zig's explicit
  go-ahead, every time. The loop STOPS and surfaces the piece.
- **The `.local` / `refs` two-tier rule.** `refs/` (verbatim sources) and everything
  committed here is public, vendor-neutral working knowledge. Private source docs,
  named infra, campaign specifics, and secrets stay in `.local/` — read inward for
  grounding, never leak outward into tracked paper content.

## When to fire

- `/submission` Step 3 picks a contribution whose format is **paper / whitepaper /
  position paper** (the MCP governance whitepaper is the live example).
- Zig says "run this as a research paper" / "set up the whitepaper project."
- A thesis is substantial enough to want formal grounding, a literature/evidence
  base, and a citable structure — not a blog's accessible top-level.
- NOT for a blog, thread, tutorial, or recipe. Those take `/submission`'s lighter
  written path (`/zig-voice` → `/aaif-review` → `/camp-publish`) directly.

## The loop (7 phases — depth in the cookbook)

Each phase hands the next a durable artifact. **Set effort per phase consciously**
(the dial column) — a bare `Agent` dispatch inherits the session's effort, so when a
step needs *more* intelligence than the session is set to (the novel-spine brainstorm
especially), dispatch through a **Workflow `agent({effort})`**, not a plain Agent.

| Phase | What it produces | Effort dial |
|---|---|---|
| **P0 · Research + plan** | angle-locked thesis + `research/angle-options.md` + a `/spec` bead with ~10–14 grep-able test cases | **xhigh** framing; **max** (Workflow) for the novel-spine / title / abstract brainstorm |
| **P1 · Infra + scaffold + data** | project skeleton (`README` · `refs/` · `research/` · `data/` · `paper/` · `REVIEW-NOTES.md` · `.beads/`); verbatim sources captured; evidence extracted to `data/` | **medium** scaffold; **high** for evidence extraction that needs judgment |
| **P2 · Per-section writing** | one **feature bead per section**, drafted in a worktree subagent, `/zig-voice` applied, section test cases green | **high** per section |
| **P3 · Assembly** | sections merged via the `\input`-per-section (or MD-concat) layout; clean build; length/page gate; link audit; `grep -i TBD` clean | **medium** |
| **P4 · REVIEW-NOTES gate** | `REVIEW-NOTES.md` filled (build cmd · decisions · owner-judgment · concern→defense table · publish checklist · file inventory); **`/scrutinize`** runs adversarial "disprove done" | **high–xhigh** |
| **P5 · Gated publish** | accessible version lands via `/camp-publish`; `/aaif-review` score-checks; **STOP at the Zig submit-gate** | **high** |
| **P6 · Optional revision sub-arc** | only if a peer-reviewed venue accepts-with-revisions — reviewer-comment table → revision spec → worktree dispatch → critic-before-merge | **high** |

**Critics are read-only.** Every meaningful draft (a section, then the whole) goes
through a read-only critic pass — naive reader / cold reviewer / `/zig-voice` pass —
using `Explore` or `general-purpose` agents, NEVER worktree subagents. Critics report
severity-ranked findings; the orchestrator applies the ones that hold up. This is what
separates a good draft from a shippable one; don't skip it.

**Every claim has a grep-able gate.** The QA discipline (from the mise `mp-9m1` spec):
each statistic is sourced, each term is defined on first use, section/length budgets
hold, the build is clean, and `grep -i TBD` is empty — each expressed as a concrete
test line checked before "done." Full test-case catalog + examples in the cookbook.

## Done when

- The paper builds clean; every grep-able test case is green; `grep -i TBD` is empty;
  length/page budget holds; the link audit passes.
- `REVIEW-NOTES.md` is complete and honest (decisions, owner-judgment items,
  concern→defense table, publish checklist, file inventory).
- `/scrutinize` passed (adversarial gate) and Zig has signed off on the content.
- The accessible version is published (`/camp-publish`); `/aaif-review` returns
  READY.
- **The loop STOPS at the Zig submit-gate** — the AAIF submission is a separate,
  human-gated action Zig takes himself.

## Anti-patterns

- **Drafting from cold.** Lock the angle first (P0). The angle is a contract; it saves
  redraft thrash. Use `/randomize` to resist collapsing to the modal framing.
- **Worktree subagents as critics.** Critics are read-only review — `Explore` /
  `general-purpose`, never worktree. Worktree isolation is for the writing agents.
- **Blurring `refs/` and `research/`.** `refs/` is verbatim source-of-truth (always
  grep-able back to the original); `research/` is *our* analysis. Never summarize a
  source into `refs/`.
- **A claim without a gate.** Every statistic, definition, and placeholder gets a
  grep-able test case before the section is "done." No untested numbers ship.
- **Leaking `.local` into the paper.** Named infra, private campaign specifics, and
  secrets stay in `.local/`; committed paper content is vendor-neutral and public.
- **Skipping the effort dial.** Riding the session default through the P0 novel-spine
  brainstorm settles for baseline intelligence on the one phase that most rewards
  `max`. Name the effort and why; use a Workflow agent when a step needs more than the
  session is set to.
- **Treating the academic layer as required.** Zenodo / arXiv / ORCID / EasyChair are
  a **detachable optional appendix** — fire them only for a peer-reviewed venue. An LF
  whitepaper needs none of it.
- **Submitting without Zig.** The submit-gate is absolute — the loop drafts and
  surfaces; Zig submits.

## See also

- `refs/research-paper-pipeline.md` — the deep cookbook: full phase-by-phase loop,
  directory skeleton, the grep-able-test-case QA gates, the REVIEW-NOTES ledger, the
  `refs/INDEX.md` generator, the effort dial, and the **optional academic-venue
  layer** appendix.
- `/submission` — the hub this plugs into; `/research-paper` is its long-form build
  branch (fire from Step 3, hand back to Steps 4–5).
- `/aaif-review` — the score-check + conformance gate before publish/submit.
- `/camp-publish` — publish the accessible version to andrewzigler.com.
- `/zig-voice` — Andrew's writing voice + anti-patterns; applied to every draft pass.
- `/scrutinize` — the adversarial "disprove done" gate at P4.
- `/research` + `/deep-research` — the research fan-out for P0 grounding. **Reference,
  don't reimplement** — compose them; this skill doesn't re-do research orchestration.
- `/randomize` — force real angle diversity in P0 so the framing isn't the modal one.
- `~/.claude/skills/cfp/` — the global research-paper + conference arc this loop was
  ported from; `~/.claude/skills/cfp/reference/scientific-paper-arc.md` is the full
  academic-layer how-to the cookbook's optional appendix points to.
