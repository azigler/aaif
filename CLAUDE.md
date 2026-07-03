# aaif — Andrew Zigler's AAIF Ambassador work

> Public repo. Andrew is an **inaugural (2026) AAIF Ambassador** — 1 of 138
> across 41 countries. GitHub: **azigler**. This repo is where his ambassador
> work is scaffolded, tracked, and built **in the open** — the harness, the
> research, the submission backlog, and the portfolio of shipped contributions.
>
> Think of it as `coding-jams` but for ambassador work: a single home with its
> own beads, refs, and Claude harness, geared to producing **a steady stream of
> high-quality, high-engagement contributions on a monthly cadence.**

## The mission (the objective function)

Become **one of the top AAIF ambassadors** by maximizing
**points × quality × real developer usefulness**, sustained every month — never
one at the expense of the others. The floor is one public, project-tied
contribution per month; the aim is to exceed it consistently with a portfolio
mix. Full playbook: **`refs/program/strategy-top-ambassador.md`**.

## Prime directive: no agent slop

AAIF's words, and the law of this repo: *"We like agents. We do not want agent
slop… Agents are collaborators, not accountability shields."* This harness uses
agents heavily — so **every contribution passes a human-verification gate before
it ships.** Before anything is submitted, confirm:

- Technical claims are accurate; code/instructions actually run.
- Project names + facts are correct (check `refs/projects/*`).
- It reflects Andrew's own understanding and real usage.
- Any generated text has been reviewed and edited (→ `/zig-voice` for his voice).
- It genuinely helps a developer.

The gate is `/scrutinize` (adversarial "disprove done") for substantial pieces,
`/handoff` for the final check. Slop is the one failure mode that actively hurts
standing — it can't ship.

## ⛔ Hard rule: never touch AAIF in public without Zig

**NEVER draft-and-submit or open a PR, issue, comment, review, or form submission
to ANY AAIF surface on Zig's behalf without first alerting Zig and reviewing it
together.** This covers: the Ambassador submissions repo, any AAIF project repo
(MCP, goose, AGENTS.md, agentgateway, public-agents, the working groups), the
AAIF blog intake form, and the Ambassador Discord.

- **Building / drafting locally is fine** — encouraged, even.
- **Anything that lands in AAIF's spotlight** (public or ambassador-visible) is
  gated on Zig's **explicit go-ahead**, every time.
- When a piece is ready to submit: **STOP, surface it, and wait for the green
  light.** Never assume prior approval carries to the next submission.

Reason: no accidental spam of AAIF, no premature moves in the spotlight. This is
non-negotiable and overrides any "always push / autonomous" habit for AAIF-facing
actions.

## ⛔ Hard rule: no gossip or competitiveness about other ambassadors — ever in committed content

**Never write about, name, rank, or hypothesize about other program participants
or their content in anything checked into this repo** — no committed refs, beads,
commit messages, or published artifacts. No "better than X", no rival/leaderboard
framing, no sizing-up peers on display.

- Landscape/awareness that references specific people or their submissions goes in
  **`.local/`** (or memory) — never in tracked content.
- In committed/public content, frame everything around **the opportunity and the
  developer value**, not around out-competing anyone. "Top ambassador" is a
  personal quality bar, not a scoreboard over peers.

Reason: no gossip, no poor sportsmanship on display. Ambassadors are a community,
not rivals — keep the tone generous and about the work.

## What AAIF is (one paragraph)

The **Agentic AI Foundation** (Linux Foundation) — neutral open home for the
standards/projects of agentic AI: **MCP** (Anthropic), **goose** (Block),
**AGENTS.md** (OpenAI), **agentgateway** (Solo.io), plus 7 working groups.
Contributions must tie directly to one of these. Deep dive: `refs/aaif-overview.md`.

## The submission pipeline (the core loop)

Every contribution flows through these steps. One submission = one `submission:`
bead = one folder under `submissions/`.

1. **Pick** — choose the next contribution from the idea backlog (`br list`,
   `idea:` beads) balancing project / format / leverage. Use `/randomize` to resist
   collapsing to the modal choice. Heuristics: `refs/program/strategy-top-ambassador.md`.
2. **Research** — ground it in `refs/projects/<project>.md`; verify current facts
   against the live repos (they move fast). Fold new findings back into refs.
