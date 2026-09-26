#!/bin/sh
# Runtime test: see runtime_rodata_cstn.c.  Verifies that clang's mergeable
# read-only constant sections .rodata.cstN (N = 4/8/16/32) survive the
# -compiler=llvmz80 copt bridge instead of being dropped into SECTION IGNORE
# (ravn/z88dk#30).  The fix is the copt rule
# `.section .rodata.cst%2,%1 -> SECTION rodata_compiler` in
# lib/llvmz80/llvmz80_rules.1.
# ABI-independent (integer types only); portable across classic clib and newlib.
set -e
DIR=$(cd "$(dirname "$0")" && pwd)
SRC="$DIR/runtime_rodata_cstn.c"
command -v zcc >/dev/null 2>&1 || { echo "SKIP: zcc not on PATH"; exit 0; }
NTVCM=${NTVCM:-ntvcm}
command -v "$NTVCM" >/dev/null 2>&1 || { echo "SKIP: ntvcm not found (set NTVCM)"; exit 0; }
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
fail() { echo "FAIL: $1"; exit 1; }

# Expected printed lines = the array literals.  Verified HERE (not in C): a
# C-side `x[i]==LIT` compare folds from the const initializer and would pass
# even when the bytes were dropped; a dropped section reads back "0 0".
EXPECT='CST4 1234 5678
CST8 11223344 55667788
CST16 11223344 deadbee
CST32 10203040 17273747'

# Run at ALL FOUR clang optimization levels.  `-Cg-O<n>` passes -O<n> to the
# code generator (clang); zcc's bare -O<n> only sets the z80asm/appmake level
# and leaves clang at -O0.  Which section clang picks varies by level (plain
# .rodata at -O0/-O1, mergeable .rodata.cstN at -O2/-O3), so the data must
# survive the bridge at every level.
overall=0
for OPT in O0 O1 O2 O3; do
    if ! zcc +cpm -compiler=llvmz80 ${ZCC_CLIB:-} -Cg-$OPT -create-app -o "$WORK/rt_$OPT" "$SRC" >"$WORK/build_$OPT.log" 2>&1; then
        echo "--- build log ($OPT) ---"; cat "$WORK/build_$OPT.log"
        echo "FAIL[$OPT]: zcc build failed"; overall=1; continue
    fi
    OUT=$("$NTVCM" "$WORK/rt_$OPT.com" 2>/dev/null | tr -d '\r')
    printf '%s\n' "$EXPECT" | while IFS= read -r line; do
        printf '%s\n' "$OUT" | grep -qx "$line" || echo "  MISSING[$OPT]: $line"
    done
    if printf '%s\n' "$EXPECT" | while IFS= read -r line; do
            printf '%s\n' "$OUT" | grep -qx "$line" || exit 1; done; then
        echo "PASS[$OPT]: runtime_rodata_cstn"
    else
        echo "--- program output ($OPT) ---"; printf '%s\n' "$OUT"
        echo "FAIL[$OPT]: .rodata.cstN dropped to SECTION IGNORE (const reads 0) -- ravn/z88dk#30"
        overall=1
    fi
done
[ "$overall" = 0 ] || fail "runtime_rodata_cstn failed at one or more -O levels"
echo "PASS: runtime_rodata_cstn (O0 O1 O2 O3)"
