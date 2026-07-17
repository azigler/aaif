# Ship gates — the per-surface QA contract

> The single place that records **which ship gates apply to which surface**, and
> **where each rule was decided**. It transcribes already-made decisions from the
> sources listed at the bottom; it does **not** invent policy. Where the sources
> pull in different directions, the tension is parked in **OPEN — Zig's calls**
> below, unresolved on purpose.

## Why gates are per-surface (the core tension)

One idea — *earned autonomy*, the top level of the MCP-governance whitepaper —
renders across three surfaces, and **each surface has a different vendor policy.**
A single vendor grep cannot serve all three: the same token (`LinearB`) is a
**required named source** on one surface and a **hard failure** on another. So
the gates are keyed to the surface, not to the repo.

| Surface | Vendor policy in one line | Decided in |
|---|---|---|
| **Whitepaper** (LF long-form) | LinearB is the **intentionally-named** benchmark source + byline affiliation; its customers stay out; competitor engineering-intelligence products stay out (DORA-only). | `submissions/2026-mcp-governance-whitepaper/REVIEW-NOTES.md` (round-4c) |
| **andrewzigler.com blog** (the accessible lead) | **Strictly vendor-neutral** — no LinearB at all, no product/proof point; point at the category/tooling only. | bead `aaif-uf3` |
| **AAIF submission** (Ambassador issue + aaif.io blog intake) | Vendor-neutral; member-company posts carry a vendor tie only as **one or two closing sentences with a single external link.** | `.claude/skills/aaif-blog-guidelines/SKILL.md` |

The whitepaper and the blog are **the same idea at two altitudes** (`aaif-uf3`),
yet their vendor rules are opposites. That is not a mistake to reconcile away — it
is the reason this contract exists.

---

## Surface 1 — The whitepaper (LF long-form)

Path: `submissions/2026-mcp-governance-whitepaper/`. Format: LaTeX (`article`
class), single artifact `paper/main.pdf`.

### Vendor policy (decided — round-4c, REVIEW-NOTES)

- **LinearB is NAMED, not anonymized.** §3 cites "LinearB's 2026 benchmark
  report" by name (parallel to how the paper names Veracode); the bib entry
  credits LinearB; the byline reads **"Andrew Zigler, LinearB"**. This makes the
  §3 field-evidence cite transparent-first-party rather than concealed. The
  in-paper COI footnote was added then **removed at Zig's request**; the
  org-level disclosure to the LF at submission is the backstop.
- **Cite once.** The §3 field-evidence use is the only place. The §6
  product-recommendation use was **cut** (a named-employer stat backing a
  product-category recommendation reads as positioning).
- **Customers stay OUT.** LinearB's customers (Expedia / Adobe / Syngenta) never
  appear.
- **Competitors stay OUT.** The delivery-metrics framing is **DORA-only**; the
  second delivery-metrics framework (DX / "DX Core 4" / getdx) and its bib entry
  were cut. Any peer engineering-intelligence product name appearing is a gate
  failure, same class as naming a customer.
- **Standing optics gate:** §4's capabilities and §6's checklist stay in pure
  capability language — no product nouns shaped like a named vendor tool. With
  LinearB on the page the category→product hunt is one search shorter, so this is
  load-bearing.

### Mechanical gates — mechanized in `gates.sh`

Run `submissions/2026-mcp-governance-whitepaper/gates.sh`. It prints PASS/FAIL
per gate and exits nonzero on any failure.

| Gate | Rule | Source |
|---|---|---|
| `build` | `latexmk -pdf main.tex` builds clean, PDF produced | REVIEW-NOTES "Build command" |
| `page-count` | rendered PDF is **exactly 8 pages** | REVIEW-NOTES (held 8pp across rounds) |
| `undefined-citations` | build log has **0** undefined citations/references | pipeline QA gate `citations-resolve` |
| `tbd-sweep` | no `TBD / TODO / FIXME / XXX / [placeholder]` in source or PDF | pipeline QA gate `no-placeholders` |
| `no-mcp-1.0` | the string `MCP 1.0` never appears (it is "the 2026-07-28 spec") | REVIEW-NOTES owner-judgment (a) |
| `customers-absent` | Expedia / Adobe / Syngenta absent | REVIEW-NOTES round-4c |
| `competitors-absent` | peer engineering-intelligence product names absent (DORA-only) | REVIEW-NOTES (DORA-only) |
| `linearb-allowed` | LinearB **present** (informational — the allowed named source) | REVIEW-NOTES round-4c |
| `no-em-dash` | rendered PDF has **0** em-dashes (`—`, U+2014) | REVIEW-NOTES lexicon (Fable rounds) |
| `no-actually` | the literal word " actually " absent | REVIEW-NOTES lexicon (Fable rounds) |

