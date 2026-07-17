# Earned autonomy for agent fleets

*Agent telemetry shows you every call and nothing about what the work became. The MCP revision finalizing on 2026-07-28 closes that gap with per-call records you can join to delivery data, and it points at a better basis for deciding how much scope your agents get.*

Every agent workflow in my fleet holds permissions I granted during its pilot. The one I think about most triages inbound issues in my tracker: it earned write access in a two-week trial this spring, the grant has stood since, and I have never once checked whether the labels it applies stick or get peeled off by the humans downstream. Every grant in the fleet has a version of that story, and I'd bet yours does too. Adoption decides what an agent may touch, and adoption is the moment you know the least about what it will deliver.

The gap costs you the day someone asks whether the agents are paying off. Activity is all your agent-side telemetry can show: calls made, changes opened, tokens burned. Whether those changes merged, held in production, or got redone by the people who reviewed them lives in a different ledger, kept in version control, and nothing joins the two. The workflow that ships durable changes and the workflow whose output your team keeps rewriting look identical from the agent's side of the wire.

Accuracy metrics don't close this, because accuracy is measured at the call. A well-formed tool call can open a change your team reverts three days later, and no call-level metric registers the revert. Grading autonomy on accuracy compounds the problem: the ladder widens a workflow's scope when its scores are high, and high scores arrive exactly when humans are examining its output the least.

## What changes on July 28

Typed tool schemas and structured results aren't new; MCP has carried those for multiple revisions. What the 2026-07-28 revision changes is narrower: it removes protocol sessions, so an agent no longer authorizes once at connect time and carries that trust through everything that follows. Authorization is evaluated on every call, and every call therefore arrives with an authenticated principal attached. That is the piece that turns records MCP already produced into something attributable: each call binds a credential you issued to the tool it hit, with inputs and outputs typed against a declared schema and a trace context that follows the action across your gateways into the observability stack you already run. (The text stays a Release Candidate until the 28th, so details can move; the per-call architecture is settled.)

That makes an agent action something you can join on. The trace that begins at a tool call is the same trace your delivery systems see, and the principal on the call is one you issued. "What did this workflow do" and "what did that work become" become queries over records that share keys. Activity metrics already told you the agents were busy. The join is what lets you show whether they delivered.

The spec has two limits. It gives you the record and the per-call enforcement point; what a workflow is allowed to do is still policy you write. And the record attributes actions to an authenticated principal and a client implementation; the notion of "this agent" is a convention you build on top, usually by issuing each workflow configuration its own credential.

## The idea to run with

Once the join exists, set scope with it. Condition a workflow's autonomy on the outcomes it has delivered. The unit that earns trust is the workflow configuration, the durable bundle of model, prompt, tools, and policy: instances are ephemeral and interchangeable, and the configuration is what produced the last change and will produce the next one. A configuration with a trailing record of merged changes that held earns more rope at its next review. A configuration with no record starts small, because the safe grant without evidence is a small one. How you tier it, how often you review, and what counts as held are your calls, tuned to your delivery culture. The part I'm arguing for is the grading basis: the grant gets justified by what shipped.

There's a cultural precedent inside the protocol itself. MCP's official SDKs hold published tiers, earned by measured conformance and downgraded publicly when the measurement lapses. Conformance is a different variable than outcomes, but the habit is the same: standing that gets re-earned on evidence, in the open. The ecosystem shipping this spec already governs itself that way.

Outcome evidence catches reverts and rework, and it will never catch the security defect that merges clean and holds until someone exploits it. Keep review and scanning on every change, agent-authored or otherwise; the outcome record decides scope, not safety.

The full argument needs more room than a blog post: why the field's autonomy ladders grade the wrong variable, and how to build the evidence layer that joins agent actions to delivered outcomes. I'm giving it that room in a whitepaper that's nearly done. You can put the question to your fleet this week: which of the grants your workflows hold would survive being justified by what they've delivered? Start with the ones that wouldn't.

---

*Andrew Zigler is a 2026 AAIF Ambassador. Find the cohort at [aaif.io/ambassadors](https://aaif.io/ambassadors).*