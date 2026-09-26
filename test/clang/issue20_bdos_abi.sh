#!/bin/sh
# Regression guard for ravn/z88dk#20 (bdos register-vs-stack ABI). GREEN.
#
# Usage: ZCCCFG=<z88dk>/lib/config PATH=<z88dk>/bin:$PATH \
#        NTVCM=/path/to/ntvcm ./issue20_bdos_abi.sh
# Skips (exit 0) if compiler or emulator is unavailable.
#
# NOTE: macOS has no timeout(1); a warm-boot loop (the RED symptom) would hang
# forever, so the run is wrapped in a perl alarm exec (12 s).
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/issue20_bdos_abi.c"

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

echo "$OUT" | grep -q "DONE" || fail "did not reach DONE (warm-boot loop? #20 regressed)"
VER=$(echo "$OUT" | sed -n 's/^VER=0x//p' | head -1)
[ -n "$VER" ] && [ "$VER" != "00" ] || fail "bdos(12,0) returned 0x$VER (want non-zero version)"
echo "PASS: issue20_bdos_abi (VER=0x$VER)"
