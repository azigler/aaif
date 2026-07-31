# Session handoff — 2026-07-31 8a82d3cf

## ⭐ STATE: External whitepaper review round 2, done and answered. The verified 7-28 spec facts are now a bead.

A single-purpose session. Onboard, then a technical review pass on an external
collaborator's pre-publication draft (round 2 of an arc that started 2026-07-20).
The reusable output is `aaif-2dv` — the MCP 2026-07-28 facts, all verified live.

## State at offboard
- Current branch: `main` (clean)
- Last commit: `7a7c8df` — offboard: handoff note (c9724841) *(this note is the next one)*
- Open beads: 58 (was 57); in-progress: 4
- In-flight subagents: none — no dispatches this session (direct-tool work throughout)
- Dirty files: none
- Markers: `.offboard-pending` **cleared**

## What happened this session

**Reviewed the updated draft of an external collaborator's LF whitepaper on
production MCP** (round 2; round 1 was 2026-07-20 — see the `project_lf_whitepaper_review`
memory). The author had revised it against the final 2026-07-28 release and asked for
a technical check on stateless requests, session handling, and spec references.

- **Diffed the new draft against the round-1 `[AZ review]` copy** — both read via
  `gdoc.sh`, so the diff was mechanical rather than remembered.
- **Verified every changed claim against the LIVE spec.** The 2026-07-28 release
  postdates the model's training data, so nothing was answered from in-weights
  knowledge: changelog, announcement, `basic/index`, `basic/transports/streamable-http`,
  `server/tools`, `basic/authorization`, plus raw `schema.ts` for the schema types.
- **Result: the changed sections are accurate.** All eight items from round 1's
  confirm-before-publish list are now closed by the final spec, including the two
  weakest (the `$ref` MUST NOT, and the forward-looking `iss` line — both near-verbatim).
- **Found one incorrect sentence and three notable omissions** — detail in
  `.local/review-steve-mcp-production-r2.md` (private; see watch-out 1).
- **Zig chose to send a clean "ship it"** rather than the full findings list
  (asked via AskUserQuestion; he reaffirmed after I flagged the concern — his call,
  his relationship). The reply was written scoped to the three sections the author
  actually asked about, which genuinely do check out, so it states nothing false.
- **Nothing was written to any Google Doc.** No comment, no edit, no copy — Zig took
  delivery himself. The repo's hard rule (no AAIF-facing action without explicit
  go-ahead) and the edit-only-my-copy pattern both held.

## Decisions made this session (autonomous decide-and-proceed calls)
- None this session. Harvest receipt: `0 decision bead(s) since the last offboard
  (3 scanned, open+closed)` — a true zero, not an empty query. The one genuine fork
  (how much of the review to send) went to Zig via AskUserQuestion rather than being
  decided autonomously.

## Proposed practices — where each one landed (Step 2.6)
- Verified MCP 2026-07-28 spec facts → filed as **`aaif-2dv`** (`note`, P2). These were
  at risk of living only in this snapshot; they are public spec knowledge, they land
  directly on `aaif-51g`, and a handoff note is not a home for them.
- No standing *practice* was proposed this session — nothing phrased as durable.

## What's next

1. **`aaif-2dv` should feed `aaif-51g`.** The headline is that **statelessness made
   retries non-idempotent**: SSE resumability is gone, a broken stream means the client
   MUST re-issue with a *new request id*, and with sessions *and* event ids both removed
   there is no protocol-level handle left to dedupe on. The spec removed the mechanism
   that made this safe without requiring a replacement — that is an autonomy/accountability
   gap the 'Earned Autonomy' thesis can measure, not just a migration chore.
2. **`aaif-51g.2` (the governance experiment) is still the load-bearing bead**, unchanged
   from last session — the measurement is what makes the whitepaper stand alone.
3. **`aaif-ambassador-program-18o.46` — DECISION NEEDED, pick August's anchor.** Still
   open, still P1, and now more urgent: the external whitepaper this session reviewed is
   moving toward publish, and that publish is the external coupling the bead names.
4. **W31 radar** still has last session's specific check queued: whether `#246`/`#249`/`#250`
   land a goose code contribution at the new **20** rung (currently n=2).

## Warnings / watch-outs

1. **`.local/review-steve-mcp-production-r2.md` is private and must stay that way.** It
   quotes an unpublished third-party draft. Gitignored (verified via `git check-ignore`).
   Per the two-tier rule, nothing from it — the author's name, his draft's content, or
   the specific defects found — goes in a tracked file, a bead, a commit message, or any
   published artifact. **`aaif-2dv` was written to contain only public spec facts**, with
   no reference to the draft or its author; keep it that way if you edit it.
2. **Don't re-derive the 7-28 spec from memory.** The release is after the training
   cutoff. Anything stated about it without a live fetch is a guess that will sound
   confident. `aaif-2dv` is the verified cache — extend it rather than re-answering.
3. **The "deprecated, still works" reading of 7-28 is a trap** and it is the kind of thing
   our own writing could get wrong too: Roots/Sampling/Logging are deprecated with a
   12-month window, but `logging/setLevel`, `notifications/roots/list_changed`, and `ping`
   were **removed outright** in the same release. Logging in particular goes silently dark
   on upgrade unless the new per-request `_meta` log-level field is set.
4. **Session-start "Open beads" remains a partial, priority-capped view** (12 of 58 shown).
   Scan the full backlog before committing to anything meaningful.
