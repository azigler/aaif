---
name: pinki-steward
description: Weekly pinki-steward pulse. Audits the shared pinki ledger, pinki's repo state, and its README and docs against the latest release, triages findings into upstream issues, estate-wrapper beads or usage notes, and logs a pulse-ledger row. Fires from the Tue 13:07 PT timer, on the canary tick the day after a pinki release, or on demand ("audit pinki", "pinki maintenance").
---

# /pinki-steward — the weekly pinki-steward pulse

## What it is

aaif owns pinki. Pinki is the promise tool at github.com/azigler/pinki. The local checkout
is `~/pinki`. The whole estate writes promises to one shared ledger. This pulse reads that
ledger every week, finds defects and usage patterns, and keeps pinki healthy.

Timer: Tue 13:07 PT. A canary tick also fires the day after any pinki release. consul owns
the systemd unit and the roster row (aaif-eecq).

Timer-lane rules:
- Never use AskUserQuestion.
- News goes to the desk: `bash ~/.agents/agents/lib/post.sh send desk --body-file F`.
- File a P1 `human:` bead only when Zig must decide something.

The tool for the audit is `bin/pinki-audit.py`. It is deterministic, stdlib only, and
read-only on the ledger. Its tests are `bash tests/pinki-audit/run.sh`.

## Step 0 — put the tick on a bead

Cost attribution (aaif-7zy1): before any other work, touch the pinki epic so the tick's first
model calls carry a bead. A non-zero exit is a defect for the desk mail, not a stop.

```bash
bash /home/ubuntu/.agents/agents/lib/bead-claim.sh touch "$CLAUDE_CODE_SESSION_ID" aaif-rsi pinki-steward-tick
```

## Step 1 — GLOBAL PROMISE AUDIT

```bash
W=$(date +%G-W%V)
mkdir -p .local/pinki-audit
python3 bin/pinki-audit.py --json .local/pinki-audit/$W.json \
  --prev "$(ls -1 .local/pinki-audit/*.json | grep -v "$W" | tail -1)"
```

On the first run there is no earlier snapshot: leave `--prev` off. A missing ledger exits 2.
That is a failure to report, never an empty week.

Snapshots live in `.local/pinki-audit/`. That folder is gitignored and private, because
promise texts name private infra. Never copy a promise text into a tracked file.
Do not post promise texts to a channel.

Read the `global` lists in the snapshot before you inspect one seat. Each row names an id,
the declaring seat, the recipient, and an outcome or state. Each class has a count in
`scalars` and counts by seat. The lists and counts are cumulative. With `--prev`, each
class also shows `prev_count` and `new_since_prev` ids. The text render gives the current
count, previous count, and new ids. On the first run, the new ids are unknown.

- `lapsed`: the final outcome is lapsed, or an unsuperseded watchdog assessment marks it
  terminal-lapsed. Read `lapse_ts`, `lapse_source` (`resolve` or `watchdog`), and
  `later_outcome`. A watchdog-lapsed promise still counts as open and overdue in pinki.
- `chronically_extended`: at least `--chronic-amends` non-watchdog amends (default 3).
  Read `amends_total`, `amends_watchdog`, the shift in deadline, and whether it is open.
- `unresolvable`: an owed promise is still open, is overdue by more than `--stale-hours`
  (default 72), and has no seat amend or non-watchdog assess after its current until.
  Watchdog nudge amends and terminal assessments do not count as seat action.
- `owed_to_zig`: the recipient is `human:zig` or `zig`, without case sensitivity. Read
  the open and resolved counts by outcome. An open row has overdue hours.

Feed open rows and ids new since `--prev` into Step 3 triage. A core defect becomes an
issue and bead. A wrapper defect goes to consul. A usage pattern goes in the note.
Route a seat-specific pattern to that seat in Step 2. In the one desk mail, put only
`owed_to_zig` ids that are overdue (`overdue_hours > 0`) or newly lapsed since `--prev`.
Do not include a not-yet-due id or the whole cumulative list.
Do not send them to Zig directly.

