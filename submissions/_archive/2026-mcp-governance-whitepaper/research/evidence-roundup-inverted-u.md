# Evidence Roundup — the inverted-U of MCP toolset size + the scaffold swing

Research pass for the "Earned Autonomy" whitepaper repositioning. Harvested from
primary sources (arXiv papers, vendor engineering blogs, model cards). Every
per-claim finding carries a **verbatim quoted span**, the **source URL**, and a
**confidence note**. Complications that cut against the thesis are flagged in
Section D — that honesty is the point; the whitepaper's credibility depends on it.

Vendor-neutral throughout: findings are framed around ideas and developer value.
No private-infrastructure names (the experiment runs a coding agent + a local
model behind a self-hosted gateway). Re-verify every quote at publication (the
anti-slop gate).

Bib keys proposed for `references.bib` are given in Section C. The
earned/graduated/progressive-autonomy landscape is **already** in the bib
(`roder`, `progressiveautonomy`, `digitalapprentice`, `mckinsey`,
`cncflifecycle`); Section A4 only adds the *ideas* to position against, neutrally.

---

## A. Per-claim findings

### A1. The inverted-U / tool-count effect — RIGHT side (too many tools hurts)

**Claim 1 — OSWorld-MCP: dumping all 158 tools (RAG removed) drops accuracy 20.5 → 15.5.**
> "removing RAG led to a noticeable performance drop: the overall Acc decreased from 20.5 to 15.5."
> "descriptions of all 158 tools result in excessively long tool contexts, which markedly reduce the model's tendency to use tools"

- Source: https://arxiv.org/abs/2510.24563 (HTML: https://arxiv.org/html/2510.24563 ; §4.3, Table 2; ablation on Gemini-2.5-Pro)
- Confidence: **HIGH.** Both spans verified against the arXiv HTML (v2, generated Nov 11 2025). Exact figures and the causal explanation are the paper's own words.
- Note the important nuance the paper itself supplies: it attributes the drop to **long tool-description context**, not tool count per se (see Flag D2). This is the cleanest single "too many tools hurts" result tied to MCP.

**Claim 2 — OSWorld-MCP: curated MCP tools HELP (the left side of the same curve).**
> "from 8.3% to 20.4% for OpenAI o3 at 15 steps, from 40.1% to 43.3% for Claude 4 Sonnet at 50 steps"
> tool invocation rate "Only 36.3%" (strongest model)

- Source: https://arxiv.org/abs/2510.24563 (abstract; main results Table 1)
- Confidence: **HIGH.** Verified verbatim. This is the *pro-tool* half — a curated tool set lifts success, while the un-curated full 158 (Claim 1) drags it back down. Together they ARE the inverted-U in one paper.

**Claim 3 — GitHub Copilot engineering: an oversized built-in toolset costs 2–5 points; trimming 40 tools → 13 core recovers them.**
> "giving an agent too many tools doesn't always make it smarter. Sometimes it just makes it slower."
> "a 2–5 percentage point decrease in resolution rate on benchmarks including SWE-Lancer" [with the full built-in toolset]
> the agent "ends up ignoring explicit instructions, using tools incorrectly, and calling tools that are unnecessary to the task at hand."
> trimming "the default 40 built-in tools down to 13 core ones" … changes that "improve success rates by 2-5 percentage points" (SWE-Lancer + SWEbench-Verified, GPT-5 + Sonnet 4.5)

- Source: https://github.blog/ai-and-ml/github-copilot/how-were-making-github-copilot-smarter-with-fewer-tools/ (Anisha Agarwal & Connor Peet, Nov 19 2025)
- Confidence: **HIGH.** First-party engineering measurement from a large production agent; verified verbatim. Strongest *practitioner-with-numbers* source. This is a near-perfect fit for the "converge on the sweet-spot toolset" thesis: a real team measured the over-provisioned toolset, then pruned to a load-bearing core and regained points.

**Claim 4 — RAG-MCP: retrieving a small tool subset triples selection accuracy vs. showing all tools; and accuracy is non-monotonic as the registry grows.**
> "more than triples tool selection accuracy (43.13% vs 13.62% baseline)" (prompt tokens cut "by over 50%")
> "its retrieval precision and overall throughput degrade as the tool registry scales to thousands of MCPs"

