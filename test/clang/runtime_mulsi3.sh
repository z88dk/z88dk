#!/bin/sh
# Red-green runtime test for the ___mulsi3 (32-bit long multiply) bridge.
#
# GREEN: libsrc/l/llvmz80/__mulsi3.asm correctly adapts clang's __mulsi3 ABI
#        (one 32-bit operand in HL:DE, the other on the stack, IX preserved)
#        to z88dk's l_mulu_32_32x32 core (DE:HL layout) -- every 32-bit
#        product below comes out exactly right.
# RED  : bridge missing (link failure) or wrong (garbage/truncated products).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_mulsi3.sh
# Skips (exit 0) if the compiler or emulator is not available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_mulsi3.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK="$DIR/.runtime_mulsi3_work"
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

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

EXP='mulsi3 OK'
echo "$OUT" | grep -qF "$EXP" || fail "output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 __mulsi3 bridge computes correct 32-bit products"
