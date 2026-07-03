# Session handoff — 2026-07-03 ba17a917 (gateway compaction bug fixed; toggle hardened; next = skills + tutorial)

## State at offboard
- Current branch: `main` (aaif)
- Open beads: 28; in-progress: 0. Top: `aaif-715` (article/tutorial), `aaif-46m` (crash-course, superseded), `aaif-ambassador-program-18o.27` (skills bundle extensions).
- In-flight subagents: none. Dirty files: none in aaif. (~/dotfiles has Zig's own uncommitted `.profile`/`.zprofile`/`settings.json`/two aaif skills — NOT mine, left untouched.)
- This session's commits landed in **other repos** (work was infra/refs, not aaif tracked files):
  - `dotfiles@c750121` — cc-gw/cc-direct true toggle
  - `explore@5023a13` — agentgateway maxBufferSize fix + capability-map finding
- ⚠ aaif is an **unabsorbed submodule** — run `cd ~/explore && git submodule absorbgitdirs aaif` before any worktree subagents (else worktrees land in the parent's `.claude/worktrees/`).

## What happened this session
Started dogfooding (this CC session launched with `cc-gw` ON → its own traffic routes through the pico gateway). Three intertwined issues, all traced to the AI-parsing path, all resolved:

1. **Compaction 503 "request was too large" (root-caused + FIXED).** The gateway's own error (`reason=Internal`, never reached Anthropic). Cause: `frontendPolicies.http.maxBufferSize` default = **2 MiB**; CC context-compaction (its largest request) exceeds it → deterministic 503 → retries dead-loop → context can't shrink. **Fix: raised to 32 MiB (`33554432`)** on the global (only) knob; matches Anthropic's ~32MB ceiling. Deployed to `pico:~/.config/agentgateway/config.yaml`, restarted, **verified live** (bind up, a real 200 flowed through). The depth-vs-fragility finding is written into `~/explore/agentgateway/refs/capability-map.md` — prime *tempered-realism* article material.
2. **cc-gw/cc-direct → true toggle.** Now also adds/removes the `omni-gw` MCP server (CC presents its virtual key → governed tools) in lockstep with the LLM route; `cc-route` reports both. Compaction caveat baked into the comment block. Tested round-trip.
3. **CC prompt logging** — already ON (recent `claude-cli` rows `has_payload=1`); the "off" Zig saw was stale pre-reload history. No change needed.

Also nailed the **launch-time `ANTHROPIC_BASE_URL` gotcha**: `cc-direct` only affects *future* sessions; a session started under cc-gw stays routed until restart (this is why my traffic kept hitting the gateway after Zig went direct).

## What's next (the handoff's standing phase — unchanged)
1. **Skills first** — harden `gateway-audit` + `gateway-harden`; build the `aaif-ambassador-program-18o.27` bundle (`/gateway-cost`, `/gateway-watch`, `/gateway-trace`); figure out how they're actually used. Wire the audit/cost skills to query the SQLite request-log DB via **DuckDB** (ATTACH; SQLite-write / DuckDB-read split).
2. **Tutorial (`aaif-715`)** — clean setup from nothing → full instrumentation (goose + local ollama + Claude + the true cc-gw toggle). **EXCLUDE Tailscale/tailnet** (bind localhost/LAN). Section-by-section, ambitious/technical, tempered-realism (the 2 MiB compaction finding is a centerpiece), applied-academic voice, "As above, so below."
3. **Self-made screenshots** via browser/Playwright (on this box) — capture all UI shots myself; Zig only reviews. First **re-review `~/linearb/skills/.claude/skills/lb-demo-flow-builder/SKILL.md`** (screenshots-as-spine, section-by-section, read-aloud narration, placeholder discipline) and harden the demo/tutorial skill to do this.

## Warnings / watch-outs
- **This session chose "ride" (stay routed).** Auto-compaction will fire soon and is now the LIVE proof of the maxBufferSize fix — if it succeeds through the gateway, the fix is validated end-to-end. If it still fails, the request may exceed 32 MiB (unlikely; Anthropic caps ~32MB) — then flip `cc-direct` + restart.
- After editing the toggle, **re-source `~/.bash_aliases`** (or new shell) before toggling — a running shell holds old function defs.
- Gateway config source-of-truth = `~/explore/agentgateway/experiment/config-pico.yaml` (gitignored, real keys); committed template = `config-pico.example.yaml`. Deploy = `cat > pico:~/.config/agentgateway/config.yaml` then `launchctl kickstart -k gui/$(id -u)/com.zig.agentgateway`.
- Hard rules unchanged: never publish/submit to AAIF without Zig's go-ahead; no ambassador gossip in committed content; SSH+tmux (plain URLs, no SendUserFile/images); always commit + push.
