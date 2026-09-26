#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 clang realloc bridge wired into
# z88dk (fixed 2026-08-04).  Same bug class as runtime_qsort / runtime_bsearch /
# runtime_calloc: clang's __smallc/sdcccall(0) pushes stack args right-to-left
# (first arg on top), but the classic `_callee` asm expects the z88dk
# left-to-right order.
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using realloc, and running
#        it in ntvcm prints "realloc 1 16" -- realloc(NULL,n), grow, shrink and
#        a run of growing reallocs all preserve the stored string.  The map
#        links _realloc_callee and does NOT link ___realloc.
# RED  : pre-fix, realloc fell back to malloc.h's __ZPROTO reversed-arg form and
#        routed to ___realloc (CALLER-linkage, stack-popped args); clang passes
#        (p,size) in registers, so the args were garbage -> old data lost and
#        the program hung at exit.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_realloc.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_realloc.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

fail() { echo "FAIL: $1"; exit 1; }

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app \
	-pragma-define:CLIB_MALLOC_HEAP_SIZE=8000 \
	-o "$WORK/rt" "$SRC" -m >"$WORK/build.log" 2>&1; then
	echo "--- build log ---"; cat "$WORK/build.log"
	fail "zcc build failed"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

# Link-level proof: realloc must route to realloc_callee, not the classic
# CALLER-linkage ___realloc entry.
grep -q "_realloc_callee" "$WORK/rt.map" || fail "realloc_callee not linked"
if grep -q "___realloc" "$WORK/rt.map"; then
	fail "___realloc (the reversed-arg __ZPROTO/CALLER entry) is still linked"
fi

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

EXP='realloc 1 16'
echo "$OUT" | grep -qF "$EXP" || fail "realloc output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 realloc routes to realloc_callee and preserves data across grow/shrink"
