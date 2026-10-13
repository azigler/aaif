#!/usr/bin/env bash
# Positive-control runner for bin/pinki-audit.py (aaif-eecq).
# The fixture ledger makes EVERY metric nonzero at least once, so a zero from
# the real ledger means something. Also: missing ledger -> exit 2, --prev delta,
# --since window, and the ledger is never modified.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT="$HERE/../../bin/pinki-audit.py"
LEDGER="$HERE/ledger.jsonl"
NOW="2026-10-12T12:00:00Z"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass=0
fail=0
ok() { echo "PASS ($1)"; pass=$((pass + 1)); }
bad() { echo "FAIL ($1): $2"; fail=$((fail + 1)); }

# jq-free JSON probe: python expression over `s` (the snapshot)
jget() { python3 -c 'import json,sys; s=json.load(open(sys.argv[1])); print(eval(sys.argv[2]))' "$1" "$2"; }
check() { # name file expr want
  local got
  got=$(jget "$2" "$3")
  if [ "$got" = "$4" ]; then ok "$1"; else bad "$1" "want '$4' got '$got' for: $3"; fi
}

before=$(sha256sum "$LEDGER" | cut -d' ' -f1)

SNAP="$TMP/full.json"
OUT=$(python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --json "$SNAP" 2>&1)
rc=$?
if [ "$rc" -eq 0 ]; then ok "full run exit 0"; else bad "full run exit" "rc=$rc $OUT"; fi

# 1 totals + fixtures excluded
check "m1 promises_total" "$SNAP" "s['scalars']['promises_total']" 14
check "m1 fixture_promises" "$SNAP" "s['scalars']['fixture_promises']" 1
check "m1 live excludes fixtures" "$SNAP" "s['scalars']['promises_live']" 13
# 2 writer/seat outcomes (all four outcome kinds nonzero)
check "m2 writer promise-gap cancelled" "$SNAP" "s['by_writer']['promise-gap']['cancelled']" 2
check "m2 writer offboard satisfied" "$SNAP" "s['by_writer']['offboard']['satisfied']" 2
check "m2 writer manual released" "$SNAP" "s['by_writer']['manual']['released']" 1
check "m2 writer offboard OPEN" "$SNAP" "s['by_writer']['offboard']['OPEN']" 2
check "m2 seat alpha total" "$SNAP" "s['by_seat']['alpha']['total']" 4
# 3 molt cancelled (fixture molt row must not count)
check "m3 molt_cancelled" "$SNAP" "s['scalars']['molt_cancelled']" 2
check "m3 cancelled_total" "$SNAP" "s['scalars']['cancelled_total']" 3
check "m3 molt share" "$SNAP" "s['scalars']['molt_cancelled_share']" 0.6667
# 4 cancelled reads done (fixture reason 'done' must not count)
check "m4 cancelled_reads_done" "$SNAP" "s['scalars']['cancelled_reads_done']" 1
# 5 violated assessments
check "m5 violated_assessments" "$SNAP" "s['scalars']['violated_assessments']" 2
check "m5 violated_then_satisfied" "$SNAP" "s['scalars']['violated_then_satisfied']" 1
# 6 open + overdue + age
check "m6 open" "$SNAP" "s['scalars']['open']" 7
check "m6 amended_open" "$SNAP" "s['scalars']['amended_open']" 4
check "m6 open_overdue" "$SNAP" "s['scalars']['open_overdue']" 3
check "m6 forward amend is not overdue" "$SNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'pr-amend-forward')" False
check "m6 forward amend is current until" "$SNAP" "next(o['until'] for o in s['open_promises'] if o['id'] == 'pr-amend-forward')" 2026-10-12T13:00:00Z
check "m6 back amend is overdue" "$SNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'pr-amend-back')" True
check "m6 back amend is current until" "$SNAP" "next(o['until'] for o in s['open_promises'] if o['id'] == 'pr-amend-back')" 2026-10-12T11:00:00Z
check "m6 ledger order wins" "$SNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'pr-amend-order')" False
check "m6 ledger order until" "$SNAP" "next(o['until'] for o in s['open_promises'] if o['id'] == 'pr-amend-order')" 2026-10-12T14:00:00Z
check "m6 garbage last amend is not overdue (pinki fold)" "$SNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'pr-amend-garbage')" False
check "m6 garbage last amend is the until text" "$SNAP" "next(o['until'] for o in s['open_promises'] if o['id'] == 'pr-amend-garbage')" not-a-time
check "m6 oldest open age_h" "$SNAP" "s['open_promises'][0]['age_h']" 72.0
check "m6 oldest open id" "$SNAP" "s['open_promises'][0]['id']" pr-20261009-eeee
check "m6 text capped at 70" "$SNAP" "max(len(o['text']) for o in s['open_promises']) <= 70" True
check "m6 max overdue age" "$SNAP" "s['scalars']['open_overdue_max_age_h']" 72.0
# 7 duplicate open texts per seat (case + punctuation normalised)
check "m7 duplicate groups" "$SNAP" "s['scalars']['duplicate_open_groups']" 1
check "m7 duplicate count" "$SNAP" "s['duplicate_open_texts'][0]['count']" 2
# 8 refs (fixture ref must not count)
check "m8 with_ref" "$SNAP" "s['scalars']['with_ref']" 1
check "m8 with_ref_share" "$SNAP" "s['scalars']['with_ref_share']" 0.0769
# 9 nudged (fixture nudge must not count)
check "m9 nudged" "$SNAP" "s['scalars']['nudged']" 1
# 10 medians
check "m10 offboard horizon" "$SNAP" "s['medians_by_writer']['offboard']['horizon_min']" 60.0
check "m10 amended promises use declared horizon" "$SNAP" "s['medians_by_writer']['amend-test']['horizon_min']" 60.0
check "m10 offboard latency" "$SNAP" "s['medians_by_writer']['offboard']['latency_min']" 75.0
check "m10 promise-gap latency" "$SNAP" "s['medians_by_writer']['promise-gap']['latency_min']" 30.0
check "m10 manual latency" "$SNAP" "s['medians_by_writer']['manual']['latency_min']" 40.0
# 11 id lengths: more than one bucket
check "m11 id length buckets" "$SNAP" "len(s['id_length_distribution']) > 1" True
check "snapshot keys" "$SNAP" "all(k in s for k in ('generated_at','ledger','window','scalars'))" True

