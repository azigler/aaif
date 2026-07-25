# ops/gateway-host — keeping the fleet's off-the-shelf services current

The gateway host runs two **off-the-shelf, hand-installed** services the fleet depends on:

| Service | What it is | Updater |
|---|---|---|
| **agentgateway** (+ `agctl`) | the AAIF gateway — MCP + LLM proxy, authz, request log | `agentgateway-upgrade` |
| **ollama** | the local-inference server the gateway's LLM provider proxies to | `ollama-upgrade` |

Both were installed once by hand and had **no upgrade path whatsoever** — no package
manager, no periodic job, no update script. agentgateway is a fast-moving project, so
that guaranteed silent rot. These scripts are the fix.

> Host specifics (which machine, service labels, tailnet addresses) are **not** in this
> repo — it's public. Both scripts are parameterized by environment variables; the real
> values live in `.local/gateway-host-inventory.md`.

## Shared design

Same CLI on both, so there's one thing to learn:

```bash
<updater> check            # exit 0 current · 10 upgrade avail · 11 prerelease avail
<updater> check --json     # machine-readable, for the scheduled wrapper
<updater> apply            # staged upgrade to latest STABLE (no-op if current)
<updater> apply --dry-run  # every pre-swap gate, stop before changing anything
<updater> apply --to v1.4.0 --dry-run    # rehearse a specific release
<updater> apply --allow-prerelease       # opt in to alpha/beta/rc
<updater> verify           # health-check the running deployment
<updater> status           # versions, service, health, rollback targets, ledger
<updater> rollback         # restore the previous version
<updater> versions         # list retained rollback targets
```

Both follow **stage → verify → swap → restart → health-check → auto-rollback**, and
nothing is touched until every pre-swap gate passes. Both append a JSONL ledger
(`result` ∈ `ok` · `noop` · `dry-run` · `blocked` · `error` · `rolled-back` ·
`rollback-failed` · `rollback-impossible` · `degraded`).

`--dry-run` is the safe way to answer *"will the next release work here?"* before it's
time to actually upgrade.

## The upstream gotcha both scripts defend against

**GitHub's `/releases/latest` is not the latest stable release.** Verified 2026-07-25:

```
$ gh api repos/agentgateway/agentgateway/releases/latest -q '.tag_name, .prerelease'
v1.4.0-beta.1
false          # <-- a BETA, flagged as not-a-prerelease
```

Upstream mis-flags prereleases, so a naive "install latest" updater pushes a beta onto
the fleet's governance plane. **Both scripts decide the channel by semver-parsing the
tag name and never read the API's `prerelease` boolean.** The same bug was live in
`~/dotfiles/ubuntu.upgrade.sh` and had already installed that beta (fixed, bead
`dotfiles-6uj`).

## agentgateway-upgrade

Single static binary → atomic `mv` swap. Gate order:

| # | Step | On failure |
|---|---|---|
| 1 | Resolve target (semver over tag names) | abort |
| 2 | Download `agentgateway` + `agctl` for this OS/arch | abort, nothing touched |
| 3 | **Verify sha256** against the release's `.sha256` asset | abort, nothing touched |
| 4 | Staged binary runs and reports the expected version | abort, nothing touched |
| 5 | **`--validate-only` against the LIVE config** | abort + print the `migrate` hint |
| 6 | Back up binary + agctl + config to `$AGW_STATE/versions/<ver>/` | abort |
| 7 | **Atomic swap** (same-filesystem `mv`) | abort |
| 8 | Restart | continue, verify anyway |
| 9 | **Health verify** | **AUTO-ROLLBACK**, exit 20 |
| 10 | Move `agctl` into place, prune, log | warn only — not the serving path |

