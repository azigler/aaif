---
name: agentgateway
description: "Four read-only lenses on an agentgateway deployment's OWN request-log surfaces — no external o11y backend. AUDIT (aggregate: who called what, how often, with what outcome, at what token cost), COST (token accounting + cache economics + dollars ONLY when priced), TRACE (one request by id / one session as a time slice + privacy-gated payload structure), and HARDEN (observed behavior → least-privilege CEL allowlist). All read the SQLite request-log DB via DuckDB over a consistent snapshot, never the live file. Harden is HUMAN-GATED and never applies policy itself. Fire it to review fleet behavior, size the token bill, explain one call, or tighten authz from evidence."
when_to_use: "When you need to understand or tighten a running agentgateway fleet from its own request log: review what the fleet did (audit), account tokens/cost (cost), explain or walk one call/session (trace), or derive a least-privilege authz policy for a human to apply (harden). Read-only; harden proposes, never applies."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /agentgateway — observe, account, trace, harden a fleet

agentgateway records every call it proxies (MCP, LLM, HTTP) to its own surfaces: a
structured **SQLite request-log DB** (the same store behind the admin UI's Logs view)
and, as a text fallback, an access log + Prometheus metrics. This one skill turns that
raw stream into legible answers through **four components** — you don't need Phoenix, an
OTLP backend, or any external store.

| Component | Answers | Fire it |
|---|---|---|
| **audit** | what did the fleet do? | routine review · investigate a spike · baseline before hardening |
| **cost** | what did it cost? | size the token bill · find the heavy hitter · check cache economics |
| **trace** | what happened in ONE call / session? | explain an outlier/denial · walk one agent's window · inspect one payload |
| **harden** | what least-privilege policy fits? | after an audit, propose CEL that allows exactly what was observed |

**All four are read-only** over the request-log DB. The only component that *proposes a
change* is **harden — and it is HUMAN-GATED: it emits policy YAML + a runbook and NEVER
applies policy itself.** The pipeline flows one way: audit produces the observed-behavior
baseline; harden turns that baseline into a proposed allowlist a human validates and applies.

(Near-real-time *continuous* alerting is deliberately out of scope — a skill can't hold a
standing watch; run audit/cost on a cadence and read the deltas instead.)

## The shared foundation — read this first

The DB source, the snapshot recipe, the schema, the verified per-metric queries, and the
gotchas that shape every component live in **`refs/gateway-request-log-cookbook.md`** — the
single source of query truth. Compose from it; do not invent columns, and do not duplicate
its contents here.

The non-negotiable mechanic (the **SQLite-write / DuckDB-read split**): agentgateway *owns*
the SQLite file (`config.database.url`, `mode=rwc`, WAL). You never point the analytics
engine at the file it is writing — you snapshot a consistent copy (`VACUUM INTO` folds the
WAL and never blocks the writer), then attach it **read-only**:

```bash
GW_DB=/absolute/path/requests.db      # what agentgateway writes (never queried live)
SNAP=/tmp/reqsnap.db                   # consistent read copy
sqlite3 "$GW_DB" "VACUUM INTO '$SNAP'" # local; remote/mesh: see cookbook Pattern B (ssh + gzip + integrity_check)
```
```sql
LOAD sqlite;   -- INSTALL sqlite; first time
ATTACH '/tmp/reqsnap.db' AS gw (TYPE sqlite, READ_ONLY);
```

When the DB isn't configured, audit has a text-access-log fallback (below); cost/trace/harden
need the DB. Ground field/authz meanings in `~/explore/agentgateway/refs/capability-map.md`.

---

## Component 1 — audit: what did the fleet do?

**Answers:** who called what, how often, with what outcome, at what token cost — grouped by
identity × route × method × tool, with error clusters and latency percentiles.

**Fire it when:** doing a routine "what happened this week?" review; investigating a 403
spike / latency cliff / unexpected tool call / token blowout; capturing the observed
`(identity → routes → methods → tools)` surface as the **baseline harden consumes**; or
showing a fleet's real traffic in a talk.

**How:** one composite pass over `gw.request_logs` yields overview totals, protocol mix,
status classes, by-identity-with-tokens, error clusters, and p50/p95/max latency — the six
sections of the report. Pull each metric's verified query from the cookbook (identity
resolution, status/error clusters, latency percentiles); the load-bearing join for harden is,
**per identity, the set of `(route, mcp.method.name, gen_ai.tool.name)` actually seen** — that
triple is exactly what harden turns into an allowlist, so emit it explicitly.

