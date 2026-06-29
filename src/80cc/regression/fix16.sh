#!/bin/bash
# 80cc regression: _Accum (fix-point) end-to-end.
#
# Each test compiles a short C program with --use-ir, links with the
# fix16 library, and runs under z88dk-ticks. main returns the test's
# expected outcome via HL — checked at the harness's exit point. The
# IR pipeline handles float literal → _Accum scaling (×256), routes
# `_Accum * _Accum` and `_Accum / _Accum` through l_fix16_{muls,
# mulu,divs,divu}, and lowers `(int) _Accum` as a right-shift by 8.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_fix16}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.c "$WORK"/*.trace

ok=0
fail=0
failures=()

run_test() {
    local name="$1"
    local expected="$2"
    local src="$3"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" --use-ir "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: 80cc --use-ir failed"); return
    fi
    if ! ( cd "$WORK" && reg_z80asm "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: z80asm failed"); return
    fi
    "$TICKS" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ -z "$hl" ]; then
        fail=$((fail+1)); failures+=("$name: no pc=000D trace line"); return
    fi
    hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name: expected hl=$expected, got hl=$hl")
    fi
}

# Q8.8 raw bits for 5.0 are 0x0500 (high byte = integer part = 5).
run_test "scale_assign"   "0500" '
static _Accum a;
int main(void) {
    a = 5.0;
    return *(int *)&a;
}'

# 5.0 * 3.0 = 15.0; (int) 15.0 = 15.
run_test "mul_to_int"     "000F" '
static _Accum a, b, r;
int main(void) {
    a = 5.0;
    b = 3.0;
    r = a * b;
    return (int) r;
}'

# 6.0 / 4.0 = 1.5; (int) 1.5 = 1.
run_test "div_to_int"     "0001" '
static _Accum a, b, r;
int main(void) {
    a = 6.0;
    b = 4.0;
    r = a / b;
    return (int) r;
}'

# Unsigned mul: 4.0 * 2.0 = 8.0 in Q8.8 = 0x0800.
run_test "umul_raw"       "0800" '
static unsigned _Accum a, b, r;
int main(void) {
    a = 4.0;
    b = 2.0;
    r = a * b;
    return *(int *)&r;
}'

# Negative-value (int) conversion: -5.0 * 3.0 = -15.0 → -15 = 0xFFF1.
# Requires l_fix16_f2sint (arithmetic shift + sign extend); a plain
# logical shift would give 0x00F1 (wrong sign).
run_test "neg_to_int"     "FFF1" '
static _Accum a, b, r;
int main(void) { a = -5.0; b = 3.0; r = a * b; return (int) r; }'

# Negative (long) cast: -2.5 → -2 in long = 0xFFFFFFFE; low 16 = FFFE.
run_test "neg_to_long"    "FFFE" '
static _Accum a; static long r;
int main(void) { a = -2.5; r = (long) a; return (int) r; }'

# Unsigned _Accum → unsigned int via l_fix16_f2uint.
run_test "uacc_to_uint"   "0007" '
static unsigned _Accum a;
int main(void) { a = 7.5; return (unsigned)(unsigned _Accum) a; }'

# Reverse direction: int → _Accum via l_fix16_sint2f, then back.
run_test "int_to_acc"     "0005" '
static int x; static _Accum a;
int main(void) { x = 5; a = (_Accum) x; return (int) a; }'

run_test "neg_int_to_acc" "FFF9" '
static int x; static _Accum a;
int main(void) { x = -7; a = (_Accum) x; return (int) a; }'

run_test "uint_to_uacc"   "0003" '
static unsigned x; static unsigned _Accum a;
int main(void) { x = 3; a = (unsigned _Accum) x; return (unsigned) a; }'

# ADD chain: (1.5 + 2.5) * 2 = 8.0; (int) = 8.
run_test "add_then_mul"   "0008" '
static _Accum a, b, c, r;
int main(void) {
    a = 1.5;
    b = 2.5;
    c = 2.0;
    r = (a + b) * c;
    return (int) r;
}'

echo "fix16 suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
