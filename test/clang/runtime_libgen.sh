#!/bin/sh
# basename/basename_ext/dirname/pathnice on classic +cpm must return the SAME
# strings under sccz80 and llvmz80.  Oracle diff: sccz80 is the reference,
# llvmz80 must match.  Regression guard for the fixed ferror/feof-class ABI bug
# (ravn/z88dk#55 audit): plain char *basename(char*) decls bypassed the
# __z88dk_fastcall bridge under __STDC_ABI_ONLY, so clang read the returned
# pointer from DE while the asm worker returns it in HL -> garbage.  Fixed by
# making the fastcall decl+redirect macro unconditional in libgen.h.
# See runtime_libgen.c for the full writeup.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_libgen.c"

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
        echo "__BUILD_FAIL__"; return
    fi
    (cd "$d" && ntvcm_run t.com | tr -d '\r' | LC_ALL=C sed -n 's/^\(lg .*\)$/\1/p' | head -1)
}

V_SCC=$(run_variant scc +cpm -O2)
V_LLVM=$(run_variant llvm +cpm -compiler=llvmz80 -O2)

[ "$V_SCC" = "__BUILD_FAIL__" ] && { echo "SKIP: sccz80 oracle build failed"; exit 0; }
[ "$V_LLVM" = "__BUILD_FAIL__" ] && { echo "FAIL: llvmz80 build failed"; exit 1; }

echo "sccz80:  ${V_SCC:-<none>}"
echo "llvmz80: ${V_LLVM:-<none>}"

# Sanity: the oracle must have actually produced the expected strings, else a
# "match" would be meaningless.
case "$V_SCC" in
    "lg bn=[zcc] dn=[/usr/local/bin]"*) : ;;
    *) echo "FAIL: sccz80 oracle unexpected ([$V_SCC]) -- test assumption broken"; exit 1 ;;
esac

[ "$V_LLVM" = "$V_SCC" ] || { echo "FAIL: libgen diverges under llvmz80 (llvm=[$V_LLVM] vs oracle=[$V_SCC])"; exit 1; }

echo "PASS: basename/basename_ext/dirname/pathnice agree (sccz80 == llvmz80)"
exit 0
