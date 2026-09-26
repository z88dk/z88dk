#!/bin/sh
# Red-green runtime test for qsort with a clang/llvmz80 comparator.
#
# GREEN: a comparator declared __smallc (== sdcccall(0)) is compiled to read
#        its two arguments from the stack and return the int result in HL --
#        exactly the protocol qsort_sdcc_callee uses when it invokes the
#        comparator.  The array sorts correctly (ascending and descending).
# RED  : a DEFAULT (unannotated) comparator takes a in HL, b in DE and returns
#        in DE; qsort_sdcc feeds it stack args and reads HL -> the sort
#        scrambles the array instead of ordering it.
#
# This validates the z88dk maintainer's "annotate the callback" approach: no
# runtime trampoline or global state, fully reentrant.  See runtime_qsort.c.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_qsort.sh
# Skips (exit 0) if the compiler or emulator is not available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_qsort.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O1 -create-app \
	-o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

EXP='qsort 200 5 991 OK'
echo "$OUT" | grep -qF "$EXP" || fail "output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 qsort sorts correctly with an __smallc comparator"
