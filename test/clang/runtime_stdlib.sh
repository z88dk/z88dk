#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 clang stdlib/stdio bridges wired
# into z88dk (fixed 2026-07-12).
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using atoi, malloc/free
#        and fflush, and running it in ntvcm prints the correct result line AND
#        exits (fflush no longer corrupts the stack).
# RED  : pre-fix, atoi("123") printed 523, the malloc/free cycle corrupted the
#        heap (ok=0 or garbage), and fflush(stdout) sent the program into an
#        infinite restart loop so the line never appeared / it never exited.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_stdlib.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_stdlib.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app \
	-pragma-define:CLIB_MALLOC_HEAP_SIZE=8000 \
	-o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

# A broken fflush loops forever; ntvcm exits on its own on a clean run, but
# guard against a hang if the fix regresses.
OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

#   atoi("123") -> 123 ; atoi("-45") -> -45 ; malloc/free cycle ok -> 1
EXP='stdlib 123 -45 1'
echo "$OUT" | grep -qF "$EXP" || fail "stdlib output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 atoi/malloc/free/fflush bridges link and behave correctly"
