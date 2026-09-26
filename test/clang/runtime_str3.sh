#!/bin/sh
# Red-green runtime test for llvmz80 string bridges fixed in Group C
# klasse 1: stricmp, strrstr, strlcpy
# (libsrc/string/c/sccz80/{stricmp,strrstr,strlcpy}.asm "Clang bridge" block).
#
# GREEN: all bridges return correct results.
# RED  : stricmp had a copy-paste typo (called the stack-based
#        `strcasecmp` entry instead of `asm_strcasecmp`); strrstr/strlcpy
#        still had the old broken `defc ___X = X` stack-ABI alias.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_str3.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_str3.c"

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
EXPECT="str3 si=0 rs=4 rsnf=-1 [hello] r1=5 [he] r2=5"

if [ "$OUT" = "$EXPECT" ]; then
    echo "PASS: llvmz80 stricmp/strrstr/strlcpy bridges correct"
else
    echo "FAIL: unexpected output"
    echo "  got:    $OUT"
    echo "  expect: $EXPECT"
    exit 1
fi
