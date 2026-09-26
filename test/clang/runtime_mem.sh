#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 clang mem* bridges wired into
# z88dk (libsrc/string/c/sccz80/mem{set,cpy,move}.asm, "Clang bridge" block).
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using memset/memcpy/
#        memmove (backend emits reversed-arg __memset/__memcpy/__memmove) and
#        running it in ntvcm prints the correct results, including the
#        returned destination pointer.
# RED  : with the old `defc ___memset = memset` stack-ABI alias the program
#        hangs / prints garbage (wrong-ABI: the worker read a garbage count
#        and ran LDIR over 64 KB).  The exact-match check below catches it.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_mem.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_mem.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

# ntvcm can hang if the mem* ABI is wrong; bound it.
OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

#   memset(a,'X',7)                 -> "XXXXXXX", ret==a  -> 1
#   memcpy(dst,"ABCDEFG",7)         -> "ABCDEFG", ret==dst-> 1
#   memmove(b+3,b,4) on "0123456789"-> "012012378"
EXP='mem [XXXXXXX] 1 [ABCDEFG] 1 [012012378]'
echo "$OUT" | grep -qF "$EXP" || fail "mem* output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 memset/memcpy/memmove bridges link and behave correctly"
