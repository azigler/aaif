---
name: camp-publish
description: Land a finished article/tutorial into Andrew Zigler's andrewzigler.com publish pipeline — turn a working draft into a lexicon-valid "camp note" (frontmatter + body transform), validate it actually builds, and land it in the source-of-truth vault so the daily build publishes it. This is the "Publish" step (pipeline step 5) for any written AAIF contribution that ships on andrewzigler.com. Use when a tutorial/blog draft is reviewed and ready to go live; STOP short of the separate, gated AAIF submission.
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /camp-publish — publish a finished piece to andrewzigler.com

A reviewed draft becomes a live post at **`andrewzigler.com/feed/<slug>`** by landing a
**camp note** (a frontmatter-typed markdown file) into the source-of-truth vault. The daily
build fetches it, prerenders it, and deploys. This skill produces the note, proves it builds,
and lands it. Private machine/path specifics live in **`.local/camp-publish-infra.md`** — read
that for the concrete SSH target, vault path, and landing command (this file stays generic per
the repo's two-tier rule).

## When to fire
- A written contribution (tutorial, blog, devlog) is drafted, reviewed (`/scrutinize` + a cold
  read), and Zig has okayed the content. This is the **Publish** step of `/submission`.
- NOT the AAIF submission — that's a separate, human-gated GitHub issue (`/aaif-review`), only
  after the piece is publicly live.

## The pipeline (know where the note actually goes)
```
metis Obsidian vault (SOURCE OF TRUTH)  ──fetch-camp.sh──▶  ~/andrewzigler3/in/camp
   .../Zettelkasten/camp/YYYYMMDD <slug>.md   (ssh+tar, live)        (a fetch TARGET, not the source)
                                                       │
                          andrewzigler3-build.timer (daily, 03:00 UTC = 8pm PT, on zig-computer)
                                                       │  Vite + Vike prerender ▶ Vercel deploy
                                                       ▼
                                     https://andrewzigler.com/feed/<slug>
```
- **Source of truth is the metis Obsidian vault's `camp/` folder** — NOT `in/camp` (clobbered on
  every fetch) and NOT the `azigler/zettelkasten` git repo (a backup the *fallback* uses).
- The build pulls camp **live from the vault** at build time. **To make a given day's publish,
  land the note in the vault BEFORE the 03:00 UTC (8pm PT) build.** Fallback path (metis down) reads
  the zettelkasten repo, kept current by metis's backup cron.

## Step 1 — Build the publish note
Start from the reviewed working draft (`submissions/.../TUTORIAL.md`). Produce `PUBLISH.md`:

**Frontmatter — match the article lexicon EXACTLY.** The build's validator
(`vite-plugin-02-validate-frontmatter`) **STRIPS any field not in the lexicon** and injects missing
required ones, so use only these keys:
```yaml
---
title: "<title>"                 # required
published: "YYYY-MM-DD"          # required — the PT date the piece goes live
slug: "<kebab-slug>"            # required — becomes /feed/<slug>
tags:                            # required — these three, verbatim:
  - com.andrewzigler.content.article
  - www-andrewzigler-com         # site tag -> routes it to andrewzigler.com
  - camp-note
image: "https://cdn.zig.computer/.../header.png"   # optional — the hero; host via /cdn
category: "Devlog"              # optional, free string; in use: Devlog · Personal · Review · History
---
```
(Full lexicon: `~/andrewzigler3/public/shared/lexicon/v1/com.andrewzigler.content.article.json`. Other
optional fields: `url`, `last_updated`, `status`, `url_substack`, `url_linkedin`.)

**Body transform** (it's MDX):
- **Strip** the internal provenance HTML comment (MDX has no HTML comments), the **H1** (the title
  renders from frontmatter), and the **top `---` hr** after the dek.
- **Keep** the dek + prose. Start the body with prose/dek (no H1).
- The **hero image goes in frontmatter `image:`**, NOT inline — don't duplicate it at the top of the body.
- Body figures are plain markdown `![alt](https://cdn.zig.computer/...)`. Host every image via **`/cdn`**
  (Zig won't put binaries in the site repo); external CDN URLs render fine.

## Step 2 — Validate it ACTUALLY builds (never land an unvalidated note)
A bad note **fails the whole www build and skips the deploy**, so gate on two checks:

1. **MDX compiles** (fast; catches stray `<`/`{` outside code — the common MDX footgun):
   ```bash
   cd ~/andrewzigler3 && node --input-type=module -e '
     import {compile} from "@mdx-js/mdx"; import fs from "node:fs"; import matter from "gray-matter";
     const {content}=matter(fs.readFileSync(process.argv[1],"utf8"));
     await compile(content).then(()=>console.log("MDX OK")).catch(e=>{console.error("MDX FAIL:",e.message);process.exit(1)});
   ' /path/to/PUBLISH.md
   ```
   (All `<placeholder>` / `{json}` must sit inside backticks or fenced code blocks.)
2. **Full build prerenders the page** (belt-and-suspenders; the real gate). Copy the note into local
   `in/camp/` and build without touching metis:
   ```bash
   cp PUBLISH.md "~/andrewzigler3/in/camp/YYYYMMDD <slug>.md"
   cd ~/andrewzigler3 && SKIP_CAMP_FETCH=1 BUILD_TARGET=www-andrewzigler-com \
     VIKE_CRAWL='{"ignore":"**/sites/zig-computer/**"}' npx vite build
   # PASS = exit 0 AND out/www-andrewzigler-com/client/feed/<slug>/index.html exists
   ```
   `SKIP_CAMP_FETCH=1` stops fetch:camp from clobbering the local note; `in/`+`out/` are gitignored, so
   this has no lasting/tracked effect (the real 8pm fetch re-pulls from the vault).

## Step 3 — Land it in the vault (before the build window)
Write `PUBLISH.md` to the vault's `camp/` as `YYYYMMDD <slug>.md` (space after the date; the path has
spaces → quote it). Exact SSH target + path + command: **`.local/camp-publish-infra.md`**. Then verify
the landed file's frontmatter + line count over SSH. Land **before 03:00 UTC (8pm PT)** to catch that
day's publish.

## Step 4 — Verify after publish
After the build runs, load `https://andrewzigler.com/feed/<slug>` and confirm the title, hero image, and
figures render. Then keep any review gist in sync, and proceed to the (separate, gated) `/aaif-review`
+ AAIF submission with the now-public URL.

## Gotchas (learned building this)
- **Lexicon strips unknown frontmatter fields** — a typo'd key vanishes silently. Match the schema exactly.
- **Date is the PT date.** The build fires 03:00 UTC = 8pm PT; a piece landing the evening of the 8th
  (PT) publishes on the 8th, even though UTC has ticked to the 9th. Filename + `published` use the PT date.
- **MDX ≠ markdown.** Bare `<word>` or `{obj}` in prose is parsed as JSX and breaks the build. Keep them in code.
- **Source is the vault, not `in/camp` or the git repo.** Writing to `in/camp` is pointless (clobbered);
  writing to the zettelkasten repo directly fights the backup cron. Write to the vault.
- **iCloud path has spaces** — always quote the remote path in ssh/scp.

## See also
- `/submission` — the end-to-end contribution pipeline; this is its Publish step.
- `/zig-voice` — the draft must be in his voice before it lands here.
- `/cdn` — host the hero + figures and get the embeddable URLs.
- `/aaif-review` — the SEPARATE, gated AAIF submission that follows publication.
- `.local/camp-publish-infra.md` — the private SSH target, vault path, build timer, and landing command.
