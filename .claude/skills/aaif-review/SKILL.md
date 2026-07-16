---
name: aaif-review
description: Score-check an AAIF ambassador contribution BEFORE it's submitted — classify its highest legitimate type, predict points, run the verifiability conformance checklist (so the automated reviewer lands high-confidence with no human review), flag rejection risks, and draft the [Submission] issue body. STOPS at the submit gate (never posts). Use before publishing/submitting any contribution, or to vet a LinearB/DI artifact as a candidate.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /aaif-review — conformance + score check before submitting

AAIF scores contributions with an **automated reviewer** (a goose agent) that reads
your public artifact, classifies it, verifies a handful of signals, and writes a
**scorecard JSON** with the points. This skill makes a contribution pass that reviewer
**cleanly, at the highest legitimate score, the first time** — then drafts the
submission issue and **stops** for Zig to send.

It's the conformance gate `/submission` calls at its **verify** (step 4) and
**submit** (step 6) steps. It's also independently invocable: *"score-check this
before I publish."*

## When to fire

- Before publishing an artifact — so you can still shape it to score better.
- Before submitting — to draft the issue body and confirm conformance.
- To vet a **LinearB / Dev Interrupted** piece as a candidate (see the lane below).
- Called by `/submission` at steps 4 and 6.

## The one law: TYPE is the only points lever

Points are a **pure function of the contribution's detected type.** Depth, length,
polish, and tagging more projects do **not** add points. You move the number only by
legitimately landing a **higher type** — never by mislabeling (the agent verifies), and
never by underselling a piece that genuinely is the higher type.

### Type → points

**Firm baselines:**

| Type (`detected_type`) | Points | What it is |
|---|---|---|
| `social_thread` | 5 | a substantive thread/post with developer value |
| `community_help` | 5–15 | answering/supporting in community channels (scope-scaled) |
| `blog_post` | 15 | a written explainer / case study / opinion piece |
| `short_technical_video` | 15 | a short focused technical video |
| `tutorial` | 20 | a **step-by-step, reproducible** how-to (the key upgrade over blog) |
| `meetup_talk` / `podcast` | 20 | a talk given at a meetup / a podcast appearance |
| `organizing_meetup` | 25 | organizing an event (docked if not tied to a specific AAIF project) |
| `livestream` | 25 | a live technical stream |
| `conference_talk` | 30 | a talk at a conference (verifiable session page) |
| `workshop` | 35 | a hands-on, multi-part guided session |
| `course` | 50 | a full multi-lesson course |
| `project_contribution` | 5 / 10 / 15 / 25 | code/artifact contribution — **scope ladder below** |

> Firmness note: `blog_post`, `short_technical_video`, `tutorial`, `conference_talk`,
> `organizing_meetup`, and `social_thread` are grounded in observed scorecards. The
> `project_contribution` ladder was **refined to 5 / 10 / 15 / 25 in the W28 radar scan**,
> which added the `10` rung (a substantive bug-report / small-fix, above a trivial
> one-liner) between the trivial-fix and example/demo rungs. `community_help`,
> `meetup_talk`, `podcast`, `livestream`, `workshop`, `course` are from the program point
> table but not yet seen scored — treat their exact value as provisional and confirm on
> first use.

### `project_contribution` scope ladder

The only variable type. Points track **how substantial + how "upstream"** the work is:

- **5** — a trivial upstream fix (one-line CLI/help/docs/link fix that merged).
- **10** — a substantive **bug report / small fix**, a rung above a trivial one-liner.
- **15** — a self-authored, AAIF-relevant **example/demo repo** that is *not* a merged
  upstream PR.
- **25** — a substantial self-authored **skill / feature artifact** (the top rung
  observed so far).
- **50** — a presumed higher ceiling (a major merged feature / large body of upstream
  work), **not yet observed** in a scorecard — treat as provisional.

So a merged non-trivial upstream PR beats a demo repo; a demo repo beats a docs typo.
If the goal is points, **merge it upstream** and make the merge visible.

## The conformance checklist (bank `confidence: high`, `human_review: false`)

The reviewer independently finds and verifies these on the **public artifact itself**.
Every one must be **unmissable without your help**:

1. **Title** — clear, on the artifact.
2. **Visible publish date** — a date the agent can read on the page. Missing/ambiguous
   date is the most common verifiability miss.
3. **AAIF-project relevance** — the artifact is *specifically* about MCP / goose /
   AGENTS.md / agentgateway. A weak or generic tie gets the score **docked** (project
   relevance is a floor, not a bonus). Anchor to **one** specific project; don't lean on
   "Other."
4. **Authorship = you** — the byline / handle / repo owner on the artifact matches your
   GitHub handle **`azigler`**. Mismatch forces the agent into an identity-linking
   judgment call (→ `medium` confidence, or a request for more info).
5. **Developer value** — it teaches or gives a developer something concrete to do. Not
   "agents are the future"; a specific, useful thing.
6. **Timing eligibility** — artifact publish date is **after 2026-06-23** (your start).
   Pre-start content is ineligible. And `recognition_month` = the artifact's month, so
   **publish + submit inside the month** you want the leaderboard credit.

If any item is weak, the skill's output says **what to fix on the artifact before
publishing** — that's the whole point of running this *before* you ship.

## Confidence calibration

`high` = clean automated approval. `medium` doesn't cost points on its own, but it
means the agent had to make a judgment call — avoid giving it one:

