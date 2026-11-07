---
name: aaif-weekly
description: aaif's weekly pass. Part 1 is the /aaif-radar scan of the submissions landscape. Part 2 closes the loop on aaif's own beads and repo (close done work with evidence, fold duplicates, release stale claims, re-rank, monthly-floor check, housekeeping lint). Ends every run with one four-part desk mail (ran, suggestions, questions for Zig, notes), a bead for every later action, and a refreshed window handoff. Fires from the Sat 15:00 PT timer (pulse-aaif-weekly), or by hand ("aaif weekly", "triage aaif").
---

# /aaif-weekly — the radar, then close the loop on aaif's own work

Bead `aaif-ub9x` is the spec of record. Zig's words (desk, 2026-10-14): a weekly "close
the loop" pass that cleans up the work in this repo, and "Yeah aaif-radar should become
aaif-weekly and have the triage/housekeeping step". `pulse-aaif-weekly` replaces
`pulse-aaif-radar`, on the same Sat 15:00 PT calendar.

Goal: `br ready` stays a list Zig and this seat can trust, and the repo carries no drift.

**The estate ruling on weekly pulses** (Zig, desk window, 2026-10-14 ~21:1x-21:4x PT,
#estate 2026-10-15T04:29Z) binds this pass. Its one written copy is consul's
`~/.agents/agents/skills/pulse/reference/weekly.md` (dotfiles-8fn94); if that file and
this summary disagree, that file wins:
1. "Each seat needs to fully run the loop on all its projects".
2. ALL and ONLY the seat's roster folders. Nothing joins by default: a project joins only
   when Zig adds it to aaif's roster row.
3. Demesne and dotfiles get no weekly pulse.
4. "These weekly pulses ... should also push and close the beads they can, and even
   utilize the garden skill to knock it all out".

**The L2 fixes** (Zig, desk, 2026-10-31 ~18:5x PT, verbatim pick: "Thoroughness floor,
Broken work -> beads, Handoff per window, Evidence + no RO triage"; dotfiles-phnvj; rule
text at demesne 1c31ea2d, `agents/skills/pulse/reference/weekly.md`) bind every run:
1. Thoroughness floor: reopen-scan on each store with its count printed; one dated
   keep/close/fold comment on every bead walked (Step 2). Never defer: a bead that may come
   back closes with `REOPEN-ON:` or `REOPEN-IF:`.
2. Broken work -> beads: every BROKEN, SKIPPED or SUGGESTION item that needs later action
   is a bead in aaif's store, its id quoted in the desk mail, and `beads_filed` on the
   ledger row (Step 6, Step 7).
3. Handoff per window: the run ends by refreshing `refs/session-handoff--aaif-weekly.md`
   (Step 8).
4. Evidence + no read-only triage: bead triage runs in this write-capable session, never in
   a read-only Codex sandbox (hard rule 7).

Models: `/pigeon-weekly` (~/dovecoted) for the shape. The global `/triage` for each bead
population. Where this file and `/triage` differ, this file wins.

## Paths (absolute, always)

- ROSTER FOLDERS: read live every run, never from this file:
  `jq -r '.seats.aaif | [.home] + (.homes // []) | .[]' /home/ubuntu/.agents/agents/seats.json`.
  It prints `~` paths: expand each with `p=${p/#\~/$HOME}` before any `cd`. On 2026-10-15
  it printed only `~/aaif`, so today Part 2 runs on aaif alone. If Zig adds a folder,
  repeat Part 2 there with REPO set to it; REPORT and the one ledger row stay aaif's and
  list each folder. `~/pinki` is not on the
  roster: `/pinki-steward` covers it.
- REPO = `/home/ubuntu/aaif`. Start every Bash call with `REPO=/home/ubuntu/aaif` and use
  `$REPO/...` paths. Shell state does not survive between calls.
- W = `$(date +%G-W%V)`. Recompute it in every call that needs it.
- LEDGER = `$REPO/refs/pulse-ledger.jsonl`, row `aaif-weekly`.
- REPORT = `$REPO/.local/aaif-weekly/$W.md`. It is private and gitignored, because it can
  quote bead text that names private infra. Next week's run scores it.
- MAIL = `$REPO/.local/aaif-weekly/$W-desk.md`, the one desk mail body.

## Hard rules

1. Timer lane: never AskUserQuestion. A decision only Zig can make goes in part 3 of
   the ONE desk mail (Step 6), which every run sends, and the pass ends.
2. The AAIF hard rules in `CLAUDE.md` hold. This pass never opens, comments on or submits
   anything on an AAIF surface. It never names, ranks or compares other ambassadors in a
   bead, a comment, a commit or the ledger. Nothing from `.local/` goes into a tracked
   file. Close reasons and comments cite bead ids, shas and URLs only.
3. Close with evidence: a merge sha, a live URL that Zig already approved, a closed
   child, or a ledger row. Or close it as STALE (Step 2, item 8), with exactly one
   `REOPEN-ON: YYYY-MM-DD` or `REOPEN-IF: <condition>` line, last in the reason.
   A `:card_file_box:` / `beads: file` commit is NEVER evidence,
   even though `/triage` says to "usually just close" an orphan. "Probably done" stays
   open, with a comment that names the missing evidence.
4. Each bead mutation is its own Bash call. A hook block kills the whole call.
5. A negative is a claim. "0 stale beads" needs a printed positive control (the oldest
   open bead's `updated_at`).
6. Print `AAIF_WEEKLY_RESULT=<verdict>` as the last line on every path:
   `ok:acted:<n actions>:<n decisions>`, `ok:quiet`, `partial:radar:<why>`, `blocked:<step>:<why>`,
   `failed:<step>:<why>`.
7. Bead triage runs in THIS session, which can take the `br` write lock. A read-only Codex
   sandbox cannot take the lock or record decisions: never hand it triage. If triage could
   not run in a writer, report it as SKIPPED (with a bead, Step 6) until its receipts land.
8. Never `br defer`. A bead that should come back later closes with a REOPEN line (rule 3);
   `reopen-scan` brings it back.

## Who may do what

| Change | Who decides |
|---|---|
| Close a bead whose work landed (evidence in the close reason) | aaif acts |
| Fold an exact duplicate into the older bead (`-r "duplicate of <id>"`) | aaif acts |
| Close a stale bead with a `REOPEN-IF: <condition>` line (Step 2, item 8) | aaif acts |
| Dispatch a buildable bead to a builder, at most 2 a run (Step 4b) | aaif acts; aaif merges after a different-model SHIP |
| Release a stale `in_progress` claim back to `open` | aaif acts |
| Add a `waits-for` edge, or close on a dated trigger with `REOPEN-ON: <date>` (never `br defer`) | aaif acts |
| Move a priority by one step, with a one-line comment saying why | aaif acts, at most 5 a week |
| Close a `submission:` bead. A draft, or a piece waiting at the submit gate, stays open | aaif acts only on a live URL Zig approved; else Zig |
| Close an `idea:` or `submission:` bead as won't-do on its merits, or change a month's anchor | Zig, via the desk |
| Close a P1 `human:` bead (title prefix: a decision filed for Zig) | Zig, via the desk |
| Anything on an AAIF surface | Zig, every time (CLAUDE.md hard rule) |

## Step 0 — before Part 1

```bash
# Cost attribution (aaif-7zy1): put the tick on a bead BEFORE any other work, so its first
# model calls are not unattributed. 18o.4 is the cadence bead this pass checks.
bash /home/ubuntu/.agents/agents/lib/bead-claim.sh touch "$CLAUDE_CODE_SESSION_ID" \
  aaif-ambassador-program-18o.4 aaif-weekly-tick
REPO=/home/ubuntu/aaif; W=$(date +%G-W%V); mkdir -p "$REPO/.local/aaif-weekly"; cd "$REPO" || exit 1
git status --short | tee "$REPO/.local/aaif-weekly/$W-dirty-before.txt"
```

A non-zero exit from the touch line is a defect to report in the desk mail, not a reason to
stop the pass.

Files listed there were dirty BEFORE this pass. They are not this pass's to commit, except
`.beads/issues.jsonl`, the shared bead store, which every bead commit carries.

## Part 1 — the radar

Run `/aaif-radar` in full, in its autonomous mode: the scan, Output 1 (the private report
in `.local/radar/`) and Output 2 (the closed `note` bead). Three overrides inside this pass:

- **Skip radar's Output 3.** Do not write an `aaif-radar` ledger row. One fire writes ONE
  row, and this pass's `aaif-weekly` row (Step 7) carries the radar result.
- **No commits in Part 1.** Create and close radar's note bead (Output 2), but skip its
  `git add && git commit` line. Any radar edit to `SUBMISSIONS.md` (its scorecard sync) is
  also left for Step 7. Step 7 makes the one commit, after the leak check.
- **Notify goes through Step 6.** A notable radar finding that needs Zig's decision goes in
  the one desk mail, plus the P1 `human:` bead radar's Notify section shapes (a menu).
  News with no decision goes in the ledger note. This seat sends no push itself.

If the radar fails (for example, the private repo is unreachable), record
`radar: failed:<why>` in REPORT and go on to Part 2. Part 2 does not depend on Part 1.
The ledger row then says `"outcome":"partial"`, with the failure in its note.

## Part 2 — close the loop

### Step 1. Snapshot (before)

```bash
REPO=/home/ubuntu/aaif; cd "$REPO" || exit 1
br stats
echo "before: open=$(br count --status open) in_progress=$(br count --status in_progress) ready=$(br ready --json | jq length)"
```

Write the `before:` line into REPORT exactly as printed. Part 1's note bead is already in
these counts. Read last week's REPORT, if one exists, for Step 7's score. Never treat it as current state.

### Step 2. Walk the populations (the global `/triage`, Step 2)

First, the reopen scan, on EACH roster bead store (today only aaif's):

```bash
REPO=/home/ubuntu/aaif; ~/.agents/agents/bin/reopen-scan --root "$REPO"
```

Print each store's `REOPEN_SCAN_RESULT=` line into REPORT. A scan that errors or prints no
result line is `COULD-NOT-EVALUATE` for that store, never zero. Review every DUE result
(reopen it, or re-close it with a new date and a comment why) and every CONDITION result
(has the condition happened?). Fix every NONCONFORMING one: `br reopen`, then re-close with
the same reason and one standard REOPEN line at the end.

Every bead walked in the populations below gets ONE dated comment, its own Bash call:
`[aaif-weekly <PT date>] keep|close|fold: <reason>`. A `keep` names the live owner or
blocker; a `close` names its evidence. A pass with no disposition comments is not bead
triage. `defer` is not a disposition here (hard rule 8).

Cap: walk at most the 10 oldest items in each population. Put the rest in REPORT as next
week's first items. In this order:

0. `br ready`: confirm each ready bead is still live and still ready.
1. `br list --status in_progress`: a claim with no commit or comment in 7 days is a
   zombie. Release it to `open`, or comment why it is still live.
2. `br orphans --json`: read `latest_commit_message` first (`/triage`'s jq line). A
   filing commit is a false positive: leave the bead alone.
3. `br stale --days 14`: close (rule 3), fold, add an edge, or keep with a reason.
4. `br blocked`: confirm each blocker is real and still open.
5. `br epic close-eligible --dry-run`: close only the epics that are truly done, one at a
   time. The bare verb, without `--dry-run`, closes all of them.
6. Duplicates: compare open titles within every title prefix (`br list --json | jq -r
   '.[].title'`, grouped by the text before the first colon). Fold only exact
   duplicates. Near-duplicates get a comment that links them.
7. Re-rank: read the open P1 list. A P1 with no activity in 21 days is a candidate to
   move to P2. Move at most 5, each with a comment that says why.
8. Close the stale (estate ruling, point 4). A bead with no activity in 30 days closes as
   stale UNLESS it is: a `submission:`, `cadence:` or `human:` bead; a `decision` or
   `note` type; an epic with open children; `in_progress`, `deferred`, the source of a
   `waits-for` edge, or a blocker of any open bead (`br dep tree <id>`); or a bead that
   quotes a Zig ruling (test: `br show <id> | command grep -E 'Zig[ ,(]+20[0-9]{2}-'`; a hit
   excludes it). An `idea:` bead may close as
   stale: the ruling covers it, and the `REOPEN-IF:` (or `REOPEN-ON:`) line keeps it
   findable. The close:
   `br close <id> -r "$(printf 'stale: no activity since <date>.\nREOPEN-IF: <the condition that makes it live again>')"`
   (the bead-close-reopen hook reads the `REOPEN-IF:` line, on its own line, exactly once).
   Write a real condition, not "if needed". Stale closes are capped at 10 a run, oldest first.

### Step 3. The monthly floor

The floor is one public, project-tied contribution per month (`CLAUDE.md`, Cadence).
Part 1 already runs the floor guard (radar's floor block). It checks the
`floor-ruled-<YYYY-MM>` label, so it never asks Zig again about a month he has ruled on.
Do NOT run a second guard here. Copy radar's `floor:` result into REPORT. Its menu, if
it files one, goes in Step 6's desk mail. If Part 1 failed, run radar's floor block alone. If that fails too (it needs `gh`), record
`floor: unknown` in REPORT and raise no desk item for it.

### Step 4. Housekeeping

- Run the aaif index-vs-disk lint (`.claude/skills/housekeeping/SKILL.md`, the bash
  block). Fix drift on the spot, and record each fixed path for Step 7's commit.
- Dirty files from Step 0 are not this pass's. Do not commit them. List them in REPORT.
- `git worktree list` and `git branch --merged main`: remove a merged worktree or branch
  that this seat created. Leave any other seat's work alone.
- `git ls-files .local | wc -l` must print 0. Nonzero is a leak: stop, and report it as
  `blocked:housekeeping:local-tracked`.
- Any `refs/session-handoff--<window>.md` older than 14 days while beads moved: note it in REPORT.
  aaif is per-window (`refs/.handoff-per-window`, aaif-1i4t): `--aaif` is the main seat's note,
  `--aaif-weekly` is this window's. This window's `/offboard` writes only its own note.
- Units live: for each schedules row in aaif's roster entry,
  `systemctl --user is-enabled <unit>.timer` must print `enabled`, and `systemctl --user
  list-timers <unit>.timer` must show a NEXT time. A row with no live timer, or a live
  aaif timer that no row names, goes to consul as one mail. Until consul's cutover
  (demesne branch `aaif/aaif-weekly`) the roster still names `pulse-aaif-radar`, and
  `pulse-aaif-weekly` is not installed. That is expected: note it in REPORT, mail nobody.

### Step 4b. Knock it out (the garden's dispositions)

`/garden` is demesne's backlog engine and a model cannot invoke it. This pass borrows its
dispositions for aaif's own store. Each bead still open after Step 2 that the pass looked
at gets one: close, fold, interconnect (`br dep add`), groom (a sharper title or
acceptance line), ask-zig (Step 6), keep, or build.

A `build` bead has clear acceptance criteria and needs no decision from Zig. Dispatch at
most 2 a run, and only while load1 (`cut -d' ' -f1 /proc/loadavg`) is 12 or less; above
that, record the bead in REPORT as next week's build. Use the global `/drain-tap dispatch
--pool tertiary` with a `Bead:` line, and set the bead `in_progress` at dispatch so next
week does not send it twice. No `.local/` text goes in the brief. A Claude agent reviews the result; aaif merges it on SHIP,
in a later run or by hand. A builder never closes the bead: this seat closes it with the
merge sha. Anything on an AAIF surface is never a `build`.

### Step 5. Leak check before any commit

Run it after the ledger row is appended (Step 7), against what is already pushed, so it
covers everything this pass changed:

```bash
REPO=/home/ubuntu/aaif; cd "$REPO" || exit 1; git fetch -q origin
git diff -U0 origin/main -- .beads/issues.jsonl SUBMISSIONS.md | command grep -n -E '^\+.*\.local/' || echo "leak-check: beads clean"
tail -1 refs/pulse-ledger.jsonl | jq -r .note | command grep -n '\.local/' || echo "leak-check: ledger note clean"
```

The ledger row's `proof` names `.local/aaif-weekly/` on purpose; only its `note` is
checked. Also read the added lines yourself for any other ambassador's name or handle. A hit
means: edit the comment or close reason, then re-run.

### Step 6. The one desk mail — EVERY run (Zig, Ruling 4, 2026-10-16)

Every run ends with ONE desk mail, even a quiet run. Zig, at the desk, 2026-10-16
~17:1x PT: "all of the seats' weekly pulses ... end by making some suggestions for
things to do. Whenever these pulses run they should always report that or mail that to
the desk." A run with no desk mail is incomplete. The body has four parts, in this order:

1. **RAN:** what the run did and how it went. Name anything skipped or broken.
2. **SUGGESTIONS:** things to do next.
3. **QUESTIONS FOR ZIG:** each decision only Zig can make, with a recommendation and a
   default; or "none".
4. **NOTES:** anything else about the run.

Before sending, file a bead in aaif's OWN store for every BROKEN, SKIPPED or SUGGESTION
item that needs later action (a `human:` bead when Zig must rule), and quote each bead id
beside its item in the mail. A later action written only in prose is lost. Count them:
that number is `beads_filed` on the ledger row (Step 7); write 0 explicitly when no later
action remains. Never file another seat's work in aaif's store: mail that seat instead.

The body stays participant-free (no other ambassador named); radar specifics stay in the
private report. Write the body to MAIL first, then send it with the dated ref:

```bash
REPO=/home/ubuntu/aaif; W=$(date +%G-W%V); D=$(date +%F)
bash ~/.agents/agents/lib/post.sh send desk --from aaif --ref "aaif-weekly-$D" --body-file "$REPO/.local/aaif-weekly/$W-desk.md"
```

Believe only a `POST_SEND_RESULT=` line.

### Step 7. Report, ledger, commit

- Score last week: each desk item, accepted, declined or not yet answered.
- Snapshot (after): re-run Step 1's `echo "before: ..."` line with `after:` in place of
  `before:`, and write it to REPORT.
- REPORT also lists each action with its bead id and the evidence used, and the radar
  result from Part 1.
- Append ONE LEDGER row, built with `jq` so a quote in the note cannot break it:

  ```bash
  REPO=/home/ubuntu/aaif; W=$(date +%G-W%V); cd "$REPO" || exit 1
  NOTE="aaif-weekly $W — radar: <n new subs, trend; participant-free>; beads: open <a>-><b>, ready <c>-><d>; <n> closed, <n> folded, <n> released, <n> re-ranked; lint <clean|fixed>; <n> desk items"
  OUTCOME=done   # or quiet, or partial (radar failed)
  BEADS_FILED=<n>   # Step 6's count; 0 when no later action remains
  jq -nc --arg ts "$(date -u +%FT%TZ)" --arg w "$W" --arg note "$NOTE" --arg outcome "$OUTCOME" --argjson bf "$BEADS_FILED" \
    '{ts:$ts,row:"aaif-weekly",outcome:$outcome,beads_filed:$bf,proof:{kind:"cmd",cmd:("grep -q \"^before:\" .local/aaif-weekly/"+$w+".md && grep -q \"^after:\" .local/aaif-weekly/"+$w+".md")},note:$note}' \
    >> refs/pulse-ledger.jsonl
  tail -1 refs/pulse-ledger.jsonl | jq -e . >/dev/null && echo "ledger row: valid JSON"
  ```

  Replace every `<...>` in NOTE before you run it. A week with no actions and a quiet
  radar logs `"outcome":"quiet"`. A failed radar logs `"outcome":"partial"`.
- `br sync --flush-only`. Then run Step 5. Then commit by explicit path:
  `.beads/issues.jsonl`, `refs/pulse-ledger.jsonl`, `SUBMISSIONS.md` if radar changed it,
  the Step 4 lint-fix paths, and the Step 8 handoff note. Subject
  `:broom: aaif-weekly <YYYY-Www>: <n> closed, <n> folded`, trailer `Bead: aaif-ub9x`.
  Push. On rejection: `git fetch origin && git merge --no-edit origin/main`, then push
  once more. Never stash.
- Print `AAIF_WEEKLY_RESULT=...` after Step 8.

### Step 8. The window handoff — the final step, every run

Refresh THIS window's note, `refs/session-handoff--aaif-weekly.md`, on every run,
including a quiet one. A stale note must not pose as the next run's state. Resolve the path
through the sanctioned helper, not by hand:

```bash
REPO=/home/ubuntu/aaif; cd "$REPO" || exit 1
. ~/.agents/agents/lib/handoff-path.sh; handoff_path .   # must print ./refs/session-handoff--aaif-weekly.md
```

If it prints any other path, stop: the run is not in the `aaif-weekly` window, and it must
not write the main seat's `--aaif` note. The note holds: the run outcome (the
`AAIF_WEEKLY_RESULT` verdict), the next owner of each open item, the live beads this run
touched or filed, and the desk mail ref (`aaif-weekly-<date>`). Keep the seat front matter
(`handoff_stamp_seat`). A note that belongs to a dead window is deleted, and the commit
names the note that carries its remaining work. Commit it with Step 7's commit (or a
`:card_file_box:` follow-up by explicit path) and push. This is the run's `/offboard`
handoff; arm the molt only per `/offboard` Step 4.

## Budget

About 45 minutes for both parts. A pass that needs more is doing too much. Put the rest
in REPORT as next week's first items.

## Out of scope

The demesne side of this pulse: the `pulse-aaif-weekly` unit pair and its `seats.yml` row
are consul's, and harnessd's manifest loop entry is warden's. pinki's ledger
(`/pinki-steward`, Tue).
