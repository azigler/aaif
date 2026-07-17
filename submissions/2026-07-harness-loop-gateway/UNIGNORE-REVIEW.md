# UNIGNORE-REVIEW — privacy sign-off for the harness/loop/gateway tutorial

> **Status: NOT un-ignored. Awaiting Zig's review + explicit go-ahead.**
>
> This folder (`submissions/2026-07-harness-loop-gateway/`) is currently
> gitignored by `.gitignore` (`submissions/*`, with a single exception for the
> whitepaper). Its contents are **not tracked and not public**. This document is
> the pre-un-ignore review: a complete inventory of every file that *would*
> become public if the folder is un-ignored, plus a scrub report flagging
> anything private or screenshot-sensitive.
>
> **Nothing here is committed except this review file itself.** The `.gitignore`
> edit and the `git add` of the approved subset happen only after Zig signs off
> below. This doc names sensitive items **by location and category, never by
> value** — no literal IPs, hostnames, or keys are reproduced.

## TL;DR for the reviewer

- **1 hard leak to redact:** a sample gateway request-log line in `article.md`
  contains a **real mesh/tailnet IP** (real octets — not the `100.x.y.z`
  placeholder the rest of that file correctly uses). Must be redacted to a
  placeholder before any publish. See Scrub report #1.
- **4 internal working docs** should **not** publish at all (field notes, the
  conformance dry-run, the design spec, the planning drafts). See dispositions.
- **2 candidate tutorials are duplicates/variants** — pick one canonical file;
  don't ship all three renders.
- **Screenshots:** publish only the `-redacted` variants of the servers/models
  views; visually re-check the two log/analytics views before publish.
- **Images:** the folder holds many *generation candidates* + provenance logs —
  ship only the one selected hero/header, not the exploration set.

## Disposition legend

