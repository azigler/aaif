#!/usr/bin/env bash
#
# gates.sh — the mechanical ship-gate runner for the "Earned Autonomy" whitepaper.
#
# Mechanizes Surface 1 (the whitepaper) of the per-surface ship-gates contract in
# refs/program/ship-gates.md. Prints PASS / FAIL per gate; exits 0 iff EVERY gate
# passes, nonzero on any failure.
#
# VENDOR POLICY FOR THIS SURFACE (decided round-4c, see REVIEW-NOTES.md):
#   * LinearB is the intentionally-NAMED benchmark source + byline affiliation.
#     Its presence is ALLOWED — reported as INFO, never a failure here.
#   * LinearB's customers (Expedia / Adobe / Syngenta) stay OUT.
#   * Peer engineering-intelligence products stay OUT (the delivery-metrics
#     framing is DORA-only). Their presence would break vendor-neutrality.
#
# DO NOT copy this script to the blog surface: there, `LinearB` is a HARD FAIL,
# not an allowance. See OPEN-A / the per-surface table in ship-gates.md.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PAPER="$SCRIPT_DIR/paper"
EXPECTED_PAGES=8
SRC=("$PAPER/main.tex" "$PAPER/references.bib" "$PAPER"/sections/*.tex)

FAILED=0

pass() { printf '  \033[32mPASS\033[0m  %-22s %s\n' "$1" "${2:-}"; }
fail() { printf '  \033[31mFAIL\033[0m  %-22s %s\n' "$1" "${2:-}"; FAILED=$((FAILED + 1)); }
info() { printf '  \033[34mINFO\033[0m  %-22s %s\n' "$1" "${2:-}"; }

echo "== ship gates: Earned Autonomy whitepaper (Surface 1) =="

# --- preflight: required tools ------------------------------------------------
missing=""
for t in latexmk pdfinfo pdftotext grep; do
	command -v "$t" >/dev/null 2>&1 || missing="$missing $t"
done
if [ -n "$missing" ]; then
	fail "toolchain" "missing:$missing"
	echo "== cannot proceed without the LaTeX toolchain =="
	exit 1
fi

# --- gate: build (out-of-tree, so the committed main.pdf is never touched) -----
BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT
(cd "$PAPER" && latexmk -pdf -interaction=nonstopmode -halt-on-error \
	-outdir="$BUILD_DIR" main.tex) >"$BUILD_DIR/build.out" 2>&1
build_rc=$?
PDF="$BUILD_DIR/main.pdf"
LOG="$BUILD_DIR/main.log"

if [ "$build_rc" -eq 0 ] && [ -f "$PDF" ]; then
	pass "build" "latexmk clean, main.pdf produced"
else
	fail "build" "latexmk rc=$build_rc (tail: $(tail -1 "$BUILD_DIR/build.out" 2>/dev/null))"
fi

# --- gate: page-count (must be exactly 8pp) -----------------------------------
if [ -f "$PDF" ]; then
	pages="$(pdfinfo "$PDF" 2>/dev/null | awk '/^Pages:/ {print $2}')"
	if [ "$pages" = "$EXPECTED_PAGES" ]; then
		pass "page-count" "$pages pages"
	else
		fail "page-count" "expected $EXPECTED_PAGES, got ${pages:-none}"
	fi
else
	fail "page-count" "no PDF (build failed)"
fi

# --- gate: undefined-citations (must be 0) ------------------------------------
if [ -f "$LOG" ]; then
	undef="$(grep -cE 'Citation .*undefined|Reference .*undefined|There were undefined (citation|reference)' "$LOG")"
	if [ "$undef" -eq 0 ]; then
		pass "undefined-citations" "0 undefined"
	else
		fail "undefined-citations" "$undef undefined citation/reference warning(s)"
	fi
else
	fail "undefined-citations" "no build log (build failed)"
fi

# --- gate: TBD sweep (source + rendered PDF must be clean) --------------------
tbd_pat='TBD|TODO|FIXME|XXX|\[placeholder\]'
tbd_src="$(grep -rIniE "$tbd_pat" "${SRC[@]}" 2>/dev/null)"
tbd_pdf=""
[ -f "$PDF" ] && tbd_pdf="$(pdftotext "$PDF" - 2>/dev/null | grep -niE "$tbd_pat")"
if [ -z "$tbd_src$tbd_pdf" ]; then
	pass "tbd-sweep" "no placeholders in source or PDF"
else
	fail "tbd-sweep" "found: $(printf '%s' "$tbd_src$tbd_pdf" | tr '\n' ';' | cut -c1-90)"
fi

# --- gate: no "MCP 1.0" (it is "the 2026-07-28 spec") -------------------------
mcp10="$(grep -rIniE 'MCP[[:space:]]*1\.0' "${SRC[@]}" 2>/dev/null)"
if [ -z "$mcp10" ]; then
	pass "no-mcp-1.0" "absent"
else
	fail "no-mcp-1.0" "found: $(printf '%s' "$mcp10" | tr '\n' ';' | cut -c1-90)"
fi

# --- gate: customers absent (Expedia / Adobe / Syngenta) ---------------------
cust="$(grep -rIniE 'expedia|adobe|syngenta' "${SRC[@]}" 2>/dev/null)"
if [ -z "$cust" ]; then
	pass "customers-absent" "no LinearB customers named"
else
	fail "customers-absent" "found: $(printf '%s' "$cust" | tr '\n' ';' | cut -c1-90)"
fi

# --- gate: competitors absent (DORA-only; peer engineering-intelligence out) --
# Presence of any peer delivery/engineering-intelligence product would break the
# paper's vendor-neutral, DORA-only framing. Patterns are anchored to avoid
# false positives; verified clean against the current draft.
comp_pat='getdx|DX Core|\bCore 4\b|swarmia|jellyfish|\bsleuth\b|code ?climate|pluralsight flow|\bfaros\b|\buplevel\b|\bwaydev\b|\ballstacks\b|\bathenian\b|gitclear|cortex\.io|minware'
comp="$(grep -rIniE "$comp_pat" "${SRC[@]}" 2>/dev/null)"
if [ -z "$comp" ]; then
	pass "competitors-absent" "DORA-only framing intact"
else
	fail "competitors-absent" "found: $(printf '%s' "$comp" | tr '\n' ';' | cut -c1-90)"
fi

# --- info: LinearB present (the ALLOWED named source — never a failure) -------
lb_hits="$(grep -rIniE 'linearb' "${SRC[@]}" 2>/dev/null | wc -l | tr -d ' ')"
info "linearb-allowed" "$lb_hits mention(s) — allowed named source (this surface only)"

# --- gate: no em-dash in rendered PDF (U+2014) --------------------------------
# Checked on the rendered text, not source: LaTeX comment separators use --- runs
# that never render, and source --- would false-positive on them. What a reader
# sees is the codepoint U+2014; \x{2014} matches it and (unlike a byte pattern)
# does not depend on the locale, and it correctly ignores the en-dash (U+2013).
if [ -f "$PDF" ]; then
	emdash="$(pdftotext "$PDF" - 2>/dev/null | grep -acP '\x{2014}')"
	if [ "${emdash:-0}" -eq 0 ]; then
		pass "no-em-dash" "0 em-dashes in rendered PDF"
	else
		fail "no-em-dash" "$emdash line(s) with an em-dash (—)"
	fi
else
	fail "no-em-dash" "no PDF (build failed)"
fi

# --- gate: no literal " actually " -------------------------------------------
act="$(grep -rIniw 'actually' "${SRC[@]}" 2>/dev/null)"
if [ -z "$act" ]; then
	pass "no-actually" "absent"
else
	fail "no-actually" "found: $(printf '%s' "$act" | tr '\n' ';' | cut -c1-90)"
fi

# --- verdict ------------------------------------------------------------------
echo "== $([ "$FAILED" -eq 0 ] && echo 'ALL GATES PASS' || echo "$FAILED GATE(S) FAILED") =="
exit "$FAILED"
