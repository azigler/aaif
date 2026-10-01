#!/usr/bin/env python3
"""Thin wrapper: the canonical voice battery lives in the zig-voice skill.

Usage: voice-battery.py DRAFT.md
"""
import os
import sys

CANONICAL = os.path.expanduser("~/.agents/agents/skills/zig-voice/bin/voice-battery.py")
os.execv(sys.executable, [sys.executable, CANONICAL, *sys.argv[1:]])
