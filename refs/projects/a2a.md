# A2A — contribution surface brief

**Agent2Agent (A2A)** is the open standard for agent-to-agent interoperability: how independent agents discover each other, delegate tasks, and exchange results across frameworks, vendors, and organizational boundaries. Launched by Google in April 2025 and donated to the Linux Foundation, merged with IBM's Agent Communication Protocol in August 2025, stabilized at v1.0 in March 2026, and accepted as an **AAIF hosted project on 2026-08-17**. It is on this list because it completes the AAIF stack directly adjacent to the two surfaces this practice already knows best — agentgateway and MCP — and because it arrived with a stable spec but a visibly thin governance/observability tooling layer.

## What A2A is

A2A defines how one agent asks another agent to do work. The unit of discovery is the **Agent Card**: a JSON document at `https://{domain}/.well-known/agent-card.json` describing an agent's identity, provider, skills, endpoint interfaces, capabilities, and the security schemes needed to call it. Cards may be cryptographically signed (`AgentCardSignature`, with canonicalization + verification defined in the spec), and an authenticated **extended agent card** can expose additional skills to callers who have earned them. Discovery has three sanctioned shapes: the well-known URI, curated registries (the spec deliberately does **not** prescribe a registry API), and direct configuration.

The unit of work is the **Task**. A client calls `SendMessage` and gets back either a direct `Message` or a `Task` with a server-generated `id` and a `contextId`. Tasks move through `TASK_STATE_SUBMITTED` → `TASK_STATE_WORKING`, may pause at the interrupted states `TASK_STATE_INPUT_REQUIRED` or `TASK_STATE_AUTH_REQUIRED` (in-task authorization is a first-class concept), and terminate at `COMPLETED`, `FAILED`, `CANCELED`, or `REJECTED`. Messages carry `parts` (text, raw bytes, or file URL); durable outputs belong in `Artifact` objects — the spec is explicit that messages are *not* a reliable delivery channel for critical results. Clients track progress by polling `GetTask`, by streaming (`SendStreamingMessage` / `SubscribeToTask`, with mandatory ordered delivery and identical event sequences across concurrent streams), or by registering a webhook `PushNotificationConfig`.

Structurally, v1.0 is layered: a canonical data model defined normatively in `specification/a2a.proto`, a set of abstract operations, and then **three official protocol bindings** — JSON-RPC, gRPC, and HTTP+JSON/REST — which must be functionally equivalent, plus a governed path for custom bindings. Version negotiation rides an `A2A-Version` header (`Major.Minor`; empty means 0.3), extensions ride `A2A-Extensions`, and the media type `application/a2a+json` is registered. Auth uses OpenAPI-shaped scheme objects (API key, HTTP, OAuth2 with authorization-code/client-credentials/device-code flows, OpenID Connect, mutual TLS), with a stated rule that "not found" and "not authorized" must be indistinguishable to callers.

## Architecture & ecosystem

AAIF's own layer map places A2A at the top of five layers: **AGENTS.md** (instructions and context) → **goose** (agent runtime) → **MCP** (agent-to-tool connectivity) → **agentgateway** (traffic mediation, policy, observability) → **A2A** (agent-to-agent interoperability).

**A2A × MCP** — the two projects frame themselves as complementary, not competing. The A2A docs' formulation: *"A2A focuses on agents partnering on tasks, whereas MCP focuses on agents using capabilities."* MCP connects a reasoning engine down to tools with structured, often stateless inputs and outputs; A2A connects agents sideways for stateful, multi-turn, opaque collaboration. The canonical worked example is an auto repair shop where a Mechanic agent talks to a Shop Manager and a Parts Supplier over A2A while calling `scan_vehicle_for_error_codes(...)` over MCP. The AAIF project proposal restates this as **MCP = vertical integration layer, A2A = horizontal orchestration layer**. A single service is routinely both an MCP client and an A2A server; the docs also note a bridging pattern where an A2A server exposes some skills as MCP resources, with the caution that this forfeits A2A's stateful strengths.

