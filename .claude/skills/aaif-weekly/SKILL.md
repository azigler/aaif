---
name: aaif-weekly
description: aaif's weekly pass. Part 1 is the /aaif-radar scan of the submissions landscape. Part 2 closes the loop on aaif's own beads and repo (close done work with evidence, fold duplicates, release stale claims, re-rank, monthly-floor check, housekeeping lint). Mails the desk only what needs Zig. Fires from the Sat 15:00 PT timer (pulse-aaif-weekly), or by hand ("aaif weekly", "triage aaif").
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

1. Timer lane: never AskUserQuestion. A decision only Zig can make goes in ONE folded
   desk mail (Step 6), and the pass ends.
2. The AAIF hard rules in `CLAUDE.md` hold. This pass never opens, comments on or submits
   anything on an AAIF surface. It never names, ranks or compares other ambassadors in a
   bead, a comment, a commit or the ledger. Nothing from `.local/` goes into a tracked
   file. Close reasons and comments cite bead ids, shas and URLs only.
3. Close with evidence: a merge sha, a live URL that Zig already approved, a closed
   child, or a ledger row. Or close it as STALE (Step 2, item 8), with a `Reopen if:`
   line. A `:card_file_box:` / `beads: file` commit is NEVER evidence,
   even though `/triage` says to "usually just close" an orphan. "Probably done" stays
   open, with a comment that names the missing evidence.
4. Each bead mutation is its own Bash call. A hook block kills the whole call.
5. A negative is a claim. "0 stale beads" needs a printed positive control (the oldest
   open bead's `updated_at`).
6. Print `AAIF_WEEKLY_RESULT=<verdict>` as the last line on every path:
   `ok:acted:<n actions>:<n decisions>`, `ok:quiet`, `partial:radar:<why>`, `blocked:<step>:<why>`,
   `failed:<step>:<why>`.

## Who may do what

| Change | Who decides |
|---|---|
| Close a bead whose work landed (evidence in the close reason) | aaif acts |
| Fold an exact duplicate into the older bead (`-r "duplicate of <id>"`) | aaif acts |
| Close a stale bead with a `Reopen if: <condition>` line (Step 2, item 8) | aaif acts |
| Dispatch a buildable bead to a builder, at most 2 a run (Step 4b) | aaif acts; aaif merges after a different-model SHIP |
| Release a stale `in_progress` claim back to `open` | aaif acts |
| Add a `waits-for` edge, or `br defer --until <date>` on a dated trigger | aaif acts |
| Move a priority by one step, with a one-line comment saying why | aaif acts, at most 5 a week |
| Close a `submission:` bead. A draft, or a piece waiting at the submit gate, stays open | aaif acts only on a live URL Zig approved; else Zig |
| Close an `idea:` or `submission:` bead as won't-do on its merits, or change a month's anchor | Zig, via the desk |
| Close a P1 `human:` bead (title prefix: a decision filed for Zig) | Zig, via the desk |
| Anything on an AAIF surface | Zig, every time (CLAUDE.md hard rule) |

## Step 0 — before Part 1

```bash
REPO=/home/ubuntu/aaif; W=$(date +%G-W%V); mkdir -p "$REPO/.local/aaif-weekly"; cd "$REPO" || exit 1
git status --short | tee "$REPO/.local/aaif-weekly/$W-dirty-before.txt"
```

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

Cap: walk at most the 10 oldest items in each population. Put the rest in REPORT as next
week's first items. In this order:

1. `br list --status in_progress`: a claim with no commit or comment in 7 days is a
   zombie. Release it to `open`, or comment why it is still live.
2. `br orphans --json`: read `latest_commit_message` first (`/triage`'s jq line). A
   filing commit is a false positive: leave the bead alone.
3. `br stale --days 14`: close (rule 3), defer, add an edge, or comment.
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
   stale: the ruling covers it, and the `Reopen if:` line keeps it findable. The close:
   `br close <id> -r "stale: no activity since <date>. Reopen if: <the condition that makes it live again>"`.
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
- `refs/session-handoff.md` older than 14 days while beads moved: note it in REPORT.
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

### Step 6. The one desk mail

Only when a decision is needed from Zig. ONE mail, every item in it, each with a
recommendation and a default. Write the body to MAIL first:

```bash
REPO=/home/ubuntu/aaif; W=$(date +%G-W%V)
bash ~/.agents/agents/lib/post.sh send desk --from aaif --ref aaif-weekly --body-file "$REPO/.local/aaif-weekly/$W-desk.md"
```

Believe only a `POST_SEND_RESULT=` line. No decision means no desk mail.

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
  jq -nc --arg ts "$(date -u +%FT%TZ)" --arg w "$W" --arg note "$NOTE" --arg outcome "$OUTCOME" \
    '{ts:$ts,row:"aaif-weekly",outcome:$outcome,proof:{kind:"cmd",cmd:("grep -q \"^before:\" .local/aaif-weekly/"+$w+".md && grep -q \"^after:\" .local/aaif-weekly/"+$w+".md")},note:$note}' \
    >> refs/pulse-ledger.jsonl
  tail -1 refs/pulse-ledger.jsonl | jq -e . >/dev/null && echo "ledger row: valid JSON"
  ```

  Replace every `<...>` in NOTE before you run it. A week with no actions and a quiet
  radar logs `"outcome":"quiet"`. A failed radar logs `"outcome":"partial"`.
- `br sync --flush-only`. Then run Step 5. Then commit by explicit path:
  `.beads/issues.jsonl`, `refs/pulse-ledger.jsonl`, `SUBMISSIONS.md` if radar changed it,
  and the Step 4 lint-fix paths. Subject
  `:broom: aaif-weekly <YYYY-Www>: <n> closed, <n> folded`, trailer `Bead: aaif-ub9x`.
  Push. On rejection: `git fetch origin && git merge --no-edit origin/main`, then push
  once more. Never stash.
- Print `AAIF_WEEKLY_RESULT=...`.

## Budget

About 45 minutes for both parts. A pass that needs more is doing too much. Put the rest
in REPORT as next week's first items.

## Out of scope

The demesne side of this pulse: the `pulse-aaif-weekly` unit pair and its `seats.yml` row
are consul's, and harnessd's manifest loop entry is warden's. pinki's ledger
(`/pinki-steward`, Tue).
