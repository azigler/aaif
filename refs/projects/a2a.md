# A2A — contribution-surface brief

> **Newest AAIF project** — joined as a hosted project **2026-08-17**
> (https://aaif.io/blog/a2a-joins-aaif). The agent-to-agent interoperability layer of
> the AAIF stack (AGENTS.md = instructions · goose = runtime · MCP = agent-to-tool ·
> agentgateway = traffic/policy · A2A = agent-to-agent). Facts verified 2026-08-28.

## What it is
Open standard for inter-agent communication: discovery, delegation, and result-sharing
between agents built on different frameworks/vendors. Explicitly NOT an agent dev kit,
not a tool-call protocol, not an MCP replacement (their docs: complementary — MCP
connects agents to tools; A2A connects agents to agents).

## History & governance
- Launched by Google Apr 2025; donated to the Linux Foundation; IBM's Agent
  Communication Protocol merged into A2A Aug 2025; **v1.0 Mar 2026** (signed agent
  cards, multi-tenancy, version negotiation). Joined AAIF 2026-08-17.
- TSC reps: AWS, Cisco, Google, IBM Research, Microsoft, Salesforce, SAP, ServiceNow.
  150+ partner orgs incl. direct competitors. Apache-2.0. Normative source:
  `spec/a2a.proto`. SDKs: Python, JS, Java, C#/.NET, Go, Rust.

## Core model (from the v1.0 spec + topics docs)
- **AgentCard** — signed, cacheable JSON manifest: skills, capabilities, security
  schemes; fetched pre-interaction (well-known URI / curated registry / direct config).
- **Task** — stateful unit of work with a lifecycle state machine (SUBMITTED/WORKING/
  COMPLETED/FAILED/CANCELED/INPUT_REQUIRED/REJECTED/AUTH_REQUIRED); terminal tasks are
  IMMUTABLE — refinement = a new task in the same `contextId`. **No deadline/expiry
  field on Task** (only status timestamps).
- **Message vs Artifact discipline** — task outputs belong in Artifacts, not Messages.
- **Extensions** — `AgentExtension` declared in the card; formal extension + custom
  binding system with a tiered promotion process keeping the core stable; extensions
  can strongly type `metadata` values.
- Discovery holds only the STATIC leg (their own docs: no broadcast, runtime
  negotiation, or bidding; named as community future work).

## Contribution surface (for ambassador work)
- **Extensions** are the natural first-mover seam: new-to-AAIF project, formal
  extension mechanism, tiered promotion — a well-specified extension proposal (e.g.
  obligation/promise semantics: deadline, evidence-bearing completion, reason-bearing
  rejection) is high-leverage. See the 2026-09 anchor arc (bead aaif-i5a).
- Docs/tutorials: project is 11 days into AAIF — early-days content lane is open.
- Multi-language SDKs → runnable-sample lanes across 6 ecosystems.

## Watch-outs
- Very new to AAIF: check aaif.io + the repo for current status before claiming facts.
- Task lifecycle/discovery facts above are v1.0; the spec moves — re-verify at use.
