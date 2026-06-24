# MCP (Model Context Protocol) — contribution surface brief

> Researched 2026-06-24, cross-verified against official sources. One of four
> AAIF submission targets — and the connective tissue across all of them (goose,
> agentgateway, and AGENTS.md tooling all touch MCP).

## What MCP is

An open standard — a **JSON-RPC wire protocol** — letting AI apps
("hosts/clients") connect to external tools/data/context ("servers") through a
uniform interface ("USB-C for AI"). Contributed by **Anthropic** (launched Nov
2024); **~110M monthly SDK downloads**, **10,000+ public servers** by mid-2026.
**AAIF founding project since 2025-12-09**; keeps full technical autonomy (same
maintainers, the **SEP** process).

## Repos & ecosystem map

Org: **github.com/modelcontextprotocol** (~30 repos).

**Core protocol & docs**
- `modelcontextprotocol` (~8.5k★) — the **spec AND docs** (→ modelcontextprotocol.io).
  SEPs in `/seps`. ⚠️ the old standalone `docs` repo is **archived** — don't contribute there.
- `blog.modelcontextprotocol.io` — separate Hugo site.

**Official SDKs (9 langs, partner-maintained):** python (~23k, Anthropic, Tier 1) ·
typescript (~13k, Anthropic, Tier 1) · go (~4.7k, Google) · csharp (~4.3k, MS) ·
rust/`rmcp` (~3.6k, Tier 2) · java (~3.5k, Spring AI) · php (~1.5k) · kotlin
(~1.4k, JetBrains) · ruby (~856, Shopify) · swift (thinnest).

**Tools & infra**
- `servers` (~88k★) — **now curatorial, NOT a contribution target.** 7 reference
  servers only (Everything, Fetch, Filesystem, Git, Memory, Sequential Thinking,
  Time); originals moved to `servers-archived`.
- `registry` (~7k★, Go) — official server registry (**still PREVIEW, no GA**).
- `inspector` (~10k★) — visual server testing tool.
- `conformance` — conformance test suite (now gates Standards-Track SEPs).
- `mcpb` (~2k★) — **MCP Bundles** (renamed from DXT, Nov 2025): `.mcpb` + `manifest.json` one-click install.
- `quickstart-resources`, `example-remote-server`.

**Extensions** (reverse-DNS-namespaced, formalized in the RC): official `ext-apps`
(MCP Apps — sandboxed HTML UIs via `ui://`), `ext-auth`, ext-tasks; experimental
`experimental-ext-skills` (Skills over MCP, `skill://`), interceptors,
triggers-events, etc. Working groups: transports-wg, agents-wg + Registry/
Inspector/Security/Auth interest groups.

## Maturity & current state (mid-2026)

- **Current Final spec: `2025-11-25`** (date-versioned). Adds OIDC Discovery,
  tool/resource/prompt icons, incremental scope consent, `ElicitResult`/
  `EnumSchema` redesign + URL-mode elicitation, tool-calling inside sampling,
  experimental **Tasks** (durable ops), JSON Schema 2020-12 default, SDK tiering.
- **`2026-07-28` is a RELEASE CANDIDATE** (locked 2026-05-21, not yet final):
  "largest revision since launch" — a **stateless protocol core** (drops the
  `initialize` handshake + `Mcp-Session-Id`; adds method/name routing + caching),
  W3C Trace Context, the Extensions framework formalized, MCP Apps + Tasks
  promoted, six auth-hardening SEPs, and **12-month deprecation of Roots,
  Sampling, Logging**.
- 2026 roadmap priorities: transport scalability, agent communication, governance
  maturation, enterprise readiness.

## Contribution surface (named gaps)

**Docs gaps (clearest greenfield):**
- **Build AND DEPLOY a remote server** — the official build-server tutorial is
  **stdio-only**; no first-party "deploy a Streamable-HTTP server with OAuth"
  guide (devs get punted to Cloudflare). The single clearest tutorial gap.
