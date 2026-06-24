# AGENTS.md + aaif/public-agents — contribution surface brief

> Researched 2026-06-24, verified via web fetch + GitHub API. **This is Andrew's
> strongest-fit lane:** he is a power author of agent-guidance files and runs a
> battle-tested multi-agent harness whose patterns map ~1:1 onto both surfaces.

## What AGENTS.md is

A simple, open **Markdown format for guiding coding agents** — "a README for
agents." Cross-vendor origin (OpenAI Codex, Amp, Jules, Cursor, Factory),
contributed by **OpenAI** as a founding AAIF project, **AAIF-stewarded since
2025-12-09**.

- Spec/website repo: **`github.com/agentsmd/agents.md`** — ~22.5k stars, MIT,
  a Next.js site whose homepage *is* the spec (no separate schema doc).
- Adoption: "**over 60,000 open-source projects**," read by **20–30+ agents**
  (Codex, Jules, Factory, Aider, goose, opencode, Zed, Warp, VS Code, Devin,
  Junie, Amp, Cursor, RooCode, Gemini CLI, Copilot, Ona, Windsurf, …).

## What public-agents is

**`github.com/aaif/public-agents`** (MIT) — "public, reusable agent resources
for AAIF: skills, recipes, prompts, agent-facing workflows."

> 🎯 **Headline finding — wide open.** Verified state (2026-06-24): ~4 stars,
> created 2026-05-06, **near-empty**. Only **2 skills exist, both AAIF-internal**
> (`aaif-blog-guidelines`, `aaif-brand-guidelines`). **`recipes/` and `prompts/`
> directories do NOT physically exist** — the lone open PR (#2) is *deleting* the
> README references because nobody populated them. **There is not one
> general-purpose agent-engineering skill in the whole foundation library.**
> First-mover leverage is large and real.

Verified tree:
```
public-agents/
├── AGENTS.md          ← 1 line: "associated GitHub wiki; keep it updated too"
├── README.md          ← describes skills/recipes/prompts/docs
├── LICENSE (MIT)
├── .github/workflows/ ← copilot-test-action.yml, gemini-test-action.yml (smoke tests)
└── skills/
    ├── README.md
    ├── aaif-blog-guidelines/SKILL.md   (author: Angie Jones, AAIF)
    └── aaif-brand-guidelines/SKILL.md  (+ assets/: logos, Instrument Sans fonts)
```

> 🔑 **The format is the SAME one Andrew already uses.** public-agents skills
> follow the open **Agent Skills standard** (`SKILL.md` = YAML frontmatter +
> Markdown body + progressive disclosure; optional `assets/`, `references/`,
> `scripts/`). Required frontmatter: `name` (lowercase-hyphenated, matches
> folder) + `description`; optional `license`, `metadata.{author, organization,
> source, version}`. Distributed via the Skills CLI: `npx skills add
> aaif/public-agents --skill <name> --global`. **No CONTRIBUTING.md exists yet** —
> another opening: whoever proposes the conventions shapes the repo's norms.

## AGENTS.md format & conventions (the real spec surface)

Deliberately minimal — **plain Markdown, no required fields, no frontmatter, no
fixed schema.** Conventional (not mandatory) sections: project overview / stack
with versions · setup & build commands · test commands (exact flags) · code
style · testing · security · commit/PR workflow · dev-env tips.

- **Monorepo rule** (the one structural rule): an `AGENTS.md` per package; the
  **nearest file in the tree wins**.
- **Size:** Codex enforces a **32 KiB cap**; shorter outperforms longer
  (concise files ~28.6% faster execution per a cited study; Copilot's 2,500-file
  analysis says 20–30 lines, command-first).
- **GitHub's "2,500+ files" best practices:** specialists not generalists; six
  areas (commands, testing, structure, code style, git workflow, boundaries);
  command-first w/ exact flags; concrete > abstract; three-tier boundaries
  (always / ask-first / never).

### AGENTS.md vs CLAUDE.md (Andrew's edge)

| | AGENTS.md | CLAUDE.md |
|---|---|---|
| Scope | Cross-tool (20–30+ agents) | Claude Code only |
| Format | Plain markdown | Markdown + `@imports` + hooks + skills |
| Hierarchy | Nearest file wins | Global + project + subdir |
| Size | 32 KiB cap | ~200 lines guideline |

Claude Code does **not** read AGENTS.md natively by default. Bridges: a
`CLAUDE.md` whose first line is `@AGENTS.md`, or `/init` with an existing
AGENTS.md. ~90% content overlap reported — keep Claude-specific features
(imports/hooks/skills) in CLAUDE.md, push shared content to AGENTS.md.

**Live spec debates = contribution openings:** #185 (different AGENTS.md per
agent), #186 (vs workspace.json), #187 (two tools, divergent behavior, one
format), #189 (generated-code safety checks), #184 (a `.agent/` dir + versioned
schema — appetite for formalization), **#207 (enterprise adoption patterns &
anti-patterns — literally requests a catalog).**

