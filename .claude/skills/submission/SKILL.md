---
name: submission
description: End-to-end pipeline for producing ONE AAIF ambassador contribution — pick, research, build, verify (anti-slop gate), publish, submit, log, amplify. Use when starting or advancing a submission, or when the monthly cadence floor needs a contribution.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /submission — produce one AAIF contribution end-to-end

One run = one shippable contribution = one `submission:` bead = one folder under
`submissions/<YYYY-MM>-<slug>/`. Drive the eight steps in order. Don't skip the
verify gate.

## When to fire

- Andrew says "start a submission" / "let's ship this month's piece" / names an
  idea to build.
- The monthly cadence guard (`cadence:` bead) shows the floor is unmet.
- An opportunistic opening appears (e.g. a good-first PR in public-agents).

## Prereqs

- Read `refs/program/strategy-top-ambassador.md` (selection) and the relevant
  `refs/projects/<project>.md` (grounding) before building.
- **Also consult `.local/`** — it's a private (gitignored) reference folder
  holding the authoritative source docs + the Asana planning-hub IDs. Read it for
  grounding; never republish or quote its contents. (See CLAUDE.md "`.local/` is
  a private reference folder.")
- Know the AAIF submissions-repo URL + the "Ambassador Contribution Submission"
  issue template (from onboarding / Ambassador Discord). GitHub handle: `azigler`.

## The eight steps

### 1. Pick
Choose from the `idea:` backlog (`br list`) balancing **project / format /
leverage** (heuristics in the strategy doc). Use `/ssot` to avoid collapsing to
the modal choice. Promote the chosen idea: create/convert a `submission:` bead
with the format, project tie-in, leverage thesis, and acceptance bar ("what makes
this useful to a developer"). `br update <id> --status=in_progress`.

### 2. Research
Ground it in `refs/projects/<project>.md`. **Re-verify current facts** against
the live repos — they move fast; the briefs carry accuracy flags. Fold anything
new back into refs (the archive is a deliverable). For a heavier dig, dispatch a
read-only research agent or use `/explore`/`/research`.

### 3. Build
Create `submissions/<YYYY-MM>-<slug>/` and produce the artifact:
- **written** (blog / tutorial / thread) → draft, then `/zig-voice` for Andrew's
  voice. Keep AAIF framing vendor-neutral (LinearB tie = one closing link).
- **talk / conference** → `/cfp` (proposal) then `/talk` (deck + script). Target
  AGNTCon / MCPCon.
- **code / recipe / skill PR** → build + test it. For `public-agents`, author in
  the **Agent Skills `SKILL.md` format** (this file is an example) — copy-adapt
  from Andrew's existing skills. For goose, recipes are YAML.
- **video / livestream** → script + record; publish to a public URL.
- any **web/UI** deliverable → `/impeccable`.

### 4. Verify — the anti-slop gate (NON-NEGOTIABLE)
*"Agents are collaborators, not accountability shields."* Before anything ships:
- Run it / test it. Code and instructions must actually work.
- Facts + project names correct (cross-check `refs/projects/*`).
- Reflects Andrew's real understanding/usage; generated text reviewed & edited.
- It genuinely helps a developer.
- `/scrutinize` substantial pieces (adversarial "disprove done"); `/handoff` as
  the final check. **Andrew signs off.** If it can't pass, it isn't done.

### 5. Publish
Push the public artifact and capture its URL (blog post, GitHub PR, YouTube,
talk page, slide deck, tutorial repo…).

### 6. Submit
Open an issue in the **AAIF Ambassador submissions repository** with the
"Ambassador Contribution Submission" template: handle `azigler` · contribution
URL · related AAIF project(s) · notes (context for the review agent — *"help the
agent help you"*). **Submit early in the month** — monthly leaderboards aren't
recalculated for late entries. Respond in-thread if the review agent asks for
more info.

### 7. Log
Add a row to `SUBMISSIONS.md` (title, format, project, URL, status). **Also log
it onto the current month's recurring task in the Asana planning hub** — the
private scheduler/collector (IDs + write convention in `.local/private-notes.md`;
that file is gitignored, so never echo its IDs into tracked files or commits).
Capture the scorecard/points when AAIF approves. Close the bead (`/commit` with
the bead trailer; one bead = one commit). Update running totals.

### 8. Amplify
Announce per `refs/program/brand-and-social.md`: tag **@AgenticAIFdn**, use
**#AAIFAmbassador**, post the badge. A useful developer-value thread is itself a
qualifying 5-pt contribution — log it too if it stands alone.

## Done when

The artifact is public, the submission issue is open, `SUBMISSIONS.md` has the
row, the bead is closed, and the post is up. The monthly floor is met (or
exceeded).

## Anti-patterns

- Shipping unverified agent output (the cardinal sin).
- Generic "agents are the future" content with no specific project tie-in.
- Letting the artifact sit unpublished/unsubmitted — it only counts when shipped.
- Forgetting the social amplification (free engagement + a possible extra contribution).
