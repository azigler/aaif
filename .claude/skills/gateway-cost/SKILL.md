---
name: gateway-cost
description: "Answer 'what did the fleet cost?' from an agentgateway request-log DB — token accounting in totals, per-identity, per-model, and per-day, plus cache economics (cache_read vs cache_creation), and dollars ONLY when the rows are actually priced. Tokens are not dollars: on subscription / flat-rate / local setups the cost column is NULL, so this reports tokens-only and says so. Read-only, over a snapshot; never touches the live DB and never reads payloads. Fire it to size token spend, find the token-heavy identity/model, or check whether prompt caching is actually saving you input tokens."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /gateway-cost — what did the fleet cost?

agentgateway persists every LLM call it proxies to a SQLite request-log DB with
`input_tokens` / `output_tokens` / `total_tokens`, the cache-token detail inside
`attributes_json`, and a `cost` column that is populated **only when a cost catalog
prices the model**. This skill turns that store into an honest **cost report**: the
token bill by identity, model, and day; the cache-read-vs-creation economics that
actually move that bill; and dollars **only when the rows carry a price**.

The honesty is the point. On a subscription, a flat-rate plan, or local models the
`cost` column is `NULL` — you get exact **token counts**, not spend. This skill shows
`$` only when `count(cost) > 0`, and otherwise reports tokens-only and names why.
It is **read-only** over a consistent snapshot, and it never needs payloads — all
accounting lives in the aggregate `request_logs` table.

## When to fire

- **Size the bill** — "how many tokens did the fleet burn this week, and where?"
- **Find the heavy hitter** — which identity or model dominates input/output tokens.
- **Check cache economics** — is prompt caching actually saving input tokens, or are
  you re-paying to create cache entries you never read back?
- **Answer "how much in dollars?"** — with the honest tokens-only answer when unpriced.

## Source (snapshot, read-only)

Same SQLite-write / DuckDB-read split as the rest of the gateway skills — see
`refs/gateway-request-log-cookbook.md` for the full snapshot recipe. Never query the
file the gateway is writing; snapshot a consistent copy, then attach it read-only:

```bash
GW_DB=/absolute/path/requests.db            # what agentgateway writes (never queried live)
SNAP=/tmp/reqsnap.db                         # consistent read copy
sqlite3 "$GW_DB" "VACUUM INTO '$SNAP'"       # local; folds the WAL, never blocks the writer
# remote gateway: ssh <gateway-host> "sqlite3 <db> 'VACUUM INTO /tmp/reqsnap.db'" && scp <gateway-host>:/tmp/reqsnap.db "$SNAP"
```

Attach once (DuckDB `$HOME/.local/bin/duckdb`); every query below assumes `gw`:

```sql
INSTALL sqlite; LOAD sqlite;   -- INSTALL only the first time
ATTACH '/tmp/reqsnap.db' AS gw (TYPE sqlite, READ_ONLY);
```

> Reserved-word trap: `identity`, `day`, `rows` are DuckDB keywords — always alias
> them with the explicit `AS` (`… AS identity`), never as a bare trailing alias.

## The queries (composed from the cookbook, verified against a live snapshot)

**Grand totals + cache economics + pricing status** — one row that decides `$`-vs-tokens:

```sql
SELECT count(*) AS calls,
       sum(coalesce(input_tokens,0))  AS in_tok,
       sum(coalesce(output_tokens,0)) AS out_tok,
       sum(coalesce(total_tokens,0))  AS tot_tok,
       sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_read.input_tokens"')::BIGINT,0))     AS cache_read,
       sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_creation.input_tokens"')::BIGINT,0)) AS cache_create,
       count(cost) AS rows_priced, coalesce(sum(cost),0) AS dollars
FROM gw.request_logs;
-- verified: calls 259 · in 89726 · out 148607 · cache_read 9,363,773 · cache_create 1,443,406 · rows_priced 0 · $0
```

**By identity** (NULL-safe; column first, `agent` attribute fallback):

```sql
SELECT coalesce(nullif(agentgateway_user,''), attributes_json->>'$.agent', 'unattributed') AS identity,
       count(*) AS calls, sum(coalesce(input_tokens,0)) AS in_tok,
       sum(coalesce(output_tokens,0)) AS out_tok, sum(coalesce(total_tokens,0)) AS tot_tok,
       count(cost) AS priced
FROM gw.request_logs GROUP BY identity ORDER BY tot_tok DESC;
-- verified: unkeyed 244 calls / 235,380 tok · goose 15 calls / 2,953 tok · priced 0
```

**By model** (with per-model cache split). When `rows_priced > 0`, add
`coalesce(sum(cost),0) AS dollars` to this select for a per-model spend column:

