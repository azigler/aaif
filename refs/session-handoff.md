# Session handoff — 2026-07-25 5f673502

## ⭐ STATE: the gateway host now stays up to date automatically. Timer armed.

Zig redirected this session away from the whitepaper write-up to a live infra question:
*does the agentgateway on pico stay up to date, or does it sit stale?* Answer: it sat
stale with **no mechanism at all**. That's now fixed, scheduled, and verified.

The whitepaper write-up phase (prior handoff, see git history of this file) is
**untouched and still queued** — resume there when Zig steers back.

## State at offboard
- Branch: `main`, clean. Last commit `3eddb41` (ops: the scheduled update loop).
- Open beads: 51. `aaif-oei` (this work) closeable; `aaif-51g.2` still in_progress
  (whitepaper case-study write-up, unchanged).
- In-flight subagents: none. Background runs: none.
- Both hosts verified healthy at offboard (see INFRA STATE).

## What shipped
1. **`ops/gateway-host/`** (new) — `agentgateway-upgrade`, `ollama-upgrade`,
   `host-update` (the scheduled loop), `deploy.sh`, systemd unit templates, README.
2. **Timer armed** on zig-computer: `gateway-host-update.timer`, daily 04:17 local,
   `Persistent=true`, next run **Sun 2026-07-26 04:24 UTC**.
3. **ollama upgraded 0.30.8 → 0.32.3** (was 9 stable releases behind).
4. **Two real bugs fixed in `~/dotfiles/`** (own beads, pushed):
   - `ubuntu.upgrade.sh` installed agentgateway **betas** via
     `/releases/latest/download/` — and had already put v1.4.0-beta.1 on zig-computer
     at 04:11 that morning. Now semver-stable + sha256-verified. (`dotfiles-6uj`)
   - New `pico.upgrade.sh` — the macOS counterpart of ubuntu.upgrade.sh. (`dotfiles-6io`)
5. **`.local/gateway-host-inventory.md`** — the full private audit of every
   off-the-shelf binary on the gateway host and its update path.

## Decisions made this session
- `aaif-ntx` — pin `tailscale` out of the unattended brew upgrade (the loop rides the
  tailnet; a botched 04:17 tailscaled upgrade would take the gateway offline AND remove
  the only remote fix path). Reversible: `brew unpin tailscale` / `BREW_PIN=""`.

## ⚠️ A CORRECTION I made mid-session — don't re-introduce the wrong version
I first reported ollama as **unsupervised** and one reboot from taking local inference
down. **That was wrong.** `/Library/LaunchDaemons/com.zig.ollama.plist` (a *system*
LaunchDaemon Zig created 2026-06-12) had `RunAtLoad` + `KeepAlive`, `UserName pico`, and
all 7 `OLLAMA_*` vars pinned including the tailnet `OLLAMA_HOST`. It was correct all along.

Why I got it wrong: a system-domain job is **invisible** from `gui/<uid>` (`print` →
`Bad request`, `bootout` → `No such process`) while it keeps respawning — it reads exactly
like an unkillable ghost. My one early check of `/Library/LaunchDaemons/` was defeated by
**zsh aborting the whole command on the first glob having no match**, so the output read
as "no system-level plists."

Cost: I created a duplicate user LaunchAgent for an already-supervised service; the two
fought over port 11434 (32 bind errors, three failed upgrade attempts). Removed; host
verified back to a single supervisor. The corrected account lives in the README
(gotcha 5), `.local/gateway-host-inventory.md`, and the `aaif-oei` notes.

## Four gotchas now encoded in the scripts + README — read before touching this
1. **GitHub `/releases/latest` lies for agentgateway** — returns `v1.4.0-beta.1` with
   `prerelease: false`. Decide the channel by semver over **tag names**, never the flag.
2. **A system-domain launchd job is invisible from `gui/<uid>`.** Check every domain AND
   `/Library/LaunchDaemons/` before concluding anything about supervision.
3. **`KeepAlive: {SuccessfulExit: false}` is wrong for a server restarted via
   `kickstart -k`** — the graceful kill exits 0, launchd calls it done and refuses to
   restart, leaving the service silently DOWN. Test supervision with **SIGTERM**, not
   just `kill -9` (which exits non-zero and passes under either setting).
4. **`mv -f newlink existing-symlink-to-a-dir` FOLLOWS the symlink** and moves the source
   *inside* the directory, exiting 0. It silently no-op'd three upgrades. Use `rename(2)`
   (python `os.rename`), and **assert the symlink afterward**.

## What's next
1. **Nothing required** — the loop runs itself at 04:17. First unattended run tonight.
2. Zig may want to review the first `brew upgrade` run (48 formulas on a box also running
   postgres + a desktop session). `host-update --check` shows what's pending, changes
   nothing.
3. `v1.4.0` agentgateway stable is imminent (beta tagged 2026-07-25). It **already
   validates against the live config** (verified by dry-run), so the loop will take it
   automatically when it goes stable.
4. **Resume the whitepaper write-up** when Zig steers back — figures from
   `matrix-behavior.json`, §6 case study per `REPOSITIONING.md`, blog reshape (`aaif-uf3`).

## Warnings / watch-outs
- **Never bootout/bootstrap to restart** a launchd job on that host — `bootout` leaves a
  pending spawn that grabs the port and creates a respawn loop. Use `kickstart -k`.
- **Zig's AAIF submit-gate** still stands: nothing to AAIF / andrewzigler.com / LinkedIn
  without explicit go-ahead. Untouched this session.
- The experiment gateway from the whitepaper arc is **still running** on pico (spare
  ports, isolated). Tear down when the figures are done:
  `ssh pico "pkill -f 'agentgateway -f /tmp/exp-gateway.yaml'"`.
- `~/ollama.log` was 1.4 GB unrotated; truncated, and `pico.upgrade.sh` now caps service
  logs over 100 MB. macOS has no logrotate — don't assume rotation exists.
- `brew` and the service binaries are **not** in a non-interactive SSH PATH on pico. Use
  absolute paths in anything scripted.

## INFRA STATE (verified at offboard)
- agentgateway **1.3.1**, pid 48645, user LaunchAgent, readiness `ready`, guarded ports
  still 401. Untouched all session — its PID never changed.
- ollama **0.32.3**, pid 49551, system LaunchDaemon `active count = 1`, single process,
  real inference verified over the tailnet from zig-computer.
- Updaters installed at `~/.local/libexec/host-update/` on the gateway host.
- zig-computer's agentgateway reverted from the accidental beta to **stable 1.3.1**
  (checksum-verified; nothing serves it there).
- `brew list --pinned` → `tailscale`.
