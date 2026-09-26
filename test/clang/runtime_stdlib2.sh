#!/bin/sh
# Red-green runtime test for llvmz80 stdlib bridges fixed in Group C
# klasse 2 batch A: isqrt, unbcd
# (include/stdlib.h __STDC_ABI_ONLY fastcall-gating class).
#
# GREEN: isqrt/unbcd bridges return correct results.
# RED  : isqrt(n) always returned 45 regardless of n; unbcd(n) always
#        returned 0 (both silently read garbage off the stack under
#        llvmz80's default sdcccall(1) register-passing convention).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_stdlib2.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_stdlib2.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"
    fail "build failed"
fi

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | head -1 | tr -d '\r')
EXPECT="stdlib2 i1=12 i2=100 u1=1234 u2=9999 u3=1"

if [ "$OUT" = "$EXPECT" ]; then
    echo "PASS: llvmz80 isqrt/unbcd bridges correct"
else
    echo "FAIL: unexpected output"
    echo "  got:    $OUT"
    echo "  expect: $EXPECT"
    exit 1
fi
