# goose — contribution surface brief

> Researched 2026-06-24 against official AAIF / goose-docs.ai / GitHub sources.
> Verified facts only; speculative items flagged. One of four AAIF submission
> targets. See `refs/program/strategy-top-ambassador.md` for how this feeds the
> submission cadence.

## What goose is

goose is an open-source, **local-first, provider-agnostic AI agent** that runs
on your machine (desktop app, full CLI, or embeddable API), built in **Rust**
and extensible through **MCP**. Originally built and open-sourced by **Block**,
it was contributed in **April 2026** to AAIF and now lives under the
`aaif-goose` GitHub org. General-purpose (code, research, writing, automation,
data analysis), works with **any LLM** including local models.

## Architecture & ecosystem

| Piece | What it is | URL |
|---|---|---|
| **Surfaces** | Native desktop app (Electron, mac/Linux/Win), full CLI, embeddable API. GUI in `ui/desktop`; core is Rust (`goose-cli`, `goose-server`). | https://goose-docs.ai/ |
| **Extensions** | 70+ tool integrations via **MCP** — goose was an early MCP adopter. | https://goose-docs.ai/ |
| **Recipes** | Portable **YAML** workflow configs: instructions/prompt, extensions, typed parameters, settings (provider/model/temp/max_turns), structured `response` schema, `retry`, `activities`, `sub_recipes`. Shareable via deeplink, runnable in CI, version-controllable. | https://goose-docs.ai/docs/guides/recipes/ |
| **Subagents** | Independent isolated goose instances run in **parallel** (own ExtensionManager/ToolMonitor/context). Limits (re-verify): ~10 concurrent, 5-min default timeout, 25 max turns. `summon` extension auto-injects when subrecipes present. | https://goose-docs.ai/ |
| **Providers** | 15+ headline / 50+ total. Cloud (Anthropic, OpenAI, Gemini, Azure, Bedrock, Groq, Mistral…), gateways (OpenRouter, LiteLLM), **local: Ollama (primary), LM Studio, Docker Model Runner, Ramalama**, plus **ACP** to reuse Claude/ChatGPT/Gemini subscriptions. | https://goose-docs.ai/docs/getting-started/providers |
| **Local-model caveat** | goose leans hard on **tool-calling** → works best with frontier models. Local models must be tool-call-capable (qwen2.5/qwen3, Llama 3.1/3.3, Mistral). Watch Ollama's **4096-token default context** — raise `OLLAMA_CONTEXT_LENGTH` or hints/extensions get ignored. | same |
| **MCP-UI** | Renders interactive MCP-UI components as real widgets (one of ~3 clients that do). | — |

**Repos & docs:** code https://github.com/aaif-goose/goose (Apache-2.0) ·
docs https://goose-docs.ai/ · CONTRIBUTING
https://github.com/aaif-goose/goose/blob/main/CONTRIBUTING.md · GOVERNANCE
`/GOVERNANCE.md` · Discord https://discord.gg/goose-oss.

## Maturity & current state (mid-2026)

- **Very mature and active**: ~50k stars, ~5.3k forks, 138 releases, latest
  **v1.38.0 (2026-06-17)** — near-weekly cadence.
- **Governance transition complete (2026-04-07)**: `block/goose` → `aaif-goose/goose`,
  docs → `goose-docs.ai`.
- **Roadmap themes (Feb–Apr 2026)** to align contributions with: (1) open/local
  models (built-in downloads, prompt-tuning small models, latency-aware
  planning); (2) Apps (composable, MCP-based); (3) out-of-the-box experience;
  (4) meta-agent orchestration (sessions + workflows + recipes + parallel
  subagents); (5) composable UI primitives; (6) protocol standardization (MCP
  for tools, ACP for agent↔client). https://github.com/aaif-goose/goose/discussions/6973
- **2026 events** for talks/CFPs: **AGNTCon + MCPCon** (NA + Europe).

