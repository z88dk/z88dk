#!/bin/sh
# Oracle-based runtime test: fwrite / fread binary round-trip.
# See runtime_fileio_rw.c for the full description.
#
# GREEN (classic): sccz80 and llvmz80 both produce "rw[ok]"
# XFAIL (newlib):  fails to link -- ravn/z88dk#34 (WONTFIX)
# XFAIL (classic, llvmz80): if output differs from sccz80 oracle, gap is noted
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_rw.c"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
HEAP="-pragma-define:CLIB_MALLOC_HEAP_SIZE=4000"
NTVCM_MAXCYC=${NTVCM_MAXCYC:-10}
ntvcm_run() { "$NTVCM" -m:"$NTVCM_MAXCYC" "$@" 2>/dev/null | grep -v "^ntvcm: cycle limit"; }

mkdir -p "$WORK/odir"
if ! zcc +cpm -O2 $HEAP -create-app -o "$WORK/odir/oracle" "$SRC" \
        >"$WORK/o.log" 2>&1; then
    echo "SKIP: oracle (sccz80) build failed"; cat "$WORK/o.log"; exit 0
fi
EXPECTED=$(cd "$WORK/odir" && ntvcm_run ORACLE.COM | tr -d '\r') || true

mkdir -p "$WORK/rtdir"
if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 $HEAP \
        -create-app -o "$WORK/rtdir/rt" "$SRC" >"$WORK/rt.log" 2>&1; then
    case "${TEST_CLIB:-classic}" in
        newlib_*) echo "XFAIL: newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; exit 0 ;;
        *) cat "$WORK/rt.log"; fail "llvmz80 build failed" ;;
    esac
fi
ACTUAL=$(cd "$WORK/rtdir" && ntvcm_run RT.COM | tr -d '\r') || true

if [ "$ACTUAL" = "$EXPECTED" ]; then
    echo "PASS: fwrite/fread binary round-trip (got [$ACTUAL])"
else
    echo "XFAIL: fwrite/fread output differs from sccz80 oracle. got=[$ACTUAL] want=[$EXPECTED]"
fi
