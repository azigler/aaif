#!/usr/bin/env python3
"""pinki-audit.py -- deterministic, read-only audit of the shared pinki ledger.

Job: the weekly pinki-steward pulse (aaif-eecq) runs this to get the same metrics
every week, so week-over-week deltas mean something. Stdlib only. It never
writes the ledger; the only file it writes is the --json snapshot.

Usage:
  pinki-audit.py [--ledger PATH] [--since ISO] [--now ISO] [--json PATH] [--prev PATH]

Exit codes: 0 ok, 2 ledger missing or unreadable (never an empty result).

Fixture rows (meta.dir starts with /tmp) are counted, then dropped from every
other metric, including their amend/resolve/assess rows.
"""

import argparse
import collections
import json
import os
import re
import statistics
import sys
from datetime import UTC, datetime

DEFAULT_LEDGER = os.path.expanduser("~/.local/state/harness/pinki-ledger.jsonl")
DONE_RE = re.compile(r"\b(done|landed|shipped|kept|complete|returned)\b", re.I)
OUTCOMES = ("satisfied", "cancelled", "released", "lapsed", "refused")


def parse_ts(s):
    """Parse an ISO-8601 string (Z or offset) to an aware UTC datetime, or None."""
    if not isinstance(s, str) or not s:
        return None
    try:
        d = datetime.fromisoformat(s.replace("Z", "+00:00"))
    except ValueError:
        return None
    if d.tzinfo is None:
        d = d.replace(tzinfo=UTC)
    return d.astimezone(UTC)


def iso(d):
    return d.strftime("%Y-%m-%dT%H:%M:%SZ")


def norm_text(t):
    t = re.sub(r"[^\w\s]", " ", (t or "").lower())
    return " ".join(t.split())


def share(n, d):
    return round(n / d, 4) if d else 0.0


def med_minutes(deltas):
    return round(statistics.median(deltas), 1) if deltas else None


def load_rows(path):
    rows, bad = [], 0
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                r = json.loads(line)
            except json.JSONDecodeError:
                bad += 1
                continue
            if isinstance(r, dict):
                rows.append(r)
            else:
                bad += 1
    return rows, bad


