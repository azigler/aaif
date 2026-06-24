# agentgateway + AAIF working groups — contribution surface brief

> Researched 2026-06-24 against official AAIF / agentgateway / Solo.io sources.
> Verified facts only; flags at the end. Two contribution surfaces in one doc:
> the agentgateway project + the 7 working groups (+ aaif-landscape).

## What agentgateway is

An open-source, **AI-native proxy/gateway**: one high-performance Rust data
plane handling traditional service traffic (HTTP, gRPC) *and* agentic protocols
(MCP, A2A) *and* LLM inference — instead of bolting an "AI gateway" onto a
separate stack. Drop-in **security, observability, governance** for
agent↔LLM, agent↔tool, agent↔agent traffic, anywhere (bare metal → k8s).

Three logical gateways over one proxy:
- **LLM Gateway** — one OpenAI-compatible API to 13+ providers (OpenAI,
  Anthropic, Gemini, Bedrock, Azure…) with budget/spend controls, prompt
  enrichment, load balancing, failover, virtual models. **Also routes to
  self-hosted/local models** (Ollama, LM Studio, vLLM, llama.cpp).
- **MCP Gateway** — federates tools/data over MCP with **virtual MCP servers**
  multiplexing multiple backends into one endpoint; stdio/HTTP/SSE/Streamable
  transports, OpenAPI→MCP, OAuth. Deepest MCP support in the space.
- **A2A Gateway** — agent-to-agent traffic: capability discovery, modality
  negotiation, task collaboration.

Cross-cutting: guardrails (regex, OpenAI moderation, Bedrock, Google Model
Armor), **JWT/API-key auth + RBAC via a CEL policy engine** (incl. MCP
tool-poisoning protection), rate limiting, TLS, **OpenTelemetry**, AI cost
analysis, and a built-in **UI / self-service developer portal** (v1.3.0+).

**Provenance:** Apache-2.0, **Rust**, created+donated by **Solo.io**; AAIF
**Growth-stage** project (proposal #11; TC-approved 2026-05-13, GB-approved
2026-05-21). 250+ contributors/50+ orgs; Microsoft moving toward maintainership.
Adopters incl. Microsoft, Adobe, Apple, T-Mobile, Expedia, Zalando, Swissquote.
Current line **v1.3.x**.

> ⚠️ **Repo lives in its OWN org, NOT under `aaif`:**
> https://github.com/agentgateway/agentgateway · docs https://agentgateway.dev/docs/
> · AAIF page https://aaif.io/projects/agentgateway/

## agentgateway contribution surface

Two shapes, one Rust data plane: **standalone** (single binary + YAML —
the local/dev/VPS shape, relevant to a self-hoster) and **Kubernetes** (split
control/data plane, Gateway-API conformant, xDS hot reload).

Relationship to the ecosystem: Solo's purpose-built AI data plane; Solo is
**replacing kgateway's (Envoy-based) AI data plane with agentgateway** — so
kgateway (CNCF Sandbox) can drive agentgateway as its AI data plane. (Solo.io +
Tetrate merged 2025.)

Where to land work:
- **Code (Rust)** — data plane, new LLM providers, MCP transport/federation
  edge cases, guardrail backends, policy/CEL, telemetry. OpenSSF-badged process.
- **Provider cookbook / docs** — https://agentgateway.dev/models/ — new provider
  recipes + config walkthroughs are low-friction PRs.
- **Config recipes & examples** — local-model + hybrid routing YAML are
  under-documented relative to demand.
- **Ecosystem content** — blog, demos, interop reports; the project welcomes
  external write-ups (it publishes design deep-dives itself).

## The 7 AAIF working groups

All under https://github.com/orgs/aaif/repositories. Each: chaired by a platinum
member + co-chair, **biweekly** calls, **meetings currently member-only**
(sign-up via Google Form w/ business email; private list + Discord per WG; notes
in Google Docs; recordings on LFX). Repos hold `charter/`, `meeting-notes/`,
deliverables — **artifacts are public on GitHub even though live calls are
member-gated.** Chair terms: 2026-03-01 → 2027-01-31.

| WG (repo) | Charter (one line) | Chair / Co-chair | Activity |
|---|---|---|---|
| **wg-observability-and-traceability** | Observable/explainable/traceable agent behavior — tracing, correlation, audit, standardized metrics | Pavan Sudheendra (Cisco) / Matthew Lee (Datadog) | early-stage (~10 commits) |
| **wg-security-and-privacy** | Threat models, taxonomies, design patterns, adversarial testing, security-by-design | Alex Frazer (Runlayer) / Junjie Bu (Google) | **most active** (~29 commits) |
| **wg-accuracy-and-reliability** | Reliability/accuracy/consistency for autonomous systems | Jordan Augé (Cisco) / Casper Nielsen (Diagrid) | active |
| **wg-workflows-and-process-integration** | Agents as roles in multi-step business processes — handoff protocols, state guarantees | Yaron Schneider (Diagrid) / Adam Seligman (Workato) | — |
| **wg-agentic-commerce** | Discovery, negotiation, payment authorization for agents | Ilya Grigorik (Shopify) / Rahul Bansal (OpenAI) | — |
| **wg-identity-and-trust** | Portable identity + dynamic trust — delegation, cross-domain identity | Grant Miller (IBM) / Alper Dedeoğlu (SAP) | — |
| **wg-governance-risk-and-regulatory** | Risk classification, regulatory mapping (EU AI Act) | Ryan Hagemann (IBM) / Deborah Eng (JPMorgan) | — |

