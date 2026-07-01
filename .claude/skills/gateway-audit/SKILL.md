---
name: gateway-audit
description: "Answer 'what did my agent fleet actually do?' from an agentgateway deployment's own access log + Prometheus metrics — no external o11y backend. Groups every call by identity, route, method, and tool; clusters errors; sums tokens/cost for LLM traffic; surfaces anomalies. Read-only. The foundation the hardening skill (/gateway-harden) derives least-privilege policy from. Fire it to review fleet behavior, investigate a spike, or produce the observed-behavior baseline before tightening authz."
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

## Inputs

| Input | Where | Notes |
|---|---|---|
| **Access log** (primary) | the gateway's stdout/stderr sink | e.g. pico: `~/Library/Logs/agentgateway.log` (tail via `ssh pico`). One `info … request …` line per call. |
| **Prometheus metrics** (cross-check) | `statsAddr`, e.g. `localhost:15020/metrics` | aggregate counters; use to sanity-check the log-derived totals and for rates over time. |
| **Time window** (optional) | — | default: whole log. Narrow with a timestamp filter; **always state the window in the report** — a short window is a partial picture. |
| **`agctl proxy`** (optional) | admin API | live route/backend state, to name what the traffic hit. |

Ground the field meanings in the **capability map**
(`~/explore/agentgateway/refs/capability-map.md`) — the authoritative per-field inventory.

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

Set `LOG` to the log (or `LOG="ssh pico cat ~/Library/Logs/agentgateway.log"` and pipe).
Every request line contains `http.status=`, so that's the reliable filter.

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

## Report shape

Emit a compact markdown report (no preamble):

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
