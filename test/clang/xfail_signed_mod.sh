#!/bin/sh
# XFAIL: z88dk newlib 16-bit signed-modulo sign bug (stale prebuilt library).
# See xfail_signed_mod.c for the full evidence table and root cause.
#
#   PASS  = -30000 % 7 == -5   (C-correct; the classic clib path)
#   XFAIL = -30000 % 7 == +5   (matches stock z88dk newlib -- known stale-lib
#                               bug; acceptance = parity with z88dk for now)
#   FAIL  = build failed, or any other value (clang diverged from BOTH the C
#           result AND z88dk's newlib result -- a real regression to chase)
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/xfail_signed_mod.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "FAIL: build failed -- $(grep -iE 'error|undefined' "$WORK/build.log" | head -1)"
    exit 0
fi

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')
val=$(printf '%s\n' "$OUT" | sed -n 's/^s16mod=//p')

case "$val" in
    -5) echo "PASS: -30000 %  7 == -5 (C-correct signed modulo)" ;;
    5)  echo "XFAIL: -30000 %  7 == +5 -- z88dk newlib stale-lib signed-mod bug (matches stock sccz80/sdcc; source fixed upstream af5630797c, prebuilt libs not regenerated)" ;;
    *)  echo "FAIL: -30000 %  7 == '$val' (expected -5 or the z88dk-newlib +5); OUT=[$OUT]" ;;
esac
