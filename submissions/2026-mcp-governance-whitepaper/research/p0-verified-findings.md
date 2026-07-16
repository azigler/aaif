# P0 — verified findings (claim inventory)

> The `/research-paper` P0 grounding pass for this whitepaper. Every load-bearing
> fact below was verified against a **primary source** by a read-only research
> agent (bead `aaif-wzz`). This is the claim inventory the `/spec` test cases and
> every drafted sentence answer to. **Nothing ships uncited.** Re-verify every
> normative MCP MUST/SHOULD at Final (2026-07-28) before publish.
>
> Vendor-neutral: this file cites only public/practitioner evidence and the spec.

## 1. MCP / SEP facts — the govern-by-measurement spine is solid

`refs/projects/mcp.md` (the repo's MCP brief) is the SEP source of record and
verified **remarkably accurate**. Load-bearing facts, all confirmed against the
`modelcontextprotocol.io` draft changelog, the SEP PRs, and the community pages:

**The stateless release (the "2026-07-28 spec"):**
- **SEP-2567** — remove protocol sessions / `Mcp-Session-Id`; explicit server-minted state handles. **Final.** (The Explicit-Handle Pattern is **guidance, not an API** — "no `handles/*` method, no handle type in the schema, no wire-level concept of a handle at all." Quotable verbatim.)
- **SEP-2575** — remove `initialize` handshake; per-request version+capabilities in `_meta`; adds `server/discover`.
- **SEP-2468** — OAuth: clients MUST validate a present `iss` against the recorded issuer (RFC 9207).
- **SEP-2243** — require `Mcp-Method` + `Mcp-Name` routing headers on Streamable-HTTP POST.
- **SEP-414** — W3C/OTel trace-context conventions (`traceparent`/`tracestate`/`baggage`) in `_meta`.
- **SEP-2106** — tool `inputSchema`/`outputSchema` lifted to full JSON Schema 2020-12.
- **SEP-2549** — `CacheableResult`: **require** `ttlMs` + `cacheScope` (`public`/`private`) on the list/read methods. (REQUIRED, not optional — matters if we lean on cache economics.)

**The governance-by-measurement machinery (the spine — factually confirmed):**
- **SEP-2484** — a Standards-Track SEP with observable behavior **cannot reach Final without a matching conformance scenario** in the conformance repo. Gate is on the **Accepted→Final** transition. Final 2026-06-04.
- **SDK tiers** — conformance tests live **2026-01-23**; tiering published **2026-02-23**. **Tier 1 = 100%** pass; **Tier 2 = 80%**; Tier 3 = none. **Relegation:** Tier 1→2 if **any** test fails continuously for **4 weeks**; Tier 2→3 if >20% fail 4 wks.
- **SEP-2596** — feature lifecycle Active→Deprecated→Removed, **min 12-month** window **measured from revision release** (not SEP-Final), ≥90-day expedited-removal floor for active security risk.
- **SEP-2577** — deprecates Roots/Sampling/Logging (annotation-only, still functional). Logging → **stderr/OpenTelemetry**; this is **diagnostic** logging, never an outcome/value primitive.

**⚠ THE ACCURACY GATE (resolved — load-bearing for the spine):**
Only the **SAFE** claim ships: *"The 2026-07-28 release ships into a conformance-gated, SDK-tiered ecosystem — a conformance suite live since 2026-01-23, published SDK tiers since 2026-02-23, and, as of SEP-2484 (Final 2026-06-04), a standing rule that **future** Standards-Track SEPs cannot reach Final without a matching conformance scenario."*
**Do NOT write** "every 7-28 SEP was conformance-gated from birth" — SEP-2484 is forward-governing, reached Final *after* the RC text locked (2026-05-21), and isn't in the 7-28 changelog.

**Status:** 2026-07-28 is a Release Candidate (RC locked 2026-05-21); current Final = **2025-11-25**. Re-verify normative claims at Final.

**Minor `refs/projects/mcp.md` refinements** (not errors): notification stream settled as `subscriptions/listen`; of the OAuth SEP set only 2468/837/2352 are changelog-enumerated (2207/2350/2351 are RC-blog-sourced — verify before citing as normative); SEP-2164 (error-code) is blog-attributed; the SDK-tier-system SEP number (SEP-1777) is blog-sourced — verify its PR before citing a number.

Sources: modelcontextprotocol.io/specification/draft/changelog · /seps/2567-sessionless-mcp · /community/sdk-tiers · /community/feature-lifecycle · github.com/modelcontextprotocol/modelcontextprotocol/pull/2484 · blog.modelcontextprotocol.io RC post.

## 2. External evidence base (the "stakes") — one must-fix

**⚠ MUST-FIX — MIT NANDA is mis-cited in our earlier drafts.** The shorthand "~95% of GenAI pilots fail to reach production" is **wrong** and a leader-reader will catch it.
- The **95%** = enterprise GenAI initiatives with **no measurable P&L return** (MIT Media Lab **Project NANDA**, *"The GenAI Divide: State of AI in Business 2025,"* ~300 initiatives / 52 interviews / 153 surveys).
- **"Reach production" is a *different* NANDA stat:** the funnel **~60% evaluated → 20% pilot → 5% production**.
- **Safe phrasing:** *"MIT's Project NANDA found ~95% of enterprise GenAI initiatives showed no measurable P&L return."* Attribute to **NANDA / MIT Media Lab** (not "MIT" flatly). Optional footnote: reflects custom enterprise pilots; the same report found ~90% of workers use personal ("shadow") AI productively.

**DORA 2025** (*State of AI-assisted Software Development*, 2025-09-23, ~5,000 respondents): **two distinct relationships** — a **positive** one with throughput, a **negative** one with stability. "AI **amplifies** what's already there" (strong teams improve, weak teams worsen). Note the YoY flip (2024 throughput relationship was negative → positive in 2025). **Don't** flatten to "speed and failure rise together"; frame as *acceleration exposes downstream instability where control systems are weak* (conditional on capability). This is the empirical spine for "measure outcomes, not activity."

**Veracode** (*2025 GenAI Code Security Report*, 2025-07-30): **45% of code samples** introduced an OWASP Top-10 vuln, across 100+ LLMs / 80 tasks / 4 languages (Java **72%**, C# 45%, JS 43%, Python 38%). Flat across model size/recency. Phrase as "45% of AI-generated code **samples**," attribute to Veracode (a security vendor).

**Stanford AI Index** — **two editions, don't blend:** 78% org adoption (2025 ed., 2024 data, up from 55%) vs **88%** (2026 ed., 2025 data). Cite the edition. Agentic-capability trend: SWE-bench Verified ~60%→~100% of human baseline in a year; OSWorld 12%→~66%; agents still fail **~1 in 3** structured-benchmark attempts — useful "capability outrunning readiness" ballast for a governance argument.

Sources: cloud.google.com 2025-dora-report + dora.dev/research/2025 · mlq.ai NANDA PDF · veracode.com/blog/genai-code-security-report · hai.stanford.edu/ai-index/2025 + /2026.

## 3. Novelty & positioning — lead with the join, not the label

**Honest verdict (the theory tested against the landscape):**
- **"Earned / graduated autonomy" is NOT novel or ownable.** The phrase and the ladder (Audit→Assist→Automate), threshold promotion, non-self-promotion, and auto-demotion are all published (Roder's "Earned Autonomy Gradient"; "progressive autonomy" vendors; the "Digital Apprentice" arXiv paper; McKinsey; AWS).
- **The opening:** every existing version conditions autonomy on **agent task-performance** (extraction accuracy, override rate, tool-call correctness) — **none on delivered *software* outcomes** (change-failure / revert / held-in-production of agent-authored change).
- **The genuinely novel contribution = the three-way join + the substrate swap:** (1) **delivered software outcomes** as the trust signal (not task-accuracy); (2) enforced at the **per-call (MCP tool-call) boundary** — progressive-autonomy vendors gate *deployment tiers*, not calls; (3) organized by **the standard's own governance-by-measurement** (conformance gates, tiers-with-relegation, lifecycle clock) — a port that is **unpublished** (Slalom's "permission design… with what proof" is one sentence away but doesn't wire it; the "Trusted AI Agent Governance" paper does conformance-for-agents only at the identity layer).
- **Lead with the join + substrate, not with "earned autonomy," or a reviewer calls the frame derivative.**

**Naming (two landmines):**
- **Avoid coining into existing branded category labels** — "delivery intelligence," "software engineering intelligence / SEI," "engineering intelligence" are established analyst/vendor category names; a vendor-neutral paper must not adopt one.
- **"Delivery context layer" collides** with the context-engineering "context layer" (IBM "structured context layer," McKinsey "AI memory layer," the academic "context engineering layer") — those mean *input context fed to agents to act*, the **opposite** of our *outcome context fed to the authorizer to govern*. If kept, define sharply on first use and contrast explicitly; a more self-disambiguating name (foregrounding *attribution* / *outcome feedback*) collides less.

**Grounding terms to cite (real, practitioner, neutral):** the "attribution gap" (DORA can't distinguish AI- from human-authored code), "false velocity" (DX), DX Core 4, DORA change-failure rate, Slalom "permission design / with what proof," IBM "structured context layer," EPAM "junior autonomy ratio," CNCF Sandbox→Incubation→Graduated (the standards-body governance-by-measurement precedent).

Sources: getdx.com (Core 4, DORA-metrics attribution) · slalom.com outcome-engines · ibm.com/think radical-application-development · arxiv.org/pdf/2606.04321 (Digital Apprentice) · aaif.io/blog/mcp-is-growing-up · contribute.cncf.io/projects/lifecycle · mightybot.ai / mindstudio.ai (progressive autonomy) · mckinsey.com trust-in-the-age-of-agents · aws.amazon.com agentic-ai security principles.
