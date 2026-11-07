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
**AGENTS.md** (OpenAI), **agentgateway** (Solo.io), **A2A** (Google; joined
2026-08-17 — aaif.io/blog/a2a-joins-aaif), **Agent Router** (Bloomberg + Tetrate,
in the Envoy community; the renamed Envoy AI Gateway, joined 2026-09-09 —
aaif.io/blog/agent-router-joins-aaif), and, from 2026-10-22 (MCPCon NA),
**Agent Skills** (Anthropic), **Open Responses** (OpenAI), **OpenEnv** (Hugging Face +
Meta) and **OpenSandbox** (Alibaba), plus 7 working groups. Sources per project:
`refs/aaif-overview.md`.
Contributions must tie directly to one of these. Deep dive: `refs/aaif-overview.md`.

## The submission pipeline (the core loop)

One submission = one `submission:` bead = one folder under `submissions/`. Eight steps;
the detail of each lives in **`/submission`** (`.claude/skills/submission/SKILL.md`):

1. **Pick** (idea backlog, `/randomize`) → 2. **Research** (`refs/projects/*`, re-verify live)
→ 3. **Build** (`submissions/<YYYY-MM>-<slug>/`) → 4. **Verify**, the anti-slop gate
(`/scrutinize`, `/aaif-review`; Andrew signs off) → 5. **Publish** (`/camp-publish` for
andrewzigler.com) → 6. **Submit** → 7. **Log** (`SUBMISSIONS.md` + the `cadence:` bead
`aaif-ambassador-program-18o.4`) → 8. **Amplify** (`/amplify`, drafts only).

