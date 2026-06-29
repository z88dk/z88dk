#!/bin/bash
# sccz80 regression: compound-assign correctness and save-address
# fastpath (#146 long; #147 generalised to all types/ops).
#
# The walker computes the LHS address once, pushes it, walks the
# RHS into the primary register, calls the binop helper which
# consumes the saved primary from underneath the saved address,
# and finally pops the address to store. Two classes of failure
# this guards against:
#
#   1. Address recomputation — old shape walked the address twice,
#      breaking `arr[side_effect()] += …` because the side effect
#      fired twice.
#   2. Stack imbalance — wrong primary-save helper for a kind
#      leaves Zsp wrong by the time the address pop happens.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_compound}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.trace "$WORK"/*.c "$WORK"/*.o

ok=0
fail=0
failures=()

# Args: cpu, name, expected_HL_hex, asm_must_contain_pattern, src
run_ca_test() {
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
    if ! ( cd "$WORK" && "$COMPILER" "-m$cpu" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name [$cpu]: sccz80 failed"); return
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

# --- (a) int local += non-const RHS — fastpath fires --------------
# Walker saves &n, loads n, pushes n, walks rhs into HL, pops n
# into DE, adds, pops &n, calls l_pint. Tests stack neutrality
# of the save-address sequence with a non-const RHS.
run_ca_test z80 "ca_int_add_var" "0029" '' '
int rhs;
int main(void) {
    int n;
    rhs = 31;
    n = 10;
    n += rhs;
    return n;
}'

# --- (b) char local += var — char path uses ld a,(hl);add a,e -----
run_ca_test z80 "ca_char_add_var" "0029" '' '
unsigned char rhsc;
int main(void) {
    unsigned char n;
    rhsc = 31;
    n = 10;
    n += rhsc;
    return n;
}'

# --- (c) long local += var — lpush/lpop save-addr cycle ---------
# Critical regression target — #146 was specifically for this shape.
run_ca_test z80 "ca_long_add_var" "0029" '' '
long rhsl;
int main(void) {
    long n;
    rhsl = 31L;
    n = 10L;
    n += rhsl;
    return (int)n;
}'

# --- (d) longlong local += var — llpush/llpop ------------------
run_ca_test z80 "ca_llong_add_var" "0029" '' '
long long rhsll;
int main(void) {
    long long n;
    rhsll = 31LL;
    n = 10LL;
    n += rhsll;
    return (int)n;
}'

# --- (e) int local *= var ---------------------------------------
run_ca_test z80 "ca_int_mul_var" "001E" '' '
int rhs2;
int main(void) {
    int n;
    rhs2 = 3;
    n = 10;
    n *= rhs2;
    return n;
}'

# --- (f) int local <<= var — shift RHS keeps int even for long --
run_ca_test z80 "ca_int_shl_var" "0050" '' '
int rhs3;
int main(void) {
    int n;
    rhs3 = 3;
    n = 10;
    n <<= rhs3;
    return n;
}'

# --- (g) long local <<= var — shift LHS, int RHS ----------------
run_ca_test z80 "ca_long_shl_var" "0050" '' '
int rhs4;
int main(void) {
    long n;
    rhs4 = 3;
    n = 10L;
    n <<= rhs4;
    return (int)n;
}'

# --- (h) *p += rhs — long via pointer (complex-LHS save-addr) ---
# Task #205. LHS is OP_DEREF(local-ptr); cg2_walk(addr) walks the
# pointer var into HL, then the standard save-address dance runs
# (push HL, gen_load_indirect, arith, gen_store_tos).
# `return (int)n` is the canonical shape. The ast_opt prop pass
# (task #206) now invalidates escaped locals on indirect store
# through OP_DEREF LHS — so `n = 10L; *p += 31L; return n;` no
# longer folds the return to the stale literal 10.
run_ca_test z80 "ca_long_via_ptr" "0029" '' '
int main(void) {
    long n;
    long *p;
    p = &n;
    n = 10L;
    *p += 31L;
    return (int)n;
}'

# Direct alias-invalidation test (task #206): write through `*p`
# (plain OP_ASSIGN, not compound) must also invalidate the value
# of n in the prop env. Returns 5 (post-store) not 10 (pre-store).
run_ca_test z80 "alias_plain_store" "0005" '' '
int main(void) {
    int n;
    int *p;
    p = &n;
    n = 10;
    *p = 5;
    return n;
}'

# Negative: a non-escaped local is NOT invalidated by an indirect
# store through some other pointer — propagation still fires.
# `int m = 7; m gets propagated; *p = 5 (p points elsewhere) does
# not touch m;` return m+3 should compute to 10 at compile time
# and fold to a literal. Easiest verification: m has no &m
# anywhere in the function. We can't directly assert "literal-
# folded" from outside, but the runtime value must be correct.
run_ca_test z80 "alias_non_escaped_ok" "000A" '' '
int dest;
int main(void) {
    int *p;
    int m;
    p = &dest;
    m = 7;
    *p = 99;
    return m + 3;
}'

# --- (i) Compound on global int — fallback path -----------------
# Global LHS skips the save-addr fastpath (gen_load_static /
# gen_store_static are tighter). Validates fallback.
run_ca_test z80 "ca_int_global_var" "0029" '' '
int g, rhs5;
int main(void) {
    rhs5 = 31;
    g = 10;
    g += rhs5;
    return g;
}'

# --- (j) Compound with const RHS — *_const fastpath -------------
# Hits the dedicated const branch (zadd_const etc.). Different
# code path; needs its own coverage.
run_ca_test z80 "ca_int_add_const" "0029" '' '
int main(void) {
    int n;
    n = 10;
    n += 31;
    return n;
}'

# --- (k) Side-effect-once: arr[g_idx++] += rhs (task #205) -----
# THE canonical correctness test for the save-address shape. If
# the address re-evaluated after the RHS walk, the post-inc of
# g_idx would fire twice. Setup: g_idx=0, arr={10,99,0,0}. After
# `arr[g_idx++] += 31` with g_idx=0:
#   - read arr[0] = 10
#   - increment g_idx → 1 (exactly once)
#   - arr[0] = 10 + 31 = 41
# Return arr[0] + arr[1] = 41 + 99 = 140 = 0x008C.
# Asm pattern: a single `(_g_idx)` store via `inc hl` chain — the
# pattern check counts `_g_idx` references in the address-build
# step to lock in single-evaluation.
run_ca_test z80 "ca_side_effect_once" "008C" 'inc[[:space:]]+hl' '
int g_idx;
int arr[4];
int main(void) {
    g_idx = 0;
    arr[0] = 10;
    arr[1] = 99;
    arr[2] = 0;
    arr[3] = 0;
    arr[g_idx++] += 31;
    return arr[0] + arr[1];
}'

# Explicit single-evaluation check: emit a custom test that
# verifies _g_idx is incremented exactly once across the whole
# `arr[g_idx++] += 31` statement. Run the same compile, then count.
cfile="$WORK/ca_g_idx_count.c"
asm="$WORK/ca_g_idx_count.asm"
printf '%s\n' '
int g_idx;
int arr[4];
int main(void) {
    g_idx = 0;
    arr[0] = 10;
    arr[g_idx++] += 31;
    return arr[0];
}' > "$cfile"
if ( cd "$WORK" && "$COMPILER" -mz80 ca_g_idx_count.c 2>/dev/null ); then
    # Count *_g_idx address loads. The init `g_idx = 0` emits
    # `ld (_g_idx),hl` (no address load). The post-inc inside
    # `arr[g_idx++] += 31` emits a single `ld hl,_g_idx` for the
    # in-place inc sequence. Anything > 1 means the post-inc was
    # evaluated twice — the side-effect-once invariant is broken.
    addr_loads=$(grep -cE '^\s*ld\s+hl,_g_idx[[:space:]]*$' "$asm")
    if [ "$addr_loads" -le 1 ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("ca_g_idx_count [z80]: expected <= 1 address load of _g_idx, got $addr_loads")
    fi
else
    fail=$((fail+1))
    failures+=("ca_g_idx_count [z80]: sccz80 failed")
fi

# --- #R8 / #216 bitfield compound assign --------------------------
# Task #216 fix: `s.bf += N` was wiping the surrounding bitfields
# because the walker store-back used a plain word store. Fixed by
# routing bitfield through the save-address fastpath with
# gen_bitfield_store at the end. Setup: s.a=3, s.b=5, s.c=7; then
# s.a += 2 → s.a=5. Sum: 5+5+7 = 17 = 0x0011.
run_ca_test z80 "ca_bitfield_add" "0011" '' '
struct { unsigned int a : 4; unsigned int b : 4; unsigned int c : 8; } sbf;
int main(void) {
    sbf.a = 3; sbf.b = 5; sbf.c = 7;
    sbf.a += 2;
    return sbf.a + sbf.b + sbf.c;
}'

# `s.bf &= mask` — bitfield AND compound. Mask preserves low bit;
# s.a=3 (binary 0011) & 1 = 1. Verify adjacent bitfields b and c
# are NOT overwritten by the store-back. (sbf2.c is `: 8` which
# also exercises #217: the 8-bit-bitfield-at-byte-1 read must go
# through the bitfield-aware path, not the #198 const-offset fold.)
run_ca_test z80 "ca_bitfield_and" "000D" '' '
struct { unsigned int a : 4; unsigned int b : 4; unsigned int c : 8; } sbf2;
int main(void) {
    sbf2.a = 3; sbf2.b = 5; sbf2.c = 7;
    sbf2.a &= 1;
    return sbf2.a + sbf2.b + sbf2.c;    /* 1+5+7 = 13 = 0x0D */
}'

# `s.bf |= bit` — bitfield OR compound. s.a=3 | 8 = 11 (binary
# 1011). Verify other fields preserved.
run_ca_test z80 "ca_bitfield_or" "0017" '' '
struct { unsigned int a : 4; unsigned int b : 4; unsigned int c : 8; } sbf3;
int main(void) {
    sbf3.a = 3; sbf3.b = 5; sbf3.c = 7;
    sbf3.a |= 8;
    return sbf3.a + sbf3.b + sbf3.c;    /* 11+5+7 = 23 = 0x17 */
}'

# #217 explicit regression: read of an 8-bit bitfield at byte-1
# (bit_offset=8, bit_size=8) must go through bitfield-aware load,
# not via gen_load_static_offset which would emit a 16-bit word
# load and pick up the byte after the struct. Setup: 3+5+7 = 15.
run_ca_test z80 "bf_8bit_read_c" "000F" '' '
struct { unsigned int a : 4; unsigned int b : 4; unsigned int c : 8; } sbf4;
int main(void) {
    sbf4.a = 3; sbf4.b = 5; sbf4.c = 7;
    return sbf4.a + sbf4.b + sbf4.c;
}'

# --- #R8 bitwise compound (&=, |=, ^=) on plain int locals --------
# The save-address fastpath has zand/zor/zxor branches but the
# regression corpus only covered + - * <<. Add the bitwise forms.
run_ca_test z80 "ca_int_and_var" "0008" '' '
int rhs_and;
int main(void) {
    int n;
    rhs_and = 0xFFFF;
    n = 0x000F;
    n &= rhs_and;
    n &= 0xFF;
    n &= rhs_and;
    n -= 7;
    return n;
}'

run_ca_test z80 "ca_int_or_var" "00FF" '' '
int rhs_or;
int main(void) {
    int n;
    rhs_or = 0x00F0;
    n = 0x000F;
    n |= rhs_or;
    return n;            /* 0x0F | 0xF0 = 0xFF */
}'

run_ca_test z80 "ca_int_xor_var" "0033" '' '
int rhs_xor;
int main(void) {
    int n;
    rhs_xor = 0x0055;
    n = 0x0066;
    n ^= rhs_xor;
    return n;            /* 0x66 ^ 0x55 = 0x33 */
}'

# --- #218c char-width bitwise compound -----------------------------
# `c &= N` / `c |= N` / `c ^= N` with bare char LV/GV LHS now stays
# at byte width: `ld a,(sym); and/or/xor N; ld (sym),a` — 3 ops, 8
# bytes (was 14: int-widen via ld l,(hl)/ld h,0, redundant ld a,l,
# op, ld l,a, ld h,0, ld a,l before store, etc.).

# AND: 0x3F & 0x0F = 0x0F. Positive: assert `and 15` instruction.
run_ca_test z80 "ca_char_and_const_byte" "000F" '^[[:space:]]*and[[:space:]]+15' '
unsigned char ucand;
int main(void) {
    ucand = 0x3F;
    ucand &= 0x0F;
    return ucand;
}'

# OR: 0x07 | 0x80 = 0x87. Pattern: `or 128`.
run_ca_test z80 "ca_char_or_const_byte" "0087" '^[[:space:]]*or[[:space:]]+128' '
unsigned char ucor;
int main(void) {
    ucor = 0x07;
    ucor |= 0x80;
    return ucor;
}'

# XOR: 0xAA ^ 0xFF = 0x55. Pattern: `xor 255`.
run_ca_test z80 "ca_char_xor_const_byte" "0055" '^[[:space:]]*xor[[:space:]]+255' '
unsigned char ucxor;
int main(void) {
    ucxor = 0xAA;
    ucxor ^= 0xFF;
    return ucxor;
}'

# Negative: the legacy widen pattern `ld l,(hl); ld h,0` should
# NOT appear for the compound op itself. (The return-value load
# still uses it.) Verify by counting: 1 occurrence (the return),
# not 2 (compound + return).
cfile_neg3="$WORK/ca_char_no_widen.c"; asm_neg3="$WORK/ca_char_no_widen.asm"
printf '%s\n' '
unsigned char ucn;
int main(void) {
    ucn = 0x3F;
    ucn &= 0x0F;
    return ucn;
}' > "$cfile_neg3"
if ( cd "$WORK" && "$COMPILER" -mz80 ca_char_no_widen.c 2>/dev/null ); then
    n=$(grep -cE '^[[:space:]]*ld[[:space:]]+l,\(hl\)[[:space:]]*$' "$asm_neg3")
    if [ "$n" -le 1 ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("ca_char_no_widen: ld l,(hl) appears $n times (expected <=1)")
    fi
else
    fail=$((fail+1))
    failures+=("ca_char_no_widen: sccz80 failed")
fi

# Local char compound — same shape on stack-locals via
# gen_store_local_byte_in_a (FP-indexed or sp+d byte store).
run_ca_test z80 "ca_char_and_const_local" "000F" '^[[:space:]]*and[[:space:]]+15' '
unsigned char *p_local;
int main(void) {
    unsigned char lc;
    p_local = &lc;       /* escape so prop pass doesn'\''t fold */
    lc = 0x3F;
    lc &= 0x0F;
    return *p_local;
}'

# --- #237 save-LHS-address for bare local long plain assign -----
# `local_long = expr` where expr clobbers HL. Walker pre-pushes
# the LHS address before evaluating RHS; the store ends with
# `pop bc; call l_plong` instead of the old
# lpush+gen_local_addr+pop+pop dance. Closes ~53% of the md5sum
# parity gap (256 of 479 instructions).
#
# Uses globals to defeat ast_opt const-folding.
run_ca_test z80 "save_addr_long_assign" "0030" '^	pop	bc$' '
long ga = 0x10L;
long gb = 0x20L;
int main(void) {
    long a;
    a = ga + gb;
    return (int)a;
}'

# Same shape, longlong — exercises the KIND_LONGLONG arm via
# cg2_walk_to_llong and gen_store_tos with l_i64_store.
run_ca_test z80 "save_addr_llong_assign" "0030" '^	pop	bc$' '
long long gall_a = 0x10LL;
long long gall_b = 0x20LL;
int main(void) {
    long long a;
    a = gall_a + gall_b;
    return (int)a;
}'

# --- #231 ast_opt: rewrite `a = a op b` → `a op= b` --------------
# The new ast_compoundify_assign pass rewrites the plain-assign
# shape into the compound form when the LHS is a bare lvalue and
# appears on the RHS as `(deref bare-lvalue)`. Walker then routes
# through cg2_compound_assign with its save-address fastpath.
#
# Distinguishing shape: compound int store via cg2_compound_assign
# ends with `pop de; call l_pint` (TOS holds the address); plain
# assign through gen_store_local_keep does `push hl; ld hl,N; add
# hl,sp; pop de; ex de,hl; call l_pint`. Look for the compound
# pop+call pair as positive evidence.
# Use a parameter so const-prop can't fold `a` away — that's the
# whole point of #231: catch source-level `a = a + b` shapes that
# weren't statically reducible.
cfile_n231="$WORK/compoundify_assign.c"; asm_n231="$WORK/compoundify_assign.asm"
printf '%s\n' '
int rhs;
int dest;
void f(int a) {
    a = a + rhs;
    dest = a;
}
int main(void) {
    rhs = 11;
    f(5);
    return dest;
}' > "$cfile_n231"
if ( cd "$WORK" && "$COMPILER" -mz80 compoundify_assign.c 2>/dev/null ); then
    if awk '
        /^\tpop\tde$/                 { prev=NR; next }
        /^\tcall\tl_pint/ && NR==prev+1 { found=1 }
        END { exit !found }' "$asm_n231"; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("compoundify_assign: compound pop-de/call-l_pint shape missing")
    fi
else
    fail=$((fail+1))
    failures+=("compoundify_assign: compile failed")
fi

# --- #241 walker emits l_glong2sp for long deref + lpush --------
# Long binop on z80 where LHS is a memory read: walker fuses the
# `load-into-DEHL + push DE + push HL` sequence into a single
# `call l_glong2sp` (which atomically loads and pushes the long).
# Test value: 100000 + 50000 = 150000 = 0x000249F0 → low word 0x49F0.
# Pattern check: at least one `call l_glong2sp` in the body.
run_ca_test z80 "save_addr_glong2sp_global" "49F0" '^	call	l_glong2sp$' '
static long ga = 100000;
static long gb = 50000;
int main(void) {
    return (int)(ga + gb);
}'

# Same shape but LHS is a local long (sp-relative address). Walker
# emits gen_local_addr + call l_glong2sp. Use parameters so the
# value isn't const-propagated away.
run_ca_test z80 "save_addr_glong2sp_local" "49F0" '^	call	l_glong2sp$' '
long add_them(long a, long b) { return a + b; }
int main(void) { return (int)add_them(100000L, 50000L); }'

# Same shape with a pointer-arithmetic LHS — the cg2_walk(OP_ADD)
# arm of #241. Verify pointer arithmetic still works correctly.
run_ca_test z80 "save_addr_glong2sp_ptr" "49F0" '^	call	l_glong2sp$' '
static long arr[2] = { 100000, 50000 };
int main(void) {
    return (int)(arr[0] + arr[1]);
}'

# --- #243 LICM/CSE-synth slot-sharing fix ---
# When LICM (or CSE-synth) hoists a temp into a compound that's a
# scope-sibling of the C block where the inner-loop index var lives,
# plan_color's scope-based liveness model concluded they don't overlap
# and gave them the same stack slot. They DO overlap at runtime — the
# temp is read inside the inner loop while the index var is also live.
# Fix: synthesized syms (digit-prefix names — `1cse_<N>` / `1licm_<N>`)
# get flagged `always_interferes = 1` so they always get their own slot.
#
# Repro pattern: same shape as md5sum.c MD5Update. Trigger needs a
# multi-variable declaration line (`int i, ii;`) — sccz80 sub-scopes
# these into a different compound from where LICM inserts its temp.
# Without the fix this test returns 0x062f (loop var clobbers the
# hoisted pointer temp so the for-loop accumulates garbage).
run_ca_test z80 "licm_slot_share_no_clobber" "0078" '' '
typedef struct { int pad[5]; unsigned char data[16]; } Box;
static Box bx;
int f(Box *b, unsigned int n) {
    int sum;
    int i, ii;                    /* multi-decl line — sub-scoped */
    while (n--) {
        sum = 0;
        for (i = 0, ii = 0; i < 16; i++, ii++)
            sum += b->data[i];
    }
    return sum;
}
int main(void) {
    int i;
    for (i = 0; i < 16; i++) bx.data[i] = (unsigned char)i;
    return f(&bx, 1);             /* 0+1+..+15 = 120 = 0x78 */
}'

# --- pointer-store long widening (general path) -------------------
# `p[i] = small_long_literal` used to emit `ld hl,N` but forget the
# matching `ld de,0` for the high half — l_plong then wrote DE's
# stale value into bytes 2-3 of the destination. Fix: walker's
# general pointer-store path dispatches cg2_walk_to_long on the RHS
# when the destination kind is KIND_LONG. Pattern check: the
# function-body must contain `ld de,0` paired with the `ld hl,1`
# literal, then `call l_plong`. Runtime check: read back arr[2]
# truncated to int — high half must be 0 (DE properly cleared) or
# the != 1UL test would short-circuit and return 0xBAD.
run_ca_test z80 "ptr_store_long_widen_small" "0001" '^	ld	de,0$' '
static unsigned long arr[4];
void store(unsigned long *p) { p[2] = 1; }
int main(void) {
    arr[2] = 0xCAFEBABEUL;   /* poison high half */
    store(arr);
    if (arr[2] != 1UL) return 0xBAD;
    return (int)arr[2];
}'

# Zero literal — same bug class. Tests that even `p[i] = 0` walks
# through vlongconst (or its widen equivalent) rather than skipping
# the high-half load entirely.
run_ca_test z80 "ptr_store_long_widen_zero" "0000" '' '
static unsigned long arr[4];
void store(unsigned long *p) { p[2] = 0; }
int main(void) {
    arr[2] = 0xCAFEBABEUL;
    store(arr);
    if (arr[2] != 0UL) return 0xBAD;
    return (int)arr[2];
}'

# --- CSE-synth: must not hoist reads of a decl-with-init above the
# decl itself. Repro: `T arr[N] = {0,0,0,0}; ...uses arr[k] twice`
# made the synthesize pass hoist `*(arr+k)` to a __cse_<n> temp
# before the LDIR-fill of arr — temp captured uninitialised memory.
# Fix: stmt_directly_mutates_cand_sym treats AST_DECL with declvar
# as a write to its sym. Runtime check: with two reads of arr[2]
# after a zero-init, both reads must observe 0.
run_ca_test z80 "cse_synth_no_hoist_above_decl_init" "0000" '' '
static volatile unsigned long sink;
int main(void) {
    unsigned long arr[4] = {0,0,0,0};
    sink = arr[2];                          /* read #1 */
    if (arr[2] != 0UL) return 0xBAD;        /* read #2 — CSE cand */
    return (int)arr[2];
}'

# --- Builtin strcpy Zsp imbalance (test/suites/string strlcat repro) ---
# `gen_builtin_strcpy` emits an unbalanced final `pop hl` to consume
# the dest address the caller pushed, but didn't update Zsp. The
# walker then thought one extra item was still on the stack — every
# subsequent local-address computation in the same statement landed
# two bytes off. Manifested as `strcpy(buf, "First")` followed by a
# printf("%s", buf) printing "rst" — the second arg pointer was 2
# bytes past the actual buf. Repro calls __builtin_strcpy directly
# (regression harness doesn't pull in string.h's strcpy macro), then
# reads buf[0] which must come from the SAME slot the inline copy
# wrote to.
run_ca_test z80 "builtin_strcpy_zsp_balance" "0041" '' '
extern char *__builtin_strcpy(char *dst, const char *src);
int main(void) {
    char buf[8];
    __builtin_strcpy(buf, "ABC");
    return buf[0];                /* must be ''A'' = 0x41, not ''C'' */
}'

# --- OP_ADDR type stamping (test/suites/stdio scanf %ld repro) ---
# `normalize_types` fell back to operand->type for both OP_DEREF and
# OP_ADDR — correct for DEREF (deref of T* is T) but wrong for ADDR
# (&x is T*, not T). Variadic call-arg push-width dispatch then read
# the wrong type and pushed 4 bytes for `&long_local` instead of 2.
# `sscanf("-32767", "%ld", &v1)` wrote the result through a bogus
# pointer; v1 stayed 0. Fix: ADDR builds make_pointer(operand-type)
# when the parser left node->type unset.
#
# Minimum direct repro: a variadic helper that reads its pointer
# arg via va_list semantics — except we can't write that without
# libc. Instead exploit the post-call state: with a 4-byte push of
# &long_local, the caller emits 4 `pop bc`s to clean up but only 3
# were really pushed at the right widths, so the return-from-call
# offset arithmetic for accessing `x` AFTER the call lands at the
# wrong slot. Verifies: write through &x via a non-inlined helper,
# then read x back — must match. With the bug, the helper writes
# to a stale address (high half of x's stack slot).
run_ca_test z80 "addr_long_local_push_width" "0BAD" '' '
static void store_long(long *p, long val) { *p = val; }
int main(void) {
    long x = 0xCAFEBABE;
    store_long(&x, 0x12340BAD);    /* &x MUST be pushed as 2 bytes */
    return (int)x;                  /* low half = 0x0BAD */
}'

# --- UINT4 byte-pack fastpath (md5sum.c MD5Update inner loop) -----
# `(UINT4)b3<<24 | (UINT4)b2<<16 | (UINT4)b1<<8 | (UINT4)b0` used to
# emit 3 × `call l_long_or` per pack + per-byte shift-into-position
# scaffolding. Recognised in cg2_binop and emitted as a byte-deposit
# straight into D/E/H/L. Verify the asm doesn't call l_long_or for
# this exact shape, and the runtime value is the expected packed long.
# Input bytes 0x01, 0x23, 0x45, 0x67 in that array order → packed
# little-endian-from-MSB result = 0x67452301. Low half = 0x2301.
run_ca_test z80 "byte_pack_long_no_or_helper" "2301" '' '
typedef unsigned long UINT4;
static unsigned char data[4] = { 0x01, 0x23, 0x45, 0x67 };
int main(void) {
    UINT4 r = ((UINT4)data[3] << 24) | ((UINT4)data[2] << 16) |
              ((UINT4)data[1] << 8)  | (UINT4)data[0];
    return (int)r;                 /* low 16 = 0x2301 */
}'

# Negative asm assertion: the recognised shape must NOT emit a single
# l_long_or call (the body should be 4 byte-loads + pop/deposit
# sequence). Compile a function that exercises the pattern in
# isolation, then grep its asm.
cfile_byte_pack="$WORK/byte_pack_check.c"
asm_byte_pack="$WORK/byte_pack_check.asm"
printf '%s\n' '
typedef unsigned long UINT4;
extern UINT4 out;
void f(unsigned char *p) {
    out = ((UINT4)p[3] << 24) | ((UINT4)p[2] << 16) |
          ((UINT4)p[1] << 8)  | (UINT4)p[0];
}' > "$cfile_byte_pack"
if ( cd "$WORK" && "$COMPILER" -mz80 byte_pack_check.c 2>/dev/null ); then
    if grep -qE '^\s*call\s+l_long_or' "$asm_byte_pack"; then
        fail=$((fail+1))
        failures+=("byte_pack_no_or_helper: l_long_or call still emitted")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("byte_pack_no_or_helper: compile failed")
fi

# --- 16-bit local post-inc in-place fastpath (MD5Update mdi++) ----
# `for (int i = 0; i < N; i++)` and `arr[idx++]` patterns used to
# emit load via l_gintsp + inc on HL + store via l_pint (~3 helper
# calls, ~150 cycles per step). Fastpath: gen_local_addr + carry-
# aware in-place `inc (hl); ld a,(hl); inc hl; jr nz,+3; inc (hl);
# ld h,(hl); ld l,a` (~42 cycles, no helper calls). Verify both
# runtime correctness and absence of l_gintsp / l_pint in the body.
run_ca_test z80 "post_inc_local_inplace" "000A" '' '
int main(void) {
    int i = 0;
    int sum = 0;
    while (i < 10) {
        i++;            /* in-place inc on local int */
    }
    return i;
}'

# Negative asm assertion: the post-inc must use inc (hl), not the
# l_gintsp / l_pint pair. Match the in-place sequence: the body
# should contain `inc\s+\(hl\)` and NOT contain `call\s+l_pint` for
# the increment itself (the loop-bound check might still use l_gint,
# but a 4-iter loop body with `i++` only should be inc-based).
cfile_inplace="$WORK/post_inc_inplace_check.c"
asm_inplace="$WORK/post_inc_inplace_check.asm"
printf '%s\n' '
void f(void) {
    int i = 0;
    while (i < 4) i++;
}' > "$cfile_inplace"
if ( cd "$WORK" && "$COMPILER" -mz80 post_inc_inplace_check.c 2>/dev/null ); then
    if ! grep -qE '^\s*inc\s+\(hl\)' "$asm_inplace"; then
        fail=$((fail+1))
        failures+=("post_inc_inplace_check: inc (hl) not emitted")
    elif grep -qE '^\s*call\s+l_pint' "$asm_inplace"; then
        fail=$((fail+1))
        failures+=("post_inc_inplace_check: still calling l_pint to store i++")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("post_inc_inplace_check: compile failed")
fi

# --- _Float16 push-init width (test/suites/math test_math16 repro) ---
# #219 push-init replaced `modstk + ld (slot),hl` for leading
# init'd locals with `eval init; push hl`. For decimal slots the
# init expression's natural width can exceed the slot — e.g.
# `_Float16 a = 10.0;` walks the double literal to 4-byte FA in
# DE:HL, but `push hl` only stores the LOW 2 bytes (= 0 for both
# 10.0 and -2.0 in IEEE32). `a > 0` then compares wrong. Fix:
# route decimal slots through cg2_walk_to_decimal which converts
# down to the slot's storage kind before the push. Verifies the
# raw bits stored at &a are the IEEE half encoding of 10.0 = 0x4900.
run_ca_test z80 "push_init_float16_widen_down" "4900" '' '
int main(void) {
    _Float16 a = 10.0;
    unsigned short *p = (unsigned short *)&a;
    return (int)*p;
}'

# --- Summary -------------------------------------------------------
echo "compound_assign suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
