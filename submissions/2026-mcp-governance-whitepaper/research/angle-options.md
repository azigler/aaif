# Angle lock — the contract

> This is the Step-4 angle-lock **contract** for the whitepaper. It exists to
> prevent redraft thrash: once an angle is locked here, drafting proceeds against
> it and does not relitigate the spine. Changes to the locked angle are a
> deliberate decision, recorded — not a drift.
>
> **Status: LOCKED.** Vendor-neutral throughout — the paper points only to the
> category / capability and to external evidence, never to any product, vendor,
> customer, or peer.

## Locked title (working)

**"Earned Autonomy: Governing Agent Fleets on the 2026-07-28 MCP Spec."**

## The bridge (one move)

The 2026-07-28 spec turns agent activity into **structured, attributable,
enforceable events**. A higher-level delivery-outcome / context layer turns those
events into **answers and steering**. Together they **close the loop** that lets
an organization run autonomous work on evidence rather than on faith.

The spec is the enabler and is celebrated as such — never faulted. The paper's
contribution is the layer *above* the protocol and the governance philosophy that
connects them.

## The layer, defined (one store, two faces)

A single delivery-context store with a **write path** and a **read path**. Four
capabilities:

**Write path**

- **Attribute** — authorship-segment delivered change. Join the spec's per-call
  action records to VCS and CI/CD events, so a delivered change carries a
  legible answer to "which autonomous work produced this, and through what path."
- **Evaluate** — attach outcome signals to each agent-authored change:
  change-failure / revert / rework / override-before-merge / held-in-production,
  plus cost-to-outcome. These are *delivery* signals, not activity counts.

**Read path**

- **Serve** — hand deterministic, typed, freshness-contracted context back to the
  agents, delivered over the spec's own substrate (the same protocol that emitted
  the events also carries the answers back).
- **Steer** — feed evaluations into boundary policy: the outcomes an agent has
  actually delivered set the autonomy it is granted next. **Framed as forward
  agenda**, not as a shipped system — see the honesty valves in `REVIEW-NOTES.md`.

## The spine (Earned Autonomy)

The spec **governs itself by measurement**: conformance-gated changes (a
Standards-Track change lands into a conformance-gated, SDK-tiered ecosystem),
tiered SDKs with public relegation, and a 12-month deprecation lifecycle clock.
That is a working model of *earned* standing — capabilities keep their status by
demonstrated conformance, and lose it publicly when they don't.

The paper **ports that philosophy to agent fleets**: autonomy is *earned by
delivered outcomes* and adjusted at the **per-call enforcement point the spec
provides**. The mapping the paper states honestly:

- The **spec** = the **actuator + legibility** (it enforces at the call boundary
  and makes activity legible).
- The **layer** = the **sensor + evidence** (it observes outcomes and holds the
  evidence).
- The **policy engine between them** = **the organization's own build** — not
  something the spec ships. The paper is explicit that this middle piece is the
  reader's to build; it does not claim the protocol provides it.

## Boundary conditions (make it credible)

The paper puts these first-class, not in a footnote — they are what separate the
argument from a slogan:

- **Attribution lag** — outcomes arrive after the change. Use **rolling trust
  windows** rather than instantaneous scoring.
- **Unstable identity** — the unit of trust is a **workflow configuration**, not
  an agent instance. Instances are ephemeral; the configuration that produced the
  work is the durable thing to attribute to and to govern.
- **Goodhart** — gate on **held-in-production** signals, **never on activity
  counts**. The moment the metric is a throughput count, it is gamed.
- **Small-n** — with too few observations, **default to the sandbox**. Autonomy is
  earned from evidence; absent evidence, the safe default is low autonomy.

## The 6-section spine

1. **The question that predates the spec** — ROI on autonomous work. Stakes:
   the MIT / Project NANDA finding that ~95% of enterprise GenAI initiatives show
   no measurable P&L return (NOT "fail to reach production" — that is a separate
   NANDA funnel stat); the DORA 2025 result that AI *amplifies* what a team already
   is — a positive relationship with delivery throughput and a negative one with
   stability, so acceleration exposes instability where control systems are weak.
   The governance question is older than the protocol; the protocol changes what
   we can answer it *with*. (See research/p0-verified-findings.md for exact figures + sources.)
2. **What the spec makes legible + enforceable** — the SEP walk: per-call action
   records, per-call enforcement point, the stateless core, the conformance /
   lifecycle machinery. The celebration of the spec, **earned** by walking the
   actual mechanisms.
3. **The loop above the protocol** — atoms don't compose into answers. The
   protocol's horizon ends at the tool boundary; individual action records don't,
   by themselves, answer "is this fleet delivering?" A layer is needed to compose
   them.
4. **The delivery-context layer defined** — the four capabilities (Attribute,
   Evaluate, Serve, Steer), the one-store-two-faces shape, the freshness contract.
5. **Earned autonomy** — the conformance-culture port; the boundary conditions
   (above) as first-class; the two honesty valves (per-call authorization is an
   enforcement point, not a scope-semantics engine; per-call identity attributes
   to the authenticated principal + client implementation, not to an individual
   agent).
6. **Recommendations + evaluation checklist** — what an engineering leader does
   Monday: what to instrument, what to gate on, what to defer, and a checklist for
   evaluating a delivery-context layer against these criteria.

## Alternatives considered (the decision trail)

Recorded so a later reader sees the forks and why the spine won.

### (a) "Govern the tool call, not the aggregate" — folded in, not the spine

A clean governance frame: enforce at the individual call rather than reasoning
about aggregate behavior. **Why it lost the spine:** it had no hook and read thin
on its own — a correct observation without a thesis. **Disposition:** folded in as
a **supporting point** inside Section 2/5 (the per-call enforcement point is real
and load-bearing), but not the organizing idea.

### (b) The "accountability trap" — considered → reframed

An earlier framing anchored the two-plane gap (activity vs. outcome) to
**statelessness**, as if the spec *created* the accountability gap by removing
sessions. **Why it was reframed:** a maintainer can puncture it — **sessions were
correlation state, never a value ledger.** The gap between "what agents did" and
"what they delivered" was **always there**; the stateless turn didn't open it. The
spec proves only the *enabling* half (it makes activity legible and enforceable);
it never claimed to close the outcome gap. **Disposition:** kept as a
**considered → reframed** entry. The honest version — the spec is the enabler, the
outcome layer is the reader's to build — became the bridge above. Framing the spec
as the *cause* of the gap would have faulted it, which this paper does not do.