def audit(rows, now, since):
    promises = {}
    by_id = collections.defaultdict(list)
    for r in rows:
        if r.get("type") == "promise" and r.get("id"):
            if r["id"] not in promises:
                promises[r["id"]] = r
        elif r.get("promise"):
            by_id[r["promise"]].append(r)

    # window
    if since:
        promises = {
            i: p
            for i, p in promises.items()
            if (parse_ts(p.get("ts")) or now) >= since
        }
    fixture_ids = {
        i
        for i, p in promises.items()
        if str((p.get("meta") or {}).get("dir", "")).startswith("/tmp")
    }
    live = {i: p for i, p in promises.items() if i not in fixture_ids}

    info = {}
    for i, p in live.items():
        meta = p.get("meta") or {}
        evs = by_id.get(i, [])
        resolves = [(n, e) for n, e in enumerate(evs) if e.get("type") == "resolve"]
        amends = [e for e in evs if e.get("type") == "amend"]
        assess = [(n, e) for n, e in enumerate(evs) if e.get("type") == "assess"]
        # The first resolve wins. Only its author can correct its outcome, and
        # only corrections later in the log apply.
        res_index, res = resolves[0] if resolves else (None, None)
        corrections = [
            e for n, e in enumerate(evs)
            if res is not None and n > res_index and e.get("type") == "correct"
            and e.get("by") == res.get("by")
        ]
        outcome_event = corrections[-1] if corrections else res
        ts = parse_ts(p.get("ts"))
        until = parse_ts(p.get("until"))
        # pinki's fold: the LAST amend in log order wins, unconditionally. An
        # unparseable until there leaves the promise owed but never overdue.
        current_until = until
        current_until_text = p.get("until")
        if amends:
            current_until = parse_ts(amends[-1].get("until"))
            current_until_text = amends[-1].get("until")
        info[i] = {
            "p": p,
            "meta": meta,
            "res": res,
            "res_index": res_index,
            "outcome_event": outcome_event,
            "amends": amends,
            "assess": assess,
            "ts": ts,
            "until": until,
            "current_until": current_until,
            "current_until_text": current_until_text,
            "writer": meta.get("writer") or (
                "pinki-cli" if i.startswith("pnk_") else "unknown"
            ),
            "seat": p.get("by") or "unknown",
            "outcome": (outcome_event.get("as") if outcome_event else None)
            or ("OPEN" if not res else "unknown"),
        }

    total_live = len(live)

    # 2. outcomes per writer / seat
    def outcome_table(key, required=()):
        t = collections.defaultdict(lambda: collections.Counter())
        for v in info.values():
            t[v[key]][v["outcome"]] += 1
            t[v[key]]["total"] += 1
        for name in required:
            t[name]
        return {
            k: {"total": c["total"], **{o: c[o] for o in OUTCOMES}, "OPEN": c["OPEN"]}
            for k, c in sorted(t.items(), key=lambda kv: -kv[1]["total"])
        }

    by_writer = outcome_table("writer", ("pinki-cli", "unknown"))
    by_seat = outcome_table("seat")

    # 3 + 4. cancelled
    cancelled = [v for v in info.values() if v["outcome"] == "cancelled"]
    molt_cancelled = [v for v in cancelled if v["meta"].get("kind") == "molt"]
    done_reason = [
        v
        for v in cancelled
        if DONE_RE.search(str(v["outcome_event"].get("reason") or ""))
    ]

    # 5. violated assessments
    violated_rows = 0
    violated_ids = set()
    violated_then_satisfied = set()
    for i, v in info.items():
        # pinki's superseded_by relation: a later assessment can replace the
        # first still-unsuperseded earlier one with the same observer and ts.
        superseded = set()
        for pos, (_, a) in enumerate(v["assess"]):
            if a.get("supersedes") is None:
                continue
            for prior, (_, old) in enumerate(v["assess"][:pos]):
                if (prior not in superseded
                        and old.get("observer") == a.get("observer")
                        and old.get("ts") == a["supersedes"]):
                    superseded.add(prior)
                    break
        for pos, (event_index, a) in enumerate(v["assess"]):
            if pos in superseded:
                continue
            if a.get("state") == "violated":
                violated_rows += 1
                violated_ids.add(i)
                if (v["outcome"] == "satisfied" and v["res_index"] is not None
                        and event_index < v["res_index"]):
                    violated_then_satisfied.add(i)

    # 6. open
    opens = []
    for i, v in info.items():
        if v["res"] is None:
            age = (now - v["ts"]).total_seconds() / 3600 if v["ts"] else None
            overdue = bool(v["current_until"] and v["current_until"] < now)
            opens.append(
                {
                    "id": i,
                    "by": v["seat"],
                    "age_h": round(age, 1) if age is not None else None,
                    "overdue": overdue,
                    "until": v["current_until_text"],
                    "text": (v["p"].get("promise") or "")[:70],
                }
            )
    opens.sort(key=lambda o: -(o["age_h"] or 0))
    overdue = [o for o in opens if o["overdue"]]

    # 7. duplicate open texts per seat
    groups = collections.defaultdict(list)
    for o in opens:
        groups[(o["by"], norm_text(live[o["id"]].get("promise")))].append(
            o["id"]
        )
    dups = [
        {"by": k[0], "text": k[1][:70], "count": len(ids), "ids": ids}
        for k, ids in groups.items()
        if len(ids) > 1
    ]
    dups.sort(key=lambda d: -d["count"])

    # 8. refs, 9. nudges
    with_ref = [
        i for i, v in info.items() if str(v["meta"].get("ref") or "").strip()
    ]
    nudged = [
        i
        for i, v in info.items()
        if any(
            "nudge" in str(a.get("reason") or "").lower() for a in v["amends"]
        )
    ]

    # 10. Horizon median measures the deadline promised at declaration.
    horizon, latency = (
        collections.defaultdict(list),
        collections.defaultdict(list),
    )
    for v in info.values():
        if v["ts"] and v["until"]:
            horizon[v["writer"]].append(
                (v["until"] - v["ts"]).total_seconds() / 60
            )
        if v["res"] is not None and v["ts"]:
            rt = parse_ts(v["res"].get("ts"))
            if rt:
                latency[v["writer"]].append((rt - v["ts"]).total_seconds() / 60)
    medians = {
        w: {
            "horizon_min": med_minutes(horizon.get(w, [])),
            "latency_min": med_minutes(latency.get(w, [])),
        }
        for w in sorted(set(horizon) | set(latency) | {v["writer"] for v in info.values()})
    }

    # 11. id lengths
    id_len = collections.Counter(len(i) for i in info)

    cancelled_total = len(cancelled)
    scalars = {
        "promises_total": len(promises),
        "fixture_promises": len(fixture_ids),
        "promises_live": total_live,
        "direct_cli_promises": sum(
            1 for v in info.values() if v["writer"] == "pinki-cli"
        ),
        "cancelled_total": cancelled_total,
        "molt_cancelled": len(molt_cancelled),
        "molt_cancelled_share": share(len(molt_cancelled), cancelled_total),
        "cancelled_reads_done": len(done_reason),
        "violated_assessments": violated_rows,
        "violated_then_satisfied": len(violated_then_satisfied),
        "open": len(opens),
        "amended_open": sum(
            1 for v in info.values() if v["res"] is None and v["amends"]
        ),
        "open_overdue": len(overdue),
        "open_overdue_max_age_h": max(
            (o["age_h"] or 0 for o in overdue), default=0
        ),
        "duplicate_open_groups": len(dups),
        "with_ref": len(with_ref),
        "with_ref_share": share(len(with_ref), total_live),
        "nudged": len(nudged),
    }
    return {
        "scalars": scalars,
        "by_writer": by_writer,
        "by_seat": by_seat,
        "medians_by_writer": medians,
        "open_promises": opens,
        "duplicate_open_texts": dups,
        "id_length_distribution": {
            str(k): v for k, v in sorted(id_len.items())
        },
        "violated_promise_ids": sorted(violated_ids),
        "violated_then_satisfied_ids": sorted(violated_then_satisfied),
    }


