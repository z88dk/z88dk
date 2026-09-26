#!/bin/sh
# Red-green runtime test for strtol/strtoul/strncmp bridges (llvmz80).
#
# GREEN: strtol/strtoul return correct values; strncmp correctly distinguishes
#        equal and unequal strings.
# RED  : pre-fix, strtol("99",&end,10) returned 6488064 (sccz80/llvmz80 32-bit
#        return convention mismatch); strncmp("abc","abd",3) returned -205
#        (wrong register order).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_strtol.sh
# Skips (exit 0) if the compiler or emulator is not available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_strtol.c"

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

EXP='strtol 99 255 -42 65535 0 1 1 0'
echo "$OUT" | grep -qF "$EXP" || fail "output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 strtol/strtoul/strncmp bridges return correct values"
