#!/bin/sh
# Red-green runtime test for the llvmz80 stdlib bridge fixed in Group C
# klasse 2 batch B: srand
# (include/stdlib.h __STDC_ABI_ONLY fastcall-gating class).
#
# GREEN: srand(seed) then rand() matches srand_fastcall(seed) then rand()
#        for the same seed.
# RED  : the plain srand() entry read garbage off the stack instead of
#        the register-passed seed, so the two rand() streams diverged.
#
# (inp/sleep/msleep are the same bug class, fixed in the same commit, but
# are not empirically testable under ntvcm -- see runtime_stdlib3.c for
# why -- their fix was verified via clang -S assembly inspection instead.)
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_stdlib3.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_stdlib3.c"

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

case "$OUT" in
    "stdlib3 srand_plain="*" srand_fastcall="*" match=1")
        echo "PASS: llvmz80 srand bridge correct (got: $OUT)"
        ;;
    *)
        echo "FAIL: unexpected output"
        echo "  got:    $OUT"
        echo "  expect: stdlib3 srand_plain=N srand_fastcall=N match=1 (same N)"
        exit 1
        ;;
esac
