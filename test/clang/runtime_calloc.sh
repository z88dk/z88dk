#!/bin/sh
# Red-green runtime test for the ravn/llvm-z80 clang calloc bridge wired into
# z88dk (fixed 2026-07-14).
#
# GREEN: `zcc +cpm -compiler=llvmz80` links a program using calloc, and running
#        it in ntvcm prints "calloc 0 42" -- the 5 cells read back as zero
#        (calloc zero-initialised) and cell 2 holds the value written.  The map
#        links _calloc_callee and does NOT link ___calloc.
# RED  : pre-fix, calloc fell back to malloc.h's __ZPROTO2 form and routed to
#        the __calloc.asm bridge, so _calloc_callee was NOT linked (___calloc
#        was linked instead) and the link-level assertions below fail.  Without
#        a heap pragma the __calloc bridge additionally failed to link at all
#        ("undefined symbol: _heap", the raw heap it referenced).
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./runtime_calloc.sh
# Skips (exit 0) if neither the compiler nor the emulator is available.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_calloc.c"

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
	fail "zcc build failed (pre-fix: undefined symbol: _heap from __calloc.asm)"
fi
[ -f "$WORK/RT.COM" ] || fail "no .com produced"

# Link-level proof: calloc must route to calloc_callee, not the __calloc bridge.
grep -q "_calloc_callee" "$WORK/rt.map" || fail "calloc_callee not linked"
if grep -q "___calloc" "$WORK/rt.map"; then
	fail "___calloc (the removed __calloc.asm bridge) is still linked"
fi

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

# 5 zeroed ints sum to 0; cell 2 written = 42.
EXP='calloc 0 42'
echo "$OUT" | grep -qF "$EXP" || fail "calloc output wrong. got: [$OUT] want: [$EXP]"

echo "PASS: llvmz80 calloc routes to calloc_callee, zero-inits and behaves correctly"