# human table mentions the headline metrics
for m in molt_cancelled amended_open open_overdue violated_then_satisfied; do
  if printf '%s' "$OUT" | grep -q "$m"; then ok "table shows $m"; else bad "table shows $m" "missing"; fi
done

# --since window
WIN="$TMP/win.json"
python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --since 2026-10-01T00:00:00Z --json "$WIN" > /dev/null
check "since drops the old promise" "$WIN" "s['scalars']['promises_total']" 13

# --prev delta
DOUT=$(python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --prev "$WIN" 2>&1)
if printf '%s' "$DOUT" | grep -qE '^promises_total +14 +\+1$'; then
  ok "prev delta column (+1)"
else
  bad "prev delta column" "$(printf '%s' "$DOUT" | head -8)"
fi
if printf '%s' "$DOUT" | grep -qE '^amended_open +4 +\+0$'; then
  ok "amended_open delta column (+0)"
else
  bad "amended_open delta column" "$(printf '%s' "$DOUT" | grep amended_open)"
fi
if printf '%s' "$OUT" | grep -qE '^metric +value +delta$'; then bad "no delta without --prev" "delta header present"; else ok "no delta without --prev"; fi

# missing ledger: exit 2 and names the path
MOUT=$(python3 "$AUDIT" --ledger "$TMP/nope.jsonl" 2>&1)
mrc=$?
if [ "$mrc" -eq 2 ] && printf '%s' "$MOUT" | grep -qF "$TMP/nope.jsonl"; then
  ok "missing ledger exits 2 and names path"
else
  bad "missing ledger" "rc=$mrc out=$MOUT"
fi

# read-only
after=$(sha256sum "$LEDGER" | cut -d' ' -f1)
if [ "$before" = "$after" ]; then ok "ledger unmodified"; else bad "ledger unmodified" "hash changed"; fi

echo "=== $pass passed, $fail failed ==="
if [ "$fail" -ne 0 ]; then
  echo "=== RESULT: FAIL ==="
  exit 1
fi
echo "=== RESULT: PASS ==="
exit 0
