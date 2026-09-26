#!/bin/sh
# Red-green runtime test for llvmz80 string bridges fixed in Group C
# klasse 2 batch C: strrspn, strrcspn
# (libsrc/string/c/sccz80/{strrspn,strrcspn}.asm "Clang bridge" block).
#
# GREEN: strrspn/strrcspn bridges return correct results.
# RED  : both still had the old broken `defc ___X = X` stack-ABI alias,
#        returning 512 regardless of input.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_str4.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_str4.c"

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
EXPECT="str4 rsp=4 rcsp=9"

if [ "$OUT" = "$EXPECT" ]; then
    echo "PASS: llvmz80 strrspn/strrcspn bridges correct"
else
    echo "FAIL: unexpected output"
    echo "  got:    $OUT"
    echo "  expect: $EXPECT"
    exit 1
fi