Then check repo state:
- `gh issue list -R azigler/pinki`
- `gh pr list -R azigler/pinki`
- `git -C ~/pinki tag --sort=-v:refname | head -1`, against `pinki --version`. A gap means
  the installed binary is behind the latest tag.

Reading a zero: the fixture proves that the code can report a positive count. It does
not prove that a live zero is correct. For global classes, check a live positive control:
the ledger cut at 2026-10-05 lists two unresolvable ids, and the full ledger lists 34
lapsed ids as of 2026-11-15. If a count looks wrong, re-run `tests/pinki-audit/run.sh`
and the live control before reporting a zero.

## Step 1b — README + DOCS, every run

Agents are the README's audience (Zig 2026-10-12, aaif-rsi.15). They learn pinki from it and
paste it to other agents, so drift costs adoption. Each run checks the README and docs
against the latest release and fixes what drifted:

```bash
bash ~/pinki/scripts/check-readme.sh        # every README example, run as committed
grep -n -E 'v?0\.[0-9]+\.[0-9]+' ~/pinki/README.md ~/pinki/docs/*.md   # version claims
```

- A red check, or a version, verb, flag or exit code the README states that the binary does
  not have, is drift. Fix it on a `docs/` branch in `~/pinki`, with a different-model review.
- Ask: what would a new agent fail on? A missing command, an example that needs editing to
  run, a paragraph of prose before the first command. Fix the worst one each week.
- A release (Step 5) updates the README before the tag, not after.
- Docs-only PRs that fix drift are this duty, and the README rewrite was Zig's own ask. Like
  every pinki PR, they are the steward's own call (Step 2's merge rule). A PR that changes
  what pinki claims to be, or its scope, still goes through the desk.

## Step 2 — ASK THE ESTATE

On each pulse, read replies from the last pulse with `bash ~/.agents/agents/lib/post.sh read`
(channel `#pinki-incorporation`). Feed each reply into Step 3. Record its disposition in
the weekly note, even when no change is needed.

Build one channel post for the pulse. Combine the standing feedback ask with the Step 6
digest. Publish it at Step 6, after Steps 3-5, because the digest needs their results.
Use `post.sh publish pinki-incorporation --body-file F` once. Give the four
cumulative global counts and each class's change since the prior snapshot. Give counts
only. Do not include promise texts or ids in the channel post. Ask two or three concrete
questions. For example: Which lapsed deadline was hard to resolve? Which amend flow
caused repeat work? Which stale promise lacked a clear next action?

Check the subscription gap. `post.sh channel list` prints only a count, so read the names
from the channel's `.subs` file. Compare them with the ROSTERED seats (keys under `seats:`
in `~/.agents/agents/seats.yml`) that declared a promise in the last 30 days. Builder ids
and other unrostered `by` values do not count.

```bash
SUBS=~/.local/state/harness/post/channels/pinki-incorporation.subs
python3 bin/pinki-audit.py --since "$(date -u -d '30 days ago' +%FT%TZ)" --json .local/pinki-audit/30d.json >/dev/null
python3 - "$SUBS" <<'EOF'
import json, re, sys, os
subs = set(open(sys.argv[1]).read().split())
roster = set(re.findall(r'^  ([a-z0-9-]+):$', open(os.path.expanduser('~/.agents/agents/seats.yml')).read().split('\nseats:\n', 1)[1], re.M))
active = set(json.load(open('.local/pinki-audit/30d.json'))['by_seat'])
print('GAP', sorted((roster & active) - subs))
EOF
```

Name the gap in the one desk mail only when it differs from the gap in the prior week's
note. Do not join seats yourself. On 2026-11-15, the channel had 9 subscribers.

