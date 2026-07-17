---
name: housekeeping
description: Project-local mechanical hygiene for the aaif repo. Currently carries the index-vs-disk drift lint — flags when refs/README.md or CLAUDE.md's skill list fall out of sync with the actual files on disk. Run during a housekeeping pass or before a release. Supplements the global /housekeeping ritual with aaif-specific checks.
---

# housekeeping (aaif-local)

Mechanical, non-creative hygiene for this repo. This project-local skill
supplements the global `/housekeeping` ritual with checks specific to the aaif
harness. It lives here (not in the shared global skill) because the paths it
checks are aaif-specific.

## Index-vs-disk drift lint

Two indexes in this repo are hand-maintained and drift silently as files are
added or removed:

- `refs/README.md` — the index of the `refs/` archive
- `CLAUDE.md` — the `.claude/skills/` list (routing table + file-layout tree)

Run this from anywhere in the repo to flag drift. It exits non-zero if any file
on disk is missing from its index (the common failure).

```bash
#!/usr/bin/env bash
# index-vs-disk drift lint for the aaif harness
set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1
drift=0

# 1. refs/ archive vs refs/README.md
while IFS= read -r f; do
  rel=${f#refs/}
  grep -qF "$rel" refs/README.md || { echo "DRIFT: refs/$rel on disk, missing from refs/README.md"; drift=1; }
done < <(find refs -type f \( -name '*.md' -o -name '*.jsonl' \) ! -name README.md)

# 2. .claude/skills/ vs CLAUDE.md
for d in .claude/skills/*/; do
  s=$(basename "$d")
  grep -qF "$s" CLAUDE.md || { echo "DRIFT: skill '$s' on disk, missing from CLAUDE.md"; drift=1; }
done

[ "$drift" -eq 0 ] && echo "index-vs-disk: clean" || echo "index-vs-disk: DRIFT (fix the indexes above)"
exit "$drift"
```

When it flags drift, add the missing entry to the index (or remove the phantom
row) — never suppress the check. A forward reference (indexing a file a
same-wave worker is still adding) is fine: the lint only flags files present on
disk but absent from the index, so a not-yet-created path stays quiet until it
lands.
