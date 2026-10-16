#!/usr/bin/env bash
# Positive-control test for the handoff scrub gate (aaif-l0kl).
# Builds a throwaway repo, installs the REAL hook into it, and for each marker class
# shows: a note carrying it is REFUSED with the line named, then the same note
# passes once the line is removed. No literal secret is stored: the fake credential
# and the GID are built at run time. Exit 0 only if every expectation holds.
set -u

here="$(cd "$(dirname "$0")" && pwd)"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fails=0

ok()  { echo "  PASS: $1"; }
bad() { echo "  FAIL: $1"; fails=$((fails + 1)); }

git init -q "$work/repo"
cd "$work/repo" || exit 1
git config user.email t@example.com
git config user.name t
mkdir -p bin/hooks refs
cp "$here/handoff-scrub-check.py" bin/
cp "$here/install-hooks.sh" bin/
cp "$here/hooks/pre-commit" bin/hooks/
bash bin/install-hooks.sh

# Build the markers at run time.
rand=$(python3 -c 'import secrets,string;print("".join(secrets.choice(string.ascii_letters+string.digits) for _ in range(40)))')
fake_cred="sk-ant-$rand"
gid="1$(python3 -c 'import random;print("".join(random.choice("0123456789") for _ in range(15)))')"

printf '# Handoff\n\nclean line one\nclean line two\n' >refs/session-handoff.md
git add refs/session-handoff.md
git commit -q -m base || bad "clean baseline note should commit"

# check <name> <bad-line> <expected-reason>
check() {
  local name=$1 badline=$2 reason=$3 out
  echo "== $name"
  printf '# Handoff\n\nclean line one\n%s\nclean line two\n' "$badline" >refs/session-handoff.md
  git add refs/session-handoff.md
  out=$(git commit -q -m "with $name" 2>&1); rc=$?
  echo "$out" | sed 's/^/    | /'
  [ $rc -ne 0 ] && ok "commit refused (rc=$rc)" || bad "commit was NOT refused"
  echo "$out" | grep -q "refs/session-handoff.md:4: .*$reason" \
    && ok "refusal names line 4 and $reason" || bad "refusal did not name line 4 / $reason"
  if [ "$name" = credential ]; then
    echo "$out" | grep -qF "$rand" && bad "refusal re-printed the secret" || ok "secret not re-printed"
  fi
  # remove the line, same note must now pass
  printf '# Handoff\n\nclean line one\nclean line two after %s\n' "$name" >refs/session-handoff.md
  git add refs/session-handoff.md
  git commit -q -m "without $name" && ok "same note passes once the line is removed" \
    || bad "clean note was refused"
}

check ".local-path" 'see the private notes in .local/private-notes.md for details' '\.local-path'
check "asana-gid" "task id $gid in the planning hub" 'asana-gid'
check "credential" "the key was $fake_cred in the env" 'credential:anthropic-key'

echo "== negative controls (must PASS the gate)"
printf '# Handoff\n\nbinary at ~/.local/bin/tool and $HOME/.local/share/x, ts 1760000000000\n' >refs/session-handoff.md
git add refs/session-handoff.md
git commit -q -m xdg && ok "XDG ~/.local and a 13-digit timestamp are not flagged" || bad "false positive on XDG/timestamp"

echo "== only staged handoff notes are checked"
printf 'path .local/x\n' >refs/other.md
git add refs/other.md
git commit -q -m other && ok "non-handoff file with .local passes (out of scope)" || bad "non-handoff file was blocked"

echo "== installer never overwrites a foreign hook"
printf '#!/bin/sh\necho foreign\n' >.git/hooks/pre-commit
if bash bin/install-hooks.sh 2>/dev/null; then bad "installer overwrote a foreign hook"; else ok "installer refused"; fi
grep -q foreign .git/hooks/pre-commit && ok "foreign hook intact" || bad "foreign hook changed"

echo
[ "$fails" -eq 0 ] && echo "ALL PASS" || echo "$fails FAILURE(S)"
[ "$fails" -eq 0 ]