3. **Build** — produce the artifact in `submissions/<YYYY-MM>-<slug>/`:
   - written (blog/tutorial/thread) → draft, then `/zig-voice` for Andrew's voice
   - talk/conference → `/cfp` (proposal) → `/talk` (deck+script)
   - code/recipe/skill PR → build it; for public-agents use the `SKILL.md`
     Agent-Skills format (matches Andrew's existing skills — copy-adapt)
   - any web/UI deliverable → `/impeccable`
4. **Verify (the anti-slop gate)** — run/test it; `/scrutinize` substantial work;
   run **`/aaif-review`** to score-check (highest legitimate type + verifiability →
   clean automated approval); confirm the prime-directive checklist. Andrew signs off.
5. **Publish** — push the public artifact (blog URL, PR, video, talk page…).
6. **Submit** — ⛔ **STOP: never submit without alerting Zig and reviewing it
   together first** (see the Hard rule above — no accidental spam / premature
   spotlight). *After his explicit go-ahead,* open an issue in the **AAIF
   Ambassador submissions repository** using the "Ambassador Contribution
   Submission" template: GitHub handle `azigler` · contribution URL · related
   AAIF project(s) · notes. (**`/aaif-review`** drafts the exact issue body and
   stops here at the gate.) (Submit early in the month — monthly leaderboards
   aren't recalculated for late entries.)
7. **Log** — record it in `SUBMISSIONS.md` (the public portfolio index), **and log
   it onto the current month's recurring task in the Asana planning hub** (private
   scheduler/collector — IDs + convention in `.local/private-notes.md`). Close the
   bead. Capture the scorecard/points when AAIF approves it.
8. **Amplify** — announce per `refs/program/brand-and-social.md` (tag
   **@AgenticAIFdn**, **#AAIFAmbassador**, badge). A useful thread is itself a
   5-pt contribution.

## Cadence (portfolio, not heroics)

| Layer | Cadence | Formats | Role |
|---|---|---|---|
| Pulse | weekly-ish | social thread, community help | presence; keep leaderboard warm |
| Anchor | **monthly (the floor)** | blog / tutorial / video / project PR | reliable spine, with margin |
| Tentpole | quarterly | conference talk / workshop / livestream / course | leaderboard + recognition movers |
| Opportunistic | as found | PRs to public-agents / agentgateway / goose recipes | first-mover, durable artifacts |

**Never miss the monthly anchor.** A monthly check (the `cadence:` bead / pulse)
guards the floor.

## Routing

| When you're… | Go to |
|---|---|
| Deciding what to make next | `refs/program/strategy-top-ambassador.md` + `br list` (idea beads) |
| Checking program rules / points / submission process | `refs/program/ambassador-program.md` |
| Researching a project's contribution surface | `refs/projects/<project>.md` |
| Announcing / branding a post | `refs/program/brand-and-social.md` + `refs/brand/` |
| Building one contribution end-to-end | `/submission` (`.claude/skills/submission/`) |
| Score-checking a contribution before publish/submit | `/aaif-review` (`.claude/skills/aaif-review/`) — type + points + conformance + issue drafter |
| Auditing an agentgateway fleet's traffic | `/gateway-audit` (`.claude/skills/gateway-audit/`) — aggregate: what the fleet did, from its request-log DB (DuckDB) or logs+metrics (read-only) |
| Accounting a fleet's token/cost | `/gateway-cost` (`.claude/skills/gateway-cost/`) — tokens + cache economics + $ only when priced (read-only) |
| Watching a live fleet in near-real-time | `/gateway-watch` (`.claude/skills/gateway-watch/`) — threshold/anomaly alerts, one line per breach (read-only) |
| Tracing one request / one session end-to-end | `/gateway-trace` (`.claude/skills/gateway-trace/`) — single-call timeline + session slice + privacy-gated payloads (read-only) |
| Deriving least-privilege gateway policy | `/gateway-harden` (`.claude/skills/gateway-harden/`) — observed behavior → proposed CEL allowlist (human-gated, never applies) |
| Writing/verifying a gateway request-log query | `refs/gateway-request-log-cookbook.md` — the verified DuckDB-over-SQLite cookbook (schema, gotchas, queries) the five gateway skills share |
| Understanding AAIF the org | `refs/aaif-overview.md` |
| Needing the authoritative source / private context | **`.local/`** — read it like `refs/` (handbook PDFs, Asana hub IDs); never commit or quote its contents |

## Beads

Prefix **`aaif`**. Orchestrator owns the lifecycle (create/claim/close);
subagents only reference IDs in commits. Title-prefix taxonomy (greppable):

- `epic:` — the program + per-lane groupings
- `submission:` — one shippable contribution (the unit of work)
- `idea:` — backlog of candidate contributions (promote to `submission:` when started)
- `research:` — deepen a project's contribution-surface knowledge
- `setup:` — harness/repo scaffolding
- `wg:` — working-group participation
- `cadence:` — the recurring monthly-floor guard

`br ready` is the "what's next" source of truth. Keep it honest (`/triage`).

## File layout

```
aaif/
├── CLAUDE.md              ← this file (the harness)
├── README.md             ← public-facing: what this is, learning in the open
├── SUBMISSIONS.md        ← the public portfolio index (every shipped contribution)
├── .beads/               ← task tracking (prefix aaif)
├── .claude/
│   ├── practices.md      ← the ambassador practice spec
│   └── skills/
│       ├── submission     ← the end-to-end submission pipeline
│       ├── aaif-review    ← score-check + conformance gate (type/points/checklist/issue drafter)
│       ├── gateway-audit  ← aggregate: what the fleet did (DuckDB request-log, or logs+metrics)
│       ├── gateway-cost   ← tokens + cache economics + $ only when priced
│       ├── gateway-watch  ← near-real-time threshold/anomaly alerts (one line per breach)
│       ├── gateway-trace  ← one request / one session, end to end
│       └── gateway-harden ← observed behavior → least-privilege CEL (human-gated)
│           (the five gateway-* skills share refs/gateway-request-log-cookbook.md)
├── refs/                 ← reference material (the research archive)
│   ├── aaif-overview.md
│   ├── gateway-request-log-cookbook.md  ← verified DuckDB query foundation for the gateway skills
│   ├── program/          ← program mechanics, strategy, brand/social (distilled; source PDFs stay in .local/)
│   ├── projects/         ← per-project contribution-surface briefs
│   ├── brand/            ← badge kit + Credly badge + header
│   └── research/         ← deeper research as it accrues
├── submissions/          ← one folder per contribution: <YYYY-MM>-<slug>/
└── .local/               ← PRIVATE reference (gitignored): source PDFs, Asana hub
                              IDs, notes — read like refs/, never published
```

## Conventions (inherited from the explore umbrella + global)

- **Gitmoji + bead trailer** on commits (`/commit`); one bead = one commit.
- **Always push** — commit and push as you go; this repo is public by design.
- Public-facing writing under Andrew's name → **`/zig-voice`**; keep AAIF framing
  **vendor-neutral** (LinearB tie = one closing link max).
- Reference material lives in `refs/` at root (not `.claude/refs/`).
- This is a **submodule of `~/explore`** (remote `azigler/aaif`, public) but a
  standalone repo with its own life.
- **`.local/` is a private reference folder — READ it like `refs/`, never publish
  from it.** It is gitignored (never committed) yet **first-class context**: it
  holds the **authoritative source docs** (the AAIF Ambassador Handbook + social
  guide PDFs in `.local/program-pdfs/`), the **Asana planning-hub IDs**, and
  private notes (`.local/private-notes.md`). The two-way rule:
  - **Read inward** — always consult `.local/` for grounding (it's where the
    source-of-truth docs and private context live). Don't let "gitignored" read
    as "ignore it"; that's the blindspot to avoid. When grounding a claim, the
    distilled `refs/` come first, but `.local/` holds the originals behind them.
  - **Never leak outward** — nothing from `.local/` (IDs, secrets, verbatim PDFs)
    ever lands in tracked files, bead descriptions, commit messages, or published
    artifacts. The repo is public; `.local/` is the private half of the same brain.
- **The two-tier knowledge rule (Zig, 2026-06-29):**
  1. **Source documents from AAIF / Angie** (PDFs, the opportunities doc, any
     not-yet-public campaign material — incl. the 5 white-paper titles + the
     opportunity menu) are **private → `.local/`**, never committed.
  2. **Your own distilled / secondhand research** (public MCP-spec analysis,
     agentgateway / goose / AGENTS.md / working-group findings) is **working
     knowledge → `refs/` → committed + public.** Keep sensitive specifics OUT of
     it: **no verbatim private-doc content** and **no attributing things to AAIF's
     unannounced campaign** (the white-paper titles + opportunity menu live in
     `.local/`). **Generalize Zig's private infra out of public refs** — refer to
     a self-hosted gateway / a local-model box / a private mesh in generic terms
     rather than by their private machine names — and prefer framing the
     local-model story on **goose** (an AAIF project he can openly champion).
     Named infra + genuine secrets (keys, tailnet IPs, Asana IDs) live only in
     `.local/`. When a detail is borderline, ask before pushing.

## Learning in the open

This repo is itself part of the ambassador story: the harness, the backlog, and
the mistakes are public so others can learn from how an agentic-AI practitioner
actually does the work. That transparency is a feature — and occasionally a
contribution in its own right (e.g. "here's the system I built to be a better
ambassador"). Keep it presentable.
