# Session handoff — aaif bootstrap (2026-06-24)

Bootstrapped the AAIF Ambassador harness for **Zig** (Andrew Zigler; address him
as Zig, byline stays Andrew Zigler). Repo is live, public, and a submodule of
`~/explore`.

## What's built (all committed + pushed)

- **Public repo** `azigler/aaif` (github.com/azigler/aaif), wired as an
  `~/explore` submodule. `main` is clean.
- **Harness** `CLAUDE.md` — mission (top-ambassador = points × quality ×
  usefulness, monthly), anti-slop prime directive, 8-step `/submission` pipeline,
  cadence model (pulse → anchor → tentpole → opportunistic), routing, beads
  taxonomy. `/submission` skill + `.claude/practices.md`.
- **`refs/`** — program mechanics (distilled from the handbook), top-ambassador
  strategy, brand/social playbook, 4 project briefs (MCP, goose,
  AGENTS.md+public-agents, agentgateway+working-groups), brand kit.
- **Beads** (prefix `aaif`): epic `aaif-ambassador-program-18o` + 24 open
  (6 opening-move submissions, 13-idea backlog, WG/cadence/setup). `br ready`.
- **`.local/`** (gitignored, PRIVATE, read-like-refs): source PDFs in
  `program-pdfs/`, Asana hub IDs + logging convention in `private-notes.md`.

## Privacy posture (important)

- Source PDFs were briefly committed at bootstrap, then **scrubbed from git
  history (filter-repo) + force-pushed**; Zig accepted the tiny residual-blob
  risk (fresh repo, GitHub GCs unreferenced objects). **Never republish the
  PDFs.** Distilled notes only.
- `.local/` is the private half of the brain: **read it for grounding, never
  leak its contents** (IDs/secrets/verbatim PDFs) into tracked files, beads,
  commits, or published artifacts.

## OPEN — pick up here

1. **Strategic fork not yet decided (Zig: "wrap up here" — deferred):** the
   ambassador **signature**. My recommendation: **harness-operator primary +
   local-first secondary** (most unique; best fit with AAIF's anti-slop ethos).
   Alt: local-first/sovereign primary. This decides the first anchor:
   harness-operator → the tighter **"What AGENTS.md gives agents that READMEs
   don't"** explainer; local-first → the **goose local-inference** tutorial. Suggested
   arc: explainer → robot-fleet flagship (bead .6) → goose tutorial (bead .8).
2. **Venues (Zig confirmed):** canonical submit-URL = **his own blog/site** or a
   **LinkedIn article**; **Dev Interrupted is amplify-only, never the submit
   URL** (avoids the "promotional" non-qualify trap). Vendor-neutral framing;
   LinearB tie = one closing link. A substantive, project-tied Dev Interrupted
   piece *can* count, but submit the neutral canonical URL.
3. **Human action items (Zig):** bead `.2` — get added to the AAIF submissions
   repo + confirm the issue template + Discord invite + badge-kit link (blocks
   *submitting* anything). Bead `.3` — confirm hashtag (#AAIFAmbassador vs
   #AAAmbassador) with ambassadors@aaif.io.
4. **Asana write-path TODO:** no connector for Zig's personal Asana org in the
   bootstrap session — monthly logging to the planning hub is **manual** for now
   (harness drafts the update text). IDs/convention in `.local/private-notes.md`.

## Recommended next action

Settle the signature (item 1), then run `/submission` on the first anchor — you
can **build + publish** now; you can't **submit** until bead `.2` is done.
Strongest lane remains **AGENTS.md + public-agents** (empty foundation repo,
Zig's exact `SKILL.md` format).
