#!/usr/bin/env bash
# Ablation driver — behavior-primary outcome.
# Runs each config-identity (full/nucleus/nosearch/noedit/readonly) on one instance,
# holding the model (qwen3-coder:30b) and prompt fixed. Per-config tool set is enforced
# at the gateway (mcpAuthorization keyed on the apiKey identity), so the audit
# auto-attributes tool calls to the config. goose's built-in shell is DISABLED so all
# tool use flows through the governed MCP surface.
#
# Records per config: timing, whether a diff was produced, diff bytes. The tool-use
# audit (counts / sequence / allow-deny) and tokens are pulled afterward by identity +
# window from the gateway access log + request DB.
set -u
export PATH="$HOME/.local/bin:$PATH"
EXP=/home/ubuntu/aaif/submissions/2026-mcp-governance-whitepaper/experiment
cd "$EXP" || exit 1
KEYS_JSON=$(ssh pico cat /tmp/exp-keys.json 2>/dev/null)
INSTANCE=psf__requests-1142
REPO=/tmp/exp-workspace/requests
TASK=/tmp/exp-task.txt
RESULTS="$EXP/results/ablation-${INSTANCE}.jsonl"
: > "$RESULTS"

for CFG in full nucleus nosearch noedit readonly; do
  KEY=$(printf '%s' "$KEYS_JSON" | python3 -c "import sys,json;print(json.load(sys.stdin)['$CFG'])")
  cat > /tmp/expcfg/goose/config.yaml <<GEOF
GOOSE_PROVIDER: openai
GOOSE_MODEL: qwen3-coder:30b
extensions:
  honk:
    name: honk
    type: streamable_http
    uri: http://100.72.47.4:25001/mcp
    enabled: true
    timeout: 300
    headers: { Authorization: "Bearer ${KEY}" }
    envs: {}
  developer: { type: builtin, name: developer, display_name: Developer, enabled: false, timeout: 300 }
GEOF
  ssh pico "cd $REPO && git checkout -- . && git clean -fdq" >/dev/null 2>&1
  START=$(date -u +%Y-%m-%dT%H:%M:%S); T0=$(date +%s)
  timeout 400 env XDG_CONFIG_HOME=/tmp/expcfg OPENAI_API_KEY="$KEY" OPENAI_HOST=http://100.72.47.4:25003 \
    GOOSE_MODEL=qwen3-coder:30b goose run -i "$TASK" > "/tmp/exp-abl-${CFG}.log" 2>&1
  RC=$?; ELAPSED=$(( $(date +%s) - T0 )); END=$(date -u +%Y-%m-%dT%H:%M:%S)
  DIFFFILE="$EXP/results/diff-${CFG}-${INSTANCE}.txt"
  ssh pico "cd $REPO && git diff" > "$DIFFFILE" 2>/dev/null
  python3 - "$CFG" "$INSTANCE" "$START" "$END" "$ELAPSED" "$RC" "$DIFFFILE" <<'PY' >> "$RESULTS"
import sys, json
cfg,inst,start,end,el,rc,df = sys.argv[1:8]
body=open(df).read().strip()
print(json.dumps({"config":cfg,"instance":inst,"identity":"exp-"+cfg,"start":start,"end":end,
                  "elapsed_s":int(el),"rc":int(rc),"diff_bytes":len(body),"diff_produced":len(body)>0}))
PY
  echo "[$CFG] done elapsed=${ELAPSED}s diff_bytes=$(wc -c < "$DIFFFILE" | tr -d ' ')"
done
echo "ABLATION MATRIX COMPLETE -> $RESULTS"
