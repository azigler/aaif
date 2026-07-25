# ops/agentgateway — keeping the gateway deployment current

`agentgateway` is an AAIF project under active development. The fleet's gateway
runs a **hand-installed static binary under a service manager** — which means that
without a mechanism it silently rots. This directory is that mechanism.

> Host specifics (which machine, which service label, which ports) are **not** in
> this repo — it's public. The script is parameterized by environment variables and
> the real values live in `.local/gateway-host-inventory.md`.

## The problem it solves

Discovered 2026-07-25: the deployment had **no upgrade path at all**. No package
manager, no periodic job, no update script — the service definition just execs a
binary that was downloaded once (v1.3.1, 2026-07-01) and never touched again.

## Two upstream gotchas this script exists to handle

**1. GitHub's `/releases/latest` is not the latest stable release.**
Upstream mis-flags prereleases. Verified 2026-07-25:

```
$ gh api repos/agentgateway/agentgateway/releases/latest -q '.tag_name, .prerelease'
v1.4.0-beta.1
false          # <-- a BETA, flagged as not-a-prerelease
```

A naive "install latest" updater pushes a beta onto the fleet's governance plane.
So the channel is decided by **semver parsing of the tag name**, never by the API's
`prerelease` boolean.

**2. The config schema drifts between versions.** The binary ships a `migrate`
subcommand ("migrate deprecated local config fields to frontendPolicies"), so a new
version can legitimately reject a config that works today. Every upgrade therefore
validates the **live config** against the **new binary** before anything is swapped.

## The upgrade sequence

`agentgateway-upgrade apply` runs gates in this order and stops at the first failure,
leaving the deployment untouched until the swap point:

| # | Step | On failure |
|---|---|---|
| 1 | Resolve target (semver over tag names; stable unless `--allow-prerelease`/`--to`) | abort |
| 2 | Download `agentgateway` + `agctl` for this OS/arch | abort, nothing touched |
| 3 | **Verify sha256** against the release's `.sha256` asset | abort, nothing touched |
| 4 | Staged binary self-check — it runs and reports the expected version | abort, nothing touched |
| 5 | **`--validate-only` against the LIVE config** (the schema-drift gate) | abort + print the `migrate` hint |
| 6 | Back up current binary + agctl + config to `$AGW_STATE/versions/<ver>/` | abort |
| 7 | **Atomic swap** (same-filesystem `mv`; staging dir sits beside the target) | abort |
| 8 | Restart the service | continue, verify anyway |
| 9 | **Health verify** (below) | **AUTO-ROLLBACK**, exit 20 |
| 10 | Move `agctl` into place, prune old versions, log | warn only — not the serving path |

### What "healthy" means

All four must hold, or the upgrade rolls back:

1. **Readiness** — `$AGW_READY_URL` returns HTTP 200 with body `ready` within
   `$AGW_HEALTH_TIMEOUT` (default 45s).
2. **Version** — the binary now reports the version we installed.
3. **Restart actually happened** — the service PID *changed*. Catches the nasty case
   where the swap succeeded but a stale process is still serving the old binary.
4. **Authz still closed** — every port in `$AGW_GUARDED_PORTS` still rejects
   unauthenticated traffic (401/403). A **200 here fails the upgrade**: for a
   governance gateway, failing open is worse than being down.

## Usage

```bash
agentgateway-upgrade check            # exit 0 current · 10 upgrade avail · 11 prerelease avail
agentgateway-upgrade check --json     # machine-readable, for the scheduled wrapper
agentgateway-upgrade apply            # staged upgrade to latest STABLE (no-op if current)
agentgateway-upgrade apply --dry-run  # run every pre-swap gate, stop before swapping
agentgateway-upgrade apply --to v1.4.0 --dry-run   # rehearse a specific release
agentgateway-upgrade apply --allow-prerelease      # opt in to alpha/beta/rc
agentgateway-upgrade verify           # health-check the running deployment
agentgateway-upgrade status           # versions, service, health, rollback targets, ledger
agentgateway-upgrade rollback         # restore the most recent retained version
agentgateway-upgrade versions         # list retained rollback targets
```

