#!/usr/bin/env bash
# Positive-control runner for bin/pinki-audit.py (aaif-eecq).
# The fixture ledger makes EVERY metric nonzero at least once, so a zero from
# the real ledger means something. Also: missing ledger -> exit 2, --prev delta,
# --since window, and the ledger is never modified.
set -u
export PYTHONDONTWRITEBYTECODE=1

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT="${PINKI_AUDIT_BIN:-$HERE/../../bin/pinki-audit.py}"
LEDGER="$HERE/ledger.jsonl"
NOW="2026-10-12T12:00:00Z"
mkdir -p "$HERE/../../.local"
TMP="$(mktemp -d "$HERE/../../.local/pinki-audit-test.XXXXXXXX")"
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
global_before=$(sha256sum "$HERE/ledger-global.jsonl" | cut -d' ' -f1)

SNAP="$TMP/full.json"
OUT=$(python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --json "$SNAP" 2>&1)
rc=$?
if [ "$rc" -eq 0 ]; then ok "full run exit 0"; else bad "full run exit" "rc=$rc $OUT"; fi

# 1 totals + fixtures excluded
check "m1 promises_total" "$SNAP" "s['scalars']['promises_total']" 19
check "m1 fixture_promises" "$SNAP" "s['scalars']['fixture_promises']" 1
check "m1 live excludes fixtures" "$SNAP" "s['scalars']['promises_live']" 18
check "m1 direct_cli_promises" "$SNAP" "s['scalars']['direct_cli_promises']" 1
# 2 writer/seat outcomes (all five resolved outcomes and OPEN are nonzero)
check "m2 writer promise-gap cancelled" "$SNAP" "s['by_writer']['promise-gap']['cancelled']" 2
check "m2 writer offboard satisfied" "$SNAP" "s['by_writer']['offboard']['satisfied']" 2
check "m2 writer manual released" "$SNAP" "s['by_writer']['manual']['released']" 1
check "m2 writer offboard OPEN" "$SNAP" "s['by_writer']['offboard']['OPEN']" 2
check "m2 seat alpha total" "$SNAP" "s['by_seat']['alpha']['total']" 4
check "m2 corrected outcome uses latest authorized correction" "$SNAP" "s['by_writer']['fold-test']['satisfied']" 1
check "m2 writer lapsed" "$SNAP" "s['by_writer']['fold-test']['lapsed']" 1
check "m2 writer refused" "$SNAP" "s['by_writer']['fold-test']['refused']" 1
check "m2 seat lapsed" "$SNAP" "s['by_seat']['epsilon']['lapsed']" 1
check "m2 seat refused" "$SNAP" "s['by_seat']['epsilon']['refused']" 1
check "m2 JSON has every outcome column" "$SNAP" "all(all(outcome in row for outcome in ('satisfied','cancelled','released','lapsed','refused','OPEN')) for table in ('by_writer','by_seat') for row in s[table].values())" True
check "m2 pnk id without writer is pinki-cli" "$SNAP" "s['by_writer']['pinki-cli']['satisfied']" 1
check "m2 other id without writer is unknown" "$SNAP" "s['by_writer']['unknown']['satisfied']" 1
# 3 molt cancelled (fixture molt row must not count)
check "m3 molt_cancelled" "$SNAP" "s['scalars']['molt_cancelled']" 2
check "m3 cancelled_total" "$SNAP" "s['scalars']['cancelled_total']" 3
check "m3 molt share" "$SNAP" "s['scalars']['molt_cancelled_share']" 0.6667
# 4 cancelled reads done (fixture reason 'done' must not count)
check "m4 cancelled_reads_done" "$SNAP" "s['scalars']['cancelled_reads_done']" 1
# 5 violated assessments
check "m5 violated_assessments" "$SNAP" "s['scalars']['violated_assessments']" 2
check "m5 violated_then_satisfied" "$SNAP" "s['scalars']['violated_then_satisfied']" 1
check "m5 superseded violation excluded" "$SNAP" "'pr-correct' not in s['violated_promise_ids'] and 'pr-correct' not in s['violated_then_satisfied_ids']" True
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
check "m8 with_ref_share" "$SNAP" "s['scalars']['with_ref_share']" 0.0556
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
for m in molt_cancelled amended_open open_overdue violated_then_satisfied direct_cli_promises; do
  if printf '%s' "$OUT" | grep -q "$m"; then ok "table shows $m"; else bad "table shows $m" "missing"; fi
