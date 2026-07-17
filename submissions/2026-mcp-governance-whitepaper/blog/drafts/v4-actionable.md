# Earned autonomy for agent fleets

*Agent telemetry shows you every call and nothing about what the work became. You can join the two today with gateway-issued credentials; the MCP revision finalizing on 2026-07-28 makes that join portable.*

Every scope an agent workflow holds was granted at adoption, and adoption is the moment you know the least about what the workflow will deliver. The structural problem comes after: nothing in the stack revisits the grant. Changes get reviewed, incidents get postmortemed, but a scope grant never returns to a docket, because no system owns the question of whether the workflow should still hold it. The scrutiny that issued the permission expires. The permission stays. Run a fleet for a while and the grants pile up, each dated to whatever the workflow looked like when someone approved it.

The gap costs you the day someone asks whether the agents are paying off. Agent-side telemetry can only show activity: calls made, changes opened, tokens burned. Whether those changes merged, held in production, or got rewritten by reviewers lives in version control, and nothing joins the two ledgers. Accuracy metrics don't close the gap either, because accuracy is measured at the call; a well-formed call can open a change your team reverts three days later, and no call-level metric registers the revert. Autonomy ladders graded on accuracy compound this: scope widens when scores are high, and high scores are when humans stop double-checking the output, so the grading data thins right as the grant grows.

## What July 28 standardizes

Nothing in this post waits on the spec. Your gateway can issue per-workflow credentials now, and it already logs calls. What the MCP revision finalizing on July 28 changes is where the machinery lives. It retires protocol sessions, so no session state remains for a server to treat as standing trust; every call carries an authenticated principal, inputs and outputs typed against a declared schema, and a trace context that follows the action into the observability stack you already run. (The text is a Release Candidate until the 28th, so details can move; the per-call architecture is settled.) That moves identity and trace out of your gateway's private convention and into the protocol, so the join survives a change of vendor, gateway, or tool. I tested the per-call path on a live agentgateway while writing the longer version of this argument: two workflow identities, different tool tiers, authorization evaluated on every single call.

The spec hands you the enforcement point and the record. The policy and the join are yours to build, and two moves get you there.

**Give each workflow configuration its own credential.** The spec attributes every call to an authenticated principal; the notion of "this agent" is a convention you build on top. Build it as one credential per workflow configuration, the durable bundle of model, prompt, tools, and policy that produces the work. Share one key across the fleet and everything aggregates into a single anonymous principal, and you can no longer tell which configuration did what, now or in any later query. Budget a day at the gateway for the key-cutting.

**Then run the join once, by hand.** Pick one workflow and one trailing month. Pull its calls from your gateway log, pull the changes it opened from version control, and answer three questions per change: did it merge, did it get reverted, did a human rewrite it before it shipped? A spreadsheet is enough. Decide up front what connects a log row to a pull request, because the MCP principal doesn't appear in git on its own. In practice the join key is a per-workflow bot identity on the commits, a trailer in the commit message naming the workflow, or the trace ID pasted into the PR description; if your setup has none of those, wiring one is the exercise's first finding, and it's an hour of CI config. Do this once and the value question has a computed answer: what a month of one workflow's autonomy delivered, and what the tokens cost per change that held. Rank the fleet on that number and you know which configurations to refit and which to retire.

## The idea to run with

Once the join exists, set scope with it: condition a workflow's autonomy on the outcomes it has delivered. A configuration with a trailing record of merged changes that held earns more rope at its next review; one with no record starts small, because the safe grant without evidence is a small one. How you tier it and how often you review are yours to tune. The part I'm arguing for is the grading basis: scope justified by delivered work rather than call-level scores.

MCP already governs itself this way. Its official SDKs hold published tiers, earned through measured conformance and downgraded publicly when the measurement lapses. Conformance and outcomes are different variables, but the habit transfers: standing that gets re-earned on published evidence and lapses on a schedule.

Two boundaries keep this honest. First, keep review and scanning on every change, agent-authored or otherwise; the outcome record only sets scope, and it will never catch the security defect that merges clean until someone exploits it. Second, watch for gaming. Grade scope on merged-and-not-reverted and workflows drift toward timid changes and split PRs that each clear the bar while the work shrinks; a change-size floor plus a sampled human review of merged changes keeps the number connected to the work it measures.

If both moves feel far off, start cheaper. Build the grant table: one row per workflow configuration, columns for the credential it holds, the scope, the grant date, and what its output has delivered since. The first three columns take an hour. The fourth comes back mostly blank, and the blank is the finding: a fleet of standing permissions, none justified by anything the record can show. The rows you can't fill are where to point the hand-run join.

I'm making the full argument in a forthcoming whitepaper: why autonomy ladders grade the wrong variable, and how the evidence layer gets built as infrastructure instead of a quarterly spreadsheet ritual. The table is where I'd start this week.

---

*Andrew Zigler is a 2026 AAIF Ambassador. Find the cohort at [aaif.io/ambassadors](https://aaif.io/ambassadors).*