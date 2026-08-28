# The draft-review surface — Zig's standing weekly process (ruled 2026-08-28)

> Zig's ruling, on holding the first terminal-delivered draft: the draft must land
> "in a place where I can review it… a page… hosted over the Tailnet… This is a
> practice we do every week so it needs to deliver it that way… And this needs to be
> the process for how that works." EVERY draft review ships this way, unasked.

## The mechanism (reuses /camp-publish Step 2.5 — that section owns the deep detail)
1. Working draft → lexicon-valid PREVIEW.md (Step 1 frontmatter; placeholder
   `published:` = today PT; working title staged as-is — reviewing the title is part
   of the point). Strip ALL HTML comments (MDX), the H1, internal markers.
2. MDX compile check → `SKIP_CAMP_FETCH=1 BUILD_TARGET=www-andrewzigler-com npx vite
   build` in ~/andrewzigler3 → verify `out/…/client/feed/<slug>/index.html` exists →
   remove the note from `in/camp/` immediately.
3. `rsync -a --delete` the built client dir to `~/.local/share/aaif-stage/client/`
   (NEVER serve live `out/` — az3's scheduled rebuild clobbers it mid-review).
4. Serve the snapshot tailnet-only:
   `systemd-run --user --unit=aaif-stage-review --working-directory=$HOME/.local/share/aaif-stage/client python3 -m http.server 18271 --bind $(tailscale ip -4)`
   (transient unit; does not survive reboot; recreate per review cycle. NEVER bind
   0.0.0.0 — this box carries the public edge; pre-approval content never touches
   the public CDN.)
5. Verify BEFORE alerting: curl 200 + content markers (title, close line) + loopback
   refused + a headless screenshot eyeballed.
6. Hand Zig the PLAIN URL (SSH+tmux — no markdown links):
   http://zig-computer.tailfb4637.ts.net:18271/feed/<slug>/
   State the placeholders in the review message (published date, hero, title status).
7. After his sign-off or teardown ruling: `systemctl --user stop aaif-stage-review`.

## Why the terminal delivery failed (the lesson)
Inline text ≠ reviewable. He reviews the RENDERED page — the artifact that will
actually ship — title, layout, rhythm on the page. "Make the artifact you'll
actually deliver" (his 2026-08-16 rule; re-ruled 2026-08-28 as the standing weekly
process after one draft shipped inline).
