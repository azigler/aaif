#!/usr/bin/env bash
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
rig="$here/rig"
run_dir="${TMPDIR:-/tmp}/tutorial-rig-$(id -u)"
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/tutorial-rig-test.XXXXXX")
cleanup() {
  if [[ -f "$run_dir/state.json" ]]; then "$rig" down || true; fi
  rm -rf -- "$test_dir"
}
trap cleanup EXIT

until awk '{exit !($1 < 24)}' /proc/loadavg; do sleep 60; done

"$rig" up "$here/examples/rig.yaml"
"$rig" drive "$here/examples/steps.yaml"
"$rig" shoot "$here/examples/shots.yaml"
"$rig" cards "$here/examples/cards"
"$rig" scrub "$run_dir/cards" "$here/examples/terms.txt"

mkdir "$test_dir/planted"
cat > "$test_dir/planted/planted.html" <<'HTML'
<!doctype html><html><head><style>body{margin:0}#card{width:1200px;padding:70px;font:bold 64px Arial,sans-serif}</style></head>
<body><div id="card">PLANTED SECRET</div></body></html>
HTML
printf 'PLANTED SECRET\n' > "$test_dir/planted-terms.txt"
"$rig" cards "$test_dir/planted"
if "$rig" scrub "$run_dir/cards" "$test_dir/planted-terms.txt" > "$test_dir/scrub.out" 2>&1; then
  echo "test failed: planted term passed scrub" >&2
  exit 1
fi
if ! grep -F 'term '\''PLANTED SECRET'\''' "$test_dir/scrub.out"; then
  echo "test failed: scrub did not name the planted term" >&2
  cat "$test_dir/scrub.out" >&2
  exit 1
fi

python3 - "$run_dir/state.json" > "$test_dir/ports" <<'PY'
import json, sys
print(*json.load(open(sys.argv[1]))['ports'].values())
PY
"$rig" down
python3 - "$test_dir/ports" <<'PY'
import re, subprocess, sys
expected = set(map(int, open(sys.argv[1]).read().split()))
result = subprocess.run(['ss', '-ltnH'], capture_output=True, text=True, check=True)
actual = set()
for line in result.stdout.splitlines():
    parts = line.split()
    if len(parts) >= 4:
        match = re.search(r':(\d+)$', parts[3])
        if match:
            actual.add(int(match.group(1)))
assert not expected & actual, f'ports still open: {expected & actual}'
print('test passed: all rig ports closed')
PY