Cross-check aggregate counters against Prometheus (`agentgateway_(requests|mcp_requests)_total`
at `statsAddr`) — they survive log rotation. **Fallback (no DB):** derive the same report from
the text access log; every request line carries `http.status=`, so `grep -F 'http.status='` is
the reliable filter, then group by `src.addr` / `mcp.method.name` / `gen_ai.tool.name`.

**Anti-patterns (load-bearing):**
- **Report only what's logged — don't invent identity.** Attribution is `src.addr` (network
  identity) unless `extAuthz`/virtual keys are on. Say "network identity only" and point at the
  gap; never fabricate per-agent identity the log doesn't carry.
- **State the window.** "0 errors" over 10 minutes is not "0 errors"; small samples
  under-represent the tail. Report `min(started_at) .. max(completed_at)`.

## Component 2 — cost: what did it cost?

**Answers:** the token bill in totals, per-identity, per-model, and per-day; the cache
economics (`cache_read` vs `cache_creation`) that actually move that bill; and dollars **only
when the rows are priced**.

**Fire it when:** sizing token spend ("how many tokens this week, and where?"); finding the
token-heavy identity or model; checking whether prompt caching is actually saving input tokens
(high read% pays off; high create% + low read% = re-paying, not saving); or answering "how much
in dollars?" — with the honest tokens-only answer when unpriced.

**How:** all accounting lives in the aggregate `request_logs` table (never payloads). The grand-
totals query returns `rows_priced = count(cost)` — that one number decides `$`-vs-tokens. Cache
tokens come from the `attributes_json` usage keys, not columns. Pull the totals / by-identity /
by-model / by-day / cache-efficiency queries from the cookbook.

**Anti-patterns (load-bearing):**
- **Tokens are not dollars.** `cost` is NULL on subscription / flat-rate / local setups. Show
  `$` only when `count(cost) > 0`; otherwise report tokens-only and name why (a **cost catalog**
  is the fix, never a guessed price).
- **NULL-safe every sum, and read cache from JSON.** Failed calls and some local-model rows
  carry NULL tokens — wrap every `sum()` in `coalesce(…,0)`; and `cache_read`/`cache_creation`
  live in `attributes_json`, so a report that ignores them undercounts the input story.

## Component 3 — trace: one request, one session, end to end

**Answers:** the zoom-IN twin of audit — one call by its `id` (full timeline: status,
identity, provider/model/route, token split, payload-captured flag) or one **session**
reconstructed as a time-ordered slice of one identity's calls in a window.

**Fire it when:** explaining a single latency outlier / lone 403·429 / surprising model or
route; walking what one agent did in a window (e.g. auth denials resolving into successful
calls, read straight off the sequence); or inspecting one payload's *structure* (the one
component that legitimately touches captured content, for the operator reviewing their own
traffic). Hand a representative `id` back to audit as the concrete example behind a cluster.

**How:** the durable handle is the **`id` primary key** (per-call UUID), NOT `trace_id`. Find a
candidate `id` by filtering `request_logs` on the symptom (`http_status >= 400`,
`duration_ms > 30000`, a model/identity), then read the full row / session slice via the
cookbook's "one request, end to end" recipe. Payload *structure* (validity, byte length, message
count) comes from `request_log_payloads` — join it only when you deliberately intend to.