> As an inaugural Ambassador the membership gate is likely satisfied/waivable —
> confirm with `support@aaif.io`. To volunteer, email the chairs/co-chairs.

### Best-fit shortlist (ranked for Andrew)

1. **wg-observability-and-traceability — strongest fit.** He *already built* an
   observability layer for an agent fleet (tmux lexicon, pulse heartbeats,
   hooks, beads). Exactly this WG's subject, and it's **early-stage** — a
   practitioner with a working, opinionated tracing practice can shape the
   foundational taxonomy, not just review it. Highest leverage-to-effort.
2. **wg-security-and-privacy — second, most active.** Maps to his
   egress-allowlist + sandboxing hardening on a self-hosted gateway + browser-automation
   security work. Producing threat models/patterns *now* → real artifact work.
3. **wg-accuracy-and-reliability — credible third.** His pulse + bead-tracked,
   verification-gated harness is a reliability discipline for autonomous agents.

(Commerce/identity/workflows/governance are weaker fits; identity-and-trust is
the only adjacent one via auth/RBAC, but enterprise-IAM-flavored.)

## aaif-landscape

https://github.com/aaif/aaif-landscape — curated interactive ecosystem map
(CNCF **landscape2** generator) published at https://landscape.aaif.io.
JavaScript, regenerates daily after merge — genuinely contributable. Path: PR
editing `landscape.yml` (alphabetical) + an SVG logo in `hosted_logos/` + one
category + inclusion bar (~1,000+ stars, OSS, fits a category). Contact
`support@aaif.io`. Sibling repo `ws-taxonomy-landscape` also exists.

## 6 tailored submission ideas

1. **"agentgateway in front of your laptop's brain: routing Claude *and*
   qwen3-coder through one OpenAI-compatible endpoint"** — blog + tutorial repo.
   Local-model provider + virtual models + cloud→local failover with budget
   caps on a real Mac Studio. Rare hybrid frontier+local recipe. Edge: a local-model box +
   Ollama + qwen3-coder-30b.
2. **"Hardening an agent gateway on a VPS: egress allowlists, RBAC/CEL,
   tool-poisoning defenses"** — blog/tutorial + **wg-security-and-privacy**
   deliverable. Maps agentgateway RBAC/CEL + MCP tool-poisoning onto his a self-hosted gateway
   egress work. Doubles as a WG design-pattern contribution.
3. **"Observability for an agent fleet: from OpenTelemetry traces to a
   glanceable status lexicon"** — talk/video + **wg-observability-and-traceability**.
   agentgateway OTel as the data source; his tmux-lexicon/pulse/beads as the
   human layer. The practitioner UX perspective the early-stage WG lacks.
   **Highest-payoff dual-purpose piece.**
4. **"Building a virtual MCP server: federating your own tools behind
   agentgateway"** — tutorial + cookbook PR. MCP multiplexing (the project's
   deepest differentiator) + his MCP-server experience.
5. **"Put your stack on the map: contributing to the AAIF landscape"** — blog +
   `aaif-landscape` PR. Lowest-friction first contribution producing a durable
   public artifact + a "how to get involved" on-ramp for others.
6. **"The harness *is* the gateway: governing AI-in-the-SDLC traffic with
   agentgateway"** — Dev Interrupted talk / LinkedIn long-form (Zig-voice).
   Budget/guardrails/observability reframed for dev-intelligence buyers; ties
   AAIF's governance story to LinearB's AI-for-SDLC thesis. Edge: his audience.

## Accuracy flags

- agentgateway is hosted at `agentgateway/agentgateway`, **not** `aaif/agentgateway`.
- WG live meetings are **member-only**; the public surface is the GitHub repos
  (charters, notes, deliverables). Confirm access with `support@aaif.io`.

## Sources

- https://github.com/agentgateway/agentgateway · https://agentgateway.dev/docs/ · https://agentgateway.dev/models/
- https://agentgateway.dev/blog/2026-06-04-designing-agentgateway-unified-gateway/
- https://aaif.io/projects/agentgateway/ · https://github.com/aaif/project-proposals/issues/11
- https://aaif.io/working-groups/ · https://github.com/orgs/aaif/repositories
- https://github.com/aaif/aaif-landscape · https://landscape.aaif.io/
- https://www.solo.io/blog/agentgateway-joins-aaif-as-an-open-gateway-for-agentic-ai-infrastructure
