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
   + video. A self-hosted gateway is the perfect non-Cloudflare target. Points 20.
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

---

# MCP 2026-07-28 deep brief — the stateless release

> Extended 2026-06-29 from official sources (blog.modelcontextprotocol.io RC
> post, the `draft` changelog, SEP-2567 Final text, the feature-lifecycle +
> deprecated-registry + sdk-tiers + extensions pages). This section EXTENDS the
> brief above — it does not repeat it. It grounds real technical writing + demo
> work on the biggest MCP architectural change since launch.
>
> **One framing note up front:** I group the changes below into three themes —
> Migration & Breaking, Optimization & Advanced Ops, Governance & Strategy — as a
> reader aid. The *spec itself* does NOT use those labels — the RC post groups by
> Stateless Core / Extensions Framework / Authorization Hardening / Deprecation
> Policy / JSON Schema. The three-theme split here is editorial; don't attribute
> it to modelcontextprotocol.io.

## The headline, stated precisely

The `2026-07-28` revision makes MCP **stateless at the protocol layer**. It is
a **breaking change** (the RC post: *"This release contains breaking changes.
We don't intend for that to be the norm"*). RC text **locked 2026-05-21**;
**finalizes 2026-07-28**; the ~10-week window is for SDK maintainers + client
implementers to validate against real workloads. Spec text can still shift on
blocking issues, but **the architectural shape is final**.

Crucial nuance the hype misses: the *mechanical* blast radius is small. SEP-2567's
own 1000-repo survey found **90.0% of open-source servers have no app-level
reference to the session ID at all**; only **~3.7%** (the "session-keyed app
state" 2.5% + "sticky-routing gateway" 0.7% + "auth-binding" 0.5% rows) need a
*designed* migration. The takeaway is less "everyone rewrite" and more
"the 4% who must, plus everyone who should adopt the new ergonomics."

---

## TRACK A — Migration & Breaking Changes (most urgent)

### A1. Stateless core — two complementary SEPs

- **SEP-2575 (Remove the `initialize` handshake).** No more
  `initialize`/`notifications/initialized`. Every request now carries protocol
  version, client identity, and client capabilities in `_meta`:
  `io.modelcontextprotocol/protocolVersion`,
  `io.modelcontextprotocol/clientInfo`,
  `io.modelcontextprotocol/clientCapabilities`. Version mismatch →
  `UnsupportedProtocolVersionError`.
- **SEP-2567 (Remove `Mcp-Session-Id` / sessions).** Drops the
  `Mcp-Session-Id` header and the entire protocol-level session concept. List
  endpoints (`tools/list`, `resources/list`, `prompts/list`) **no longer vary
  per-connection**. Status: **Final** (authored by Peter Alexander, Anthropic).
- **Net effect:** any request can land on any server instance — no sticky
  routing, no shared session store at the protocol layer. A remote MCP server
  can sit behind a plain round-robin load balancer.

### A2. The Explicit-Handle Pattern (the migration linchpin) — see deep section below.

### A3. Server-to-client requests restructured (this breaks Sampling/Elicitation/Roots round-trips)

- **SEP-2322 (Multi Round-Trip Requests, "MRTR").** Replaces *server-initiated*
  requests (`roots/list`, `sampling/createMessage`, `elicitation/create`) —
  which needed a session to correlate the in-flight tool call with the eventual
  response. Now a server returns an **`InputRequiredResult`** with
  `resultType: "input_required"` and an `inputRequests` field carrying what it
  needs; the **client re-issues the original call** with `inputResponses` plus
  any echoed `requestState` the server encoded. Because all correlation state
  rides the payload, **any replica can process the retry**.
- **New required `resultType` on ALL results:** `"complete"` (ordinary) or
  `"input_required"` (interim). Clients **MUST** treat older servers that omit
  the field as `"complete"`.
- Consequences: `notifications/elicitation/complete` and the URL-mode
  `elicitationId` field (both new in 2025-11-25) are **removed** — servers now
  self-encode any correlation ID in `requestState`.

### A4. Notifications & streaming reshaped

- The HTTP **GET endpoint** and `resources/subscribe`/`resources/unsubscribe`
  are replaced by a single **`subscriptions/listen`** long-lived POST-response
  stream. Clients opt into types (`toolsListChanged`, `promptsListChanged`,
  `resourcesListChanged`, `resourceSubscriptions`); server tags notifications
  with `io.modelcontextprotocol/subscriptionId`. (Note: the changelog also
  references `messages/listen`/`subscriptions/listen` naming across SEP-2575 —
  cite the changelog verbatim when precision matters; the WG was still settling
  the exact method name during RC.)
- **SSE stream resumability removed**: no more `Last-Event-ID` / SSE event-ID
  redelivery. A broken stream loses the in-flight request; the client **MUST**
  re-issue it as a new request with a new ID.
- **`ping`, `logging/setLevel`, `notifications/roots/list_changed` removed.**
  Log level is now per-request via `io.modelcontextprotocol/logLevel` in
  `_meta`; servers **MUST NOT** emit `notifications/message` for a request that
  didn't include it.

### A5. Tasks moved to an official extension + redesigned (breaks early adopters)

- **SEP-2663.** Experimental Tasks leaves core → official extension
  `io.modelcontextprotocol/tasks`. Blocking `tasks/result` replaced by polling
  **`tasks/get`**; adds **`tasks/update`** (client→server mid-flight input) and
  **`tasks/cancel`**; **`tasks/list` removed** (can't be scoped safely without
  sessions). Servers may return task handles **unsolicited** (no per-request
  opt-in). The RC post's one explicit "you must migrate" call-out: *"Anyone who
  shipped against the 2025-11-25 experimental Tasks API will need to migrate."*

### A6. Error-code changes (small but will bite literal matchers)

- Resource-not-found: MCP-custom **`-32002` → JSON-RPC `-32602`** (Invalid
  Params) (SEP-2164 in some summaries; the changelog lists it under JSON Schema/
  error cleanup). New error-code allocation policy partitions `-32000..-32019`
  (impl-defined, grandfathered) vs `-32020..-32099` (MCP-reserved); the RC's own
  new codes renumber: `HeaderMismatch` `-32001→-32020`,
  `MissingRequiredClientCapability` `-32003→-32021`,
  `UnsupportedProtocolVersion` `-32004→-32022`.

### A7. Mixed-version migration mechanics (the part the RC post under-documents)

The RC blog gives **no** client↔server interop guidance — but **SEP-2567 does**.
Rollout is a **clean break, no deprecation window for sessions**: a server that
still needs session state simply **stays on `2025-11-25`** until it migrates to
handles. Protocol-version negotiation handles mixed fleets — a dual-version
client speaks old to unmigrated servers, new to everyone else. The WG
deliberately avoided a "both modes at once" version because that would defeat
list caching (a client can't cache lists if *any* connected server might be
session-scoped). **This interop gap is itself a documentation opportunity.**

---

## TRACK B — Optimization & Advanced Ops

### B1. Header-based routing — SEP-2243

Streamable-HTTP POSTs now **require `Mcp-Method` and `Mcp-Name` headers** so
load balancers / gateways / rate-limiters route on the operation **without
parsing the body**. Servers **MUST reject** requests where headers and body
disagree (`HeaderMismatchError`). Also adds `x-mcp-header` for passing custom
headers from tool parameters.

### B2. Protocol-layer caching — SEP-2549

A new **`CacheableResult`** interface puts **`ttlMs`** (freshness hint, ms) and
**`cacheScope`** (`"public"` | `"private"`, à la HTTP `Cache-Control`) on
`tools/list`, `prompts/list`, `resources/list`, `resources/read`,
`resources/templates/list`. `public` = shared intermediaries may cache across
users; `private` = per-principal. Complements `*/list_changed`. **This is the
SEP that pays off the stateless rewrite**: with sessions gone, lists are stable
enough to cache, and the subagent fan-out cost drops from `O(subagents ×
servers)` to `O(servers)` (the orchestrator fetches once, every subagent reuses
the cached list). Servers **SHOULD** also return `tools/list` in deterministic
order to maximize LLM prompt-cache hits.

### B3. Distributed tracing — SEP-414

W3C Trace Context conventions documented for `_meta` keys: **`traceparent`,
`tracestate`, `baggage`** — so traces correlate across SDKs, gateways, and any
OpenTelemetry backend. Pairs with the Logging deprecation (→ OTel).

### B4. Server discovery — `server/discover` (SEP-2575)

New RPC servers **MUST** implement to advertise supported protocol versions,
capabilities, identity. Clients **MAY** call it before anything else for
up-front version selection, or as a backward-compat probe on stdio. Stateless,
cacheable, no shared state — the replacement for what `initialize` used to do.

### B5. JSON Schema 2020-12 — SEP-2106

Tool `inputSchema`/`outputSchema` lifted to **full JSON Schema 2020-12**: input
keeps a `type:"object"` root but gains composition (`oneOf`/`anyOf`/`allOf`),
conditionals (`if`/`then`/`else`), `$ref`, `$defs`; output schemas are
unrestricted and `structuredContent` may be **any JSON value**. **DoS guards:**
implementations **MUST NOT** auto-dereference external `$ref` URIs and **SHOULD**
bound schema depth + validation time.

### B6. MCP Apps (interactive UIs) — SEP-1865, ext `io.modelcontextprotocol/ui` (repo `ext-apps`)

First official extension; **production-ready**. Servers ship interactive HTML
rendered in **sandboxed iframes**. UI resources are predeclared via the
**`ui://`** URI scheme and associated with tools through metadata, so hosts can
**prefetch, cache, and security-review** them before render. Content type
**`text/html;profile=mcp-app`**. The iframe talks back over the **same JSON-RPC
base protocol** via `postMessage` — no new wire format. Security model: mandatory
sandbox, predeclared/reviewable templates, auditable (loggable) JSON-RPC
messages, optional explicit user consent for UI-initiated tool calls.

---

## TRACK C — Governance & Strategy

### C1. Extensions framework — SEP-2133

Extensions are **first-class, optional, off-by-default** additions identified by
**reverse-DNS** (`{vendor-prefix}/{name}`; official = `io.modelcontextprotocol`,
third-party = a domain you own, e.g. `com.example/my-extension`). Negotiated via
an **`extensions` map** in client + server capabilities (each extension declares
its own settings-object schema; `{}` = no settings). **Graceful degradation** is
required: the supporting side falls back to core behavior, or rejects if the
extension is mandatory. Official extensions live in `ext-*` repos with their own
maintainers and **version independently of the core spec**; experimental ones
live in `experimental-ext-*`, must be tied to a WG/IG, and **graduate via the
Extensions Track SEP process** (which *requires* ≥1 reference implementation in
an official SDK before review). Existing officials: **MCP Apps** (`ext-apps`),
**Tasks** (`io.modelcontextprotocol/tasks`), **ext-auth** (OAuth Client
Credentials, Enterprise-Managed Authorization).

### C2. Authorization hardening — six OAuth 2.1 / OIDC SEPs

| SEP | What it requires |
|---|---|
| **SEP-2468** | Clients **MUST** validate a present `iss` param on auth responses against the recorded issuer before redeeming the code (RFC 9207) — stops mix-up attacks; future versions will require *rejecting* responses that omit `iss`. The RC post: *"the one that should ship in every client by August."* |
| **SEP-837** | Clients **MUST** declare an appropriate `application_type` during Dynamic Client Registration so AS defaults don't misclassify desktop/CLI as `"web"` and reject localhost redirect URIs. |
| **SEP-2352** | Credentials are **bound to the issuing AS**: key persisted creds by issuer, **MUST NOT** reuse across AS, **MUST** re-register when the AS changes. |
| **SEP-2207** | Guidance for requesting **refresh tokens** from OIDC-style AS. |
| **SEP-2350** | Clarifies **scope accumulation** during step-up auth. |
| **SEP-2351** | Standardizes the **`.well-known` discovery suffix** for AS metadata. |

Related (not in the six but same revision): **Dynamic Client Registration
(RFC 7591) is now Deprecated** in favor of **Client ID Metadata Documents**
(PR #2858) — DCR stays for backward compat only.

### C3. Deprecation policy + the 12-month clock — SEP-2596 (policy) & SEP-2577 (the deprecations)

- **SEP-2596** adopts the **feature lifecycle**: **Active → Deprecated →
  Removed**, with a **minimum 12-month window** between deprecation and earliest
  removal (measured from the *revision release*, not SEP-Final date), a
  **deprecated-features registry** as the canonical "what's leaving and when,"
  and **Tier-1 SDK obligations** (mark the API deprecated in the next release;
  *should* emit a runtime warning). Expedited removal (≥90-day floor) only for
  active security risks with a published advisory.
- **SEP-2577** deprecates **Roots, Sampling, Logging** (deprecated *in*
  `2026-07-28`; earliest removal = first revision on/after **2027-07-28**). They
  **remain fully functional** through the window — annotation-only.

  | Deprecated | Recommended alternative |
  |---|---|
  | **Roots** | Pass directories/files via **tool parameters, resource URIs, or server configuration** |
  | **Sampling** | **Integrate directly with the LLM provider API** (the host's own model access) |
  | **Logging** | **`stderr`** for stdio transports; **OpenTelemetry** for structured observability (ties to SEP-414) |

- Also reclassified as Deprecated under the policy: **HTTP+SSE transport**
  (→ Streamable HTTP) and `includeContext: "thisServer"/"allServers"`
  (→ omit or `"none"`).

### C4. SEP process + conformance gating — SEP-2484, SEP-1850

- **SEP-2484:** a Standards-Track SEP **cannot reach Final** until a matching
  scenario lands in the **conformance suite** (`github.com/modelcontextprotocol/
  conformance`). The suite grows exactly as fast as the spec — and it's the
  **same suite the SDK tier system scores against**.
- **SEP-1850:** formalizes the **PR-based SEP workflow** (markdown in `seps/`,
  PR-derived numbering, sponsor responsibilities, status via PR labels).
- **SDK tiers** (conformance dates: tests available **2026-01-23**, tiering
  published **2026-02-23**): **Tier 1** = 100% conformance, ships new features
  before spec release, 2-business-day triage, 7-day P0 fix, stable release,
  full docs; **Tier 2** = 80% / within 6 months; **Tier 3** = experimental, no
  minimums. **Relegation:** Tier 1→2 if *any* conformance test fails for 4
  continuous weeks. Experimental features (Tasks) and extensions (MCP Apps) are
  **not required for any tier**.

---

## The Explicit-Handle Pattern — explained deep (the migration linchpin)

**What it is — and isn't.** It is **NOT a protocol construct.** There is no
`handles/*` method, no handle type in the schema, no wire concept. SEP-2567's
own words: *"From the protocol's perspective a handle is a string in a tool
result and a string in a tool argument, indistinguishable from any other tool
data."* The normative change is only the **removal of sessions**; the handle
pattern is **guidance the spec documents** (like it documents pagination) to
fill the resulting gap. This precision matters for a credible white paper:
people will call it "the new handle API" — it is not an API.

**The mechanic.** A server that used to scope state to a session instead:

1. Exposes a **creation tool** that mints + returns an opaque ID in
   `structuredContent`:
   `create_basket() → { "basket_id": "bsk_a1b2c3" }`.
2. The **model threads that ID** as an ordinary argument on later calls:
   `add_item(basket_id="bsk_a1b2c3", sku="shoes")` → `checkout(basket_id=...)`.
3. The **server owns the state**; the client merely **holds a name** for it;
   **authorization is re-checked on every call**.

**Why it's framed as *more powerful* than sessions** (this is the conceptual
core — five concrete wins):

- **Arbitrary cardinality + independent scoping.** A session gives exactly *one*
  scope per connection. The canonical example: an orchestrator spawns subagents
  that should **share one cart** but each need **their own browser**. No single
  session boundary satisfies both (share-parent clobbers browsers; own-session
  isolates the cart). With handles: `create_basket()` once → pass `basket_id` to
  all; each subagent `create_browser()` for its own `browser_id`. *The model
  decides what's shared vs isolated, per piece of state.*
- **Free resumption.** Handles live in tool results → they're in the chat
  transcript → any client that persists chats persists the handle automatically.
  Reopen on another device and the handle is back in front of the model — *no
  resumption machinery*, consistent across clients. Sessions required clients to
  persist/resend `Mcp-Session-Id` out-of-band, which almost none do.
- **List caching becomes sound.** With no session, `tools/list` can't vary
  per-connection, so it's cacheable (the `O(subagents×servers)→O(servers)` win).
  A side rule falls out: servers **may no longer mutate list results as a side
  effect** (the old `connect_database()`-makes-`query`-appear trick). Instead,
  expose `query`/`list_tables` unconditionally taking a `connection_id` arg, and
  error usefully if it's missing.
- **Addressability / hand-off.** A session-scoped cart is invisible outside its
  chat. A `basket_id` can be handed to another agent, another conversation, or a
  colleague.
- **Honest lifecycle.** Sessions never reliably delivered GC anyway (per-call
  clients destroy state instantly; per-launch clients never end it; LB'd
  stateless servers never see a close). Servers already lean on TTL expiry — the
  handle pattern just makes the durability policy **explicit and model-visible**.

**Server design guidance (SEP-2567, non-normative but load-bearing):**
handles **opaque** (`bsk_a1b2c3`, not `cart_user42_2026-03-11`); **possession ≠
authorization** for authed servers — validate `(handle, auth_context)` *every*
call (handles leak into chat logs, copy buffers, subagent prompts); for
**unauthenticated** servers the handle *is* a bearer token → ≥128 bits CSPRNG
entropy + bounded lifetime (same posture as "anyone-with-the-link" share URLs);
**document durability in the `create_*` tool description** ("baskets expire after
24h idle") so it's visible to the model; **expired handles return a clear error**
("basket bsk_a1b2c3 has expired", not "invalid argument") so the model can
recover by re-creating; **creation takes params** (`create_context(cluster=...)`,
not create-then-configure); offer **`destroy_*`/`list_*`** for cleanup/recovery
(optional). The pattern is already the de-facto norm in production remote
servers — **Linear** (`create_issue`→id), **Notion**, **GitHub**
(`create_pull_request`→PR#), **Stripe** (`create_customer`→id).

**Migration cookbook by server category (from SEP-2567 §Backward Compatibility):**

| Category | Migration |
|---|---|
| Stdio, process-lifetime state (most common stateful servers) | Mechanically still work, but **SHOULD migrate** — process lifetime has the same undefined-scope flaw and can't port to HTTP |
| HTTP using `Mcp-Session-Id` | Mechanical: session-map → handle-keyed map; add a `create_*` tool; add handle param to stateful tools |
| Session ID as telemetry key | Move to authenticated principal or request-level correlation ID |
| Proxy/gateway sticky routing | If upstream is stateless/handle-based, you need **no** sticky routing; HTTP→stdio bridges route by principal or a gateway-issued header |
| Auth bound to session (PKCE verifier, JWT claims) | Put a server nonce in OAuth `state` (the callback never carried `Mcp-Session-Id` anyway); per-request auth removes the need for session→user pinning |

**Future work flagged in the SEP:** nothing currently *marks* `basket_id` as a
live handle to client/model — a follow-up could make it explicit via shared
`$defs` referenced across tool input/output schemas, or a result-field
annotation, so orchestrators can identify live state for compaction/hand-off/
cleanup. (← a natural SEP-contribution lane for an orchestration-harness author.)

---

## 7 highest-leverage technical angles for THIS ambassador (Zig)

> Profile recap that drives the fit scoring: **multi-agent orchestration harness
> builder** (subagent fan-out, compaction, beads), **MCP-server author**,
> **local-model operator** (local models via Ollama/qwen3-coder; a self-hosted gateway),
> **peer-reviewed empirical-SE researcher** (EASE 2026 "Mise en Place"). He wants
> **academic + hands-on engineering**, *not* dev-rel. Effort = rough build cost.

**1. "Sessions were the wrong abstraction for fan-out: an empirical look at the
`O(subagents×servers)→O(servers)` list-caching win."** *(Track A/B)* — A
measurement piece: instrument a real subagent-spawning orchestrator against a
stateless+`ttlMs`-caching server vs the old session-rescan path; report the
`tools/list` call-count and latency delta as subagent count scales.
*Deliverable:* **white-paper section + demo repo** (reproducible benchmark
harness). *Why him:* his harness **is** the `O(subagents×servers)` pathology
SEP-2567 cites as the motivating case — he can produce the empirical curve the
SEP only asserts. His EASE method (controlled, reproducible, "the writeup is the
deliverable") is exactly the credibility differentiator vs dev-rel hot-takes.
*Effort:* **M–L** (needs a clean benchmark rig, but he has the orchestrator).
*This is the flagship — most defensible, most on-brand.*

**2. "Migrating a real stateful MCP server to the Explicit-Handle Pattern: a
diary."** *(Track A)* — Take one of his own servers (or a Playwright/browser-state
server — the SEP's canonical hard case) and migrate it: session-map → handle-map,
add `create_*`, thread the handle, implement `(handle, auth_context)` validation,
TTL expiry, clear expiry errors. *Deliverable:* **migration diary (blog) + demo
repo** with before/after branches. *Why him:* MCP-server author who actually owns
servers; the diary format matches the "learning in the open" ethos. *Effort:*
**M.** *Highest urgency — the migration/breaking changes are the most time-sensitive, and this is the
canonical migration artifact.*

**3. "Handles as capabilities: the security posture of the post-session world."**
*(Track A/C)* — Deep treatment of the one genuinely *new* risk surface: handles
leak where session IDs didn't (chat logs, subagent prompts, copy buffers).
Codify the `(handle, auth_context)`-every-call rule, the 128-bit-entropy bearer-
token case for unauthenticated servers, and the parallel to the **lethal
trifecta** already in the brief above. *Deliverable:* **white-paper section →
talk/livestream**, possible **SEP** (the "mark a field as a handle" future-work
lane, or a server security-checklist contribution). *Why him:* his harness uses
**hooks** (client-layer enforcement) and he already has the tool-poisoning/
rug-pull security thread going; this extends it into the 7-28 world. *Effort:*
**M** (writeup) / **L** (if it becomes a SEP).

**4. "MCP went stateless — so should your local model gateway: wiring
qwen3-coder behind a round-robin LB on a self-hosted box."** *(Track B)* — The
stateless core's whole point is "any request → any replica." Demo it where it's
least documented: **local models**. Stand up the new `Mcp-Method`/`Mcp-Name`
header routing + `server/discover` in front of a qwen3-coder MCP server, scaled
across replicas, no sticky routing. *Deliverable:* **tutorial + demo repo +
video.** *Why him:* he runs a self-hosted local-model setup — exactly the non-cloud rig with
**zero first-party "MCP + local models" content** (already flagged as idea #5 in
the brief above — 7-28 makes it sharper). *Effort:* **M–L.**

**5. "A conformance-gated MCP server fleet: CI that fails the build when you
drift from 2026-07-28."** *(Track B/C)* — Build a reusable GitHub Actions
template wiring the **conformance suite** (the SEP-2484 / SDK-tier suite) +
Inspector against a server, plus deprecation-warning detection for
Roots/Sampling/Logging. *Deliverable:* **demo repo + reusable Actions template
(PR-able).** *Why him:* beads + pulse + hooks = a "continuously
conformance-check a fleet" story; SDLC voice; pairs with his existing test-pyramid
idea (#6 above). *Effort:* **M.**

**6. "The three deprecations and what replaces them: Sampling→provider API,
Roots→tool params/resource URIs, Logging→stderr/OTel."** *(Track A/C)* — The
"use-it-and-migrate" tutorial that's in high demand, with a **live client-support
matrix** (he runs many clients + local models → can actually test each cell). Tie
Logging→OTel to the new **SEP-414 W3C Trace Context** for a complete observability
story. *Deliverable:* **tutorial + maintained matrix PR + screencast.** *Why him:*
multi-client + local-model operator who can fill cells others can only guess at
(extends idea #4 in the brief above into the deprecation frame). *Effort:* **M.**

**7. "Reading the spec like a researcher: an empirical-SE lens on the 7-28
breaking change."** *(Track C)* — The academic capstone. Use SEP-2567's own
1000-repo migration survey as the spine: replicate/extend the classification on a
fresh sample, validate the "90% unaffected / 4% must-migrate" claim, and frame
the stateless turn as a case study in **protocol evolution under ecosystem
constraints** (cardinality, undefined lifetime, uncacheable lists — the design
forces). *Deliverable:* **white-paper / conference-talk** (his EASE/empirical-SE
home turf; a potential paper or workshop submission). *Why him:* the one
ambassador with a **peer-reviewed empirical-SE publication** — this is the angle
no dev-rel ambassador can credibly take, and it directly serves AAIF's
governance/strategy track. *Effort:* **L** (real measurement + writing) —
*reserve max-effort; it's the differentiator.*

**Portfolio shape:** #2 (Track-A urgency, ships first) → #1 + #4 (the
harness/local-model empirical demos, the durable repos) → #3/#6 (security +
deprecations writeups) → #7 (the tentpole academic piece) → #5 (the CI
infrastructure contribution). Mix hits all three themes, leans every asset
in his profile, and avoids the dev-rel lane entirely.

---

## Accuracy flags (verify before publishing — the anti-slop gate)

- **SEP-number drift between summaries.** Secondary blogs mislabel several SEPs.
  Authoritative mapping (from the `draft` changelog + SEP pages):
  - Stateless: **SEP-2575** (remove `initialize`) + **SEP-2567** (remove
    sessions/`Mcp-Session-Id`).
  - Deprecation **policy** = **SEP-2596**; the **Roots/Sampling/Logging
    deprecations** = **SEP-2577**. (The first RC-blog summary I saw swapped
    these — don't.)
  - Routing headers **SEP-2243**; caching **SEP-2549**; trace context
    **SEP-414**; MRTR **SEP-2322**; Tasks **SEP-2663**; JSON Schema **SEP-2106**;
    extensions **SEP-2133**; MCP Apps **SEP-1865**; conformance gate **SEP-2484**;
    SEP workflow **SEP-1850**.
- **Notification-stream method name** (`subscriptions/listen` vs
  `messages/listen`) was still being finalized in RC text — **quote the changelog
  verbatim** rather than paraphrasing, and re-check at Final (7-28).
- **`2026-07-28` is still a Release Candidate** until 7-28; the changelog lives
  at `/specification/draft/changelog` and spec text **can still change** on
  blocking issues. **Re-verify every normative MUST/SHOULD at Final** before any
  white-paper or demo ships. Current Final remains **`2025-11-25`**.
- **The Explicit-Handle Pattern is NOT an API** — no schema, no method. Calling
  it one is the single most likely accuracy error in downstream content.
- **The "three themes" used here are a reader aid, not the spec's own structure.**
  The spec/RC-post groups by Stateless Core / Extensions / Auth / Deprecation /
  JSON Schema. Don't attribute A/B/C to modelcontextprotocol.io.
- **Migration blast radius is small** (90% unaffected per SEP-2567's survey) —
  resist the "everyone must rewrite" framing that secondary coverage leans on.
- **The RC blog groups the changes differently** than the three-theme split used
  here — that grouping is editorial, not the spec's.

## Sources (7-28 deep brief)

- RC announcement: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
- Draft changelog (authoritative SEP list): https://modelcontextprotocol.io/specification/draft/changelog
- **SEP-2567** (Sessionless MCP via Explicit State Handles, Final): https://modelcontextprotocol.io/seps/2567-sessionless-mcp
- Feature lifecycle / deprecation policy (SEP-2596): https://modelcontextprotocol.io/community/feature-lifecycle
- Deprecated-features registry: https://modelcontextprotocol.io/specification/draft/deprecated
- SDK tiers + conformance: https://modelcontextprotocol.io/community/sdk-tiers · https://github.com/modelcontextprotocol/conformance
- Extensions framework (SEP-2133): https://modelcontextprotocol.io/docs/extensions/overview
- MCP Apps (SEP-1865): https://modelcontextprotocol.io/community/seps/1865-mcp-apps-interactive-user-interfaces-for-mcp · https://github.com/modelcontextprotocol/ext-apps
- SEP PRs (numbers/text): #2567, #2575, #2322, #2243, #2549, #414, #2663, #2106, #2133, #1865, #2577, #2596, #2484, #1850, #2858 at github.com/modelcontextprotocol/modelcontextprotocol
