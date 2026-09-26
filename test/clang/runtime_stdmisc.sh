#!/bin/sh
# Red-green runtime test for the llvmz80 misc-number (abs/labs/rand) + ctype
# bridges in z88dk.
#
# GREEN: abs/labs route to abs_fastcall/labs_fastcall (register ABI) and return
#        correct values; ctype predicates and toupper/tolower behave.
# RED  : without the `#elif defined(__LLVMZ80)` fastcall routing in <stdlib.h>,
#        clang calls the __smallc (stack ABI) abs/labs with the arg in HL ->
#        abs(-42) returned 1199 etc.  The exact-match check below catches it.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_stdmisc.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_stdmisc.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O1 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

EXP='abs 42 7 0
labs 99 123456
rand 1
ct 111111
nct 000
cv Az5'
[ "$OUT" = "$EXP" ] || fail "stdmisc output wrong.
got:
$OUT
want:
$EXP"

echo "PASS: llvmz80 abs/labs (register-ABI) + rand + ctype bridges behave correctly"
