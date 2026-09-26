#!/bin/sh
# Regression for strerror() under llvmz80.
#
# GREEN: links without "undefined symbol: __rodata_error_strings_head"; returns
#        non-empty strings for EINVAL, ENOMEM, errnum=0, and unknown errnum.
# RED  : link error OR empty strings (table missing / wrong section).
#
# Fix: libsrc/l/llvmz80/__strerror_table.asm (ravn/z88dk 2026-07-21)
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_strerror.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"
    fail "zcc build failed (likely undefined __rodata_error_strings_head)"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "PASS strerror links and returns non-empty strings" \
    || fail "strerror failed. got: [$OUT]"

echo "PASS: strerror() links and returns non-empty strings (ravn/z88dk __strerror_table)"
