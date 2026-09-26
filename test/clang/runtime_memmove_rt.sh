#!/bin/sh
# Red-green runtime test for the ___memmove_rt (runtime-unknown-direction
# memmove) bridge.
#
# GREEN: libsrc/l/llvmz80/__memmove_rt.asm correctly adapts clang's
#        Z80_AllReg ___memmove_rt ABI (dst=HL, src=DE, size=BC) to z88dk's
#        existing overlap-safe asm_memmove core (hl=src, de=dst, bc=n) via
#        one `ex de,hl` -- forward-overlap, backward-overlap, and
#        non-overlapping copies all come out byte-correct.
# RED  : bridge missing (link failure) or wrong (corrupted copy).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_memmove_rt.sh
# Skips (exit 0) if the compiler or emulator is not available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_memmove_rt.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK="$DIR/.runtime_memmove_rt_work"
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

EXP='memmove_rt OK'
echo "$OUT" | grep -qF "$EXP" || fail "output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 ___memmove_rt bridge copies correctly (overlap + non-overlap)"