- Session affinity / multi-worker routing (#2064); Streamable HTTP concurrency
  (#1053); server `instructions`/`description` guidance (#2146, #2060).
- *Already done — don't re-pitch:* Security Best Practices page, Keycloak OAuth
  tutorial, Registry publishing quickstart.

**Good-first-issue surface (ranked):** python-sdk (richest, best-triaged) →
typescript-sdk → spec/docs doc cluster → experimental-ext-skills. *Avoid
`servers` + the archived `docs` repo.*

**Missing tutorials (demand × emptiness):** (1) Elicitation + Sampling + Roots
end-to-end with a **live client-support matrix**; (2) host-agnostic remote
deployment + stdio→HTTP migration; (3) MCP Apps from scratch; (4) the MCP test
pyramid (Inspector + conformance).

**Underdocumented security patterns** (rich externally, unnamed officially):
tool poisoning / rug-pulls (no diff/re-consent/TOFU-pinning mandate on
`tools/list_changed`); the **lethal trifecta** applied to MCP; "how to actually
sandbox a server"; server provenance/vetting (discussion #2913, signed manifests).

**Underserved SDKs:** Swift (thinnest), Rust/`rmcp` (~40% API doc coverage),
Kotlin (#2512), Ruby (docs lag two spec versions).

## 6 tailored submission ideas

1. **"I gave my multi-agent harness a registry: publishing a fleet of MCP servers
   under one namespace"** — blog + sample `server.json` PR. Registry preview +
   `mcp-publisher` + reverse-DNS. Rides imminent registry GA; he has a real
   *fleet* to publish. Points 15+.
2. **"Build and deploy a *remote* MCP server with OAuth — host-agnostic, no
   Cloudflare lock-in"** — tutorial (into the docs repo, fills the confirmed gap)
   + video. His **a self-hosted gateway VPS** is the perfect non-Cloudflare target. Points 20.
3. **"MCP's lethal trifecta: tool poisoning, rug-pulls, and a TOFU-pinning pattern
   that stops them"** — deep-dive blog → talk/livestream; could mature into a SEP
   (#2913). His **hooks** demo client-layer manifest pinning; Dev Interrupted
   amplifies. Points 15→30.
4. **"Elicitation, sampling, and roots — the primitives nobody finished
   documenting (with a live client-support matrix)"** — tutorial + maintained
   matrix PR + screencast. "Use-it-and-migrate" given the RC deprecations. He runs
   many clients + local models → can actually test each cell. Points 20.
5. **"Wiring MCP into local models: serving qwen3-coder over MCP on a Mac
   Studio"** — tutorial + video. Zero first-party "MCP + local models" content;
   a local-model box is exactly the rig. Points 20+15.
6. **"The MCP test pyramid: Inspector, the conformance suite, and CI for your
   servers"** — tutorial + reusable GitHub Actions template (PR). His beads +
   pulse + hooks = a "continuously conformance-check a server fleet" story;
   on-brand for an SDLC voice. Points 20.

## Accuracy flags

- `2026-07-28` is a **Release Candidate** — cite `2025-11-25` as current Final.
- The **Registry is still in preview** (no GA as of mid-2026).
- Adoption numbers (~110M downloads, ~9,600 servers) are Anthropic/registry-API
  snapshots via a secondary aggregator.

## Sources

- https://www.anthropic.com/news/donating-the-model-context-protocol-and-establishing-of-the-agentic-ai-foundation
- https://blog.modelcontextprotocol.io/ (MCP-joins-AAIF, 2026 roadmap, 2026-07-28 RC, registry preview, MCPB, MCP Apps)
- https://modelcontextprotocol.io/specification/2025-11-25/changelog · /community/sep-guidelines · /registry/about
- https://github.com/orgs/modelcontextprotocol/repositories (+ inspector, conformance, mcpb, registry)
- Security canon: Invariant Labs (tool poisoning), Trail of Bits (line jumping), Simon Willison (lethal trifecta)
