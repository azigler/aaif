# Evidence — per-call tier-gated authorization, run on a real MCP gateway

> Empirical validation of the paper's exhibit (bead `aaif-t58`). An **isolated**
> agentgateway **1.3.1** instance (AAIF project; a real MCP gateway) enforcing
> per-call authorization that gates a tool-call *scope* on a workflow's *tier*.
> Run 2026-07-16 on a throwaway instance (spare ports, throwaway workspace); the
> production fleet was never touched and the instance was torn down after. Infra
> specifics generalized; test keys redacted.

## What was tested

A gateway fronting a filesystem MCP server, with two workflow identities and a
per-call authorization policy (CEL) that grants a **trusted** identity full
access and restricts a **sandbox** identity to read-only tools. The same
`write_file` call was issued by each identity.

Policy shape (real, loaded + validated by the gateway):

```yaml
mcpAuthorization:
  rules:
  # trusted-tier identity: full access, including write
  - allow: apiKey.name == "wf-alpha"
  # sandbox-tier identity: read-only tools only — a write is denied per call
  - allow: apiKey.name == "wf-beta" && mcp.tool.name in
      ["read_file","read_text_file","list_directory","directory_tree",
       "search_files","get_file_info", ...]
```

## Result

| workflow identity (tier) | `write_file` | `read_text_file` |
|---|---|---|
| **wf-alpha (trusted)** | **HTTP 200 — "Successfully wrote…"** (file actually written) | 200 |
| **wf-beta (sandbox)** | **HTTP 400 — denied per-call** (`Unknown tool: write_file`) | 200 |

The identical `write_file` request on the identical endpoint is **allowed** for the
trusted identity and **denied** for the sandbox identity, decided **per call** at
the gateway. "Relegation" is the same mechanism run backwards: move a workflow from
the `wf-alpha` identity to `wf-beta` and its next write is denied — no redeploy,
enforced on the next call.

## Findings that sharpen the paper

1. **Per-call authorization is real and works as the paper claims.** The gateway
   evaluates a CEL rule on every tool call against request attributes
   (`apiKey.name`, `mcp.tool.name`) and allows/denies the specific operation. The
   celebrate-the-spec leg is grounded in a running system, not asserted.
2. **The gate is on identity, not on an inline evidence lookup.** CEL evaluates
   request-available attributes only; a custom `apiKey.metadata.<field>` (e.g. a
   `tier` field) did **not** resolve, and an inline `evidence(...)` lookup is not
   expressible. So the tier is carried by **which identity** a workflow holds, and
   the trust decision — read the delivery evidence, decide the tier, assign the
   identity — is the **organization's build** (the cadence), exactly the division
   of labor the paper describes. The gateway is the actuator; the evidence layer +
   cadence are the sensor and the policy.
3. **Denial is a clean per-call scope restriction** (the disallowed tool is simply
   not callable for that identity), which is the enforceable, legible behavior the
   paper attributes to the boundary.

## Correction this forced in the draft

The first-draft exhibit used a fictional inline `evidence(identity.workflow_id).revert_rate_28d < 0.05`
policy. Acting on it showed that is **not** how the gateway evaluates. The exhibit
was corrected to the tested mechanism: a per-call rule gating scope on the
workflow's **identity/tier**, with the evidence→tier→identity assignment named as
the organization's cadence. The corrected exhibit is therefore *runnable*, which is
a stronger claim than *illustrative*.
