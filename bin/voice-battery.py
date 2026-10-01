#!/usr/bin/env python3
"""Mechanical voice battery for a Zig personal-site draft. Usage: voice-battery.py DRAFT.md

Strips frontmatter, HTML comments, code fences and MDX import/export lines, then reports
line-numbered hits per check. Prints a positive-control line per regex so a zero is provable.
"""
import re
import sys

CHECKS = {
    "negative-parallelism": [
        r"\b(is|was|are|were)n[\u2019']?t\b[^.!?\n]{0,80}[,;:—-]+\s*(it|this|that|they|he|she|we)[\u2019']?(s|re)?\b",
        r"\bnot\b[^.!?\n]{0,60}[,;—-]+\s*(but\s+)?(a|an|the)\b",
        r"\b(was|were) never\b[^.!?\n]{0,80}[,;—-]",
        r"\bdon[\u2019']?t have\b[^.!?\n]{0,40}\b(are|is) (a|one)\b",
        r"\bNot [^.!?\n]{1,40}\. Not\b",
    ],
    "false-significance": [r"\b(is|are) (real|here)\b", r"\bera is here\b"],
    "magic-adverb": [r"\b(quietly|deeply|fundamentally|remarkably|arguably|truly|profoundly)\b"],
    "banned-vocab": [r"\b(delve\w*|utiliz\w*|leverag(e|es|ed|ing)|robust|streamlin\w*|tapestry|landscape|paradigm\w*)\b"],
    "scaffolding": [r"here[\u2019']s the (thing|kicker)", r"plot twist", r"let[\u2019']s break", r"in this (article|post)",
                    r"here[\u2019']s where it gets", r"it[\u2019']s important to note", r"in summary", r"serves as"],
    "spelled-number": [r"\b(two|three|four|five|six|seven|eight|nine|ten|eleven|twelve|fifteen|twenty|thirty|"
                       r"hundred|thousand|eighteenth|seventeenth|nineteenth)\b"],
    "prior-close-reuse": [r"gl;hf", r"old people already knew"],
}
POSITIVE_CONTROLS = {
    "negative-parallelism": "It isn't panic, it's routing.",
    "false-significance": "The agent era is here.",
    "magic-adverb": "It quietly works.",
    "banned-vocab": "We leverage the landscape.",
    "scaffolding": "Here's the thing about it.",
    "spelled-number": "There were three muses.",
    "prior-close-reuse": "gl;hf!",
}


def body_lines(text):
    text = re.sub(r"\A---\n.*?\n---\n", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
    text = re.sub(r"<!--.*?-->", lambda m: "\n" * m.group(0).count("\n"), text, flags=re.S)
    out, fence, data = [], False, False
    for line in text.split("\n"):
        if line.strip().startswith("```"):
            fence = not fence
            out.append("")
            continue
        if re.match(r"^export ", line):
            data = True
        skip = fence or data or re.match(r"^import ", line)
        if data and re.match(r"^\}\)?;?\s*$", line):
            data = False
        out.append("" if skip else line)
    return out


def main():
    with open(sys.argv[1], encoding="utf-8") as fh:
        lines = body_lines(fh.read())
    prose = " ".join(lines)
    words = len(re.findall(r"\b[\w\u2019']+\b", prose))
    dashes = prose.count("—") + len(re.findall(r"\s--\s", prose))
    print(f"words={words} em-dashes={dashes} (cap ~{max(1, words // 200)}) "
          f"{'OVER' if dashes > max(1, words // 200) else 'ok'}")
    for name, pats in CHECKS.items():
        ctrl = any(re.search(p, POSITIVE_CONTROLS[name], re.I) for p in pats)
        hits = [(i + 1, line.strip()) for i, line in enumerate(lines)
                for p in pats if re.search(p, line, re.I)]
        tag = " (advisory: cardinals in prose)" if name == "spelled-number" else ""
        print(f"\n[{name}]{tag} hits={len(hits)} positive-control={'PASS' if ctrl else 'FAIL (zero unproven)'}")
        for n, line in hits:
            print(f"  L{n}: {line[:160]}")


if __name__ == "__main__":
    main()