**A2A × agentgateway** — this is the load-bearing intersection, and it is **already real, but asymmetric**. Agentgateway supports A2A today: marking a route with an empty `a2a: {}` policy block switches it into A2A mode, where the gateway rewrites the `url` field in the proxied agent card to point back at the gateway (so clients cannot bypass it on subsequent calls), parses the A2A method out of each request into an `a2a.method` log field, and applies the standard CORS/authn/authz/rate-limit policies to A2A traffic. Reading the source rather than the docs shows it goes further than documented: `crates/agentgateway/src/a2a/mod.rs` accepts **both** `/.well-known/agent.json` and `/.well-known/agent-card.json`, and parses responses into a `ResponseInfo` carrying `outcome`, `error_code`, `result_kind`, `task_state`, and `contextId` — handling both the flat v0.3 result shape and the nested v1.0 `oneof` shape. Those land on the log struct as `a2a_method` / `a2a_response`.

The asymmetry is in **policy**. Agentgateway's CEL attribute schema (`schema/cel.md`) exposes roughly 19 `mcp.*` attributes (`mcp.tool.name`, `mcp.tool.arguments`, `mcp.tool.result`, `mcp.sessionId`, `mcp.task.*`, …) and 58 `llm.*` attributes — and **zero `a2a.*` attributes**. The only A2A-aware handle a policy author has is `backend.protocol == 'a2a'`. So you can write "deny this tool call by name" for MCP, but you cannot yet write "deny delegation to this skill" or "alert on tasks terminating in `REJECTED`" for A2A, even though the proxy is already parsing exactly those fields for telemetry. That gap is small, well-shaped, and squarely in this practice's lane.

**A2A × goose** — no evidence of A2A support in goose was found. goose's protocol story is MCP for extensions plus **ACP (Agent Client Protocol)** for the client-facing interface, per its own roadmap discussions. Note the persistent naming collision: goose's "ACP" is Agent *Client* Protocol, a different thing from IBM's Agent *Communication* Protocol that merged **into** A2A in 2025. See Accuracy flags — this is the weakest-sourced claim in the brief.

## Maturity & current state (mid-2026)

Adoption is broad and the spec is deliberately quiet. Founding orgs were AWS, Cisco, Google, Microsoft, Salesforce, SAP, and ServiceNow; the project now cites 150+ partner organizations, including direct competitors — which is precisely the argument the announcement makes for neutral hosting. Named production deployments: Huawei (Celia ↔ in-app agents on HarmonyOS), Tencent WeChat (assistant-initiated messaging/calls with dual authorization), Google Cloud (ADK, Agent Engine, Cloud Run, GKE), Microsoft Azure AI Foundry, AWS Bedrock AgentCore, and the AP2 (Agent Payments Protocol) extension with PayPal for agentic commerce.

Release cadence tells the maturity story cleanly: rapid churn through 2025 (v0.2.2 through v0.3.0 between June and July 2025), then **v1.0.0 on 2026-03-12** and a single patch **v1.0.1 on 2026-05-28**. The AAIF project proposal states the roadmap priority is stability — "no significant or breaking changes are on the horizon." The published roadmap (last updated 2026-03-10) accordingly points at extensions, validation tooling, and *community-led development processes* rather than protocol features.

Repo activity (counts verified 2026-08-21): `a2aproject/A2A` at 25,443 stars / 236 open issues, pushed 2026-08-18, Apache-2.0. SDKs in six languages, all actively pushed within the last week or two: `a2a-python` (2,096★ / 74 issues), `a2a-js` (589★ / 69), `a2a-java` (475★ / 57), `a2a-go` (441★ / 22), `a2a-dotnet` (254★ / 51), `a2a-rs` (65★ / 22). Supporting repos: `a2a-samples` (1,740★ / **306 open issues** — the largest backlog in the org), `a2a-inspector` (472★, validation tooling), `a2a-tck` (48★, compatibility kit, last pushed 2026-06-29 — the least fresh), plus newer `a2a-cli`, `a2a-itk` (integration testing kit), and two experimental extension repos (`experimental-ext-oid4vp-auth`, `experimental-cpb-slimrpc`).

