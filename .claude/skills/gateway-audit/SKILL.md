---
name: gateway-audit
description: "Answer 'what did my agent fleet actually do?' from an agentgateway deployment's own surfaces — its structured request-log DB (DuckDB, preferred) or, as fallback, its access log + Prometheus metrics — no external o11y backend. Groups every call by identity, route, method, and tool; clusters errors; sums tokens/cost for LLM traffic; surfaces anomalies. Read-only. The foundation the hardening skill (/gateway-harden) derives least-privilege policy from. Fire it to review fleet behavior, investigate a spike, or produce the observed-behavior baseline before tightening authz."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /gateway-audit — what did the fleet do?

agentgateway records every call it proxies (MCP, LLM, HTTP) as a structured
access-log line, and aggregates the same data as Prometheus metrics. This skill
turns that raw stream into a **legible report of fleet behavior** — who called what,
how often, with what outcome, at what token cost — using nothing but the gateway's
own surfaces. No Phoenix, no OTLP backend, no external store required.

It is **read-only**. It observes; it never changes config or policy. Its output is
also the **input to `/gateway-harden`**: you can't write a least-privilege policy for
behavior you haven't measured.

## When to fire

- **Routine review** — "what has the fleet been doing this week?"
- **Investigate** — a 403 spike, a latency cliff, an unexpected tool call, a token blowout.
- **Baseline before hardening** — capture the observed (identity × route × method × tool)
  surface so `/gateway-harden` can propose rules that allow exactly what's real.
- **Content/demo** — show a fleet's actual traffic in a talk or article.

## Inputs — two sources (prefer the DB)

agentgateway exposes fleet behavior two ways. Prefer the structured DB whenever it's on.