done
if printf '%s' "$OUT" | grep -qE '^  name +total +satisfied +cancelled +released +lapsed +refused +OPEN +expired$'; then
  ok "text tables show lapsed and refused columns"
else
  bad "text tables show lapsed and refused columns" "missing"
fi
if printf '%s' "$OUT" | grep -qE '^  pinki-cli +1 +1 ' && printf '%s' "$OUT" | grep -qE '^  unknown +1 +1 '; then
  ok "text writer table shows pinki-cli and unknown"
else
  bad "text writer table shows pinki-cli and unknown" "missing"
fi
if printf '%s' "$OUT" | grep -qF 'move a past deadline forward'; then
  bad "render omits promise text" "open promise text found"
else
  ok "render omits promise text"
fi

# --since window
WIN="$TMP/win.json"
python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --since 2026-10-01T00:00:00Z --json "$WIN" > /dev/null
check "since drops the old promise" "$WIN" "s['scalars']['promises_total']" 18

# --prev delta
DOUT=$(python3 "$AUDIT" --ledger "$LEDGER" --now "$NOW" --prev "$WIN" 2>&1)
if printf '%s' "$DOUT" | grep -qE '^promises_total +19 +\+1$'; then
  ok "prev delta column (+1)"
else
  bad "prev delta column" "$(printf '%s' "$DOUT" | head -8)"
fi
if printf '%s' "$DOUT" | grep -qE '^amended_open +4 +\+0$'; then
  ok "amended_open delta column (+0)"
else
  bad "amended_open delta column" "$(printf '%s' "$DOUT" | grep amended_open)"
fi
if printf '%s' "$DOUT" | grep -qE '^direct_cli_promises +1 +\+0$'; then
  ok "direct_cli_promises delta column (+0)"
else
  bad "direct_cli_promises delta column" "$(printf '%s' "$DOUT" | grep direct_cli_promises)"
fi
if printf '%s' "$OUT" | grep -qE '^metric +value +delta$'; then bad "no delta without --prev" "delta header present"; else ok "no delta without --prev"; fi

# `on` antecedents (aaif-rsi.26): pinki computes a promise whose antecedent ended
# unsatisfied as "expired" (terminal), so it is neither open nor overdue. A
# satisfied antecedent leaves the dependent owed (open, and overdue once late).
# Only an owed promise can be late: a conditional one never is. The fixture
# ledger-on.jsonl is checked against ~/pinki/src/state.rs, not against a guess.
ONSNAP="$TMP/on.json"
python3 "$AUDIT" --ledger "$HERE/ledger-on.jsonl" --now "$NOW" --json "$ONSNAP" > "$TMP/on.txt" 2>&1
check "on open excludes expired" "$ONSNAP" "s['scalars']['open']" 6
check "on open_overdue excludes expired" "$ONSNAP" "s['scalars']['open_overdue']" 2
check "on expired count" "$ONSNAP" "s['scalars']['expired']" 3
check "on cancelled antecedent expires its dependent" "$ONSNAP" "'on-dep-cancel' not in [o['id'] for o in s['open_promises']]" True
check "on expiry is transitive" "$ONSNAP" "'on-dep-chain' not in [o['id'] for o in s['open_promises']]" True
check "on fixture antecedent still expires its dependent" "$ONSNAP" "'on-dep-fixture' not in [o['id'] for o in s['open_promises']]" True
check "on resolved dependent stays resolved" "$ONSNAP" "'on-dep-resolved' not in [o['id'] for o in s['open_promises']] and s['by_writer']['on-test']['satisfied'] == 2" True
check "on satisfied antecedent leaves dependent open" "$ONSNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'on-dep-ok')" True
check "on unresolved antecedent: dependent open, not overdue" "$ONSNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'on-dep-wait')" False
check "on unknown antecedent: dependent open, not overdue" "$ONSNAP" "next(o['overdue'] for o in s['open_promises'] if o['id'] == 'on-dep-unknown')" False
check "on cycle: both conditional, open, not overdue" "$ONSNAP" "[o['overdue'] for o in s['open_promises'] if o['id'].startswith('on-cycle')]" "[False, False]"
check "on overdue ids" "$ONSNAP" "sorted(o['id'] for o in s['open_promises'] if o['overdue'])" "['on-ante-open', 'on-dep-ok']"
check "on max overdue age ignores expired" "$ONSNAP" "s['scalars']['open_overdue_max_age_h']" 59.2
check "on writer OPEN column excludes expired" "$ONSNAP" "s['by_writer']['on-test']['OPEN']" 6
check "on writer expired column" "$ONSNAP" "s['by_writer']['on-test']['expired']" 3
check "on seat theta total keeps expired rows" "$ONSNAP" "s['by_seat']['theta']['total']" 9
# --since drops the antecedent from the window but pinki still sees it
python3 "$AUDIT" --ledger "$HERE/ledger-on.jsonl" --now "$NOW" --since 2026-10-10T00:05:00Z --json "$TMP/on-win.json" > /dev/null
check "on out-of-window antecedent still expires dependent" "$TMP/on-win.json" "s['scalars']['expired']" 3

