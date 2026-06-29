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

> 🔑 **The two-layer access model (deepened 2026-06-29 — this is the key
> contribution finding).** There is a real tension between the WG *charters* and
> the WG *repo READMEs / TC policy*:
> - **Charters (open):** every WG charter says verbatim *"Participation is open
>   to all individuals and organizations consistent with foundation policies"*
>   and defines a **Participant → Contributor → Maintainer/Approver → Chair**
>   ladder where a **Contributor** = *"anyone making substantive contributions
>   through issues, pull requests, documentation, or reviews,"* gated only by a
>   **DCO sign-off** (docs CC-BY-4.0, code Apache-2.0/MIT). Merge needs 1
>   Maintainer (chair) approval; decisions by rough consensus.
> - **Repo READMEs + `technical-committee` repo (gated):** *"Working Group
>   Meetings are only open to AAIF members at this time. Participants must be
>   invited to join."* Zoom links, LFX recordings, Discord, private mailing list
>   sit behind a member-org-email Google Form. **Two READMEs (Accuracy,
>   Governance) go further** and state *"Non-members cannot directly contribute
>   via PR or attend meetings"* — which **contradicts their own charters.**
> - **Net for an ambassador (individual, not necessarily member-org):** the
>   *async GitHub deliverable layer* (issues/PRs under DCO) is charter-open; the
>   *synchronous layer* (meetings/recordings/Discord) is member-gated. A WG
>   deliverable PR is exactly the kind of public, project-tied artifact the
>   monthly ambassador requirement wants. **First action: get a chair or
>   `support@aaif.io` to rule on whether async PR co-authorship is open to a
>   non-member ambassador, leading with the charter language.** (The
>   charter-vs-README contradiction on Accuracy/Governance is the single thing to
>   make them resolve. Also unconfirmed: whether a WG PR explicitly *counts*
>   toward the monthly ambassador floor — the ambassador pages list
>   tutorials/talks/blogs/videos/courses, not WG deliverables.)
> - **Associate membership escape hatch:** the `aaif/foundation` charter lists an
>   **Associate tier that is free for nonprofits / academia / government** — a
>   possible route to a qualifying business email if the member-gate proves hard.

| WG (repo) | Cadence (PT) | Chair / Co-chair | Deliverables in flight | Activity (2026-06-29) |
|---|---|---|---|---|
| **wg-security-and-privacy** | biweekly **Tue 10:00** | Alex Frazer (Runlayer) / **Junjie Bu (Google)** ⚠️ | **5 workstreams**: taxonomy, threat-modeling, design-patterns, best-practices, review-checklist. Flagship = *Agentic AI Threat Modeling: Gap Analysis & Framework Design* (leads **Alon Mazor / Fernando Lucktemberg**), vs CSA MAESTRO/OWASP/NIST AI RMF | 29 commits, 1 issue; most-structured |
| **wg-accuracy-and-reliability** | biweekly **Tue 09:00** | Jordan Augé (Cisco) / Casper Nielsen (Diagrid, `CasperGN`) | 3-phase: taxonomy → *Agent Output Quality Standard* + best-practices → conformance suite + benchmark leaderboard + reference impl (most spec/benchmark/code-heavy charter) | **~44 commits** ⚠️ (freshest repo); 1 PR |
| **wg-observability-and-traceability** | biweekly **Wed 10:00** | Pavan Sudheendra (Cisco) / Matthew Lee (Datadog, `mr-lee`) | **7 dated deliverables** incl. taxonomy v1, use-case inventory, *Agent Behavior Trace Model* (Oct '26), **"Agentic Observability Best Practices" white paper (Jan '27)** | ~11 commits but **6 issues / 4 live PRs, several `help wanted`** — highest open-collab surface |
| **wg-governance-risk-and-regulatory** | biweekly **Thu 10:00** (charter says weekly ⚠️) | Ryan Hagemann (IBM) / Deborah Eng (JPMorgan) | 3 phases: landscape → gap analysis → risk-classification schema + **"AI Agent Bill of Materials" (AI-BOM)**; EU AI Act / NIST mapping. **No in-repo drafts yet** (Google Doc stage) | 20 commits, 0 issues; thinnest/slowest |
| **wg-workflows-and-process-integration** | — | Yaron Schneider (Diagrid) / Adam Seligman (Workato) | handoff protocols, state guarantees | — |
| **wg-agentic-commerce** | — | Ilya Grigorik (Shopify) / Rahul Bansal (OpenAI) | discovery/negotiation/payment authz | — |
| **wg-identity-and-trust** | — | Grant Miller (IBM) / Alper Dedeoğlu (SAP) | portable identity, delegation, cross-domain trust | — |