- **Source A — the request-log DB (DuckDB), PREFERRED** when `config.database.url` is
  set. A structured, indexed SQLite table the gateway persists per call (the same store
  behind the admin UI's Logs view); you read a read-only snapshot with DuckDB. Exact,
  indexed, rotation-proof — and one query produces the whole report.
- **Source B — the text access log (grep), FALLBACK** when the DB isn't configured. The
  gateway's stdout/stderr stream, parsed with grep/awk. Same fields, less precise, and
  exposed to log rotation.

Cross-check either against **Prometheus metrics** (`statsAddr`, e.g.
`localhost:15020/metrics`) for aggregate counters and rates over time; use `agctl proxy`
(admin API) to name what the traffic hit. **Always state the time window in the report** —
a short window is a partial picture.

Ground field meanings in the **capability map**
(`~/explore/agentgateway/refs/capability-map.md`); ground every DB query in the
**request-log cookbook** (`refs/gateway-request-log-cookbook.md`) — the single source of
query truth (verified schema, gotchas, per-metric queries).

## Source A — the request-log DB (DuckDB, preferred)

The gateway **writes** SQLite (`config.database.url`, `mode=rwc`, WAL); you **read** with
DuckDB. Never point the analytics engine at the live file — snapshot a consistent copy
(`VACUUM INTO` folds the WAL and never blocks the writer), then attach it read-only:

```bash
GW_DB=/absolute/path/requests.db             # what agentgateway writes (local)
SNAP=/tmp/reqsnap.db                          # consistent read copy
sqlite3 "$GW_DB" "VACUUM INTO '$SNAP'"        # point-in-time, self-contained, WAL folded in
# remote gateway (mesh case): ssh <gateway-host> "sqlite3 …/requests.db 'VACUUM INTO /tmp/reqsnap.db'" && scp <gateway-host>:/tmp/reqsnap.db "$SNAP"
```

```sql
LOAD sqlite;   -- INSTALL sqlite; first time
ATTACH '/tmp/reqsnap.db' AS gw (TYPE sqlite, READ_ONLY);
```

**One composite query = the whole report in a single pass** — overview totals, protocol
mix, status classes, by-identity with tokens, error clusters, and latency percentiles.
Its six `sect` groups map 1:1 onto the report shape below. For LLM dollars, cache
economics, volume-over-time, and single-request trace, pull the matching query from the
cookbook rather than duplicating it here.

```sql
WITH base AS (
  SELECT coalesce(attributes_json->>'$.protocol','?') AS proto, http_status AS st,
         coalesce(nullif(agentgateway_user,''), attributes_json->>'$.agent','unattributed') AS ident,
         attributes_json->>'$.route' AS route, attributes_json->>'$."http.path"' AS path,
         duration_ms AS dur,
         coalesce(input_tokens,0) AS in_tok, coalesce(output_tokens,0) AS out_tok
  FROM gw.request_logs)
SELECT '1_overview' sect, 0 ord, 'window '||(SELECT min(started_at) FROM gw.request_logs)||' .. '||(SELECT max(completed_at) FROM gw.request_logs) line
UNION ALL SELECT '1_overview', 1, 'calls '||count(*)||' · in_tok '||sum(in_tok)||' · out_tok '||sum(out_tok) FROM base
UNION ALL SELECT '2_protocol', row_number() OVER (ORDER BY count(*) DESC), 'proto '||proto||' ×'||count(*) FROM base GROUP BY proto
UNION ALL SELECT '3_status', cast(st AS INT), 'status '||st||' ×'||count(*) FROM base GROUP BY st
UNION ALL SELECT '4_identity', row_number() OVER (ORDER BY count(*) DESC), 'ident '||ident||' — '||count(*)||' calls · '||sum(in_tok+out_tok)||' tok' FROM base GROUP BY ident
UNION ALL SELECT '5_errors', row_number() OVER (ORDER BY count(*) DESC), 'err '||st||' '||coalesce(ident,'?')||' '||coalesce(route,'?')||' '||coalesce(path,'?')||' ×'||count(*) FROM base WHERE st>=400 GROUP BY st,ident,route,path
UNION ALL SELECT '6_latency', 0, 'p50 '||round(quantile_cont(dur,0.5))||'ms · p95 '||round(quantile_cont(dur,0.95))||'ms · max '||max(dur)||'ms' FROM base
ORDER BY sect, ord;
```

Identity resolves `agentgateway_user` (keyed) → the `agent` attribute (`unkeyed`) →
`unattributed`; on a shared box `src.addr` is **not** per-agent identity (see
`/gateway-harden`). Cost honesty holds here too: `cost` is NULL on flat-rate/local — the
composite reports tokens only; only add `$` when the cookbook's cost query shows
`count(cost) > 0`. Never join `request_log_payloads` unless you intend to read
prompt/response content — and never print or commit that content.

## Source B — the text access log (grep, fallback)

When the DB isn't configured, derive the same report from the stdout access log. Set
`LOG` to the log file (or `LOG="ssh <gateway-host> cat <path>"` and pipe).

## The field schema (what each log line carries)

Space-separated `key=value` pairs after `… info … request`. The ones this skill groups on:

- **identity:** `src.addr` (caller IP:port — network identity); `tailscale.node` /
  `tailscale.email` (if `extAuthz` is on); a virtual-key id (if key auth is on).
- **target:** `listener`, `route`, `http.host`, `http.path`.
- **action:** `protocol` (`mcp`|`llm`|`http`), `http.method`, `mcp.method.name`
  (`initialize`|`tools/list`|`tools/call`|…), `gen_ai.tool.name` (**the exact tool**),
  `mcp.target`, `mcp.resource.type`.
- **outcome:** `http.status`, `reason` + `error` (on failure), `duration` (ms).
- **cost (LLM):** `gen_ai.request.model` / `response.model`, `gen_ai.usage.input_tokens`,
  `output_tokens`, `cache_creation.input_tokens`, `cache_read.input_tokens`.

## Parse recipe (copy-paste, works on the real format)

(e.g. `LOG="ssh pico cat ~/Library/Logs/agentgateway.log"` and pipe.) Every request line
contains `http.status=`, so that's the reliable filter.

```bash
REQ() { grep -F 'http.status=' "$LOG"; }        # all request lines
# ---- volume + outcomes ----
REQ | grep -oE 'http\.status=[0-9]+'        | sort | uniq -c | sort -rn   # by status
REQ | grep -oE 'protocol=[a-z]+'            | sort | uniq -c              # by protocol
# ---- who (identity) ----
REQ | grep -oE 'src\.addr=[0-9.]+'          | sort | uniq -c | sort -rn   # by caller IP
REQ | grep -oE 'tailscale\.email=[^ ]+'     | sort | uniq -c              # by tailnet identity (if extAuthz)
# ---- what (method + tool) ----
REQ | grep -oE 'mcp\.method\.name=[^ ]+'    | sort | uniq -c | sort -rn   # by MCP method
REQ | grep -oE 'gen_ai\.tool\.name=[^ ]+'   | sort | uniq -c | sort -rn   # by TOOL invoked
# ---- errors (the important lines) — field-order-independent (agentgateway emits
#      error= before reason= on some lines, after on others, so extract each field) ----
REQ | grep -E 'http\.status=[45][0-9][0-9]' | while IFS= read -r l; do
  printf '%s\n' "$l" | grep -oE '(src\.addr=[^ ]+|http\.status=[0-9]+|reason=[^ ]+|error="[^"]*")' | paste -sd' ' -
done
# ---- latency (ms) ----
REQ | grep -oE 'duration=[0-9]+' | grep -oE '[0-9]+' | sort -n | awk '{a[NR]=$1} END{print "n="NR, "p50="a[int(NR*.5)], "p95="a[int(NR*.95)], "max="a[NR]}'
# ---- LLM token totals ----
REQ | grep -oE 'gen_ai\.usage\.input_tokens=[0-9]+'  | grep -oE '[0-9]+' | awk '{s+=$1} END{print "input_tokens="s}'
REQ | grep -oE 'gen_ai\.usage\.output_tokens=[0-9]+' | grep -oE '[0-9]+' | awk '{s+=$1} END{print "output_tokens="s}'
```

Cross-check against the aggregate counters (survives log rotation):

```bash
curl -s $STATS/metrics | grep -E 'agentgateway_(requests|mcp_requests)_total'
# agentgateway_mcp_requests_total{method="tools/call",resource="echo",server="everything",…} N
```

**The key join for hardening:** per identity, the set of `(route, mcp.method.name,
gen_ai.tool.name)` actually seen. That triple is what `/gateway-harden` turns into an
allowlist. Produce it explicitly:

```bash
REQ | grep -oE 'src\.addr=[0-9.]+.*(gen_ai\.tool\.name=[^ ]+|mcp\.method\.name=[^ ]+)' # then group per identity
```

## Report shape (source-agnostic)

Emit a compact markdown report (no preamble) — the same shape whichever source you used.
Source A's composite `sect` groups (`1_overview` … `6_latency`) map straight onto it:

```
# Gateway audit — <window> (<host>)
Totals: N calls · by protocol {mcp:.., llm:.., http:..} · statuses {200:.., 4xx:.., 5xx:..}

## By identity
- <identity> — N calls · routes {..} · top methods {..} · top tools {..} · errors: N

## Tools invoked   (the least-privilege surface)
- <route>: <tool> ×N · <tool> ×N …

## Errors
- <identity> → <status> <reason> "<error>" ×N   (cluster, don't list each)

## Latency
p50 / p95 / max ms   (+ any outliers by route)

## LLM cost (if any llm traffic)
model · input/output/cache tokens · $ (only if a cost catalog is set — else "tokens only; flat-rate = no $")

## Notes / anomalies
- <identity attribution gaps, short-window caveats, surprising tools, spikes>
```

## Cautions (anti-slop)

- **Report only what's logged.** Attribution is `src.addr` unless `extAuthz`/virtual
  keys are on. Don't invent per-agent identity that the log doesn't carry — say
  "network identity only" and point at the gap (`explore-0d06`).
- **Token observability ≠ cost.** On a flat-rate subscription you get token *counts*,
  not dollars (unless a `agctl costs` catalog is set). Never present tokens as spend.
- **State the window.** "0 errors" over 10 minutes is not "0 errors." Small samples
  under-represent the tail.
- **Read-only.** If a fix is warranted, hand the observed baseline to `/gateway-harden`
  — this skill never edits config or policy.

## Hands off to

`/gateway-harden` — feed it the "tools invoked / by identity" section; it proposes the
least-privilege CEL that allows exactly the observed surface and denies the rest.

## Reads / relates

- **Query foundation:** `refs/gateway-request-log-cookbook.md` — the verified DuckDB
  cookbook (schema, gotchas, per-metric queries) this skill's Source A composes from.
- **Sibling DB-backed skills** (same cookbook, different lens):
  `/gateway-cost` (token/cost accounting), `/gateway-watch` (near-real-time trend /
  volume-over-time), `/gateway-trace` (one request or session, end to end by `id`).
- **Field/authz reference:** `~/explore/agentgateway/refs/capability-map.md`.
