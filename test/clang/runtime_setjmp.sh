#!/bin/sh
# Red-green runtime test for setjmp/longjmp under llvmz80 classic clib.
#
# GREEN: include/setjmp.h declares l_setjmp/l_longjmp __smallc (matching the
#        stack-args/HL-return convention actually implemented by
#        libsrc/setjmp/c/l_setjmp.asm and l_longjmp.asm), so setjmp() returns
#        0 on the direct call and the value passed to longjmp() on the
#        resumed call.
# RED  : without __smallc, llvmz80's default sdcccall(1) convention reads the
#        return value from DE (garbage; the asm places it in HL) -- setjmp()
#        appears non-zero on the direct call, so `if (setjmp(jb) == 0)`
#        always takes the else branch and longjmp() never runs. This is the
#        root cause of the "(in setup)" failures across ~18 upstream
#        test/suites (test/framework/test.c dispatches every test through
#        exactly this setjmp idiom).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_setjmp.sh
# Skips (exit 0) if the compiler or emulator is not available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_setjmp.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK="$DIR/.runtime_setjmp_work"
rm -rf "$WORK"
mkdir -p "$WORK"
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O1 -create-app \
	-o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" -m:80 "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "A_SETJMP0" || fail "setjmp() did not return 0 on direct call. got: [$OUT]"
echo "$OUT" | grep -qF "B_AFTER_LONGJMP stage=1 rv=7 vloc=111" || fail "longjmp() did not resume correctly (expected stage=1 rv=7 vloc=111). got: [$OUT]"
echo "$OUT" | grep -qF "C_DONE" || fail "control flow did not reach after the if/else. got: [$OUT]"
echo "$OUT" | grep -qF "UNREACHABLE" && fail "longjmp() did not actually jump (fell through). got: [$OUT]"

echo "PASS: llvmz80 setjmp/longjmp round-trip correct"