## Contribution surface (ranked by fit + openness)

1. **Be first to populate `public-agents/skills/` with general-purpose
   agent-engineering skills.** The repo has zero. His harness skills
   (orchestrator/worktree dispatch, scrutinize gate, beads-style tracking, pulse
   heartbeat, progressive-disclosure digest) are *already in SKILL.md format* —
   copy-adapt-PR.
2. **Build `recipes/` and `prompts/` from nothing** — define the sections PR #2
   is currently deleting for being empty. Highest first-mover leverage in the
   whole foundation library.
3. **Author the missing CONTRIBUTING.md / authoring conventions** for
   public-agents.
4. **AGENTS.md pattern + anti-pattern catalog** — answers open issue #207, builds
   on GitHub's 2,500-repo data + his CLAUDE.md mastery.
5. **The CLAUDE.md → AGENTS.md bridge** — he runs the most elaborate CLAUDE.md
   set in the wild; the canonical migration guide is unwritten. Ties to #185–187.
6. **Tooling** — an AGENTS.md linter/generator, or a CLAUDE.md↔AGENTS.md
   converter shipped as an **MCP server** (a two-project contribution).

## 6 tailored submission ideas

1. **"The CLAUDE.md files that run a robot fleet"** — blog + annotated public
   repo [15]. Publishes his real, battle-tested agent-guidance files as
   master-class examples with line-by-line *why*. Rare production-grade artifact;
   strong Dev Interrupted carry. Edge: his single strongest asset.
2. **"An AGENTS.md pattern catalog: 12 patterns & 8 anti-patterns"** — tutorial +
   PR to agents.md docs answering issue #207 [20]. Evergreen, linkable, SEO-durable
   for a 60k-repo standard with no canonical pattern doc.
3. **"orchestrator-worktree: the first general-purpose skill in
   aaif/public-agents"** — code PR (a `SKILL.md`) + explainer video [5–50 + 15].
   Would be the inaugural non-internal skill in the foundation library,
   installable across goose/Claude Code/Codex/Gemini. Max first-mover signal.
4. **"The scrutinize gate: an adversarial-review recipe for agent fleets"** —
   code PR bootstrapping the empty `recipes/` dir + blog [5–50 + 15]. "How do I
   stop my agent lying that it's done?" is a top unsolved pain; being first in
   `recipes/` makes him author of that section's conventions.
5. **"From CLAUDE.md to AGENTS.md (and back): migration + a converter"** —
   tutorial + small CLI/MCP tool [20]. Two AAIF projects (AGENTS.md + MCP). Every
   Claude Code user wanting cross-tool portability hits this wall.
6. **"Build an agent harness that manages itself"** — course / livestream series
   [50 or 25]. Teaches the self-managing harness (beads, pulse, hooks, digests)
   packaged as installable public-agents skills, demoed on goose + Claude Code.
   Each episode lands one skill/recipe PR → a stream of monthly contributions.

## Accuracy flags

- The AGENTS.md spec repo is `agentsmd/agents.md` (not under `aaif`).
- The AAIF **blog has a vendor-neutral editorial gate** (~600–1,500 words,
  ~2-week lead, narrative, ≤2 posts/month for community contributors). Andrew's
  LinearB tie must stay to a single closing link, vendor-neutral framing.

## Sources

- https://agents.md/ · https://github.com/agentsmd/agents.md · /issues
- https://github.com/aaif/public-agents (+ tree/skills via GitHub API)
- https://github.blog/ai-and-ml/github-copilot/how-to-write-a-great-agents-md-lessons-from-over-2500-repositories/
- https://agentskills.io/specification · https://skills.sh/docs/cli
- https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation
- https://www.anthropic.com/news/donating-the-model-context-protocol-and-establishing-of-the-agentic-ai-foundation · https://openai.com/index/agentic-ai-foundation/
