#!/bin/bash
# 80cc regression: IR variadic dispatch (task #314).
#
# Asserts that a call to a variadic SMALLC callee emits
# `ld a,N` (or `xor a` for N=0) directly before `call _<name>`,
# where N = total pushed bytes / 2 — matching the walker's
# loadargc() convention. Also locks in the LIBRARY-symbol
# no-underscore call form.
#
# All tests pass `--use-ir`. Without it the IR pipeline isn't
# engaged and the test is irrelevant.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_variadic}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.c

ok=0
fail=0
failures=()

asm_slurp() {
    tr '\t' ' ' < "$1" | awk '{
        gsub(/^ +/, "");
        gsub(/ +$/, "");
        gsub(/ +/, " ");
        if ($0 != "") printf "%s;", $0;
    }'
}

run_ir_test() {
    local name="$1"
    local pos_pat="$2"
    local neg_pat="$3"
    local src="$4"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" --use-ir "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: 80cc --use-ir failed"); return
    fi
    local slurped
    slurped=$(asm_slurp "$asm")
    if [ -n "$pos_pat" ] && [[ "$slurped" != *"$pos_pat"* ]]; then
        fail=$((fail+1)); failures+=("$name: expected '$pos_pat' missing"); return
    fi
    if [ -n "$neg_pat" ] && [[ "$slurped" == *"$neg_pat"* ]]; then
        fail=$((fail+1)); failures+=("$name: forbidden '$neg_pat' present"); return
    fi
    ok=$((ok+1))
}

# --- SMALLC variadic, 3 ints -> ld a,3 (3 words pushed) ----------
# Caller pushes fmt + a + b + c = 4 args × 2 bytes = 8 bytes. So we
# expect `ld a,4` immediately before `call _vsink`.
run_ir_test "va_three_ints" \
    'ld a,4;call _vsink' \
    '' \
    '
extern int vsink(const char *fmt, ...);
extern const char *FMT;
int test(int a, int b, int c) {
    return vsink(FMT, a, b, c);
}'

# --- SMALLC variadic with long arg, mixed widths -----------------
# fmt + int + long + int = 2 + 2 + 4 + 2 = 10 bytes, so `ld a,5`.
# Also verifies the long arg pushes high then low (`push de; push hl`).
run_ir_test "va_mixed_long" \
    'push de;push hl' \
    '' \
    '
extern int vsink(const char *fmt, ...);
extern const char *FMT;
int test(int a, long b, int c) {
    return vsink(FMT, a, b, c);
}'

run_ir_test "va_mixed_long_count" \
    'ld a,5;call _vsink' \
    '' \
    '
extern int vsink(const char *fmt, ...);
extern const char *FMT;
int test(int a, long b, int c) {
    return vsink(FMT, a, b, c);
}'

# --- SMALLC variadic with no args after fmt -> ld a,1 ------------
# Caller pushes only `fmt` = 2 bytes -> N=1. Verifies the non-zero
# path is preferred over xor (which is only when N=0).
run_ir_test "va_no_extra_args" \
    'ld a,1;call _vsink' \
    '' \
    '
extern int vsink(const char *fmt, ...);
int test(const char *p) {
    return vsink(p);
}'

# --- Non-variadic stdc callee: no `ld a,N` / `xor a` precedes call --
# A regular call shouldn'\''t emit the loadargc pre-amble.
run_ir_test "nonva_int_returner" \
    'call _peer' \
    'xor a;call _peer' \
    '
extern int peer(int x);
int test(int a) {
    return peer(a);
}'

# --- LIBRARY callee: no leading underscore on the call ----------
# `extern __sharedC int libfn(int)` would set LIBRARY, but the easier
# way to hit the no-underscore path is to call printf directly. We
# can'\''t bring stdio into a unit test cleanly without a prototype that
# includes the LIBRARY flag; instead we use `__library` attr.
run_ir_test "library_callee_no_underscore" \
    'call libfn' \
    'call _libfn' \
    '
extern int __LIB__ libfn(int x);
int test(int a) {
    return libfn(a);
}'

if [ "$fail" -eq 0 ]; then
    echo "variadic suite: ok=$ok fail=0"
    exit 0
else
    echo "variadic suite: ok=$ok fail=$fail"
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
