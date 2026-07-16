# MCP / SEP grounding — the verbatim-source pointer tier

> This is the `/research-paper` **verbatim-sources** tier for this whitepaper:
> source material accrues here (quoted precisely, cited), while our own analysis
> lives in `../research/`. Keep the split clean — sources here, argument there.

## SEP source of record

The verbatim SEP grounding lives in the repo's public MCP brief:

- **`../../../refs/projects/mcp.md`** — the researched, cross-verified
  contribution-surface brief and the 2026-07-28 deep brief (the stateless
  release), including the authoritative SEP-number mapping and the accuracy flags.

Deepen it there as needed; that brief is the shared grounding for every MCP piece
in this repo, not a per-submission copy. Quote SEP text verbatim when a normative
MUST/SHOULD is load-bearing, and re-verify against the live changelog at Final —
the 2026-07-28 revision is a Release Candidate; current Final is 2025-11-25.

## External-evidence base (for the stakes)

The Section 1 stakes argument cites external, verifiable evidence — the category
and the numbers, never a vendor or customer:

- **DORA 2025** — AI is an **amplifier**: a *positive* relationship with delivery
  throughput and a *negative* one with stability (strong teams improve, weak teams
  worsen). Frame as "acceleration exposes downstream instability where control
  systems are weak," not "speed and failure rise together."
- **MIT / Project NANDA** — ~95% of enterprise GenAI initiatives show **no
  measurable P&L return** (the ROI gap that predates the protocol). NOT "fail to
  reach production" — that is a separate NANDA funnel stat (60% eval → 20% pilot →
  5% production). Attribute to NANDA / MIT Media Lab.
- **Veracode** — ~45% of AI-generated code ships with an OWASP Top-10
  vulnerability (the quality-at-scale risk).
- **Stanford AI Index** — adoption / capability trend baseline.

Verify each figure against its primary source at Final before it ships (the
anti-slop gate); attach the citation to the specific claim it supports.

## The split, restated

- **`refs/` (here)** = verbatim source material — SEP text pointers + the
  external-evidence base.
- **`research/`** = our own distilled analysis and the angle contract.

Private strategy and source documents stay in the repo's `.local/` tier — never
committed, never quoted here.