# Global lists use a separate fixture so all earlier metric totals stay fixed.
GLOBAL="$TMP/global.json"
GOUT=$(python3 "$AUDIT" --ledger "$HERE/ledger-global.jsonl" --now "$NOW" --json "$GLOBAL" 2>&1)
if [ "$?" -eq 0 ]; then ok "global run exit 0"; else bad "global run exit" "$GOUT"; fi
check "global lapsed count" "$GLOBAL" "s['scalars']['global_lapsed']" 3
check "global lapsed ids" "$GLOBAL" "sorted(r['id'] for r in s['global']['lapsed']['rows'])" "['g-lapsed', 'g-watchdog-lapsed', 'g-watchdog-resolved']"
check "global resolve lapse fields" "$GLOBAL" "[(r['lapse_ts'],r['lapse_source'],r['later_outcome']) for r in s['global']['lapsed']['rows'] if r['id']=='g-lapsed']" "[('2026-10-09T10:00:00Z', 'resolve', None)]"
check "global watchdog lapse stays open" "$GLOBAL" "[(r['lapse_ts'],r['lapse_source'],r['later_outcome'],r['outcome_or_state']) for r in s['global']['lapsed']['rows'] if r['id']=='g-watchdog-lapsed']" "[('2026-10-11T00:00:00Z', 'watchdog', None, 'owed')]"
check "global watchdog lapse later outcome" "$GLOBAL" "[(r['lapse_source'],r['later_outcome']) for r in s['global']['lapsed']['rows'] if r['id']=='g-watchdog-resolved']" "[('watchdog', 'satisfied')]"
check "global superseded watchdog lapse excluded" "$GLOBAL" "'g-watchdog-superseded' not in [r['id'] for r in s['global']['lapsed']['rows']] and 'g-watchdog-lapsed' in [r['id'] for r in s['global']['lapsed']['rows']]" True
check "global chronic count" "$GLOBAL" "s['scalars']['global_chronically_extended']" 1
check "global chronic id and fields" "$GLOBAL" "[(r['id'],r['amends_total'],r['amends_watchdog'],r['slip_hours'],r['open_or_terminal']) for r in s['global']['chronically_extended']['rows']]" "[('g-chronic', 3, 0, 300.0, 'open')]"
check "global chronic ignores watchdog amend" "$GLOBAL" "'g-mixed-amends' not in [r['id'] for r in s['global']['chronically_extended']['rows']]" True
check "global two amends excluded" "$GLOBAL" "'g-two-amends' not in [r['id'] for r in s['global']['chronically_extended']['rows']]" True
check "global unresolvable count" "$GLOBAL" "s['scalars']['global_unresolvable']" 2
check "global unresolvable ids" "$GLOBAL" "sorted(r['id'] for r in s['global']['unresolvable']['rows'])" "['g-stale', 'g-watchdog-lapsed']"
check "global 71h excluded" "$GLOBAL" "'g-near71' not in [r['id'] for r in s['global']['unresolvable']['rows']]" True
check "global exactly 72h excluded" "$GLOBAL" "'g-exact72' not in [r['id'] for r in s['global']['unresolvable']['rows']] and 'g-watchdog-lapsed' in [r['id'] for r in s['global']['unresolvable']['rows']]" True
check "global seat assess excludes unresolvable" "$GLOBAL" "'g-seat-assess' not in [r['id'] for r in s['global']['unresolvable']['rows']] and 'g-watchdog-lapsed' in [r['id'] for r in s['global']['unresolvable']['rows']]" True
check "global post-until amend excluded" "$GLOBAL" "'g-after-amend' not in [r['id'] for r in s['global']['unresolvable']['rows']]" True
check "global owed zig count" "$GLOBAL" "s['scalars']['global_owed_to_zig']" 3
check "global owed zig ids" "$GLOBAL" "sorted(r['id'] for r in s['global']['owed_to_zig']['rows'])" "['g-lapsed', 'g-zig-done', 'g-zig-open']"
check "global human adam excluded" "$GLOBAL" "'g-adam' not in [r['id'] for r in s['global']['owed_to_zig']['rows']]" True
check "global zig outcome counts removed" "$GLOBAL" "'outcome_counts' not in s['global']['owed_to_zig']" True
check "global zig open count" "$GLOBAL" "s['global']['owed_to_zig']['open_count']" 1
check "global zig resolved by outcome" "$GLOBAL" "s['global']['owed_to_zig']['resolved_by_outcome']['lapsed'] == 1 and s['global']['owed_to_zig']['resolved_by_outcome']['satisfied'] == 1" True
check "global per-seat counts" "$GLOBAL" "s['global']['owed_to_zig']['by_seat']" "{'alpha': 2, 'delta': 1}"
check "global no promise texts" "$GLOBAL" "all('text' not in r and 'promise' not in r for c in s['global'].values() for r in c['rows'])" True
for class in lapsed chronically_extended unresolvable owed_to_zig; do
  if printf '%s' "$GOUT" | grep -q "global $class"; then ok "global text table $class"; else bad "global text table $class" "missing"; fi
