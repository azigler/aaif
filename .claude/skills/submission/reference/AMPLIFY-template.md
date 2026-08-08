# AMPLIFY.md — the amplification-tracking convention

> **What this is.** The per-submission record of how a shipped contribution was
> announced and boosted — the missing half of pipeline **step 8 (Amplify)**.
> Every published contribution should be announced socially and tagged so the
> cohort + AAIF can amplify it (`refs/program/brand-and-social.md`). Amplification
> is *also* the program's **largest sustained points line**: the pulse layer
> (social threads @ 5 pts, community help @ 5–15 pts) carries the biggest annual
> envelope (`refs/program/strategy-top-ambassador.md`). Yet it had no tooling and
> no record — this convention closes that gap.
>
> **One `AMPLIFY.md` per submission folder** (`submissions/<YYYY-MM>-<slug>/`),
> alongside the draft. Drafting is the **`/amplify`** skill. **Posting is NEVER
> automated** — the skill drafts, asks the standalone question, and STOPS; Zig
> posts by hand and fills in the posted URL + engagement.

## Why it exists (the spec)

Three jobs, one file:

1. **Prove the piece was amplified.** Announce → tag → boost is step 8 of every
   submission. Without a record, a shipped piece can silently skip the free
   engagement (and AAIF's repost/newsletter boost).
2. **Track the standalone-contribution question.** Every amplification post gets
   assessed — *does this stand alone as its own 5-pt pulse contribution?* — and
   the answer **defaults to NO**. A post that only promotes is not an unscored
   post, it's a rejection (`/aaif-review`, rejection risks →
   **"Amplification without substance"**). `/amplify` step 3 owns the ladder and
   the bar; record its verdict here rather than re-deriving one. A YES earns its
   own row in the **pulse-contributions table** in `SUBMISSIONS.md` and its own
   (gated) submission.
3. **Capture engagement.** A lightweight snapshot (reactions / comments /
   reposts) after posting — evidence for the contribution and a signal of what
   lands.

## Fields (what every AMPLIFY.md records)

| Field | Meaning |
|---|---|
| Draft copy | Path to the draft post file(s) in the folder (e.g. `LINKEDIN-POST.md`); voice = `/zig-voice` |
| Posted URL | The live post URL — `TBD` until Zig posts (never auto-filled) |
| Posted date | `YYYY-MM-DD` the post went live — `TBD` until posted |
| Tags applied | Platform handle + hashtag actually used (see the tag table below) |
| Badge included | Whether the ambassador badge was attached (`refs/brand/`) |
| Engagement snapshot | reactions · comments · reposts, with an as-of date — `TBD` until captured |
| Stands alone? | The verdict from `/amplify` step 3 — **defaults to `no`**; `YES → pulse row` is earned, not assumed. Run the ladder there, record it here |

**Tags (from `refs/program/brand-and-social.md`, applied on every post):**
X/Twitter **@AgenticAIFdn** · LinkedIn **Agentic AI Foundation** · Bluesky
**@aaif.io**; hashtag **#AAIFAmbassador** (primary) + **#AAAmbassador** (until
AAIF confirms which they track). Post the badge on announcements.

## Unknowns are `TBD`, never guessed

A posted URL, a date, or an engagement count that isn't known yet is written
`TBD` — never invented. Backfilling an already-shipped piece captures only what
the folder's records actually prove; everything else stays `TBD` for Zig to fill.

---

## Template (copy into `submissions/<YYYY-MM>-<slug>/AMPLIFY.md`)

```markdown
# Amplification — <submission title>

> Per-submission amplification record (pipeline step 8). Drafting: `/amplify`.
> **Posting is Zig's, never automated** — `TBD` fields wait for the live post.

## The piece being amplified
- Submission: <title> (<format> · <project(s)>)
- Public URL: <url>
- Logged in SUBMISSIONS.md: <yes — ledger row | pulse row | no>

## Posts

### <platform> — <draft | posted | TBD>
- Draft copy: <file in this folder, e.g. LINKEDIN-POST.md>  (voice: /zig-voice)
- Posted URL: <url | TBD>
- Posted date: <YYYY-MM-DD | TBD>
- Tags applied: <@AgenticAIFdn / Agentic AI Foundation / @aaif.io> · #AAIFAmbassador (+#AAAmbassador)
- Badge included: <yes | no | TBD>
- Engagement snapshot (as of <YYYY-MM-DD>): reactions <n> · comments <n> · reposts <n>  | TBD
- Stands alone as its own contribution? (verdict from /amplify step 3 — default no) <no — announcement | candidate — Zig's call | YES, 5-pt pulse thread → SUBMISSIONS.md pulse table>

## Standalone determination
<Record the verdict from /amplify step 3 and why — the default is NO. Name what
the post carries on its own, or what's missing. Pure promotion is not a 5-pt
floor; it's a rejection (see /aaif-review, "Amplification without substance"),
so it is not submitted at all. If YES: its own row in the SUBMISSIONS.md
pulse-contributions table and its own gated submission.>
```

## See also
- `/amplify` (`.claude/skills/amplify/SKILL.md`) — drafts the copy + runs the
  standalone question, then STOPS for Zig.
- `refs/program/brand-and-social.md` — tags, badge, post formats.
- `refs/program/voice-and-posting-examples.md` + `/zig-voice` — the voice.
- `SUBMISSIONS.md` — the pulse-contributions table (where a standalone thread lands).
