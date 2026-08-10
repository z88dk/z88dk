#!/bin/sh
# ABSOLUTE-assertion runtime test: fopen("rb+") must allow writing (ravn/z88dk#53).
# See runtime_fileio_rbplus.c for the full description.
#
# NOT an oracle comparison: sccz80 and llvmz80 share classic stdio, so before the
# fix BOTH returned rbplus=0 and a toolchain-diff test would have passed wrongly.
# Here we assert the absolute expected string on BOTH toolchains.
#
# GREEN (classic): both produce "rbplus=128 rplusb=128".
# XFAIL (newlib):  fails to link -- ravn/z88dk#34 (WONTFIX).
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_rbplus.c"
WANT="rbplus=128 rplusb=128"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
HEAP="-pragma-define:CLIB_MALLOC_HEAP_SIZE=4000"
NTVCM_MAXCYC=${NTVCM_MAXCYC:-20}
ntvcm_run() { "$NTVCM" -m:"$NTVCM_MAXCYC" "$@" 2>/dev/null | grep -v "^ntvcm: cycle limit"; }

# sccz80 (shares classic stdio -- also exercises the fix)
mkdir -p "$WORK/odir"
if ! zcc +cpm -O2 $HEAP -create-app -o "$WORK/odir/oracle" "$SRC" \
        >"$WORK/o.log" 2>&1; then
    echo "SKIP: sccz80 build failed"; cat "$WORK/o.log"; exit 0
fi
SCCZ80=$(cd "$WORK/odir" && rm -f M.DAT && ntvcm_run oracle.com | tr -d '\r') || true

# llvmz80
mkdir -p "$WORK/rtdir"
if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2 $HEAP \
        -create-app -o "$WORK/rtdir/rt" "$SRC" >"$WORK/rt.log" 2>&1; then
    case "${TEST_CLIB:-classic}" in
        newlib_*) echo "XFAIL: newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; exit 0 ;;
        *) cat "$WORK/rt.log"; fail "llvmz80 build failed" ;;
    esac
fi
LLVMZ80=$(cd "$WORK/rtdir" && rm -f M.DAT && ntvcm_run rt.com | tr -d '\r') || true

[ "$SCCZ80" = "$WANT" ]  || fail "sccz80 got [$SCCZ80] want [$WANT]"
[ "$LLVMZ80" = "$WANT" ] || fail "llvmz80 got [$LLVMZ80] want [$WANT]"
echo "PASS: rb+/r+b mode-string both writable (got [$LLVMZ80])"