| Tag | Meaning |
|---|---|
| PUBLISH | Public-safe as-is (still subject to Zig's editorial call). |
| SCRUB→PUBLISH | Publishable *after* the flagged redaction/genericization. |
| EXCLUDE | Internal working artifact — do not un-ignore / do not publish. |
| ZIG-DECIDES | Duplicate/variant or selection call — Zig picks the canonical one. |

## Markdown files (10)

| File | ~Size | What it is | Disposition |
|---|---|---|---|
| `PUBLISH.md` | 21 KB | Publish-ready tutorial ("If you give a Goose an MCP server", frontmatter dated 2026-07-08). | SCRUB→PUBLISH (see #5) · ZIG-DECIDES canonical |
| `TUTORIAL.md` | 23 KB | Latest working render (v9, randomize provenance header). | SCRUB→PUBLISH (see #5) · ZIG-DECIDES canonical |
| `PUBLISH-if-you-give-a-goose-an-mcp-server.md` | 16 KB | A second copy/variant of the publish tutorial (same title/date). | ZIG-DECIDES (likely a stale duplicate) |
| `article.md` | 10 KB | Earlier full-draft tutorial ("Build the o11y and governance plane…"). | SCRUB→PUBLISH (see #1) — but likely superseded by the above |
| `LINKEDIN-POST.md` | 2 KB | Amplify copy (randomize provenance header). | PUBLISH (amplify artifact) |
| `findings.md` | 10 KB | Raw live-deploy field notes — **self-labeled "gitignored working file."** | EXCLUDE (see #2) |
| `AAIF-REVIEW.md` | 4.5 KB | Internal `/aaif-review` conformance dry-run. | EXCLUDE (see #3) |
| `nucleus-spec.md` | 8.8 KB | Internal design spec for the curated tool nucleus. | EXCLUDE (see #4) |
| `walkthrough-outline.md` | 8.6 KB | Planning outline "for Zig's review" — superseded. | EXCLUDE (draft; see #6) |
| `walkthrough-v2-goose.md` | 19 KB | Detailed v2 draft — superseded by `PUBLISH.md`/`TUTORIAL.md`. | EXCLUDE (draft; see #6) |

## Screenshots (`screenshots/`, 13 files)

| File | Note | Disposition |
|---|---|---|
| `01-mcp-servers.png` | Raw servers view. | EXCLUDE — publish the redacted twin |
| `01-servers-redacted.png` | Redacted servers view. | PUBLISH (verify redaction reads clean) |
| `04-models.png` | Raw models view. | EXCLUDE — publish the redacted twin |
| `04-models-redacted.png` | Redacted models view. | PUBLISH (verify redaction reads clean) |
| `04-logs.png`, `04-logs-goose.png` | Request-log views — may show `src.addr` IPs / real server names. | ZIG-DECIDES — **visually re-check for a real mesh IP before publish** |
| `05-analytics.png` | Analytics dashboard. | ZIG-DECIDES — re-check for real identifiers |
| `00-ui-landing.png`, `02-tool-playground.png`, `02-tools.png`, `03-cel-playground.png`, `03-tool-call.png` | UI/tool/CEL views. | PUBLISH pending a visual pass for stray identifiers |

## Images (`images/`, ~35 files across `char/`, `char2/`, `round2/`, `header/`)

These are **image-generation exploration candidates + provenance logs**, not a
finished asset set:

- **Candidates:** `1-`…`8-` style variants, `char/` + `char2/` character sets,
  `round2/` second-pass variants, `header/` header variants (`h1`–`h3`,
  `header-remake-*`). → **Ship only the one selected hero + header.** The rest
  are EXCLUDE (exploration).
- **Provenance logs:** `images/gen.log`, `images/round2/gen.log`,
  `images/header/gen.log`, `images/header/*.out`. → EXCLUDE (generation logs).
- **Brand asset:** `images/header/aaif-logo.png` is the AAIF logo — governed by
  `/aaif-brand-guidelines`; keep only if usage conforms.

## Scrub report (flagged by location + category — no values reproduced)

1. **`article.md` (~line 138) — REAL mesh/tailnet IP in a sample log line.**
   A `src.addr=` in an example request-log line carries real octets, unlike the
   `100.x.y.z` placeholder the same file uses in its config block (and the file
   even says "substitute your own host and tailnet where I use placeholders").
   **Action: redact that one IP to the placeholder before any publish.**

2. **`findings.md` — internal field notes, explicitly gitignored.** Its own
   first line labels it a "gitignored working file." Contains raw deploy notes,
   the gateway host's private machine name, and the internal CC-through-proxy
   saga. **Action: EXCLUDE from the un-ignore.**

3. **`AAIF-REVIEW.md` — internal conformance dry-run.** References the private
   `.local/radar/` grading calibration, a private publish/Mac host, and a read
   of *other participants'* scorecards (the no-peer-gossip surface). **Action:
   EXCLUDE.**

4. **`nucleus-spec.md` — internal design spec.** References the gateway host's
   private config filename (`config-<host>.yaml`) and a private `~/explore/…`
   build path. **Action: EXCLUDE, or scrub the host name + private path first.**

5. **`PUBLISH.md` / `TUTORIAL.md` — genericize the gateway host name.** The
   intended-public tutorials still carry field-note phrasings that name the
   private gateway host ("verified vs `<host>` live config", "against `<host>`:
   401 …"). Per the repo's two-tier rule, **generalize the private machine name
   to a generic "the gateway box" before publish.** (The `localhost:150xx` ports
   are standard admin ports and are fine.)

6. **`walkthrough-outline.md` / `walkthrough-v2-goose.md` — planning drafts.**
   Reference `.local/…` paths and are superseded by the publish tutorials.
   **Action: EXCLUDE as internal drafts.**

7. **General:** no literal API keys / bearer tokens found in the markdown — the
   tutorials use `<goose key>` / `apiKey: { ... }` placeholders throughout. Still
   worth a final grep on any file promoted to publish.

## The un-ignore mechanics (NOT performed here)

For reference only — do **not** run these until sign-off:

- `.gitignore` currently ends with `submissions/*` + `!submissions/2026-mcp-governance-whitepaper/`.
- To publish this folder, add a negation for the approved path (e.g.
  `!submissions/2026-07-harness-loop-gateway/`), then `git add` **only the
  approved subset** (excluded working docs / logs / candidate images stay out,
  either via per-file `.gitignore` negation discipline or simply by not adding
  them).
- Re-run the scrub greps on the final tracked set before committing.

## Sign-off checklist (Zig)

- [ ] `article.md` mesh/tailnet IP redacted (Scrub #1) — or `article.md` dropped.
- [ ] `findings.md`, `AAIF-REVIEW.md`, `nucleus-spec.md`, `walkthrough-outline.md`, `walkthrough-v2-goose.md` confirmed EXCLUDE.
- [ ] Canonical tutorial chosen (one of `PUBLISH.md` / `TUTORIAL.md` / `PUBLISH-if-you-give-a-goose-an-mcp-server.md`).
- [ ] Gateway host name genericized in the chosen tutorial (Scrub #5).
- [ ] Screenshots: only `-redacted` server/model views; log/analytics views visually cleared.
- [ ] Images narrowed to the one selected hero + header; logs/candidates excluded.
- [ ] `.gitignore` negation added + only the approved subset staged.
