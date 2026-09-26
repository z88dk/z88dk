#!/bin/sh
# Red-green regression test for the __z88dk_fastcall 16-bit contract under clang.
#
# GREEN: clang places a single 16-bit argument in HL (== z88dk_fastcall i16),
#        which is what makes the __z88dk_fastcall no-op in sys/compiler.h safe
#        for 16-bit arguments.
# RED  : if clang emitted the argument anywhere else (e.g. in A/DE), the no-op
#        would silently miscompile every clib fastcall call.  We prove the test
#        can fail by also checking that the *wrong* expectation (arg in A, the
#        8-bit-mismatch register) does NOT appear -- if it did, we'd catch it.
#
# Usage: LLVMZ80EXE=/path/to/clang ./fastcall_abi_16.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
CLANG=${LLVMZ80EXE:?set LLVMZ80EXE to the ravn/llvm-z80 clang binary}
SRC="$DIR/fastcall_abi_16.c"

ASM=$("$CLANG" --target=z80 -S -O2 "$SRC" -o - 2>/dev/null)

fail() { echo "FAIL: $1"; echo "--- emitted asm ---"; echo "$ASM"; exit 1; }

# GREEN assertion: the 16-bit argument 0x1234 == 4660 must be loaded into HL.
echo "$ASM" | grep -qiE 'ld[[:space:]]+hl,[[:space:]]*(4660|0x1234|\$1234)' \
	|| fail "clang did not place the 16-bit fastcall argument in HL (i16 convention drifted -> __z88dk_fastcall no-op is UNSAFE)"

# RED guard: the argument must NOT go into A alone (that is the 8-bit mismatch
# register).  A bare 'ld a,0x34' style load of the low byte would mean clang
# switched to a byte convention.
if echo "$ASM" | grep -qiE 'ld[[:space:]]+a,[[:space:]]*(52|0x34|18|0x12)[^0-9a-fx]'; then
	fail "clang loaded the argument into A (byte convention) -- fastcall i16 contract broken"
fi

echo "PASS: clang places a single 16-bit argument in HL (z88dk_fastcall i16 contract holds)"