- Source: https://arxiv.org/abs/2505.03275 (Gan & Sun, 2025; HTML v1 verified)
- Confidence: **HIGH.** Verified verbatim. The 13.62% all-tools baseline is a striking "flood the prompt and the model can't pick" datapoint; the "non-monotonic … degrade as the tool registry scales" line is the closest thing in the literature to an explicit measured curve over tool-pool size. Note the baseline here (13.62%) is almost certainly the true origin of the widely-repeated "~13% with many tools" figure (see Flag D3).

**Claim 5 — MCP-Flow: performance deteriorates as candidate-tool-set size increases.**
> (search-derived summary) "Contemporary SOTA models still exhibit suboptimal performance in real-world MCP tool utilization, and their effectiveness further deteriorates as the number of candidate tools increases."

- Source: https://arxiv.org/abs/2510.24284 (Wang et al., 2025; ACL 2026 Main, Camera Ready)
- Confidence: **MEDIUM — FLAGGED.** The paper is real and its topic is exactly candidate-tool scaling, BUT I could **not** confirm the quoted sentence verbatim: it is **not** in the published abstract (checked arXiv abs page + HuggingFace papers page), and the arXiv HTML render 404s. The sentence appears to be a search-engine summary of a body/experiments finding, not an abstract quote. **Before citing, pull the exact sentence from the PDF body** (experiments on candidate-set size / GAIA). Treat as a supporting citation, not a headline quote, until re-verified.

### A2. The Qwen3-Coder-30B scaffold / tool-sensitivity swing

**Claim 6 — Same model, ~18.8% bash-only vs ~50–52% with a rich scaffold. Even GPT-4o is ~21% bash-only.**
> "The mini-swe-agent, powered by Qwen3-Coder-30B-A3B, achieves an 18.8% success rate on the full SWE-Bench Verified dataset when restricted to the Bash tool." (search-rendered from the AgentStop paper)
> "This performance is consistent with the official mini-swe-agent benchmark … since even GPT-4o only achieves 21.2% in this setting."

- Sources: AgentStop paper https://arxiv.org/abs/2605.15206 (Pham, Katevas, Shamsabadi, Haddadi, 2026) for the 18.8% and 21.2% figures; mini-swe-agent = the minimal bash-only ReAct scaffold from the SWE-bench team, https://github.com/SWE-agent/mini-swe-agent and https://www.swebench.com/ .
- The rich-scaffold end: Qwen's self-reported **51.6** on SWE-bench Verified with **OpenHands (100 turns)**, referenced in the model-card repro thread https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct/discussions/30 ; an independent OpenHands run (Nebius/SWE-rebench) reports **50.3% Pass@1 at 500 turns**.
- Confidence on 18.8% / 21.2%: **MEDIUM-HIGH.** Numbers come from a primary paper (AgentStop) and are internally cross-checked against the mini-swe-agent leaderboard, but I read them through a search render (the arXiv PDF stream was not cleanly extractable) — **re-read the AgentStop PDF to lift the exact sentence + confirm 18.8 / 21.2** before quoting.
- Confidence on 51.6% (OpenHands): **MEDIUM — FLAGGED.** 51.6 is **vendor-reported** (Qwen team, on the model card). The HuggingFace discussion #30 is an **unanswered reproduction request** — it asks *how* 51.6 was obtained (commit, config, tool-call parser) and gets no answer in-thread. So report it as "the model card's reported figure," corroborated in the same ballpark by the independent 50.3% OpenHands run — not as an independently reproduced number.
- Scaffold definitions: **mini-swe-agent** = ~100-line agent, *bash only, no tool-calling interface, no special scaffold* ("just a simple ReAct agent loop"); **OpenHands** = a rich SWE-specialized scaffold with structured file-edit/navigation/terminal tools and many turns (100–500). SWE-bench Verified = 500 human-validated tasks (OpenAI, Aug 2024).
- **Why this belongs in the paper:** it shows the swing is driven by *scaffold/tool shape*, not raw model capability — a ~2.7× swing on one fixed model. See Flag D4 for the tension this creates and its resolution (it argues for the *right, load-bearing* tools, which is exactly "earned autonomy," not merely "fewer").

### A3. Practitioner guidance on a tool-count sweet spot / consolidation

