#!/bin/bash
# sccz80 regression: loop-reversal pass (task #126).
#
# Each test compiles a count-up for-loop whose induction variable is
# unused inside the body, then verifies BOTH that the runtime answer
# is correct (HL after main returns) AND that the back-edge in the
# emitted asm uses `djnz` (8-bit count ≤ 255) or `dec bc` (16-bit).
#
# Usage: bash loop_reversal.sh
# override paths via env: COMPILER, Z80ASM, Z88DK_LIB, TICKS

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_loop_reversal}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.trace "$WORK"/*.c

ok=0
fail=0
failures=()

# Args: name, expected_HL_hex, expected_back_edge_pattern, src
#   expected_back_edge_pattern is a grep -E pattern that must match in
#   the asm output (e.g. 'djnz\\s', 'dec\\s+bc').
run_test() {
    local name="$1"
    local expected="$2"
    local pat="$3"
    local src="$4"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: sccz80 failed"); return
    fi
    if ! grep -qE "$pat" "$asm"; then
        fail=$((fail+1)); failures+=("$name: pattern '$pat' not found in asm"); return
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
    local hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    local expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name: expected hl=$expected, got hl=$hl")
    fi
}

# 8-bit djnz cases (trip count fits in B). Body is a call so we also
# verify push/pop bc preserves the counter.

run_test "djnz_simple_5" "000F" 'djnz[[:space:]]' '
int sum;
int adder(int v) { sum = sum + v; return 0; }
int main(void) {
    int i;
    sum = 0;
    for (i = 0; i < 5; i++) adder(3);
    return sum;
}'

run_test "djnz_simple_10" "0032" 'djnz[[:space:]]' '
int sum;
int adder(int v) { sum = sum + v; return 0; }
int main(void) {
    int i;
    sum = 0;
    for (i = 0; i < 10; i++) adder(5);
    return sum;
}'

run_test "djnz_max_255" "0010" 'djnz[[:space:]]' '
unsigned char ticks;
void tick(void) { ticks = ticks + 1; }
int main(void) {
    int i;
    ticks = 17;
    for (i = 0; i < 255; i++) tick();
    return ticks;
}'

# 16-bit dec bc case (trip count > 255 so 16-bit counter is required).

run_test "decbc_256" "0100" 'dec[[:space:]]+bc' '
int counter;
void bump(void) { counter = counter + 1; }
int main(void) {
    int i;
    counter = 0;
    for (i = 0; i < 256; i++) bump();
    return counter;
}'

run_test "decbc_300" "012C" 'dec[[:space:]]+bc' '
int counter;
void bump(void) { counter = counter + 1; }
int main(void) {
    int i;
    counter = 0;
    for (i = 0; i < 300; i++) bump();
    return counter;
}'

# Empty body — should reduce to nothing but the pre-test + back-edge.
# (Currently the pass still fires; the body compound's NULL'd stmts
# become an empty compound. Verify it still terminates.)
run_test "djnz_empty_body" "0000" 'djnz[[:space:]]' '
int main(void) {
    int i;
    for (i = 0; i < 10; i++) { }
    return 0;
}'

# Zero-trip case: loop bound equals init, so the loop body should not
# run. The pass currently declines (trip_count <= 0), so this stays
# as a normal loop — verify behaviour.
run_test "zero_trip" "002A" '' '
int counter;
int main(void) {
    int i;
    counter = 42;
    for (i = 5; i < 5; i++) counter = counter + 1;
    return counter;
}'

# Pass should DECLINE for IV-used-in-body or break-in-body. Runtime
# behaviour must still be correct, and djnz must not fire.
run_decline_test() {
    local name="$1"
    local expected="$2"
    local src="$3"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: sccz80 failed"); return
    fi
    if grep -qE 'djnz[[:space:]]' "$asm"; then
        fail=$((fail+1)); failures+=("$name: djnz emitted but pass should decline"); return
    fi
    if ! ( cd "$WORK" && reg_z80asm "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: z80asm failed"); return
    fi
    "$TICKS" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    local hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    local expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name: expected hl=$expected, got hl=$hl")
    fi
}

# `i` is read inside the body (sink(i)) — sum 0..9 = 45.
run_decline_test "iv_used_decline" "002D" '
int total;
int sink(int v) { total = total + v; return 0; }
int main(void) {
    int i;
    total = 0;
    for (i = 0; i < 10; i++) sink(i);
    return total;
}'

# `break` short-circuits the trip count.
run_decline_test "break_decline" "0006" '
int total;
int bump(void) { total = total + 1; return 0; }
int main(void) {
    int i;
    total = 0;
    for (i = 0; i < 100; i++) {
        if (total > 5) break;
        bump();
    }
    return total;
}'

# --- #276 Loop-reverse must save BC across body --------------------
# crcbench miscompile: the loop body XOR-stores into a long via
# l_long_xor + l_plong, both of which clobber BC. With djnz holding
# the counter in B, the body destroyed it. Fix: AST_LOOP_COUNTDOWN
# walker now pushes BC at body entry / pops at body exit (Zsp
# tracked). Below: long XOR-accumulate in a for-body counted in B.
# Without the wrap the loop runs hundreds of extra iterations and
# the final sum is wrong.
run_test "loop_reverse_long_compound_in_djnz" "0007" 'djnz[[:space:]]' '
unsigned long sum;
int main(void) {
    int i;
    sum = 0;
    for (i = 0; i < 5; i++) {
        sum ^= 3UL;
    }
    /* 5 XORs of 3: 3, 0, 3, 0, 3 — and a free-running djnz
       would land on a different parity. Add a final +4 so the
       expected HL is distinct from 0 / FFFF / etc. */
    return (int)(sum + 4UL);
}'

printf 'Loop-reversal regression:\n'
printf '  ok:   %d\n' "$ok"
printf '  fail: %d\n' "$fail"
if [ "$fail" -gt 0 ]; then
    for f in "${failures[@]}"; do printf '  - %s\n' "$f"; done
    exit 1
fi
exit 0
