#!/usr/bin/env bash
# SUBMISSIONS.jsonl (machine ledger) must agree with SUBMISSIONS.md (human face).
# Readers: consul's presence pillar (dotfiles-eoxfr) reads max(shipped).
set -euo pipefail
ROOT=$(cd "$(dirname "$0")/../.." && pwd)
python3 - "$ROOT/SUBMISSIONS.jsonl" "$ROOT/SUBMISSIONS.md" <<'PY'
import json, re, sys
rows = [json.loads(l) for l in open(sys.argv[1]) if l.strip()]
md = open(sys.argv[2]).read()
md_urls = set(re.findall(r'^\|[^\n]*?\| (https?://\S+) \|', md, re.M))
fail = 0
def bad(msg):
    global fail; fail += 1; print("FAIL", msg)
for r in rows:
    for k in ("shipped", "layer", "title", "url", "status", "points"):
        if k not in r: bad(f"{r.get('url')}: missing {k}")
    if not re.fullmatch(r'\d{4}-\d{2}-\d{2}', r.get("shipped") or ""): bad(f"{r['url']}: shipped not YYYY-MM-DD")
    if r.get("layer") not in ("ledger", "pulse"): bad(f"{r['url']}: layer")
    if r["url"] not in md_urls: bad(f"{r['url']}: in jsonl, not in SUBMISSIONS.md")
for u in md_urls - {r["url"] for r in rows}:
    bad(f"{u}: in SUBMISSIONS.md, not in jsonl")
if len(md_urls) == 0: bad("positive control: parsed 0 URLs from SUBMISSIONS.md")
print(f"rows={len(rows)} md_urls={len(md_urls)} latest_shipped={max(r['shipped'] for r in rows)}")
sys.exit(1 if fail else 0)
PY