Step 5 is the schema-drift gate: the binary ships a `migrate` subcommand ("migrate
deprecated local config fields to frontendPolicies"), so a new version genuinely can
reject a config that works today.

**Healthy** requires all four:

1. **Readiness** — `$AGW_READY_URL` returns 200 with body `ready` within `$AGW_HEALTH_TIMEOUT`.
2. **Version** — the binary reports what we installed.
3. **Restart actually happened** — the service PID *changed*. Catches a stale process still serving the old binary.
4. **Authz still closed** — every port in `$AGW_GUARDED_PORTS` still rejects unauthenticated traffic (401/403). A **200 fails the upgrade**: for a governance gateway, failing open is worse than being down.

`AGW_GUARDED_PORTS` must list only genuinely auth-guarded ports. An MCP listener with no
auth policy returns **406** (missing `Accept` header), not 401, and the check would fail
forever. Set it to `""` to skip the authz probe.

| Variable | Default |
|---|---|
| `AGW_REPO` | `agentgateway/agentgateway` |
| `AGW_BIN` / `AGW_CTL_BIN` | `$HOME/.local/bin/agentgateway` / `agctl` |
| `AGW_CONFIG` | `$HOME/.config/agentgateway/config.yaml` |
| `AGW_STATE` | `$HOME/.local/share/agentgateway` |
| `AGW_SERVICE_LABEL` | `com.zig.agentgateway` |
| `AGW_READY_URL` | `http://localhost:15021/healthz/ready` |
| `AGW_GUARDED_PORTS` | `15001 15003` |
| `AGW_KEEP_VERSIONS` / `AGW_HEALTH_TIMEOUT` | `3` / `45` |

## ollama-upgrade

Ollama ships a **flat tarball** (binary + Metal/ggml dylibs, 45 entries, no top-level
directory), so the install shape is a versioned directory plus a `-current` symlink:

```
~/ollama-0.30.8/          <- extracted release
~/ollama-0.32.3/          <- extracted release
~/ollama-current  ->  ~/ollama-0.32.3
```

The launchd job points at the **symlink**, so an upgrade is an atomic symlink swap +
restart and a rollback is the same swap in reverse. No service definition is ever
rewritten, and the model store (`~/.ollama/models`) is never touched.

The symlink swap builds a temp link and `rename()`s it over the target — `ln -sfn`
unlinks first, leaving a window with no symlink at all.

**Healthy** requires:

1. **API version** — `/api/version` reports the version we installed, within `$OLL_HEALTH_TIMEOUT`.
2. **Restart actually happened** — a *new* service PID appeared.
3. **Real inference** — a `/api/generate` call against the smallest installed model
   returns `done: true`. A version string cannot prove the Metal/ggml runner loads;
   only running one can. Set `OLL_INFERENCE_CHECK=0` to skip.

| Variable | Default |
|---|---|
| `OLL_REPO` | `ollama/ollama` |
| `OLL_ROOT` / `OLL_CURRENT` | `$HOME` / `$HOME/ollama-current` |
| `OLL_SERVICE_LABEL` | `com.zig.ollama-serve` |
| `OLL_API` | `http://localhost:11434` — **must match `OLLAMA_HOST`** |
| `OLL_ASSET` | `ollama-darwin.tgz` |
| `OLL_STATE` | `$HOME/.local/share/ollama-upgrade` |
| `OLL_KEEP_VERSIONS` / `OLL_HEALTH_TIMEOUT` / `OLL_RESTART_TIMEOUT` | `2` / `120` / `60` |

**`OLL_API` must point where ollama actually binds.** If `OLLAMA_HOST` is a tailnet
address, a `localhost` probe reports a false failure — the server is fine, the check is
pointed at the wrong interface.

## macOS launchd gotchas — learned the hard way, encoded in the scripts

These cost real time and one failed upgrade on 2026-07-25, and none of them are in
Apple's docs in any useful form.

**1. `launchctl bootout` leaves a pending spawn.** It returns success and the label
disappears from `launchctl print`, but launchd fires one more spawn seconds later. That
delayed instance grabs the port; the next `bootstrap` then fails with
`bind: address already in use`, and `KeepAlive` turns it into an indefinite respawn loop
writing an error every `ThrottleInterval`. Symptom: `active count = 0` /
`state = spawn scheduled` / `last exit code = 1` while a live process holds the port and
`XPC_SERVICE_NAME` names your label.

- **To restart a job: use `launchctl kickstart -k`.** Never bootout+bootstrap.
- **To genuinely stop one:** `launchctl disable`, *then* `bootout`, *then* drain (kill
  and re-check) until you've seen a sustained window with zero processes.
- Repeated bootout/bootstrap can corrupt a label's accounting. A **fresh label** is the
  reliable escape.

**2. `KeepAlive: {SuccessfulExit: false}` is wrong for a server you restart with
`kickstart -k`.** The graceful kill makes the process exit **0**; launchd reads that as a
clean finish and *declines to restart it*. The service stays silently DOWN. This is
exactly what broke the first real ollama upgrade — the health check correctly saw
nothing serving and auto-rolled-back.

- For an always-on server use **`KeepAlive: true`**.
- Test supervision with **SIGTERM**, not just `kill -9`. `kill -9` exits non-zero and
  restarts under either setting, so it passes while the graceful path is broken.

**3. Point the service definition at a `-current` symlink**, not a versioned path. Then
an upgrade never edits the plist, and a rollback is one symlink swap.

**4. `ppid 1` does not mean "detached"** — launchd *is* pid 1, so every launchd child has
ppid 1. Use `XPC_SERVICE_NAME` in the process environment to find which job spawned
something.

## Portability notes

- Targets **bash 3.2** — macOS ships 3.2.57 and that is what `/usr/bin/env bash` resolves
  to in a non-interactive SSH session. Empty-array expansion uses the 3.2-safe
  `${arr[@]+"${arr[@]}"}` form; BSD `sed` has no `\|` alternation, so use `grep -E`.
- JSON parsing uses **stdlib `python3`** — the gateway host has no `jq` and no `gh`.
- Restart auto-detects `launchctl kickstart -k` (macOS) or `systemctl --user restart`.
- `LC_ALL=C` is pinned because `shasum` and `tar` are perl/locale-sensitive and leak
  warnings into output on hosts whose `LANG` the SSH session doesn't provide.
- `brew` and these binaries are **not** in the non-interactive SSH `PATH` — use absolute
  paths in anything scripted.

## Verification record (2026-07-25)

**agentgateway** — tested against a **sacrificial instance** on spare ports under its own
launchd label; the live gateway was never touched (PID 48645 unchanged throughout).

| Test | Result |
|---|---|
| `check` on a current deployment | `current-prerelease-available`, exit 11 ✅ |
| `apply` when already current | no-op, exit 0, ledger `noop` ✅ |
| `apply --to v1.4.0-beta.1 --dry-run` on the **live** deployment | all pre-swap gates passed, nothing swapped, staging cleaned ✅ |
| sha256 verification | verified for both assets ✅ |
| **live config validates against v1.4.0-beta.1** | ✅ — the 1.4.0 stable path is clean |
| `apply` happy path (sacrificial) | 1.3.1 → 1.4.0-beta.1, PID changed, healthy, ledger `ok` ✅ |
| `rollback` command (sacrificial) | 1.4.0-beta.1 → 1.3.1, healthy ✅ |
| **forced post-swap health failure (sacrificial)** | detected, auto-rolled back, exit 20, loud `MANUAL INTERVENTION REQUIRED` ✅ |

**ollama** — tested on the live install (idle: no models loaded, no in-flight requests).

| Test | Result |
|---|---|
| `check` | 0.30.8 installed, v0.32.3 stable, correctly ignored `v0.32.4-rc0`, exit 10 ✅ |
| `verify` incl. real inference | healthy ✅ |
| `apply --dry-run` | downloaded, sha256 ok, extracted, staged self-check 0.32.3, symlink untouched, 10.4 s ✅ |
| **first real `apply`** | health check failed (nothing serving — the `SuccessfulExit` bug above), **auto-rolled back to a healthy 0.30.8**, exit 20, ledger `rolled-back` ✅ |
| 0.32.3 standalone on a spare port | binds in <1 s, Metal GPU discovered, `/api/version` 200 — the release itself is fine ✅ |
| supervision: SIGTERM | restarted in 1 s ✅ |
| supervision: SIGKILL | restarted in 22 s ✅ |

The auto-rollback firing on a *genuine* upgrade rather than a synthetic test is the most
valuable result here: the safety net worked before anyone was watching.