**Claim 7 — Anthropic (tool-authoring guidance): build few, high-impact, consolidated tools; namespace large sets; audit usage to find consolidation opportunities.**
> "Instead of implementing list_users, list_events, and create_event tools, consider implementing a schedule_event tool which finds availability and schedules an event."
> "Namespacing (grouping related tools under common prefixes) can help delineate boundaries between lots of tools"
> "Tracking tool calls can help reveal common workflows … and offer some opportunities for tools to consolidate."

- Source: https://www.anthropic.com/engineering/writing-tools-for-agents
- Confidence: **HIGH (as guidance).** These are prescriptive best-practices, not measured deltas — cite as the "how to converge on the sweet-spot toolset" authority, and note the "audit usage to consolidate" line directly prefigures the whitepaper's audit-then-prune loop. First-party primary source.

**Claim 8 — GitHub Copilot enforces a 128-tool hard cap explicitly to protect performance; too many tools "floods the context window."**
- Source (primary, product): https://github.com/microsoft/vscode-copilot-release/issues/13065 (error: "You may not include more than 128 tools in your request") and the engineering blog in Claim 3.
- Confidence: **HIGH** for the existence + rationale of the cap; the cap is a concrete industry artifact of the tool-count problem.
- **Do NOT cite the "5–7 tools clean / 30 confusion / 50 suboptimal / 100+ guaranteed-fail / >90%→~13% accuracy" staircase as GitHub's.** That specific staircase is a *secondary blog aggregation* (see Flag D3); GitHub's own measured number is the 2–5 pp / 40→13 result in Claim 3, and the ~13% traces to RAG-MCP's 13.62% baseline (Claim 4).

### A4. The "earned / graduated / progressive autonomy" landscape — position against, NEUTRALLY

The framing prior art is **already in the bib** and needs no new citations; capture only the *ideas* to differentiate from (about concepts, never ranking anyone):

- **Earned-autonomy gradient** (`roder`) — trust-to-act as a function of demonstrated reliability.
- **Progressive-autonomy controls** (`progressiveautonomy`) — autonomy tiers gated on task performance (industry pattern).
- **Digital apprentice** (`digitalapprentice`, arXiv 2606.04321) — human-directed graduation of agent independence.
- **Project lifecycle: sandbox → incubating → graduated** (`cncflifecycle`) — the CNCF maturity metaphor the "earned" frame borrows.
- **Trust in the age of agents** (`mckinsey`) — governance/trust framing.

**Our differentiation (idea-level, neutral):** prior "earned autonomy" gates the *agent's overall latitude* over time; this whitepaper earns autonomy at the **tool granularity, enforced per-call at a gateway**, and *derives* the earned toolset from **audited usage** (which tools were actually load-bearing) rather than from a human-set tier. That "measure → converge on the sweet-spot toolset → enforce per call" loop is the contribution. The MCP-governance security prior art (per-tool, not per-server, authorization; per-invocation re-authorization; identity-attributed audit trail; OWASP "Excessive Agency" = excessive functionality + permissions + autonomy) is the enforcement substrate — see Section A5.

### A5. MCP governance / per-action authorization / audit prior art (the enforcement substrate)

Idea-level, vendor-neutral. Best *primary* anchors (avoid the vendor product blogs as load-bearing citations):

- **Per-call authorization is a separate decision on top of OAuth scope consent.** Idea: a one-time scope grant does not evaluate whether *this* `tools/call` with *these* arguments is appropriate now — per-invocation authz is where least privilege on the tool surface is actually enforced. Anchor to the MCP spec's authorization section (already spec-cited in the paper) rather than vendor blogs.
- **Tool-level (not server-level) least privilege.** Idea: one server can expose `filesystem_read` beside `filesystem_write`; server allowlists defeat least privilege. Primary-ish anchor: OWASP Top 10 for LLM Applications — **"Excessive Agency"** (excessive functionality / permissions / autonomy) and OWASP Top 10 for Agentic Applications (finalized Dec 2025). These are neutral, standards-body sources.
- **Identity-attributed audit trail with a session correlation ID.** Idea: every tool call recorded — agent identity, tool, params, response, human-authorization chain — so behavior can be reconstructed and *then mined* for which tools mattered. This is the read-side the whitepaper's audit-then-prune loop consumes.
- Confidence: **MEDIUM.** The synthesis is well-established across 2025–26 guidance, but most retrievable write-ups are vendor product pages (MintMCP, DeepInspect, TrueFoundry, AppSentinels, CSA labs). **Cite OWASP / CSA / the MCP spec directly; treat vendor pages as corroboration only, and say so.**

