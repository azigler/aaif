# The research-paper pipeline — a venue-neutral cookbook

The deep reference behind the `/research-paper` skill. It is the paper-lane
counterpart of `refs/gateway-request-log-cookbook.md`: the skill stays a thin
"when / how to fire" layer, and the mechanics — the full loop, the directory
skeleton, the QA gates, the REVIEW-NOTES ledger — live here.

This cookbook describes a **reusable production loop for a long-form research
paper, position paper, or whitepaper**. It was ported from the loop that wrote,
compiled, submitted, and revised a real peer-reviewed paper (the "mise" paper);
that project is the worked example the QA gates and the REVIEW-NOTES pattern are
drawn from. But the loop here is **self-contained** — a cold reader can run it
with nothing but this file, the aaif harness, and the global skills the
"Effort" and "Compose, don't reimplement" sections name. Nothing in the core
loop requires any external paper repo to be present; the only thing that points
outward is the clearly-delimited **optional academic-venue layer** at the end.

Because this repo is public, the pipeline is itself an open-learning artifact —
"here's the whitepaper pipeline I actually run." Keep it presentable.

## The invariant (state it plainly)

Everything below is scaffolding around seven rules. If you remember nothing
else, remember these:

1. **`refs/` is verbatim sources; `research/` is our analysis.** Never blur the
   line. A source captured in `refs/` must always grep back to the original
   wording. Our reading of it, our angle work, our claim inventory — that is
   `research/`.
2. **Beads are the handoff spine.** Every meaningful chunk of work is a typed
   bead a cold agent can pick up. The bead trail *is* the plan, the decision
   log, and the progress record.
3. **Critics are read-only.** Review passes report findings; they never edit and
   they never run in a worktree. The orchestrator applies what holds up.
4. **One bead = one commit.** Close the bead, then commit with a `Bead:` trailer.
5. **Every claim and placeholder has a grep-able gate before "done."** Each
   statistic is sourced, each term is defined on first use, each budget holds,
   `TBD` is gone — each as a concrete test line, checked, not asserted.
6. **The angle is a contract.** Lock the framing before drafting a sentence; the
   locked angle in `research/angle-options.md` is what every section answers to.
7. **The loop STOPS at the Zig submit-gate.** It drafts, tests, and surfaces a
   ready piece — it never opens an AAIF-facing PR / issue / form. Zig submits.

## The AAIF gates (honor these — CLAUDE.md)

Two hard rules from the repo's CLAUDE.md wrap the whole loop:

- **The Zig submit-gate.** Building and drafting locally is encouraged. Anything
  that lands in AAIF's spotlight — the Ambassador submissions repo, any AAIF
  project repo, the blog intake form, the Discord — is gated on Zig's explicit
  go-ahead, every time. Never assume prior approval carries to the next piece.
  The loop's last act is to STOP and surface the finished piece for review.
- **The `.local` / `refs` two-tier rule.** `refs/` and every committed byte of
  the paper is **public, vendor-neutral working knowledge**: distilled,
  secondhand, no verbatim private-doc content, no attributing anything to an
  unannounced campaign. Private source docs, named infrastructure, campaign
  specifics, Asana IDs, and secrets live in **`.local/`** — read inward for
  grounding, never leak outward. When a detail is borderline, ask before
  committing. Keep the framing vendor-neutral; a product tie is at most one
  closing link.

## The canonical directory skeleton

One paper = one folder under `submissions/<YYYY-MM>-<slug>/` (or a dedicated
project root for a large initiative). The shape:

```
<project>/
├── README.md              # public, vendor-neutral: what the piece is, its status,
│                          #   and the /research-paper loop it follows
├── refs/                  # VERBATIM source material — grep-able back to the original
│   ├── INDEX.md           #   generated once refs/ exceeds ~10 files (generator below)
│   └── <source-files>     #   captured sources; binary + a markdown rendering of each
├── research/
│   └── angle-options.md   # the framings considered + the LOCKED angle as the contract
├── data/                  # extracted evidence (metrics, timings, measured curves)
│   └── .gitkeep           #   placeholder until evidence lands
├── paper/                 # the deliverable — one file per section, an assembled root
│   ├── main.tex           #   LaTeX: preamble + \input-per-section (layout below)
│   │  OR  main.md         #   Markdown/Doc: a root that concatenates section files
│   └── sections/          #   one file per section (introduction, related-work, …)
├── REVIEW-NOTES.md        # the human-gate ledger (pattern below)
└── .beads/                # task tracking — the handoff spine (prefix: this repo's)
```

