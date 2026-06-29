# AAIF — Agentic AI Foundation (overview)

> Reference doc. What AAIF is, who runs it, what it hosts, and where the
> contribution surfaces are. Source for the harness's understanding of the
> ecosystem. Last verified 2026-06-24.

## What it is

The **Agentic AI Foundation (AAIF)** is "an open and neutral home for critical
AI standards, protocols, and open source projects such as MCP, Goose,
AGENTS.md, and other projects that help developers build with agents."

- **Hosted by The Linux Foundation.**
- Tagline: *"Advancing · Developing · Growing Agentic AI Together."*
- Mission framing (homepage): "the neutral and open foundation built on
  transparency, collaboration, and standardization to advance the public
  interest in agentic AI innovation."
- Press framing: "a neutral, open foundation to ensure [agentic AI] evolves
  transparently, collaboratively, and in ways that advance the adoption of
  leading open source AI projects."
- The throughline: as AI moves from passive chatbots to proactive agents, AAIF
  exists to keep that shift on **open standards** — avoiding fragmentation and
  vendor lock-in, enabling agents to work across tools and environments without
  constant rewiring.
- Values (from the Ambassador Handbook): *"Our work is rooted in openness,
  neutrality, interoperability, and practical developer enablement. We are not
  here to hype agents as magic."*

## Founding contributions (the seed projects)

Three flagship projects were contributed by their originators when AAIF formed:

| Project | Contributed by | One-liner |
|---|---|---|
| **Model Context Protocol (MCP)** | Anthropic | Open protocol connecting LLM apps to external data, tools, and applications. |
| **goose** | Block | Open-source, extensible, local-first AI agent (install/run/edit/test with any LLM). |
| **AGENTS.md** | OpenAI | Universal standard giving AI coding agents project-specific guidance (a markdown file at repo root; read by 20+ agents, adopted by 60k+ repos). |
| **agentgateway** | (proposed/added) | Unified high-performance gateway for agentic AI, MCP, LLM, and service traffic. |

These four are the **current submission options** for ambassador contributions
(plus "Other AAIF Project — we'll be adding more often").

## Membership (signal of seriousness)

- **Platinum**: AWS, Anthropic, Block, Bloomberg, Cloudflare, Google,
  Microsoft, OpenAI.
- **Gold**: Adyen, Arcade.dev, Cisco, Datadog, Docker, Ericsson, IBM,
  JetBrains, Okta, Oracle, Runlayer, Salesforce, SAP, Shopify, Snowflake,
  Temporal, Tetrate, Twilio.
- **Silver**: ~21 more, incl. Hugging Face, Pydantic.
- Named LF leadership: Jim Zemlin (Executive Director, Linux Foundation).

## GitHub org — github.com/aaif

Beyond the four projects, the org hosts governance + community + landscape repos
and **seven working groups**:

**Working groups** (each a GitHub repo `wg-*`):
- `wg-observability-and-traceability`
- `wg-security-and-privacy`
- `wg-accuracy-and-reliability`
- `wg-workflows-and-process-integration`
- `wg-agentic-commerce`
- `wg-identity-and-trust`
- `wg-governance-risk-and-regulatory`

**Governance / community:**
- `technical-committee` — the TC (technical governing body), Apache-2.0
- `project-proposals` — propose a project to the TC
- `working-group-proposals` — propose a new WG
- `.github` — org profile / community health (has a `.gitvote.yml` — the org
  uses GitVote for decisions)
- `foundation` — foundation-level resources

**Landscape / agents:**
- `aaif-landscape` — ecosystem mapping (topics: mcp, landscape, aaif)
- `public-agents` — **"Reusable agents and agent scaffolding for the AAIF"**
  (MIT). Dirs: `skills/`, `recipes/`, `prompts/`, `docs/`. ← direct contribution
  surface for a harness author.
- `ws-taxonomy-landscape` — taxonomy/landscape docs

> goose's code also lives under `aaif-goose` / `block` orgs (it moved to AAIF in
> 2026). MCP lives under the `modelcontextprotocol` org. Per-project repo maps
> are in `refs/projects/`.

## Community channels

- **Discord** (public): https://discord.com/invite/9zTwngHAMy
- Private **Ambassador Discord channel** (link in the handbook; ambassadors only)
- GitHub: https://github.com/aaif
- Social: X/Twitter **@AgenticAIFdn**, LinkedIn "Agentic AI Foundation",
  Bluesky **@aaif.io**, YouTube, LinkedIn "Daily Agentic AI" newsletter
- Ambassador contact: **ambassadors@aaif.io**
- Conference: **AGNTCon** (Tokyo, Amsterdam, San Jose — ambassador perks apply)

## Why this matters for Andrew

AAIF is the standards body for exactly the substrate Andrew already lives in:
agent-guidance files (AGENTS.md / CLAUDE.md), MCP servers, agent frameworks,
and agent gateways (his own self-hosted gateway). His harness *is* a working instance of the
patterns AAIF is trying to standardize and teach. That overlap is the engine of
high-quality, credible ambassador contributions — see
`refs/program/strategy-top-ambassador.md`.

## Sources

- https://aaif.io/ · https://aaif.io/ambassadors/ · https://aaif.io/projects/ · https://aaif.io/members/
- https://aaif.io/blog/we-planned-for-10-ambassadors-were-welcoming-138/
- https://aaif.io/blog/were-building-a-squad-of-agentic-ai-advocates-join-the-aaif-ambassador-program/
- https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation
- https://github.com/aaif · https://github.com/orgs/aaif/repositories
- AAIF Ambassador Handbook (held privately in `.local/`; distilled into `refs/program/`)