### A6. Tool-ablation methodology precedents (how to measure per-tool marginal contribution)

**Claim 9 — Leave-One-Out (LOO) ablation identifies bottleneck components as well as combinatorial (Shapley) methods, far cheaper — but misses interaction effects.**
> "Leave-One-Out (LOO) identifies bottleneck agents as effectively as combinatorial methods, but at a fraction of the computational cost."
> "Agent ablation isolates structural bottlenecks, whereas introspective LLM judges fail to faithfully approximate this behavior."

- Source: https://arxiv.org/abs/2605.27621 — "Agents that Matter: Optimizing Multi-Agent LLMs via Removal-Based Attribution" (Lu, Huang, Lin, Lee, 2026). Verified verbatim (abstract).
- Confidence: **HIGH.** This is the methodological backbone for the experiment's ablation: LOO over tools = re-run the SWE-bench subset with each tool held out, attribute the delta. Formalizes tool-attribution as a cooperative game (removal protocol + coalition + target metric); LOO is the cheap, effective removal protocol.
- **Corroborating precedent (already in A1):** CompAgent's core-tool-removal study is a concrete LOO-style tool ablation with published F1 deltas — use it as the "prior work does exactly this per-tool" citation.

**Claim 10 — CompAgent: removing a load-bearing core tool set collapses F1 from 0.93 to ~0.67–0.71 (the LEFT side — too few load-bearing tools hurts).**
> "Removing Summarization tools … leads to a significant performance degradation (Unsafe F1 dropping to 0.68 from 0.93)."
> Content Detection removal → "Unsafe F1 score of 0.71"; LlavaGuard removal → "Unsafe F1 dropping to 0.67"

- Source: https://arxiv.org/abs/2511.00171 (HTML: https://arxiv.org/html/2511.00171 ; ablation on LlavaGuard dataset; Ghosh, Chaudhury, Das, et al., 2025)
- Confidence: **HIGH.** Verified via arXiv HTML search render; figures are consistent and specific. Caveat: this is a **vision-compliance** agent, not a coding agent — cite it as domain-general evidence that removing load-bearing tools sharply hurts, i.e., the left arm of the inverted-U and a template for the ablation method, not as SWE-domain evidence.

---

## B. Ranked citation table

Ranked by strength-for-this-thesis (primary + concrete numbers + verified verbatim first).

