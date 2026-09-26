#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 transcendental libm routing
# (include/math/math_math32.h fastcall routing now enabled for llvmz80/z80).
#
# GREEN: `zcc +cpm -compiler=llvmz80 --math32` links a program using
#        exp/log/sin/cos/atan/sqrt (clang's double==float32); the header routes
#        them to the register-ABI _m32_*f cores via z80_fastcall, and running it
#        in ntvcm prints "ALL PASS".
# RED  : with the header routing gated off (clang defines __STDC_ABI_ONLY),
#        clang's register call hits the plain stack wrappers, so exp/log/sin/cos/
#        atan return 0 and each chk() prints "FAIL <name> ...".
#
# Needs --math32 (z88dk math32 f32 libm) plus the explicit #277 arithmetic
# bridges and -mllvm -z80-float-sdcccall0, exactly like runtime_float.sh.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_libm.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_libm.c"
L="$DIR/../../libsrc/l/llvmz80"
MATH32_DIR="$DIR/../../libsrc"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O3 -create-app \
	-mllvm -z80-float-sdcccall0 -Cg-mdouble=32 --math32 -L"$MATH32_DIR" \
	"$L/__addsf3.asm" "$L/__cmpsf2.asm" "$L/__floatsisf.asm" \
	-o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "ALL PASS" || fail "libm output wrong. got: [$OUT]"

echo "PASS: llvmz80 exp/log/sin/cos/atan bridges link and behave correctly"
