---
name: amplify
description: Draft the social announcement + community-help copy for a shipped AAIF contribution (pipeline step 8) in Andrew Zigler's voice, apply the AAIF tag/badge rules, record it in the submission's AMPLIFY.md, and answer "does this stand alone as its own 5-pt pulse contribution?" — then STOP. POSTING IS NEVER AUTOMATED; the skill drafts and hands off to Zig, who posts and fills in the live URL + engagement. Use at step 8 of /submission, or any time a thread / community-help interaction needs drafting or standalone-scoring.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /amplify — draft the amplification, score the standalone question, STOP

Amplification is **pipeline step 8** and the program's **largest sustained points
line**: the pulse layer (social thread @ 5 pts, community help @ 5–15 pts) carries
the biggest annual envelope (`refs/program/strategy-top-ambassador.md`). This skill
is the tooling that layer never had. It **drafts** — copy, tags, badge, the
standalone verdict, the AMPLIFY.md record — and then **stops**. Zig posts.

## ⛔ The one hard rule

**POSTING IS NEVER AUTOMATED.** This skill NEVER posts to X, LinkedIn, Bluesky,
Discord, or any AAIF surface, and never fills in a live posted URL or engagement
count. It produces the draft + the AMPLIFY.md record and hands off. Zig posts by
hand, then fills in `Posted URL`, `Posted date`, and the engagement snapshot.
(This is the same class of gate as the CLAUDE.md hard rule: *never touch an AAIF
public surface without Zig* — amplification posts included.)

## When to fire

- Step 8 of `/submission` — a piece just published and needs its announcement.
- Zig says "draft the announcement / thread / LinkedIn post for <piece>."
- A community-help interaction (Discord/Slack/GitHub Discussions) is worth
  logging — draft the write-up + score whether it stands alone.

## Prereqs (read before drafting)

- `refs/program/brand-and-social.md` — tags, handles, badge, post formats.
- `refs/program/voice-and-posting-examples.md` — the canonical voice exemplars.
- `/zig-voice` (global skill) — the full voice guide + anti-patterns.
- The published piece's URL + its `submissions/<YYYY-MM>-<slug>/` folder.
- `.claude/skills/submission/reference/AMPLIFY-template.md` — the record format.

## The steps

### 1. Draft the copy (in Andrew's voice)

Write the announcement in `/zig-voice`, matching the register in
`voice-and-posting-examples.md` (quirky wrapper, real payload — the silliness is
the vehicle; underneath is a genuine teaching hook). Save the draft **in the
submission folder** as `LINKEDIN-POST.md` (or `X-THREAD.md`, `COMMUNITY-HELP.md`,
etc.), including a `/randomize` provenance header if you used it for diversity.
Keep the AAIF framing **vendor-neutral** — the LinearB tie is one closing link at
most.

### 2. Apply the tag + badge rules

Every post carries (from `brand-and-social.md`):
- **Handle:** X/Twitter **@AgenticAIFdn** · LinkedIn **Agentic AI Foundation** ·
  Bluesky **@aaif.io**.
- **Hashtag:** **#AAIFAmbassador** (primary) + **#AAAmbassador** (until AAIF
  confirms which they track).
- **Badge** (`refs/brand/`): post it on announcements, on your first
  contribution, and anytime you publish on behalf of an AAIF project.
- A closing peer question ("how are you scoping what your agents can reach?") — it
  invites the engagement the pulse layer runs on.

### 3. Ask the standalone question (the points call)

> **Does this stand alone as its own 5-pt pulse contribution?**

**Default to NO.** The 5 points on `social_thread` are for **developer value, not
for posting** — and a post that promotes an event, release, or piece while
carrying *"no technical explanation, practical guidance, or another
developer-useful resource"* is **rejected outright, with no scorecard**:
*"Social submissions need more than event promotion or general amplification to
qualify."* That is exactly the shape of the default announcement thread ("I
published X, here's the link, @AgenticAIFdn #AAIFAmbassador"), so submitting one
is not a zero-value move — **it's a rejection on the record.** The rule lives in
`/aaif-review`'s rejection-risk section under **"Amplification without
substance"**; read it there and don't restate it elsewhere, so the two skills
can't drift.

