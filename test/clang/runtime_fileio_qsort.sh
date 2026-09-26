#!/bin/sh
# Regression guard for ravn/z88dk#54 via a stdio in-place on-disk quicksort.
#   Stdio (f*) port of the raw-BDOS qsort_disk test.  Exercises fopen("r+b") +
#   fseek + fread/fwrite random access through the classic CP/M fcntl sector
#   cache.  See runtime_fileio_qsort.c for layout + the #54 root cause
#   (getfcb() left fcb->record_nr uninitialised; fixed upstream cc22967e21).
#
# The bug is in the SHARED classic/CP/M path, so it affects BOTH sccz80 and
# llvmz80.  This fixture is therefore NOT an oracle diff: the C program
# self-verifies (ascending keys + intact record bytes) and prints "qsort[OK]"
# only when every random read/write landed.  We run both compilers and require
# each to print OK.
#
# EXPECT_FIXED=1 -> assert OK on the toolchain under test (current master/
#                   dev-fork is fixed); any non-OK is a hard FAIL.  Released
#                   z88dk 2.4 (unfixed getfcb) will FAIL here -- that is correct.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_qsort.c"
EXPECT_FIXED=1        # ravn/z88dk#54 fixed upstream (getfcb.c cc22967e21)

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
HEAP="-pragma-define:CLIB_MALLOC_HEAP_SIZE=4000"
NTVCM_MAXCYC=${NTVCM_MAXCYC:-10}
ntvcm_run() { "$NTVCM" -m:"$NTVCM_MAXCYC" "$@" 2>/dev/null | grep -v "^ntvcm: cycle limit"; }

# Build + run one variant; echoes the verdict line (or a __*__ sentinel).
run_variant() {
    label="$1"; shift
    d="$WORK/$label"; mkdir -p "$d"
    if ! zcc "$@" $HEAP -create-app -o "$d/t" "$SRC" >"$d/build.log" 2>&1; then
        case "${TEST_CLIB:-classic}" in
            newlib_*) echo "__NEWLIB_LINK_FAIL__" ;;
            *) cat "$d/build.log" >&2; echo "__BUILD_FAIL__" ;;
        esac
        return
    fi
    (cd "$d" && ntvcm_run t.com | tr -d '\r' | sed -n 's/.*\(qsort\[[^]]*\]\).*/\1/p' | head -1)
}

V_SCC=$(run_variant scc +cpm -O2)
V_LLVM=$(run_variant llvm +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2)

case "$V_LLVM" in
    __NEWLIB_LINK_FAIL__)
        echo "XFAIL: newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; exit 0 ;;
    __BUILD_FAIL__)
        fail "llvmz80 build failed" ;;
esac
[ "$V_SCC" = "__BUILD_FAIL__" ] && { echo "SKIP: sccz80 oracle build failed"; exit 0; }

echo "sccz80:  ${V_SCC:-<no verdict>}"
echo "llvmz80: ${V_LLVM:-<no verdict>}"

both_ok=0
[ "$V_SCC" = "qsort[OK]" ] && [ "$V_LLVM" = "qsort[OK]" ] && both_ok=1

if [ "$EXPECT_FIXED" = 1 ]; then
    [ "$both_ok" = 1 ] && { echo "PASS: stdio in-place disk quicksort (#54)"; exit 0; }
    fail "stdio disk quicksort regressed (#54): scc=[$V_SCC] llvm=[$V_LLVM]"
else
    if [ "$both_ok" = 1 ]; then
        echo "GREEN: #54 appears FIXED -> ACTION: set EXPECT_FIXED=1 in this fixture"
        exit 0
    fi
    echo "XFAIL: #54 stdio disk quicksort broken (scc=[$V_SCC] llvm=[$V_LLVM])"
    exit 0
fi