| # | Title | Authors / Org | Year | URL | One-line relevance | Bib-worthy |
|---|---|---|---|---|---|---|
| 1 | How we're making GitHub Copilot smarter with fewer tools | A. Agarwal & C. Peet (GitHub) | 2025 | https://github.blog/ai-and-ml/github-copilot/how-were-making-github-copilot-smarter-with-fewer-tools/ | Production team measures oversized toolset costing 2–5 pp; prunes 40→13 core to recover — the "converge on sweet-spot toolset" proof | **Y** |
| 2 | OSWorld-MCP: Benchmarking MCP Tool Invocation in Computer-Use Agents | Jia, Liao, Zhang, Xu, Xie, et al. | 2025 | https://arxiv.org/abs/2510.24563 | Both arms in one paper: curated MCP tools help (8.3→20.4); all-158 (RAG off) hurts (20.5→15.5) | **Y** |
| 3 | RAG-MCP: Mitigating Prompt Bloat in LLM Tool Selection via RAG | Gan & Sun | 2025 | https://arxiv.org/abs/2505.03275 | All-tools baseline 13.62% vs retrieved-subset 43.13%; explicit non-monotonic degradation as tool registry grows | **Y** |
| 4 | Agents that Matter: Optimizing Multi-Agent LLMs via Removal-Based Attribution | Lu, Huang, Lin, Lee | 2026 | https://arxiv.org/abs/2605.27621 | Formal LOO/removal attribution = the experiment's per-tool ablation methodology | **Y** |
| 5 | AgentStop: Terminating Local AI Agents Early to Save Energy… | Pham, Katevas, Shamsabadi, Haddadi | 2026 | https://arxiv.org/abs/2605.15206 | Primary source for Qwen3-Coder-30B 18.8% bash-only + GPT-4o 21.2% bash-only | **Y** |
| 6 | Writing effective tools for AI agents | Anthropic (engineering) | 2025 | https://www.anthropic.com/engineering/writing-tools-for-agents | First-party guidance: consolidate to few high-impact tools, namespace, audit usage to prune | **Y** |
| 7 | CompAgent: An Agentic Framework for Visual Compliance Verification | Ghosh, Chaudhury, Das, et al. | 2025 | https://arxiv.org/abs/2511.00171 | Core-tool LOO ablation: F1 0.93 → 0.67–0.71 (too few load-bearing tools hurts) | **Y** |
| 8 | Qwen3-Coder-30B-A3B-Instruct (model card + repro thread #30) | Qwen Team / Alibaba | 2025 | https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct | Model-card 51.6% OpenHands(100-turn) figure — the rich-scaffold end of the swing (vendor-reported) | **Y** |
| 9 | mini-swe-agent (bash-only SWE-bench harness) | SWE-bench team (Princeton/Stanford) | 2025 | https://github.com/SWE-agent/mini-swe-agent | Defines the minimal bash-only scaffold; the apples-to-apples "just a shell" baseline | **Y** |
| 10 | MCP-Flow: Facilitating LLM Agents to Master … Scaling MCP Tools | Wang, Niu, Xu, et al. | 2025 | https://arxiv.org/abs/2510.24284 | Candidate-tool-set-size degradation (ACL 2026) — supporting, pending verbatim re-check | **Y (caveat)** |
| 11 | OWASP Top 10 for LLM Applications — Excessive Agency | OWASP | 2025 | https://owasp.org/www-project-top-10-for-large-language-model-applications/ | Neutral standards anchor for over-provisioned functionality/permissions/autonomy | **Y** |
| 12 | SWE-bench Verified (leaderboard/dataset) | OpenAI / SWE-bench | 2024 | https://www.swebench.com/verified.html | The 500-task benchmark the experiment ablates on | N (ref only) |

Rows 1–11 recommended for `references.bib`. Row 12 is context (the benchmark itself),
cite inline. Earned-autonomy landscape (A4) already in the bib — no new rows.

---

## C. BibTeX (matches the existing @misc style in references.bib)

```bibtex
@misc{githubfewertools,
  author       = {Agarwal, Anisha and Peet, Connor},
  title        = {How We're Making {GitHub} {Copilot} Smarter with Fewer Tools},
  year         = {2025},
  howpublished = {\url{https://github.blog/ai-and-ml/github-copilot/how-were-making-github-copilot-smarter-with-fewer-tools/}},
  note         = {GitHub Engineering Blog, 19 November 2025; 40 built-in tools trimmed to 13 core, +2--5 pp on SWE-Lancer/SWE-bench Verified}
}

@misc{osworldmcp,
  author       = {Jia, Hongrui and Liao, Jitong and Zhang, Xi and Xu, Haiyang and Xie, Tianbao and Jiang, Chaoya and Yan, Ming and Liu, Si and Ye, Wei and Huang, Fei},
  title        = {{OSWorld-MCP}: Benchmarking {MCP} Tool Invocation in Computer-Use Agents},
  year         = {2025},
  eprint       = {2510.24563},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2510.24563}},
  note         = {Removing RAG filtering (all 158 tools) drops accuracy 20.5 to 15.5}
}

@misc{ragmcp,
  author       = {Gan, Tiantian and Sun, Qiyao},
  title        = {{RAG-MCP}: Mitigating Prompt Bloat in {LLM} Tool Selection via Retrieval-Augmented Generation},
  year         = {2025},
  eprint       = {2505.03275},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2505.03275}},
  note         = {Tool-selection accuracy 43.13\% (retrieved subset) vs 13.62\% (all tools); non-monotonic degradation as the registry scales}
}

@misc{agentsthatmatter,
  author       = {Lu, Mingyu and Huang, Yushan and Lin, Chris and Lee, Su-In},
  title        = {Agents that Matter: Optimizing Multi-Agent {LLMs} via Removal-Based Attribution},
  year         = {2026},
  eprint       = {2605.27621},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2605.27621}},
  note         = {Leave-One-Out attribution identifies bottleneck components as effectively as combinatorial methods at lower cost}
}

@misc{agentstop,
  author       = {Pham, Dzung and Katevas, Kleomenis and Shamsabadi, Ali Shahin and Haddadi, Hamed},
  title        = {{AgentStop}: Terminating Local {AI} Agents Early to Save Energy in Consumer Devices},
  year         = {2026},
  eprint       = {2605.15206},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2605.15206}},
  note         = {Qwen3-Coder-30B-A3B bash-only (mini-swe-agent) 18.8\% on SWE-bench Verified; GPT-4o 21.2\% in the same setting}
}

@misc{anthropictools,
  author       = {{Anthropic}},
  title        = {Writing Effective Tools for {AI} Agents---Using {AI} Agents},
  year         = {2025},
  howpublished = {\url{https://www.anthropic.com/engineering/writing-tools-for-agents}},
  note         = {Consolidate to few high-impact tools; namespace large sets; monitor tool-call usage to find consolidation opportunities}
}

@misc{compagent,
  author       = {Ghosh, Rahul and Chaudhury, Baishali and Das, Hari Prasanna and others},
  title        = {{CompAgent}: An Agentic Framework for Visual Compliance Verification},
  year         = {2025},
  eprint       = {2511.00171},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2511.00171}},
  note         = {Leave-one-out core-tool ablation: Unsafe F1 0.93 falls to 0.67--0.71 when a load-bearing tool set is removed}
}

@misc{qwen3coder,
  author       = {{Qwen Team}},
  title        = {{Qwen3-Coder-30B-A3B-Instruct} Model Card},
  year         = {2025},
  howpublished = {\url{https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct}},
  note         = {Reported 51.6 on SWE-bench Verified with OpenHands (100 turns); repro details unconfirmed in discussion \#30}
}

@misc{minisweagent,
  author       = {{SWE-bench Team}},
  title        = {mini-swe-agent: A Minimal Bash-Only Coding Agent},
  year         = {2025},
  howpublished = {\url{https://github.com/SWE-agent/mini-swe-agent}},
  note         = {Bash-only ReAct scaffold, no tool-calling interface; the apples-to-apples LM baseline on SWE-bench Verified}
}

@misc{mcpflow,
  author       = {Wang, Wenhao and Niu, Peizhi and Xu, Zhao and Chen, Zhaoyu and Du, Jian and Du, Yaxin and Pang, Xianghe and Huang, Keduan and Wang, Yanfeng and Yan, Qiang and Chen, Siheng},
  title        = {{MCP-Flow}: Facilitating {LLM} Agents to Master Real-World, Diverse and Scaling {MCP} Tools},
  year         = {2025},
  eprint       = {2510.24284},
  archivePrefix= {arXiv},
  howpublished = {\url{https://arxiv.org/abs/2510.24284}},
  note         = {ACL 2026 Main. Reports degradation as candidate-tool-set size grows --- verify exact sentence in PDF body before quoting}
}

@misc{owaspllm,
  author       = {{OWASP}},
  title        = {{OWASP} Top 10 for {LLM} Applications: Excessive Agency},
  year         = {2025},
  howpublished = {\url{https://owasp.org/www-project-top-10-for-large-language-model-applications/}},
  note         = {Excessive functionality, permissions, and autonomy as root causes --- the standards anchor for over-provisioned tool surfaces}
}
```

---

## D. Flags — what complicates or cuts against the thesis (read before writing)

**D1. No single paper plots a clean inverted-U over tool COUNT with a measured peak.**
The inverted-U is a *synthesis of two literatures*: (a) removing load-bearing tools
hurts — CompAgent, LOO ablations = the LEFT arm; and (b) too many tools hurts —
OSWorld-MCP RAG-off, GitHub Copilot, RAG-MCP = the RIGHT arm. OSWorld-MCP is the
closest to holding both arms in one study; RAG-MCP is the closest to an explicit
"non-monotonic as pool grows" curve. **Frame it honestly as a synthesis with strong
support at both ends, and let the experiment supply the missing middle** (the swept
curve on one fixed model+task) — that's precisely the whitepaper's novel data
contribution, not a restatement.

**D2. "Too many tools" is confounded with context length.** OSWorld-MCP itself
attributes the drop to "excessively long tool contexts," not tool count per se. So
the mechanism is context/attention dilution from tool *descriptions*, and a
token-efficient tool representation (or retrieval) shifts the curve rightward
(that's exactly what RAG-MCP demonstrates). **State the mechanism as context bloat +
selection ambiguity, not a mystical "count" effect** — this is more accurate and
harder to attack, and it's why an *auditing gateway that prunes* is the right lever.

**D3. Do not attribute the "5–7 / 30 / 50 / 100+ / >90%→13%" staircase to GitHub or
to a single primary source.** That specific staircase is a *secondary blog
aggregation*. The defensible primary numbers are: GitHub's own 2–5 pp / 40→13
(Claim 3), RAG-MCP's 13.62% all-tools vs 43.13% retrieved (Claim 4), and
OSWorld-MCP's 20.5→15.5 (Claim 1). The ~13% "many tools" figure that floats around
almost certainly originated as RAG-MCP's 13.62% baseline. **Cite those; drop the
staircase.**

**D4. The scaffold swing is in apparent TENSION with "fewer tools is better" — and
resolving it strengthens the thesis.** OpenHands is a *richer* scaffold (more
structured tools + tool-calling) and beats bash-only by ~2.7× on the same Qwen3
model. So the lesson is NOT "fewer tools always win" — it's **the RIGHT, load-bearing
tools in the right shape.** Bash-only starves the agent (left arm); an un-curated
158-tool dump drowns it (right arm); a compact, well-fit tool set (OpenHands' core
edit/nav/run tools; Copilot's 13) is the peak. **This is the honest, unifying frame
for "earned autonomy": converge on the load-bearing set, neither starve nor drown.**
Say this explicitly — reviewers will otherwise raise the tension themselves.

**D5. Provenance caveats on specific numbers.**
- 51.6% (Qwen3 OpenHands) is **vendor-reported**; the HF repro thread is unanswered.
  Corroborated in-ballpark by an independent 50.3% OpenHands run. Report as reported,
  not reproduced.
- 18.8% / 21.2% (bash-only) come from AgentStop but were read via a search render
  (PDF stream not cleanly extractable). **Re-read the AgentStop PDF for the exact
  sentence before quoting the figures.**
- MCP-Flow candidate-tool sentence: **not confirmed verbatim** (not in abstract;
  HTML 404). Pull from the PDF body or downgrade to a topical citation.
- CompAgent read via arXiv HTML search render; re-verify the F1 table at publication.

**D6. Publication-bias / generalization note.** Most tool-count evidence is on
GUI/computer-use (OSWorld-MCP), vision compliance (CompAgent), or synthetic tool
registries (RAG-MCP, MCP-Flow) — **not** SWE coding. The GitHub Copilot result IS on
SWE (SWE-Lancer/SWE-bench Verified), which is why it's ranked #1. The experiment's
own SWE-bench-Verified ablation is what makes the coding-domain claim first-party
rather than transferred — lean on that.

---

## E. Summary (for the bead)

Harvested and verbatim-verified the primary-source spine for the inverted-U thesis.
RIGHT arm (too many tools hurts): OSWorld-MCP (all-158 RAG-off 20.5->15.5),
GitHub Copilot engineering (oversized toolset -2..5pp; 40->13 core recovers it),
RAG-MCP (all-tools 13.62% vs retrieved 43.13%; explicit non-monotonic decay).
LEFT arm (too few load-bearing tools hurts): CompAgent (F1 0.93->0.67-0.71 on
core-tool removal) + LOO methodology from "Agents that Matter". Scaffold swing:
Qwen3-Coder-30B ~18.8% bash-only vs ~50-52% OpenHands, GPT-4o ~21.2% bash-only
(AgentStop primary; 51.6% is vendor-reported, unreproduced). Anthropic's
tool-authoring guidance ("consolidate, namespace, audit usage to prune") prefigures
the audit-then-converge loop. 11 bib-worthy sources + ready BibTeX in Section C.
Key honesty flags (Section D): no single paper plots a clean count-vs-performance
peak (it's a synthesis; the experiment supplies the middle); the effect is really
context-bloat + selection-ambiguity, not raw count; the scaffold swing shows the
peak is the RIGHT load-bearing tools, not merely fewer; drop the unsourced
"5/30/50/100" staircase; MCP-Flow + AgentStop figures need a PDF-body re-read
before quoting.

Output file: research/evidence-roundup-inverted-u.md
