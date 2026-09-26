#!/bin/sh
# ferror()/feof() on classic +cpm must return the SAME answer under sccz80 and
# llvmz80.  Oracle diff over the whole ferror/feof contract (fresh / mid-file /
# true EOF / after clearerr); sccz80 defines the correct answer for each state
# and llvmz80 must match it.  The classic oracle is
#   f_fresh=0 r_fresh=0 f_mid=0 r_mid=0 f_eof=1 r_eof=0 f_clr=1 r_clr=0
# (note f_clr=1: clearerr is a no-op macro on classic +cpm, so feof stays set).
#
# Regression guard for the fixed llvmz80 divergence: plain int ferror/feof(FILE*)
# decls used to bypass the __z88dk_fastcall bridge under __STDC_ABI_ONLY, so
# clang tail-called the stack-arg _ferror/_feof asm with the arg in a register
# and returned garbage.  Fixed by making the fastcall decl+redirect macro
# unconditional (stdio.h).  See runtime_fileio_ferror_feof.c for the full writeup.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_fileio_ferror_feof.c"
ORACLE="ff f_fresh=0 r_fresh=0 f_mid=0 r_mid=0 f_eof=1 r_eof=0 f_clr=1 r_clr=0"

command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }

WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
HEAP="-pragma-define:CLIB_MALLOC_HEAP_SIZE=4000"
NTVCM_MAXCYC=${NTVCM_MAXCYC:-10}
ntvcm_run() { "$NTVCM" -m:"$NTVCM_MAXCYC" "$@" 2>/dev/null | grep -v "^ntvcm: cycle limit"; }

run_variant() {
    label="$1"; shift
    d="$WORK/$label"; mkdir -p "$d"
    if ! zcc "$@" $HEAP -create-app -o "$d/t" "$SRC" >"$d/build.log" 2>&1; then
        case "${TEST_CLIB:-classic}" in
            newlib_*) echo "__NEWLIB_LINK_FAIL__" ;;
            *) echo "__BUILD_FAIL__" ;;
        esac
        return
    fi
    (cd "$d" && ntvcm_run t.com | tr -d '\r' | sed -n 's/^\(ff .*\)$/\1/p' | head -1)
}

V_SCC=$(run_variant scc +cpm -O2)
V_LLVM=$(run_variant llvm +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -O2)

case "$V_LLVM" in
    __NEWLIB_LINK_FAIL__) echo "SKIP: newlib CP/M FILE* not supported (ravn/z88dk#34 WONTFIX)"; exit 0 ;;
esac
[ "$V_SCC" = "__BUILD_FAIL__" ] && { echo "SKIP: sccz80 oracle build failed"; exit 0; }
[ "$V_LLVM" = "__BUILD_FAIL__" ] && { echo "FAIL: llvmz80 build failed"; exit 1; }

echo "sccz80:  ${V_SCC:-<none>}"
echo "llvmz80: ${V_LLVM:-<none>}"

# Sanity: the oracle must exercise the contract (all-zero on the non-EOF states
# AND actually reach EOF, f_eof=1) -- otherwise any "match" would be meaningless.
[ "$V_SCC" = "$ORACLE" ] || { echo "FAIL: sccz80 oracle unexpected ([$V_SCC]) -- test assumption broken"; exit 1; }

[ "$V_LLVM" = "$V_SCC" ] || { echo "FAIL: ferror/feof diverge under llvmz80 (llvm=[$V_LLVM] vs oracle=[$V_SCC])"; exit 1; }

echo "PASS: ferror/feof agree (sccz80 == llvmz80 == oracle)"
exit 0
