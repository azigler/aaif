---
name: gateway-trace
description: "Follow ONE thing through an agentgateway end to end — a single request by its id, or a single agent 'session' reconstructed as a time-ordered slice of one identity's calls. The zoom-IN twin of /gateway-audit's aggregate view. Reads the request-log DB (SQLite) with DuckDB, read-only. Emits a single-request timeline card, an optional session sequence, and — only when you deliberately ask and behind a loud privacy gate — the structure of the captured prompt/response payload (validity, byte length, message count; NEVER the content). Fire it to explain one slow/failed/surprising call, or to walk what one agent did in a window."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /gateway-trace — one request, one session, end to end

`/gateway-audit` answers "what did the fleet do?" in aggregate. This skill zooms
**in**: pick one call by its `id` and see its whole story — timeline, status,
identity, model/provider/route, token split, and (if capture is on) whether a
payload was recorded. Or widen to one **session** — all of one identity's calls in a
window, in order — to watch an agent's behavior unfold. Same request-log DB, same
SQLite-write / DuckDB-read split, still **read-only**.

The single durable handle is the **`id` primary key** (a per-call UUID), NOT
`trace_id`: in the verified sample **0 of 259 rows carried a `trace_id`** — those
columns are NULL unless OTLP/distributed tracing is configured. So treat `trace_id`
as optional "if tracing is on" enrichment, reconstruct a session heuristically from
`id` + `started_at` + identity, and be honest that it's a time slice, not a trace.

## When to fire

- **Explain one call** — a 52s latency outlier, a lone 403/429, a surprising model
  or route. You have (or can find) its `id`; walk the full row.
- **Walk one session** — "what did `goose` do between 19:50 and 20:10?" — the
  time-ordered slice of one identity, to read a sequence (e.g. auth denials
  resolving into successful calls) off the rows in order.
- **Inspect one payload** — the single skill that legitimately surfaces prompt/
  response content, for the operator reviewing *their own* traffic (privacy gate below).
- **Feed the aggregate** — hand a representative `id` to `/gateway-audit` as the
  concrete example behind a cluster it found.

## Inputs

| Input | Where | Notes |
|---|---|---|
| **Request-log snapshot** | `VACUUM INTO` a copy; attach read-only | never query the file the gateway is writing — see the cookbook, Pattern A/B. |
| **A request `id`** (primary) | from `/gateway-audit`, the admin Logs view, or a filter query | the per-call UUID PK; the one handle that always exists. |
| **An identity + window** (for a session) | e.g. `goose` + a start/end timestamp | reconstructs a session as a time slice — a heuristic, state it as one. |
| **`trace_id`** (optional) | only if OTLP tracing is configured | enrichment, never the required key — NULL in the default sample. |

Ground field meanings in the cookbook (`refs/gateway-request-log-cookbook.md`) — the
single source of query truth. Compose from it; don't invent columns.

## The queries (verified against a live snapshot)

Attach once; every query below assumes `gw`:

```sql
LOAD sqlite;   -- INSTALL sqlite; first time
ATTACH '$SNAP' AS gw (TYPE sqlite, READ_ONLY);
```

**Find a candidate `id`** when you only have a symptom — filter `request_logs` on it
(`WHERE http_status >= 400`, `duration_ms > 30000`, a model/identity), `ORDER BY
started_at DESC LIMIT 20`, and read the `id` off the row. Then:

**One request, end to end** (the timeline card — the full row picture):

```sql
SELECT r.id, r.started_at, r.completed_at, r.duration_ms, r.http_status, r.error,
       coalesce(nullif(r.agentgateway_user,''), r.attributes_json->>'$.agent','unattributed') AS identity,
       r.gen_ai_provider_name AS provider,
       r.gen_ai_request_model AS req_model, r.gen_ai_response_model AS resp_model,
       r.input_tokens AS in_tok, r.output_tokens AS out_tok, r.total_tokens AS tot_tok,
       (r.attributes_json->>'$."gen_ai.usage.cache_read.input_tokens"')::BIGINT AS cache_read,
       r.attributes_json->>'$.protocol' AS proto,
       r.attributes_json->>'$.route'    AS route,
       r.attributes_json->>'$."http.method"' AS http_method,
       r.attributes_json->>'$."http.path"'   AS http_path,
       r.has_payload
FROM gw.request_logs r WHERE r.id = '<uuid>';
-- verified (a goose local-model row): 200 · ident=goose · ollama/qwen3:8b · in 13 / out 845 / total 858
--   · llm · internal/llm:request · POST /v1/chat/completions · duration 25733ms · has_payload=1
```

