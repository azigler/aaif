#!/usr/bin/env python3
"""radar-live-state-lint.py — enforce live-state tagging on aaif-radar reports.

RULE (aaif-1bw): every line in a radar report that mentions a bead id must
carry that id's store status on the SAME line, as a bracketed tag right
after the id — e.g. `aaif-51g [CLOSED]`, `aaif-i5a [OPEN]`,
`aaif-omn [IN_PROGRESS]`, `aaif-xyz [TOMBSTONE]`. This is the DERIVE rung
from aaif-1bw's ladder: a radar line naming a bead id resolves that id's
live status at generation time, so a closed or tombstoned referent can
never render as an open ask (the aaif-51g / aaif-1oh incident: a bead
that shipped 2026-08-28 was rendered as an unclaimed "ship or concede"
ask twice, two weeks apart, because the generator never checked).

Checks, one diagnostic per violation:
  (a) an id appears with no `[STATUS]` tag immediately after it
  (b) a tag is present but disagrees with the store's live status
  (c) a CLOSED or TOMBSTONE id appears on a line that also contains
      "ask" vocabulary (see ASK_VOCAB below)
  (d) an id is not found in the store at all ("unknown id")

Exit 0 when clean, 1 when any violation is found. `--summary` additionally
prints a table of every id seen -> store status -> tag -> verdict.
"""

import argparse
import json
import re
import sys
from pathlib import Path

# Bead ids in this store look like: aaif-51g, aaif-i5a,
# aaif-ambassador-program-18o.28, aaif-pinki-export-formats-rbs — a prefix,
# zero or more slug words, and a final 3-char base36-ish hash segment,
# optionally followed by a `.N` child suffix. The 3-char-final-segment rule
# is what keeps this from matching prose or skill/file names built the same
# way (`aaif-review`, `aaif-line-art`'s "art" is the one known near miss —
# see DENYLIST) and from matching `#709`-style issue numbers, which never
# start with `aaif-` in the first place.
ID_RE = re.compile(
    r"(?<![\w/.-])aaif-(?:[a-z0-9]+-)*[a-z0-9]{3}(?:\.[0-9]+)?(?![\w-])"
)

# Known aaif-prefixed names that match ID_RE's shape but are not bead ids
# (skill directory names, ref filenames). Extend as new ones collide.
DENYLIST = {"aaif-line-art"}

TAG_RE = re.compile(r"^\s?\[(OPEN|IN_PROGRESS|CLOSED|TOMBSTONE)\]")

STATUS_TO_TAG = {
    "open": "OPEN",
    "in_progress": "IN_PROGRESS",
    "closed": "CLOSED",
    "tombstone": "TOMBSTONE",
}

ASK_VOCAB = [
    "unclaimed",
    "ship or concede",
    "ship-or-concede",
    "decision needed",
    "awaiting",
    "still open",
    "pending",
    "ruling",
    "your call",
]


def find_repo_root(explicit_repo: str | None) -> Path:
    if explicit_repo:
        return Path(explicit_repo).resolve()
    here = Path(__file__).resolve().parent
    for candidate in [here, *here.parents]:
        if (candidate / ".beads").exists() or (candidate / ".git").exists():
            return candidate
    return here


def load_store(store_path: Path) -> dict[str, str]:
    """Last record per id wins, per the bead's own JSONL semantics."""
    statuses: dict[str, str] = {}
    if not store_path.exists():
        print(f"ERROR: store not found at {store_path}", file=sys.stderr)
        sys.exit(2)
    with store_path.open() as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            row = json.loads(line)
            statuses[row["id"]] = row["status"]
    return statuses


def check_line(line: str):
    """Yield (bead_id, tag_match, position) for every id found on one line."""
    for m in ID_RE.finditer(line):
        bead_id = m.group(0)
        if bead_id in DENYLIST:
            continue
        rest = line[m.end() :]
        tag_match = TAG_RE.match(rest)
        yield bead_id, tag_match, m.start()


def lint_file(
    path: Path, store: dict[str, str], summary_rows: list
) -> list[str]:
    diagnostics = []
    with path.open() as f:
        for lineno, line in enumerate(f, start=1):
            for bead_id, tag_match, _ in check_line(line):
                store_status = store.get(bead_id)
                tag = tag_match.group(1) if tag_match else None
                verdict = "OK"

                if store_status is None:
                    diagnostics.append(
                        f"{path}:{lineno}: {bead_id} unknown id (not in store)"
                    )
                    verdict = "UNKNOWN-ID"
                else:
                    expected_tag = STATUS_TO_TAG[store_status]
                    if tag is None:
                        diagnostics.append(
                            f"{path}:{lineno}: {bead_id} missing status tag "
                            f"(store status is {expected_tag})"
                        )
                        verdict = "MISSING-TAG"
                    elif tag != expected_tag:
                        diagnostics.append(
                            f"{path}:{lineno}: {bead_id} tag disagrees with "
                            f"store (store={expected_tag}, tag={tag})"
                        )
                        verdict = "WRONG-TAG"

                    if store_status in ("closed", "tombstone"):
                        lower = line.lower()
                        hit = next((w for w in ASK_VOCAB if w in lower), None)
                        if hit is not None:
                            diagnostics.append(
                                f"{path}:{lineno}: {bead_id} {expected_tag} id "
                                f'rendered in an ask-vocabulary line (matched "{hit}")'
                            )
                            if verdict == "OK":
                                verdict = "ASK-ON-CLOSED"

                summary_rows.append(
                    (bead_id, store_status or "UNKNOWN", tag, verdict)
                )
    return diagnostics


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "reports", nargs="+", help="radar report markdown paths"
    )
    parser.add_argument(
        "--store",
        default=".beads/issues.jsonl",
        help="path to the bead store JSONL (default: .beads/issues.jsonl, "
        "resolved against the repo root unless absolute)",
    )
    parser.add_argument(
        "--repo",
        default=None,
        help="repo root override (default: walk up from this script)",
    )
    parser.add_argument(
        "--summary", action="store_true", help="print a table of every id seen"
    )
    args = parser.parse_args()

    repo_root = find_repo_root(args.repo)
    store_path = Path(args.store)
    if not store_path.is_absolute():
        store_path = repo_root / store_path
    store = load_store(store_path)

    all_diagnostics: list[str] = []
    summary_rows: list[tuple[str, str, str | None, str]] = []
    for report in args.reports:
        all_diagnostics.extend(lint_file(Path(report), store, summary_rows))

    if args.summary:
        print(f"{'id':<40} {'store':<12} {'tag':<12} verdict")
        for bead_id, status, tag, verdict in summary_rows:
            print(f"{bead_id:<40} {status:<12} {tag or '-':<12} {verdict}")

    for d in all_diagnostics:
        print(d)

    return 1 if all_diagnostics else 0


if __name__ == "__main__":
    sys.exit(main())