```sql
SELECT coalesce(gen_ai_request_model,'(none)') AS model, count(*) AS calls,
       sum(coalesce(input_tokens,0)) AS in_tok, sum(coalesce(output_tokens,0)) AS out_tok,
       sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_read.input_tokens"')::BIGINT,0))     AS cache_read,
       sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_creation.input_tokens"')::BIGINT,0)) AS cache_create,
       count(cost) AS priced
FROM gw.request_logs GROUP BY model ORDER BY calls DESC;
-- verified: claude-opus-4-8 244 (cache_read 9.36M) · qwen3:8b 12 · qwen2.5-coder:7b 2 · qwen3-coder:30b 1 · all priced 0
```

**By day trend** (use `date_trunc('hour', …)` for short windows):

```sql
SELECT date_trunc('day', completed_at::TIMESTAMPTZ)::DATE AS day, count(*) AS calls,
       sum(coalesce(input_tokens,0)) AS in_tok, sum(coalesce(output_tokens,0)) AS out_tok,
       sum(coalesce(total_tokens,0)) AS tot_tok
FROM gw.request_logs GROUP BY day ORDER BY day;
-- verified (2h window = one day row): 2026-07-03 · 259 calls · 238,333 tok
```

**Cache efficiency** — the story that moves the bill: what fraction of input tokens
were cheap cache reads instead of fresh input:

```sql
WITH c AS (
  SELECT sum(coalesce(input_tokens,0)) AS fresh_in,
         sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_read.input_tokens"')::BIGINT,0))     AS cache_read,
         sum(coalesce((attributes_json->>'$."gen_ai.usage.cache_creation.input_tokens"')::BIGINT,0)) AS cache_create
  FROM gw.request_logs)
SELECT fresh_in, cache_create, cache_read,
       round(100.0*cache_read/nullif(cache_read+fresh_in,0),1) AS cache_read_pct_of_input
FROM c;
-- verified: fresh 89,726 · cache_create 1,443,406 · cache_read 9,363,773 · 99.1% of input served from cache
```

**Dollars — only when priced.** Read `rows_priced` from the totals query. If it is `0`
(verified here — the whole snapshot is unpriced), STOP at tokens: report tokens-only and
do not compute or fabricate spend. If `> 0`, the `dollars` columns above are real spend.

## Report shape

Emit a compact markdown block (no preamble). State the window; lead with tokens;
show `$` only when priced:

```
# Gateway cost — <window> (<host>)
Totals: N calls · in <in_tok> / out <out_tok> / total <tot_tok> tok
Pricing: <k>/<N> rows priced — <"$X.XX" if k>0 else "unpriced (subscription/flat-rate/local) → tokens only">

## By identity   <identity> — <tot_tok> tok (in/out) · <k> priced
## By model      <model> — N calls · <tot_tok> tok · cache_read <n> · <$ or —>
## By day/hour   <bucket> — N calls · <tot_tok> tok   (a trend, not one number)
## Cache         fresh <in> · created <cc> · read <cr> — <pct>% of input from cache
                 (high read% = caching pays off; high create% + low read% = re-paying, not saving)
## $ / tokens    <if unpriced> tokens are exact; dollars NULL (no cost catalog). Add a
                 catalog to populate `cost`, then re-run for spend.
```

## Cautions (anti-slop)

- **Tokens are not dollars.** The `cost` column is `NULL` on subscription / flat-rate /
  local setups (verified: `rows_priced 0`). Never present token counts as spend. Show
  `$` only when `count(cost) > 0`; otherwise say "tokens only" and name why. A **cost
  catalog** is what populates `cost` — that's the fix, not a guessed price.
- **NULL-safe every sum.** Failed calls and some local-model rows carry NULL tokens;
  wrap every `sum()` over a token column in `coalesce(…,0)` so one NULL can't void the total.
- **Cache tokens live in `attributes_json`, not columns.** `cache_read` / `cache_creation`
  come from the JSON usage keys; a report that ignores them undercounts the input story
  (in the verified window, cache reads were ~99% of all input tokens).
- **State the window.** A two-hour snapshot is not a month. Report
  `min(started_at) .. max(completed_at)` and don't extrapolate a bill from a sliver.
- **Read-only, no payloads.** Attach `READ_ONLY` over a `VACUUM INTO` snapshot; cost
  accounting never needs `request_log_payloads`. Stay in the aggregate table.

## Reads / relates

- Query foundation (schema, gotchas, snapshot recipe): `refs/gateway-request-log-cookbook.md`.
- Sibling skills: `/gateway-audit` (aggregate behavior + errors + latency),
  `/gateway-harden` (observed surface → least-privilege CEL). Feed a token blowout
  spotted here into `/gateway-audit` to see which calls drove it.
