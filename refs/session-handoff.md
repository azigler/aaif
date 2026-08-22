# Session handoff — 2026-08-21/22 · f673ef33 (The Envoy; resumed mid-day as 245361a8 — see Warnings)

## State at offboard
- Branch `main`, all pushed (aaif → 3582fc5+beads, az3 → 3f87ff4, demesne → 3bf3f5e)
- In-flight subagents: none (5 dispatched today, all returned/merged/reaped); no background tasks
- **STAYS RUNNING: transient unit `aaif-stage-review`** — serves the SNAPSHOT COPY at
  `~/.local/share/aaif-stage/client` (NOT live out/ — az3's pipeline regenerates that) on
  http://zig-computer.tailfb4637.ts.net:18271/ . Transient = does NOT survive reboot; recreate via
  camp-publish Step 2.5 rev. Stop after Zig signs off.
- Dirty files: only gitignored submission staging (drafts, PREVIEW, dataset — by design)

## What happened this session (the short version of another very long day)
1. **A2A intake** (Zig's flag): refs/projects/a2a.md (verified brief) + idea aaif-j3v — headline:
   agentgateway parses A2A telemetry but has ZERO a2a.* CEL attributes vs ~19 mcp.*.
2. **Clare Liguori MCP episode SUBMITTED** on Zig's explicit go: aaif/ambassadors#703
   (auto-label verified), bead aaif-xtx, SUBMISSIONS.md row. Predicted podcast_guest 20,
   medium confidence (host-vs-guest + vendor-hosted both unobserved in the corpus).
3. **The anchor went v9 → v11 on Zig's big feedback** (FEEDBACK-ZIG-v3.md = the contract):
   reframed to his software-factory arc (Lloyd's equation, per-unit denominator; staged title
   "Every task my fleet completes now carries its price"); synthetic "Brownout" dataset
   (DATASET-brownout.json, checksummed, 24 beads/8 seats/$491.95/$8,900) walks four widget
   states ending on the seat-ranking INVERSION; real 37-hour numbers fenced beside the
   composite (the anti-"fan-fiction" answer); linearb-copy 25-rule two-pass discipline;
   Fable cold-HN-read + Opus adversarial panel → 5 factual errors + 10-aphorism overrun
   fixed in v11. Body 1,622w. All gates green; 11/11 staged checks; screenshots eyeballed.
4. **az3 widgets shipped** (bd-m6fs, merged fa10a55, CLOSED): BeadGraph showCosts
   (dollars on nodes, seat tint via new shared seat-accent.ts), SeatSpend view=fleet|epic,
   FULL human copy pass (Zig's "cheesy and sloppy" fix), 5 eye-caught defects fixed,
   backward-compat proven on the v9 arrays. NOTE: BeadGraph's DOM root class is `bead-pool`.
5. **Hero durably fixed**: Zig's pick (hero-rings-c-og) on the CDN
   (https://cdn.zig.computer/aaif/gateway-ledger/hero-rings-c-og.png), front-matter absolute URL.
6. **Staging clobber class killed**: az3's own scheduled `npm run build:az` regenerates out/
   (404'd the staged page mid-review) → review server now serves a snapshot copy; camp-publish
   Step 2.5 hardened twice (2e9bbac, 264c701).
7. **Hardening beads filed on Zig's direction**: dotfiles-l1dfk (session-level bead attribution —
   top-level session bead the worked beads attach to).
8. SPEC.md gained Act I-c (C45–C49, the live-join claims, all verify-commanded); DATA.md v2
   (bead-id era pull, aaif-dlr closed) landed earlier same session.

## Friction
- az3 vike dev server unbootable (60s transport timeout; blocks its Playwright suite) → bd-tdb4
- az3 pipeline regenerates out/ mid-review (page 404 + earlier hero deletion) → promoted into
  camp-publish Step 2.5 (2e9bbac, 264c701)
- build renames in/camp notes .md→.mdx (exact-name rm misses) → promoted into Step 2.5 (2e9bbac)
- bundled skills (/dataviz) have no on-disk path for subagents → filed aaif-2ay
- resume split the session id (system-prompt vs task-files/marker; marker id has no transcript)
  → filed dotfiles-tweqa
- agent's probe vite server outlived it and blocked worktree removal (guard worked; killed
  orphans, removed clean) → one-off
- post.sh send takes body POSITIONAL (usage error on --body) → one-off

## Decisions made this session (autonomous decide-and-proceed calls)
- `aaif-nqf` — v9/v11 numbers policy: one window per claim-set (42% narrative week for
  prose+viz... superseded in v10+ by the Brownout composite, whose disclosure+fence framing is
  the successor policy; bead stays as the record of the v9-era call)
- (`aaif-v5k` remains open from the prior session — voice work drafts inline; still honored:
  v10/v11 drafted inline)

## Proposed practices — where each one landed
- Snapshot-copy staging + CDN-for-approved-hero + .mdx-rename note → all written into
  .claude/skills/camp-publish/SKILL.md Step 2.5/3.5 (commits 2e9bbac, 264c701)
- Verify-skill-paths-before-dispatch → filed aaif-2ay (dispatch-discipline home TBD there)

## What's next
- NEXT: Run /aaif-review on DRAFT-v11 (submissions/2026-08-gateway-ledger) and record the scorecard + conformance verdict on aaif-qex BY 2026-08-22T20:00:00Z
- When Zig rules (title/date/appendix/widget sign-off/composite-framing line): execute the
  rulings → /camp-publish → GATED submit (never without his explicit go). Gate 8/24–25.
- Watch #703 (Clare episode) for its scorecard → aaif-xtx AC (capture verdict verbatim,
  esp. if host-vs-guest or vendor grounds bite) + Asana August log still owed.
- Whitepaper arc HOLDS on Zig's three answers (is it live now / REPOSITIONING approval /
  the NO-Fable experiment clause vs burn directive) — my explanation is in-transcript
  2026-08-21; aaif-51g.2 + REPOSITIONING.md are the ground truth.

## Warnings / watch-outs
- **⛔ AAIF surfaces gated on Zig** — absolute, every time (#703 was his explicit go).
- **v11 review sheet** = CHANGES-v11.md; contract = FEEDBACK-ZIG-v3.md; read BOTH plus
  FEEDBACK-ZIG-v2.md before touching a word of the draft. Aphorism budget: ONE (spent on
  "birth certificate").
- **Synthetic/real fencing is load-bearing**: composite numbers never take verified/exact
  language; real facts ($0.098559, $29.61, 1,381/16, 5.7%) stay in their own paragraphs.
  DATASET-brownout.json _meta carries the rule.
- **Session id split** (dotfiles-tweqa): this offboard armed the marker with the
  system-prompt id f673ef33 (the only id passing both asserts); the resumed half ran as
  245361a8 (no transcript JSONL). If .offboard-pending reappears naming 245361a8, it is THIS
  conversation — retro-offboard is satisfied by this note (date-only landing if asserts refuse).
- **Tap**: linearb 5h window was exhausted late 2026-08-21 and has reset; fable-lane burn was
  Zig-authorized through Sun 08:00 PT reset. Re-read the wake header, not this note, for live state.
- Expert seats: works/consul know the gateway side; desk holds the pending-review state
  (mailed twice today, one-bell rule).
