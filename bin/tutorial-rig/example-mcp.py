#!/usr/bin/env python3
"""Small local MCP backend for the generic tutorial rig example."""

import json
import sys


for line in sys.stdin:
    try:
        request = json.loads(line)
        if "id" not in request:
            continue
        method = request.get("method")
        if method == "initialize":
            result = {
                "protocolVersion": "2025-03-26",
                "capabilities": {"tools": {}},
                "serverInfo": {"name": "tutorial-example", "version": "1.0"},
            }
        elif method == "tools/list":
            result = {"tools": [{"name": "ping", "description": "Return a generic greeting", "inputSchema": {"type": "object", "properties": {}}}]}
        elif method == "tools/call" and request.get("params", {}).get("name") == "ping":
            result = {"content": [{"type": "text", "text": "pong"}]}
        else:
            result = None
        if result is None:
            response = {"jsonrpc": "2.0", "id": request["id"], "error": {"code": -32601, "message": "Method not found"}}
        else:
            response = {"jsonrpc": "2.0", "id": request["id"], "result": result}
        print(json.dumps(response), flush=True)
    except (json.JSONDecodeError, TypeError, ValueError) as error:
        print(f"MCP input error: {error}", file=sys.stderr, flush=True)
