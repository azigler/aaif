---
name: gateway-watch
description: "Near-real-time monitoring of an agentgateway fleet — a standing watch that stays quiet until a signal crosses a threshold, then emits one alert line per breach (suitable for a PushNotification). Watches for error-rate spikes (4xx/5xx surge), latency cliffs (p95 jump), token-rate blowout (tokens/min over budget), 429 rate-limit clusters, and a NEW/unexpected identity or model. Two mechanisms: a cheap streaming log-tail via the harness Monitor tool for per-event immediacy, and a periodic incremental DuckDB query over a fresh snapshot for aggregate thresholds. Read-only. Fire it to keep a live fleet under guard between one-shot /gateway-audit reports."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /gateway-watch — a standing guard on the fleet

`/gateway-audit` is a one-shot aggregate report: you run it, read it, move on.
`/gateway-watch` is the **ongoing** counterpart — a standing monitor that watches an
agentgateway's own surfaces continuously and **stays silent until something crosses a
threshold**, then emits exactly one alert line per breach. It never summarizes the
happy path; it interrupts you only when a signal moves.

This is a **guard against the token-blowout loop cost** (one of the harness's four
silent debts: an idle bug that runs all night) — and against its siblings: an
authz-storm 4xx spike, a latency cliff, an unexpected new caller. Read-only, always.

## When to fire

- **Stand a watch on a live fleet** — a demo, a duty cycle, an overnight batch you want
  guarded without babysitting the log.
- **Confirm a fix held** — after `/gateway-harden` tightens a policy, watch for new
  `reason=Authorization` 4xx clusters over a full duty cycle.
- **Catch a blowout early** — a runaway agent burning tokens, a crashloop, a rate-limit
  wall — before it becomes an all-night incident.
- **Escalate to the report** — when a breach fires, run `/gateway-audit` for the full
  aggregate picture of the window it fired in.

## Signals watched (each has a threshold; breach → alert)

| Signal | Breach when | Source |
|---|---|---|
| **error-rate spike** | 4xx/5xx share of recent window > N% | `http_status` |
| **latency cliff** | p95 of recent window jumps past a ceiling | `duration_ms` |
| **token-rate blowout** | tokens/min (or window total) over budget | `total_tokens` |
| **429 cluster** | any rate-limit responses in the window | `http_status=429` |
| **new identity / model** | an identity or model not in the prior baseline | `agentgateway_user` / `gen_ai_request_model` |

## Two mechanisms — and be honest about their cost

### (a) PRIMARY, high-frequency: tail the text access log with the Monitor tool

Per-event immediacy, essentially free — the access log is an append stream you grep, so
each breach line becomes a notification with no DB work. Point the harness **Monitor
tool** at the log through a filter that matches **failure signatures**, not the happy
path — *silence is not success*; a watch that only greps `http.status=200` stays quiet
right through a crashloop.

```bash
LOG=/path/to/agentgateway.log     # local sink, or: LOG via  ssh <gateway-host> tail -F …
# every line this passes is a breach worth a notification:
tail -F "$LOG" | grep --line-buffered -E \
  'http\.status=(4[0-9]{2}|5[0-9]{2})|reason=|error="|panic|level=(error|fatal)|connection refused|duration=[0-9]{5,}'
```

That one regex catches **per-request failures** (4xx/5xx, `reason=`, `error="`),
**process-level failures** (`panic`, `level=error|fatal`, `connection refused` — so a
dying gateway still emits lines instead of going ominously quiet), and a **coarse
latency cliff** (`duration=[0-9]{5,}` = ≥10 000 ms, five-plus digits). Verified against
sample lines: it passes the 429, the 403, the 55 027 ms slow call, and the
`connection refused` — and drops the fast 200s. Feed the same filter to Monitor as the
match pattern so each surviving line fires one notification.

### (b) PERIODIC, deeper: incremental DuckDB query on a 30s+ interval

Aggregate thresholds (rate %, p95, tokens/min, new-identity) need the structured DB, not
the log. **Cost caveat: do NOT `VACUUM INTO` a large DB every few seconds.** The snapshot
folds the WAL and copies the whole file (this sample is ~24 MB / 259 rows; a busy fleet's
is far bigger) — cheap once a minute, wasteful once a second. Reserve the DB check for a
**30s+ interval**; let the log tail carry per-event immediacy. Snapshot per the cookbook
(`refs/gateway-request-log-cookbook.md`), then query only rows past the last watermark:

