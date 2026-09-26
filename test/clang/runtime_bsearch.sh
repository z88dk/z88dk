#!/bin/sh
# Regression for standard 5-arg bsearch() under llvmz80 (was xfail_bsearch).
#
# GREEN: every present key is found (hits == 16) and every absent key returns
#        NULL (misses == 5) -> "bsearch 16 5 OK".
# RED  : build failure, or a scrambled comparator/arg-order -> wrong counts.
#
# Fix: <stdlib.h> reversed-arg alias __bsearch_llvmz80 -> _bsearch, __smallc
# comparator via l_cmp_sdcc (ravn/z88dk 2026-07-24; upstream _bsearch merge).
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_bsearch.c"

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

OUT=$("$NTVCM" "$WORK/RT.COM" 2>/dev/null | tr -d '\r')

echo "$OUT" | grep -qF "bsearch 16 5 OK" \
    || fail "bsearch wrong result. got: [$OUT]"

echo "PASS: standard 5-arg bsearch finds all keys and rejects absent ones"
