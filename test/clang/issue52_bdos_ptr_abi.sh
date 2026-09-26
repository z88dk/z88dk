#!/bin/sh
# Regression guard for ravn/z88dk#52 (bdos pointer-argument ABI). Complements
# issue20 (integer args). Skips (exit 0) if compiler or emulator unavailable.
#
# Usage: LLVMZ80EXE=<clang> ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./issue52_bdos_ptr_abi.sh
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/issue52_bdos_ptr_abi.c"
command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
zcc +cpm -compiler=llvmz80 --opt-code-size -create-app -o "$WORK/t" "$SRC" \
    >"$WORK/build.log" 2>&1 || { cat "$WORK/build.log"; fail "build failed"; }
[ -f "$WORK/t.com" ] || fail "no .com produced"
OUT=$(perl -e 'alarm shift; exec @ARGV' 12 "$NTVCM" "$WORK/t.com" 2>/dev/null | tr -d '\r' | head -20)
echo "$OUT"
echo "$OUT" | grep -q "PTRARG-OK" || fail "pointer-arg bdos(9,ptr) did not print (func scrambled? #52 regressed)"
echo "$OUT" | grep -q "DONE" || fail "did not reach DONE (warm-boot loop?)"
VER=$(echo "$OUT" | sed -n 's/^VER=//p' | head -1)
[ -n "$VER" ] && [ "$VER" != "0" ] || fail "bdos(12,0) returned $VER (want non-zero version)"
echo "PASS: bdos() correct for integer AND pointer arguments"