Send direct mail to a seat only when its audit has a named finding. Include the ids and
the action needed. Use `post.sh send <seat> --body-file F`. Keep promise texts out of mail.
The shared `steward` skill (dotfiles-kuucv, lab drafts) owns the generic feedback loop.
Keep pinki's questions and routing here.

## Step 3 — TRIAGE

Each open global row, each id new since `--prev`, each reply, and each repo finding gets
one disposition. Do not triage every cumulative row again.

- (a) A core pinki defect: write an issue draft, and file a bead under epic aaif-rsi.
- (b) An estate wrapper or watchdog defect. Examples: `~/.agents/agents/lib/promise-gap.sh`
  and the expected-gap-watchdog. These are demesne, owned by consul. Mail consul with a bead
  suggestion. Do not edit them.
- (c) A usage pattern: one line in the weekly note.

## Step 4 — GITHUB

Zig's STANDING GRANT (2026-10-10, desk, ref aaif-wj1h): aaif may file issues on
azigler/pinki through pigeon. Mail pigeon the title and a body file. Pigeon files with `gh`
under Zig's account. Limit: at most 3 per calendar week.

Before you file:
1. Count this week's uses. Read the comments on aaif-wj1h-style beads (`br comments aaif-wj1h`
   and the beads of earlier filings). Stop at 3.
2. Search for a duplicate: `gh issue list -R azigler/pinki --search "<terms>" --state all`.
3. Verify the claim against pinki's own behavior: `pinki show`, `pinki --help`,
   `~/pinki/docs/DESIGN.md`. On 2026-10-10 two drafted issues were dropped because pinki
   already did the thing.
4. Record each filing as a comment on its bead, with the date. That comment is the counter.

PRs are the steward's own call (Zig, 2026-10-17 11:3x PT, said twice: "Yes aaif has standing
PR open and merge privileges on pinki as its steward" and "AAIF has standing permissions to
open and merge into pinki as its steward"). Open and merge as steward, one PR at a time:
merge-only (never rebase), read the CI result BEFORE the merge, merge at the reviewed head
(`gh pr merge --merge --match-head-commit <sha>`), and confirm main's CI after. A
different model reviews every change before its PR. Do not ask the desk for a PR yes/no.
Still to Zig, via ONE desk mail: a change to what pinki is, its scope, or its stance (for
example its no-crypto rule, DESIGN.md §8 Q5). Releases are the loop's own call (Step 5).

## Step 5 — BUILD + RELEASE

