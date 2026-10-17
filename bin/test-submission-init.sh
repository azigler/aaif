#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
export SUBMISSIONS_ROOT="$tmp/submissions"
target=$SUBMISSIONS_ROOT/2026-10-example-piece

"$repo_root/bin/submission-init" 2026-10 example-piece --title 'Example "piece"'
for file in README.md PUBLISH.md AAIF-REVIEW.md AMPLIFY.md NOTES.md gates.sh images/.gitkeep screenshots/.gitkeep; do
  test -f "$target/$file" || { printf 'FAIL missing %s\n' "$file"; exit 1; }
done
test -x "$target/gates.sh"
grep -Fq 'title: "Example \"piece\""' "$target/PUBLISH.md"
grep -Fq 'published: "YYYY-MM-DD"' "$target/PUBLISH.md"
printf 'PASS stamped files, executable gate, and publish placeholders\n'
if bash "$target/gates.sh" > "$tmp/gates.out" 2>&1; then
  printf 'FAIL unconfigured ship gates passed\n'; exit 1
fi
grep -Fq 'FAIL artifact-configured' "$tmp/gates.out"
grep -Fq 'FAIL explicit-aaif-submit-approval' "$tmp/gates.out"
printf 'PASS unconfigured ship gates block release\n'

if "$repo_root/bin/submission-init" 2026-10 example-piece > "$tmp/repeat.out" 2>&1; then
  printf 'FAIL existing folder was overwritten\n'; exit 1
fi
grep -Fq "$target" "$tmp/repeat.out"
printf 'PASS existing folder refused with path\n'

for args in '2026-13 valid-slug' '2026-00 valid-slug' '0000-10 valid-slug' '2026-10 BadSlug' '2026-10 bad--slug'; do
  # Intentional word splitting to exercise the two positional arguments.
  # shellcheck disable=SC2086
  if "$repo_root/bin/submission-init" $args > "$tmp/invalid.out" 2>&1; then
    printf 'FAIL accepted bad input: %s\n' "$args"; exit 1
  fi
done
printf 'PASS invalid month and slug refused\n'

if "$repo_root/bin/submission-init" 2026-10 valid-slug --title '' > "$tmp/invalid.out" 2>&1; then
  printf 'FAIL accepted empty title\n'; exit 1
fi
printf 'PASS empty title refused\n'
