#!/bin/bash
# sccz80 regression: FRAMEPTR (-frameix) IX-relative codegen.
# Locks in tasks #151-#159:
#   Phase 1a — IX-relative int load/store          (z80)
#   Phase 1b — IX-relative long load/store         (z80)
#   Phase 1c — IX-relative char load/store         (z80)
#   Phase 1d — ez80 `lea hl,ix+d` for gen_local_addr
#   Phase 1e — verify push/pop elimination under FP
#   Phase 4  — 8085 ldsi/lhlx/shlx under FP
#   Phase 7  — consolidate FP-active check in cg2_bare_ret_p
#   Phase 8  — ez80 inline l_glong / l_getptr
#
# Each test compiles with `-frameix`, asserts the IX-relative
# pattern is present in the asm, and runs under z88dk-ticks for
# runtime correctness.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_frameptr}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.trace "$WORK"/*.c "$WORK"/*.o

ok=0
fail=0
failures=()

# Args: cpu, name, expected_HL_hex, asm_must_contain_pattern, src
#   Same shape as run_cpu_test in opt_fold.sh but adds -frameix to
#   the sccz80 invocation.
run_fp_test() {
    local cpu="$1"
    local name="$2"
    local expected="$3"
    local pat="$4"
    local src="$5"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "-m$cpu" -frameix "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: sccz80 -frameix failed"); return
    fi
    if [ -n "$pat" ] && ! grep -qE "$pat" "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: pattern '$pat' missing"); return
    fi
    if ! ( cd "$WORK" && reg_cpu_asm "$cpu" "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: asm/link failed"); return
    fi
    "$TICKS" "-m$cpu" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    local hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    local expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name [$cpu]: expected hl=$expected, got hl=$hl")
    fi
}

# --- Walker FP DISABLED (#312) ------------------------------------
# As of task #312, the walker emits sp-relative addressing for all
# slot accesses even when -frameix is on. The flag still preserves
# the caller's IX register (push at entry, pop at exit) but the body
# no longer uses (ix±d) addressing. This eliminates the IX-clobber
# bug from long helpers (l_long_or etc. do `pop ix` to stash the
# return address — fatal if the function relies on IX as FP).
#
# Negative-style tests: with -frameix on, the walker body must NOT
# contain any (ix±d) addressing. The push ix / pop ix wrap MUST
# still appear (caller IX preserved).
run_fp_walker_disabled() {
    local cpu="$1"
    local name="$2"
    local expected="$3"
    local src="$4"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "-m$cpu" -frameix "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: sccz80 -frameix failed"); return
    fi
    if grep -qE '\(ix[-+]' "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: leaked (ix±d) walker emit"); return
    fi
    if ! grep -qE '^[[:space:]]*push[[:space:]]+ix[[:space:]]*$' "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: missing push ix (caller-save)"); return
    fi
    if ! grep -qE '^[[:space:]]*pop[[:space:]]+ix[[:space:]]*$' "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: missing pop ix (caller-restore)"); return
    fi
    if ! ( cd "$WORK" && reg_cpu_asm "$cpu" "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: asm/link failed"); return
    fi
    "$TICKS" "-m$cpu" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    local hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    local expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name [$cpu]: expected hl=$expected, got hl=$hl")
    fi
}

# Int / long / char locals under -frameix: body emits sp-relative,
# push/pop ix wraps the function.
run_fp_walker_disabled z80 "fp_int_no_ix" "002A" '
int g;
int main(void) {
    int n;
    g = 42;
    n = g;
    return n;
}'

run_fp_walker_disabled z80 "fp_long_no_ix" "5678" '
long gl2;
int main(void) {
    long n;
    gl2 = 0x12345678L;
    n = gl2;
    return (int)n;
}'

run_fp_walker_disabled z80 "fp_char_no_ix" "007F" '
unsigned char gc;
int main(void) {
    unsigned char c;
    gc = 127;
    c = gc;
    return c;
}'

# md5-style: long compound assign that calls l_long_or. Pre-#312
# this would corrupt IX mid-function and miscompile. Post-#312 the
# walker emits sp-relative, IX gets clobbered by the helper, but
# nothing depends on IX surviving, so the result is correct.
# 0x12345678 | 0x0F0F0F0F = 0x1F3F5F7F → low 16 = 0x5F7F.
run_fp_walker_disabled z80 "fp_long_helper_no_clobber" "5F7F" '
int main(void) {
    long x = 0x12345678L;
    long y = 0x0F0F0F0FL;
    x |= y;
    return (int)(x & 0xFFFFL);
}'