> Note the asymmetry: `linearb-allowed` is **informational** here. On the blog it
> would be a hard FAIL. Do not copy this script to another surface.

### Human gates — NOT mechanizable (→ REVIEW-NOTES.md)

The accuracy gates and the two honesty valves are judgment, not grep. Do not try
to mechanize them; the authoritative ledger is
`submissions/2026-mcp-governance-whitepaper/REVIEW-NOTES.md`:

- Accuracy: "the 2026-07-28 spec" (date-versioned, RC until 7-28, Final is
  2025-11-25 — re-verify every normative MUST/SHOULD at Final); the
  Explicit-Handle Pattern is **not** an API; the deprecated Logging is
  **diagnostic only**; three citations need a canonical locator confirmed.
- Honesty valves: per-call authorization is an **enforcement point, not a scope
  engine**; per-call identity attributes to the **principal + client**, not to an
  individual agent.
- Owner judgment: subtitle, layer name, voice pass (`/zig-voice`), final sign-off.
- **HARD GATE:** nothing lands on an AAIF / LF surface without Zig's explicit
  go-ahead, every time.

---

## Surface 2 — andrewzigler.com blog (the accessible lead)

Bead: `aaif-uf3`. The accessible, news-pegged lead of the whitepaper's idea;
ships via `/camp-publish` to andrewzigler.com, then feeds a Dev Interrupted
Friday news segment. Draws from the **same locked foundation** as the whitepaper
and renders it higher.

### Vendor policy (decided — `aaif-uf3`)

- **Strictly vendor-neutral.** No LinearB, no product, no proof point. Point at
  the category / tooling only. This is the **opposite** of the whitepaper's
  policy: on this surface a `LinearB` hit is a hard failure.

### Mechanical / editorial gates

| Gate | Rule | Source |
|---|---|---|
| vendor-neutral | LinearB / product names / customers **absent** (hard fail) | `aaif-uf3` |
| length | ~800–1200 words, one idea | `aaif-uf3` |
| no-mcp-1.0 | "the 2026-07-28 spec," never "MCP 1.0" | `aaif-uf3` (inherited accuracy gate) |
| accuracy (inherited) | SAFE "the release lands into a conformance-gated, SDK-tiered ecosystem"; UNSAFE "every 7-28 SEP was gated from birth"; RC-until-7-28 tense; Explicit-Handle-Pattern-not-an-API; Logging-deprecation-diagnostic | `aaif-uf3` / REVIEW-NOTES |
| lexicon | `/zig-voice` anti-slop (no AIisms, no number-matrix headers, no hypophora, no cheesy hooks); no em-dash; no " actually " | `aaif-uf3` |
| build | `/camp-publish` lexicon frontmatter + MDX transform build-validates | CLAUDE.md (Publish step) |

> `gates.sh` does **not** cover this surface. Its vendor gate is inverted here.

### Human gate

`/aaif-review` self-check + Andrew manual check. **HARD GATE:** no publish/submit
to any AAIF / LF / DI surface without Zig's explicit go-ahead.

---

## Surface 3 — AAIF submission

Two distinct sub-surfaces with different bars.

### 3a — Ambassador Contribution Submission issue (a pointer)

An issue in the AAIF Ambassador submissions repo: GitHub handle `azigler` ·
contribution URL · related AAIF project(s) · notes. It carries **no prose of its
own** — the vendor policy is whatever the linked artifact carries.

| Gate | Rule | Source |
|---|---|---|
| url-live | the contribution URL is public/reachable before submit | CLAUDE.md submit step |
| project-tie | names a real AAIF project (MCP / goose / AGENTS.md / agentgateway / a WG) | CLAUDE.md |
| **HARD GATE** | never open the issue without Zig's explicit go-ahead | CLAUDE.md hard rule |