**One session** (time-ordered slice of one identity in a window — a heuristic, not a
real trace):

```sql
SELECT row_number() OVER (ORDER BY started_at) AS seq,
       started_at, duration_ms, http_status,
       gen_ai_request_model AS model, total_tokens AS tok,
       attributes_json->>'$."http.path"' AS path, has_payload
FROM gw.request_logs
WHERE coalesce(nullif(agentgateway_user,''), attributes_json->>'$.agent') = '<identity>'
  AND started_at >= '<window-start>' AND started_at < '<window-end>'
ORDER BY started_at;
-- verified (goose, 20-min window): seq 1-3 = 403 denials (2-3ms) → seq 4-8 = 200s (128-1104 tok):
--   an auth misconfig resolving into successful calls, read straight off the sequence.
```

**Payload structure** (⚠️ privacy — see the gate below): surface *shape*, never text.

```sql
SELECT log_id,
       json_valid(request_prompt_json)        AS req_ok,
       length(request_prompt_json)            AS req_bytes,
       json_array_length(request_prompt_json) AS req_msgs,   -- request = a messages ARRAY
       json_valid(response_completion_json)   AS resp_ok,
       length(response_completion_json)       AS resp_bytes
FROM gw.request_log_payloads WHERE log_id = '<uuid>';
-- verified (same goose row): req_ok=true · req_bytes=44 · req_msgs=1 · resp_ok=true · resp_bytes=2432
```

## The payload privacy gate (READ THIS before touching content)

`request_log_payloads` holds the **full prompt and completion** for `has_payload=1`
rows — the one skill that can read them, for the operator reviewing *their own*
traffic on *their own* gateway. No exceptions:

- **NEVER commit, paste, or quote payload content** — not into the skill, a bead, a
  commit, a report, or a chat. Emit only **structure**: `json_valid`, bytes, message count.
- **Pretty-print is local-only.** `SELECT json_pretty(...)` to eyeball your own call
  is fine — that output stays on the operator's screen, never anywhere tracked.
- **Someone else's prompts are theirs.** On a shared gateway, unkeyed/operator rows
  are the human's own prompts — don't open them for a demo. Prefer a low-sensitivity
  row (a local-model agent call) for a worked example.

## Report shape

Emit a compact markdown report (no preamble):

```
# Gateway trace — <id> (<host>)   |   or: session <identity> <window>
## Request timeline
id <uuid>  status <http.status>  duration <ms>  started <t0> → completed <t1>
identity <ident>  <provider>/<req_model> (→ <resp_model>)  <method> <http.path> on <route> (<proto>)
tokens in/out/total <in>/<out>/<total>  cache_read <n or —>  payload <captured|none>  trace_id <id|not configured>
## Session sequence   (only when walking a window — mark "reconstructed time-slice, not a trace")
seq · <started_at> · <status> · <model> · <tok> · <path>   ×rows, in order
## Payload   (only if explicitly requested; STRUCTURE ONLY)
request valid=<t/f> bytes=<n> messages=<n>   response valid=<t/f> bytes=<n>   — content withheld —
## Notes
- <what the timeline/sequence explains: the outlier's cause, the denial→success arc, gaps>
```

## Cautions (anti-slop)

- **`id` is the handle, not `trace_id`.** `trace_id`/`span_id` are NULL without OTLP
  tracing (0/259 in the sample). When present it's a bonus link, never the spine.
- **A "session" is a heuristic.** A time-ordered slice of one identity is not a real
  distributed trace — it can merge two concurrent runs or split one. Say so, state the
  window, pick it deliberately, and keep token sums NULL-safe (`coalesce(...,0)`).
- **Payloads are sensitive and opt-in.** Content never leaves the operator's screen;
  demonstrate with structure only. Most rows have `has_payload=0` — nothing to read.
- **Identity may be coarse.** Keyless callers surface as `unkeyed`; `src.addr` is a
  network address (a private-mesh IP on a mesh setup), not per-agent identity — mask
  it as `<caller-ip>` if you ever surface it. See `/gateway-harden`.
- **Read-only.** Attach `READ_ONLY` against a `VACUUM INTO` snapshot; never touch the
  live file the gateway is writing.

## Reads / relates

- Query source of truth: `refs/gateway-request-log-cookbook.md` (schema, gotchas, the
  "one request, end to end" recipe this skill expands).
- Aggregate twin: `/gateway-audit`. Policy: `/gateway-harden`. Field/authz reference:
  `~/explore/agentgateway/refs/capability-map.md`.
