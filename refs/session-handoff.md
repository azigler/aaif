# Session handoff — 2026-07-01 (agentgateway o11y/gov plane → staged for build + content)

## ▶ Next session's focus: the staged bead pipeline

This session explored agentgateway deeply, verified the core capabilities on real
infra, scoped the stack, and scaffolded the next work into staged beads. The next
agent executes the build + the content, referencing the research. **Read each bead's
`br show` notes — they carry full scope / acceptance / deps / open-questions.**

**Execution order (what unblocks what):**
1. **`explore-if4y`** (in `~/explore`, run `br` from there) — DEPLOY the agentgateway
   o11y/gov plane on **pico** + MAP its full egress-data capabilities. Unblocks
   everything: the skills and the article both need the real capability map + a
   running gateway.
2. **`aaif-5ad`** — BUILD the gateway learning/hardening skills (`/gateway-audit`
   first, then `/gateway-harden`). Plan from `explore-if4y`'s capability map. **The
   part Zig is most excited about.**
3. **`aaif-715`** — WRITE the first AAIF submission: the perspective article *"The
   harness, the loop, and the gateway are converging."* Grounded in the build +
   skills (anti-slop). Flow: compile → `/aaif-review` self-review → Zig manual check
   → publish → (Zig explicit go-ahead) submit.
- **`aaif-pkb`** (decision) — the idea→explore→aaif-content process this arc models.

## The process (aaif-pkb, the meta-point of this scaffold)