**Anti-patterns (load-bearing):**
- **`id` is the handle, not `trace_id`.** `trace_id`/`span_id` are NULL without OTLP tracing
  (0/259 in the verified sample) — when present it's a bonus link, never the spine. And a
  "session" is a **heuristic** time-slice, not a real distributed trace: it can merge two
  concurrent runs or split one, so state the window and pick it deliberately.
- **Payloads are sensitive and opt-in — structure only.** `request_log_payloads` holds full
  prompts and completions. **NEVER commit, paste, or quote payload content** — into the skill, a
  bead, a commit, a report, or a chat. Emit only structure (`json_valid`, bytes, message count);
  `json_pretty` to eyeball your own call stays local-only; someone else's prompts are theirs.

## Component 4 — harden: least privilege from observed behavior (HUMAN-GATED)

**Answers:** what agentgateway **authorization policy** allows exactly the identities / methods
/ tools the fleet actually used and denies everything else — deny-by-default, earned from the
audit baseline.

> **This component PROPOSES; it does NOT apply.** Output is policy YAML plus a
> validate → shadow → apply runbook for a *human* to walk. Tightening a live authz policy is a
> foot-gun (you can lock out legitimate-but-unseen traffic), so the apply step is always the
> operator's. No autonomous policy changes to a live gateway — ever.

**Fire it when:** you have an audit baseline and want to convert it to policy; scope an agent to
the tools it really uses (the "this MCP server exposes 40 tools, my agent calls 3" gap); close a
network-only route now that you know its real callers; or respond to an audit finding (an
unexpected tool call / caller).

**The authz surface (agentgateway v1.3.1):** two CEL layers under a route's `policies:` —
`authorization` (gates the HTTP request: identity/path/method) and `mcpAuthorization` (gates MCP
tools/prompts/resources on `mcp.tool.name` / `mcp.method`). **Eval order:** `deny` wins → all
`require` must pass → any `allow` allows. **Adding any `allow` flips the ruleset to allowlist
semantics** — everything not allowed is denied. That is the lever: one `allow` per observed thing
= deny-by-default for the rest. (Verified: an `mcp.tool.name == "echo"` allowlist made `tools/list`
return only `echo`; calling `add` was denied as `-32602 "Unknown tool: add"` — no info leak — and
still logged `status=400 gen_ai.tool.name=add reason=MCP` so the audit sees the attempt.)

**Derivation:** from the audit baseline, per identity collect `routes`, `mcp.method.name`s,
`gen_ai.tool.name`s, then emit as a **diff against the current route config** (not a whole new
file): a `mcpAuthorization` allow per observed tool set, an `authorization` allow per observed
caller, and — for per-agent least privilege — key the tool allow on the identity
(`apiKey.name == "goose" && mcp.tool.name in ["echo","sequentialthinking"]`). Prefer separate
routes per agent identity over one CEL branching on identity.

**The runbook the human walks:** 1) **Validate** — `agentgateway -f proposed.yaml --validate-only`
(must say "Configuration is valid!"). 2) **Shadow** — stand it up on a non-production copy / spare
port, replay representative traffic, confirm the allowed set passes and the denied set is intended.
3) **Apply deliberately** — swap it onto the live route and watch audit for new
4xx/`reason=Authorization` clusters for a full duty cycle (new denials = over-tight rule; loosen
with evidence). 4) **Keep the baseline** — save the audit window the policy was derived from next
to the policy.

**Anti-patterns (load-bearing):**
- **Propose, never apply.** This component writes YAML + a runbook; a human validates, shadows,
  applies. No autonomous change to a live gateway.
- **Over-fitting is the failure mode.** A short window yields rules that break legitimate-but-
  unseen behavior — state the derivation window, set a minimum (≥1 representative duty cycle), and
  widen before tightening when in doubt.
