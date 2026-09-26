#!/bin/sh
# XFAIL: tmpfile() is a deliberate CLASSIC-DESIGN / platform gap on +cpm.
#
# Expected: the program FAILS TO BUILD (tmpfile undeclared in classic stdio.h,
# because CP/M 2.2 has no temp-file primitive -- see xfail_tmpfile.c for the
# rationale).
#
# XFAIL  = build failed as expected (the documented gap holds).
# XPASS  = it built (the gap closed upstream) -> retire this xfail.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/xfail_tmpfile.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

if zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 -create-app -o "$WORK/rt" "$SRC" >"$WORK/build.log" 2>&1; then
    echo "XPASS: tmpfile now builds on +cpm -- gap closed, retire xfail_tmpfile"
else
    reason=$(grep -iE "undeclared|undefined|tmpfile" "$WORK/build.log" | head -1 | sed 's/^[[:space:]]*//')
    echo "XFAIL: tmpfile() absent on classic +cpm (no CP/M temp-file primitive) -- $reason"
fi
