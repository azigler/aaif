# The AAIF ambassador practice

The working spec for how contributions get made here. `CLAUDE.md` is the
quick-reference harness; this is the fuller "how we work" doc. Short version:

1. **Real usage first.** Every contribution comes from something Andrew actually
   runs, builds, or has verified — not from a marketing brief. AAIF prizes
   "here's how I did it," and that's the only kind of content that survives the
   anti-slop gate. If he hasn't done the thing, do the thing first.

2. **Tie it to a project, specifically.** "Agents are the future" doesn't
   qualify. "Here's how I routed Claude and a local qwen3 through one
   agentgateway endpoint" does. Name the AAIF project; serve one of the three
   goals (Awareness / Activation / Contribution).

3. **The anti-slop gate is non-negotiable.** Agents accelerate the work; a human
   verifies and signs the result. Run it, test it, check the facts against
   `refs/projects/*`, edit generated text (`/zig-voice`), `/scrutinize` anything
   substantial. *"Agents are collaborators, not accountability shields."* Nothing
   ships that Andrew wouldn't put his name on.

4. **Ship monthly; bank early.** The monthly floor is sacred — never miss it.
   Monthly leaderboards aren't recalculated for late entries, so land the anchor
   in the first half of the month and let pulse + opportunistic work fill the
   rest.

5. **Portfolio over heroics.** Mix layers (pulse / anchor / tentpole /
   opportunistic). Don't burn out on a course in month one — the program itself
   says *"Please do not"* try to write the definitive guide first. Sustainability
   is the competitive advantage in a 12-month, renew-every-6-months program.

6. **Diversify deliberately.** Rotate projects and formats; use `/randomize` so the
   selection doesn't collapse to "another MCP blog." But lean into the two
   standout lanes (AGENTS.md/public-agents; local-model + gateway) for the
   pieces only Andrew can write.

7. **Prefer durable, first-mover, multi-purpose artifacts.** A pattern catalog,
   the first skill in an empty foundation repo, a talk that's also a blog that's
   also a WG deliverable — these compound. Track them as `submission:` beads with
   the leverage noted.

8. **Build in the open.** The repo is public on purpose. Keep it presentable;
   the harness and the backlog are themselves part of the ambassador story.

9. **Capture what you learn.** New facts about a project go back into
   `refs/projects/*`; decisions and gotchas become `research:`/`note` beads. The
   research archive is a deliverable, not scaffolding — future contributions
   draw on it.

## The unit of work

One **`submission:` bead** = one shippable contribution = one folder under
`submissions/<YYYY-MM>-<slug>/`. It moves through the 8-step pipeline in
`CLAUDE.md` (pick → research → build → verify → publish → submit → log →
amplify). The bead carries enough context that any agent could pick it up cold:
the format, the project tie-in, the leverage thesis, and the acceptance bar
("what makes this useful to a developer").

## Renewal lens (every 6 months)

AAIF reviews on: consistency, quality, project relevance, community impact,
professionalism, responsiveness, alignment, continued interest. The practice
above is built to score well on all eight without gaming any.