```bash
SNAP=/tmp/reqsnap.db     # fresh consistent copy (VACUUM INTO; Pattern A/B in the cookbook)
```
```sql
LOAD sqlite;  -- INSTALL sqlite; first time
ATTACH '$SNAP' AS gw (TYPE sqlite, READ_ONLY);
-- $WM = the previous tick's high-water mark (max completed_at last seen)
WITH w AS (SELECT * FROM gw.request_logs WHERE completed_at > '$WM')
SELECT 'error_rate' signal, round(100.0*sum((http_status>=400)::INT)/count(*),1) val, '>5%' threshold
  FROM w HAVING val > 5
UNION ALL SELECT 'p95_latency_ms', round(quantile_cont(duration_ms,0.95)), '>30000' FROM w
  HAVING round(quantile_cont(duration_ms,0.95)) > 30000
UNION ALL SELECT 'tokens_total', sum(coalesce(total_tokens,0)), '>50000' FROM w
  HAVING sum(coalesce(total_tokens,0)) > 50000
UNION ALL SELECT 'rate_limit_429', count(*), '>0' FROM w WHERE http_status=429 HAVING count(*) > 0;
-- verified (window since 19:00): p95_latency_ms 52398 · tokens_total 238333 · rate_limit_429 3
-- (error_rate 1.3% was below 5% → correctly omitted; a clean tick returns 0 rows)
```

The query **returns only breaches** — a healthy tick is an empty result, nothing to
alert. Advance `$WM` to the new `max(completed_at)` each tick so work isn't re-counted.

**New identity / model** (an unexpected caller or model appearing) is an anti-join of the
recent window against everything before the watermark:

```sql
WITH recent AS (SELECT DISTINCT coalesce(nullif(agentgateway_user,''),
                 attributes_json->>'$.agent','unattributed') ident
               FROM gw.request_logs WHERE completed_at > '$WM'),
     baseline AS (SELECT DISTINCT coalesce(nullif(agentgateway_user,''),
                 attributes_json->>'$.agent','unattributed') ident
               FROM gw.request_logs WHERE completed_at <= '$WM')
SELECT r.ident AS new_identity FROM recent r LEFT JOIN baseline b USING (ident) WHERE b.ident IS NULL;
-- swap `ident` for gen_ai_request_model to watch for a new MODEL instead
-- verified: new-model form surfaced qwen2.5-coder:7b appearing after a mid-window watermark
```

## Alert shape (one line per breach)

Emit one terse line per breach — the real ones are `PushNotification`-worthy. No preamble,
no all-clear spam; a quiet watch means the fleet is within thresholds.

```
[gw-watch <host> HH:MM] <signal> BREACH: <val> (threshold <thr>) — <one-line context>
```
```
[gw-watch example-gw 21:41] rate_limit_429 BREACH: 3 (>0) — unkeyed → default/claude-agent
[gw-watch example-gw 21:41] p95_latency_ms BREACH: 52398 (>30000) — window since 19:00, n=158
[gw-watch example-gw 21:41] new_identity BREACH: an unseen caller appeared — run /gateway-audit
```

When a breach fires, the natural next step is `/gateway-audit` for the full window, then
`/gateway-harden` if the finding is an authz gap (an unexpected caller or tool).

## Cautions (anti-slop)

- **Silence must be earned, not assumed.** A filter that only matches the happy path is a
  broken watch — it will stay green through an outage. The tail regex above matches
  process-death and error signatures on purpose; keep them in.
- **Snapshot cost is real.** `VACUUM INTO` copies the whole DB. Per-event needs → log
  tail; aggregate thresholds → a **≥30s** DB tick. Never snapshot on a per-second loop.
- **Thresholds are claims — state the window and the number.** "p95 breach" means nothing
  without the ceiling and the window (`>30000ms, since 19:00, n=158`). A short window
  under-represents the tail; a first tick has no baseline, so *every* identity looks
  "new" — seed the baseline from a prior audit before trusting new-identity alerts.
- **`cost` is NULL on flat-rate/local setups** — watch **tokens/min**, never fabricated
  dollars (cookbook gotcha). Token counts are the budget signal, not spend.
- **Read-only, never write.** DuckDB attaches `READ_ONLY` against a *copy*; the watch
  observes and alerts. It proposes no change — remediation is a human running
  `/gateway-harden`.
- **Never surface payload content.** Alerts carry identity / route / status / counts
  only. `request_log_payloads` prompts and completions are off-limits in any alert line.

## Reads / relates

- Query foundation (verified schema + snapshot patterns + gotchas):
  `refs/gateway-request-log-cookbook.md` — the single source of query truth; compose, don't invent columns.
- One-shot sibling: `/gateway-audit` (the aggregate report a breach escalates to).
- Remediation: `/gateway-harden` (observed surface → least-privilege CEL, human-gated).
- Loop-cost lens: the harness's four loop costs — token blowout is the one a watch guards.
- Field/authz reference: `~/explore/agentgateway/refs/capability-map.md`.
