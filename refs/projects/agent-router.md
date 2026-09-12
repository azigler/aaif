# Agent Router — contribution-surface brief

> **Newest AAIF project** — joined **2026-09-09**
> (https://aaif.io/blog/agent-router-joins-aaif), as the **rename of Envoy AI
> Gateway**. AAIF's *second* gateway: where agentgateway is a Rust MCP/A2A-native
> proxy, Agent Router is a **Go control plane that drives Envoy** as its data
> plane. Facts verified **2026-09-12** against the repo, the 1.0/1.1 release
> notes, and the live docs; unverifiable claims are marked **UNVERIFIED** inline.
> Repo https://github.com/theagentrouter/agent-router · docs
> https://theagentrouter.ai/docs · Apache-2.0 · Go.

## What it is

The open-source **control plane for AI and agent traffic, powered by Envoy**
(README, first line). Application teams get one OpenAI-compatible API across
hosted providers, self-hosted inference, and MCP servers; platform teams keep
credentials, routing, quotas, failover, and usage accounting in one place. The
project's own slogan is the cleanest summary: **"Agent Router controls. Envoy
carries."**

Two shapes: **standalone** — `OPENAI_API_KEY=sk-… aigw run`, then point any
OpenAI-compatible client at `http://localhost:1975/v1` (README; `site/docs/cli/run.md`),
no cluster required — and **Kubernetes**, CRDs reconciled by a controller that
configures Envoy Gateway. The announcement's "same config scales from a laptop to
Kubernetes" describes the *resource model*, not one artifact: the laptop path is
the CLI plus a config file, the cluster path is CRDs.

## History & governance

- Public development began **2024-10-21** (repo `createdAt`), out of Bloomberg
  engineers bringing an LLM-traffic problem to the Envoy community and joining
  forces with Tetrate (announcement).
- **15 stable releases**, v0.1.0 (2025-02-25) → **v1.0.0 (2026-06-23, GA)** →
  **v1.1.0 (2026-08-21)** — GitHub releases API, non-rc tags, matching the
  announcement's "fifteen stable releases".
- **Nine maintainer seats** across Bloomberg, Nutanix, AMD, Tetrate, Netflix, no
  company holding a majority; **132 contributors from 21 organizations**;
  **eleven listed adopters** including Bloomberg, Tetrate, Tencent Cloud,
  Nutanix, LY Corporation, and the National Research Platform (announcement).
  `MAINTAINERS.md` lists nine people with per-area ownership, including a named
  area for "MCP, aigw CLI (standalone mode)".
- Apache-2.0; LF Projects Code of Conduct; `Technical_Charter.pdf` at repo root.

**The rename changed almost nothing operationally** (README, "Formerly Envoy AI
Gateway"): unchanged CRD kinds and `aigateway.envoyproxy.io` API group, the same
`aigw` CLI, the same `envoy-ai-gateway-system` namespace, the same container
images (`docker.io/envoyproxy/ai-gateway-*`) and Go module path
(`github.com/envoyproxy/ai-gateway`).

**Where the announcement is already stale:** it says the repository "will move to
a new GitHub organization following this announcement." As of 2026-09-12 the move
has **already happened** and the redirects work — `github.com/envoyproxy/ai-gateway`
resolves to `github.com/theagentrouter/agent-router`, and
`aigateway.envoyproxy.io/docs/` to `theagentrouter.ai/docs/` (both HTTP 200 after
redirect). Use the new URLs; cite the old ones only as history.

## Architecture

From `site/docs/concepts/architecture/system-architecture.md`: the **control
plane** is the Kubernetes API server as config interface, the **AI Gateway
Controller** (this project) reconciling the AI CRDs, and the **Envoy Gateway
Controller** handling core proxy config and xDS — the AI controller also
fine-tunes xDS via Envoy Gateway's extension-server mechanism. The **data plane**
is **Envoy Proxy** plus an **External Processor** (`extproc`) doing the
AI-specific transformations, plus the **Rate Limit Service** for token-based
limiting. Binaries: `cmd/controller`, `cmd/extproc`, `cmd/aigw`.

The README's "Usage" section adds a **two-tier gateway pattern**: a **Tier One**
gateway as centralized entry (authentication, top-level routing, global rate
limiting) and a **Tier Two** gateway fronting a self-hosted model-serving cluster
with endpoint-picker support. Dependency floor for 1.1
(`release-notes/v1.1.0.md`): Go 1.26.4, Envoy Gateway v1.8.1, Envoy Proxy
v1.38.1, Gateway API v1.5.1, Gateway API Inference Extension v1.0.2, MCP Go SDK
v1.7.0.

## The API surface

Six CRDs in the `aigateway.envoyproxy.io` group (`api/v1alpha1/`, `api/v1beta1/`):
`AIGatewayRoute`, `AIServiceBackend`, `BackendSecurityPolicy`, `GatewayConfig`,
`MCPRoute`, `QuotaPolicy`.

⚠️ **The stability guarantee does not cover all six.** `release-notes/v1.0.0.md`
declares exactly five stable at `v1beta1` — `AIGatewayRoute`, `AIServiceBackend`,
`BackendSecurityPolicy`, `GatewayConfig`, `MCPRoute`. **`QuotaPolicy` exists only
at `v1alpha1`** (`api/v1alpha1/quota_policy.go`, no `api/v1beta1` counterpart;
the docs' examples use `aigateway.envoyproxy.io/v1alpha1`), so quota config is
the one surface that may move inside 1.x. Say "five stable CRDs plus an alpha
QuotaPolicy", never "the API is stable". The **`aigw` CLI is likewise
experimental** — `site/docs/cli/index.md` carries a warning box, *"The CLI is
experimental and currently under active development"* — which sits against the
announcement's framing of the one-command start as a headline feature; quoting
the second without the first over-claims. (A third-party guide describing `aigw`
and Kubernetes CRDs is correct on both counts: the announcement omitted them, and
the repo confirms them.)

## Surfaces

### Models / LLM routing

- **One OpenAI-compatible API across 16 providers** with cross-provider
  translation — Anthropic `/v1/messages` → OpenAI `/v1/chat/completions`,
  Anthropic Messages → Bedrock Converse/InvokeModel, covering streaming, tool
  use, reasoning blocks, and images. **Model virtualization** via
  `modelNameOverride` maps stable app-facing names onto provider models.
  Endpoints: chat, completions, embeddings, image generation, audio
  (`/v1/audio/transcriptions|translations|speech`), `/v1/responses`.
  (`release-notes/v1.0.0.md`)
- 1.1 added **token counting without generation** (a vLLM-compatible `/tokenize`,
  `/anthropic/v1/messages/count_tokens`, `/v1/responses/input_tokens`) plus
  `/anthropic/v1/models` (`release-notes/v1.1.0.md`).
- **Self-hosted inference is first-class**: InferencePool / Gateway API Inference
  Extension support, and the shipped `aigw` example stack targets **Ollama** and
  explicitly mentions driving it from **goose** (`cmd/aigw/README.md`).

### MCP

- `MCPRoute` multiplexes several MCP servers behind one endpoint, merging and
  filtering `tools/list` and routing `tools/call` by a backend-name prefix
  (`github__issue_read`). Transport is **streamable HTTP**; the docs claim full
  coverage of the 2025-06-18 MCP spec including prompts, resources,
  notifications, and server→client requests
  (`site/docs/capabilities/mcp/index.md`).
- **CEL-based per-tool authorization**, where `tools/list` applies the same rules
  as `tools/call`, so callers cannot discover tools they may not invoke
  (`release-notes/v1.0.0.md`). 1.1 added `MCPRoute.spec.hostnames` and a
  `backendSelector` CEL rule evaluated at session initialize, defaulting to Deny.
- Standalone MCP gateway from the CLI: `aigw run --mcp-config mcp-servers.json`
  (or `--mcp-json '…'`), consuming the **canonical `mcpServers` JSON** that Claude
  Desktop / Cursor / VS Code already use, with `headers` (`${VAR}` substitution,
  Bearer auto-extraction) and `includeTools` filtering, served at
  `http://localhost:1975/mcp` (`site/docs/cli/run.md`). Config `type` accepts only
  `http` / `streamable-http` variants — **stdio is not a documented type**, though
  `cmd/aigw/stdio2http.go` exists in the tree (behaviour **UNVERIFIED**, not
  covered by the CLI guide).

### A2A

**Not a surface.** No A2A support appears in the CRDs, the docs tree, or the
1.0/1.1 release notes; a repo-wide code search for `a2a` returns only four test
fixtures (HTTP cassettes and spans). This is the sharpest difference from
agentgateway and the claim most likely to be mis-stated by anyone assuming "AAIF
gateway ⇒ speaks A2A". If it changes it will show up as a CRD or a docs page.

### Observability, quota, and "cost"

- **OpenTelemetry tracing with OpenInference semantics**, compatible with LLM-eval
  tooling such as Arize Phoenix (`cmd/aigw/.env.otel.phoenix` wires it into the
  example stack); 1.1 adds `gen_ai.*` span attributes behind
  `AI_GATEWAY_TRACING_SEMCONV=gen_ai` and a Grafana dashboard at
  `examples/monitoring/grafana-dashboard.json` (release notes 1.0/1.1).
- **Prometheus GenAI metrics** — `gen_ai.client.token.usage`,
  `gen_ai.server.request.duration`, `…time_to_first_token`,
  `…time_per_output_token` — attributed by `gen_ai.original.model` /
  `request.model` / `response.model` / `provider.name`, with `session.id`
  deliberately excluded as high-cardinality
  (`site/docs/capabilities/observability/metrics.md`).
- **`QuotaPolicy` is token-denominated, not currency-denominated**: cumulative
  per-model token budgets, **CEL cost expressions** weighting input / output /
  cached / reasoning tokens differently, client-selector buckets for per-tenant
  carve-outs, shadow mode, `429` on exhaustion, Redis-backed via Envoy Gateway's
  rate-limit infrastructure (`site/docs/capabilities/traffic/quota-policy.md`).

⚠️ **Precision point:** the announcement says teams "see usage, cost, and latency
for every request". In the shipped product **"cost" is tokens**, computed by a CEL
expression — there is no provider price table or currency figure in the docs. Any
claim of "per-request dollar cost" without "you supply the prices" is wrong; same
discipline our `/agentgateway` skill applies.

### Authorization and credentials

`BackendSecurityPolicy` centralizes upstream credentials — API key, AWS, Azure,
GCP cloud-native identity incl. GKE Workload Identity via ADC — alongside
request/response **body redaction** (`release-notes/v1.0.0.md`). 1.1 adds
`credentialOverride`, the multi-tenant BYO-key primitive: a trusted filter
supplies the credential **per request** from Envoy dynamic metadata or a header
the gateway strips; plus `GatewayConfig.spec.forwardProxy` (HTTP CONNECT egress)
and `AIGatewayRouteRule.streamIdleTimeout`, which bounds a stalled stream and can
fail over before the first token (`release-notes/v1.1.0.md`).

## How it differs from agentgateway

Both are AAIF-hosted gateways fronting LLMs and MCP; the honest framing is
*different lineages solving an overlapping problem*, never "which one wins".
agentgateway facts below come from
`refs/projects/agentgateway-and-working-groups.md` (verified 2026-06-24 —
re-check before publishing anything comparative).

| | **Agent Router** | **agentgateway** |
|---|---|---|
| Data plane | **Envoy** (a separate, existing project) | its **own Rust proxy** |
| Implementation | Go control plane (`cmd/controller`, `cmd/extproc`) | Rust, single binary |
| Config surface | Kubernetes CRDs (`aigateway.envoyproxy.io`) + `aigw` + config file | YAML + Kubernetes |
| A2A | **none found** (see above) | a named A2A gateway surface |
| MCP | `MCPRoute` multiplexing, CEL per-tool authz, streamable HTTP | virtual MCP servers, stdio/HTTP/SSE/streamable, OpenAPI→MCP |
| Lineage | Envoy / Envoy Gateway community; Bloomberg + Tetrate, Oct 2024 | donated by Solo.io |
| AAIF status | joined **2026-09-09** | Growth-stage, TC-approved 2026-05-13 |

The one-line version for a talk or a post: **agentgateway replaces the proxy;
Agent Router configures one you probably already run.**

⚠️ **Name collision to disambiguate every time.** "Tetrate Agent Router Service
(TARS)" is a **separate commercial hosted service**, and one of the *provider
backends* Agent Router can route to
(`site/docs/getting-started/connect-providers/tars.md`). The Apache-2.0 AAIF
project is "Agent Router"; never let the two blur in our copy.

## What the project asks for

Named in the announcement's "Get involved": **quickstarts, error messages, the
standalone binary, docs**, and **proxy internals**, with usability stated as a
core project goal. The line worth pinning above any idea list: *"The most
valuable contribution is a production problem the community has not encountered
yet."*

Mechanics, from `CONTRIBUTING.md`: prereqs are a Go toolchain, `make`, `docker`,
everything behind make targets (`make precommit test` before opening a PR);
**tests required** for new main code paths; **DCO sign-off on every commit**
(`git commit -s`, real names only); during review **no squashing, force-pushing,
or rebasing** — use `git merge`, maintainers squash at merge.

**There is an explicit generative-AI policy**, close to this repo's own anti-slop
rule: AI assistance is allowed *if you fully understand the change*, can revise it
on request, and **disclose the AI usage in the PR description**; PRs the submitter
does not own, and AI-oriented code comments, are not allowed.

Entry-point reality check (2026-09-12): **0 open issues carry `good first issue`
and 0 carry `help wanted`**, though both labels exist — there is no curated
newcomer queue. The real ramps are docs (`area/site`, `documentation`), the
`area/*` taxonomy (`api`, `caching`, `controller`, `extproc`, `mcp`,
`observability`, `operations`, `quota`, `routing`, `security`, `site`,
`translation`), and the **design proposals** in `docs/proposals/NNN-<slug>/`
(13 directories numbered 001–012, two of them 012; e.g. `006-mcp-gateway`,
`009-quota-aware-routing`, `011-mcp-backend-crd`). The project is busy — 143 open
issues, 145 open PRs, 69 PRs merged and 71 commits in the 30 days to 2026-09-12 —
so a scoped PR gets read and a vague one is noise.

Roadmap: `theagentrouter.ai/docs/roadmap` **404s** and no public org project board
was discoverable, so the announcement's "review the roadmap" pointer is
**UNVERIFIED as a canonical URL**. The de-facto roadmap is the 1.0 notes' "What's
Next" — a dedicated `MCPBackend` CRD, deeper MCP authorization across
tools/resources/prompts, fuller quota-aware routing, more translation paths,
multimodal — plus the open proposals and the weekly meeting agenda.

## Community channels

- **Discord** — https://discord.gg/xuxtPq43gZ (README) and
  https://discord.gg/XvSqZZty7k (announcement). Not a contradiction: both invites
  resolve to the **same guild**, named "Agent Router" (identical guild id via the
  Discord invites API). Prefer the README's link.
- **Monday community meeting**, open to everyone, agenda in a public Google Doc
  linked from the README (reachable, HTTP 200). The announcement calls this "the
  easiest way to get involved" — it is where a production problem belongs.
- Site https://theagentrouter.ai · blog `/blog` · talks `/talks` · release notes
  `/release-notes/`

## Contribution surfaces for us

Ranked by what an agent-harness practitioner can do credibly and verifiably.
**None of these is in flight** — this brief keeps the option open, nothing more,
and nothing reaches an AAIF or Agent Router surface without Zig's explicit
go-ahead (repo hard rule).

1. **The standalone MCP-gateway path, exercised for real.** `aigw run
   --mcp-config` consumes the same `mcpServers` JSON our editors already use, so
   aggregating an existing MCP client stack behind one endpoint is a reproducible
   day's work — and aggregation + `includeTools` + per-tool CEL authz is exactly
   the tool-sprawl problem agent users have. Best ratio of real usage to words.
2. **A production problem, written up the way the project asked for it.**
   Anything we hit while running it — an unhelpful error message, a config that
   silently did nothing (the docs themselves warn a `perModelQuotas` entry whose
   `modelName` misses `modelNameOverride` is silently not applied) — is worth more
   than a tutorial, and belongs on the Monday agenda or an issue.
3. **Docs / quickstart PRs**, the ask stated verbatim in the announcement. The
   rename leaves a long tail of "Envoy AI Gateway" strings (`GOALS.md` and
   `CONTRIBUTING.md` still carry the old name); a scoped pass is a legitimate
   first PR. Small, named, DCO-signed.
4. **The goose tie-in.** The example stack already drives **Ollama** and mentions
   goose (`cmd/aigw/README.md`); "local model behind a router, driven by an AAIF
   agent" is a two-project story with our local-inference experience behind it.
5. **Observability content.** The OpenInference/Phoenix wiring and the `gen_ai.*`
   metric set are shipped and under-documented; a piece that *measures* something
   (token accounting, TTFT, quota burn-down) beats one that restates features.
6. **A design proposal** in `docs/proposals/` — the highest bar, and the last move
   here rather than the first.

## Submission mechanics

As of **2026-09-12** the AAIF Ambassador submission template has **no Agent
Router checkbox** — its project boxes are goose, MCP, AGENTS.md, agentgateway,
A2A, and "Other AAIF Project".

**Tick "Other AAIF Project" and name Agent Router in the Notes.** The automated
reviewer tags such a piece `other` and scores it at the **full rung** for its type
when the hosted project is named — observed once, a `blog_post` at **15**, the
rationale citing AAIF-hosted status; `other` is a dock only when there is no real
AAIF project behind the work. **Watch for a new checkbox** — a hosted project
usually gets one eventually, and `/aaif-radar` is what notices. Scoring rules and
the issue-body drafter live in `/aaif-review`, which is the authority on rungs,
not this brief.

## Watch-outs

- The project is **days into AAIF and mid-rename**: names, URLs, and org paths are
  the volatile part. Re-check the repo path and docs domain before publishing.
- **Do not call the whole API stable** — five CRDs at `v1beta1` are, `QuotaPolicy`
  at `v1alpha1` is not, and the `aigw` CLI is documented as experimental.
- **Do not attribute A2A support**; none was found. **Do not say dollars** when
  the product means tokens.
- Provider, adopter, issue/PR, and label counts above are point-in-time
  (2026-09-12) — re-derive before quoting, never relay.
- Keep any agentgateway comparison **descriptive and current**: our agentgateway
  facts date from 2026-06-24, and both projects move.

## Sources

- https://aaif.io/blog/agent-router-joins-aaif (join announcement, 2026-09-09) ·
  https://theagentrouter.ai/blog/envoy-ai-gateway-is-now-agent-router (companion
  technical post)
- https://github.com/theagentrouter/agent-router — `README.md`, `CONTRIBUTING.md`,
  `MAINTAINERS.md`, `GOALS.md`, `api/v1alpha1/`, `api/v1beta1/`,
  `cmd/aigw/README.md`, `docs/proposals/`, `examples/monitoring/`,
  `release-notes/v1.0.0.md`, `release-notes/v1.1.0.md`
- https://theagentrouter.ai/docs — `concepts/architecture/system-architecture.md`,
  `capabilities/mcp/index.md`, `capabilities/observability/metrics.md`,
  `capabilities/traffic/quota-policy.md`, `cli/index.md`, `cli/run.md`,
  `getting-started/connect-providers/tars.md`
- GitHub REST API (repo metadata, releases, labels, issue/PR/commit counts) and
  the Discord invites API, both 2026-09-12
- `refs/projects/agentgateway-and-working-groups.md` (comparison column only)
