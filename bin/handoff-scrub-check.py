#!/usr/bin/env python3
"""Scrub check for one handoff note. Exit 0 clean, 1 refused, 2 could-not-evaluate.

Usage: handoff-scrub-check.py <label> <file-with-the-staged-content>

WHAT THIS CATCHES: literal markers only -- a `.local/` path, an Asana GID, a
credential. It does NOT catch strategy inference (what a note reveals by what it
says), and it is not claimed to. Zig accepted that limit on 2026-09-22 (aaif-l0kl).

WHERE EACH CHECK LIVES, and why:
  * CREDENTIALS -> the global scrub-secrets skill (scrub.py), imported, never copied.
    Its PATTERNS dict and live-value denylist (~/.secrets) are the one pattern list.
    scrub.py's CLI reports per-file counts, not lines, and the gate must NAME the
    line, so this script imports the module and reads match offsets from its PATTERNS.
  * `.local/` PATH and ASANA GID -> here, in aaif. They are aaif-specific markers
    (aaif's gitignored private folder; Zig's Asana hub) that scrub.py has no seam for
    and that would be wrong to add to a vault-wide tool.

A credential line is shown with the secret masked: a refusal must not re-print it.
"""

import importlib.util
import os
import re
import sys

SCRUB_PY = os.environ.get(
    "SCRUB_PY", os.path.expanduser("~/.claude/skills/scrub-secrets/scrub.py")
)

# A `.local` path component, e.g. `.local/x`, `~/aaif/.local/x`, "`.local/`".
# `~/.local/` and `$HOME/.local/` are the XDG user dir (~/.local/bin), not aaif's
# private folder, so they are exempt.
LOCAL_PATH = re.compile(r"(?<![\w.])(?<!~/)(?<!\$HOME/)\.local(?:/|(?![\w-]))")

# Asana GIDs are 16-19 digit integers (task / project / workspace ids); the same
# digits sit in app.asana.com URLs. Shorter numbers (epoch ms = 13 digits) pass.
ASANA_GID = re.compile(r"(?<![\w.])\d{16,19}(?![\w.])")


def load_scrub():
    spec = importlib.util.spec_from_file_location(
        "scrub_secrets_scrub", SCRUB_PY
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def main() -> int:
    label, path = sys.argv[1], sys.argv[2]
    try:
        scrub = load_scrub()
    except Exception as e:  # could-not-evaluate must never read as clean
        print(
            f"handoff-scrub: COULD NOT EVALUATE {label}: cannot load {SCRUB_PY} "
            f"({e.__class__.__name__}). Credential check unavailable; refusing.",
            file=sys.stderr,
        )
        return 2
    with open(path, encoding="utf-8", errors="replace") as fh:
        text = fh.read()
    lines = text.split("\n")

    deny = []
    secrets = os.path.expanduser(
        os.environ.get("SCRUB_SECRETS_FILE", scrub.SECRETS_FILE_DEFAULT)
    )
    try:
        deny = scrub.build_denylist(secrets)
    except OSError as e:
        print(
            f"handoff-scrub: WARN live-value denylist unavailable "
            f"({e.__class__.__name__}); credential check is PATTERNS ONLY.",
            file=sys.stderr,
        )

    findings: dict[int, set[str]] = {}

    def add(lineno: int, why: str) -> None:
        findings.setdefault(lineno, set()).add(why)

    for name, pat in scrub.PATTERNS.items():
        for m in pat.finditer(text):
            if not scrub.is_allowlisted(m.group(0)):
                add(text.count("\n", 0, m.start()) + 1, f"credential:{name}")
    for name, needle in deny:
        i = text.find(needle)
        while i != -1:
            add(text.count("\n", 0, i) + 1, f"credential:secrets-file:{name}")
            i = text.find(needle, i + 1)
    for n, line in enumerate(lines, 1):
        if LOCAL_PATH.search(line):
            add(n, ".local-path")
        if ASANA_GID.search(line):
            add(n, "asana-gid")

    if not findings:
        return 0
    for n in sorted(findings):
        whys = sorted(findings[n])
        shown = lines[n - 1]
        if any(w.startswith("credential:") for w in whys):
            shown, _ = scrub.redact_text(shown, deny)
        if len(shown) > 160:
            shown = shown[:160] + "..."
        print(f"{label}:{n}: {', '.join(whys)}\n    {shown}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
