# The agentgateway request-log cookbook — DuckDB over the SQLite request DB

The shared query foundation for the gateway skills (`/gateway-audit`, `/gateway-cost`,
`/gateway-watch`, `/gateway-trace`). Where the text access log is a stream you `grep`,
the **request-log database** is a structured, indexed table you query — richer, exact,
and rotation-proof. This reference is the verified, copy-paste cookbook every gateway
skill composes from.

Every query here was **run against a live request-log DB** (agentgateway v1.3.x,
259-row window) — the sample outputs are real, so the shapes are trustworthy, not
guessed. Re-verify against your own DB before depending on a number.

## The source: agentgateway writes SQLite, you read with DuckDB

agentgateway can persist every call it proxies to a **SQLite** request-log DB — the
same store that powers the admin UI's web Logs view. Turn it on with one config knob:

```yaml
config:
  database:
    url: "sqlite:///absolute/path/requests.db?mode=rwc"   # rwc = read-write-create
  standardAttributes:
    user: 'apiKey.name'          # populates the agentgateway_user column (identity)
# optional: capture prompt + completion payloads (flips has_payload; privacy-sensitive)
frontendPolicies:
  accessLog:
    database:
      add: { prompt: 'llm.prompt', completion: 'llm.completion' }
```

The **write path is SQLite** (agentgateway owns it, `mode=rwc`, WAL). The **read path is
DuckDB** — attach that file *read-only* and query it with DuckDB's analytics engine
(window functions, `quantile_cont`, `date_trunc`, JSON extraction). This is the
**SQLite-write / DuckDB-read split**: never let the analytics engine touch the file the
gateway is writing; read a consistent copy.

### Pattern A — gateway co-located with DuckDB

Snapshot the live DB to a consistent single file (folds the WAL, never blocks the
writer), then attach the snapshot:

```bash
GW_DB=/absolute/path/requests.db          # what agentgateway writes
SNAP=/tmp/reqsnap.db                       # consistent read copy
sqlite3 "$GW_DB" "VACUUM INTO '$SNAP'"     # point-in-time, self-contained, WAL folded in
```

### Pattern B — gateway on another host (the mesh case)

agentgateway commonly runs on a separate box (a home machine reached over a private
mesh) while you analyze from your dev box. Snapshot **remotely**, copy the single file:

```bash
ssh <gateway-host> "sqlite3 ~/.local/share/agentgateway/requests.db 'VACUUM INTO /tmp/reqsnap.db'"
scp <gateway-host>:/tmp/reqsnap.db "$SNAP" && ssh <gateway-host> 'rm -f /tmp/reqsnap.db'
```

`VACUUM INTO` matters: the live DB runs in WAL mode with a `-wal` sidecar holding
uncommitted pages. Copying `requests.db` alone loses them; `VACUUM INTO` produces one
consistent, self-contained file (no `-wal`/`-shm` needed) — verified portable.

## The schema (only the load-bearing columns)

```
request_logs
  id TEXT PK                     -- per-call UUID  (the single-request handle)
  started_at, completed_at TEXT  -- ISO8601 µs + tz: 2026-07-03T21:41:59.468865+00:00
  duration_ms INTEGER
  trace_id, span_id TEXT         -- NULL unless OTLP tracing is configured (see gotchas)
  http_status INTEGER, error TEXT
  gen_ai_operation_name, gen_ai_provider_name TEXT
  gen_ai_request_model, gen_ai_response_model TEXT
  input_tokens, output_tokens, total_tokens INTEGER
  cost REAL                      -- NULL unless a cost catalog prices the model
  agentgateway_user, agentgateway_group TEXT   -- identity (from apiKey metadata)
  user_agent_name TEXT
  has_payload INTEGER            -- 1 if the row has a payloads-table row
  attributes_json TEXT           -- everything else, as JSON (see keys below)
request_log_payloads
  log_id TEXT PK -> request_logs.id
  request_prompt_json, response_completion_json TEXT   -- valid JSON; PRIVACY-SENSITIVE
```

Indexes exist on `completed_at`, `(total_tokens,cost)`, `http_status`, provider/model,
`agentgateway_user`, `agentgateway_group`, `user_agent_name` — so the group-bys below
are cheap.

`attributes_json` top-level keys (verified present): `protocol`, `route`, `listener`,
`endpoint`, `gateway`, `agent`, `agentgateway.user`, `agw.api_key.name`,
`src.addr`, `http.method`, `http.path`, `http.host`, `http.status`, `http.version`,
`user_agent.name`, and the `gen_ai.*` family (`request.model`, `response.model`,
`provider.name`, `operation.name`, `request.max_tokens`, `usage.input_tokens`,
`usage.output_tokens`, `usage.cache_read.input_tokens`,
`usage.cache_creation.input_tokens`). MCP traffic adds `mcp.method.name`,
`gen_ai.tool.name`, `mcp.target` (see the capability map — none in the LLM-only sample
window, but they land on MCP rows).

## The cookbook (verified queries)

Attach once; every query assumes `gw`:

```sql
LOAD sqlite;   -- INSTALL sqlite; first time
ATTACH '/tmp/reqsnap.db' AS gw (TYPE sqlite, READ_ONLY);
```

**JSON extraction** — DuckDB reads `attributes_json` as text; pull fields with `->>`.
Dotted keys must be quoted in the path:

```sql
attributes_json ->> '$.protocol'                       -- llm | mcp | http
attributes_json ->> '$."gen_ai.request.model"'         -- dotted key: quote it
```