`--dry-run` is the safe way to answer "will the next release accept our config?"
before it's time to actually upgrade.

## Configuration (environment)

| Variable | Default | Notes |
|---|---|---|
| `AGW_REPO` | `agentgateway/agentgateway` | upstream releases source |
| `AGW_BIN` | `$HOME/.local/bin/agentgateway` | the served binary |
| `AGW_CTL_BIN` | `$HOME/.local/bin/agctl` | CLI, upgraded in lockstep |
| `AGW_CONFIG` | `$HOME/.config/agentgateway/config.yaml` | validated pre-swap |
| `AGW_STATE` | `$HOME/.local/share/agentgateway` | backups + ledger |
| `AGW_SERVICE_LABEL` | `com.zig.agentgateway` | launchd label or systemd unit |
| `AGW_READY_URL` | `http://localhost:15021/healthz/ready` | from the config's `readinessAddr` |
| `AGW_GUARDED_PORTS` | `15001 15003` | must answer 401/403 unauthenticated |
| `AGW_KEEP_VERSIONS` | `3` | retained rollback targets |
| `AGW_HEALTH_TIMEOUT` | `45` | seconds to wait for readiness |
| `GITHUB_TOKEN` | — | optional; raises the 60/hr anonymous API rate limit |

**`AGW_GUARDED_PORTS` must list only genuinely auth-guarded ports.** An MCP listener
with no auth policy returns **406** (missing `Accept` header), not 401, and the check
would fail perpetually. Set it to `""` to skip the authz probe entirely.

## Ledger

Every action appends one JSON line to `$AGW_STATE/upgrade-ledger.jsonl`:

```json
{"ts":"2026-07-25T05:02:18Z","action":"apply","result":"ok","from":"1.3.1","to":"v1.4.0-beta.1","detail":"healthy"}
```

`result` is one of `ok` · `noop` · `dry-run` · `blocked` (config rejected) · `error`
· `rolled-back` · `rollback-failed` · `rollback-impossible` · `degraded`.

## Portability notes

- Targets **bash 3.2** — macOS ships 3.2.57 and that is what `/usr/bin/env bash`
  resolves to in a non-interactive SSH session. Empty-array expansion uses the
  3.2-safe `${arr[@]+"${arr[@]}"}` form.
- JSON parsing uses **stdlib `python3`** — the gateway host has no `jq` or `gh`.
- Restart works via `launchctl kickstart -k` (macOS) or `systemctl --user restart`
  (Linux), auto-detected.
- `LC_ALL=C` is pinned because `shasum` is a perl script and leaks locale warnings
  into output on hosts whose `LANG` the SSH session doesn't provide.

## Verification record (2026-07-25)

Tested against a **sacrificial instance** on spare ports under its own launchd
label — the live gateway was never touched (PID 48645 unchanged start to finish).

| Test | Result |
|---|---|
| `check` on a current deployment | `current-prerelease-available`, exit 11 ✅ |
| `apply` when already current | no-op, exit 0, ledger `noop` ✅ |
| `apply --to v1.4.0-beta.1 --dry-run` on the **live** deployment | all pre-swap gates passed, nothing swapped, staging cleaned ✅ |
| sha256 verification | verified for both assets ✅ |
| **live config validates against v1.4.0-beta.1** | ✅ — the 1.4.0 upgrade path is clean |
| `apply` happy path (sacrificial) | 1.3.1 → 1.4.0-beta.1, PID changed, healthy, ledger `ok` ✅ |
| `rollback` command (sacrificial) | 1.4.0-beta.1 → 1.3.1, healthy ✅ |
| **forced post-swap health failure (sacrificial)** | detected, auto-rolled back to 1.3.1, exit 20, loud `MANUAL INTERVENTION REQUIRED`, ledger `rollback-failed` ✅ |

The forced-failure test injected a *permanently* failing probe, so the script
correctly reported that rollback did not clear the condition — the binary did revert
(instance served 1.3.1, healthy) while the artificial check kept failing. That is the
intended semantics: never claim health it cannot observe.
