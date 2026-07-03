---
name: aaif-radar
description: Weekly read-only scan of the AAIF ambassadors submissions repo — what's being submitted + scored, where the topic bloat / over-rotation is, which lanes are under-served (our opportunities), and whether the automated reviewer's grading still matches our documented model. Emits a PRIVATE full report to .local/radar/ and a participant-FREE closed `note` bead to preserve learnings, and notifies only when something is notable. Read-only; never posts to any AAIF surface. Pairs with /aaif-review (which scores OUR piece). Fire weekly (the pulse-aaif-radar timer, Sat 15:00 PT) or on demand ("scan the landscape", "what's the submission trend", "is Angie's scoring still in sync").
---

# /aaif-radar — the AAIF submissions-landscape radar

`/aaif-review` looks *inward* (score our contribution before we submit). **`/aaif-radar`
looks *outward*:** it watches the whole `aaif/ambassadors` submissions repo so we can see
trends, spot topic bloat / over-rotation, surface under-served lanes (opportunity +
inspiration), and stay in sync with how the automated reviewer grades. Read-only.

## ⛔ The one rule that governs this skill (do not violate)

The scan reads **other ambassadors' submissions and scorecards**. Per the repo's hard rule
(CLAUDE.md): **never write about, name, rank, or hypothesize about other participants in
anything committed or published.** So this skill has **two outputs with a hard wall between
them**:

| Output | Location | Committed? | May name peers? |
|---|---|---|---|
| **Full report** | `.local/radar/YYYY-Www.md` | ❌ gitignored | ✅ yes — landscape awareness lives here |
| **Distilled note** | a **closed `note` bead** in `.beads/` | ✅ committed | ❌ **NEVER** — participant-free model only |

The note bead preserves *what we learned* (type/project trend deltas, scoring calibration,
opportunity lanes framed around **developer value**) with **zero** named peers, zero ranking,
zero "better than X". If a learning can't be stated without naming a peer, it stays in
`.local/` only. When in doubt, it goes in `.local/`, not the bead.

## Modes

- **Interactive** (Zig types `/aaif-radar`): may surface highlights via AskUserQuestion.
- **Autonomous** (timer-fired, `pulse-aaif-radar`): **never blocks.** Writes the report +
  the note bead, files a P1 `human:` bead + push **only if notable**, then ends. (Global rule:
  scheduled runs never escalate to AskUserQuestion.)

Detect autonomous mode the usual way (a `/pulse`-style injected tick / no interactive
follow-up expected); default to the autonomous contract if unsure.

## The scan (all queries verified against the live private repo)

Prereq: `gh` authed as `azigler` with read access to the private `aaif/ambassadors` repo.

### 1. Snapshot the submissions (issues)
```bash
gh api --paginate 'repos/aaif/ambassadors/issues?state=all&per_page=100' \
  --jq '.[] | select(.pull_request==null) | select(.title|startswith("[Submission]")) |
        {n:.number, state:.state,
         status:([.labels[].name]|map(select(startswith("status:")))|join(",")),
         title:.title, created:.created_at}'
```
Statuses in play: `needs-agent-review` (submitted, unscored) · `needs-info` ·
`scorecard-pr-opened` (scored, PR open) · `approved` · `rejected`.

### 2. Snapshot the scorecards (the source of truth for points)
```bash
# list this month + last month's scorecards
for M in 2026/06 2026/07; do
  gh api "repos/aaif/ambassadors/contents/scorecards/$M" --jq '.[].path' 2>/dev/null
done
# fetch one scorecard JSON (base64-decode the contents API)
gh api "repos/aaif/ambassadors/contents/<path>" --jq '.content' | base64 -d
```
Schema (v1.0) fields that matter: `contribution.detected_type`, `contribution.projects[]`,
`scoring.base_points`, `scoring.total_points`, `review.confidence`,
`review.human_review_required`, `dates.recognition_month`, `promotion.promotable`.
(For a batch tabulation, loop the paths and `base64 -d | jq` each — a small fleet of
`gh api` calls; if the shell environment fights you, fetch paths first then decode.)

### 3. Delta vs last run (the ledger makes it a *radar*, not a snapshot)
State lives at `.local/radar/state.json` — last-seen max issue number, scorecard count, and
the prior type/project distribution. Compute **what changed this week**: new submissions, new
scorecards, new rejections, and any movement in the distributions. First run = baseline (say so).

## The analysis (what the report answers)

1. **Volume + status flow** — new submissions this week; how many scored / approved / rejected.
2. **Type distribution + trend** — count by `detected_type`; the week-over-week delta. Which
   types are crowding in.
3. **Project distribution + trend** — count by AAIF project; where the attention is massing.
4. **Over-rotation / bloat** — topics or (type × project) cells that are getting saturated
   (e.g. "N more 'what is MCP' blog_posts this week"). Saturation = lower marginal value there.
5. **Under-served lanes = our opportunities** — types/projects/topics with little or no
   coverage that fit Zig's lane (agentgateway o11y/governance, MCP 7-28 stateless, goose local
   inference, deep empirical/academic, conference talks). Frame as **opportunity + developer
   value**, never as out-competing anyone.
6. **Grading calibration** — do observed `detected_type → base_points` still match our map in
   `.local/research/aaif-review-system.md`? Any **new type** seen? Any **new rejection reason**?
   Any **adjustment** (total ≠ base)? Drift → flag to update the model + `/aaif-review`.

## Outputs (produce both, every run)

### Output 1 — full report → `.local/radar/YYYY-Www.md`
Private, gitignored. Peer-specific detail allowed. Structure: header (week, date range,
counts) → the 6 analyses above → an "inspiration / opportunities for us" section (specific,
may reference specific submissions since it's private) → calibration notes → update
`.local/radar/state.json`.

### Output 2 — closed `note` bead (participant-FREE)
```bash
br create -t note -p 3 "radar: <YYYY-Www> AAIF landscape learnings" \
  -d "<participant-free distillation: type/project trend deltas; over-rotation signal;
      under-served lanes as opportunity+dev-value; grading calibration (model still holds? / drift);
      NO named peers, NO ranking.>"
br close <id>
git add .beads/issues.jsonl && git commit -m ":card_file_box: beads: radar note <YYYY-Www> (AAIF landscape learnings)"
```
This is the durable, committed memory of what each week taught us — safe because it carries
only the model, never the people.

## Notify (only when it matters)
File a **P1 `human:` bead + push notification** if the week shows: a clear **new opportunity**
in Zig's lane, meaningful **over-rotation** worth steering around, a **grading-model drift**
(so `/aaif-review` predictions stay honest), or a **rejection pattern** worth avoiding.
A quiet week = write the report + note bead, no notification.

## Calibration loop (keep /aaif-review honest)
When grading drifts from `.local/research/aaif-review-system.md` (new type, changed base,
new adjustment/rejection rule), update that file (and note it) so `/aaif-review`'s type→points
predictions stay accurate. This is the whole point of "stay in sync with Angie's grading."

## Guardrails
- **Read-only.** Never open an issue/PR/comment on any AAIF surface. No writes to `aaif/*`.
- **The two-output wall** (above) is the load-bearing rule — peers in `.local/` only.
- **Opportunity framing, never rivalry** — even in `.local/`, keep the tone generous;
  the point is where *developer value* is missing, not out-scoring anyone.
- Autonomous runs never block on AskUserQuestion (file a `human:` bead instead).
