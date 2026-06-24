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

## What AAIF is (one paragraph)

The **Agentic AI Foundation** (Linux Foundation) — neutral open home for the
standards/projects of agentic AI: **MCP** (Anthropic), **goose** (Block),
**AGENTS.md** (OpenAI), **agentgateway** (Solo.io), plus 7 working groups.
Contributions must tie directly to one of these. Deep dive: `refs/aaif-overview.md`.

## The submission pipeline (the core loop)

Every contribution flows through these steps. One submission = one `submission:`
bead = one folder under `submissions/`.

1. **Pick** — choose the next contribution from the idea backlog (`br list`,
   `idea:` beads) balancing project / format / leverage. Use `/ssot` to resist
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
   confirm the prime-directive checklist. Andrew signs off.
5. **Publish** — push the public artifact (blog URL, PR, video, talk page…).
6. **Submit** — open an issue in the **AAIF Ambassador submissions repository**
   using the "Ambassador Contribution Submission" template: GitHub handle
   `azigler` · contribution URL · related AAIF project(s) · notes. (Submit early
   in the month — monthly leaderboards aren't recalculated for late entries.)
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
│   └── skills/submission ← the end-to-end submission pipeline skill
├── refs/                 ← reference material (the research archive)
│   ├── aaif-overview.md
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

## Learning in the open

This repo is itself part of the ambassador story: the harness, the backlog, and
the mistakes are public so others can learn from how an agentic-AI practitioner
actually does the work. That transparency is a feature — and occasionally a
contribution in its own right (e.g. "here's the system I built to be a better
ambassador"). Keep it presentable.