def fmt_delta(cur, prev):
    if prev is None or not isinstance(prev, (int, float)):
        return "n/a"
    d = cur - prev
    if isinstance(cur, float) or isinstance(prev, float):
        d = round(d, 4)
    return f"{d:+g}"


def render(snap, prev):
    s = snap["scalars"]
    ps = (prev or {}).get("scalars", {})
    out = []
    w = out.append
    w(f"pinki audit  ledger={snap['ledger']}  generated={snap['generated_at']}")
    w(
        f"window: since={snap['window']['since'] or 'all rows'}  now={snap['window']['now']}"
        f"  (bad ledger lines: {snap['bad_lines']})"
    )
    w("")
    w(f"{'metric':<28}{'value':>10}" + (f"{'delta':>10}" if prev else ""))
    for k, v in s.items():
        line = f"{k:<28}{v:>10}"
        if prev:
            line += f"{fmt_delta(v, ps.get(k)):>10}"
        w(line)

    def table(title, tbl):
        w("")
        w(title)
        columns = (("total", 6), ("satisfied", 10), ("cancelled", 10),
                   ("released", 9), ("lapsed", 8), ("refused", 8), ("OPEN", 6))
        w(f"  {'name':<20}" + "".join(f"{key:>{width}}" for key, width in columns))
        for k, c in tbl.items():
            w(f"  {k[:20]:<20}" + "".join(
                f"{c[key]:>{width}}" for key, width in columns
            ))

    table("by writer (meta.writer)", snap["by_writer"])
    table("by seat (by)", snap["by_seat"])
    w("")
    w(
        "median minutes by writer (horizon = until-ts, latency = declare-to-resolve)"
    )
    for k, m in snap["medians_by_writer"].items():
        w(
            f"  {k[:20]:<20}horizon={m['horizon_min']}  latency={m['latency_min']}"
        )
    w("")
    w(
        "id length distribution: "
        + ", ".join(
            f"{k}:{v}" for k, v in snap["id_length_distribution"].items()
        )
    )

    def open_list(title, items):
        w("")
        w(title)
        for o in items:
            w(f"  {o['age_h']:>7}h  {o['id']}  {o['by']:<10} {o['text']}")
        if not items:
            w("  (none)")

    open_list(
        "open + overdue", [o for o in snap["open_promises"] if o["overdue"]]
    )
    open_list(
        "open, not yet due",
        [o for o in snap["open_promises"] if not o["overdue"]],
    )
    w("")
    w("duplicate open texts per seat")
    for d in snap["duplicate_open_texts"]:
        w(f"  x{d['count']} {d['by']}: {d['text']}  {', '.join(d['ids'])}")
    if not snap["duplicate_open_texts"]:
        w("  (none)")
    return "\n".join(out)


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Read-only audit of the pinki ledger."
    )
    ap.add_argument("--ledger", default=DEFAULT_LEDGER)
    ap.add_argument(
        "--since", help="ISO time; only promises declared at or after it"
    )
    ap.add_argument("--now", help="ISO time; override the clock (tests)")
    ap.add_argument("--json", metavar="PATH", help="write the snapshot here")
    ap.add_argument(
        "--prev", metavar="PATH", help="earlier snapshot, for a delta column"
    )
    a = ap.parse_args(argv)

    if not os.path.isfile(a.ledger):
        print(f"pinki-audit: ledger not found: {a.ledger}", file=sys.stderr)
        return 2
    now = parse_ts(a.now) if a.now else datetime.now(UTC)
    since = parse_ts(a.since) if a.since else None
    if now is None or (a.since and since is None):
        print("pinki-audit: --now/--since must be ISO-8601", file=sys.stderr)
        return 2
    try:
        rows, bad = load_rows(a.ledger)
    except OSError as e:
        print(
            f"pinki-audit: cannot read ledger {a.ledger}: {e}", file=sys.stderr
        )
        return 2

    prev = None
    if a.prev:
        try:
            with open(a.prev, encoding="utf-8") as fh:
                prev = json.load(fh)
        except (OSError, json.JSONDecodeError) as e:
            print(
                f"pinki-audit: cannot load --prev {a.prev}: {e}",
                file=sys.stderr,
            )
            return 2

    snap = {
        "generated_at": iso(now),
        "ledger": a.ledger,
        "window": {"since": iso(since) if since else None, "now": iso(now)},
        "bad_lines": bad,
    }
    snap.update(audit(rows, now, since))
    print(render(snap, prev))
    if a.json:
        with open(a.json, "w", encoding="utf-8") as fh:
            json.dump(snap, fh, indent=2, sort_keys=False)
            fh.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
