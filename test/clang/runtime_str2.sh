#!/bin/sh
# Red-green runtime test for llvmz80 additional string bridges:
# strstr, strspn, strcspn, strncmp, strncat, strtok, strrchr, strnlen,
# strcasecmp (libsrc/string/c/sccz80/{fn}.asm "Clang bridge" block).
#
# GREEN: all bridges return correct results.
# RED  : with the old `defc ___X = X` stack-ABI aliases every call returns
#        garbage or hangs.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_str2.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_str2.c"

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
EXPECT="str2 ss=6 spn=4 cspn=2 ncmp=0 [foobar] rr=4 nl=3 ci=0 [a][b]"

if [ "$OUT" = "$EXPECT" ]; then
    echo "PASS: llvmz80 strstr/strspn/strcspn/strncmp/strncat/strrchr/strnlen/strcasecmp/strtok bridges correct"
else
    echo "FAIL: unexpected output"
    echo "  got:    $OUT"
    echo "  expect: $EXPECT"
    exit 1
fi
