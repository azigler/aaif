# Session handoff — 2026-07-01 (AAIF ambassador: research → review-system pivot)

## ▶ Next session's dedicated focus (start here)

**Bead `aaif-ambassador-program-18o.26` (P1)** — build the **AAIF submission +
score-checking pipeline**: a hardened conformance skill + a pipeline so our
submissions pass AAIF's *automated* reviewer at the highest legitimate score,
first time (and possibly stage candidates from LinearB / Dev Interrupted work
where it ties to an AAIF project, vendor-neutral).

1. **Read `.local/research/aaif-review-system.md` FIRST.** It has the
   reverse-engineered review mechanics, the full **scorecard JSON schema**, the
   **rubric / optimization levers**, 5 worked examples, and a concrete TODO list.
   (It's private — it references other ambassadors' scorecards, which by hard
   rule never go in committed content.) The scorecard-file list is at
   `.local/research/scorecard-list.txt` (36 scorecards).
2. **The one-line finding:** AAIF's reviewer (goose, posting via the program
   account) scores **type-baseline-driven** (blog 15, tutorial 20, talk 30, small
   merged PR 5; observed `total == base`, no bonuses). It writes a scorecard JSON
   and verifies type / project / publish-date / authorship / dev-value / timing
   (artifact must be dated after the 2026-06-23 start). So the pipeline optimizes
   **type classification + verifiability + timing**.
3. **The build (per bead .26):** tabulate all 36 scorecards → confirm the
   type→points map + find any bonus/human-review/rejection cases; grab the exact
   `[Submission]` issue template; build the skill in `aaif/.claude/skills/`
   (schema + rubric + pre-submit checklist + issue-body drafter — **stopping at
   the submit gate**); design the candidate→classify→shape→review→submit→track
   pipeline; add the LinearB/DI staging lane.

## Hard rules now in force (CLAUDE.md — do NOT violate)

1. **Never draft-and-submit or open a PR/issue/comment/form to ANY AAIF surface
   without alerting Zig and reviewing together first.** Building locally is fine;
   anything in AAIF's spotlight waits for his explicit go-ahead, every time.
2. **Never write about / rank / hypothesize about other program participants or
   their content in committed files** — that goes in `.local/` only. Committed
   content stays about the work and the developer value.
3. **Two-tier knowledge:** AAIF/Angie source docs + not-yet-public campaign
   material + anything from the private `aaif/ambassadors` repo → `.local/`
   (never committed). Distilled secondhand research → `refs/` (public), scrubbed.
   **Generalize private infra** — refer to a self-hosted gateway / a local-model
   box / a private mesh generically (never by their private machine names);
   prefer **goose** for the local-model story.

## Repo state

- Public repo `azigler/aaif` (submodule of `~/explore`), clean; all pushed.
- **Committed research:** MCP 7-28 deep brief (`refs/projects/mcp.md`), WG
  research, goose/AGENTS.md briefs, voice exemplars. **Private (`.local/`):** the
  campaign white-paper paths, agentgateway deep-dive, hands-on projects, both
  onboarding docs, the review-system notes, the Asana hub IDs, the source PDFs.
- **Skills installed globally:** `aaif-blog-guidelines`, `aaif-brand-guidelines`.
- History was scrubbed of private infra names (filter-repo) — HEAD/history/DB all clean.

## Still-open strategic threads (Zig's call, whenever)

- **Read the two onboarding gists** (MCP + agentgateway — links in
  `.local/private-notes.md`) → pick the **signature + first move** (the decision
  that unblocks the content plan; my rec: harness-operator primary + local-first
  secondary).
- **Toronto MCP Dev Summit CFP (~July 14)** — the one time-boxed item (via
  `/cfp` → `/talk`). Verify it's still open on Sessionize.
- Submissions repo confirmed: **we're in `aaif/ambassadors`** (bead `.2` closed).
  The MCP 7-28 campaign interest form was submitted. Blog-on-aaif.io = an Asana
  form; contribution *scoring* = a `[Submission]` issue in the submissions repo.

## Beads

Master epic `aaif-ambassador-program-18o`. `.26` (P1) is the next-session focus.
`br ready` for the rest (6 opening-move submissions, the idea backlog, WG,
cadence). The monthly-floor cadence guard is `.4`.