> ⚠️ **Conflicts to verify:** two research passes disagreed on the security
> co-chair (**Junjie Bu/Google** vs **Jonathan Bregler/SAP**) and the accuracy
> commit count (~10 vs ~44). Governance cadence: README says biweekly Thu, charter
> says weekly. Treat these as unconfirmed; check the live charters before relying.

> **Cross-WG target — `ws-taxonomy-landscape`** (NOT one of the 7 WGs; a
> cross-cutting workstream): the busiest repo in the org (~83 commits, has a real
> `CONTRIBUTING.md`, all 7 WGs participate). Security's taxonomy moved here
> 2026-06-22. Builds an interactive taxonomy dashboard + the ecosystem landscape.
> Chairs **Junjie Bu (Google) / Gala Malbasic (Bloomberg)**. One PR target that
> touches every WG at once — strong if you want maximal cross-cutting credit.

### Best-fit shortlist (ranked for THIS ambassador — academic/security/governance lean)

1. **wg-security-and-privacy — strongest fit + most mature.** Maps directly to his
   MCP tool-poisoning, egress-allowlist, self-hosted-gateway hardening, and supply-chain /
   tools-manifest-verification depth. The threat-modeling workstream is a live
   gap-analysis against CSA MAESTRO/OWASP/NIST — exactly his lane, with named
   workstream leads to join (not just chairs). Design Patterns Catalog + Best
   Practices Guide both due Oct '26 → real co-authorship windows. **Highest
   credibility-to-effort.**
2. **wg-observability-and-traceability — strongest *fast-visible* co-authorship.**
   He built fleet observability (tmux lexicon, pulse, beads, OTel-shaped traces).
   This WG has the most open-collaboration surface *right now* (4 draft PRs, 6
   issues, `help wanted` tags) and a **white paper deliverable (Jan '27)** — a
   genuine co-authorship target, not just a spec. Pick up an issue (#8/#9/#10) or
   comment on a live doc PR. Early enough to shape the foundational trace model.
3. **wg-governance-risk-and-regulatory — ground-floor.** His governance practice
   (verification gates, audit trails, the AI-BOM idea ≈ his MCP server-provenance
   work). Nothing drafted in-repo yet → author foundational AI-BOM / risk-class
   content from scratch. Slowest-moving, but the most open canvas.
4. **wg-accuracy-and-reliability — credible.** His pulse + bead-tracked,
   verification-gated harness is a reliability discipline; the *Agent Output
   Quality Standard* + conformance suite map to his `/scrutinize` gate. Freshest
   repo, most spec/benchmark-heavy charter, most explicit "non-members may PR"
   clause.

(Commerce/identity/workflows are weaker fits; identity-and-trust is the only
adjacent one via auth/RBAC, but enterprise-IAM-flavored.)

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
   caps on a real local-model box. Rare hybrid frontier+local recipe. Edge: local models +
   Ollama + qwen3-coder-30b.
2. **"Hardening an agent gateway on a VPS: egress allowlists, RBAC/CEL,
   tool-poisoning defenses"** — blog/tutorial + **wg-security-and-privacy**
   deliverable. Maps agentgateway RBAC/CEL + MCP tool-poisoning onto a self-hosted gateway's
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
