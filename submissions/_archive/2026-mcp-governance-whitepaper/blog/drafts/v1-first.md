# Your agent fleet needs a relegation rule

*MCP grades its official SDKs on measured conformance and demotes them in public when the measurement lapses. Before the 2026-07-28 revision finalizes, it's worth asking why your agent workflows get gentler treatment.*

Ask how an agent workflow in your organization got its current permissions and you will usually get a date, not a review. The workflow was adopted, its accuracy numbers looked good in the pilot, someone widened its scope, and the grant has stood ever since because nothing forces anyone to revisit it. Adoption gets an agent in the door. Accuracy metrics keep it there. Both variables stop measuring anything useful the moment the agent starts shipping real changes.

Contrast that with how the Model Context Protocol governs itself. The official SDKs hold published tiers, and Tier 1 requires passing 100% of the public conformance suite. If any test fails for four continuous weeks, the SDK is relegated to Tier 2. Since June, a Standards-Track spec change cannot reach Final until a matching scenario lands in that same suite (SEP-2484). Feature removals run on a published lifecycle with at least twelve months between deprecation and earliest removal, and the July release starts that clock on three early protocol features. Standing here is earned by measurement and lost in public when the measurement lapses. Humans run all of it; no algorithm demotes an SDK. It works.

The timing is why I'm writing this now. The 2026-07-28 revision, the largest in MCP's history, finalizes at the end of this month, and it ships from exactly that self-measuring ecosystem. The release gives engineering leaders new enforcement machinery worth knowing about. The governance model it ships from is worth more. The pitch of this post: condition a workflow's permissions on the outcomes it has delivered, and review the grant on a clock. I call that earned autonomy, and you can run it without buying anything.

## A clean record can hide a bad outcome

Task accuracy has a blind spot you have probably already paid for. An agent whose every tool call is well-formed, whose accuracy dashboard reads solid green, opens a change your team reverts on Thursday. The dashboard never moves. Accuracy was measured at the call; the failure happened in delivery, one step past anything call-level metrics can see. The defective call is a correct call.

Promotion ladders built on that metric compound the problem. An accuracy-graded ladder widens a workflow's scope exactly when its scores are high, and high scores are when its output draws the least human scrutiny. The metric rises as the examination falls. Grade the call instead of the delivery and you get a system that trusts most where it is looking least.

## What changes on July 28

The revision removes protocol sessions, and with them the pattern of authorizing an agent once at connection time. Authorization is evaluated on every call. Each action arrives as a structured, attributable record: the authenticated principal behind it, the tool it hit, typed inputs and outputs, a trace ID that follows it across your infrastructure. For governance, that is the substrate that was missing: a per-call enforcement point where policy can bite. (The text stays a Release Candidate until the 28th, so details can still move. The architecture won't.)

Know the limits before you build on it. The spec gives you the enforcement point; what a given workflow is allowed to do is still policy you have to write. And the record tells you what your agents did and what they were permitted to do. Whether it was worth doing is recorded somewhere else: version control and production. What merged and held. What got rolled back on Thursday. The trust signal worth acting on is the join of the protocol's record with the delivery record.

## Tie the tier to what shipped

The unit that holds a tier is the part most orgs get wrong. Agent instances are ephemeral and interchangeable. The durable thing is the workflow configuration: the model, the prompt, the tool list, and the policy, as one bundle. That bundle produced the last change and will produce the next one, so that bundle is what earns the tier.

The mechanism is small enough to sketch as config:

```yaml
# Sketch. Run it as a spreadsheet first; encode it in gateway
# policy as it matures. The gateway enforces the allowlist per
# call; the review cadence is what moves a workflow between tiers.

tiers:
  sandbox:        # default for any workflow without a record
    allow: [read_file, list_directory, search_files]
  trusted:
    allow: [read_file, list_directory, search_files,
            write_file, edit_file, open_pull_request]

review:
  cadence: 4w     # the spec's own relegation window; a fine default
  window: 90d     # score a trailing window, not last week's demo
  signals: [merged, held_30d, reverted, reworked]
  promote: clean trailing window at current tier
  relegate: sustained downtrend in held changes
```

<!-- ALT: a diagram or screenshot can replace the config sketch above.
The loop to show: gateway enforces the tier per call -> delivery signals
accrue over the trailing window -> the review moves the tier -> the
gateway enforces the new tier on the next call. -->

None of those signals is an accuracy score or an adoption count. Each one is a delivered-outcome fact your platform team can already query. That is the entire swap this idea asks for: keep the ladder the field already uses, change the variable it grades on.

## Start with a spreadsheet

A platform or developer-experience team can run the review on day one: list the workflow configurations currently running agents, assign each a tier, publish the list, and put the four-week review on the calendar. New workflow, no record? Sandbox, because the safe grant without evidence is a small one. What this amounts to is a performance review for agent workflows, and encoding it in gateway policy is the maturation step, not the entry fee.

One boundary keeps the whole thing honest. Outcome scoring catches reverts and rework. It cannot catch the security defect that merges clean and holds in production until someone exploits it; that class is caught only by reading the change itself. Keep pre-merge scanning and code review on every pull request, agent-authored or not, no matter whose record is clean. A strong outcome record is a reason to widen a workflow's scope. It is never a reason to skip the scan.

## The question the spec leaves open

The 2026-07-28 release settles whether you can see and control what your agents do, action by action. It leaves open whether that activity was worth the scope you granted, and the full answer needs more room than a blog post. There's a whitepaper I'm working on, coming out soon, that makes the complete argument: why the field's existing autonomy ladders grade the wrong variable, and how to build the evidence layer that joins agent actions to the changes they delivered.

Meanwhile the tier table upstream is already running its four-week clock. Yours can start Monday.

---

*Andrew Zigler is a 2026 AAIF Ambassador. Find the cohort at [aaif.io/ambassadors](https://aaif.io/ambassadors).*
