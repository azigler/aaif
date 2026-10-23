# OpenSandbox: contribution-surface brief

OpenSandbox is an open agent isolation platform. Alibaba Group started it and open-sourced it
in December 2025 (aaif/project-proposals#26). It joined AAIF on 2026-10-22, at MCPCon NA.

- Repo: https://github.com/opensandbox-group/OpenSandbox (moved from `alibaba/OpenSandbox`;
  the old URL redirects). Default branch `main`.
- AAIF explainer: https://aaif.io/blog/the-sandbox-as-an-agent-primitive
- Shape: a **server** with a lifecycle API (create, pause, resume, delete) sends each request
  to a runtime. The runtime creates a Docker container or a Kubernetes workload. **execd**, a
  small daemon inside each sandbox, runs commands and moves files over HTTP. SDKs exist for
  several languages.

## What we measured (one small VPS, Docker runtime, release 1.1.1)

Our own trials for the estate refactor (aaif-oylh.4, then the tutorial bead
aaif-ambassador-program-18o.57). Medians over 5 repetitions: create 1.4 s, a command 0.4 s,
pause 0.2 s, resume 0.2 s, delete 0.6 s. An idle worker used 6.5 MiB; the server idled at
104 MiB. The worker ran as uid 1000, capped at 2 CPU / 4 GiB.

Facts a contributor or tutorial reader needs:
- Server API key: env `OPENSANDBOX_SERVER_API_KEY`; clients send the `OPEN-SANDBOX-API-KEY`
  header. Without it the server answers 401 `MISSING_API_KEY`.
- execd token: env `EXECD_ACCESS_TOKEN` per sandbox; clients send `X-EXECD-ACCESS-TOKEN`.
- Pin the server and execd images to the SAME release. execd v1.1.0 waits 1 s after every
  command (1.1.1: 200 ms; tunable with `EXECD_API_GRACE_SHUTDOWN`), and it lacks the
  `/internal/init` route.
- The server takes about 8 s to start answering. Until then Docker's port proxy resets the
  connection, and `curl --retry` does not retry that. Wait in a loop.
- tmux (not OpenSandbox) drops a `;` at the end of a `send-keys -l` argument; escape it as
  `\;`.
- Not shown by our trials: containment of hostile code. Unprivileged user namespaces were off
  on the host, so no inner bubblewrap ran.

## Upstream state (checked 2026-10-23, read-only, nothing filed)

- `/version` reported `0.1.0.dev0` on the release-1.1.1 server: fixed on main by PR #2356.
- PTY output lost when the shell exits right away: open PR #2362 (the same mechanism).
- The Docker egress sidecar has no CPU or memory limits on main
  (`server/opensandbox_server/services/docker/networking.py`); Kubernetes sidecars do. Not
  reported upstream; we have not measured it (we used no network policy). A filing candidate,
  only after the four-check due diligence and Zig's go.
- `example.config.toml` on main still pins `execd:v1.1.0`.

Any issue, PR or comment on this repo is an AAIF surface: nothing goes there without Zig.
