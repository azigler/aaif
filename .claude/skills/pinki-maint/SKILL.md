---
name: pinki-maint
description: Weekly pinki-maintainer pulse. Audits the shared pinki ledger and pinki's repo state, triages findings into upstream issues, estate-wrapper beads or usage notes, and logs a pulse-ledger row. Fires from the Tue 13:07 PT timer, on the canary tick the day after a pinki release, or on demand ("audit pinki", "pinki maintenance").
---

# /pinki-maint — the weekly pinki-maintainer pulse

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

## Step 1 — AUDIT

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

Then check repo state:
- `gh issue list -R azigler/pinki`
- `gh pr list -R azigler/pinki`
- `git -C ~/pinki tag --sort=-v:refname | head -1`, against `pinki --version`. A gap means
  the installed binary is behind the latest tag.

Reading a zero: the test fixture makes every metric nonzero at least once, so a zero in the
audit is a real zero. If a metric looks wrong, re-run `tests/pinki-audit/run.sh` first.

## Step 2 — LISTEN

Read the channel: `bash ~/.agents/agents/lib/post.sh read` (channel `#pinki-incorporation`).

Post ONE ask there only when the audit shows a seat-specific anomaly. Name the seat and the
instance ids. Use `post.sh publish pinki-incorporation --body-file F`. Do not send blanket
"any feedback?" asks.

## Step 3 — TRIAGE

Each finding becomes one of three things.

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

PRs stay GATED per act. Ask through the desk. The grant does not cover them. Releases are
the loop's own call (Step 5).

## Step 5 — BUILD + RELEASE

Fixes are built in worktrees. A different model reviews each fix before merge.

The release is the loop's call, not the desk's (Zig 2026-10-11, recorded on aaif-rsi).
After the weekly work, if a change merged since the last tag, decide: cut it or hold it.

Cut a release only when ALL of these hold:
- At least 1 merged change alters behavior the estate can see.
- `cargo test` is green on `main`.
- The estate suites pass with the release binary FIRST on PATH. Build `main` to a scratch
  dir (`cargo build --release --locked`), put its dir first on `PATH`, and run all four:
  `~/.agents/agents/lib/test-promise-gap.sh`, `~/.agents/agents/lib/test-molt-gap.sh`,
  `~/.agents/agents/scheduler/test-expected-gap-watchdog.sh`,
  `~/.agents/agents/bin/test-desk-query.sh`. Run them on the installed binary too: a
  suite that is red on BOTH is a pre-existing estate bug, not this release's.

A suite that is green on the installed binary and red on the release binary HOLDS the
release. That is a contract break with the estate wrapper (owner: consul). Mail consul the
failing test ids and the error line, and wait for the wrapper to adapt. Measured
2026-10-11: #16 (missing ledger is an error) turned at least 156 estate tests red in 3
suites (promise-gap 60 then a crash, watchdog 80, molt-gap 16), because the
wrapper reads a fresh ledger before its first write.

Version rule: patch for fixes, minor for new verbs or a changed exit code a caller can
see. At most 1 release per week. To cut one: bump `Cargo.toml` and `Cargo.lock`, move the
CHANGELOG `Unreleased` entries under the version, commit `:bookmark: vX.Y.Z — <one line>`
on `main`, push an annotated tag `vX.Y.Z` (the release workflow builds the asset), then
`cargo install --path ~/pinki --locked` and confirm `pinki --version`. Mail the desk the
tag as NEWS, not as a gate. The canary tick the next day checks the estate on it.

## Step 6 — OUTPUTS, every tick

1. A row in `refs/pulse-ledger.jsonl` with `"row":"pinki-maint"`. The proof is `kind:cmd`
   and re-runs a grep over the snapshot. Model: Output 3 in
   `.claude/skills/aaif-radar/SKILL.md`.
   ```bash
   TS=$(date -u +%FT%TZ)
   printf '%s\n' "{\"ts\":\"$TS\",\"row\":\"pinki-maint\",\"outcome\":\"done\",\"proof\":{\"kind\":\"cmd\",\"cmd\":\"grep -q promises_live .local/pinki-audit/<YYYY-Www>.json && grep -q open_overdue .local/pinki-audit/<YYYY-Www>.json\"},\"note\":\"pinki-maint <YYYY-Www> — <headline numbers, participant-free>\"}" \
     >> refs/pulse-ledger.jsonl
   ```
   Replace every `<YYYY-Www>`. Add the row with `git add refs/pulse-ledger.jsonl`, then
   commit and push. A quiet week still logs a row with `"outcome":"quiet"` (no proof needed).
2. A closed `note` bead with participant-free headline numbers. No promise texts, no seat
   names tied to a finding.
3. One short digest on #pinki-incorporation (`post.sh publish pinki-incorporation`).

Desk mail only when a decision is needed, for a PR gate, or as news of a cut release.

## Success measures (week over week)

- Molt-cancelled share goes to 0.
- Violated-then-satisfied goes to 0 once upstream #1 lands.
- Open-overdue stays under 3, with none older than 48 h.
- Every auto-parsed declare gets a receipt.
- More multi-day waits get declared.

## Out of scope

Changing `promise-gap.sh`, the watchdog, or the systemd unit (consul). Posting anything on an
AAIF surface (see the hard rule in `CLAUDE.md`). Writing to the ledger: this skill only reads it.
