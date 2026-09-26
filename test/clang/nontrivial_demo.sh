#!/bin/sh
# End-to-end runtime test for the ravn/llvm-z80 clang bridges wired into z88dk.
#
# Complements runtime_stdlib.sh with a single non-trivial program that exercises
# recursion, structs, static arrays, memset, sprintf (%s/%d/%ld/%lu), the 32-bit
# multiply/divide/modulo runtime helpers, and strcpy/strlen -- i.e. the integer
# helpers, the string/mem clang bridges, and the fastcall-redirect header
# routing all at once.
#
# GREEN: `zcc +cpm -compiler=llvmz80` links and runs the program in ntvcm and
#        prints both reference lines exactly.
# RED  : with the pre-fix headers (plain stack-ABI symbols reached under
#        __STDC_ABI_ONLY) the string/mem calls read register args off the stack
#        -> garbage output / heap or stack corruption.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./nontrivial_demo.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/nontrivial_demo.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app \
	-o "$WORK/nt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/nt.com" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/nt.com" 2>/dev/null | tr -d '\r')

EXP1='Ada/36 fib(15)=610 primes<200=46 12345*6=74070'
EXP2='div=1003 mod=12 strlen=46'
echo "$OUT" | grep -qF "$EXP1" || fail "line 1 wrong. got: [$OUT] want: [$EXP1]"
echo "$OUT" | grep -qF "$EXP2" || fail "line 2 wrong. got: [$OUT] want: [$EXP2]"

echo "PASS: llvmz80 end-to-end demo (recursion/struct/sieve/sprintf/32-bit/str) correct"
