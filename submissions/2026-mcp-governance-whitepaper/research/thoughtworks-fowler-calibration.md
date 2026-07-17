# Calibration: ThoughtWorks / Martin Fowler "Exploring Gen AI" (local-models)

Zig's reference model for the usefulness + data/graph treatment we're aiming at.
Source articles (Birgitta Böckeler, ThoughtWorks, on martinfowler.com):
- `.../exploring-gen-ai/local-models-for-coding-factors.html`
- `.../exploring-gen-ai/local-models-for-coding-experiences.html`

## What makes them work (emulate these)

- **An explicit evaluation FRAMEWORK with a beginning→end.** The "experiences"
  article runs a **7-step viability funnel** (RAM check → speed → tool-calling →
  correctness → context → complexity → code quality). Gives the reader a repeatable
  lens and a clear start/finish. **→ our experiment needs its own funnel/framework.**
- **A consistent per-item template.** The "factors" article uses `Impacts:` /
  `My experience:` on every factor. Skimmable, comparable. **→ use a fixed template
  per workflow-config / per intervention.**
- **Upfront scope + setup, stated concretely.** Hardware, models, quantization,
  harness, context settings — reproducible bullet points. **→ state our gateway
  config, workflow configs, task, and metric definitions upfront.**
- **Real DATA, embedded near the finding** (not one big table): concrete pass/fail
  ratios ("failed 5 of 7 times", "succeeded 2/2"), timing anecdotes ("gave up after
  11 minutes"). **→ our per-workflow merge/revert/rework/cost numbers, inline.**
- **VISUALS do two distinct jobs:**
  - a **systems diagram** of interacting factors (boxes + labeled arrows) carries the
    *conceptual* complexity → **our LaTeX diagram of `config-hash → tool usage →
    outcome`, the governance loop.**
  - **result SCREENSHOTS** (success AND a memorable **failure** — the "text wall of
    doom") + a **cross-run COMPARISON graphic** carry the *concrete* evidence →
    **our gateway-log excerpts, allow/deny snippets, and a trend/comparison chart
    across permission interventions.**
  - a **final setup CHECKLIST** = a takeaway card the reader acts on.
- **Honest limitations, stated plainly.** "unstructured", "hit and miss", "this
  remains a mystery to me". Divergent/contradictory results reported, not hidden.
  **→ report our contrivance + limits openly; it builds the exact credibility Zig wants.**
- **Voice:** first-person, candid, humble, credible. A single clear recommendation
  at the end. **→ matches Zig's register; pair with `/zig-voice`.**

## The gap to beat

Their main weakness (per the analysis): the "factors" piece has **no quantitative
charts/tables**. We have an advantage — the gateway request log is real, queryable
data. **Once we have the data, MAKE THE GRAPHS** (trend of held-rate vs tool-scope,
cost-to-outcome per config-hash, allow/deny over the intervention). Graphs +
diagrams are what turn this from an essay into a case study, and they carry across
whitepaper (LaTeX) → blog (embedded PNG) → workshop.

## The one-line lesson

Böckeler earns trust by being **specific, reproducible, honest, and visual** about a
**hands-on experiment**. Our experiment must do the same for the MCP governance loop —
that is the whole point of running it instead of asserting it.