`paper/` may be `whitepaper/` — pick one name per project and be consistent. The
**format** (LaTeX vs Markdown/Doc) can be deferred until the target venue's
format is known; **everything else in this loop is format-agnostic** and can
start immediately.

### The `\input`-per-section layout (venue-agnostic)

The one structural idea worth copying from the reference paper: a thin root
document that owns the preamble + metadata and then pulls in **one file per
section**. This makes each section an independently-writable, independently-
testable unit — the atom a per-section bead and a worktree agent operate on.

For LaTeX, the root `main.tex` is preamble + title/author/abstract + a list of
`\input{sections/<name>}` lines + bibliography, and nothing else:

```latex
\documentclass{<venue-class-or-a-generic-article>}
% preamble: \usepackage{...}, bibliography style, metadata
\begin{document}
% title / author / abstract / keywords
\input{sections/introduction}
\input{sections/related-work}
\input{sections/methodology}
\input{sections/case-study}
\input{sections/discussion}
\input{sections/conclusion}
\bibliography{references}
\end{document}
```

The **acmart/IEEEtran/LNCS class specifics are venue-coupling — NOT part of this
loop.** For a whitepaper with no academic venue, use a plain `article` class (or
a Markdown root that concatenates `sections/*.md`). The *pattern* — root owns
metadata, sections are separate files — is what ports.

## The loop — phase by phase

Seven phases. Each hands the next a durable artifact. The **effort dial** for
each phase is in its own section below; set it consciously.

### P0 — Research + plan (the angle is a contract)

1. **Fan out the research.** Ground the thesis in real sources. Reuse the global
   research skills — `/research` and `/deep-research` — for the multi-source
   fan-out; **compose them, don't reimplement research orchestration here.**
   Capture what you find as verbatim sources in `refs/` (P1 files them properly).
2. **Explore angles before drafting.** Write `research/angle-options.md` with
   **3–5 framings** the paper could take. Each framing gets: a one-sentence hook,
   the audience promise (what a reader leaves with), the differentiator (why this
   author, why now), a section-outline sketch, and the risk (what makes this
   angle weak / the likely reviewer objection). Use `/randomize` to resist
   collapsing to the modal framing.
3. **Lock the angle.** Pick one; record it in `research/angle-options.md` as the
   **contract**, with the 1–2 rejected alternatives and *why* they lost. If the
   angle walks in already decided, still write the file — a one-line capture of
   the locked angle plus the alternatives considered. The value is that mid-draft
   you can see why this framing won. Every section answers to this contract.
4. **Spec the paper with grep-able test cases.** Fire `/spec` to produce a spec
   bead whose `--description` carries: the overview, the section plan, the claim
   inventory (every statistic and its source), out-of-scope items, and **~10–14
   grep-able test cases** (the catalog + examples are in "The QA gates" below).
   This spec bead is the P2/P3 acceptance contract.

### P1 — Infra + scaffold + data

1. **Scaffold** the directory skeleton above. `br init` the beads DB with a
   unique prefix if this is a fresh project root (never accept the `bd` default);
   inside `submissions/` the repo's own `.beads/` already exists.
2. **Capture verbatim sources into `refs/`.** Convert binary sources (PDF/DOCX)
   to a markdown rendering alongside the original — both live in `refs/` so the
   agent can always grep the source-of-truth text. Summarizing a source *into*
   `refs/` is the anti-pattern; summary belongs in `research/`.
3. **Extract evidence into `data/`.** If the paper rests on measured evidence (a
   timing curve, a metric table, a reference-implementation result), extract it
   into `data/` as its own artifact — separate from the prose that cites it. A
   reader (and a reviewer) should be able to check the number against the data
   file. Deploy read-only agents against any evidence source; never mutate it.