`/aaif-review` drafts the exact issue body and stops at the gate.

### 3b — AAIF blog intake (aaif.io)

Governed by `.claude/skills/aaif-blog-guidelines/SKILL.md` (Angie Jones / AAIF).

| Gate | Rule | Source |
|---|---|---|
| vendor-neutral | member-company posts vendor-neutral throughout; vendor tie = **one or two closing sentences, a single external link** | blog guidelines |
| length | 600–1500 words (deep-dives may run longer) | blog guidelines |
| original | original + unpublished; timely (past ~2 months) | blog guidelines |
| no-discouragement | no criticism that discourages adoption of any OSS project | blog guidelines |
| narrative | narrative structure, not a press release / one-pager | blog guidelines |
| package | title · author · bio · headshot/logo · social copy · hashtags · date · review-complete confirmation | blog guidelines checklist |
| **HARD GATE** | never submit without Zig's explicit go-ahead | CLAUDE.md hard rule |

---

## OPEN — Zig's calls (unresolved cross-surface conflicts)

These are **not resolved here.** Each is a genuine tension between two sources.

**OPEN-A — Blog neutrality vs linking to a LinearB-named whitepaper.**
`aaif-uf3` requires the blog to be *strictly vendor-neutral* **and** to
*cross-link both ways* to the whitepaper as its "fully-fleshed exploration." But
the whitepaper it links to names LinearB in-body and carries an
"Andrew Zigler, LinearB" byline. Does a strictly-neutral blog that links to a
LinearB-named paper still count as neutral, or does the outbound link inherit the
destination's vendor posture? A grep on the blog alone cannot answer this.
→ Zig's call.

**OPEN-B — Which AAIF surface the LinearB-named whitepaper targets, and how far
the named-LinearB exception extends.** The whitepaper's in-body LinearB naming +
byline is the plan for an **LF whitepaper channel** with an org-level disclosure
to the LF (REVIEW-NOTES). The **AAIF blog intake** (Surface 3b), by contrast,
permits a vendor tie only as one closing link and requires vendor-neutral
throughout — which the in-body-named whitepaper does not meet. Meanwhile the repo
default (CLAUDE.md) is "vendor-neutral (LinearB tie = one closing link max)," and
the whitepaper is a Zig-approved *exception* to it. Open: is the whitepaper routed
to the LF whitepaper channel **only** (naming + disclosure = the plan), and not to
the AAIF blog intake — or does an AAIF-blog-intake path require a
neutrality-stripped variant? Does the named-LinearB exception stop at LF
publication or extend to AAIF-facing surfaces? → Zig + LF (org-level; settle with
Ben).

**OPEN-C — Publish scheduling depends on the LinearB report URL.** The whitepaper
**cannot publish before the LinearB report's public URL exists** — §3's field
evidence resolves to nothing until then (REVIEW-NOTES). This couples the LF
timeline to the report release calendar. It is a human release-gate, not a QA
check `gates.sh` can run. → Zig's call.

---

## Source ledger (where each rule was transcribed from)

- `submissions/2026-mcp-governance-whitepaper/REVIEW-NOTES.md` — the whitepaper's
  decisions log (round-4c LinearB naming, DORA-only, customers-out, byline,
  lexicon, 8pp, the honesty valves, the standing optics gate, OPEN-B/OPEN-C
  dependencies).
- bead `aaif-uf3` — the andrewzigler.com blog's strict-neutrality policy, the
  two-altitudes framing, the inherited accuracy gates, the cross-link mandate
  (OPEN-A).
- `.claude/skills/aaif-blog-guidelines/SKILL.md` — the AAIF blog intake bar
  (Surface 3b): vendor-neutral, one closing link, narrative, length, package.
- `refs/research-paper-pipeline.md` — the venue-neutral build/hygiene QA gates
  (build, page/length, citations-resolve, placeholders, vendor scrub) the
  whitepaper's mechanical gates instantiate.
- `CLAUDE.md` (repo) — the standing "vendor-neutral (one closing link max)"
  default and the AAIF-surface HARD GATE that overrides "always push."
