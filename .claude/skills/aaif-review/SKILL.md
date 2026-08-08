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
| `blog_post` | **5 / 15** | a written explainer / case study / opinion piece — **the rung depends on project tie, see below** |
| `short_technical_video` | 15 | a short focused technical video |
| `tutorial` | 20 | a **step-by-step, reproducible** how-to (the key upgrade over blog) |
| `podcast_guest` | 20 | a podcast appearance |
| `meetup_talk` | **25** | a talk given at a meetup |
| `livestream` | 25 | a live technical stream |
| `conference_talk` | 30 | a talk at a conference (verifiable session page) |
| `organizing_meetup` | **35** | organizing an event (docked if not tied to a specific AAIF project) |
| `workshop` | 35 | a hands-on, multi-part guided session |
| `course` | 50 | a full multi-lesson course |
| `project_contribution` | 5 / 10 / 15 / 20 / 25 / 40 | code/artifact contribution — **scope ladder below** |

> ⚠️ **Calibration hygiene (W31).** Scorecards are **retroactively re-based**: W30 recorded
> `meetup_talk = 20` as CONFIRMED at n=2/high-confidence, and those same two scorecards now
> read **25**. A "confirmed" rung is therefore *not* permanent — never trust a prior ledger
> diff; re-tabulate the whole corpus. Related: when a scorecard's `review.rationale` prose
> disagrees with its `scoring.base_points` field (observed on the one adjusted record),
> **trust the field** — the prose goes stale across a re-base.

> Firmness note: every type in the table above is now grounded in observed scorecards
> **except `community_help`** — `workshop` (35) and `livestream` (25) were both confirmed on
> first observation in W32, at exactly their program-table values. `community_help` 5–15 has
> **never been observed scored in 241 scorecards**; treat its rung as provisional and confirm
> on first use. The `project_contribution` ladder was refined to 5 / 10 / 15 / 25 in the W28
> scan (adding the `10` bug-report rung), to 5 / 10 / 15 / 20 / 25 in W30 (the `20`
> fix/cleanup rung), and **again in W31 to 5 / 10 / 15 / 20 / 25 / 40** (the `40` rung now has
> 3 observations, W32 — it is reachable, not a fluke). **W31 re-based `organizing_meetup`
> 25 → 35 and `meetup_talk` 20 → 25**, and observed **`podcast_guest` = 20** on first sighting
> (note the slug is `podcast_guest`, *not* `podcast` — an earlier version of this table had it
> wrong). W32 re-tabulated the full corpus and **every rung above held** — no re-base.

### The project tie decides the rung — on *any* type (W31 blog / W32 generalized)

A blog post is not automatically 15, and **this is not a blog-post rule.** The tie to a
*specific, named* AAIF project is load-bearing across types:

| Project tie | Outcome |
|---|---|
| Names a specific AAIF project **and** carries concrete technical detail (protocol specifics, code, implementation guidance) | **full rung** (e.g. `blog_post` 15) |
| Mentions AAIF / the program generally, but no specific project — scorecard resolves `projects: ["other"]` | **docked rung** (e.g. `blog_post` 5, `organizing_meetup` 25 instead of 35) |
| No AAIF project reference at all | **rejected** — see rejection risks |

W32 confirmed the generalization empirically: an `organizing_meetup` scored **25 instead of
35** because its event page *"does not substantiate MCP as a material focus, so the
contribution is classified under other AAIF work."* Same shape as the blog 15-vs-5 tier.

Practical: never ship anything that gestures at "agentic AI" in general — including an
**event listing or a talk abstract**. Name the project *in the artifact itself* (the reviewer
reads the public page, not your Notes), and make the technical substance concrete enough that
a developer could act on it.

### `project_contribution` scope ladder

The only variable type. Points track **how substantial + how "upstream"** the work is:

- **5** — a trivial upstream fix (one-line CLI/help/docs/link fix that merged).
- **10** — a substantive **bug report / small fix**, a rung above a trivial one-liner.
- **15** — a self-authored, AAIF-relevant **example/demo repo** that is *not* a merged
  upstream PR.
- **20** — a **merged upstream PR with clear developer/user impact**, but scoped as a
  *fix or cleanup* rather than a new capability (e.g. fixing a crash, removing stale
  naming across code/tests/logs). Added in the W30 radar scan.
- **25** — a substantial self-authored **artifact**: a whole tool/repo/library, or a merged
  PR that adds a meaningful **feature** with tests + docs.
- **40** — a **cross-cutting merged feature**: one PR spanning backend APIs, storage
  semantics, generated SDK code, UI, localization, *and* tests, where maintainer review
  confirms the feature was wanted. Added in the W31 radar scan (n=1). The distance from
  `25` to `40` is **breadth across the stack**, not just "feature + tests + docs".
