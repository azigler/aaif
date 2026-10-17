# Tutorial rig

This runner creates an isolated agentgateway instance for tutorial screenshots.
It stores its generated config, role keys, gateway log, database, and images in
`$TMPDIR/tutorial-rig-<uid>` (or `/tmp` when `TMPDIR` is unset). Run one rig per
user at a time. The example is generic and has `research` and `builder` roles.

**agentgateway 1.5.0 binds its data ports on all interfaces**, even when the
admin, stats, and readiness addresses use `127.0.0.1`. Every role key is random
for each `up` run. Treat those keys as throwaway. Use this only on a trusted
development machine. The runner never contacts or controls the production
gateway. It excludes ports 15000–15021 and 17017.

```sh
bin/tutorial-rig/rig up bin/tutorial-rig/examples/rig.yaml
bin/tutorial-rig/rig drive bin/tutorial-rig/examples/steps.yaml
bin/tutorial-rig/rig shoot bin/tutorial-rig/examples/shots.yaml
bin/tutorial-rig/rig cards bin/tutorial-rig/examples/cards
bin/tutorial-rig/rig scrub "${TMPDIR:-/tmp}/tutorial-rig-$(id -u)/cards" bin/tutorial-rig/examples/terms.txt
bin/tutorial-rig/rig down
```

`up` checks `ss -ltn`, chooses four free ports, renders the gateway template,
starts `/home/ubuntu/.local/bin/agentgateway` with `nice -n 19`, and waits for
its UI. The template supports `{{ADMIN_PORT}}`, `{{STATS_PORT}}`,
`{{READINESS_PORT}}`, `{{MCP_PORT}}`, `{{RUN_DIR}}`, `{{RIG_DIR}}`, and
`{{ROLE_KEYS}}`. The example uses a local stdio MCP backend with one `ping`
tool.
`drive` reads named curl steps with `endpoint`, `path`, `method`, optional
`role`/`headers`/`body`, and `expect_status`. `shoot` captures named admin UI
paths with optional `width`, `height`, `scale`, and `wait_ms`. `cards` renders
each HTML page's `#card` at 1200 CSS pixels and scale 2. A `data.json` in the
card directory supplies escaped `{{field}}` values. Images go into the run
directory's `shots/` and `cards/` folders.

`scrub` checks every PNG recursively. It fails on an OCR term hit, a home path,
a `100.x` or `192.168.x` address, an `sk-` key, any PNG text or EXIF chunk, or
an image with no OCR words. The terms file has one case-insensitive literal per
line; blank and `#` lines are ignored. Review the images before publication.
`down` stops the gateway process group and confirms its ports are closed with
`ss -ltn`.

To run the end-to-end test on this machine:

```sh
until awk '{exit !($1 < 24)}' /proc/loadavg; do sleep 60; done
nice -n 19 bin/tutorial-rig/test.sh
```

Requirements: Python 3 with PyYAML, `curl`, `ss`, `tesseract`, Node.js,
Playwright at `/home/ubuntu/andrewzigler3/node_modules/playwright`, and its
Chromium browser. The gateway binary is `/home/ubuntu/.local/bin/agentgateway`.