Fixes are built in worktrees. A different model reviews each fix before merge. The
builder goes to tertiary (Codex) by default: `/drain-tap dispatch --pool tertiary`, with
a `Bead:` line on the item. The review of that Codex output stays on Claude (Zig
2026-10-11, #taps `taps-codex-drain-20261011`: keep secondary for orchestrator turns).

The release is the loop's call, not the desk's (Zig 2026-10-11, recorded on aaif-rsi).
After the weekly work, if a change merged since the last tag, decide: cut it or hold it.

Cut a release only when ALL of these hold:
- At least 1 merged change alters behavior the estate can see.
- `cargo test` is green on `main`.
- The estate suites pass with the release binary FIRST on PATH. Build `main` to a scratch
  dir (`cargo build --release --locked`), put its dir first on `PATH`, and run EVERY estate
  suite that touches pinki. Derive the list; never keep a fixed one:
  ```bash
  grep -rl --include='test-*.sh' -E '\bpinki\b|promise-gap\.sh|pinki-estate' \
    "$(readlink -f ~/.agents)/agents" | grep -v mutate
  ```
  Run each suite on the installed binary too: a suite that is red on BOTH is a
  pre-existing estate bug, not this release's. Hold new starts while load1 > 12. On
  2026-10-12 the derived list had 47 suites (the gate used to run a fixed 4).
- If the release needed a wrapper change, that change is in consul's gate-window PIN, not
  only on demesne main. Ask consul for the pin sha and check it with `git merge-base
  --is-ancestor <fix> <pin>`. The gate window runs its suites on a pinned demesne copy,
  but it uses the one installed `pinki`. Measured on the v0.4.0 canary: the wrapper fix
  bd3aa4c9 was on main before the install, but gate window 442316 ran on pin 740de725
  without it. The result was red test-seat-restart (264), promise-watchdog and
  pulse-ledger-watch runs, plus cascades (consul triage on dotfiles-xcb08). No live
  reader logged a refusal after the install. The user journal had 0 "no ledger at" lines.
  In the harness logs, every hit was test, triage or mail text.

A suite that is green on the installed binary and red on the release binary HOLDS the
release. That is a contract break with the estate wrapper (owner: consul). Mail consul the
failing test ids and the error line, and wait for the wrapper to adapt. Measured
2026-10-11: #16 (missing ledger is an error) turned at least 156 estate tests red in 3
suites (promise-gap 60 then a crash, watchdog 80, molt-gap 16), because the
wrapper reads a fresh ledger before its first write.

Version rule: patch for fixes, minor for new verbs or a changed exit code a caller can
see. At most 1 release per week. To cut one: confirm `scripts/check-readme.sh` is green on
the release binary, bump `Cargo.toml` and `Cargo.lock`, move the
CHANGELOG `Unreleased` entries under the version, commit `:bookmark: vX.Y.Z — <one line>`
on `main`, push an annotated tag `vX.Y.Z` (the release workflow builds the asset), then
`cargo install --path ~/pinki --locked` and confirm `pinki --version`. Mail the desk the
tag as NEWS, not as a gate. The canary tick the next day checks the estate on it.

## Step 6 — OUTPUTS, every tick

1. A row in `refs/pulse-ledger.jsonl` with `"row":"pinki-steward"`. The proof is `kind:cmd`
   and re-runs a grep over the snapshot. Model: Output 3 in
   `.claude/skills/aaif-radar/SKILL.md`.
   ```bash
   TS=$(date -u +%FT%TZ)
   printf '%s\n' "{\"ts\":\"$TS\",\"row\":\"pinki-steward\",\"outcome\":\"done\",\"proof\":{\"kind\":\"cmd\",\"cmd\":\"grep -q promises_live .local/pinki-audit/<YYYY-Www>.json && grep -q open_overdue .local/pinki-audit/<YYYY-Www>.json\"},\"note\":\"pinki-steward <YYYY-Www> — <headline numbers, participant-free>\"}" \
     >> refs/pulse-ledger.jsonl
   ```
   Replace every `<YYYY-Www>`. Add the row with `git add refs/pulse-ledger.jsonl`, then
   commit and push. A quiet week still logs a row with `"outcome":"quiet"` (no proof needed).
2. A closed `note` bead with participant-free headline numbers. No promise texts, no seat
   names tied to a finding. Close it LAST in the tick. After the close, touch the open
   epic (`bash ~/.agents/agents/lib/bead-claim.sh touch "$CLAUDE_CODE_SESSION_ID" aaif-rsi
   pinki-steward`): the cost report credits no row to a closed bead, so later work on a
   closed note falls to unattributed (harnessd-6xqv1: 42 rows on 2026-11-10).
3. One channel post on #pinki-incorporation, published now. It holds the digest and the Step 2
   feedback ask.

Send only overdue or newly lapsed `owed_to_zig` ids in the one desk mail for the pulse.
Add the subscription gap from Step 2. Send a needed
decision, a PR gate, or news of a cut release in that same mail when they apply.

## Success measures (week over week)

- Molt-cancelled share goes to 0.
- Violated-then-satisfied goes to 0 once upstream #1 lands.
- Open-overdue stays under 3, with none older than 48 h.
- Every auto-parsed declare gets a receipt.
- More multi-day waits get declared.

## Out of scope

Changing `promise-gap.sh`, the watchdog, or the systemd unit (consul). Posting anything on an
AAIF surface (see the hard rule in `CLAUDE.md`). Writing to the ledger: this skill only reads it.
