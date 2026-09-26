#!/bin/sh
# Test that large arrays and strings (>500 chars / 2048 bytes) compile and run
# correctly under -compiler=llvmz80 without overflowing copt/z80asm buffers.

set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_large_array.c"

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

EXP='large_array ok=1'
echo "$OUT" | grep -qF "$EXP" || fail "large array test failed. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 compiles large byte array and long string correctly"
