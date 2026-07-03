---
name: gateway-harden
description: "Turn observed agentgateway traffic into a least-privilege authorization policy — derive CEL rules that allow exactly the identities, methods, and tools your fleet actually used, and deny the rest. Consumes the /gateway-audit baseline. Proposes policy YAML with a validate→shadow→apply runbook; it is HUMAN-GATED and NEVER applies policy itself. Fire it after an audit to tighten a route, close an over-broad MCP server, or scope an agent to its real tool set."
metadata:
  author: Andrew Zigler
  organization: independent (AAIF Ambassador)
  version: "1.0"
---

# /gateway-harden — least privilege from observed behavior

You can't write a good allowlist by imagining what an agent needs. You measure what
it actually did, then allow exactly that. This skill takes the observed-behavior
baseline from `/gateway-audit` and derives an agentgateway **authorization policy**:
CEL rules that permit the identities / methods / tools seen in the log and deny
everything else. Deny-by-default, earned from evidence.

It **proposes**; it does not apply. Output is policy YAML plus a validate→shadow→apply
runbook for a human to walk. Tightening a live authz policy is a foot-gun (you can lock
out legitimate-but-unseen traffic) — so the apply step is always yours.

## When to fire

- **After `/gateway-audit`** — you have the observed surface; convert it to policy.
- **Scope an agent** to the tools it really uses (close the "this MCP server exposes 40
  tools, my agent calls 3" gap).
- **Close a route** that's been open (network-only) now that you know its real callers.
- **Respond to an audit finding** — an unexpected tool call, a caller that shouldn't be there.

## The authz surface (verified on agentgateway v1.3.1)

Two CEL layers, each a `{rules: [{allow|deny: "<CEL>"}]}` ruleset, attached under a
route's `policies:`:

| Policy | Gates on | CEL variables |
|---|---|---|
| `authorization` | the HTTP request (identity, path, method) | `extauthz.tailscaleEmail`, `extauthz.tailscaleNode`, `jwt.<claim>`, request attrs |
| `mcpAuthorization` | MCP tools / prompts / resources | `mcp.tool.name`, `mcp.method` |

**Eval order (verified):** `deny` wins → all `require` must pass → any `allow` allows.
**Adding any `allow` flips the ruleset to allowlist semantics** — everything not allowed
is denied. That is the lever: one `allow` per observed thing = deny-by-default for the rest.

**Verified enforcement** (allowlist `mcp.tool.name == "echo"` on the everything server):
`tools/list` returned **only `echo`** (denied tools disappear from discovery), calling
`echo` succeeded, calling `add` was **denied** — surfaced to the client as
`-32602 "Unknown tool: add"` (agentgateway hides denied tools; no "you're forbidden"
information leak), and logged as `status=400 gen_ai.tool.name=add reason=MCP` so the
audit still sees the attempt.

## Derivation (observed surface → rules)

From `/gateway-audit`, for each identity collect the sets it actually exercised:
`routes`, `mcp.method.name`s, `gen_ai.tool.name`s. Then:

1. **Tool allowlist per route** → `mcpAuthorization`, from the observed tool set:
   ```yaml
   policies:
     mcpAuthorization:
       rules:
       - allow: 'mcp.tool.name in ["echo","add"]'   # exactly the tools seen; the rest vanish
   ```
2. **Identity gate per route** → `authorization`, from the observed callers:
   ```yaml
   policies:
     authorization:
       rules:
       - allow: 'extauthz.tailscaleEmail == "you@example.com"'   # or jwt.sub / a virtual-key id
   ```
3. **Per-identity-per-tool** (tighter) → combine: an `authorization` allow on the caller
   AND an `mcpAuthorization` allow on that caller's tool set. If different agents need
   different tools, prefer separate routes (one per agent identity) so each carries its
   own allowlist, rather than one CEL expression branching on identity.
4. **Method scoping** (optional) → `deny: 'mcp.method == "tools/call" && !(mcp.tool.name in [...])'`
   is redundant with the allowlist; prefer the positive allowlist for legibility.

Emit the rules as a **diff against the current route config**, not a whole new file —
so the reviewer sees exactly what tightens.

## Identity is the prerequisite (verified 2026-07-03)

A tool allowlist is meaningless until the gateway can tell agents apart. On a shared box,
`src.addr` is the same for every agent — so per-agent scoping needs a real identity:

1. **Give each agent a virtual key** — an `apiKey` policy on the route:
   ```yaml
   apiKey:
     mode: strict          # 401 without a valid key
     keys:
     - { key: sk-goose-…, metadata: { name: goose } }
     - { key: sk-cc-…,    metadata: { name: cc } }
   ```
   The key (Bearer header) authenticates; its metadata surfaces to CEL as
   **`apiKey.name` / `apiKey.owner` / `apiKey.group`**.
2. **Key the `mcpAuthorization` rules on the identity** (this is what "per-agent least
   privilege" actually is):
   ```yaml
   - allow: 'apiKey.name == "cc"'                                                    # cc: all
   - allow: 'apiKey.name == "goose" && mcp.tool.name in ["echo","sequentialthinking"]'  # goose: two
   ```
3. **Make it visible** — the log omits identity by default; add
   `frontendPolicies: accessLog: add: { agent: apiKey.name }` so every line carries `agent=…`.

**⚠️ The gotcha that will bite you:** at the authz layer `mcp.tool.name` is the
**underlying** tool name (`echo`), NOT the federation-namespaced name (`everything_echo`)
that `tools/list` shows. A rule against the namespaced name matches nothing and the agent
silently gets **zero** tools. Derive rules from the underlying names.

## The gate — validate → shadow → apply (the human walks this)

Never apply. Produce this runbook with the proposal:

1. **Validate:** `agentgateway -f proposed.yaml --validate-only` (must say "Configuration is valid!").
2. **Shadow:** stand the proposed policy up on a *non-production* copy / spare port and
   replay representative traffic; confirm the allowed set still passes and the denied set
   is what you intended. (agentgateway hot-reloads its config file — watch the access log.)
3. **Apply deliberately:** swap it in on the live route; **watch `/gateway-audit` for new
   4xx/`reason=Authorization` clusters** for a full duty cycle. New denials = an
   over-tight rule; loosen with evidence.
4. **Keep the baseline.** Save the audit window the policy was derived from next to the
   policy, so the next reviewer knows what "observed" meant.

## Cautions (anti-slop)

- **Over-fitting is the failure mode.** A short observation window yields rules that break
  legitimate-but-unseen behavior. **State the window** the policy was derived from and set
  a minimum (e.g. "≥1 representative duty cycle"); when in doubt, widen the window before
  tightening the rule.
- **Propose, never apply.** This skill writes YAML and a runbook. A human validates,
  shadows, and applies. No autonomous policy changes to a live gateway.
- **Deny is silent for MCP tools** (they vanish as "Unknown tool"). That's good security
  (no leak) but means a wrongly-denied tool looks *missing*, not *forbidden*, to the agent
  — call this out so a mis-scope is diagnosable (cross-reference the audit's `reason=MCP` lines).
- **Identity first.** A tool allowlist without an identity gate still lets *anyone on the
  network* call the allowed tools. Pair `mcpAuthorization` with `authorization` (tailnet
  identity / JWT / virtual key) — network position is not identity (see the capability map).

## Reads / relates

- Input: `/gateway-audit` output + the access log.
- Field/authz reference: `~/explore/agentgateway/refs/capability-map.md`,
  `~/explore/agentgateway/experiment/VERIFIED.md` (the identity-authz eval-order run).