done

# Previous snapshot from a time cut of the same fixture ledger. The late
# watchdog assessment creates a new lapse; later declarations add Zig rows.
python3 -B - "$HERE/ledger-global.jsonl" "$TMP/global-prev-ledger.jsonl" <<'PY'
import json, sys
from datetime import datetime
cut = datetime.fromisoformat('2026-10-10T12:00:00+00:00')
with open(sys.argv[1], encoding='utf-8') as source, open(sys.argv[2], 'w', encoding='utf-8') as target:
    for line in source:
        row = json.loads(line)
        if datetime.fromisoformat(row['ts'].replace('Z', '+00:00')) <= cut:
            target.write(line)
PY
python3 -B "$AUDIT" --ledger "$TMP/global-prev-ledger.jsonl" --now 2026-10-10T12:00:00Z --json "$TMP/global-prev.json" > "$TMP/global-prev.txt" 2>&1
python3 -B "$AUDIT" --ledger "$HERE/ledger-global.jsonl" --now "$NOW" --prev "$TMP/global-prev.json" --json "$TMP/global-delta.json" > "$TMP/global-delta.txt" 2>&1
check "global new lapse since prev" "$TMP/global-delta.json" "s['global']['lapsed']['new_since_prev']" "['g-watchdog-lapsed']"
check "global new zig ids since prev" "$TMP/global-delta.json" "sorted(s['global']['owed_to_zig']['new_since_prev'])" "['g-zig-done', 'g-zig-open']"
check "global prior count and delta render" "$TMP/global-delta.json" "(s['global']['lapsed']['count'],s['global']['lapsed']['prev_count'])" "(3, 2)"
if grep -qE '^global lapsed +now=3 +prev=2 +new=g-watchdog-lapsed' "$TMP/global-delta.txt"; then ok "global delta render"; else bad "global delta render" "missing"; fi

CUSTOM="$TMP/custom.json"
python3 "$AUDIT" --ledger "$HERE/ledger-global.jsonl" --now "$NOW" --chronic-amends 2 --stale-hours 70 --json "$CUSTOM" > "$TMP/custom.txt" 2>&1
check "global chronic flag threshold" "$CUSTOM" "s['scalars']['global_chronically_extended']" 3
check "global stale flag threshold" "$CUSTOM" "s['scalars']['global_unresolvable']" 4
check "global stale flag still excludes post-until amend" "$CUSTOM" "'g-after-amend' not in [r['id'] for r in s['global']['unresolvable']['rows']]" True

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
global_after=$(sha256sum "$HERE/ledger-global.jsonl" | cut -d' ' -f1)
if [ "$global_before" = "$global_after" ]; then ok "global ledger unmodified"; else bad "global ledger unmodified" "hash changed"; fi

echo "=== $pass passed, $fail failed ==="
if [ "$fail" -ne 0 ]; then
  echo "=== RESULT: FAIL ==="
  exit 1
fi
echo "=== RESULT: PASS ==="
exit 0