# --- #204 negative tests: -frameix is a no-op on CPUs without IX -----
# 8080 / 8085 / gbz80 have no IX/IY register. -frameix must NOT emit
# `ld (ix...),..` / `ld ..,(ix...)` for them — the gate in main.c
# zeroes c_framepointer_is_ix for these CPUs after option parsing.
#
# This test passes both an asm/link step (would fail outright on
# 8085 if `ld (ix-2),hl` leaked) AND a negative grep for any ix-
# relative form.
run_fp_no_ix() {
    local cpu="$1"
    local name="$2"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    printf '%s\n' "
int g;
int main(void) {
    int n;
    g = 42;
    n = g;
    return n;
}" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "-m$cpu" -frameix "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: sccz80 -frameix failed"); return
    fi
    if grep -qE '\(ix[-+]' "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: leaked ix-relative emit"); return
    fi
    if ! ( cd "$WORK" && reg_cpu_asm "$cpu" "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: asm/link failed"); return
    fi
    ok=$((ok+1))
}
run_fp_no_ix 8080  "fp_no_ix_8080"
run_fp_no_ix 8085  "fp_no_ix_8085"
run_fp_no_ix gbz80 "fp_no_ix_gbz80"

# --- Obsolete: -frameiy walker test (#263) ---------------------------
# Pre-#312, -frameiy was the workaround for #263's IX-clobber bug —
# use IY as frame ptr so IX is free for the long helpers to trash.
# Now that walker FP addressing is fully disabled (#312), both
# -frameix and -frameiy degrade to "preserve caller's index reg,
# don't actually use it as FP". The dedicated -frameiy walker test
# is no longer meaningful — covered by fp_long_helper_no_clobber
# above with -frameix.

run_fp_test_y() {
    # As run_fp_test but with -frameiy and asserting iy-relative pattern.
    local cpu="$1"
    local name="$2"
    local expected="$3"
    local pat="$4"
    local src="$5"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "-m$cpu" -frameiy "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: sccz80 -frameiy failed"); return
    fi
    if [ -n "$pat" ] && ! grep -qE "$pat" "$asm"; then
        fail=$((fail+1)); failures+=("$name [$cpu]: pattern '$pat' missing"); return
    fi
    if ! ( cd "$WORK" && reg_cpu_asm "$cpu" "$bin" "$HARNESS" "$asm" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: asm/link failed"); return
    fi
    "$TICKS" "-m$cpu" -end 6 -trace "$bin" > "$trace" 2>&1
    local hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    local hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    local expected_lc=$(echo "$expected" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "$expected_lc" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("$name [$cpu]: expected hl=$expected, got hl=$hl")
    fi
}

# run_fp_test_y body is dead since #312 — no test invocations remain.

# --- IR-mode FRAMEPTR (task #311) ---------------------------------
# Lock in the IR lowerer's IX-relative paths. ir_lower's emit
# helpers (load_to_hl_adj / store_hl / load_byte_to_a / store_a_byte
# / load_to_de / load_to_dehl_adj / store_dehl) all consult the
# fp_active(f) gate and emit `(ix±d)` synthetic forms when the
# offset fits in [-128, 127].
#
# Acceptance criteria:
#   - prologue does NOT push IX (the surrounding gen_push_frame
#     scaffolding already did it; double-push would corrupt sp);
#   - body uses IX-relative `ld hl,(ix+N)` style for slot accesses;
#   - epilogue restores sp via `ld sp,ix; pop ix` (vs the legacy
#     `ld hl,N; add hl,sp; ld sp,hl + pop ix` sequence — wins both
#     bytes and cycles).
#
# Test: a two-use PARAM in a no-call function — same shape as the
# PR_BC pool's `two_use`, but with -frameix the PARAM reload becomes
# `ld hl,(ix+4)` instead of the slot-reload chain.
asm_path="$WORK/ir_fp_two_use.asm"
printf '%s\n' '
unsigned int two_use(unsigned int a, unsigned int b) { return (a + b) ^ a; }' \
    > "$WORK/ir_fp_two_use.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix ir_fp_two_use.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("ir_fp_two_use: 80cc --use-ir -frameix failed")
else
    slurped=$(tr '\t' ' ' < "$asm_path" | awk '{gsub(/^ +/, ""); gsub(/ +$/, ""); gsub(/ +/, " "); if ($0 != "") printf "%s;", $0}')
    # Expect single push ix prologue + IX-relative load + ld sp,ix teardown.
    if [[ "$slurped" != *'push ix;ld ix,0;add ix,sp'* ]]; then
        fail=$((fail+1)); failures+=("ir_fp_two_use: missing FP prologue")
    elif [[ "$slurped" == *'push ix;ld ix,0;add ix,sp;push ix;ld ix,0;add ix,sp'* ]]; then
        fail=$((fail+1)); failures+=("ir_fp_two_use: duplicate FP prologue (walker+IR both emitted)")
    elif ! grep -qE 'ld[[:space:]]+(hl|de),\(ix' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_fp_two_use: missing ix-relative load")
    elif ! grep -qE 'ld[[:space:]]+sp,ix' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_fp_two_use: missing ld sp,ix teardown")
    elif ! grep -qE 'pop[[:space:]]+ix' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_fp_two_use: missing pop ix")
    else
        ok=$((ok+1))
    fi
fi

# --- Summary -------------------------------------------------------
echo "frameptr suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
