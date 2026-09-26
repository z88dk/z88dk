#!/bin/sh
# Regression test for itoa/ltoa/ultoa bridges under ravn/llvm-z80 + z88dk.
#
# GREEN: itoa(42,buf,10)="42", ltoa(100000L,buf,10)="100000",
#        ultoa(65535UL,buf,10)="65535", ultoa(10UL,buf,2)="1010"
# RED  : empty buffer or wrong value (ZPROTO3 arg reversal not applied)
#
# Bridge: libsrc/l/llvmz80/__itoa.asm (ravn/z88dk 2026-07-21)
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_itoa.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_itoa.c"

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

echo "$OUT" | grep -qF "PASS itoa/ltoa/ultoa bridges correct" \
    || fail "itoa/ltoa/ultoa wrong. got: [$OUT]"

echo "PASS: llvmz80 itoa/ltoa/ultoa bridges link and compute correctly (ravn/z88dk __ZPROTO3)"
