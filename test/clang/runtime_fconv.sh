#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 int<->f32 conversion bridges
# (libsrc/l/llvmz80/__floatsisf.asm -> z88dk math32), ravn/llvm-z80 #277.
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using int<->float
#        conversions (clang's double==float32 config lowers these to
#        __fixsfsi/__fixunssfsi/__floatsisf/__floatunsisf), against the
#        __floatsisf.asm alias bridge and z88dk's math32 library, and running
#        it in ntvcm prints "ALL PASS" -- including signed/unsigned and
#        boundary (0, negative, INT16_MIN/MAX, 0xFFFF) cases.
# RED  : a wrong bridge (e.g. aliasing the 16-bit cm32_sdcc___sint2fs instead
#        of the 32-bit cm32_sdcc___slong2fs) makes one or more `chk*()` calls
#        in runtime_fconv.c print `FAIL <name>: got ... want ...` instead.
#
# See runtime_float.sh for the shared -mllvm -z80-float-sdcccall0 / -lmath32
# requirement story (identical here).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm LLVMZ80EXE=/path/to/clang ./runtime_fconv.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fconv.c"
BRIDGE="$DIR/../../libsrc/l/llvmz80/__floatsisf.asm"
MATH32_DIR="$DIR/../../libsrc"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app \
	-mllvm -z80-float-sdcccall0 \
	-L"$MATH32_DIR" -lmath32 \
	-o "$WORK/rt" "$BRIDGE" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "ALL PASS" || fail "conversion output wrong. got: [$OUT]"

echo "PASS: llvmz80 int<->f32 conversion bridges link and behave correctly"
