#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 f32 compare bridges
# (libsrc/l/llvmz80/__cmpsf2.asm -> z88dk math32's raw m32_compare core).
# ravn/llvm-z80 #277.
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using every ordered/
#        unordered float compare predicate (==,!=,<,<=,>,>=, plus
#        __builtin_islessgreater/isunordered) against the __cmpsf2.asm
#        adapter and z88dk's math32 library, and running it in ntvcm prints
#        "ALL PASS" -- including NaN operands in both positions, which the
#        adapter must detect itself since m32_compare has no NaN awareness.
# RED  : a wrong NaN short-circuit, a wrong Z/C-to-tri-state translation, or
#        a wrong stack-offset assumption for the two operands makes one or
#        more `chk()` calls in runtime_fcmp.c print `FAIL <name>: got X
#        want Y` instead.
#
# See runtime_float.sh for the shared -mllvm -z80-float-sdcccall0 / -lmath32
# requirement story (identical here).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm LLVMZ80EXE=/path/to/clang ./runtime_fcmp.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fcmp.c"
BRIDGE="$DIR/../../libsrc/l/llvmz80/__cmpsf2.asm"
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

echo "$OUT" | grep -qF "ALL PASS" || fail "compare output wrong. got: [$OUT]"

echo "PASS: llvmz80 f32 compare bridges link and behave correctly"