4. **Generate `refs/INDEX.md`** once `refs/` passes ~10 files (generator below).

### P2 — Per-section writing (one bead per section)

- **One feature bead per section.** Each is atomic: 1 file, a clear scope, and
  the subset of the spec's test cases it must turn green. This is the unit a
  worktree subagent claims and completes in one session.
- **Worktree subagents do the writing.** Dispatch per the `/orchestrator` +
  `/dispatch` discipline: the agent claims its bead, drafts the section, applies
  `/zig-voice`, runs its section's test cases, and returns a `/handoff` summary.
  It references `Bead: <id>` in its commit; it does not close the bead.
- **`/zig-voice` on every draft pass**, not just the last. For an academic
  register, formalize the voice without losing its clarity — first-person plural,
  not stilted. Keep `/zig-voice` anti-patterns out ("delve," "leverage," "here's
  the thing," "plot twist").
- **Critic pass before merge.** See "The critic loop" below — read-only, never a
  worktree.

### P3 — Assembly

1. **Merge sections** into the root (`\input`-per-section for LaTeX; a concat
   root for Markdown). No section owns metadata — the root does.
2. **Build clean.** For LaTeX: `latexmk -pdf main.tex` with no fatal errors. For
   Markdown/Doc: run the project's build/render and confirm it produces the
   artifact. The clean build is a test case, not a vibe.
3. **Run the gates.** Length/page budget, the `grep -i TBD` sweep, the link
   audit, and every spec test case — all green (see "The QA gates").
4. **Assemble the references / bibliography** and confirm every in-text citation
   resolves.

### P4 — REVIEW-NOTES gate + `/scrutinize`

1. **Fill `REVIEW-NOTES.md`** (the ledger pattern below): the build command, the
   decisions made, the owner-judgment items, the concern→defense table, the
   publish checklist, and the file inventory. This is the human-readable gate —
   the doc Zig reads to sign off.
2. **Run `/scrutinize`** — the adversarial "disprove done" pass on the whole
   piece. It records its verdict; the piece is not done until the verdict is SHIP
   and Zig has signed off on the content.

### P5 — Gated publish (STOP at the submit-gate)

1. **Publish the accessible version** to andrewzigler.com via `/camp-publish`
   (the paper's blog-lead / accessible rendering). The paper is the anchor; the
   accessible lead is a lighter track of the same locked thesis.
2. **Score-check with `/aaif-review`** — confirm the highest legitimate type +
   points and the verifiability conformance, and draft the submission issue body.
3. **STOP at the Zig submit-gate.** `/aaif-review` produces the drafted issue and
   the conformance verdict and stops. Zig opens the AAIF submission himself. The
   loop does not.

### P6 — Optional revision sub-arc (peer-reviewed venues only)

Only fires if the paper targets a **peer-reviewed venue** that returns reviewer
comments + an accept-with-revisions outcome. Capture reviewer comments verbatim
(in `refs/` or as typed `note` beads), turn them into a revision spec (`/spec`)
with a per-reviewer comment table and a fresh set of grep-able test cases,
dispatch the revisions as worktree feature beads on a `camera-ready`-style branch,
and critic-review every diff before merge. The full academic mechanics
(open-science artifact bundle, DOIs, preprint, camera-ready upload) are the
**optional academic-venue layer** at the end of this file — an LF whitepaper
needs none of it.

## The critic loop (read-only, never a worktree)

Every meaningful draft — each section at P2, then the assembled whole at P3 —
goes through read-only critic passes. Three flavors, applied as needed:

1. **Naive reader** — "I have no context. Does this stand on its own?"
2. **Cold reviewer** — "I'm reading 40 of these. What grabs me, what makes me
   skip? Where's the weak claim?"
3. **Voice pass** — "Does this sound like the author? Any `/zig-voice`
   anti-patterns leaking in?"

Mechanics: dispatch the critic as an `Explore` or `general-purpose` agent with
the full draft text + the critic role — **NEVER a worktree subagent** (critics
review, they don't edit). The critic returns severity-ranked findings; the
orchestrator applies the ones that hold up and re-runs until findings drop below
threshold. The critic loop is what separates a good draft from a shippable one.

## The QA gates — every claim gets a grep-able test case

The load-bearing discipline. Each claim, definition, budget, and placeholder is a
**concrete test line** checked before "done" — not an assertion in a bead. Aim
for **~10–14 test cases** in the spec bead. The format (from the reference
paper's spec) is `TEST` / `INPUT` / `EXPECTED` / `RATIONALE`.

The gates fall into two groups: **claim/content gates** (paper-specific, written
per project) and **build/hygiene gates** (venue-neutral, roughly the same every
time). Concrete examples of both — mix LaTeX (`paper/sections/*.tex`) and
Markdown (`paper/sections/*.md`) as your format dictates:

```
TEST: every-term-defined-on-first-use
INPUT:    grep -n "earned autonomy (EA)" paper/sections/*.tex
EXPECTED: ≥1 hit, in the intro or the first section that uses the term
RATIONALE: A coined term must be introduced on first use, then used as the acronym.

TEST: headline-stat-is-sourced
INPUT:    grep -n "O(subagents" paper/sections/*.tex && grep -rn "cite{" paper/sections/*.tex | grep -i curve
EXPECTED: the headline statistic appears with an adjacent citation or a data/ reference
RATIONALE: Every quantitative claim traces to data/ or a citation — no free-floating numbers.

TEST: claim-inventory-cited
INPUT:    grep -c "cite{" paper/sections/related-work.tex
EXPECTED: ≥N citations (N from the claim inventory in the spec)
RATIONALE: The related-work / grounding section carries the promised evidence base.

TEST: novelty-framing-present
INPUT:    grep -iE "(unlike|in contrast to|distinct from)" paper/sections/introduction.tex paper/sections/related-work.tex
EXPECTED: ≥2 hits — the paper explicitly distinguishes its contribution from prior art
RATIONALE: A reviewer's first question is "how is this new?" — answer it visibly.

TEST: evidence-artifact-exists
INPUT:    ls data/*.md
EXPECTED: the evidence file(s) the case-study section cites all exist
RATIONALE: The measured evidence is a separate, checkable artifact — not baked into prose.

TEST: section-budget
INPUT:    wc -w paper/sections/*.tex
EXPECTED: each section within its planned word budget (from the spec's section plan)
RATIONALE: Length budgets hold section by section, so the whole lands within the page limit.

TEST: no-placeholders-remain
INPUT:    grep -rniE "TBD|TODO|FIXME|\[placeholder\]|XXX" paper/ REVIEW-NOTES.md
EXPECTED: empty
RATIONALE: No placeholder leaks into a "done" draft. For LaTeX, also run the PDF check below.

TEST: no-placeholders-in-pdf
INPUT:    pdftotext paper/main.pdf - | grep -i TBD
EXPECTED: empty
RATIONALE: A [TBD] can hide in the rendered PDF even when the source looks clean. Final-final gate.

TEST: builds-clean
INPUT:    cd paper && latexmk -pdf main.tex 2>&1 | tail -5     # or the Markdown/Doc build
EXPECTED: "Output written on main.pdf" / the artifact renders, no fatal errors
RATIONALE: The deliverable must build reproducibly from a fresh checkout.

TEST: page-or-length-bound
INPUT:    pdfinfo paper/main.pdf | grep Pages                  # or a word/char count for MD/Doc
EXPECTED: ≤N pages (N = the venue/whitepaper length budget)
RATIONALE: The length budget is respected.

TEST: citations-resolve
INPUT:    cd paper && latexmk -pdf main.tex 2>&1 | grep -i "undefined citation\|undefined reference"
EXPECTED: empty
RATIONALE: Every in-text citation resolves to a bibliography entry — no dangling refs.

TEST: link-audit
INPUT:    (see the pypdf link-audit snippet in the optional academic layer, or:)
          grep -roE "https?://[^ )}\"]+" paper/ | sort -u    # then spot-check each resolves
EXPECTED: every URL in the paper is live and points where the prose says it does
RATIONALE: A broken or invisible link is a correctness bug a reader hits before you do.

TEST: vendor-neutral
INPUT:    grep -rIiE "<private-product-names-and-infra>" submissions/<slug>/
EXPECTED: empty (a product tie is at most one closing link, framed vendor-neutrally)
RATIONALE: Committed content is public + vendor-neutral; no .local leakage (CLAUDE.md).
```

The claim/content gates (first five) are written per paper from the claim
inventory; the build/hygiene gates (placeholders, build, length, citations,
links, vendor-neutral) are venue-neutral and recur almost verbatim. Every gate
is checked at P3 assembly and re-checked after any edit.

## The REVIEW-NOTES ledger

`REVIEW-NOTES.md` at the project root is the **human-gate document** — the single
doc Zig reads to sign off. It is generated at P4 and kept current through
revisions. Six parts:

1. **Build** — the exact build command and current artifact state.

   ```markdown
   ## Build
   ```bash
   cd paper && latexmk -pdf main.tex     # or the Markdown/Doc build
   ```
   PDF is at `paper/main.pdf` (N pages). Re-run after any edit.
   ```

2. **Decisions Made** — the load-bearing calls, each with its rationale
   (submission type, title, structure, theoretical framing, any trimming). This
   is the decision log a reviewer or a future agent reads to understand *why* the
   paper is shaped as it is.

3. **Owner Judgment Needed** — the items that are genuinely Zig's call, each with
   options and a recommendation. Timing/framing claims, tone, a specific number
   that hedging can't fully resolve, prior-publication disclosure. These are the
   escalate-to-Zig items; don't decide them silently.

4. **Concern → Defense table** — the likely reviewer/reader objections and the
   paper's honest answer to each. Writing the defense forces you to find the
   weak spots before a reviewer does.

   ```markdown
   | Concern | Our Defense |
   |---|---|
   | Single case study, no controls | Framed as a positioning paper; §N proposes controlled experiments as future work |
   | "Just a blog post" | Adds formalization, grounding, and a research agenda beyond the accessible lead |
   | Coined term is vague | Defined with concrete components + grounding; analogized to <established idea> |
   ```

5. **Publish checklist** — the concrete pass/fail steps before the piece ships:
   the QA gates re-run, the owner-judgment items resolved, the build final, the
   accessible version published. This is the "am I actually done?" list.

6. **File Inventory** — every file and its one-line purpose, so a cold reader
   (and Zig) can navigate the project.

   ```markdown
   | File | Purpose |
   |---|---|
   | `paper/main.tex` | Root — metadata + section includes |
   | `paper/sections/introduction.tex` | Section 1 (~N words) |
   | `data/<evidence>.md` | Extracted evidence the case study cites |
   ```

## The `refs/INDEX.md` generator

Once `refs/` passes ~10 files, generate an index so a fresh agent doesn't waste
tokens scanning the directory. One line per file, first-header as the
description:

```bash
{
  echo "# refs/ index"
  echo ""
  echo "Quick map of reference material in this project."
  echo ""
  for f in refs/*.md; do
    name=$(basename "$f")
    first=$(head -1 "$f" | sed 's/^# *//')
    echo "- [$name]($name) — $first"
  done
} > refs/INDEX.md
```

After regenerating, eyeball the descriptions — first-line headers are usually
accurate but sometimes need clarification. Refresh on every `refs/` change. Skip
the index entirely for `refs/` under ~10 files (listing is cheap there).

## The effort dial (per phase)

Effort is a behavioral signal that affects all tokens — thinking, prose, and tool
calls. Set it consciously per phase; name it and why when it matters. A bare
`Agent` dispatch **inherits the session's effort** — so when a step needs more
intelligence than the session is set to, dispatch it through a **Workflow
`agent({effort})`**, not a plain Agent.

| Phase | Effort | Why |
|---|---|---|
| P0 research + framing | **xhigh** | divergent, exploratory — the default for research and multi-tool agentic work |
| P0 novel-spine / title / abstract brainstorm | **max** (via a Workflow agent) | a genuinely generative, foundational moment — the one phase that most rewards `max`; don't ride the session default through it |
| P1 scaffold | **medium** | mechanical/convergent — spending less here funds the moments that deserve max |
| P1 evidence extraction | **high** | needs judgment about what the data actually shows |
| P2 per-section drafting | **high** | solid single-answer intelligence-sensitive work |
| P3 assembly | **medium** | mechanical merge + gate-running |
| P4 critic / `/scrutinize` | **high–xhigh** | adversarial review rewards depth |
| P5 publish | **high** | careful, but well-specified |
| P6 revision | **high** | targeted, bounded work |

## Compose, don't reimplement

This loop is deliberately thin over the global skills. Reach for them; don't
rebuild them:

- **`/research` + `/deep-research`** — the P0 research fan-out. Compose them.
- **`/randomize`** — angle diversity in P0.
- **`/zig-voice`** — every draft pass.
- **`/scrutinize`** — the P4 adversarial gate.
- **`/aaif-review`** — the P5 score-check + issue drafter (stops at the gate).
- **`/camp-publish`** — publish the accessible version.
- **`/orchestrator` + `/dispatch`** — the P2 worktree-subagent dispatch pattern.
- **`/spec`** — the P0 spec bead with grep-able test cases.

---

## Optional — the academic-venue layer

**This section is a detachable appendix.** Everything above is the core,
venue-neutral loop; an LF whitepaper or a position paper needs none of what
follows. Fire this layer **only when the paper targets a peer-reviewed academic
venue** (a workshop / conference / journal with reviewer comments, a camera-ready
cycle, a named publisher, or open-science / artifact-compliance language).

The full how-to for this layer is **not duplicated here** — it lives in the
global CFP arc, which walks it end-to-end on a real accepted paper:

> **`~/.claude/skills/cfp/reference/scientific-paper-arc.md`** — the complete
> peer-reviewed-paper sub-arc: reviewer-comment capture → revision spec →
> worktree revision dispatch → open-science artifact bundle → Zenodo DOI (via the
> GitHub integration) → arXiv preprint (cs.SE endorsement flow, source-tarball
> build, compile gotchas) → ORCID linking discipline → camera-ready upload +
> e-rights. Read it end-to-end the first time you fire this layer.

What that layer adds on top of the core loop, at a glance:

- **Zenodo** — mint a DOI for a research-artifact bundle (data + code +
  methodology docs, dual-licensed CC-BY / MIT) via the GitHub-release
  integration.
- **arXiv** — a preprint; first-time `cs.SE` submitters need an endorsement
  (async, and NOT a proceedings blocker — don't let it block camera-ready).
- **ORCID** — the `\orcidlink` + inline-`\href` pattern that renders a *visible*
  iD (the bare `\orcid{}` links the name invisibly; the two conflict — see the
  arc doc for the exact fix).
- **EasyChair / HotCRP** — the camera-ready upload + server-side integrity check +
  publisher e-rights flow.
- **ACM/IEEE/LNCS class coupling** — the venue's document class + bibstyle,
  shipped in-repo for reproducible builds. This is the venue-specific coupling
  the core loop deliberately omits.

One venue-neutral tool from that layer is worth surfacing here because the core
loop's **link-audit gate** uses it — a PDF hyperlink audit that catches
"linked-but-invisible" URLs:

```bash
pip install --break-system-packages --user pypdf -q
python3 <<'EOF'
from pypdf import PdfReader
r = PdfReader('paper/main.pdf')
for i, page in enumerate(r.pages):
    for a in page.get('/Annots', []) or []:
        obj = a.get_object()
        if obj.get('/Subtype') == '/Link' and '/A' in obj:
            action = obj['/A'].get_object()
            if '/URI' in action:
                print(f'page {i+1}: {action["/URI"]}')
EOF
```

Cross-reference the printed links against what's *visible* in the rendering; a URL
in the link list that appears nowhere on the page is a bug a reader can't see or
click.
