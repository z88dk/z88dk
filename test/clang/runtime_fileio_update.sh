#!/bin/sh
# Regression guard for ravn/z88dk#54:
#   classic +cpm stdio: the FIRST read after fopen (no preceding fseek) must
#   return the file's data, not an EOF fill.  See runtime_fileio_update.c for
#   the confirmed root cause (getfcb() left fcb->record_nr uninitialised;
#   fixed upstream in getfcb.c commit cc22967e21).
#
# The bug is in the SHARED classic/CP/M path, so it affects BOTH sccz80 and
# llvmz80.  This fixture is therefore NOT an oracle diff: the C program
# self-verifies against hard-coded expected bytes and prints "update[PASS]"
# only when the seekless read returns the real data.  We run both compilers and
# require each to print PASS.
#
# EXPECT_FIXED=1 -> assert PASS on the toolchain under test (current
#                   master/dev-fork is fixed); any non-PASS is a hard FAIL.
#                   Released z88dk 2.4 (unfixed getfcb) will FAIL here -- that is
#                   correct: it flags the released-lib regression.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_update.c"
EXPECT_FIXED=1        # ravn/z88dk#54 fixed upstream (getfcb.c cc22967e21)

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }
HEAP="-pragma-define:CLIB_MALLOC_HEAP_SIZE=4000"
NTVCM_MAXCYC=${NTVCM_MAXCYC:-10}
ntvcm_run() { "$NTVCM" -m:"$NTVCM_MAXCYC" "$@" 2>/dev/null | grep -v "^ntvcm: cycle limit"; }

# Build + run one variant; echoes the verdict line (or empty on build skip).
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
    (cd "$d" && ntvcm_run t.com | tr -d '\r' | sed -n 's/.*\(update\[[^]]*\]\).*/\1/p' | head -1)
}

# --- sccz80 (classic) oracle-compiler run ---
V_SCC=$(run_variant scc +cpm -O2)
# --- llvmz80 run (shares the same classic lib) ---
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

both_pass=0
[ "$V_SCC" = "update[PASS]" ] && [ "$V_LLVM" = "update[PASS]" ] && both_pass=1

if [ "$EXPECT_FIXED" = 1 ]; then
    [ "$both_pass" = 1 ] && { echo "PASS: in-place random write-back persists (#54)"; exit 0; }
    fail "in-place write-back regressed (#54): scc=[$V_SCC] llvm=[$V_LLVM]"
else
    if [ "$both_pass" = 1 ]; then
        echo "GREEN: #54 appears FIXED -> ACTION: set EXPECT_FIXED=1 in this fixture"
        exit 0
    fi
    echo "XFAIL: #54 in-place random write-back broken (scc=[$V_SCC] llvm=[$V_LLVM])"
    exit 0
fi
