#!/bin/sh
# Regression test for ravn/z88dk#31: variadic stdio return values (printf,
# sprintf, snprintf, sscanf) were garbage under llvmz80 because __vasmallc
# expanded to empty -> clang read return value from DE instead of HL.
#
# GREEN: all four functions return the documented count/match-count.
# RED  : pre-fix, printf returned -332, sscanf returned -362, etc.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_printf_ret.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_printf_ret.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"
    fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "PASS printf/sprintf/snprintf/sscanf return values correct" \
    || fail "return values wrong or program failed. got: [$OUT]"

echo "PASS: llvmz80 printf/sprintf/snprintf/sscanf return values correct (ravn/z88dk#31 regression)"