- **50** — a presumed higher ceiling for this type, **still not observed** on a
  `project_contribution` scorecard — treat as provisional. (Note 50 *is* now confirmed
  as the base for `course`, so the overall ladder does reach it.)

So a merged non-trivial upstream PR beats a demo repo; a demo repo beats a docs typo.
If the goal is points, **merge it upstream** and make the merge visible — and if the
change is a fix, the gap between the `20` and `25` rungs is *feature + tests + docs*.
As of W31 the **`20` rung is the mode** (21 of 44 observed) — a merged `fix(...)` with clear
user impact is the most-travelled path in the program.

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
   Pre-start content is ineligible, *regardless of which leaderboard month it would land
   in* — W31 saw a strong conference talk (recording + deck + event page, a 30-point
   artifact) rejected for being delivered 6 days before the ambassador's start date.
7. **Recognition month** — ⚠️ **`recognition_month` follows the month the review is
   APPROVED, not the artifact's month** (corrected in the W31 scan; this doc previously
   said the opposite). Measured across 198 scorecards: 6 June artifacts approved in July
   were recognized **July**, and 2 July artifacts approved on Aug 1 were recognized
   **August**. So submitting in the last days of a month doesn't merely risk a late
   recalculation — it **moves the points onto the next month's leaderboard**. Observed
   intake→approval latency is same-day to ~2 days, so **submit with a ≥3-day buffer before
   month end** to secure that month's credit.

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
- **Amplification without substance** (new, W32) — a social post that *promotes* an event,
  release, or announcement but carries **"no technical explanation, practical guidance, or
  another developer-useful resource"** is rejected outright. Observed on a post promoting the
  MCP 7-28 release parties: *"Social submissions need more than event promotion or general
  amplification to qualify."* ⚠️ **This is the trap for the `/amplify` step**: the
  announcement thread for your own shipped piece is **not** automatically a 5-pt
  `social_thread`. The 5 points are for **developer value**, not for posting — the thread has
  to teach something that stands on its own.
- **No specific AAIF-project tie** — generic agent-philosophy or thought-leadership with
  only a loose connection; anything that would land as `project:other`. W31 confirmed the
  exact bar: a well-written piece was rejected for not referencing MCP or any AAIF project
  **by name** and for lacking *"concrete technical detail (protocol specifics, code,
  implementation guidance)."* Note the near-miss below this line is scored, not rejected —
  a general-AAIF-but-no-project post lands `blog_post` **5** instead of 15.
- **Increment to an already-scored parent** (new, W31) — a piece that reads as *part of* a
  contribution that already received points earns **nothing**. Observed: a new lesson added
  to a course that had already been awarded the full 50 was turned away as *"part of that
  same course rather than a separate contribution."* ⚠️ **This is the trap for multi-piece
  arcs** (whitepaper + companion blog, series parts, a talk plus its writeup): each piece
  must carry its **own thesis and its own defensible contribution**, not be an excerpt,
  recap, or "accessible lead" of an already-submitted artifact. If two pieces share a
  spine, differentiate them explicitly in the Notes — or submit only one.
- **Pre-start artifact** — delivered/published before your start date (2026-06-23). Applies
  even to high-value, fully-verifiable work, and *regardless of leaderboard month*.
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

### Mechanics for when the go-ahead IS given (verified 2026-08-01 on #404)

- **`gh issue create --body-file` works.** The web form is NOT required. The repo's
  `.github/workflows/label-submission-issues.yml` fires on `issues: opened` for any title
  starting with `[Submission]:` and applies `status:needs-agent-review` itself.
- ⚠️ **The label lands ~2s AFTER creation.** Checking immediately returns `labels: []`,
  which looks exactly like a submission that failed to enter the queue. It is a race, not
  a defect — re-check after a beat before concluding anything. (The template also declares
  the label in its front-matter, but template labels only apply via the web form, which is
  what makes the empty first read so convincing.)
- **Ambassadors cannot self-label**: `POST /issues/{n}/labels` → `403 Must have admin
  rights`. So if the workflow ever genuinely doesn't fire, the fix is to re-create the
  issue with a conforming title, not to try to patch the label on.
- **Canonical URL hygiene** — strip tracking params before they land in a public issue.
  LinkedIn's mobile "copy link to post" yields an `lnkd.in/p/...` shortlink that 301s to a
  `...-share-...` URL carrying `utm_*` **and an account-scoped `rcm=` token**. Resolve it
  and submit the page's own `og:url` instead. Note LinkedIn handle (`andrewzigler`) ≠
  GitHub handle (`azigler`); state the mapping in Notes so authorship needs no inference.

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
