#!/bin/sh
# Runtime test: see runtime_quadinit.c.  Verifies that 64-bit (long long)
# GLOBAL initializers keep their high 32 bits through the -compiler=llvmz80
# bridge.  The backend (ravn/llvm-z80 Z80MCAsmInfo, Data64bitsDirective null)
# emits each 64-bit value as two little-endian .long halves that copt lowers to
# DEFQ (4-byte); no .quad reaches the bridge (ravn/z88dk#27).
# Portable across the classic clib and newlib (only long long + printf).
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_quadinit.c"
command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "--- build log ---"; cat "$WORK/build.log"; fail "zcc build failed"
fi
OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')
if printf '%s\n' "$OUT" | grep -q 'QUADINIT-OK'; then
    echo "PASS: runtime_quadinit"
else
    echo "--- program output ---"; printf '%s\n' "$OUT"
    fail "64-bit global initializer truncated (high 32 bits lost) -- ravn/z88dk#27 regressed"
fi
