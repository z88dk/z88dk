#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 32-bit float bridges
# (libsrc/l/llvmz80/__addsf3.asm -> z88dk math32), ravn/llvm-z80 #277.
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using float add/sub/
#        mul/div (clang's double==float32 config lowers these to __addsf3/
#        __subsf3/__mulsf3/__divsf3), against the __addsf3.asm alias bridge
#        and z88dk's math32 library, and running it in ntvcm prints
#        "ALL PASS" -- including the order-sensitive sub/div cases that would
#        catch an operand-order bug in the bridge (a-b confused with b-a, or
#        a/b with b/a).
# RED  : a wrong bridge (wrong calling convention assumption, or an operand-
#        order bug) makes one or more `chk()` calls in runtime_float.c print
#        `FAIL <name>: got <bits> want <bits>` instead.
#
# This test needs `-lmath32` (z88dk's math32 IEEE-754 binary32 library) added
# explicitly at link time, since it is not part of the default classic clib
# link set. It also needs `-mllvm -z80-float-sdcccall0` (the compiler-side
# switch to CallingConv::Z80_SDCCCall0 for the f32 arithmetic libcalls is
# gated behind this opt-in flag, default OFF, because the ELF/standalone
# `--target=z80` path's own compiler-rt float runtime expects the default C
# ABI -- see llvm/test/CodeGen/Z80/issue-277-f32-libcall-sdcccall0.ll in
# llvm-z80). Without the flag, this bridge (a pure alias, no glue code) will
# link but will NOT compute the right answers -- every case in
# runtime_float.c fails with garbage bit patterns.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_float.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_float.c"
BRIDGE="$DIR/../../libsrc/l/llvmz80/__addsf3.asm"
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

echo "$OUT" | grep -qF "ALL PASS" || fail "float output wrong. got: [$OUT]"

echo "PASS: llvmz80 f32 add/sub/mul/div bridges link and behave correctly"
