#!/usr/bin/env python3
"""Parse an agentgateway text access log into a structured per-run MCP tool-call audit.

Metadata ONLY (tool name / method / target / status / session / duration) — the
gateway never logs tool-call contents unless payload capture is on, which it is not.
This is the audit spine for the tool-ablation experiment: tool counts feed the
leave-one-out figure, the ordered `sequence` feeds the stage-of-use figure, and
non-200 statuses are the allow/deny signal.

Usage:
  parse_audit.py <access.log> --agent exp [--start ISO] [--end ISO] [--json]

Attribute a run by its time window (run start..end) + agent identity; the log
interleaves all runs. Timestamps are ISO8601 and lexically sortable.
"""

import argparse
import json
import re
from collections import Counter

FIELD = re.compile(r'(\S+?)=("(?:[^"]*)"|\S+)')


def parse_line(line):
    if "protocol=mcp" not in line:
        return None
    ts = line.split("\t", 1)[0].strip()
    fields = {}
    for m in FIELD.finditer(line):
        fields[m.group(1)] = m.group(2).strip('"')
    return ts, fields


def build(log_path, agent, start, end):
    events = []
    with open(log_path, errors="replace") as fh:
        for line in fh:
            r = parse_line(line)
            if not r:
                continue
            ts, f = r
            if agent and f.get("agent") != agent:
                continue
            if start and ts < start:
                continue
            if end and ts > end:
                continue
            events.append(
                {
                    "ts": ts,
                    "method": f.get("mcp.method.name"),
                    "tool": f.get("gen_ai.tool.name"),
                    "target": f.get("mcp.target"),
                    "status": f.get("http.status"),
                    "session": f.get("mcp.session.id"),
                    "duration_ms": (f.get("duration") or "").rstrip("ms"),
                }
            )
    calls = [e for e in events if e["method"] == "tools/call"]
    denied = [e for e in calls if e["status"] and e["status"] != "200"]
    summary = {
        "window": {
            "start": events[0]["ts"] if events else None,
            "end": events[-1]["ts"] if events else None,
        },
        "total_mcp_events": len(events),
        "tool_calls": len(calls),
        "tool_counts": dict(Counter(e["tool"] for e in calls)),
        "status_counts": dict(Counter(e["status"] for e in calls)),
        "denied_calls": len(denied),
        "sequence": [e["tool"] for e in calls],
    }
    return summary, events


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("log")
    ap.add_argument("--agent", default="exp")
    ap.add_argument("--start", default=None)
    ap.add_argument("--end", default=None)
    ap.add_argument("--json", action="store_true", help="emit full events too")
    a = ap.parse_args()
    summary, events = build(a.log, a.agent, a.start, a.end)
    out = {"summary": summary, "events": events} if a.json else summary
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