- **Identity first.** A tool allowlist without an identity gate still lets *anyone on the network*
  call the allowed tools — pair `mcpAuthorization` with `authorization` (tailnet identity / JWT /
  virtual key). Network position is not identity.
- **Deny is silent for MCP tools.** A wrongly-denied tool looks *missing* ("Unknown tool"), not
  *forbidden*, to the agent — call this out so a mis-scope is diagnosable (cross-reference the
  audit's `reason=MCP` lines). And note the gotcha: at the authz layer `mcp.tool.name` is the
  **underlying** name (`echo`), NOT the federation-namespaced `everything_echo` that `tools/list`
  shows — a rule against the namespaced name matches nothing and the agent silently gets zero tools.

---

## Run them as a loop

The four components compose into one investigative loop. Concrete walk — the morning after an
overnight batch, everything read-only over one snapshot, ending at a human-gated proposal:

1. **audit the morning after.** Snapshot, attach read-only, run the composite over the window.
   You get: `unkeyed` did 244 calls, a p95 latency of 52s, three 429s, and a `gen_ai.tool.name`
   you didn't expect from the `goose` identity.
   ```bash
   sqlite3 "$GW_DB" "VACUUM INTO '$SNAP'"    # one snapshot feeds the whole loop
   ```

2. **trace the surprising call.** Audit surfaced an unexpected tool + a 52s outlier. Find the
   `id` by the symptom, then read the full row — no payload content, just the timeline:
   ```sql
   SELECT id, started_at, duration_ms, http_status,
          gen_ai_request_model AS model, attributes_json->>'$."gen_ai.tool.name"' AS tool
   FROM gw.request_logs WHERE duration_ms > 30000 ORDER BY started_at DESC LIMIT 20;
   -- read the id off the row, then the cookbook's "one request, end to end" recipe for the full card
   ```

3. **cost the heavy run.** The audit's by-identity totals flagged a token-heavy identity — size
   it and check whether caching carried the input. `rows_priced` decides tokens-vs-$:
   ```sql
   SELECT count(cost) AS rows_priced, sum(coalesce(total_tokens,0)) AS tok FROM gw.request_logs;
   -- rows_priced 0 → report tokens only (flat-rate/local); never fabricate $
   ```

4. **harden proposes a tighter allowlist — for human review.** The audit's per-identity
   `(route, method, tool)` surface becomes a proposed `mcpAuthorization` diff that allows exactly
   what `goose` was seen doing and denies the rest. The skill emits the YAML + the
   validate→shadow→apply runbook and **stops** — the operator validates, shadows, and applies.

**The whole loop is read-only and human-gated.** Steps 1–3 only ever attach a `VACUUM INTO`
snapshot `READ_ONLY` and never touch the live file or surface payload content; step 4 *proposes*
policy and never applies it. Nothing in the loop changes a running gateway on its own.

## Cautions (anti-slop — cross-cutting)

- **Read-only, over a copy.** Every component attaches a `VACUUM INTO` snapshot `READ_ONLY`;
  never query the file agentgateway is writing. Harden is the only one that proposes a change,
  and it still never applies.
- **State the window.** These queries default to the whole snapshot; a short window is a partial
  picture. Report `min(started_at) .. max(completed_at)` and don't extrapolate.
- **Never surface payload content.** Only trace touches `request_log_payloads`, and only for
  *structure* — prompts/completions never land in a report, bead, commit, or chat.
- **Tokens are not dollars.** `cost` is NULL on subscription/flat-rate/local; show `$` only when
  `count(cost) > 0`.

## Reads / relates

- **Query foundation:** `refs/gateway-request-log-cookbook.md` — the verified DuckDB-over-SQLite
  cookbook (schema, gotchas, snapshot patterns, per-metric queries) all four components compose
  from. Compose, don't duplicate; don't invent columns.
- **Field / authz reference:** `~/explore/agentgateway/refs/capability-map.md`,
  `~/explore/agentgateway/experiment/VERIFIED.md` (the identity-authz eval-order run).