**Identity** — prefer the column; fall back to the access-log `agent` attribute
(keyless/OAuth traffic surfaces as `unkeyed`):

```sql
SELECT coalesce(nullif(agentgateway_user,''), attributes_json->>'$.agent', 'unattributed') AS identity,
       count(*) n, sum(total_tokens) tok
FROM gw.request_logs GROUP BY identity ORDER BY n DESC;
-- verified: unkeyed 244 · goose 15
```

**Tokens by model (NULL-safe) + cache economics** — local models sometimes report no
usage (`NULL` tokens); never let one NULL void the sum:

```sql
SELECT gen_ai_request_model AS model, count(*) n,
       sum(coalesce(input_tokens,0))  in_tok,
       sum(coalesce(output_tokens,0)) out_tok,
       sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_read.input_tokens"')::BIGINT,0)) cache_read
FROM gw.request_logs GROUP BY model ORDER BY n DESC;
-- verified: claude-opus-4-8 in 89622 / out 145758 / cache_read 9,363,773 · qwen3:8b · qwen3-coder:30b
```

**Cost honesty** — `cost` is `NULL` on a subscription / flat-rate / local setup. Report
tokens; only show dollars when the column is actually populated:

```sql
SELECT count(cost) AS rows_priced, coalesce(sum(cost),0) AS dollars, sum(total_tokens) AS tokens
FROM gw.request_logs;
-- verified: rows_priced 0 · dollars 0 · tokens 219,906  -> "tokens only; flat-rate = no $"
```

**Latency percentiles**:

```sql
SELECT round(quantile_cont(duration_ms,0.5)) p50,
       round(quantile_cont(duration_ms,0.95)) p95, max(duration_ms) max
FROM gw.request_logs;   -- verified: p50 205ms · p95 52398ms · max 135118ms
```

**Status + error clusters** — key on `http_status`; the `error` text column is often
`NULL` even on 4xx (upstream failures surface as status, not text). Enrich from
attributes:

```sql
SELECT http_status,
       attributes_json->>'$.protocol' proto, attributes_json->>'$.route' route,
       coalesce(nullif(agentgateway_user,''), attributes_json->>'$.agent') ident,
       attributes_json->>'$."http.path"' path, error, count(*) n
FROM gw.request_logs WHERE http_status >= 400 GROUP BY ALL ORDER BY n DESC;
-- verified: 403×7 goose internal/llm:request /v1/chat/completions · 429×3 unkeyed default/claude-agent
```

**Volume over time** (the `/gateway-watch` trend):

```sql
SELECT date_trunc('hour', completed_at::TIMESTAMPTZ) hr, count(*) n,
       round(avg(duration_ms)) avg_ms, sum(coalesce(total_tokens,0)) tok
FROM gw.request_logs GROUP BY hr ORDER BY hr;
```

**One request, end to end** (the `/gateway-trace` handle — `id`, not `trace_id`):

```sql
SELECT r.id, r.started_at, r.duration_ms, r.http_status,
       coalesce(nullif(r.agentgateway_user,''), r.attributes_json->>'$.agent') ident,
       r.gen_ai_request_model model, r.total_tokens, r.has_payload
FROM gw.request_logs r WHERE r.id = '<uuid>';
-- join payloads ONLY when you intend to read prompt/response content (privacy):
SELECT json_valid(request_prompt_json) ok, length(request_prompt_json) req_bytes
FROM gw.request_log_payloads WHERE log_id = '<uuid>';
-- payloads are valid JSON (request = messages ARRAY); treat as sensitive.
```

## Gotchas that shape every skill (verified, not assumed)

- **`cost` is NULL** on subscription/flat-rate/local models. Token *counts* are not
  dollars. Never fabricate spend — show `$` only when `count(cost) > 0`.
- **`trace_id`/`span_id` are NULL** unless OTLP/distributed tracing is configured. The
  durable per-request handle is the **`id`** primary key. Reconstruct a "session" as a
  time-ordered slice of one identity's rows — don't assume trace IDs exist.
- **Identity needs an apiKey.** Keyed callers populate `agentgateway_user`
  (`standardAttributes.user: apiKey.name`); OAuth/keyless callers are `unkeyed` in the
  `agent` attribute. On a shared box `src.addr` is not per-agent identity (see
  `/gateway-harden`).
- **The `error` column is frequently NULL on 4xx.** Cluster errors on `http_status` and
  enrich from `attributes_json` (route/path/identity), not on `error` alone.
- **NULL-safe sums.** Failed calls and some local-model rows have NULL tokens. Wrap
  every `sum()` over token columns in `coalesce(...,0)`.
- **Payloads are opt-in and sensitive.** `has_payload=1` only when payload capture is
  toggled on. `request_log_payloads` holds full prompts and completions — never print,
  commit, or paste their content; surface structure (validity, byte length, message
  count) instead.
- **Always state the window.** These queries default to the whole snapshot; a short
  window is a partial picture. Report `min(started_at) .. max(completed_at)`.

## Read-only, never write

DuckDB attaches `READ_ONLY`; the snapshot is a copy. These skills observe. The only
skill that proposes a *change* is `/gateway-harden`, and it is human-gated and still
never applies. Analysis must not touch the file agentgateway is writing.

## Relates

- Field/authz reference: `~/explore/agentgateway/refs/capability-map.md`.
- Consumers: `/gateway-audit` (aggregate behavior), `/gateway-cost` (token/cost),
  `/gateway-watch` (near-real-time), `/gateway-trace` (one request/session),
  `/gateway-harden` (observed surface → least-privilege policy).
</content>
</invoke>
