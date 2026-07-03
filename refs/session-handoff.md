# Session handoff — 2026-07-03 (agentgateway plane WORKING; next = skills + tutorial)

> Resume doc for continuing in the **aaif** folder (Zig is restarting the session here
> with `cc-gw` on, so this session's own Claude Code traffic routes through the gateway
> and generates logs = dogfooding). Transcript + memory were copied into this project's
> Claude dir so history/memory are available here. Run `/onboard` then pick up below.

## Where we are: the o11y/gov plane is DEPLOYED + FULLY WORKING on pico

A real, instrumented, governed agentgateway plane runs on **pico** (macOS, launchd
`com.zig.agentgateway`). Verified end-to-end:
- **goose** (Block, an AAIF project) → local models via **ollama** on pico, scoped by a
  virtual key (`sk-goose`) to 2 MCP tools.
- **Claude Code** → Anthropic via the gateway's passthrough route (`cc-gw` toggle), full
  token o11y, `agent="unkeyed"` (OAuth, no per-agent key).
- **Per-identity governance**: virtual keys + `mcpAuthorization` CEL — goose sees 2 tools,
  cc sees all 14, no key → 401. The centerpiece demo.
- **Admin UI** (`http://pico.tailfb4637.ts.net:15000/ui`): LLM + MCP dashboards, 9-model
  catalog, **web Logs view** (SQLite request-log DB), **playground Send works**, payload
  logging on (`has_payload=1`).

**Config:** live (gitignored, real keys/IP): `~/explore/agentgateway/experiment/config-pico.yaml`;
generalized template committed: `config-pico.example.yaml`. Deploy = push to
`pico:~/.config/agentgateway/config.yaml` + `launchctl kickstart -k gui/$(id -u)/com.zig.agentgateway`.
Full field inventory + findings: `~/explore/agentgateway/refs/capability-map.md`.

## Hard-won findings (all in the capability map)

- **The LLM-playground 403 was OLLAMA, not the gateway.** agentgateway forwards the
  browser `Origin`; it strips browser CORS headers for Anthropic but NOT ollama, so ollama's
  `OLLAMA_ORIGINS` allow-list 403s. Fixed via the ollama provider's `defaults.requestHeaders.remove`.
  (Source-confirmed; an **unreported upstream bug** — candidate agentgateway contribution.)
- **High-level `llm:`/`mcp:` blocks** (not raw `binds`) are what light up the UI dashboards.
- **Request-log DB** = `config.database.url` (SQLite); payloads via `accessLog.database.add`
  (`llm.prompt`/`llm.completion` CEL). DB identity via `config.standardAttributes.user`.
- **ToS: routing your own Claude Code through your own gateway is Anthropic-DOCUMENTED +
  supported** (not "gray"). Drop the caveat everywhere (corrected in `frontier-o11y.md`).

## Zig's directives for THIS next phase (2026-07-03)

1. **Skills first.** Harden + finish the gateway skills (`aaif/.claude/skills/gateway-audit`,
   `gateway-harden`; the `aaif-5ad` bundle) and figure out how we actually USE them.
2. **Tutorial = clean setup from nothing → this full instrumentation** (goose + local models
   via ollama + Claude + the cc-gw toggle). **EXCLUDE Tailscale/tailnet** — too much complexity,
   not necessary. Bind to localhost/LAN in the tutorial instead.
3. **Self-made screenshots**: use a **browser/Playwright** (available on this box) to access the
   gateway UI and capture all tutorial screenshots MYSELF. Zig reviews, doesn't screenshot.
4. **Harden the demo/tutorial-building skill** to do #3 — and **re-review the LinearB
   `lb-demo-flow-builder` skill** (`~/linearb/skills/.claude/skills/lb-demo-flow-builder/SKILL.md`):
   screenshots-as-spine, section-by-section, read-aloud narration, placeholder discipline.
5. **DuckDB decision (settled this session):** agentgateway writes to **SQLite** (sqlx; NOT
   swappable to DuckDB). The right pattern (fits Zig's hevyd/DuckDB-native flow): keep SQLite as
   the write store, use **DuckDB as the analytics read layer** — `duckdb` ATTACHes the SQLite log
   and runs columnar OLAP (verified working). Wire the `gateway-audit`/`gateway-cost` skills to
   query the SQLite via DuckDB. Teach this SQLite-write / DuckDB-read split in the tutorial.

## Beads

- `aaif-715` — the article/tutorial (the deliverable). `aaif-5ad` — the skills bundle (audit +
  harden shipped; cost/watch/trace backlog `aaif-ambassador-program-18o.27`).
- `aaif-46m` — the (now largely superseded) hands-on crash-course bead; the plane is built now.

## Hard rules (unchanged)
- Never publish/submit to any AAIF surface without Zig's explicit go-ahead (⛔ gate).
- No gossip about other ambassadors in committed content.
- Zig on SSH+tmux: plain URLs, no clickable links / SendUserFile / images.
- Always commit + push as you go.