Step 6 is a hard gate: ⛔ **STOP: never submit without alerting Zig and reviewing it
together first** (the Hard rule above). After his explicit go-ahead, open the issue in the
AAIF Ambassador submissions repository with the "Ambassador Contribution Submission"
template; `/aaif-review` drafts the body and stops at the gate. Submit early in the month:
monthly leaderboards are not recalculated for late entries.

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
| Creating / reviewing AAIF-branded visuals, slides, or social graphics | `/aaif-brand-guidelines` (`.claude/skills/aaif-brand-guidelines/`) — the AAIF brand system for any branded deliverable (authored by AAIF) |
| Building one contribution end-to-end | `/submission` (`.claude/skills/submission/`) |
| Starting a new submission folder | `bin/submission-init <YYYY-MM> <slug> [--title "<title>"]` |
| Capturing local gateway tutorial screenshots | `bin/tutorial-rig/README.md` — temporary rig, request driver, Playwright captures, and OCR gate |
| Building a long-form research paper / white-paper | `/research-paper` (`.claude/skills/research-paper/`) — the heavy long-form build branch of `/submission` (bootstrap → verbatim refs → angle-lock → per-section beads → read-only critic loop → REVIEW-NOTES human-gate → gated publish; every claim gets a grep-able test case; STOPS at the Zig submit-gate); the optional academic layer (Zenodo/arXiv/ORCID) points to the global `/cfp` arc — shares `refs/research-paper-pipeline.md` |
| Score-checking a contribution before publish/submit | `/aaif-review` (`.claude/skills/aaif-review/`) — type + points + conformance + issue drafter |
| Publishing a finished piece to andrewzigler.com | `/camp-publish` (`.claude/skills/camp-publish/`) — lexicon frontmatter + MDX body transform, build-validate, land in the camp vault before the daily build (the Publish step) |
| Announcing a shipped contribution / drafting community-help copy | `/amplify` (`.claude/skills/amplify/`) — the Amplify step (8): social + community-help copy in Zig's voice, AAIF tag/badge rules, records it in the submission's `AMPLIFY.md`, and answers "does this stand alone as its own 5-pt pulse contribution?" **Drafts only — posting is never automated**, it hands off to Zig for the live URL |
| Needing a header / OG image for a post | Two lanes: `/storybook-header` (`.claude/skills/storybook-header/`) — the pastoral-storybook series (watercolor farmland, the white goose in a red aviator scarf); or `/aaif-line-art` (`.claude/skills/aaif-line-art/`) — the AAIF-brand flat line-art lane (thick black outlines, orange/lavender palette; approved 2026-08) for pieces that should look AAIF-legit, plus hand-built brand-palette SVG diagrams. Both: never frontload — text locks first |
| Generating and picking post images | `bin/image-round` — seeded prompt matrix, dry-run previews, contact sheet, tailnet stage, OG crop and gated CDN upload |
| Writing / reviewing / packaging an AAIF blog post (editorial + intake) | `/aaif-blog-guidelines` (`.claude/skills/aaif-blog-guidelines/`) — aaif.io editorial + submission guidelines for blog content (authored by AAIF) |
| Watching the AAIF submissions landscape (trends / bloat / opportunities / grading sync) | `/aaif-radar` (`.claude/skills/aaif-radar/`) — weekly read-only scan → **private** report (`.local/radar/`) + **participant-free** closed `note` bead; notifies only when notable (runs as Part 1 of `/aaif-weekly`, Sat 15:00 PT) |
| Auditing / maintaining pinki (the promise tool aaif owns, `~/pinki`) | `/pinki-steward` (`.claude/skills/pinki-steward/`) — weekly read-only audit of the shared pinki ledger (`bin/pinki-audit.py`) plus a README/docs drift check for agent readers (`~/pinki/scripts/check-readme.sh`) → triage into upstream issues (standing grant, ≤3/week, via pigeon), wrapper beads for consul, usage notes; PRs are the steward's own call (Zig's standing grant, 2026-10-17), releases are the pulse's own call once the estate suites pass (fired by `pulse-pinki-steward`, Tue 13:07 PT, plus a canary tick the day after a release) |
| The weekly pass: radar, then closing the loop on aaif's own beads + repo | `/aaif-weekly` (`.claude/skills/aaif-weekly/`) — Part 1 runs `/aaif-radar`; Part 2 triages the bead store (close done work with evidence, fold duplicates, release stale claims, re-rank), check the monthly floor, run the index-vs-disk lint; ends every run with one four-part desk mail (fired by `pulse-aaif-weekly`, Sat 15:00 PT, which replaced `pulse-aaif-radar`; spec aaif-ub9x) |
| Observing / accounting / tracing / hardening an agentgateway fleet | `/agentgateway` (`.claude/skills/agentgateway/`) — one read-only skill, four components: **audit** (what the fleet did), **cost** (tokens + cache economics + $ only when priced), **trace** (one request/session + privacy-gated payloads), **harden** (observed behavior → proposed least-privilege CEL; human-gated, never applies) |
| Writing/verifying a gateway request-log query | `refs/gateway-request-log-cookbook.md` — the verified DuckDB-over-SQLite cookbook (schema, gotchas, queries) the `/agentgateway` skill's components share |
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
├── CLAUDE.md · README.md (public face) · SUBMISSIONS.md (public portfolio index)
├── .beads/                  ← task tracking (prefix aaif)
├── .claude/practices.md     ← the ambassador practice spec
├── .claude/skills/<name>/   ← one Routing row each (above); housekeeping = the index-vs-disk lint
├── refs/                    ← reference material; refs/README.md indexes every file
│                               (deeper research accrues as `study` beads, not a refs/research/ dir)
├── submissions/             ← one folder per contribution: <YYYY-MM>-<slug>/
└── .local/                  ← PRIVATE (gitignored): source PDFs, Asana hub IDs, notes;
                                read like refs/, never published
```

## Conventions (global `~/.claude/CLAUDE.md` + this file)

- **Gitmoji + bead trailer** on commits (`/commit`); one bead = one commit.
- **Always push** — commit and push as you go; this repo is public by design.
- Public-facing writing under Andrew's name → **`/zig-voice`**; keep AAIF framing
  **vendor-neutral** (LinearB tie = one closing link max).
- Reference material lives in `refs/` at root (not `.claude/refs/`).
- This is a **top-level home project** at `~/aaif` (remote `azigler/aaif`, public) —
  **graduated out of the `~/explore` umbrella on 2026-07-03** (`/graduate`). It reads only
  the global `~/.claude/CLAUDE.md` plus this file — no longer the explore umbrella's
  `CLAUDE.md`/beads/monorepo. Own git, own `.beads`, own life.
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
