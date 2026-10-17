#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/brief.md" <<'BRIEF'
## Style
Warm ink illustration with a restrained palette.

## Scene
A small desk beside an open window.

## Choices
- desk object: folded map | ceramic mug | notebook
- weather: light rain | clear sky | low clouds
- viewpoint: above the desk | from the window | at desk height
BRIEF

"$repo_root/bin/image-round" plan "$tmp/brief.md" --out "$tmp/a" --n 3 --seed 0x1234 > "$tmp/plan.out"
"$repo_root/bin/image-round" plan "$tmp/brief.md" --out "$tmp/b" --n 3 --seed 0x1234 > /dev/null
cmp "$tmp/a/plan.json" "$tmp/b/plan.json"
printf 'PASS seeded plan is reproducible\n'

# Patch both external seams. Any dry-run network call or upload fails the test.
IMAGE_ROUND_TEST_DIR="$tmp/a" IMAGE_ROUND_SCRIPT="$repo_root/bin/image-round" python3 - <<'PY'
import importlib.machinery
import os
import sys
from argparse import Namespace
from pathlib import Path
from unittest.mock import patch

sys.dont_write_bytecode = True
module = importlib.machinery.SourceFileLoader("image_round", os.environ["IMAGE_ROUND_SCRIPT"]).load_module()
directory = os.environ["IMAGE_ROUND_TEST_DIR"]
with patch.object(module, "network_request", side_effect=AssertionError("network in dry-run")) as network:
    with patch.object(module, "cdn_upload", side_effect=AssertionError("upload in dry-run")) as upload:
        assert module.main(["render", directory]) == 0
        assert module.main(["pick", directory, "1", "--key", "aaif/test/og.png"]) == 0
        network.assert_not_called()
        upload.assert_not_called()
(Path(directory) / "index.html").write_text("stub", encoding="utf-8")
with patch.object(module.subprocess, "check_output", return_value="0.0.0.0\n"):
    with patch.object(module.subprocess, "run", side_effect=AssertionError("stage started")) as start:
        try:
            module.cmd_stage(Namespace(dir=Path(directory), port=18272))
        except ValueError:
            pass
        else:
            raise AssertionError("stage accepted 0.0.0.0")
        start.assert_not_called()
PY
printf 'PASS dry-run never calls network seams; stage refuses wildcard bind\n'

"$repo_root/bin/image-round" sheet "$tmp/a" > /dev/null
test -f "$tmp/a/index.html"
test -f "$tmp/a/candidate-01.png"
test -f "$tmp/a/candidate-01-og.png"
test -f "$tmp/a/candidate-02-og.png"
test -f "$tmp/a/candidate-03-og.png"
test -f "$tmp/a/log.jsonl"
printf 'PASS renders, log, contact sheet, and OG crops exist\n'

if "$repo_root/bin/image-round" render "$tmp/b" --live > "$tmp/live.out" 2>&1; then
    printf 'FAIL live render ran without --yes\n'; exit 1
fi
grep -Fq 'Estimated total: $0.21' "$tmp/live.out"
grep -Fq 'Stopped. Add --yes' "$tmp/live.out"
test ! -e "$tmp/b/log.jsonl"
if "$repo_root/bin/image-round" pick "$tmp/a" 1 --key aaif/test/og.png --live > "$tmp/pick-live.out" 2>&1; then
    printf 'FAIL live pick ran without --yes\n'; exit 1
fi
grep -Fq 'Estimated total:' "$tmp/pick-live.out"
grep -Fq 'Stopped. Add --yes' "$tmp/pick-live.out"
printf 'PASS live operations stop after cost estimate without --yes\n'

# Regression (aaif-ambassador-program-18o.54): a live response that carries its cost
# under usage.cost (no top-level cost) must still SAVE the paid image and log the cost.
"$repo_root/bin/image-round" plan "$tmp/brief.md" --out "$tmp/c" --n 1 --seed 0x1234 > /dev/null
IMAGE_ROUND_TEST_DIR="$tmp/c" IMAGE_ROUND_SCRIPT="$repo_root/bin/image-round" OPENROUTER_API_KEY=test-not-a-key python3 - <<'PY'
import base64
import importlib.machinery
import json
import os
import sys
from pathlib import Path
from unittest.mock import patch

sys.dont_write_bytecode = True
module = importlib.machinery.SourceFileLoader("image_round_live", os.environ["IMAGE_ROUND_SCRIPT"]).load_module()
directory = Path(os.environ["IMAGE_ROUND_TEST_DIR"])
png = module.placeholder_png(1)
live = {
    "choices": [{"message": {"images": [{"image_url": {"url": "data:image/png;base64," + base64.b64encode(png).decode()}}]}}],
    "usage": {"cost": 0.14},
}
with patch.object(module, "network_request", return_value=live) as network:
    assert module.main(["render", str(directory), "--live", "--yes"]) == 0
    assert network.call_count == 1
saved = directory / "candidate-01.png"
assert saved.exists() and saved.read_bytes() == png, "paid image was not saved"
rows = [json.loads(line) for line in (directory / "log.jsonl").read_text().splitlines()]
assert rows[-1]["cost"] == 0.14, rows[-1]
assert rows[-1]["dry_run"] is False
PY
printf 'PASS a live render with usage.cost is saved and its cost logged\n'