## Contribution surface (concrete)

1. **Recipe Cookbook PRs** (lowest-friction, rewarded). Add a `.yaml` under the
   docs recipes data dir, open a PR. Past drives rewarded approved recipes with
   OpenRouter credits (verify still active). Cookbook: https://goose-docs.ai/recipes
2. **Documentation** — first-class path in CONTRIBUTING; providers/local-model
   docs are an obvious gap to fill.
3. **Code PRs** — Rust core via Hermit + `just` + `cargo`; desktop via
   `just run-ui`. Maintainers warn against "AI slop" big PRs — **start small**.
   Conventional-commit PR titles required.
4. **Extensions / MCP servers** — author a goose extension and list it.
5. **Skills Marketplace** — goose has a skills surface (authorable).
6. **Good-first-issues / roadmap-aligned features** — local-model + subagent
   orchestration items map directly to Andrew's expertise.

## 6 tailored submission ideas

> Each leans on a real edge: Claude Code power user, local-first inference
> (a local-model box/a self-hosted gateway), MCP authorship, LinearB / Dev Interrupted distribution,
> CLAUDE.md/AGENTS.md authorship. Point values from the handbook in brackets.

1. **"goose vs Claude Code: an honest field guide for the orchestration power user"**
   — blog + Dev Interrupted cross-post [15]. Recipes vs CLAUDE.md, goose
   subagents vs git-worktree subagents, MCP/ACP. Highest-demand comparison in
   the space, written by someone who genuinely runs both. Also tags MCP +
   AGENTS.md (multi-project coverage).
2. **"Driving a 30B local coder with goose on a Mac Studio: the tool-calling reality check"**
   — tutorial + video [20+15]. Ollama/LM Studio config, qwen3-coder-30b, the
   4096-context trap, which local models survive goose's tool-call demands.
   Serves the #1 roadmap theme; almost nobody else can write it authentically.
3. **"A recipe that orchestrates a fleet: parallel subagents for repo-wide refactors"**
   — recipe-PR + writeup [5–50 + 15]. `sub_recipes`, `summon`, the limits,
   parameters + structured `response`. Ships a useful artifact, may earn the
   reward, maps to meta-agent-orchestration. Translate the worktree+beads
   pattern into idiomatic goose recipes.
4. **"From CLAUDE.md to .goosehints + recipes: porting an agent harness"**
   — tutorial / livestream [20 or 25]. hints vs rules vs executable workflows.
   Huge audience of devs with existing CLAUDE.md/AGENTS.md files.
5. **"Build an MCP extension for goose end-to-end (and reuse it in Claude Code)"**
   — code-PR + video [5–50 + 15]. MCP is the connective tissue across all four
   AAIF projects; "write once, run in two agents" is a strong narrative.
6. **"The air-gapped agent: goose + a private VPS gateway with zero cloud LLM"**
   — talk/CFP (AGNTCon/MCPCon) seeded by a blog [30]. Local-first providers,
   ACP/MCP boundaries, sovereign/offline workflows. Flagship local-first story;
   reproducible via a self-hosted gateway + a local-model box.

## Accuracy flags

- "$10 OpenRouter credits" was a first-50-approved launch promo — confirm before
  promising it.
- Subagent limits (10/5-min/25) come from a community gist + roadmap-era docs —
  re-verify against current docs before publishing exact numbers.
- `goose-docs.ai` is canonical post-move (legacy `docs.goose.dev` / `block.github.io/goose`).

## Sources

- https://goose-docs.ai/blog/2026/04/07/goose-moves-to-aaif/
- https://github.com/aaif-goose/goose · https://goose-docs.ai/
- https://goose-docs.ai/docs/guides/recipes/ · https://goose-docs.ai/docs/getting-started/providers
- https://goose-docs.ai/recipes · https://github.com/aaif-goose/goose/discussions/6973
- https://aaif.io/projects/goose/ · https://aaif.io/ambassadors/