Idea + exploration + research + elevation live in **`~/explore/<topic>/`** (beads
prefix `explore`, refs/, FINDINGS, DESIGN, `/elevate`). Spec + content production
live in **`aaif`** (beads prefix `aaif`: `/spec` → `/check` → build → `/aaif-review`
→ Zig manual check → publish → submit). AAIF beads reference explore bead IDs by hand
(br deps don't cross repos). This agentgateway arc is the first instance.

## What this session did

- **Bead `.26` DONE** — built the `/aaif-review` conformance skill (scorecard schema +
  rubric + issue drafter + submit gate), wired into `/submission`. Full scorecard
  reverse-engineering in `aaif/.local/research/aaif-review-system.md`.
- **Verified agentgateway on real infra:** identity/authz at the gateway
  (deny/allow/authorize); **per-agent identity** via tsnet (2 agents on one box,
  per-agent authz — `agent-frontend` 200 / `agent-backend` 403); **frontier o11y incl.
  a Max subscription** (Claude Code routes through the gateway + full `gen_ai.*` token
  o11y — the "you can observe your subscription's usage" finding).
- **Scoped the stack (Zig steer):** identity = agentgateway **virtual API keys**
  (native, no Tailscale, no external IdP); o11y = agentgateway's **own admin UI**
  (Logs + Analytics) + access logs — NOT an external Phoenix/OTel backend (Zig uses
  Phoenix minimally, wants to rip it); **Tailscale demoted** to a network-isolation
  option + serving the admin UI over the tailnet.
- **The thesis** (the article): harness ↔ loop ↔ gateway converging — DESIGN §2
  (four-loop-costs → gateway controls) + §3 (intent→policy down, telemetry→human up).
- **Deploy target = pico** (Zig: standing infra on pico, keep zig-computer clean).
  Audited pico; deploy plan lives in `explore-if4y`. `agctl` installed on zig-computer
  + added to `dotfiles/ubuntu.setup.sh`.

## Where everything is

- **Research/build:** `~/explore/agentgateway/` — `CLAUDE.md`, `DESIGN.md` (plan +
  thesis + skill bundle + layering), `FINDINGS.md`, `refs/{frontier-o11y,
  per-agent-identity, tailscale-auth-mechanism}.md`, `experiment/` (configs +
  `VERIFIED.md` + the tsnet demo; binaries/keys/logs gitignored).
- **The skill:** `aaif/.claude/skills/aaif-review/`.
- **Tabled:** beginner machine-level tutorial draft
  `~/explore/agentgateway/tutorial-draft.md` (superseded by the perspective article).

## Hard rules (do NOT violate)

1. **Never publish or submit to ANY AAIF surface without Zig** (⛔ gate, CLAUDE.md).
   `/aaif-review` stops at the submit gate.
2. **No gossip/competitiveness about other ambassadors in committed content** (.local only).
3. **Zig is on SSH + tmux:** clickable links, SendUserFile file-blocks, and images
   don't work for him. Deliver content **inline** or as a **file PATH** he can open;
   use **plain full URLs**, not `[text](url)`.
4. **Publishing path:** the article goes to andrewzigler.com via Zig's **Zettelkasten
   vault** (`github.com/azigler/zettelkasten` / his Obsidian vault), NOT
   `~/andrewzigler3/in/camp` (a build-time clone target that gets clobbered).
5. **pico deploy conventions:** standing infra on pico (macOS, **launchd**, no
   systemd); bind services to the **tailnet IP `100.72.47.4`**; reach pico via
   `ssh pico` (regular key SSH over the tailnet, port 2222, key `~/.ssh/id_ha` — NOT
   Tailscale SSH, which the tailnet ACL blocks).

## Check findings (fresh-eyes readiness review — MUST-FIX before build)

A read-only check agent reviewed the beads + design/refs. Verdict: only `aaif-pkb`
(a decision) is truly READY; the three executable beads are NEEDS-DETAIL. Enforce the
order by prose (br deps don't cross repos): **`explore-if4y` → `aaif-5ad` → `aaif-715`**;
`explore-9qj3` is off the critical path (verified input); `aaif-pkb` is context.

**Two highest-severity must-fixes:**
1. **Publish path is not reachable from this box and was undocumented.** The source of
   truth is Zig's **Obsidian Zettelkasten vault on `metis`** (`ZK_METIS_VAULT`),
   mirrored to `github.com/azigler/zettelkasten`. `~/andrewzigler3/in/camp` is a
   gitignored **build-time clone** (writing there = throwaway). Publishing = write via
   the **Obsidian Local REST API on metis** OR commit to the **azigler/zettelkasten**
   repo — neither reachable from zig-computer without setup. This trap was ALREADY
   sprung once (`tutorial-draft.md` was tagged `camp-note`; now marked SUPERSEDED).
   `aaif-715` cannot complete "publish" until this mechanism is settled (likely
   Zig-side, on metis).
2. **Identity-model fork — resolved in docs, confirm with Zig.** DESIGN §1 (virtual API
   keys) contradicted `per-agent-identity.md` (per-agent tsnet Tailscale identity as "a
   stronger AAIF piece"). Resolution written into both files + DESIGN's status note:
   **virtual keys is the adopted model; tsnet per-agent identity is parked
   (verified-but-niche).** Confirm Zig agrees.

**Other gaps folded:**
- **macOS port untested** — everything verified ran on Linux (socket
  `/run/tailscale/...`, systemd). pico is macOS: socket `/var/run/tailscale/...`,
  binary `agentgateway-darwin-arm64` (never run), launchd. `explore-if4y`'s "running on
  pico" acceptance hides this; resolve the **admin-UI-bind config syntax** (no CLI flag
  — it's a config field) FIRST.
- **Subscription attribution now OWNED by `explore-0d06`** — attribute the OAuth-path
  primary driver, or confirm it can't be. The article may claim **token observability**
  on subscription traffic (verified) but must NOT claim **per-agent attribution** of it.
- **`aaif-5ad` acceptance firmed:** build `/gateway-audit` (foundation) AND
  `/gateway-harden` (the leverage) — not just one; and the concrete log/trace SURFACE
  the skills parse (raw access-log lines? `agctl`? cost DB?) must be pinned by
  `explore-if4y`'s capability map before the skills start.
- **ToS / proxy-hop caveat** — the article's "route your own Claude Code through the
  gateway" hook nudges readers toward a ToS-gray, single-point-of-failure setup for
  their primary tool; decide how honestly to caveat it in the piece.
- **Anti-slop guard** — do NOT let `aaif-715` outrun `explore-if4y` + `aaif-5ad`; 2 of
  its 3 grounding pillars (the pico plane, the skills) don't exist yet, so drafting
  early = the vapor it claims not to be.
- **Docs fixed this pass:** `tutorial-draft.md` marked SUPERSEDED; `per-agent-identity.md`
  marked PARKED; `DESIGN.md` carries a post-check STATUS UPDATE reconciling the tutorial→
  perspective-article reframe + the identity-model resolution.

## Beads snapshot

- **Explore** (`~/explore`, prefix `explore`): `explore-if4y` (deploy+capabilities, P1),
  `explore-9qj3` (tailscale-auth, verified), `explore-7bz5`/`explore-hu3q` (virtual-LLM /
  virtual-MCP, backlog).
- **AAIF** (`aaif`, prefix `aaif`): `aaif-715` (article, P1), `aaif-5ad` (skills, P1),
  `aaif-pkb` (process decision), `aaif-ig1` (tailscale tutorial idea, folded as
  supporting), + the `aaif-ambassador-program-18o` epic backlog. `br ready` in each.