Governance under AAIF: the project proposal (`aaif/project-proposals#37`) is **closed and Approved at the "Growth" maturity tier**, with contribution agreement signed, Google LLC as contributing entity, and Alan Blount as Technical Committee Sponsor. Trademarks and accounts were agreed to be donated to AAIF. The repo carries `GOVERNANCE.md`, `MAINTAINERS.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, and a `.gitvote.yml` (automated maintainer voting). TSC meetings run on the LF Zoom platform; community chat is Discord.

## Contribution surface (concrete)

**Spec repo conventions.** Fork → feature branch → PR against `main`. Conventional Commits are enforced and load-bearing for releases: `docs(spec):` for `docs/specification.md` prose, but `feat:` / `fix:` are **reserved exclusively** for `specification/a2a.proto` changes because they trigger a protocol release. If a docs change affects protocol usage, you are asked to touch the `.proto` (even just a comment) so a release fires. Run `./scripts/format.sh` and `./scripts/lint.sh` before submitting. All PRs require review, including from project members. CONTRIBUTING.md does **not** mention DCO/CLA or an issues-first rule.

**The ADR process is nearly empty.** `adrs/` contains exactly one real ADR (`adr-001-protojson-serialization.md`) plus a template. For a v1.0 protocol with three bindings and a governed extension system, that is a lot of undocumented decision history — and a legitimate, high-value contribution shape for someone who reads specs carefully.

**Documentation gaps, verified.** `docs/tutorials/` contains only `index.md` and a `python/` directory — **six official SDKs, one tutorial language**. `docs/topics/` covers eleven subjects (a2a-and-mcp, agent-discovery, custom-protocol-bindings, enterprise-ready, extension-and-binding-governance, extensions, key-concepts, life-of-a-task, multi-tenancy, streaming-and-async, what-is-a2a) with no operations/observability topic at all — nothing on running A2A behind a gateway, on what a proxy can see, or on auditing delegation.

**Good-first-issue surface is thin, which cuts both ways.** Open GFI-labeled issues: `a2a-java` 5, everything else scanned at 0. "Help wanted": 1 each on `a2a-python` and `a2a-js`. `documentation`-labeled: 3 on the main A2A repo. There is no curated on-ramp — meaning the real openings are self-identified doc/tutorial/sample work and the 306-issue `a2a-samples` backlog, not a labeled queue.

**agentgateway-side surface (the strongest lane).** (a) The A2A docs page documents only `/.well-known/agent.json` — the pre-v0.3 path — while the code has handled `agent-card.json` all along; a docs PR fixing this is small and fully verifiable. (b) That same page documents only `a2a.method` and never mentions the `outcome` / `error_code` / `result_kind` / `task_state` / `contextId` response fields the proxy already parses. (c) No `a2a.*` CEL attributes exist, so A2A traffic cannot be governed at protocol granularity the way MCP traffic can.

**Working-group hooks.** AAIF runs seven working groups; A2A's arrival puts interoperability, security/identity (signed cards, in-task auth, mTLS), and observability questions on the table simultaneously. TSC meetings are open on LF Zoom, and the roadmap explicitly asks for help standardizing community contribution processes — an unusually open door for someone who wants to do governance-adjacent work rather than protocol design.

## 6 tailored submission ideas

1. **A2A-aware CEL attributes for agentgateway.** Propose (design issue first, then PR) an `a2a.*` attribute set — `a2a.method`, `a2a.task.state`, `a2a.contextId`, `a2a.skill`, `a2a.result.kind` — mirroring the existing `mcp.*` shape, so operators can write protocol-level authz over agent delegation instead of only `backend.protocol == 'a2a'`. The parsing already exists; this is plumbing it into the policy plane. *Ties: agentgateway + A2A. Format: upstream design issue → PR.*

2. **"What your gateway can see when agents talk to each other."** A runnable tutorial: two A2A agents, one agentgateway in front, walk the full delegation from card fetch through `message/stream` to a terminal task state, showing the actual log lines — and then name honestly where visibility and policy currently stop. This is the observability lane applied to a layer nobody has written up yet. *Ties: agentgateway + A2A. Format: tutorial/blog + sample repo.*

3. **agentgateway A2A docs PR: well-known path + telemetry field reference.** Correct the `/.well-known/agent.json` reference to cover both paths as the code does, and add a table of the A2A fields the proxy extracts. Small, mechanical, high-verifiability, immediately useful to anyone instrumenting A2A. *Ties: agentgateway. Format: docs PR.*

4. **A non-Python SDK tutorial, upstream to `a2aproject/A2A`.** Build the JS or Go equivalent of the existing Python tutorial (agent card → skills → task lifecycle → streaming), matching the established structure so it slots into `docs/tutorials/`. Six SDKs and one tutorial language is a gap the project has stated it wants closed. *Ties: A2A. Format: docs PR (+ sample).*

5. **AGENTS.md and the agent card: two audiences, one capability story.** A pattern piece on keeping what a repo tells *coding agents* (AGENTS.md) coherent with what a deployed service tells *peer agents* (the agent card) — including a skill/recipe that generates or lints one against the other. Natural fit for the public-agents surface. *Ties: AGENTS.md + A2A (+ public-agents). Format: blog + skill/recipe PR.*

6. **Where a capability should live: MCP tool or A2A skill?** A decision guide grounded in a single working service that exposes both, with a traced request through agentgateway showing what each choice costs in observability, statefulness, and policy granularity. Turns the projects' own "complementary layers" framing into something an engineer can actually apply. *Ties: MCP + A2A + agentgateway. Format: tutorial/blog + PR to `a2a-samples`.*

## Accuracy flags

- **goose × A2A is the weakest claim here.** "No A2A support; MCP for extensions + ACP for the client interface" comes from web-search summaries of goose roadmap discussions (notably discussion #7309 on ACP), **not** from reading the goose repo directly. Treat as *no evidence found*, not *confirmed absent*. Verify before publishing anything that depends on it.
- **Whether agentgateway's A2A response fields reach the default access log is unverified.** `a2a_method` and `a2a_response` are confirmed present on the logging struct in `telemetry/log.rs`, but the emitted field names and whether they appear in the default JSON access log (vs. requiring explicit config) were not confirmed. Idea #3 depends on this — run it locally first.
- **Good-first-issue counts for `a2a-itk` and `a2a-cli` were not measured** (GitHub API rate limit hit mid-scan). All other label counts in this brief were measured.
- **AAIF's own project page for A2A carries no stage, governance, TSC, or maintainer detail.** The "Growth" maturity tier, the Approved status, and the Alan Blount sponsorship all come from the `aaif/project-proposals#37` issue, not from aaif.io.
- **TSC meeting cadence, agenda, and openness were not verified** — the LF Zoom link was not fetched. Discord activity level likewise unverified.
- **`a2a-inspector` and `a2a-tck` capabilities were not exercised.** Repo existence, stars, and last-push dates are verified; what they actually validate is not.
- **A2A partner count (150+) and the named production deployments** are as stated by AAIF and the project proposal; not independently confirmed against the named companies' own documentation.
- The **`agent.json` vs `agent-card.json`** split is confirmed from two directions (the A2A discovery docs say `agent-card.json` for v1.0; the agentgateway source comment says `agent-card.json: v0.3.0+`, `agent.json: older versions`), but **no formal deprecation notice for the old path was found** in the A2A docs.

## Sources

https://aaif.io/blog/a2a-joins-aaif
https://aaif.io/projects/agent2agent
https://github.com/aaif/project-proposals/issues/37
https://a2a-protocol.org/latest/
https://a2a-protocol.org/latest/specification/
https://a2a-protocol.org/latest/topics/a2a-and-mcp/
https://a2a-protocol.org/latest/topics/agent-discovery/
https://a2a-protocol.org/latest/roadmap/
https://github.com/a2aproject
https://github.com/a2aproject/A2A
https://raw.githubusercontent.com/a2aproject/A2A/main/CONTRIBUTING.md
https://github.com/agentgateway/agentgateway
https://agentgateway.dev/docs/standalone/latest/agent/a2a/
https://github.com/agentgateway/agentgateway/blob/main/crates/agentgateway/src/a2a/mod.rs
https://github.com/agentgateway/agentgateway/blob/main/schema/cel.md
https://github.com/aaif-goose/goose/discussions/7309
https://discord.com/invite/a2aprotocol
https://zoom-lfx.platform.linuxfoundation.org/meetings/agent2agent