- Make **authorship** obvious (same handle/byline as `azigler`; link the repo you own).
- Anchor to **one clear project**, not a scattershot of tags.
- For `project_contribution`, make the **merge status** obvious (link the merged PR),
  so it isn't guessing example-vs-upstream.
- Say the **type and project explicitly in Notes**.

## Rejection-risk check (what gets turned away)

These patterns get **rejected with no scorecard**. Flag any that apply:

- **Selection / announcement / self-promotion** — "I became an ambassador" posts, or
  posts about the program itself rather than a technical contribution.
- **No specific AAIF-project tie** — generic agent-philosophy or thought-leadership with
  only a loose connection; anything that would land as `project:other`.
- **Meta / self-referential** — tooling *about* the ambassador program rather than a
  contribution *to* an AAIF project.
- **Not a scoreable type** — a format the reviewer can't map to the point table.

**Rejection is not terminal.** The rework-and-resubmit path works: tie it harder to one
specific AAIF project, reframe it to a scoreable (ideally higher) type, and resubmit as
a **fresh** issue. This skill turns a would-be rejection into a shaped resubmission.

## The Notes field — your brief to the reviewer

The Notes field is the one place you directly steer classification. *"Help the agent
help you."* Always state, concisely:

- The **type** you're claiming (and why it qualifies — e.g. "step-by-step, reproducible
  → tutorial").
- The **AAIF project(s)**, anchored to the most specific one.
- The **publish date**.
- Your **role / handle** on the artifact (authorship link).
- The **developer value** in one line.
- Any **evidence** the agent should check (merged-PR link, session page, repo).

## Draft the [Submission] issue body

Fill this exact template (`.github/ISSUE_TEMPLATE/ambassador-submission.md`), title
`[Submission]: <artifact title>`:

```markdown
## Ambassador

@azigler

## Contribution URL

<canonical public URL>

## AAIF Project

Check all that apply:

- [ ] agentgateway
- [ ] AGENTS.md
- [ ] goose
- [ ] MCP
- [ ] Other AAIF project

## Notes

<the Notes brief above: claimed type + why · project anchor · publish date ·
authorship/handle · developer value · evidence links>

## Social Links for AAIF Amplification

<social post URL(s) to boost — include to set promotable:true>
```

Check the box(es) for the anchored project. Prefer **one canonical URL**.

## ⛔ Submit gate — never post without Zig

**NEVER open the submission issue, comment, or any AAIF-facing action.** This skill
produces the drafted issue body and the conformance verdict and **STOPS**. Zig reviews
and sends it himself, every time (hard rule — see CLAUDE.md). Never assume prior
approval carries to the next submission.

## The conformance report (this skill's output)

Produce a scannable verdict:

```
AAIF conformance — <artifact title>
─────────────────────────────────────
Detected type   : tutorial            → 20 pts (predicted total 20; no bonuses exist)
Higher type?    : none legitimate — it's a genuine step-by-step (not workshop: single-part)
Project anchor  : MCP                  ✓ specific
Verifiability   : title ✓ · publish-date ✓ · authorship(@azigler) ✓ · dev-value ✓ · timing ✓ (2026-07)
Confidence est. : high (no judgment calls left for the agent)
Rejection risk  : none flagged
Recognition mo. : 2026-07 (publish + submit this month)
────────────────────────────────────
Fix before publish: <list, or "none">
Issue body        : <drafted above>
Verdict           : READY TO SUBMIT — awaiting Zig's go-ahead (submit gate)
```

If anything is weak, the verdict is **SHAPE FIRST** with the concrete fixes, not
READY.

## The LinearB / Dev Interrupted candidate-staging lane

Work Zig does for LinearB / Dev Interrupted can become an AAIF submission **when it
legitimately ties to an AAIF project** and can stand vendor-neutral. The lane:

1. **Vendor-neutral gate** — does the artifact teach something about MCP / goose /
   AGENTS.md / agentgateway on its own merits, with the LinearB/DI tie as *at most one
   closing link*? If it's really a product piece, it fails the gate — don't stage it.
2. **Classify + predict** — run the type/points model above on it as-is.
3. **Shape for verifiability** — often the LinearB/DI publish already has a clean date +
   byline; confirm authorship reads as `azigler` (or is clearly co-authored by you) and
   the AAIF-project anchor is explicit in the piece, not just implied.
4. **Draft + gate** — draft the issue body, produce the conformance report, **stop for
   Zig**. (Automation wiring — pulling candidates automatically — is a later bead; this
   lane is manual by design for now.)

Reason it's manual: the vendor-neutral + authorship judgment is exactly the kind of call
that should stay human, and every AAIF-facing action is gated on Zig regardless.

## Anti-patterns

- **Mislabeling to grab a higher type.** The agent verifies; a blog dressed as a
  "tutorial" without real reproducible steps reads as blog (or worse, flags for review).
  Claim the highest *legitimate* type, no higher.
- **Underselling.** A genuine step-by-step submitted as `blog_post` leaves 5 points on
  the table. Classify honestly *upward* too.
- **Leaning on `project:other` / scattershot tags.** Weak project ties get docked; breadth
  doesn't add points. Anchor to one.
- **Submitting late in the month.** Recognition month = artifact month; late entries miss
  that month's leaderboard.
- **Publishing before running this.** The value is shaping the artifact *before* it's
  public, while the date/byline/anchor are still editable.
- **Ever posting to AAIF without Zig.** The submit gate is absolute.
