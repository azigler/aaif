#!/usr/bin/env bash
# Negative-control runner for bin/radar-live-state-lint.py (aaif-1bw).
# Each bad-*.md fixture must exit 1 with a diagnostic containing the
# expected substring; good.md must exit 0.
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINT="$HERE/../../bin/radar-live-state-lint.py"
STORE="$HERE/issues.jsonl"

fail=0
run_case() {
  local name="$1" file="$2" want_rc="$3" want_substr="${4:-}"
  local out rc
  out=$(python3 "$LINT" --store "$STORE" --repo "$HERE" "$HERE/$file" 2>&1)
  rc=$?
  if [ "$rc" -ne "$want_rc" ]; then
    echo "FAIL ($name): expected exit $want_rc, got $rc"
    echo "$out"
    fail=1
    return
  fi
  if [ -n "$want_substr" ] && ! printf '%s' "$out" | grep -qF "$want_substr"; then
    echo "FAIL ($name): expected output to contain: $want_substr"
    echo "$out"
    fail=1
    return
  fi
  echo "PASS ($name): exit=$rc"
  printf '%s\n' "$out" | sed 's/^/    /'
}

run_case "bad-closed-as-ask" "bad-closed-as-ask.md" 1 "ask-vocabulary"
run_case "bad-wrong-tag" "bad-wrong-tag.md" 1 "tag disagrees with store"
run_case "bad-tombstone" "bad-tombstone.md" 1 "TOMBSTONE"
run_case "bad-unknown-id" "bad-unknown-id.md" 1 "unknown id"
run_case "good" "good.md" 0

if [ "$fail" -ne 0 ]; then
  echo "=== RESULT: FAIL ==="
  exit 1
fi
echo "=== RESULT: PASS ==="
exit 0
