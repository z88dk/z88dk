#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 f32 FAST-MATH compare bridge
# (libsrc/l/llvmz80/__cmpsf2.asm's ___cmpsf2_fast -> z88dk math32's raw
# m32_compare core, no NaN check). ravn/llvm-z80 #277 follow-up.
#
# GREEN: `zcc +cpm -compiler=llvmz80 -ffast-math` links a program using
#        every ordered float compare predicate (==,!=,<,<=,>,>=) against
#        the __cmpsf2.asm adapter's ___cmpsf2_fast entry point and z88dk's
#        math32 library, and running it in ntvcm prints "ALL PASS".
# RED  : before ___cmpsf2_fast existed in __cmpsf2.asm, this failed to
#        LINK with "undefined symbol: ___cmpsf2_fast" (Z80LegalizerInfo.cpp
#        has emitted this libcall under fast-math since commit 31997a65c57fe,
#        2026-03-12, predating the z88dk-side bridge). A wrong Z/C-to-tri-
#        state translation would instead link fine but print a FAIL line.
#
# See runtime_fcmp.sh for the NaN-checked, non-fast-math sibling test and
# the shared -mllvm -z80-float-sdcccall0 / -lmath32 requirement story.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm LLVMZ80EXE=/path/to/clang ./runtime_fcmp_fast.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fcmp_fast.c"
BRIDGE="$DIR/../../libsrc/l/llvmz80/__cmpsf2.asm"
MATH32_DIR="$DIR/../../libsrc"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -ffast-math -create-app \
	-mllvm -z80-float-sdcccall0 \
	-L"$MATH32_DIR" -lmath32 \
	-o "$WORK/rt" "$BRIDGE" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed (expected if ___cmpsf2_fast is missing from the bridge)"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "ALL PASS" || fail "fast-math compare output wrong. got: [$OUT]"

echo "PASS: llvmz80 f32 fast-math compare bridge (___cmpsf2_fast) links and behaves correctly"
