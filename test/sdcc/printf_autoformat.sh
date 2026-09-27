#!/bin/sh
# test/sdcc/printf_autoformat.sh -- zpragma -autoformat for -compiler=sdcc
#
# Tests ravn/z88dk#74: without -autoformat, printf("%f", ...) under -compiler=sdcc
# silently prints literal 'f' and corrupts subsequent varargs. With -autoformat,
# zpragma scans format literals and auto-selects the needed classic converters.
#
# Two cases:
#  1. STATIC literal format: printf("v=%6.1f|d=%d|s=%s", 3.5, 42, "ok")
#     -> must print correct values (compile + run through ntvcm).
#  2. DYNAMIC format in a MIXED TU: a literal + a variable fmt
#     -> must emit a "not a string literal" note to stderr (compile-only).
#
# Skips if zcc, zsdcc, or ntvcm is unavailable.
#
# See: https://github.com/z88dk/z88dk/wiki/Classic--Pragmas#configuring-printf-and-scanf-converters
set -e
DIR=$(cd "$(dirname "$0")" && pwd)

# Auto-discover tool paths relative to this test tree (../../bin from test/sdcc/)
ZCCDIR=$(cd "$DIR/../.." && pwd)
if [ -x "$ZCCDIR/bin/zcc" ]; then
    export PATH="$ZCCDIR/bin:$PATH"
    export ZCCCFG="$ZCCDIR/lib/config"
fi
NTVCM=${NTVCM:-ntvcm}
if [ -z "$NTVCM" ] || ! command -v "$NTVCM" >/dev/null 2>&1; then
    # Try relative sibling: ../../ntvcm/ntvcm
    CANDIDATE=$(cd "$DIR/../.." && pwd)/ntvcm/ntvcm
    [ -x "$CANDIDATE" ] && NTVCM="$CANDIDATE"
fi

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }

# --- Case 1: STATIC literal format (compile + run) ---
# Without -autoformat this prints "v=f|d=0|s=" (bug from #74).
# With -autoformat zpragma detects %f and emits CRT_printf_format.
if ! zcc +cpm -compiler=sdcc --math32 \
        -create-app -o "$WORK/static" \
        "$DIR/printf_autoformat_static.c" \
        >"$WORK/static_build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/static_build.log"
    fail "static test: build failed"
fi
[ -f "$WORK/STATIC.COM" ] || fail "static test: no .COM produced"
OUT=$("$NTVCM" "$WORK/STATIC.COM" 2>/dev/null | tr -d '\r')
echo "$OUT" | grep -qF "PASS autoformat-static" \
    || { echo "got: [$OUT]"; fail "static test: expected PASS autoformat-static"; }
echo "PASS: static literal printf %f auto-selects converters (no #pragma)"

# --- Case 2: DYNAMIC format in a MIXED TU (compile-only, check note) ---
# A TU with a literal format ("%d") plus a runtime-variable format triggers
# a "not a string literal" note from zpragma -autoformat because the literal
# prunes the converter table and the runtime fmt may need uncovered converters.
LOG=$(zcc +cpm -compiler=sdcc --math32 \
        -c -o "$WORK/dynamic.o" \
        "$DIR/printf_autoformat_dynamic.c" 2>&1 || true)
echo "$LOG" | grep -q "not a string literal" \
    || { echo "--- log ---"; echo "$LOG"; fail "dynamic test: expected non-literal note, got none"; }
echo "PASS: dynamic non-literal format argument triggers diagnostic note"
