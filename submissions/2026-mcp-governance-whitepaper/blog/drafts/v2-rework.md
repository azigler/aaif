# Your agent fleet needs a relegation rule

*The Model Context Protocol grades its official SDKs on measured conformance and demotes them in public when the measurement lapses. Your agent workflows almost certainly get gentler treatment. Before the protocol's 2026-07-28 revision finalizes, borrow the rule.*

I recently asked how one of the agent workflows in my own fleet got its current permissions. The answer was a date. The workflow was adopted, its accuracy numbers looked good in the pilot, I widened its scope, and the grant has stood ever since because nothing forces me to revisit it. Adoption got it in the door, accuracy kept it there, and both stopped measuring anything useful once the workflow started shipping real changes. The fix I've been converging on: condition a workflow's permissions on the outcomes it has delivered, and put the review on a clock. Call it earned autonomy. You can run it without buying anything, and MCP already runs it on itself.

## The upstream precedent

MCP's own governance is the existence proof:

- **The tier bar.** Official SDKs hold published tiers, and Tier 1 requires passing 100% of the public conformance suite.
- **The relegation trigger.** Any test failing for four continuous weeks demotes the SDK to Tier 2, in public.
- **The spec-change gate.** Since June, a Standards-Track change cannot reach Final until a matching scenario lands in that same suite (SEP-2484), and feature removals run a published lifecycle with at least twelve months between deprecation and earliest removal.

Humans run all of it; no algorithm demotes an SDK. And the 2026-07-28 revision, the largest in the protocol's history, finalizes at the end of this month from exactly this self-measuring ecosystem.

## A clean record can hide a bad outcome

Task accuracy has a blind spot. An agent whose every tool call is well-formed, whose accuracy dashboard reads solid green, opens a change your team reverts on Thursday. The dashboard never moves. Accuracy was measured at the call; the failure happened in delivery, one step past anything call-level metrics can see.

Promotion ladders built on that metric compound the problem. An accuracy-graded ladder widens a workflow's scope exactly when its scores are high, and high scores are when its output draws the least human scrutiny. You end up with a system that trusts most where it is looking least.

## What changes on July 28

The revision removes protocol sessions, and with them the pattern of authorizing an agent once at connection time. Authorization is evaluated on every call. Each action arrives as a structured, attributable record: the authenticated principal behind it, the tool it hit, typed inputs and outputs, a trace ID that follows it across your infrastructure. That is the enforcement point governance was missing, a per-call record where policy can bite. (The text stays a Release Candidate until the 28th, so details can still move, but the per-call architecture is settled.)

Before I built anything on it I wanted the limits clear. The spec gives you the enforcement point; what a given workflow is allowed to do is still policy you have to write. And the record tells you what your agents did and what they were permitted to do. Whether it was worth doing lives somewhere else entirely: version control and production, what merged and held, and what got rolled back on Thursday. The trust signal worth acting on is the join of the protocol's record with the delivery record.

## Tie the tier to what shipped

Agent instances are ephemeral and interchangeable, which makes them the wrong unit to hold a tier. The durable thing is the workflow configuration: the model, the prompt, the tool list, and the policy, as one bundle. That bundle produced the last change and will produce the next one, so that bundle is what earns the tier.

The mechanism is small enough to sketch as config:

```yaml
# Sketch. Run it as a spreadsheet first; encode it in gateway
# policy once the review has proven out. The gateway enforces
# the allowlist per call; the review cadence moves a workflow
# between tiers.

tiers:
  sandbox:        # default for any workflow without a record
    allow: [read_file, list_directory, search_files]
  trusted:
    allow: [read_file, list_directory, search_files,
            write_file, edit_file, open_pull_request]

review:
  cadence: 4w     # the spec's own relegation window; a fine default
  window: 90d     # a trailing window smooths out one bad week
  signals: [merged, held_30d, reverted]
  promote: clean trailing window at current tier
  relegate: more than 2 reverts in the trailing 90d
```

Each signal is a delivered-outcome fact your platform team can already query from version control. I left rework off the list on purpose; rework attribution is mushy enough that I wouldn't gate a tier on it yet. That is the entire swap this idea asks for: keep the ladder the field already uses, change the variable it grades on.

## Start with a spreadsheet

A platform or developer-experience team can run the review on day one:

1. List the workflow configurations currently running agents.
2. Assign each a tier.
3. Publish the list.
4. Put the four-week review on the calendar.

A new workflow with no record starts in sandbox, because the safe grant without evidence is a small one. What this amounts to is a performance review for agent workflows, and encoding it in gateway policy is the maturation step once the spreadsheet has earned its keep.

One boundary: outcome scoring catches reverts and rework, but it cannot catch the security defect that merges clean and holds in production until someone exploits it. That class is caught only by reading the change itself, so keep pre-merge scanning and code review on every pull request, agent-authored or otherwise. Use a strong outcome record to widen a workflow's scope. Keep the scan regardless.

## The question the spec leaves open

The 2026-07-28 release settles whether you can see and control what your agents do, action by action. It leaves open whether that activity was worth the scope you granted, and I'll admit the full answer needs more room than a blog post. I'm finishing a whitepaper that makes the complete argument: why the field's existing autonomy ladders grade the wrong variable, and how to build the evidence layer that joins agent actions to the changes they delivered. It publishes in the coming weeks, and I'll announce it here first.

Meanwhile the tier table upstream is already running its four-week clock. Yours can start Monday.

---

*Andrew Zigler is a 2026 AAIF Ambassador. Find the cohort at [aaif.io/ambassadors](https://aaif.io/ambassadors).*