The bar, stated positively: **a reader who never clicks through still learned a
technical thing.** Score it:

- **NO (the default)** — the payload is the link. Announcement, teaser,
  "thrilled to share", a summary that only makes sense once you've read the
  anchor piece. Amplification only; no standalone credit, and **do not submit
  it** — it's a rejection, not a 5-pt floor.
- **candidate — Zig's call** — it carries a real hook but leans on the linked
  piece to land. Mark it, name what's missing, and let Zig decide after it posts.
- **YES** — the post carries a **self-contained technical payload**: the specific
  finding, the code shape, the config, the gotcha and how you got past it —
  legible on its own, with the link as *further reading* rather than the point.
  → It earns its **own row in the SUBMISSIONS.md pulse-contributions table** and
  its **own gated submission** (a distinct contribution URL: the thread
  permalink).

**The upgrade path** when the verdict is NO and Zig wants a standalone
contribution: don't reword the announcement — **move one concrete thing out of
the artifact and into the thread.** Lift the exact snippet, the failing
error and its fix, the number you measured, the shape of the config that
finally worked. If deleting the link would gut the post, it isn't there yet.

Community help scores **5–15** by depth — draft the reviewable write-up
(what was asked, how you unblocked them, the link/screenshot as evidence) and
score it against the same bar: the help itself must be the substance.

### 4. Record it in AMPLIFY.md

Create or update `submissions/<YYYY-MM>-<slug>/AMPLIFY.md` from the template
(`.claude/skills/submission/reference/AMPLIFY-template.md`). Fill everything the
draft proves; set `Posted URL`, `Posted date`, and the engagement snapshot to
**`TBD`** (Zig fills them post-post — never guess). Record the standalone verdict.

### 5. Hand off — STOP

Surface to Zig: the draft, the tags/badge to attach, and the standalone verdict.
If it stands alone (or is a candidate), note that a separate **gated** submission
would follow *after* he posts (the thread permalink becomes its contribution
URL — and the AAIF submit gate still applies: never open the submission issue
without Zig's explicit go-ahead). **Do not post. Do not open a submission issue.**

## After Zig posts (his manual follow-up, not the skill's)

Zig fills in `Posted URL` + `Posted date` + the engagement snapshot in
AMPLIFY.md. If the post stood alone, its row lands in the SUBMISSIONS.md
pulse-contributions table (status `posted` → `submitted` → `approved`), and it
also gets logged on the month's Asana planning task (IDs + convention live in the
gitignored `.local/private-notes.md` — reference by pointer, never echo the IDs
into tracked files).

## Done when

The draft exists in the submission folder (voice-checked, tagged, badge noted),
AMPLIFY.md records it with the standalone verdict and `TBD` live fields, and the
draft + verdict are surfaced to Zig. **Nothing is posted.**

## Anti-patterns

- ❌ **Posting anything.** The cardinal rule — this skill drafts and stops.
- ❌ **Inventing a posted URL / date / engagement count.** Unknown = `TBD`.
- ❌ **Bare "I published X" promo** with no teaching payload — barely amplifies,
  and submitted as a contribution it is **rejected**, not merely unscored
  (`/aaif-review`, "Amplification without substance"). Give it a real payload.
- ❌ **Treating 5 pts as a floor for any post** — the standalone verdict defaults
  to NO; YES is earned with a self-contained technical payload.
- ❌ **Skipping the tags/badge** — that's the free AAIF repost/newsletter boost.
- ❌ **Naming/ranking other ambassadors** in any drafted copy (CLAUDE.md hard
  rule) — frame around the opportunity + developer value, not peers.
- ❌ **Forgetting the standalone question** — the pulse layer is the biggest
  points line; every post gets scored for it.
