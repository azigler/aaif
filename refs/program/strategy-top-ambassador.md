# Strategy — becoming a top AAIF ambassador

> The synthesis doc. Goal (Andrew's words): *"be one of the top ambassadors …
> a steady stream of high-quality, high-engagement submissions on a monthly
> basis."* This is the playbook the harness optimizes for. Pairs with
> `ambassador-program.md` (the rules) and `../projects/*` (the surfaces).

## What "top ambassador" actually means

Three things compound — points are only one:

1. **Cumulative points** → leaderboards, scoreboards, monthly reports. The
   visible ranking. (Point table in `ambassador-program.md`.)
2. **Sustained quality + consistency** → renewal (6-monthly), recognition,
   amplification, and being tapped for **leadership opportunities, events,
   keynote acknowledgment**. The handbook is explicit: status/badges "help AAIF
   identify active contributors for amplification, leadership opportunities,
   events, and special recognition."
3. **Genuine community impact** → the thing the program actually exists for
   ("help developers move from curiosity to capability"). It's what makes the
   first two durable rather than gamed.

So the objective function is **high points × high quality × real usefulness**,
sustained monthly — never one at the expense of the others. Gaming points with
slop is the one move that actively hurts (see the anti-slop doctrine).

## Andrew's unfair advantages (the leverage thesis)

The reason "top ambassador" is realistic, not aspirational:

1. **He already runs the system AAIF is standardizing.** His harness is a working
   instance of every AAIF project at once: AGENTS.md/CLAUDE.md (the standard),
   MCP servers (built several), an agent gateway (a self-hosted gateway ≈ agentgateway),
   multi-agent orchestration (worktree subagents ≈ goose subagents), fleet
   observability (≈ the observability WG). **Every piece of his existing
   practice is latent, credible ambassador content** — "here's how I actually run
   this," which is exactly what AAIF rewards over marketing.
2. **The publishing machine already exists.** `/zig-voice`, `/explore`, `/talk`,
   `/cfp`, `/ssot`, `/impeccable`, plus LinearB / Dev Interrupted distribution.
   Most ambassadors have to build a content pipeline; Andrew has one and just
   needs to point it at AAIF targets.
3. **`public-agents` is empty and uses his exact `SKILL.md` format.** The single
   highest-leverage move available: land the **first** general-purpose
   engineering skills + the first `recipes/`/`prompts/` content. Becomes
   foundational reference, installable across goose/Claude Code/Codex/Gemini, and
   carries a "I shipped into the Linux Foundation's repo" signal. Copy-adapt-PR,
   not net-new authoring.
4. **The anti-slop doctrine favors him.** AAIF rejects agent slop and prizes
   real-usage practitioner work. His harness's `/scrutinize` gate *is* the
   quality bar AAIF describes ("agents are collaborators, not accountability
   shields"). His content is verified-before-shipped by construction.
5. **Two working groups fit his rare expertise.** Observability-and-Traceability
   (he built fleet observability — tmux lexicon, pulse, beads) and
   Security-and-Privacy (a self-hosted gateway hardening, egress allowlists). WG participation
   is a leadership-tier path beyond content.

## The cadence engine (portfolio, not heroics)

Sustainability beats bursts. A layered mix keeps the leaderboard ticking, hits
the monthly floor with margin, and lands the high-value tentpoles that move
ranking and unlock recognition:

| Layer | Cadence | Formats (points) | Role |
|---|---|---|---|
| **Pulse** | weekly-ish | social thread (5), community help (5–15) | presence; keeps leaderboard warm; #AAIFAmbassador + tag @AgenticAIFdn |
| **Anchor** | monthly | blog (15), tutorial (20), short video (15), project contribution (5–50) | satisfies the floor with margin; the reliable spine |
| **Tentpole** | quarterly | conference talk (30), workshop (35), livestream (25), course (50) | leaderboard movers + recognition/keynote/leadership signal |
| **Opportunistic** | as found | project PRs to public-agents / agentgateway / goose recipes (5–50) | first-mover, durable, high-credibility artifacts |

Rough annual envelope if sustained: pulse (~150–250) + anchors (~200) +
tentpoles (~120) + project PRs (~150) → **well into top-tier output** — without
ever cramming. The point is the *mix*, not a number; adjust to real life.

> ⏱️ **Timing rule that shapes everything:** monthly leaderboards are NOT
> recalculated for late submissions. **Submit early in the month.** Bank the
> anchor in week 1–2; let pulse + opportunistic fill the rest.

## Selection heuristics (what to make next)

When picking the next submission, balance three axes (use `/ssot` to resist
collapsing to "always another MCP blog"):

- **Project balance** — rotate across MCP / goose / AGENTS.md / agentgateway so
  coverage is broad (helps AAIF's reporting/promotion). But *lean into* the two
  standout lanes: **AGENTS.md + public-agents** (his sweet spot) and the
  **local-model + gateway** angle (his unique infra — almost nobody can write it).
- **Format balance** — don't only blog. Each quarter must include ≥1 tentpole
  (talk/workshop/livestream/course). Each month should mix at least one
  build-something (PR/recipe/tool) with the writing.
- **Leverage** — prefer pieces that are (a) grounded in something he actually
  runs, (b) first-mover/durable (catalogs, first-in-repo skills), and (c)
  multi-purpose (a talk that's also a blog that's also a WG deliverable). The
  agentgateway observability piece, for example, is simultaneously a talk, a
  video, and a WG contribution.

## The standout opening moves (highest leverage, do early)

Ranked, drawn from the four project briefs:

1. **First general-purpose skill in `aaif/public-agents`** — e.g.
   `orchestrator-worktree` or the scrutinize gate, as a `SKILL.md` PR. Inaugural
   non-internal skill in the foundation library. (agents-md brief #3/#4.)
2. **"The CLAUDE.md files that run a robot fleet"** — annotated, open-sourced
   real harness configs as master-class AGENTS.md examples. (agents-md #1.)
3. **AGENTS.md pattern + anti-pattern catalog** — answers open issue #207
   directly; evergreen + SEO-durable. (agents-md #2.)
4. **"Driving a 30B local coder with goose on a Mac Studio"** — the tool-calling
   reality check; serves goose's #1 roadmap theme, unwritable by most. (goose #2.)
5. **Observability for an agent fleet** (talk/video) + join
   wg-observability-and-traceability — dual-purpose, leadership-tier. (agentgateway #3.)
6. **AGNTCon / MCPCon talk** via `/cfp` → `/talk` — accepted talk = top-tier
   signal + keynote/VIP/leadership access.

## Anti-patterns (the ways "top" goes wrong)

- **Agent slop** — the cardinal sin; everything passes the human-verify gate.
- **Generic "agents are the future"** content — must be specific + project-tied.
- **Overcommitting then missing the monthly floor** — consistency > one big push.
- **Vendor bias** — AAIF is neutral; the LinearB tie stays to a single closing
  link with vendor-neutral framing (mandatory for the AAIF-blog editorial gate).
- **Reposts without commentary / AAIF-in-passing** — don't qualify; don't bother.
- **Hoarding the backlog** — ideas only count when shipped + submitted.

## How this maps to the harness

Every layer above is a bead type + a pipeline step. The submission pipeline
(research → build → verify → publish → submit → log → amplify) is the
`/submission` flow in `.claude/skills/`. The cadence floor is enforced by a
monthly check. See `../../CLAUDE.md`.
