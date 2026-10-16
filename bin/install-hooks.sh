#!/usr/bin/env bash
# Install aaif's tracked git hooks into this clone's hooks dir (aaif-l0kl).
# Copies bin/hooks/pre-commit to <git hooks dir>/pre-commit. It does NOT set
# core.hooksPath (that would switch off every other hook). It refuses to overwrite a
# pre-commit hook that is not ours; a stock *.sample is not a hook and is untouched.
# Re-run after `git pull` to refresh the installed copy.
set -eu

src="$(cd "$(dirname "$0")" && pwd)/hooks/pre-commit"
hooks_dir=$(git rev-parse --git-path hooks)   # shared across worktrees
dest="$hooks_dir/pre-commit"
marker="aaif-handoff-scrub-gate"

mkdir -p "$hooks_dir"
if [ -e "$dest" ] || [ -L "$dest" ]; then
  if ! grep -q "$marker" "$dest" 2>/dev/null; then
    echo "install-hooks: $dest exists and is not the aaif hook; not overwriting." >&2
    echo "  Merge $src into it by hand, or move yours aside." >&2
    exit 1
  fi
fi
cp "$src" "$dest"
chmod +x "$dest"
echo "install-hooks: installed $dest"
