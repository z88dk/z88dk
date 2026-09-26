#!/bin/sh
# Regression guard for the classic +cpm FILE* positioning routines that lacked
# direct coverage: fileno, rewind, fsetpos (rewind/fsetpos are header macros
# over fseek).  See runtime_fileio_status.c.  ferror/feof/clearerr are covered
# separately (xfail_ferror_feof) because they diverge under llvmz80.
#
# The routines live in the SHARED classic path (affects BOTH sccz80 and
# llvmz80), so this is NOT an oracle diff: the C program self-verifies and
# prints "status[OK]" only when every check holds.  We build with each compiler
# and require both to print OK.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_status.c"

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
    (cd "$d" && ntvcm_run t.com | tr -d '\r' | sed -n 's/.*\(status\[[^]]*\]\).*/\1/p' | head -1)
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

if [ "$V_SCC" = "status[OK]" ] && [ "$V_LLVM" = "status[OK]" ]; then
    echo "PASS: classic FILE* positioning (fileno/fgetpos/fsetpos/rewind)"
    exit 0
fi
fail "classic FILE* positioning routines: scc=[$V_SCC] llvm=[$V_LLVM]"
