#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 clang str*/mem* bridges wired
# into z88dk (libsrc/string/c/sccz80/{strcpy,strcmp,strcat,strchr,strncpy,
# memcmp,memchr}.asm, "Clang bridge" block).
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using these seven
#        helpers (backend emits reversed-arg __X, register ABI) and running
#        it in ntvcm prints the correct results, including returned pointers.
# RED  : with the old `defc ___X = X` stack-ABI aliases the program hangs /
#        prints garbage (wrong-ABI: workers read the stack instead of HL/DE).
#        The exact-match check below catches it.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_str.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_str.c"

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

# ntvcm can hang if a bridge ABI is wrong; the exact match below catches it.
OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

#   strcpy(b,"Hello"); strcat(b,"!")   -> "Hello!", both rets == b -> 1 1
#   strncpy(nb,"XYZ",3) into "......."  -> "XYZ....", ret == nb   -> 1
#   strcmp eq/lt/gt                     -> 0 1 1                   -> 011
#   strchr('l' in "hello")              -> index 2
#   memchr('l' in "hello",5)            -> index 2
#   memcmp("abcd","abce",4) < 0         -> 1
#   strlen(b) where b == "Hello!"       -> 6
#   strupr/strlwr/strrev/strstrip/strrstrip (fastcall-redirect class) works
EXP='str [Hello!] 1 1 [XYZ....] 1 011 2 2 1 6 [ABCD][abcd][dcba][hi  ][hey]'
echo "$OUT" | grep -qF "$EXP" || fail "str* output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 strcpy/strcmp/strcat/strchr/strncpy/memcmp/memchr +strlen +fastcall-class bridges link and behave correctly"
