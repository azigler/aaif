#!/usr/bin/env bash
# Full ablation matrix: 6 tool-configs x N instances, model + prompt fixed.
# Config tool set enforced at the gateway per apiKey identity; audit auto-attributes by
# identity + time window. goose shell disabled -> all tool use through the governed MCP surface.
set -u
export PATH="$HOME/.local/bin:$PATH"
EXP=/home/ubuntu/aaif/submissions/2026-mcp-governance-whitepaper/experiment
cd "$EXP" || exit 1
KEYS_JSON=$(ssh pico cat /tmp/exp-keys.json 2>/dev/null)
CONFIGS="readonly noedit nosearch nucleus full bloated"
INSTANCES="psf__requests-1142 pytest-dev__pytest-5262 pallets__flask-5014 pylint-dev__pylint-6903"
RESULTS="$EXP/results/ablation-matrix.jsonl"
: > "$RESULTS"

for INST in $INSTANCES; do
  REPO=$(python3 -c "import json;print({x['instance_id']:x for x in json.load(open('$EXP/data/pilot-instances.json'))}['$INST']['repo'])")
  BASE=$(python3 -c "import json;print({x['instance_id']:x for x in json.load(open('$EXP/data/pilot-instances.json'))}['$INST']['base_commit'])")
  REPODIR=$(basename "$REPO")
  python3 - "$INST" "$REPODIR" <<'PY'
import json, sys
inst, repodir = sys.argv[1], sys.argv[2]
d={x['instance_id']:x for x in json.load(open('data/pilot-instances.json'))}[inst]
p=(f"Fix a bug in the Python '{repodir}' library. Repository root: /tmp/exp-workspace/{repodir} ; "
   f"the package source is under it. Use absolute paths under /tmp/exp-workspace.\n\nBUG REPORT:\n"
   f"{d['problem_statement']}\n\nLocate the relevant source (list_directory / search_files / read_text_file), "
   f"then apply a minimal targeted fix with edit_file. If edit_file cannot match the exact text, use write_file "
   f"with the full corrected file. Do not run tests. Be decisive: apply the fix and stop. Reply DONE when applied.")
open('/tmp/exp-task.txt','w').write(p)
PY
  ssh pico "find /tmp/exp-workspace -mindepth 1 -maxdepth 1 -exec rm -rf {} + ; cd /tmp/exp-workspace && git clone --quiet https://github.com/${REPO}.git ${REPODIR} && cd ${REPODIR} && git checkout -q ${BASE}" >/dev/null 2>&1
  for CFG in $CONFIGS; do
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
    ssh pico "cd /tmp/exp-workspace/${REPODIR} && git checkout -- . && git clean -fdq" >/dev/null 2>&1
    START=$(date -u +%Y-%m-%dT%H:%M:%S); T0=$(date +%s)
    timeout 400 env XDG_CONFIG_HOME=/tmp/expcfg OPENAI_API_KEY="$KEY" OPENAI_HOST=http://100.72.47.4:25003 \
      GOOSE_MODEL=qwen3-coder:30b goose run -i /tmp/exp-task.txt > "/tmp/exp-abl-${INST}-${CFG}.log" 2>&1
    RC=$?; ELAPSED=$(( $(date +%s) - T0 )); END=$(date -u +%Y-%m-%dT%H:%M:%S)
    DIFFFILE="$EXP/results/diff-${INST}-${CFG}.txt"
    ssh pico "cd /tmp/exp-workspace/${REPODIR} && git diff" > "$DIFFFILE" 2>/dev/null
    python3 - "$CFG" "$INST" "$START" "$END" "$ELAPSED" "$RC" "$DIFFFILE" >> "$RESULTS" <<'PY'
import sys, json
cfg,inst,start,end,el,rc,df=sys.argv[1:8]
body=open(df).read().strip()
print(json.dumps({"config":cfg,"instance":inst,"identity":"exp-"+cfg,"start":start,"end":end,
                  "elapsed_s":int(el),"rc":int(rc),"diff_bytes":len(body),"diff_produced":len(body)>0}))
PY
    echo "[${INST} / ${CFG}] elapsed=${ELAPSED}s diff=$([ -s "$DIFFFILE" ] && echo Y || echo N)"
  done
done
echo "ABLATION MATRIX COMPLETE -> $RESULTS"
