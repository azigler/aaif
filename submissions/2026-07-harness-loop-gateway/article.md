# The harness, the loop, and the gateway are converging

I pointed my own Claude Code at a proxy I'd stood up an hour earlier, mostly to see
if it would break. My subscription was supposed to be a black box. Flat rate, no API
key, no itemized bill, none of the token accounting you get when you pay per call. The
first response came back and the proxy had written a line about it: 12,205 input
tokens, 50,187 of them written to cache, four tokens out. The number I'd been told I
couldn't see was sitting in my own logs.

That was the moment a year of my work stopped looking like three separate projects.

## Three layers I'd been building without noticing

I run a harness. It's the orchestrator around my agents: prompt conventions, commit
hooks, a task tracker, a tmux status lexicon that tells me at a glance which agent is
thinking and which one is stuck. The harness is polite. It asks agents to stay in
scope, to prove their work, to not spend the whole night on a bug. Most of the time
they listen.

On top of the harness there's a loop. Scheduled ticks, a couple of daemons, agents
that keep running while I sleep. Anthropic has written about loop-engineering and the
four quiet costs a self-running loop accrues: verification debt (output piling up
between "ran" and "right"), comprehension rot (the loop ships faster than you can read
it), cognitive surrender (you stop having an opinion because there's no time to form
one), and token blowout (an idle bug burning cash till morning). I've paid all four.
They don't trip an alarm. That's what makes them expensive.

Then there's the gateway. agentgateway is an open-source proxy that sits in the
request path in front of your models and your tools. It's an AAIF project, a single
Rust binary with a YAML config. Where the harness asks agents to behave, the gateway
is the layer that can make them.

My claim, after standing one up, is that these three are converging into one system.
Not metaphorically. As a wiring diagram.

## What I actually built

I deployed the gateway as standing infrastructure on a Mac I keep for exactly that,
bound to my private mesh so the admin UI is reachable across my own devices and
nowhere else. One binary, one launchd job that restarts it if it dies. It fronts my
agents' MCP traffic, and when I opt in, my own Claude Code.

Then I did the boring, load-bearing thing: I wrote down every field it records per
call. Who called (a source identity). Which route and method. The exact tool name an
agent invoked. The outcome and the latency. For model calls, the token counts, cache
included. That inventory turned out to be the whole argument on one page. The gateway
already knows the things the harness only hopes are true.

## Downward: intent becomes policy

My harness has a budget directive, a number I hand an agent and ask it not to exceed.
It's a request, and a request is only as good as the agent's next decision. The
gateway has per-key cost caps: the same number, except the agent physically cannot go
past it. A capability scope I write in a prompt ("this agent is read-only") can become
a rule the proxy enforces on every call. An egress rule becomes an allowlist.

I tested the sharp version of this. I gave a route an allowlist of exactly one tool
and watched what happened to an agent pointed at a server that exposes dozens. Its
tool list shrank to one. The others didn't return a "forbidden" error. They stopped
existing. Ask for one by name and the gateway answers "Unknown tool." Least privilege
that an agent can't even see around, let alone argue with.

That's the downward seam: the harness's conventions compiling into the gateway's
enforcement. Asking-nicely becoming can't.

## Upward: telemetry becomes the dashboard

The other direction is the one I underestimated. The gateway produces structured
truth, one line per call, and the harness renders it where a human is already looking.
A spike of denied requests becomes a high-priority item in my tracker. Cost burn lands
on the ledger I read every morning with coffee. An out-of-scope tool call becomes a
push notification instead of a line nobody scrolls to. The gateway is the instrument.
The harness is the glass I read it through.

Put the two seams together and the four loop costs each get a control they didn't have
before. Token blowout meets a hard cost cap. Verification debt meets an audit trail,
which is proof instead of the agent's self-report. Comprehension rot meets live
telemetry feeding the human view, so my mental map can't fall a week behind without my
noticing.
And cognitive surrender, the one the paper says is least defended, meets a legible
choke point: a single place I can inspect and revoke at. The door stays open for a
human to walk in. That's the whole point of building it like someone who intends to
stay the engineer.

## The part I'm most excited about

Observation is table stakes. The interesting move is what you do with it. So I built
two small skills on top of the gateway's own logs.

The first answers one question: what did my fleet actually do? It reads the access log
and the metrics and groups every call by identity, by route, by tool, by outcome. No
external observability stack, no separate database. The gateway's own record is enough.

The second is the leverage. It takes that observed behavior and derives a
least-privilege policy: allow exactly the tools that were actually used, deny the rest,
and hand me the config to review. Measure first, then tighten, from evidence instead of
imagination. One skill is the eyes. The other is the hands. Together they're the loop
the harness always wanted and couldn't close on its own, because a prompt can't audit
itself.

## The honest limits

A gateway that oversells what it proves is worse than no gateway, so here's the ledger.

Route your primary Claude Code through a remote proxy and you've put a dependency in
front of your daily driver. If the box goes down, so do you, until you flip the kill
switch (for me, one shell command that restores the direct connection). Token counts on
a flat-rate subscription are counts, not dollars; the gateway can show you usage, not a
bill. And subscription traffic that authenticates by OAuth is fully observable but not
always per-agent attributable. I can see the tokens. I can't always see which agent
spent them. Token observability and per-agent attribution are two different claims, and
the honest version of this story keeps them apart.

None of that unmakes the point. It sharpens it.

## The shape is convergence

"The harness is the gateway" started as a line I liked saying. Standing one up turned
it into something I can draw. The orchestrator asks. The loop runs. The gateway
enforces and remembers. And the three are collapsing into a single control surface for
a fleet of agents that has to be governed, not just launched.

I'm not finished wiring it. But I can see the shape now, and the shape is one system
where what an agent can do is bounded at the choke, and what it did is legible in the
place I already look.

If you're running agents you never wrote a policy for, that's the question I'd sit
with this week: what does your gateway already know that your harness is only hoping
is true?
