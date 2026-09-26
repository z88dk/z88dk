#!/bin/sh
# Regression for ravn/llvm-z80#270: va_start/va_arg in user variadic functions.
#
# GREEN: vsum(3,10,20,30)=60; sentinel probe returns 0xBEEF.
# RED  : vsum=1 (reads saved-IX) or garbage (stdarg.h &last+sizeof(last) bug).
#
# Fix: ravn/z88dk bb914a18 defers to __builtin_va_start under __LLVMZ80.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_vaarg.c"

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

echo "$OUT" | grep -qF "PASS va_start/va_arg correct" \
    || fail "va_arg wrong or program failed. got: [$OUT]"

echo "PASS: llvmz80 va_start/va_arg reads correct varargs (ravn/llvm-z80#270 regression)"
