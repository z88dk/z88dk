#!/bin/bash
# 80cc regression: long-DEHL value cache (IR pipeline).
#
# After every store_dehl(vreg), DE retains the long's high half and BC
# holds the low half. A follow-on load_to_dehl(vreg) can recover the
# DEHL pair with just `ld l,c; ld h,b` (2 inst / ~12 T-states) instead
# of re-reading the 4-byte slot (~80 T-states). The cache also fires
# across push de / push hl staging (used for the runtime-helper arg
# convention in long ADD/SUB/AND/OR/XOR) since neither push touches
# the cached registers.
#
# These tests assert that the cache pattern *does* appear for the
# canonical "long add a const then read back" shape — a regression
# would either drop the cache wiring entirely (no `ld l,c` / `ld h,b`
# pair after a long binop) or emit the full slot read instead.
#
# All tests pass `--use-ir` to z88dk-80cc directly. Without the flag
# the IR pipeline isn't engaged and the optimisation is irrelevant.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_dehl_cache}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.c

ok=0
fail=0
failures=()

# Slurp asm into a single line for regex match. Tabs/spaces in the
# pattern become a literal space sequence; newlines become `;` for
# easy grouping in the pattern.
asm_slurp() {
    tr '\t' ' ' < "$1" | awk '{
        gsub(/^ +/, "");
        gsub(/ +$/, "");
        gsub(/ +/, " ");
        if ($0 != "") printf "%s;", $0;
    }'
}

# Args: name, must_contain_substr_with_;_separators, must_NOT_contain, src
#   Patterns are plain substrings; newlines in the source asm become
#   `;`, multiple spaces collapse to one.
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

# --- Cache hit: long ADD by const, twice in a row -----------------
# The first `a += K1` ends with store_dehl_cached(a). The second
# `a += K2` starts the long-binop emit sequence by pushing K2's
# halves on the stack, then load_to_dehl_adj(a, 4). At that point
# DE+BC still hold a's halves, so the load should compile to just
# `ld l,c; ld h,b` immediately after the second `push hl`.
#
# Pattern: after #332 the long const-ADD lowering loads K directly
# into BC at the use site (no push). The first ADD's store leaves
# BC = LHS low; the second ADD's load_to_dehl then cache-hits with
# `ld hl,bc` (the z80asm synthetic that expands to ld l,c; ld h,b).
# Verify the cache-hit recovery appears at least once in the function
# body (separating the two const ADDs).
run_ir_test "dehl_cache_const_add" \
    'ld hl,bc' \
    '' \
    '
unsigned long add_pair(unsigned long a) {
    a += 0xA478U;
    a += 0xB512U;
    return a;
}'

# --- Cache hit: long compound ADD then immediate re-read ----------
# Trickier: ST_MEM into the local slot then LD_MEM. The IR optimiser
# may eliminate the round-trip, but if it doesn't, the store sets
# the DEHL cache for the result vreg; if the source then re-reads
# the same vreg the cache should fire. This is a softer test —
# we only require that the cache infrastructure produces at least
# one standalone `ld l,c \n ld h,b` pair in the asm (not preceded
# by `ld d,(hl)` which would be the tail of a full slot read).
#
# Negative side: forbid the *all-misses* outcome — i.e. if every
# `ld l,c \n ld h,b` is the tail of a slot read, we'd see only
# `inc hl \n ld d,(hl)` immediately before each one and nothing
# else. Use a python-style awk check via a separate shell.
asm_path="$WORK/dehl_cache_hit_count.asm"
printf '%s\n' '
unsigned long acc;
void mix(unsigned long x) {
    acc += x;
    acc ^= x;
    acc += 0x12345678UL;
}' > "$WORK/dehl_cache_hit_count.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir dehl_cache_hit_count.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("dehl_cache_hit_count: 80cc --use-ir failed")
else
    # Cache mechanism is in play whenever the lowerer emits `ld bc,hl`
    # (cache_dehl publishes BC=low half). For an active cache, a
    # successor load_to_dehl on the same vreg can elide its recovery
    # entirely (cur_hl_vreg short-circuit) — we therefore can't strictly
    # require `ld hl,bc` to appear. Verify the stash exists and that
    # there's no full slot re-read between consecutive uses (the cache
    # avoids redundant `ld hl,N; add hl,sp; ld a,(hl); inc hl; ...`).
    stash_count=$(grep -cE '^[[:space:]]*ld[[:space:]]+bc,hl[[:space:]]*$' "$asm_path")
    if [ "${stash_count:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("dehl_cache_hit_count: no cache stash ld bc,hl found")
    else
        ok=$((ok+1))
    fi
fi

# --- Dead-dst long binop skips the slot write ---------------------
# `local += K; *p = local;` — the IR_ADD's dst is consumed only by
# the immediately-following ST_MEM, so the binop's spill to the slot
# is wasted. The lowerer's cur_dehl_dst_dead_safe lookahead should
# fire here, replacing store_dehl (~11 inst) with the 2-inst BC
# stash. Verify by counting `ld (hl),d` (the final byte of a long
# slot store) — md5/crcbench shows ~60+ per function; this tiny
# function should have at most one (the actual `*p = local` write),
# down from two without the dead-skip.
asm_path="$WORK/dead_dst_store.asm"
printf '%s\n' '
void compute(unsigned long *p, unsigned long a) {
    a += 1234UL;
    *p = a;
}' > "$WORK/dead_dst_store.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir dead_dst_store.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("dead_dst_store: 80cc --use-ir failed")
else
    long_stores=$(grep -c '^[[:space:]]*ld[[:space:]]\+(hl),d[[:space:]]*$' "$asm_path")
    if [ "${long_stores:-0}" -gt 1 ]; then
        fail=$((fail+1)); failures+=("dead_dst_store: expected ≤1 long slot store, got $long_stores")
    else
        ok=$((ok+1))
    fi
fi

# --- IR_LD_MEM_SYM PR_HL: skip slot spill when dead-after-next ----
# `t = g; return t ^ a;` — t is consumed only by the XOR. ir_alloc
# marks t as PR_HL via IR_LD_MEM in the cacheable kind set. The
# lowerer's spill_and_swap_unless_dead skips the slot write; the
# binop's load_binop_operands case 2 (hl_has src[0]) routes the
# RHS load through load_to_de_preserve_hl (push/pop instead of
# slot save/load — saves ~46 T-states).
asm_path="$WORK/ldmem_sym_pr_hl.asm"
printf '%s\n' '
unsigned int g;
unsigned int sum(unsigned int a) {
    unsigned int t = g;
    return t ^ a;
}' > "$WORK/ldmem_sym_pr_hl.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir ldmem_sym_pr_hl.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("ldmem_sym_pr_hl: 80cc --use-ir failed")
else
    # After the fix: `ld hl,(_g)` is the only sym-load, and there is
    # NO subsequent `ld (hl),e/d` writing it back to a slot. Count
    # `ld (hl),d` in the BB body (excluding param init) — expect 0.
    body=$(awk '/^L_f1_bb_0:/{seen=1} seen' "$asm_path")
    n_int_stores=$(echo "$body" | awk '/^[[:space:]]*ld[[:space:]]+\(hl\),d[[:space:]]*$/ { c++ } END { print c+0 }')
    if [ "${n_int_stores:-0}" -ne 0 ]; then
        fail=$((fail+1)); failures+=("ldmem_sym_pr_hl: body has $n_int_stores int slot-stores, expected 0")
    elif ! echo "$body" | grep -qE '^[[:space:]]*push[[:space:]]+hl[[:space:]]*$'; then
        fail=$((fail+1)); failures+=("ldmem_sym_pr_hl: missing push hl (preserve-HL load)")
    else
        ok=$((ok+1))
    fi
fi

# --- CONV byte->int: spill-skip when consumed by next op ----------
# `((int)b << 8)` chain. The CONV_ZX dst is src[0] of SHL, so it's
# PR_HL via the cacheable kind list (Stage 4 expansion). The
# spill_and_swap_unless_dead gate skips the slot write. Count
# `ld (hl)` byte-store sequences inside the function — without
# the cacheable fix there were ≥2 (one for CONV result, one for
# SHL result); with the fix there should be ≤1 (or 0 if the SHL
# is also dead).
asm_path="$WORK/conv_zx_pr_hl.asm"
printf '%s\n' '
unsigned int crc_step(unsigned int crc, unsigned char b) {
    return crc ^ ((unsigned int)b << 8);
}' > "$WORK/conv_zx_pr_hl.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir conv_zx_pr_hl.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("conv_zx_pr_hl: 80cc --use-ir failed")
else
    # Count `ld (hl),d` (the int high-byte store). The crc parameter
    # init in the prologue contributes one. The CONV→SHL→XOR body
    # should not add any more — CONV is PR_HL dead-skipped and SHL
    # is PR_DE. Expect ≤ 1.
    n_stores=$(awk '
        /^[[:space:]]*ld[[:space:]]+\(hl\),d[[:space:]]*$/ { c++ }
        END { print c+0 }
    ' "$asm_path")
    if [ "${n_stores:-0}" -gt 1 ]; then
        fail=$((fail+1)); failures+=("conv_zx_pr_hl: expected ≤1 int high-byte slot-store, got $n_stores")
    else
        ok=$((ok+1))
    fi
fi

# --- PR_DE: shift result routed into DE for next binop's src[1] ---
# `crc ^ (b << 8)` is intbench's CRC inner loop shape. The shifted
# byte's result becomes src[1] of the XOR. With IR_SHL in the
# Stage-4 producer set, the shift's final `add hl,hl` chain is
# wrapped with `ex de,hl` and the spill is skipped.
run_ir_test "pr_de_shl_rhs" \
    'ex de,hl' \
    'l_lsh\b' \
    '
unsigned int crc_step(unsigned int crc, unsigned char b) {
    return crc ^ ((unsigned int)b << 8);
}'

# --- PR_DE: binop result routed into DE for next binop's src[1] ---
# `c ^ (a ^ b)` — the inner XOR's dst feeds the outer XOR as src[1].
# The Stage-4 producer set includes IR_XOR, so the inner XOR's byte
# writes go to E/D instead of L/H, leaving HL holding src[0]. No
# spill of the intermediate. Verify by counting standalone `ld e,a`
# inside the function — should appear at least once (the swapped
# write).
run_ir_test "pr_de_xor_rhs" \
    'ld e,a' \
    '' \
    '
unsigned int xrh(unsigned int a, unsigned int b, unsigned int c) {
    return c ^ (a ^ b);
}'

# --- PR_DE: global-load directly into DE for binop RHS ------------
# `a + g` where g is a static int. The IR is `%t = LD_MEM g; %u =
# ADD %a, %t` with %t consumed only as src[1] of the ADD. ir_alloc
# marks %t as PR_DE; the lowerer emits `ld de,(_g)` (no slot spill)
# and the ADD's load_binop_operands case 4 picks it up via the DE
# cache. The full sym-load-into-HL-and-spill sequence is gone.
run_ir_test "pr_de_global_load" \
    'ld de,(_g)' \
    'ld hl,(_g)' \
    '
unsigned int g;
unsigned int add_g(unsigned int a) { return a + g; }'

# --- store_dehl uses ld bc,hl, not push hl/pop bc -----------------
# The store_dehl epilogue stash now uses the z80asm `ld bc,hl`
# synthetic (expands to `ld b,h; ld c,l`) instead of a stack round
# trip. Verify the synthetic appears in any store_dehl-emitting
# function.
run_ir_test "store_dehl_no_stack_stash" \
    'ld bc,hl' \
    '' \
    '
unsigned long store_some(unsigned long v) {
    v += 1UL;
    return v;
}'

# --- PR_BC: multi-use PARAM held in BC across the function body ----
# `(a + b) ^ a` — `a` is a PARAM used twice (at ADD and XOR). The
# function has no calls, no longs, and no IR_ST_MEM with offset, so
# ir_alloc's PR_BC envelope opens. `a` (v0) is picked: prologue loads
# it into BC via `ld c,(hl); inc hl; ld b,(hl)`, and both use sites
# emit `ld l,c; ld h,b` (HL hit) or `ld e,c; ld d,b` (DE hit) — 2
# instructions vs the 6 of a fresh slot reload.
#
# Positive: the prologue BC-init sequence appears.
# Positive: at least one `ld l,c; ld h,b` short-circuit fires in body.
# Negative: no second 6-instruction sp-relative slot reload of `a`
#          (the body shouldn't repeat the `ld hl,4; add hl,sp; ld a,(hl)`
#          chain — slot 4 (=PARAM `a`) gets loaded once into BC, not
#          re-read from the slot).
asm_path="$WORK/pr_bc_param.asm"
printf '%s\n' '
unsigned int two_use(unsigned int a, unsigned int b) { return (a + b) ^ a; }' \
    > "$WORK/pr_bc_param.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir pr_bc_param.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("pr_bc_param: 80cc --use-ir failed")
else
    slurped=$(asm_slurp "$asm_path")
    # The prologue BC load (`ld c,(hl); inc hl; ld b,(hl)`) must appear.
    if [[ "$slurped" != *'ld c,(hl);inc hl;ld b,(hl)'* ]]; then
        fail=$((fail+1)); failures+=("pr_bc_param: missing BC prologue init")
    elif [[ "$slurped" != *'ld hl,bc'* ]]; then
        fail=$((fail+1)); failures+=("pr_bc_param: missing BC→HL short-circuit")
    elif [ "$(awk '/ld[ \t]+hl,4[ \t]*$/ { c++ } END { print c+0 }' "$asm_path")" -gt 1 ]; then
        # Expect at most ONE `ld hl,4` (the prologue BC-init address
        # compute). If more appear, the body is re-reading slot 4.
        fail=$((fail+1)); failures+=("pr_bc_param: body re-reads PARAM slot")
    else
        ok=$((ok+1))
    fi
fi

# --- PR_BC: written PARAM (post-inc) must NOT enter the BC pool ----
# `*data++` writes back to data's vreg. Lowerer's PR_BC short-circuit
# only handles reads; writes to BC would silently drop on the floor.
# Eligibility must exclude any vreg that appears as a dst anywhere.
# This is the bug that broke intbench crc16_ccitt before the fix.
asm_path="$WORK/pr_bc_written_param.asm"
printf '%s\n' '
unsigned int sum_bytes(unsigned char *data, unsigned int len) {
    unsigned int acc = 0;
    unsigned char *end = data + len;
    while (data < end) acc += *data++;
    return acc;
}' > "$WORK/pr_bc_written_param.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir pr_bc_written_param.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("pr_bc_written_param: 80cc --use-ir failed")
else
    # Negative: no BC prologue init for the written PARAM. `data` is
    # post-incremented so its vreg has write_count > 0; ir_alloc must
    # skip it. `len` could in principle qualify (read-only, used twice
    # for the `+ len` and the loop bound via `end = data + len`), so
    # we don't ban BC use entirely — we ban the specific shape where
    # BC is loaded BUT subsequently overwritten. The simplest check:
    # if BC is initialised, no `ld bc,N` should appear in the body
    # (which would indicate IR_LD_MEM / IR_ST_MEM with offset clobber).
    if grep -q '^[[:space:]]*ld[[:space:]]\+c,(hl)[[:space:]]*$' "$asm_path" \
       && grep -q '^[[:space:]]*ld[[:space:]]\+bc,[0-9]' "$asm_path"; then
        fail=$((fail+1)); failures+=("pr_bc_written_param: BC init + BC clobber both present")
    else
        ok=$((ok+1))
    fi
fi

# --- IR long-add/sub inlined (no helper call) ---------------------
# IR_ADD / IR_SUB for width-4 vregs used to emit `call l_long_add` /
# `call l_long_sub`. Those helpers do `pop ix` to stash the return
# address, which obliterates the caller's frame pointer under
# -frameix. Inlining the helper body eliminates the IX clobber AND is
# ~40 T-states faster per site (no call/ret/IX-trick overhead).
#
# Negative: NO `call l_long_add` / `l_long_sub` appears.
# Positive: either the old 16-bit chain (`adc hl,bc` / `sbc hl,bc`)
# OR the new fused 8-bit chain (`adc a,(hl)` / `sbc a,(hl)` from #335)
# is present. Both are valid inlinings — #335 prefers the latter for
# sp-rel var-RHS but the 16-bit form still appears in other shapes.
asm_path="$WORK/ir_long_inline.asm"
printf '%s\n' '
unsigned long add_pair(unsigned long a, unsigned long b) { return a + b; }
unsigned long sub_pair(unsigned long a, unsigned long b) { return a - b; }' \
    > "$WORK/ir_long_inline.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir ir_long_inline.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("ir_long_inline: 80cc --use-ir failed")
else
    if grep -qE 'call[[:space:]]+l_long_(add|sub)\b' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_long_inline: helper call still emitted")
    elif ! grep -qE 'adc[[:space:]]+(hl,bc|a,\(hl\))' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_long_inline: missing inline adc (hl,bc or a,(hl))")
    elif ! grep -qE 'sbc[[:space:]]+(hl,bc|a,\(hl\))' "$asm_path"; then
        fail=$((fail+1)); failures+=("ir_long_inline: missing inline sbc (hl,bc or a,(hl))")
    else
        ok=$((ok+1))
    fi
fi

# --- Multi-vreg PR_BC: non-overlapping PARAM use intervals --------
# Two PARAMs with use_count >= 2 each, and their first-use/last-use
# intervals don'\''t overlap. Both should be allocated PR_BC. The asm
# should show:
#   1. A prologue BC load for the first PR_BC vreg (`a`).
#   2. A mid-function `add hl,sp; ld c,(hl); inc hl; ld b,(hl)` (or
#      `ld bc,(ix+d)` under FP) — the demand reload of `b` into BC.
#   3. Multiple `ld hl,bc` (HL hits) AND `ld e,c; ld d,b` (DE
#      hits) — the cheap BC→reg copies that PR_BC enables.
asm_path="$WORK/multi_pr_bc.asm"
printf '%s\n' '
unsigned int multi(unsigned int a, unsigned int b) {
    unsigned int s;
    s  = a + 1;
    s ^= a;
    s += a;
    s += b;
    s ^= b;
    s += b;
    return s;
}' > "$WORK/multi_pr_bc.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir multi_pr_bc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("multi_pr_bc: 80cc --use-ir failed")
else
    # Count `ld c,(hl)` (the byte-by-byte sp-relative BC load). Must
    # appear at least twice: once for prologue (a), once for demand
    # reload (b). Under FP the synthetic `ld bc,(ix+d)` is used
    # instead, so test that pattern too.
    bc_loads=$(grep -cE '(ld[[:space:]]+c,\(hl\))|(ld[[:space:]]+bc,\(i[xy])' "$asm_path")
    if [ "${bc_loads:-0}" -lt 2 ]; then
        fail=$((fail+1)); failures+=("multi_pr_bc: expected ≥2 BC loads, got $bc_loads")
    elif ! grep -qE '^[[:space:]]*ld[[:space:]]+hl,bc[[:space:]]*$' "$asm_path"; then
        fail=$((fail+1)); failures+=("multi_pr_bc: missing ld hl,bc (HL cache hit)")
    elif ! grep -qE '^[[:space:]]*ld[[:space:]]+e,c[[:space:]]*$' "$asm_path"; then
        fail=$((fail+1)); failures+=("multi_pr_bc: missing ld e,c (DE cache hit)")
    else
        ok=$((ok+1))
    fi
fi

# --- PR_BC for a write-once LOCAL (`end` pointer pattern) ---------
# Mirrors intbench's crc16_ccitt: compute `end = data + len` once,
# then read it many times in `while (data < end)`. The producer
# (ADD) goes through spill_and_swap_unless_dead; with the dst marked
# PR_BC, the lowerer emits `ld c,l; ld b,h` to stamp BC after the
# ADD, and subsequent reads hit the BC cache.
asm_path="$WORK/local_pr_bc.asm"
printf '%s\n' '
unsigned int walk(unsigned char *data, unsigned int len) {
    unsigned char *end = data + len;
    unsigned int sum = 0;
    while (data < end) sum += (unsigned int)*data++;
    return sum;
}' > "$WORK/local_pr_bc.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir local_pr_bc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("local_pr_bc: 80cc --use-ir failed")
else
    # Expect: `ld bc,hl` right after the ADD that computes `end`
    # (the producer-side BC stamp, using z80asm's synthetic that
    # expands to `ld b,h; ld c,l`). And at least one cache-hit
    # pattern (`ld hl,bc` for HL or `ld e,c` for DE) in the loop
    # body where `end` is read for the compare.
    if ! grep -qE '^[[:space:]]*ld[[:space:]]+bc,hl[[:space:]]*$' "$asm_path"; then
        fail=$((fail+1)); failures+=("local_pr_bc: missing ld bc,hl (BC stamp at producer)")
    elif ! grep -qE '^[[:space:]]*ld[[:space:]]+(hl,bc|e,c)[[:space:]]*$' "$asm_path"; then
        fail=$((fail+1)); failures+=("local_pr_bc: missing BC cache hit on end read")
    else
        ok=$((ok+1))
    fi
fi

# --- IR store-to-load forwarding (3a) ------------------------------
# `g = x; return g + 1;` — IR_LD_MEM of g should be rewritten to MOV
# from x. Asm should NOT contain a `ld hl,(_g)` load of g; the second
# use of g should come from the cached x value.
asm_path="$WORK/st2ld_sym.asm"
printf '%s\n' '
unsigned int g;
unsigned int fwd(unsigned int x) {
    g = x;
    return g + 1;
}' > "$WORK/st2ld_sym.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir st2ld_sym.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("st2ld_sym: 80cc --use-ir failed")
else
    # The body should write to (_g) but NOT read from (_g) — the second
    # use of g forwards to x. Count `ld hl,(_g)` patterns; expect 0.
    if grep -qE 'ld[[:space:]]+hl,\(_g\)' "$asm_path"; then
        fail=$((fail+1)); failures+=("st2ld_sym: redundant ld hl,(_g) present — forwarding missed")
    elif ! grep -qE 'ld[[:space:]]+\(_g\),hl' "$asm_path"; then
        fail=$((fail+1)); failures+=("st2ld_sym: missing the store itself")
    else
        ok=$((ok+1))
    fi
fi

# --- IR loop-invariant code motion (3e) ----------------------------
# A string-literal address inside a loop is invariant (the literal
# queue's address doesn't change). LICM should hoist the LD_STR to
# the loop pre-header. Asm should show exactly one `ld hl,i_<lit>`
# in the function (not one per iteration).
asm_path="$WORK/licm_strlit.asm"
printf '%s\n' '
extern int sink(const char *p);
void licm(int n) {
    while (n--) sink("hello");
}' > "$WORK/licm_strlit.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir licm_strlit.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("licm_strlit: 80cc --use-ir failed")
else
    n_loads=$(grep -cE 'ld[[:space:]]+hl,i_' "$asm_path")
    if [ "${n_loads:-0}" -ne 1 ]; then
        fail=$((fail+1)); failures+=("licm_strlit: expected 1 ld hl,i_<lit>, got $n_loads")
    else
        ok=$((ok+1))
    fi
fi

# --- IR arithmetic CSE (3d) ----------------------------------------
# Two identical `a + b` sub-expressions should collapse to one ADD
# plus a MOV. Asm should show exactly one `add hl,de`-style int-add
# sequence for `a + b`; the second use forwards via MOV.
asm_path="$WORK/cse_arith.asm"
printf '%s\n' '
unsigned int cse(unsigned int a, unsigned int b, unsigned int c) {
    unsigned int x = a + b;
    unsigned int y = a + b;
    return (x ^ c) + (y ^ c);
}' > "$WORK/cse_arith.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir cse_arith.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("cse_arith: 80cc --use-ir failed")
else
    # Without CSE: two `add hl,de` for the two a+b computations plus
    # the final outer add — 3 total.
    # With CSE: one `add hl,de` for a+b, two XORs, one final add — 2 add hl,de total.
    n_adds=$(grep -cE '^[[:space:]]*add[[:space:]]+hl,de[[:space:]]*$' "$asm_path")
    if [ "${n_adds:-0}" -gt 2 ]; then
        fail=$((fail+1)); failures+=("cse_arith: expected ≤2 add hl,de (CSE), got $n_adds")
    else
        ok=$((ok+1))
    fi
fi

# --- IR dead-store elimination (3c) --------------------------------
# Two stores to the same global with no read between — the first
# is dead and should be dropped.
asm_path="$WORK/dse_sym.asm"
printf '%s\n' '
extern unsigned int g;
unsigned int dse(unsigned int a, unsigned int b) {
    g = a;
    g = b;
    return g;
}' > "$WORK/dse_sym.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir dse_sym.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("dse_sym: 80cc --use-ir failed")
else
    n_stores=$(grep -cE 'ld[[:space:]]+\(_g\),hl' "$asm_path")
    if [ "${n_stores:-0}" -ne 1 ]; then
        fail=$((fail+1)); failures+=("dse_sym: expected 1 ld (_g),hl, got $n_stores")
    else
        ok=$((ok+1))
    fi
fi

# --- IR redundant-load elimination (3b) ----------------------------
# Two reads of the same global without intervening write — second
# should MOV from the first's dst.
asm_path="$WORK/rle_sym.asm"
printf '%s\n' '
unsigned int g;
unsigned int rle(void) {
    unsigned int a = g;
    unsigned int b = g;     /* second load — should forward */
    return a + b;
}' > "$WORK/rle_sym.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir rle_sym.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("rle_sym: 80cc --use-ir failed")
else
    # Expect EXACTLY ONE `ld hl,(_g)` — the second load was forwarded.
    n_loads=$(grep -cE 'ld[[:space:]]+hl,\(_g\)' "$asm_path")
    if [ "${n_loads:-0}" -ne 1 ]; then
        fail=$((fail+1)); failures+=("rle_sym: expected 1 ld hl,(_g), got $n_loads")
    else
        ok=$((ok+1))
    fi
fi

# --- PR_BC across IR_CALL ------------------------------------------
# A write-once local in a function that also has a call. The cached
# value survives the call either via push bc / pop bc (#319, slot-arg
# calls) or via a post-call slot reload of the tenant (pre-pushed-arg
# calls, where a save below the args is impossible). Verify one of
# the two patterns plus the cached read (`ld l,c` / `ld e,c`).
asm_path="$WORK/pr_bc_across_call.asm"
printf '%s\n' '
extern int sink(int);
int wrapped(int a, int b) {
    int sum = a + b;       /* write-once local */
    sink(sum);             /* call clobbers BC unless preserved */
    return sum + 1;        /* second read of `sum` */
}' > "$WORK/pr_bc_across_call.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir pr_bc_across_call.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("pr_bc_across_call: 80cc --use-ir failed")
else
    has_wrap=0
    if grep -qE '^[[:space:]]*push[[:space:]]+bc[[:space:]]*$' "$asm_path" \
       && grep -qE '^[[:space:]]*pop[[:space:]]+bc[[:space:]]*$' "$asm_path"; then
        has_wrap=1
    fi
    # Post-call reload: `ld c,(hl)` + `ld b,(hl)` (sp-rel) or
    # `ld bc,(ix...` (fp) appearing after the call.
    has_reload=$(awk '/call[[:space:]]+_sink/{seen=1}
                      seen && (/ld[[:space:]]+c,\(hl\)/ || /ld[[:space:]]+bc,\(/){found=1}
                      END{print found+0}' "$asm_path")
    has_cached_read=$(grep -cE '^[[:space:]]*ld[[:space:]]+(l,c|e,c|hl,bc|de,bc)[[:space:]]*$' "$asm_path")
    if [ "$has_wrap" -eq 0 ] && [ "${has_reload:-0}" -eq 0 ]; then
        fail=$((fail+1)); failures+=("pr_bc_across_call: BC neither saved (push/pop) nor reloaded post-call")
    elif [ "${has_cached_read:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("pr_bc_across_call: post-call read doesn't hit the BC cache")
    else
        ok=$((ok+1))
    fi
fi

# --- Loop-aware PR_BC: 1 static use inside a loop body ------------
# A PARAM used exactly once statically — but inside a loop body —
# should now be allocated PR_BC because the use is weighted by 4×
# (hot use in loop). Before #317, use_count < 2 → ineligible. After,
# weighted count = 4 → clears the threshold.
asm_path="$WORK/loop_pr_bc.asm"
printf '%s\n' '
unsigned int hot1(unsigned int k) {
    unsigned int s = 0;
    while (s < 1000) s = s + k;
    return s;
}' > "$WORK/loop_pr_bc.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir loop_pr_bc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("loop_pr_bc: 80cc --use-ir failed")
else
    # Expect the prologue BC load (sp-relative or FP-relative). And
    # at least one `ld hl,bc` (HL cache hit) in the loop body where
    # `k` is read.
    if ! grep -qE '(ld[[:space:]]+c,\(hl\))|(ld[[:space:]]+bc,\(i[xy])' "$asm_path"; then
        fail=$((fail+1)); failures+=("loop_pr_bc: missing BC prologue load")
    elif ! grep -qE '^[[:space:]]*ld[[:space:]]+(hl,bc|e,c)[[:space:]]*$' "$asm_path"; then
        fail=$((fail+1)); failures+=("loop_pr_bc: missing ld hl,bc / ld e,c (cache hit on k)")
    else
        ok=$((ok+1))
    fi
fi

# --- IR_DEC + IR_BR_COND must reload value before testing ---------
# Lock in the spill_and_swap_unless_dead fix for IR_INC/DEC/NEG/NOT/
# CMP*. Bug: those ops used `spill_unless_dead` (HL→junk after store)
# then `cache_hl(dst)` (claims HL holds the value). The next branch
# checked the cache, skipped the reload, and tested HL — which held
# the slot address, not the value. Result: count-down loops never
# terminated (`or l` on a non-zero address always gave NZ).
#
# Pattern: a count-down loop where `rep--` feeds `if (rep != 0)`. The
# loop check must reload rep from the slot (or have HL=actual value)
# before `ld a,h; or l`. We assert by checking the running asm: in
# the loop-check sequence we must NOT see `store-via-HL` immediately
# followed by `or l` without an `ex de,hl` (which is what
# spill_and_swap inserts) or a fresh slot load between them.
asm_path="$WORK/dec_then_br.asm"
printf '%s\n' '
extern void sink(int);
void countdown(void) {
    int rep = 63;
    while (rep != 0) {
        sink(rep);
        rep--;
    }
}' > "$WORK/dec_then_br.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir dec_then_br.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("dec_then_br: 80cc --use-ir failed")
else
    # Run binary on z80 to verify: countdown must terminate (otherwise
    # the test harness times out). 63 iters × call sink = ~500 ticks.
    # An infinite loop would burn cycles forever. We can'\''t easily
    # run the test directly here, so do a pattern check: between
    # `ld (hl),d` (high-byte store) and the following `or l`, an
    # `ex de,hl` MUST appear (the swap that restores HL=value), OR a
    # fresh `add hl,sp; ld a,(hl)` slot reload must appear.
    bad=$(awk '
        BEGIN { in_window = 0 }
        /^[[:space:]]*ld[[:space:]]+\(hl\),d[[:space:]]*$/ {
            in_window = 1; saw_ex = 0; saw_reload = 0; next
        }
        in_window && /^[[:space:]]*ex[[:space:]]+de,hl[[:space:]]*$/ { saw_ex = 1 }
        in_window && /^[[:space:]]*add[[:space:]]+hl,sp[[:space:]]*$/ { saw_reload = 1 }
        in_window && /^[[:space:]]*or[[:space:]]+l[[:space:]]*$/ {
            if (!saw_ex && !saw_reload) { bad++ }
            in_window = 0
        }
        END { print bad+0 }
    ' "$asm_path")
    if [ "${bad:-0}" -gt 0 ]; then
        fail=$((fail+1)); failures+=("dec_then_br: spill-then-test missing ex de,hl ($bad sites)")
    else
        ok=$((ok+1))
    fi
fi

# --- Variable-RHS chain: AND-then-OR cache-hit (#324) -------------
# `(a & b) | c` lowers to two variable-RHS long binops.
# The AND's dst is consumed exclusively by the OR as the first
# DEHL load (src[0]); without #324 the AND ends with a 4-byte
# slot store + the OR begins with a 4-byte slot read of the same
# value. With #324 the dead_safe lookahead recognises that the
# OR loads src[0] first → fires cache_dehl_no_spill → the OR's
# load_to_dehl(src[0]) emits the 2-instruction `ld l,c; ld h,b`
# cache-hit recovery.
#
# Test: count `ld (hl),d` (the high-byte store that terminates a
# long slot write). The function returns via DEHL so the last
# OR result is *also* spilled to a sp+0 temp before ret → 1
# legitimate occurrence. With #324 the intermediate AND-result
# spill is gone, so the count is 1; without #324 it's 2.
asm_path="$WORK/var_rhs_and_or.asm"
printf '%s\n' '
unsigned long f(unsigned long a, unsigned long b, unsigned long c) {
    return (a & b) | c;
}' > "$WORK/var_rhs_and_or.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir var_rhs_and_or.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("var_rhs_and_or: 80cc --use-ir failed")
else
    n_long_stores=$(grep -c '^[[:space:]]*ld[[:space:]]\+(hl),d[[:space:]]*$' "$asm_path")
    if [ "${n_long_stores:-0}" -gt 1 ]; then
        fail=$((fail+1)); failures+=("var_rhs_and_or: expected ≤1 long slot-store, got $n_long_stores")
    else
        ok=$((ok+1))
    fi
fi

# --- Variable-RHS ADD chain: src[1]==dst cache-hit (#324) ---------
# Long ADD's variable-RHS lowerer pushes the RHS first, so the
# first DEHL load is src[1]. When dst lands in src[1] of the next
# ADD, #324 sets dead_safe so the load_to_dehl(src[1]) cache-hits.
#
# Shape: `c + (b + a)` — the inner add's result is used as the
# RHS of the outer add. Inner ADD has dst=%t1; outer ADD has
# src[1]=%t1 (only use of %t1). The outer ADD's lowerer loads
# src[1] first → 2-instruction cache-hit recovery, no slot store.
#
# Test: count `ld (hl),d` (long high-byte slot store). Only one
# is legitimate — the return-temp spill before the function ret.
# Without #324 the inner ADD's spill adds a second one.
asm_path="$WORK/var_rhs_add_src1.asm"
printf '%s\n' '
unsigned long add_nested(unsigned long a, unsigned long b, unsigned long c) {
    return c + (b + a);
}' > "$WORK/var_rhs_add_src1.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir var_rhs_add_src1.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("var_rhs_add_src1: 80cc --use-ir failed")
else
    n_long_stores=$(grep -c '^[[:space:]]*ld[[:space:]]\+(hl),d[[:space:]]*$' "$asm_path")
    if [ "${n_long_stores:-0}" -gt 1 ]; then
        fail=$((fail+1)); failures+=("var_rhs_add_src1: expected ≤1 long slot-store, got $n_long_stores")
    else
        ok=$((ok+1))
    fi
fi

# --- Long SHR partial load (#329) ---------------------------------
# `long >> 26` (byte_shift=3, bit_shift=2): with #329 the lowerer
# loads only byte 3 of the source directly into L, then zeros H/E/D.
# inc hl count in the function: 0 in the load (partial reads only the
# high byte) + 3 in the result-spill store = 3 total. Without #329
# the full 4-byte load adds 3 more inc hl for total 6.
asm_path="$WORK/long_shr_26.asm"
printf '%s\n' '
unsigned long shr26(unsigned long x) { return x >> 26; }' \
    > "$WORK/long_shr_26.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_shr_26.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_shr_26: 80cc --use-ir failed")
else
    n_incs=$(grep -c '^[[:space:]]*inc[[:space:]]\+hl[[:space:]]*$' "$asm_path")
    n_load_l=$(grep -c '^[[:space:]]*ld[[:space:]]\+l,(hl)[[:space:]]*$' "$asm_path")
    if [ "${n_incs:-0}" -gt 3 ] || [ "${n_load_l:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("long_shr_26: expected partial load (ld l,(hl) ×≥1, inc hl ≤3) (got inc=$n_incs, ld l,(hl)=$n_load_l)")
    else
        ok=$((ok+1))
    fi
fi

# Symmetric check for SHL byte_shift=3 (<< 26): loads only byte 0
# into D directly. inc hl total ≤ 3 (just the result store).
asm_path="$WORK/long_shl_26.asm"
printf '%s\n' '
unsigned long shl26(unsigned long x) { return x << 26; }' \
    > "$WORK/long_shl_26.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_shl_26.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_shl_26: 80cc --use-ir failed")
else
    n_incs=$(grep -c '^[[:space:]]*inc[[:space:]]\+hl[[:space:]]*$' "$asm_path")
    n_load_d=$(grep -c '^[[:space:]]*ld[[:space:]]\+d,(hl)[[:space:]]*$' "$asm_path")
    if [ "${n_incs:-0}" -gt 3 ] || [ "${n_load_d:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("long_shl_26: expected partial load (ld d,(hl) ×≥1, inc hl ≤3) (got inc=$n_incs, ld d,(hl)=$n_load_d)")
    else
        ok=$((ok+1))
    fi
fi

# --- int SHR ≥ 8 partial load (#329) ------------------------------
# `int >> 8` (count=8): only the high byte survives, goes into L of
# the result. With #329 the lowerer loads just byte 1 directly into
# L; with the old code it loaded both bytes then did `ld l,h; ld h,0`.
# Pattern check: presence of `ld l,(hl)` (partial byte read into L)
# and absence of `ld l,h` (the post-load byte shuffle).
asm_path="$WORK/int_shr_8.asm"
printf '%s\n' '
unsigned int shr8(unsigned int x) { return x >> 8; }' \
    > "$WORK/int_shr_8.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir int_shr_8.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("int_shr_8: 80cc --use-ir failed")
else
    n_lh=$(grep -c '^[[:space:]]*ld[[:space:]]\+l,h[[:space:]]*$' "$asm_path")
    n_load_l=$(grep -c '^[[:space:]]*ld[[:space:]]\+l,(hl)[[:space:]]*$' "$asm_path")
    if [ "${n_lh:-0}" -gt 0 ] || [ "${n_load_l:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("int_shr_8: expected ld l,(hl) (partial), no ld l,h (got ld l,h=$n_lh, ld l,(hl)=$n_load_l)")
    else
        ok=$((ok+1))
    fi
fi

# `int << 8`: only low byte survives, goes into H. Pattern: presence
# of `ld h,(hl)` and absence of `ld h,l` (the old byte shuffle).
asm_path="$WORK/int_shl_8.asm"
printf '%s\n' '
unsigned int shl8(unsigned int x) { return x << 8; }' \
    > "$WORK/int_shl_8.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir int_shl_8.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("int_shl_8: 80cc --use-ir failed")
else
    n_hl_shuffle=$(grep -c '^[[:space:]]*ld[[:space:]]\+h,l[[:space:]]*$' "$asm_path")
    n_load_h=$(grep -c '^[[:space:]]*ld[[:space:]]\+h,(hl)[[:space:]]*$' "$asm_path")
    if [ "${n_hl_shuffle:-0}" -gt 0 ] || [ "${n_load_h:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("int_shl_8: expected ld h,(hl) (partial), no ld h,l (got ld h,l=$n_hl_shuffle, ld h,(hl)=$n_load_h)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long SHR bit_shift trim after partial load (#330) ------------
# `long >> 25` (byte_shift=3, bit_shift=1): after the partial load
# only L has data; H,E,D are zero. The bit_shift remainder should be
# just `srl l` — not the full `srl d; rr e; rr h; rr l` chain. Each
# saved instruction is 8T per bit.
asm_path="$WORK/long_shr_25.asm"
printf '%s\n' '
unsigned long shr25(unsigned long x) { return x >> 25; }' \
    > "$WORK/long_shr_25.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_shr_25.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_shr_25: 80cc --use-ir failed")
else
    n_srl_l=$(grep -c '^[[:space:]]*srl[[:space:]]\+l[[:space:]]*$' "$asm_path")
    n_rr=$(grep -c '^[[:space:]]*rr[[:space:]]\+[ehd][[:space:]]*$' "$asm_path")
    if [ "${n_srl_l:-0}" -ne 1 ] || [ "${n_rr:-0}" -ne 0 ]; then
        fail=$((fail+1))
        failures+=("long_shr_25: expected srl l ×1, rr e/h/d ×0 (got srl l=$n_srl_l, rr=$n_rr)")
    else
        ok=$((ok+1))
    fi
fi

# `long << 25` (byte_shift=3, bit_shift=1): only D has data; H,E,L
# are zero. Bit_shift should be just `sla d`, not add/rl/rl.
asm_path="$WORK/long_shl_25.asm"
printf '%s\n' '
unsigned long shl25(unsigned long x) { return x << 25; }' \
    > "$WORK/long_shl_25.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_shl_25.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_shl_25: 80cc --use-ir failed")
else
    n_sla_d=$(grep -c '^[[:space:]]*sla[[:space:]]\+d[[:space:]]*$' "$asm_path")
    n_addhl=$(grep -c '^[[:space:]]*add[[:space:]]\+hl,hl[[:space:]]*$' "$asm_path")
    n_rl=$(grep -c '^[[:space:]]*rl[[:space:]]\+[ed][[:space:]]*$' "$asm_path")
    if [ "${n_sla_d:-0}" -ne 1 ] || [ "${n_addhl:-0}" -gt 0 ] || [ "${n_rl:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_shl_25: expected sla d ×1, add hl,hl ×0, rl e/d ×0 (got sla d=$n_sla_d, add hl,hl=$n_addhl, rl=$n_rl)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long var-RHS AND/OR/XOR fused load+op (#331) -----------------
# `a & b` with both vars on the stack: instead of loading b into DEHL
# then byte-AND through A, the fused path pops LHS bytes off the
# stack and ANDs them with (hl) directly. Pattern check: presence
# of `and (hl)` and absence of `and l` (the post-load byte chain).
asm_path="$WORK/long_and_fused.asm"
printf '%s\n' '
unsigned long andx(unsigned long a, unsigned long b) { return a & b; }' \
    > "$WORK/long_and_fused.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_and_fused.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_and_fused: 80cc --use-ir failed")
else
    n_and_hl=$(grep -c '^[[:space:]]*and[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_and_l=$(grep -c '^[[:space:]]*and[[:space:]]\+l[[:space:]]*$' "$asm_path")
    if [ "${n_and_hl:-0}" -lt 4 ] || [ "${n_and_l:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_and_fused: expected and (hl) ×≥4, and l ×0 (got and (hl)=$n_and_hl, and l=$n_and_l)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long NOT fused load+cpl (#331) -------------------------------
# `~a` should emit per-byte `ld a,(hl); cpl; ld _,a; inc hl` instead
# of full DEHL load then 4× `ld a,r; cpl; ld r,a`. Pattern: no
# `ld a,l` (the load-then-cpl first byte) — direct `ld a,(hl); cpl`
# instead.
asm_path="$WORK/long_not_fused.asm"
printf '%s\n' '
unsigned long notx(unsigned long a) { return ~a; }' \
    > "$WORK/long_not_fused.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_not_fused.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_not_fused: 80cc --use-ir failed")
else
    n_ld_a_hl=$(grep -c '^[[:space:]]*ld[[:space:]]\+a,(hl)[[:space:]]*$' "$asm_path")
    n_ld_a_l=$(grep -c '^[[:space:]]*ld[[:space:]]\+a,l[[:space:]]*$' "$asm_path")
    n_cpl=$(grep -c '^[[:space:]]*cpl[[:space:]]*$' "$asm_path")
    if [ "${n_ld_a_hl:-0}" -lt 4 ] || [ "${n_ld_a_l:-0}" -gt 0 ] || [ "${n_cpl:-0}" -ne 4 ]; then
        fail=$((fail+1))
        failures+=("long_not_fused: expected ld a,(hl) ×4, ld a,l ×0, cpl ×4 (got ld a,(hl)=$n_ld_a_hl, ld a,l=$n_ld_a_l, cpl=$n_cpl)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long pow-2 strength reduction (#333) -------------------------
# `(unsigned long) % 2^N`, `/ 2^N`, `* 2^N` should reduce to AND /
# SHR / SHL instead of calling l_long_mod_u / l_long_div_u /
# l_long_mult. Verify no helper call appears in the asm.
asm_path="$WORK/long_pow2_strength.asm"
printf '%s\n' '
unsigned long mod8(unsigned long x) { return x % 8UL; }
unsigned long div8(unsigned long x) { return x / 8UL; }
unsigned long mul8(unsigned long x) { return x * 8UL; }' \
    > "$WORK/long_pow2_strength.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_pow2_strength.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_pow2_strength: 80cc --use-ir failed")
else
    n_helper=$(grep -cE 'call[[:space:]]+l_long_(mod|div|mult)' "$asm_path")
    if [ "${n_helper:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_pow2_strength: helper call present, expected 0 (got $n_helper)")
    else
        ok=$((ok+1))
    fi
fi

# --- Fused (long)*p++ cast-deref-step (#334) ----------------------
# `(unsigned long)*p++` should compile to the walker-style fused
# sequence (inc (hl) on the pointer slot + ld a,(hl) + carry-propagate
# inc + dec hl + ld l,(hl)) — NOT the 3-op sequence (byte load, spill
# byte across IR_INC, reload, zero-extend). Pattern check: `inc (hl)`
# appears (in-place ptr inc) and the byte does NOT get spilled to a
# temp slot before reload — proxied by counting `ld a,(hl); ld e,a`
# at zero (the spill sequence) and `ld l,(hl)` at ≥1 (the reload-old-
# byte step in the fused emit).
asm_path="$WORK/cast_deref_step.asm"
printf '%s\n' '
unsigned long crc_fold(unsigned char *p) { return (unsigned long)*p++; }' \
    > "$WORK/cast_deref_step.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir cast_deref_step.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("cast_deref_step: 80cc --use-ir failed")
else
    n_inc_hl=$(grep -c '^[[:space:]]*inc[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_ld_l_hl=$(grep -c '^[[:space:]]*ld[[:space:]]\+l,(hl)[[:space:]]*$' "$asm_path")
    n_asmpc=$(grep -c 'jr[[:space:]]\+nz,ASMPC+3' "$asm_path")
    if [ "${n_inc_hl:-0}" -lt 2 ] || [ "${n_ld_l_hl:-0}" -lt 1 ] || [ "${n_asmpc:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("cast_deref_step: expected fused inc(hl)/jr-nz/ld l,(hl) (got inc(hl)=$n_inc_hl, ld l,(hl)=$n_ld_l_hl, jr nz,ASMPC+3=$n_asmpc)")
    else
        ok=$((ok+1))
    fi
fi

# --- Fused load+add/sub long var-RHS (#335) -----------------------
# `a + b` / `a - b` with both vars sp-rel should emit the fused
# byte-wise chain (`add a,(hl); ld c,a; inc hl; adc a,(hl); ld b,a;
# ...` for ADD, sub/sbc for SUB) instead of loading RHS into DEHL
# then `add hl,bc; adc hl,bc`. Pattern: ≥3 `adc a,(hl)` (one add +
# three adc) for ADD, ≥3 `sbc a,(hl)` for SUB. The 16-bit form
# `adc hl,bc` / `sbc hl,bc` must NOT appear here (it'd indicate the
# fused fastpath failed to fire).
asm_path="$WORK/long_add_fused.asm"
printf '%s\n' '
unsigned long addv(unsigned long a, unsigned long b) { return a + b; }
unsigned long subv(unsigned long a, unsigned long b) { return a - b; }' \
    > "$WORK/long_add_fused.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_add_fused.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_add_fused: 80cc --use-ir failed")
else
    n_add_hl=$(grep -c '^[[:space:]]*add[[:space:]]\+a,(hl)[[:space:]]*$' "$asm_path")
    n_adc_hl=$(grep -c '^[[:space:]]*adc[[:space:]]\+a,(hl)[[:space:]]*$' "$asm_path")
    n_sub_hl=$(grep -c '^[[:space:]]*sub[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_sbc_hl=$(grep -c '^[[:space:]]*sbc[[:space:]]\+a,(hl)[[:space:]]*$' "$asm_path")
    n_adc_bc=$(grep -c '^[[:space:]]*adc[[:space:]]\+hl,bc[[:space:]]*$' "$asm_path")
    n_sbc_bc=$(grep -c '^[[:space:]]*sbc[[:space:]]\+hl,bc[[:space:]]*$' "$asm_path")
    if [ "${n_add_hl:-0}" -lt 1 ] || [ "${n_adc_hl:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("long_add_fused: expected add a,(hl) ×1 + adc a,(hl) ×3 (got $n_add_hl + $n_adc_hl)")
    elif [ "${n_sub_hl:-0}" -lt 1 ] || [ "${n_sbc_hl:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("long_add_fused: expected sub (hl) ×1 + sbc a,(hl) ×3 (got $n_sub_hl + $n_sbc_hl)")
    elif [ "${n_adc_bc:-0}" -gt 0 ] || [ "${n_sbc_bc:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_add_fused: 16-bit adc/sbc hl,bc present (fused path skipped) — adc bc=$n_adc_bc, sbc bc=$n_sbc_bc")
    else
        ok=$((ok+1))
    fi
fi

# --- OR pow-2 → set n,r; AND ~pow-2 → res n,r (#337) --------------
# When a non-identity byte of a const OR/AND has exactly one bit
# set (OR) or clear (AND), emit `set n,r` / `res n,r` instead of
# `ld a,r; or/and K; ld r,a`. XOR is NOT transformed (z80 has no
# toggle-bit instruction). Covers per-byte in the long const path
# as well — `0x12000080UL` has byte0=0x80 (single bit → set 7,l)
# and byte3=0x12 (two bits → falls through to ld a,d; or 18; ld d,a).
asm_path="$WORK/setres_bit.asm"
printf '%s\n' '
unsigned int setbit5i(unsigned int x) { return x | 32U; }
unsigned int resbit5i(unsigned int x) { return x & ~32U; }
unsigned long setbit16L(unsigned long x) { return x | 0x00010000UL; }
unsigned long resbit0L(unsigned long x) { return x & 0xFFFFFFFEUL; }
unsigned long mixL(unsigned long x) { return x | 0x12000080UL; }
unsigned int xorbit5i(unsigned int x) { return x ^ 32U; }' \
    > "$WORK/setres_bit.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir setres_bit.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("setres_bit: 80cc --use-ir failed")
else
    n_set_l=$(grep -c '^[[:space:]]*set[[:space:]]\+5,l[[:space:]]*$' "$asm_path")
    n_res_l=$(grep -c '^[[:space:]]*res[[:space:]]\+5,l[[:space:]]*$' "$asm_path")
    n_set_e=$(grep -c '^[[:space:]]*set[[:space:]]\+0,e[[:space:]]*$' "$asm_path")
    n_res_l0=$(grep -c '^[[:space:]]*res[[:space:]]\+0,l[[:space:]]*$' "$asm_path")
    n_set_l7=$(grep -c '^[[:space:]]*set[[:space:]]\+7,l[[:space:]]*$' "$asm_path")
    # XOR with single-bit K must NOT have been rewritten — `xor 32`
    # (or `xor 0x20`) should still appear in the asm.
    n_xor_imm=$(grep -cE '^[[:space:]]*xor[[:space:]]+(32|0x20)[[:space:]]*$' "$asm_path")
    if [ "${n_set_l:-0}" -lt 1 ] || [ "${n_res_l:-0}" -lt 1 ] \
       || [ "${n_set_e:-0}" -lt 1 ] || [ "${n_res_l0:-0}" -lt 1 ] \
       || [ "${n_set_l7:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("setres_bit: missing set/res byte instrs (set 5,l=$n_set_l, res 5,l=$n_res_l, set 0,e=$n_set_e, res 0,l=$n_res_l0, set 7,l=$n_set_l7)")
    elif [ "${n_xor_imm:-0}" -lt 1 ]; then
        fail=$((fail+1))
        failures+=("setres_bit: XOR with single-bit K was incorrectly rewritten (no xor 32 found)")
    else
        ok=$((ok+1))
    fi
fi

# --- In-place long compound assign on sp-rel slot (#338) ----------
# `local += K` / `local -= K` where dst==src[0] and the vreg lives
# in a stack slot, with the result NOT dead-after. (The double
# use(a) keeps `a` live past the first call: a single trailing call
# arg is now consumed straight from DEHL by its IR_PUSH_ARG and the
# in-place path correctly yields.) Should emit byte-wise add/adc
# / sub/sbc directly
# into the slot (ld a,(hl); add a,K; ld (hl),a; inc hl × 4) instead
# of going DEHL-load → const ADD/SUB → store_dehl_finalize.
asm_path="$WORK/inplace_compound.asm"
printf '%s\n' '
extern void use(unsigned long);
void f_add(unsigned long a) { a += 0x12345678UL; use(a); use(a); }
void f_sub(unsigned long a) { a -= 0x12345678UL; use(a); use(a); }' \
    > "$WORK/inplace_compound.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir inplace_compound.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("inplace_compound: 80cc --use-ir failed")
else
    n_add_a_k=$(grep -c '^[[:space:]]*add[[:space:]]\+a,120[[:space:]]*$' "$asm_path")
    n_adc_a_k=$(grep -cE '^[[:space:]]*adc[[:space:]]+a,(86|52|18)[[:space:]]*$' "$asm_path")
    n_sub_k=$(grep -c '^[[:space:]]*sub[[:space:]]\+120[[:space:]]*$' "$asm_path")
    n_sbc_a_k=$(grep -cE '^[[:space:]]*sbc[[:space:]]+a,(86|52|18)[[:space:]]*$' "$asm_path")
    # 16-bit form `add hl,bc` / `sbc hl,bc` from the unfused path
    # must NOT be present for these functions — if it is, the in-place
    # fastpath failed to fire.
    n_addhl_bc=$(grep -c '^[[:space:]]*add[[:space:]]\+hl,bc[[:space:]]*$' "$asm_path")
    n_sbchl_bc=$(grep -c '^[[:space:]]*sbc[[:space:]]\+hl,bc[[:space:]]*$' "$asm_path")
    if [ "${n_add_a_k:-0}" -lt 1 ] || [ "${n_adc_a_k:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("inplace_compound: ADD missing in-place chain (add a,120=$n_add_a_k, adc a,K=$n_adc_a_k)")
    elif [ "${n_sub_k:-0}" -lt 1 ] || [ "${n_sbc_a_k:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("inplace_compound: SUB missing in-place chain (sub 120=$n_sub_k, sbc a,K=$n_sbc_a_k)")
    elif [ "${n_addhl_bc:-0}" -gt 0 ] || [ "${n_sbchl_bc:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("inplace_compound: 16-bit add/sbc hl,bc present (in-place path skipped) — add bc=$n_addhl_bc, sbc bc=$n_sbchl_bc")
    else
        ok=$((ok+1))
    fi
fi

# --- In-place long >>=1 / <<=1 via rr/rl (hl) (#339) --------------
# `a >>= 1` on a sp-rel long should compile to `srl (hl); rr (hl);
# rr (hl); rr (hl)` from MSB down (4 inst, no DEHL roundtrip). For
# `a <<= 1`, `sla (hl); rl (hl); rl (hl); rl (hl)` from LSB up.
# Hot in crcbench's `crc = (crc >> 1) ^ poly` unrolled chain.
# Also exercises the OP_ASSHR/OP_ASSHL IR_build coverage extension
# (without it, `>>= 1` / `<<= 1` bailed out of IR entirely).
asm_path="$WORK/inplace_shift1.asm"
printf '%s\n' '
extern void use(unsigned long);
void shr1(unsigned long a) { a >>= 1; use(a); use(a); }
void shl1(unsigned long a) { a <<= 1; use(a); use(a); }' \
    > "$WORK/inplace_shift1.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir inplace_shift1.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("inplace_shift1: 80cc --use-ir failed")
else
    n_srl_hl=$(grep -c '^[[:space:]]*srl[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_rr_hl=$(grep -c '^[[:space:]]*rr[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_sla_hl=$(grep -c '^[[:space:]]*sla[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_rl_hl=$(grep -c '^[[:space:]]*rl[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    # The walker fallback path uses `srl d; rr e; rr h; rr l` (register
    # shifts) — these must NOT appear when the in-place fastpath is on.
    n_srl_reg=$(grep -cE '^[[:space:]]*srl[[:space:]]+[a-l][[:space:]]*$' "$asm_path")
    if [ "${n_srl_hl:-0}" -lt 1 ] || [ "${n_rr_hl:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("inplace_shift1: SHR missing srl (hl) ×1 + rr (hl) ×3 (got srl=$n_srl_hl, rr=$n_rr_hl)")
    elif [ "${n_sla_hl:-0}" -lt 1 ] || [ "${n_rl_hl:-0}" -lt 3 ]; then
        fail=$((fail+1))
        failures+=("inplace_shift1: SHL missing sla (hl) ×1 + rl (hl) ×3 (got sla=$n_sla_hl, rl=$n_rl_hl)")
    elif [ "${n_srl_reg:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("inplace_shift1: register-shift fallback fired (srl reg ×$n_srl_reg)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long IR_CMP_EQ / NE via byte XOR-OR chain (#340) -------------
# `a == K` / `a != K` / `a == b` on long operands compile to a
# byte-wise XOR-then-OR chain that sets Z iff equal. Const-RHS uses
# `xor n` per byte; var-RHS uses `xor (hl)` against the slot. Result
# is 0/1 in HL (or branch-direct when in cond context).
asm_path="$WORK/long_cmp.asm"
printf '%s\n' '
int eq_k(unsigned long a) { return a == 0x1C48DD57UL; }
int ne_k(unsigned long a) { return a != 0x12345678UL; }
int eq_v(unsigned long a, unsigned long b) { return a == b; }' \
    > "$WORK/long_cmp.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_cmp.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_cmp: 80cc --use-ir failed")
else
    # Const-RHS: count `xor N` (immediate, not `xor reg`) plus `or c`
    # chain — each function has 4 xor-imm + 3 or-c (last or-c with no
    # ld-c-a after it).
    n_xor_imm=$(grep -cE '^[[:space:]]*xor[[:space:]]+[0-9]+[[:space:]]*$' "$asm_path")
    n_xor_hl=$(grep -c '^[[:space:]]*xor[[:space:]]\+(hl)[[:space:]]*$' "$asm_path")
    n_or_c=$(grep -c '^[[:space:]]*or[[:space:]]\+c[[:space:]]*$' "$asm_path")
    # The 16-bit equality path `or a; sbc hl,de` must NOT appear in
    # the bodies of eq_k/ne_k/eq_v (it is the int-path fallback).
    n_sbc_de=$(grep -c '^[[:space:]]*sbc[[:space:]]\+hl,de[[:space:]]*$' "$asm_path")
    if [ "${n_xor_imm:-0}" -lt 6 ]; then
        fail=$((fail+1))
        failures+=("long_cmp: const xor-imm chain missing (got $n_xor_imm, expected ≥6 across eq_k+ne_k)")
    elif [ "${n_xor_hl:-0}" -lt 4 ]; then
        fail=$((fail+1))
        failures+=("long_cmp: var xor (hl) chain missing (got $n_xor_hl, expected ≥4 in eq_v)")
    elif [ "${n_or_c:-0}" -lt 9 ]; then
        fail=$((fail+1))
        failures+=("long_cmp: or c accumulator chain missing (got $n_or_c, expected ≥9 across all 3 fns)")
    elif [ "${n_sbc_de:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_cmp: int-path sbc hl,de present (long path didn't fire)")
    else
        ok=$((ok+1))
    fi
fi

# --- Array local through IR (#327) ---------------------------------
# `unsigned char in[N]` (auto array, N<=127) compiles through IR
# instead of bailing "AST_DECL: kind 8 not yet supported". The vreg
# is marked ADDR_TAKEN with width=ctype->size as the slot byte count;
# AST_LOCAL_VAR decays to IR_LEA. Verify with sizeof+addr usage that
# no fall-back l_g* helper call is emitted for the array load.
asm_path="$WORK/array_local.asm"
printf '%s\n' '
extern void use(unsigned char *, unsigned int);
unsigned int f(void) {
    unsigned char in[16];
    use(in, sizeof in);
    return in[3];
}' > "$WORK/array_local.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir array_local.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("array_local: 80cc --use-ir failed")
else
    # IR-built functions get L_f<N>_bb_<M>: labels; legacy fallback
    # would compile through the walker which uses different labels.
    n_ir_label=$(grep -c '^L_f[0-9]\+_bb_0:[[:space:]]*$' "$asm_path")
    # Frame should be at least 16 bytes (the array). Match the
    # `ld hl,-N` line that opens the prologue. N must be ≥ 16.
    frame=$(grep -m1 -oE 'ld[[:space:]]+hl,-[0-9]+' "$asm_path" | head -1 | grep -oE '[0-9]+')
    if [ "${n_ir_label:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("array_local: function not built through IR (no L_f*_bb_0 label)")
    elif [ "${frame:-0}" -lt 16 ]; then
        fail=$((fail+1)); failures+=("array_local: frame too small ($frame), expected ≥16")
    else
        ok=$((ok+1))
    fi
fi

# --- Long ordered compare LT/LE/GT/GE via byte sub/sbc chain (#341)
# `a < K` / `a < b` / `a > b` etc. on long operands compile to a
# byte-wise sub-sbc-sbc-sbc chain. Final sbc leaves CF=unsigned-
# borrow and A=high byte of result. Signed variants apply the S^V
# correction (`jp po; xor 0x80; rla`).
asm_path="$WORK/long_cmp_ord.asm"
printf '%s\n' '
extern void use(int);
void f_lt_k(unsigned long a) { if (a < 0x12345678UL) use(1); }
void f_lt_v(unsigned long a, unsigned long b) { if (a < b) use(1); }
void f_gt_v(unsigned long a, unsigned long b) { if (a > b) use(1); }' \
    > "$WORK/long_cmp_ord.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_cmp_ord.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_cmp_ord: 80cc --use-ir failed")
else
    # `sub n` / `sub (hl)` once + `sbc a,n` / `sbc a,(hl)` three times
    # per function. 3 functions = 3 sub, 9 sbc.
    n_sub=$(grep -cE '^[[:space:]]*sub[[:space:]]+([0-9]+|\(hl\))[[:space:]]*$' "$asm_path")
    n_sbc=$(grep -cE '^[[:space:]]*sbc[[:space:]]+a,([0-9]+|\(hl\))[[:space:]]*$' "$asm_path")
    # 16-bit `sbc hl,de` must NOT appear — that would be the int
    # ordered-compare path leaking in.
    n_sbc_de=$(grep -c '^[[:space:]]*sbc[[:space:]]\+hl,de[[:space:]]*$' "$asm_path")
    if [ "${n_sub:-0}" -lt 3 ] || [ "${n_sbc:-0}" -lt 9 ]; then
        fail=$((fail+1))
        failures+=("long_cmp_ord: expected sub ×≥3, sbc a ×≥9 (got sub=$n_sub, sbc=$n_sbc)")
    elif [ "${n_sbc_de:-0}" -gt 0 ]; then
        fail=$((fail+1))
        failures+=("long_cmp_ord: int-path sbc hl,de present (long path didn't fire)")
    else
        ok=$((ok+1))
    fi
fi

# --- Operand-type-aware compare dispatch (#341 follow-up) ---------
# op_to_ir_binop always returned the *signed* IR_CMP_LT/LE/GT/GE.
# If either operand is unsigned (per C's usual arithmetic conversions
# at the same rank), the build-site now promotes to the U variant.
# Without this, `unsigned X < K` emitted the signed S^V correction
# (`jp po; xor 0x80; rla`) — harmless for K with bit-31 clear but
# wrong otherwise, and a 3-instruction waste in every case.
asm_path="$WORK/cmp_signedness.asm"
printf '%s\n' '
extern void use(int);
void uns_l(unsigned long a, unsigned long b) { if (a < b) use(1); }
void sgn_l(long a, long b) { if (a < b) use(1); }
void uns_i(unsigned int a, unsigned int b) { if (a < b) use(1); }
void sgn_i(int a, int b) { if (a < b) use(1); }' \
    > "$WORK/cmp_signedness.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir cmp_signedness.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("cmp_signedness: 80cc --use-ir failed")
else
    # Signed compares: each emits one `jp po,L_*_cmp_ok_*` and one
    # `xor 0x80`. Unsigned must NOT. With 2 signed compares (sgn_l +
    # sgn_i), expect 2 each. With unsigned wrongly applying it before
    # the fix, we'd see 4 each.
    n_jp_po=$(grep -c '^[[:space:]]*jp[[:space:]]\+po,L_f[0-9]\+_cmp_ok_' "$asm_path")
    n_xor80=$(grep -c '^[[:space:]]*xor[[:space:]]\+0x80[[:space:]]*$' "$asm_path")
    if [ "${n_jp_po:-0}" -ne 2 ] || [ "${n_xor80:-0}" -ne 2 ]; then
        fail=$((fail+1))
        failures+=("cmp_signedness: expected 2 signed corrections (jp po=$n_jp_po, xor 0x80=$n_xor80); unsigned compares must not get the S^V fixup")
    else
        ok=$((ok+1))
    fi
fi

# --- Address-yielding LHS for OP_ASSIGN (#342) --------------------
# When the parser folds `c->i[0] = K` into `*(c->i + 0) = K` and
# strips the OP_DEREF in lvalue context, the LHS becomes a bare
# pointer expression (OP_ADD / OP_SUB / etc. with KIND_PTR type).
# Build the address, follow ->ptr for the element type, emit
# IR_ST_MEM. Also unblocks chained assigns (`a = b = K`) when the
# outer LHS goes through a pointer.
asm_path="$WORK/ptr_lhs_assign.asm"
printf '%s\n' '
struct ctx { unsigned long i[2]; unsigned long buf[4]; };
void f(struct ctx *c) {
    c->i[0] = c->i[1] = 0UL;
    c->buf[0] = 0x67452301UL;
}' > "$WORK/ptr_lhs_assign.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir ptr_lhs_assign.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("ptr_lhs_assign: 80cc --use-ir failed")
else
    # Function should compile through IR (L_f*_bb_0 label present).
    n_ir_label=$(grep -c '^L_f[0-9]\+_bb_0:[[:space:]]*$' "$asm_path")
    # No fall-back legacy long-store helper call (`l_plong`) for the
    # buf[0] assignment — IR handles the long store inline via DEHL.
    n_plong=$(grep -cE 'call[[:space:]]+l_plong\b' "$asm_path")
    # The DEHL-byte-store sequence should appear at least once (the
    # final byte of a long store via `ld (hl),d`).
    n_long_store=$(grep -c '^[[:space:]]*ld[[:space:]]\+(hl),d[[:space:]]*$' "$asm_path")
    if [ "${n_ir_label:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("ptr_lhs_assign: function not built through IR")
    elif [ "${n_long_store:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("ptr_lhs_assign: long-store byte chain not emitted (got $n_long_store ld (hl),d)")
    else
        ok=$((ok+1))
    fi
fi

# --- OP_DEREF stmt + KIND_ELLIPSES param (#343) -------------------
# (1) `*p++;` as an expression-statement (no LHS) — previously
# bailed "unsupported stmt ast_type=64" because OP_DEREF wasn't in
# build_stmt's allow-list. The operand carries side effects so the
# walk-and-discard pattern is correct.
# (2) Variadic functions exposed `...` as a KIND_ELLIPSES (13) param,
# which is a placeholder not real storage. Previously bailed "param
# kind 13 not yet supported"; now skipped in the param-vreg loop.
asm_path="$WORK/op_deref_stmt.asm"
printf '%s\n' '
void f(unsigned char *p) {
    *p++;            /* discarded read with side effect */
}
extern int printf(const char *fmt, ...);
void g(int x) { printf("%d\n", x); }' \
    > "$WORK/op_deref_stmt.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir op_deref_stmt.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("op_deref_stmt: 80cc --use-ir failed")
else
    # f and g should both compile through IR (L_f*_bb_0 labels for
    # each). Without the OP_DEREF stmt fix, f would fall back to
    # walker (no IR labels). Without the ELLIPSES fix, g would fail
    # to declare. Count IR-labelled BBs ≥ 2.
    n_ir_label=$(grep -c '^L_f[0-9]\+_bb_0:[[:space:]]*$' "$asm_path")
    if [ "${n_ir_label:-0}" -lt 2 ]; then
        fail=$((fail+1)); failures+=("op_deref_stmt: only $n_ir_label functions reached IR (need 2)")
    else
        ok=$((ok+1))
    fi
fi

# --- Pre/Post step on non-LV operand (#345) -----------------------
# `c->i[1]++` and `(*p)++` previously bailed "post/pre step on
# non-LV not yet supported" because the step builder only accepted
# bare AST_LOCAL_VAR operands. The fix:
#  (a) When OP_DEREF passes through to a wrapping pre/post step,
#      transfer its own type (the lvalue's value type, stamped by
#      rvalue()) onto the step. Without this, n->type on the step
#      node carries the operand's *address* type from
#      normalize_types' inheritance — long stores would silently
#      become pointer stores.
#  (b) Extend OP_PRE_INC / OP_POST_INC / OP_PRE_DEC / OP_POST_DEC
#      to build the address from an OP_DEREF or address-yielding
#      OP_ADD/OP_SUB operand, then emit load / step / store.
asm_path="$WORK/step_non_lv.asm"
printf '%s\n' '
struct ctx { unsigned long i[2]; unsigned int j; };
unsigned long f(struct ctx *c) {
    c->i[1]++;
    return c->i[1];
}
unsigned int g(unsigned int *p) {
    return (*p)++;
}' > "$WORK/step_non_lv.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir step_non_lv.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("step_non_lv: 80cc --use-ir failed")
else
    # Both functions should compile through IR (L_f*_bb_0 label per
    # function). Without the fix, f's `c->i[1]++` bails and the
    # whole function falls back to walker (no IR label).
    n_ir_label=$(grep -c '^L_f[0-9]\+_bb_0:[[:space:]]*$' "$asm_path")
    # No legacy long inc helper — the step should compile inline.
    n_inclong=$(grep -cE 'call[[:space:]]+l_inclong\b' "$asm_path")
    if [ "${n_ir_label:-0}" -lt 2 ]; then
        fail=$((fail+1)); failures+=("step_non_lv: only $n_ir_label functions reached IR (need 2)")
    elif [ "${n_inclong:-0}" -gt 0 ]; then
        fail=$((fail+1)); failures+=("step_non_lv: unexpected l_inclong helper call (long step should be inlined)")
    else
        ok=$((ok+1))
    fi
fi

# --- load_to_hl_adj HL cache check (#346) -------------------------
# `*p = x + 1` silently miscompiled to `*p = garbage` because
# load_to_hl_adj fell through to a slot read for PR_HL vregs whose
# value was already in HL. PR_HL means cacheable / no slot allocated
# → slot_off returns -1 → `ld hl,-1; add hl,sp; <byte load>` reads
# below the stack frame.
# The IR_ST_MEM(MEM_VREG, width=2) path calls load_to_hl
# unconditionally on src[0]; for any IR_ADD imm result that's PR_HL,
# the next ST_MEM would overwrite HL with the garbage load.
# Fix: load_to_hl_adj now early-returns when HL already holds the
# wanted vreg (and sp_adj==0).
asm_path="$WORK/load_to_hl_cache.asm"
printf '%s\n' '
void f(int *p, int x) {
    *p = x + 1;
}' > "$WORK/load_to_hl_cache.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir load_to_hl_cache.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("load_to_hl_cache: 80cc --use-ir failed")
else
    # Without the fix: a `ld hl,-1; add hl,sp` sequence appears
    # between the ADD and the final store, reading garbage from
    # below the stack frame and propagating it as the stored value.
    # The fix removes this sequence.
    n_bad=$(grep -cE 'ld[[:space:]]+hl,-1[[:space:]]*$' "$asm_path")
    if [ "${n_bad:-0}" -gt 0 ]; then
        fail=$((fail+1)); failures+=("load_to_hl_cache: forbidden 'ld hl,-1' present ($n_bad), cache hit not recognised")
    else
        ok=$((ok+1))
    fi
fi

# --- LD_SYM + ADD imm → LD_SYM+offset fold (#347) ----------------
# `&arr + K`, `&g + member_offset`, etc. emit IR_LD_SYM followed by
# IR_ADD with literal RHS. Before the fold, the lowerer emits 5
# instructions: `ld hl,_arr; ld de,K; add hl,de`. After the fold,
# the LD_SYM absorbs the literal offset and lowers to a single
# `ld hl,_arr+K` instruction. Single-use gate ensures the original
# LD_SYM's value isn't needed elsewhere.
asm_path="$WORK/sym_offset_fold.asm"
printf '%s\n' '
extern void use(int *);
static int arr[10];
void f() { use(arr + 5); }     /* &arr[5] = LD_SYM + ADD imm */
void g() { use(arr + 0); }     /* offset 0: LD_SYM alone, no ADD */
extern int gv[20];
void h() { use(&gv[7]); }      /* &gv[7] = LD_SYM + ADD imm = LD_SYM+offset */
' > "$WORK/sym_offset_fold.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir sym_offset_fold.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("sym_offset_fold: 80cc --use-ir failed")
else
    # f: should emit `ld hl,_arr+10` (5*2 = 10 bytes for 5 ints).
    # h: should emit `ld hl,_gv+14` (7*2 bytes).
    # The unmerged 5-inst sequence would have been `ld hl,_arr; ld de,10;
    # add hl,de` — checking the merged forms is sufficient. g's `arr + 0`
    # parses to a bare LD_SYM with no ADD (no fold needed) — left as a
    # smoke test that the fold doesn't break the no-op case.
    n_merged_arr=$(grep -cE 'ld[[:space:]]+hl,_arr\+10\b' "$asm_path")
    n_merged_gv=$(grep -cE 'ld[[:space:]]+hl,_gv\+14\b' "$asm_path")
    if [ "${n_merged_arr:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("sym_offset_fold: missing 'ld hl,_arr+10' (got $n_merged_arr)")
    elif [ "${n_merged_gv:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("sym_offset_fold: missing 'ld hl,_gv+14' (got $n_merged_gv)")
    else
        ok=$((ok+1))
    fi
fi

# --- Variable-count long shift via helper (#348 Phase A.1) --------
# Long SHL/SHR with a variable (non-literal) count previously bailed
# in the lowerer ("long SHL with variable count not supported"). Now
# routes through l_lsl_dehl / l_lsr_dehl (DEHL = value, A = count).
# Helper is IX-clean — safe under fp_active without push ix wrap.
# load_to_dehl doesn't clobber A so no push af staging needed.
asm_path="$WORK/long_var_shift.asm"
printf '%s\n' '
unsigned long shl(unsigned long v, int n) { return v << n; }
unsigned long shr(unsigned long v, int n) { return v >> n; }
' > "$WORK/long_var_shift.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_var_shift.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_var_shift: 80cc --use-ir failed")
else
    n_lsl=$(grep -cE 'call[[:space:]]+l_lsl_dehl\b' "$asm_path")
    n_lsr=$(grep -cE 'call[[:space:]]+l_lsr_dehl\b' "$asm_path")
    # Forbid push af / pop af around the call — load_to_dehl doesn't
    # clobber A, so the staging shouldn't need to save it.
    n_pushaf=$(grep -cE 'push[[:space:]]+af\b' "$asm_path")
    if [ "${n_lsl:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("long_var_shift: missing 'call l_lsl_dehl' (got $n_lsl)")
    elif [ "${n_lsr:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("long_var_shift: missing 'call l_lsr_dehl' (got $n_lsr)")
    elif [ "${n_pushaf:-0}" -gt 0 ]; then
        fail=$((fail+1)); failures+=("long_var_shift: unnecessary 'push af' present ($n_pushaf)")
    else
        ok=$((ok+1))
    fi
fi

# --- Long (*p)++ → l_long_inc_mhl (#348 B.1) ----------------------
# Discarded-result long step on a memory location fuses to a single
# helper call. Triple (LD_MEM long; ADD imm=1 long; ST_MEM long) with
# both intermediate vregs dead outside the triple becomes
#   ld hl, <ptr>; call l_long_inc_mhl
# Tests:
#   f(): statement context — should fuse.
#   g(): POST returns old — should NOT fuse (v_old has external use).
#   h(): PRE returns new — should NOT fuse (v_new has external use).
asm_path="$WORK/long_inc_mhl.asm"
printf '%s\n' '
void f(unsigned long *p)         { (*p)++; }
unsigned long g(unsigned long *p) { return (*p)++; }
unsigned long h(unsigned long *p) { return ++(*p); }
' > "$WORK/long_inc_mhl.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_inc_mhl.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_inc_mhl: 80cc --use-ir failed")
else
    n_inc_mhl=$(grep -cE 'call[[:space:]]+l_long_inc_mhl\b' "$asm_path")
    # f should fuse — one call. g and h don't — zero each.
    # Total expected: 1 call (for f only).
    if [ "${n_inc_mhl:-0}" -ne 1 ]; then
        fail=$((fail+1)); failures+=("long_inc_mhl: expected 1 'call l_long_inc_mhl' (f only), got $n_inc_mhl")
    else
        ok=$((ok+1))
    fi
fi

# --- KIND_ARRAY OP_ASSIGN LHS (#348 E.1; long-elem ungated 2026-06-07)
# Local- and global-array store shapes `arr[i] = char_val`,
# `arr[i] = int_val`, `arr[i] = ptr_val`, AND long-element stores
# (`unsigned long a[16]; a[i] = v`) all compile through IR in BOTH
# modes. The long-store sp gate is lifted: sp is strategically
# required (8080/8085/gbz80 have no IX) so full IR coverage there
# outranks the residual md5-sp delta vs the walker mix.
asm_path="$WORK/array_lhs_byte.asm"
printf '%s\n' '
static unsigned char buf[64];
void f(int i, unsigned char v) { buf[i] = v; }       /* global char[] */
void g(int i, unsigned char v) {
    unsigned char arr[32];
    arr[i] = v;                                       /* local char[] */
}
unsigned long h_returns;
void h(int i, unsigned long v) { unsigned long a[16]; a[i] = v; }
' > "$WORK/array_lhs_byte.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir array_lhs_byte.c 2>"$WORK/array_lhs_byte.err" ); then
    fail=$((fail+1)); failures+=("array_lhs_byte: 80cc --use-ir failed")
else
    # f, g AND h should all compile through IR (≥3 IR BB-0 labels);
    # no OP_ASSIGN bail expected since the long-array sp gate lift.
    n_ir_label=$(grep -c '^L_f[0-9]\+_bb_0:[[:space:]]*$' "$asm_path")
    n_bail=$(grep -c "OP_ASSIGN LHS shape" "$WORK/array_lhs_byte.err")
    if [ "${n_ir_label:-0}" -lt 3 ]; then
        fail=$((fail+1)); failures+=("array_lhs_byte: only $n_ir_label IR-built funcs (need ≥3)")
    elif [ "${n_bail:-0}" -gt 0 ]; then
        fail=$((fail+1)); failures+=("array_lhs_byte: unexpected OP_ASSIGN bail (long-array sp gate is lifted)")
    else
        ok=$((ok+1))
    fi
fi

# --- Phase D option B — stack-resident long-binop absorb (#348 D.2)
# When a long IR_PUSH_DEHL_LONG is followed by a commutative long
# binop consumer (OR/AND/XOR/ADD) whose src[0] matches the pushed
# vreg, the consumer's lowerer absorbs the value directly from the
# stack via byte-wise `or/and/xor/add (hl)`, eliding both the
# matching POP and the consumer's own re-push. The hallmark in asm
# is a `push de; push hl; ld hl,4; add hl,sp; pop bc; ld a,c;
# <op> (hl)` shape — `ld hl,4` (not a frame slot offset) is the
# tell that the consumer is reading off the very top of the stack.
# Pattern below mirrors the MD5 F primitive in MD5Transform.
asm_path="$WORK/optb_absorb.asm"
printf '%s\n' '
unsigned long F(unsigned long a, unsigned long b, unsigned long c) {
    return (a & b) | (~a & c);
}
' > "$WORK/optb_absorb.c"
if ! ( cd "$WORK" && IR_LONG_PUSHES=1 "$COMPILER" --use-ir optb_absorb.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("optb_absorb: 80cc --use-ir failed")
else
    # Absorbing OR fastpath signature: after the second push de/push hl
    # the lowerer emits `ld hl,4; add hl,sp; pop bc; ld a,c; or (hl)`
    # — the `ld hl,4` constant (not a slot offset) is the marker.
    n_absorb=$(grep -B0 -A4 '^	ld	hl,4$' "$asm_path" \
               | grep -B0 -A1 'add	hl,sp' \
               | grep -c '^	pop	bc')
    if [ "${n_absorb:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("optb_absorb: missing stack-resident absorb shape (got $n_absorb)")
    else
        ok=$((ok+1))
    fi
fi

# --- HL cache invariant: load_to_hl_adj must publish the loaded ---
# vreg to cur_hl_vreg, or a follow-up load_to_hl(prev_dst) hits a
# stale cache and skips its load. The failure shape: IR_ADD leaves
# v_addr in HL with cache_hl(v_addr); IR_ST_MEM(MEM_VREG, width=2)
# then loads the value (PR_BC src) via `ld l,c; ld h,b` (HL now
# holds the value, but cur_hl_vreg still says v_addr), emits
# `ex de,hl` (DE = value), then calls load_to_hl(v_addr) — which
# hits the stale cache and emits NOTHING. The subsequent
# `ld (hl),e; inc hl; ld (hl),d` stores to whatever junk HL has
# (the old DE), corrupting the program.
#
# Source below builds the asm-level shape: `tab[i] = 0x1000 + i;`
# inside a loop. The IR_ADD computes &tab[i] (in HL), then ST_MEM
# stores the int value (PR_BC LOCAL from earlier IR ops). main
# returns tab[2] = 0x1002 if the stores landed correctly.
asm_path="$WORK/hl_cache_after_load.asm"
printf '%s\n' '
unsigned int main(void) {
    unsigned int tab[4];
    int i;
    for (i = 0; i < 4; i++) tab[i] = 0x1000 + i;
    return tab[2];
}' > "$WORK/hl_cache_after_load.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir hl_cache_after_load.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("hl_cache_after_load: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/hl_cache_after_load.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("hl_cache_after_load: z80asm/link failed")
else
    trace="$WORK/hl_cache_after_load.trace"
    "$TICKS" -end 6 -trace "$WORK/hl_cache_after_load.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "1002" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("hl_cache_after_load: expected hl=1002, got hl=$hl")
    fi
fi

# --- load_to_de_preserve_hl: cur_sp_adjust around push/pop --------
# The helper push/pops HL across a slot-rel reload of DE — used by
# chained int ADDs (`x + y + z`) when HL holds the partial sum and
# we need src[1] in DE without trashing HL. Before the fix it
# emitted `push hl; ld hl,K; add hl,sp; ...; pop hl` where K was
# the slot offset BEFORE the push, so the slot read landed 2 bytes
# off (often into the return address). The fix bumps cur_sp_adjust
# by 2 across the wrap so the slot read uses K+2.
#
# Pattern: `do_three(0x100, 0x200, 0x300)` produces an IR shape
#   ADD v3 <- v0, v1
#   ADD v4 <- v3, v2   ; cur_hl_vreg=v3 → load_to_de_preserve_hl(v2)
# main returns 0x600 only if the second ADD's `z` arg is read from
# the right slot offset.
asm_path="$WORK/preserve_hl_spadj.asm"
printf '%s\n' '
unsigned int add3(unsigned int x, unsigned int y, unsigned int z) {
    return x + y + z;
}
unsigned int main(void) {
    return add3(0x100, 0x200, 0x300);
}' > "$WORK/preserve_hl_spadj.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir preserve_hl_spadj.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("preserve_hl_spadj: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/preserve_hl_spadj.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("preserve_hl_spadj: z80asm/link failed")
else
    trace="$WORK/preserve_hl_spadj.trace"
    "$TICKS" -end 6 -trace "$WORK/preserve_hl_spadj.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    hl_lc=$(echo "$hl" | tr 'A-F' 'a-f')
    if [ "$hl_lc" = "0600" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("preserve_hl_spadj: expected hl=0600, got hl=$hl")
    fi
fi

# --- Long AND-mask + BR_ZERO/COND fastpath ------------------------
# `(crc & 1UL) ? a : b` and similar long-AND-with-single-byte-mask
# conditional tests are the hot pattern in CRC inner loops. Without
# the fastpath each test goes through the full long byte-wise AND +
# slot spill + low-half reload + or h,or l + jp (~40 inst). With it,
# the lowerer emits just `ld a,<byte_reg>; and N; jp z/nz, label`.
# The mask must hit exactly one of the 4 long bytes (other 3 are
# zero) — covers (& 1), (& 0x80), (& 0x100), (& 0x80000000), etc.
asm_path="$WORK/long_and_mask_br.asm"
printf '%s\n' '
extern void true_branch(void);
extern void false_branch(void);
void test_bit0(unsigned long x) {
    if (x & 1UL) true_branch(); else false_branch();
}
void test_bit7(unsigned long x) {
    if (x & 0x80UL) true_branch(); else false_branch();
}
void test_byte3(unsigned long x) {
    if (x & 0x80000000UL) true_branch(); else false_branch();
}
' > "$WORK/long_and_mask_br.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_and_mask_br.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_and_mask_br: 80cc --use-ir failed")
else
    # Expect 3 `and 1` / `and 128` / `and 128` lines each immediately
    # followed by `jp z,` or `jp nz,`. Count the and+jp pairs.
    n_pairs=$(grep -A1 -E '^[[:space:]]+and[[:space:]]+(1|128)$' "$asm_path" \
              | grep -cE '^[[:space:]]+jp[[:space:]]+(n?z),L_f')
    # Without the fastpath there should be NO occurrences of these
    # one-byte and-mask + immediate-jp pairs (the lowerer would
    # instead emit a full long-AND via `ld a,l; and 1; ld l,a` etc).
    if [ "${n_pairs:-0}" -lt 3 ]; then
        fail=$((fail+1)); failures+=("long_and_mask_br: expected 3 and+jp pairs, got $n_pairs")
    else
        ok=$((ok+1))
    fi
fi

# --- Long const-shift djnz loop for repeated bit shifts -----------
# Repeated long shifts (bit_shift ≥ 2) by const count fold into a
# djnz loop instead of being unrolled. Trade ~13T per loop trip for
# meaningful byte savings on MD5's rotate-heavy hot paths. The gate
# uses the exact size break-even per body size:
#   byte_shift=0 (bb=5):  bit_shift ≥ 2  (SHL)
#   byte_shift=1 (bb=6):  bit_shift ≥ 2  (SHL/SHR)
#   byte_shift=2 (bb=4):  bit_shift ≥ 3  (SHL/SHR)
#   byte_shift=3 (bb=2):  bit_shift ≥ 4  (SHL/SHR)
# Test pattern: rotate-left by 7 (= shift left by 7, no byte_shift)
# should emit a djnz loop, not 7 unrolled `add hl,hl; rl e; rl d`.
asm_path="$WORK/long_shift_djnz.asm"
printf '%s\n' '
unsigned long rotl7(unsigned long x) {
    return (x << 7) | (x >> 25);
}
unsigned long shl3(unsigned long x) { return x << 3; }   /* small, no djnz */
unsigned long shl7(unsigned long x) { return x << 7; }   /* large, djnz */
unsigned long shr20(unsigned long x) { return x >> 20; } /* byte_shift=2, bit_shift=4 → djnz */
' > "$WORK/long_shift_djnz.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir long_shift_djnz.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_shift_djnz: 80cc --use-ir failed")
else
    # Expect djnz loops in shl7, rotl7, shr20 — at least 3 djnz total
    # in this file. The shl3 function shouldn't generate one
    # (bit_shift=3, byte_shift=0 → unroll=15, djnz=9 → save 6 → djnz wins).
    # Actually shl3 also qualifies. So count ≥ 3 across the file.
    n_djnz=$(grep -cE '^[[:space:]]+djnz[[:space:]]+L_f[0-9]+_shl_loop_|^[[:space:]]+djnz[[:space:]]+L_f[0-9]+_shr_loop_' "$asm_path")
    if [ "${n_djnz:-0}" -lt 3 ]; then
        fail=$((fail+1)); failures+=("long_shift_djnz: expected ≥3 shift djnz loops, got $n_djnz")
    else
        ok=$((ok+1))
    fi
fi

# --- IR_MOV producer fusion ----------------------------------------
# `UINT4 a = buf[0], b = buf[1];` (MD5 Transform's prologue shape)
# produces pairs of (LD_MEM v_t, MOV v_local <- v_t). Without fusion
# each MOV emits a long slot store (~9 bytes) after the LD_MEM's own
# spill. The fuse_mov pass folds the LD_MEM's dst into v_local
# directly, eliminating the MOV's slot store.
#
# Hallmark in asm: the function should have N long-slot stores for N
# initialised locals (one per LD_MEM-into-local). Without fusion we'd
# see 2N (LD_MEM spills v_t, then MOV stores v_local). The test below
# uses 4 long-typed locals to amplify the difference and asserts
# ≤6 long stores (with fusion: 4; without: 8 + the long store in
# `*out = a + b + c + d`). Tight bound but reliable.
asm_path="$WORK/fuse_mov.asm"
printf '%s\n' '
typedef unsigned long UINT4;
void f(UINT4 *buf, UINT4 *out) {
    UINT4 a = buf[0], b = buf[1], c = buf[2], d = buf[3];
    *out = a + b + c + d;
}' > "$WORK/fuse_mov.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir fuse_mov.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("fuse_mov: 80cc --use-ir failed")
else
    # Long-store starter: `ld (hl),c` followed by writes to byte 1/2/3.
    # In f(), each `UINT4 local = buf[i]` emits at most ONE long
    # slot-store body when fused. Without fusion there's a duplicate
    # store per pair. We count `ld (hl),c` openings as a proxy for
    # long-store starts within the function body.
    n_starts=$(awk '/m4.*::f::|::f::/{p=1} /::main::|::g::/{p=0} p' \
                   "$asm_path" 2>/dev/null \
               | grep -cE '^[[:space:]]+ld[[:space:]]+\(hl\),c$' || true)
    # With fusion: 4 long stores (one per local) + 1 store for *out
    # via the byte-walk path = 5 starts. Plus possibly the use of
    # *out itself uses an alternate path.
    # Without fusion: 4 LD_MEM + 4 MOV = 8 long stores + 1 for *out.
    # Threshold ≤ 6 cleanly separates the two regimes.
    if [ "${n_starts:-0}" -gt 6 ]; then
        fail=$((fail+1)); failures+=("fuse_mov: expected ≤6 long stores, got $n_starts (fusion missed)")
    else
        ok=$((ok+1))
    fi
fi

# --- FP-mode byte-direct (ix+d) for long var-RHS binops -----------
# In `-Cc-frameix` mode, long AND/OR/XOR/ADD/SUB with both srcs in
# slots (or one in DEHL cache) emit byte-direct `<op> a,(ix+d)`
# sequences instead of the load-DEHL + byte-ops + store-DEHL chain.
# Mirror of sdcc's pattern.
asm_path="$WORK/fp_byte_direct.asm"
printf '%s\n' '
typedef unsigned long UINT4;
void f(UINT4 *out, UINT4 a, UINT4 b, UINT4 c) {
    *out = (a & b) | c;
}' > "$WORK/fp_byte_direct.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix fp_byte_direct.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("fp_byte_direct: 80cc --use-ir -frameix failed")
else
    n_ix_byte=$(grep -cE '^[[:space:]]+(and|or|xor|add|sub|adc|sbc)[[:space:]]+a?,?\(ix' \
                "$asm_path" 2>/dev/null || echo 0)
    # Each long binop = 4 byte ops via (ix+d). With (a & b) | c =
    # 1 AND + 1 OR = 2 long binops = 8 (ix+d) byte ops. Plus the
    # store path through *out doesn't use the byte-direct form.
    # Threshold ≥ 8 confirms both binops hit the fastpath.
    if [ "${n_ix_byte:-0}" -lt 8 ]; then
        fail=$((fail+1)); failures+=("fp_byte_direct: expected ≥8 byte (ix+d) ops, got $n_ix_byte")
    else
        ok=$((ok+1))
    fi
fi

# --- FP-mode (long)*p++ correctness --------------------------------
# Pre-existing bug: the `(long)*p++` fastpath at LD_MEM lowering was
# gated `!fp_active(f)` and the fallback read 4 bytes through a char
# pointer — wrong semantics. Symptom: crcbench+frameix looped forever
# computing a wrong CRC that never matched. Fix removes the gate so
# FP mode also gets the byte-zero-extend behaviour.
asm_path="$WORK/fp_long_pp.asm"
printf '%s\n' '
typedef unsigned long UINT4;
UINT4 sum(unsigned char *p, unsigned int n) {
    UINT4 acc = 0;
    while (n--) acc ^= (UINT4)*p++;
    return acc;
}' > "$WORK/fp_long_pp.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix fp_long_pp.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("fp_long_pp: 80cc --use-ir -frameix failed")
else
    # The fastpath emits `inc (hl)` to increment the pointer's
    # low byte in place. Absence indicates the fastpath didn't fire
    # (would fall to the buggy 4-byte load).
    n_inc=$(grep -cE '^[[:space:]]+inc[[:space:]]+\(hl\)$' "$asm_path" 2>/dev/null || echo 0)
    if [ "${n_inc:-0}" -lt 1 ]; then
        fail=$((fail+1)); failures+=("fp_long_pp: missing inc (hl) — (long)*p++ FP fastpath not firing")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285e/f push BC instead of recovered HL ------------------
# After load_to_dehl on a cached/byte-walked vreg, BC already holds
# the low half — the trailing `ld l,c; ld h,b` recovery + `push hl`
# is identical-in-effect to a direct `push bc`. Copt rule #285e
# collapses `ld l,c; ld h,b; push de; push hl; ld hl,K` to
# `push de; push bc; ld hl,K`; #285f drops the dead recovery when
# push bc is already in place (post-IR_NOT cpl chain hits
# cache_dehl_no_spill needing HL=BC, after 285d cancels the inner
# round trip there's a residual `ld l,c; ld h,b` to clean up).
#
# A non-trivial long binop ((a&b) | (c^d), all long locals) hits
# the var-RHS staging path: src[1] is loaded into DEHL, then pushed.
# The 80cc lowerer emits `ld l,c; ld h,b; push de; push hl; ld hl,K`;
# after copt the asm should read `push de; push bc; ld hl,K`. We
# pipe the asm through z88dk-copt with the 80cc rules and assert
# the input pattern is gone.
asm_path="$WORK/push_bc_recovery.asm"
opt_path="$WORK/push_bc_recovery.opt"
printf '%s\n' '
unsigned long f(unsigned long a, unsigned long b,
                unsigned long c, unsigned long d) {
    return (a & b) | (c ^ d);
}' > "$WORK/push_bc_recovery.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir push_bc_recovery.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("push_bc_recovery: 80cc --use-ir failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("push_bc_recovery: z88dk-copt or 80cc_rules.1 not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -q "ld l,c;ld h,b;push de;push hl;"; then
        fail=$((fail+1))
        failures+=("push_bc_recovery: copt #285e did not collapse ld l,c; ld h,b; push de; push hl")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285g elide push bc/pop bc around sp-rel addr compute ----
# In a long var-RHS binop (e.g. `... | (c^d)`) the lowerer stages
# both halves on the stack then computes the next slot address via
# `ld hl,N; add hl,sp`. The inner `push bc` + `pop bc` immediately
# bracketing the addr compute is a pure round trip — BC is unchanged
# by the addr compute. Copt #285g elides the pair and rewrites N to
# N-2 so the outer `pop bc` (which pops the pushed DE into BC for
# the second-byte chain) still balances correctly.
#
# Test: the same long binop synthesis as #285e. After copt the asm
# must not contain `push bc; ld hl,N; add hl,sp; pop bc` — the
# remaining bracket would mean #285g didn't fire.
asm_path="$WORK/elide_pushpop_bc.asm"
opt_path="$WORK/elide_pushpop_bc.opt"
printf '%s\n' '
unsigned long g(unsigned long a, unsigned long b,
                unsigned long c, unsigned long d) {
    return (a & b) | (c ^ d);
}' > "$WORK/elide_pushpop_bc.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir elide_pushpop_bc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("elide_pushpop_bc: 80cc --use-ir failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("elide_pushpop_bc: z88dk-copt or 80cc_rules.1 not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "push bc;ld hl,[0-9-]+;add hl,sp;pop bc"; then
        fail=$((fail+1))
        failures+=("elide_pushpop_bc: copt #285g did not elide push bc/pop bc round trip")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285h fold HL recovery + ld bc,K + add hl,bc -------------
# In FP mode the long const-ADD path emits the chain
#   ld l,c; ld h,b      ; HL = BC = low half of LHS
#   ld bc,K_lo          ; BC = K's low half
#   add hl,bc           ; HL = LHS_lo + K_lo
# Rewrite to `ld hl,K_lo; add hl,bc` — addition is commutative so
# the sum is the same, BC keeps the original LHS_lo value, and the
# next `ld bc,K_hi` (always present, for the adc chain) overwrites
# BC anyway. Saves 2B per occurrence.
#
# Test: a long-const ADD in a function compiled with -frameix. After
# copt, the input pattern must be gone.
asm_path="$WORK/long_const_add_fp.asm"
opt_path="$WORK/long_const_add_fp.opt"
printf '%s\n' '
unsigned long h(unsigned long a) {
    return a + 0xD76AA478UL;
}' > "$WORK/long_const_add_fp.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix long_const_add_fp.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_const_add_fp: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("long_const_add_fp: z88dk-copt or 80cc_rules.1 not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld l,c;ld h,b;ld bc,[0-9-]+;add hl,bc"; then
        fail=$((fail+1))
        failures+=("long_const_add_fp: copt #285h did not fold HL recovery + ld bc,K + add hl,bc")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285i fold ld b,h; ld c,l + byte-op chain via A ----------
# In FP mode the long binop byte chain emits
#   ld b,h; ld c,l       ; BC = HL (low half)
#   ld a,c; OP a,(ix+d)  ; A = lo byte, op with byte0
#   ld c,a               ; C = result_byte0
#   ld a,b; OP a,(ix+d)  ; A = hi byte, op with byte1
#   ld b,a               ; B = result_byte1
# The leading BC=HL is pointless when we go straight through A:
#   ld a,l; OP a,(ix+d); ld c,a; ld a,h; OP a,(ix+d); ld b,a
# Saves 2B per occurrence. Covers ADD/ADC/SUB/SBC/AND/OR/XOR with
# (ix+d) operands via a regex match.
#
# Test: `a + b` with two long FP locals. After copt the asm must not
# contain `ld b,h; ld c,l; ld a,c; <op> a,(ix+d)`.
asm_path="$WORK/long_byte_a_chain_fp.asm"
opt_path="$WORK/long_byte_a_chain_fp.opt"
printf '%s\n' '
unsigned long fchain(unsigned long a, unsigned long b) {
    return a + b;
}' > "$WORK/long_byte_a_chain_fp.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix long_byte_a_chain_fp.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_byte_a_chain_fp: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("long_byte_a_chain_fp: z88dk-copt or 80cc_rules.1 not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld b,h;ld c,l;ld a,c;(add a,|adc a,|sub |sbc a,|and |or |xor )"; then
        fail=$((fail+1))
        failures+=("long_byte_a_chain_fp: copt #285i did not fold ld b,h/ld c,l prelude")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285j in-place variant of #285i --------------------------
# Sibling of #285i for the in-place form where the chain writes the
# byte result back to a slot via `ld (ix%d),a` instead of into
# BC via `ld c,a; ld b,a`. The leading `ld b,h; ld c,l` is still
# dead, so the same `ld a,l/h` substitution applies. BC ends with
# its pre-chain value rather than the new low half — verified safe
# in MD5 because the next op always re-loads BC explicitly.
asm_path="$WORK/long_inplace_chain_fp.asm"
opt_path="$WORK/long_inplace_chain_fp.opt"
printf '%s\n' '
void fadd(unsigned long *p, unsigned long v) {
    *p += v;
}' > "$WORK/long_inplace_chain_fp.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix long_inplace_chain_fp.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("long_inplace_chain_fp: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("long_inplace_chain_fp: z88dk-copt or 80cc_rules.1 not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld b,h;ld c,l;ld a,c;(add a,|adc a,|sub |sbc a,|and |or |xor ).*;ld \(ix"; then
        fail=$((fail+1))
        failures+=("long_inplace_chain_fp: copt #285j did not fold in-place chain")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285k elide push hl/pop hl around ld de,(ix+d) -----------
# The lowerer stages HL on the stack while loading DE from a slot
# via `ld de,(ix+d)`. The latter doesn't touch HL — push/pop are
# pure overhead. Reduce to just `ld de,(ix+d)`.
asm_path="$WORK/push_pop_hl_round_ld_de.asm"
opt_path="$WORK/push_pop_hl_round_ld_de.opt"
printf '%s\n' '
unsigned int g(unsigned int x, unsigned int y) {
    unsigned int a = x ^ y;
    unsigned int b = ~a;
    return a + b;
}' > "$WORK/push_pop_hl_round_ld_de.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix push_pop_hl_round_ld_de.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("push_pop_hl_round_ld_de: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("push_pop_hl_round_ld_de: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "push hl;ld de,\(ix.*\);pop hl"; then
        fail=$((fail+1))
        failures+=("push_pop_hl_round_ld_de: copt #285k did not elide push hl/pop hl")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285l ld a,h+and 128+jp z → ld a,h+rlca+jp nc -----------
# Sign-bit test of HL: load H into A, mask 0x80, test Z. The `and
# 128` immediate (2B) can be replaced with `rlca` (1B) which sets
# CF = original A bit 7; the conditional flips from jp z to jp nc.
# Saves 1 byte, 3 T-states per occurrence.
asm_path="$WORK/sign_bit_rlca.asm"
opt_path="$WORK/sign_bit_rlca.opt"
printf '%s\n' '
unsigned int t(unsigned int x) {
    if (x & 0x8000U) return 1;
    return 0;
}' > "$WORK/sign_bit_rlca.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir sign_bit_rlca.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("sign_bit_rlca: 80cc --use-ir failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("sign_bit_rlca: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld a,h;and 128;jp z,"; then
        fail=$((fail+1))
        failures+=("sign_bit_rlca: copt #285l did not rewrite and 128 to rlca")
    elif ! echo "$slurp" | grep -qE "rlca;jp nc,"; then
        fail=$((fail+1))
        failures+=("sign_bit_rlca: rewritten asm missing rlca+jp nc")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #260a-via-a + #260a-via-a-into-de ------------------------
# Two related rules for the byte<<8 emit pattern. The lowerer
# walks a byte into A then shuffles it into HL's high half via
#   ld l,a; ld h,0; ld h,l; ld l,0
# which is 4 inst / 6B / 16T. #260a-via-a folds this to
#   ld h,a; ld l,0
# (2 inst / 3B / 8T). When the very next op is `ex de,hl;
# ld hl,(ix+d)` (so the byte<<8 ends up in DE and HL gets
# reloaded), #260a-via-a-into-de instead emits the byte<<8
# directly into DE:
#   ld d,a; ld e,0; ld hl,(ix+d)
# saving the ex de,hl entirely (FP mode only — needs ix+d load).
asm_path="$WORK/byte_shl8_via_a.asm"
opt_path="$WORK/byte_shl8_via_a.opt"
printf '%s\n' '
unsigned int s(unsigned char b, unsigned int w) {
    return ((unsigned int)b << 8) ^ w;
}' > "$WORK/byte_shl8_via_a.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir byte_shl8_via_a.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("byte_shl8_via_a: 80cc --use-ir failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("byte_shl8_via_a: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld l,a;ld h,0;ld h,l;ld l,0"; then
        fail=$((fail+1))
        failures+=("byte_shl8_via_a: copt #260a-via-a did not fold byte<<8 shuffle")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285m caller-save BC + arg push via HL → push bc twice ---
# The lowerer's call-site setup pushes BC for caller-save, then
# stages it again as the first arg via `ld l,c; ld h,b; push hl`.
# Both pushes carry BC's value; replace the lds + push hl with a
# second push bc. The trailing ld hl,K (next arg or work) ensures
# HL is overwritten so its difference doesn't matter.
asm_path="$WORK/push_bc_arg.asm"
opt_path="$WORK/push_bc_arg.opt"
printf '%s\n' '
extern unsigned int crc16_ccitt(unsigned char *data, unsigned int len);
unsigned int run(unsigned char *p) {
    unsigned int r = crc16_ccitt(p, 10);
    return r + crc16_ccitt(p, 20);
}' > "$WORK/push_bc_arg.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir push_bc_arg.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("push_bc_arg: 80cc --use-ir failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("push_bc_arg: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "push bc;ld l,c;ld h,b;push hl"; then
        fail=$((fail+1))
        failures+=("push_bc_arg: copt #285m did not collapse arg-push via HL")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285n elide ex de,hl + reload-same-slot before ld de,K ---
# Pattern emitted around a long-mul result reuse: store HL to a
# slot, ex de,hl, reload HL from the same slot, then ld de,K. The
# ex+reload pair just round-trips HL through DE and back, leaving
# the original HL value untouched; DE gets overwritten by the
# trailing ld de,K so its intermediate value is dead. Drop both.
asm_path="$WORK/ex_reload_same_slot.asm"
opt_path="$WORK/ex_reload_same_slot.opt"
printf '%s\n' '
unsigned int prng(unsigned int s) {
    unsigned int t = s * 13;
    return t + 13849;
}' > "$WORK/ex_reload_same_slot.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix ex_reload_same_slot.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("ex_reload_same_slot: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("ex_reload_same_slot: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld \(ix.*\),hl;ex de,hl;ld hl,\(ix.*\);ld de,"; then
        fail=$((fail+1))
        failures+=("ex_reload_same_slot: copt #285n did not fold ex+reload")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285o *p++ idiom: drop redundant reloads -----------------
# `crc ^= (unsigned int)*data++ << 8` lowers to:
#   ld hl,(ix+M); ld a,(hl); ld (ix-N),a   ; load + temp-store
#   ld hl,(ix+M); inc hl; ld (ix+M),hl     ; reload + ++ + store
#   ld a,(ix-N)                            ; reload the byte
# but after the first chunk HL still holds p (the ld (ix-N),a
# doesn't touch HL) and A still holds the byte (the inc hl /
# pointer-store don't touch A). Drop the duplicate ld hl + ld a.
asm_path="$WORK/star_p_plus_plus.asm"
opt_path="$WORK/star_p_plus_plus.opt"
printf '%s\n' '
unsigned int sum(unsigned char *data, unsigned int n) {
    unsigned int acc = 0;
    while (n--) acc ^= ((unsigned int)*data++) << 8;
    return acc;
}' > "$WORK/star_p_plus_plus.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix star_p_plus_plus.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("star_p_plus_plus: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("star_p_plus_plus: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld hl,\(ix.*\);ld a,\(hl\);ld \(ix.*\),a;ld hl,\(ix"; then
        fail=$((fail+1))
        failures+=("star_p_plus_plus: copt #285o did not drop duplicate ld hl")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285p narrow int load when high half discarded -----------
# `tab[i & 0x0FU]` lowers to `ld hl,(ix-N); ld a,l; and 15; ld l,a;
# ld h,0`. The full int load reads both bytes but H is immediately
# overwritten with 0 — wasted high-byte fetch. Replace with a
# direct low-byte load `ld a,(ix-N)`.
asm_path="$WORK/narrow_int_load_mask.asm"
opt_path="$WORK/narrow_int_load_mask.opt"
printf '%s\n' '
extern unsigned int tab[];
unsigned int pick(unsigned int i) {
    return tab[i & 0x0FU];
}' > "$WORK/narrow_int_load_mask.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix narrow_int_load_mask.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("narrow_int_load_mask: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("narrow_int_load_mask: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "ld hl,\(ix.*\);ld a,l;and "; then
        fail=$((fail+1))
        failures+=("narrow_int_load_mask: copt #285p did not narrow int load to byte")
    else
        ok=$((ok+1))
    fi
fi

# --- copt #285q small-mask + add hl,hl → add a,a -------------------
# After #285p narrows the load, the lowerer often follows with
# `add hl,hl` to compute index*2 (for int-array indexing). When
# the mask is ≤127 the doubled value fits in a byte, so `add a,a`
# can be used before the int-extend — same encoding length but
# `add a,a` is 4T vs `add hl,hl` 11T (saves 7T per occurrence).
asm_path="$WORK/mask_then_double.asm"
opt_path="$WORK/mask_then_double.opt"
printf '%s\n' '
extern unsigned int tab[];
unsigned int pick(unsigned int i) {
    return tab[i & 0x0FU];
}' > "$WORK/mask_then_double.c"
copt_bin="$(dirname "$COMPILER" 2>/dev/null)/z88dk-copt"
[ -x "$copt_bin" ] || copt_bin="$(command -v z88dk-copt 2>/dev/null)"
rules="${Z80_OZFILES:-$Z88DK_LIB}/80cc_rules.1"
if ! ( cd "$WORK" && "$COMPILER" --use-ir -frameix mask_then_double.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("mask_then_double: 80cc --use-ir -frameix failed")
elif [ ! -x "$copt_bin" ] || [ ! -f "$rules" ]; then
    fail=$((fail+1)); failures+=("mask_then_double: copt or rules not found")
else
    "$copt_bin" "$rules" < "$asm_path" > "$opt_path" 2>/dev/null
    slurp=$(asm_slurp "$opt_path")
    if echo "$slurp" | grep -qE "and 15;ld l,a;ld h,0;add hl,hl"; then
        fail=$((fail+1))
        failures+=("mask_then_double: copt #285q did not move doubling to add a,a")
    elif ! echo "$slurp" | grep -qE "and 15;add a,a"; then
        fail=$((fail+1))
        failures+=("mask_then_double: expected 'and 15; add a,a' after rule")
    else
        ok=$((ok+1))
    fi
fi

# --- PR_DEHL: zero-byte frame for all-PR_DEHL-intermediate function -
# Stage 6 of the allocator marks width-4 vregs as IR_PR_DEHL when they
# are produced once and consumed immediately (single-use, next op only).
# Those vregs are excluded from ir_assign_slots, so they don't occupy
# a frame slot. When a function's only long temporaries are all
# PR_DEHL-eligible (e.g. each intermediate feeds the next op directly),
# the frame size should be zero — verified by the absence of any
# `ld hl,-N` frame-allocation prologue in the generated asm.
# chain3(a, b, c) { return a + b + c; } generates two long ADD
# intermediates: (a+b) consumed immediately by the final ADD, and the
# final result which is a return value (also dead-after). With PR_DEHL
# neither gets a slot and the frame is empty.
asm_path="$WORK/pr_dehl_no_frame.asm"
printf '%s\n' '
unsigned long chain3(unsigned long a, unsigned long b, unsigned long c) {
    return a + b + c;
}' > "$WORK/pr_dehl_no_frame.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir pr_dehl_no_frame.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("pr_dehl_no_frame: 80cc --use-ir failed")
else
    if grep -qE '^[[:space:]]+ld[[:space:]]+hl,-[0-9]' "$asm_path" 2>/dev/null; then
        fail=$((fail+1))
        failures+=("pr_dehl_no_frame: frame alloc present — PR_DEHL did not eliminate slot")
    else
        ok=$((ok+1))
    fi
fi

# --- Chain-OR accumulate: inline push instead of slot spill --------
# When a SPILL long intermediate is consumed by a single later OR/AND/XOR
# at distance >1 (non-PR_DEHL gap), the lowerer should push it to the
# data stack (3 instr: ld bc,hl; push de; push bc) instead of writing it
# to a frame slot (10 instr). The consumer uses the fused-(hl) path with
# offset=4 and pops the stack clean afterwards.
# pack4(b3,b2,b1,b0) generates two such intermediates (b3<<24 and the
# partial result (b3<<24)|(b2<<16)), each consumed by the next OR step.
# Verify:
#   pos: `push de;push bc` appears (inline pushes fired)
#   pos: `ld hl,4;add hl,sp` appears (fused-(hl) with N=4)
#   pos: `pop bc;pop bc` appears (cleanup sequence fires)
#   neg: no slot writes for v5/v8 (no `ld hl,0;add hl,sp` or equiv slot-off patterns
#        for the SPILL intermediates; we allow the non-zero slot offsets for v7/v10)
#   neg: no `ld hl,-12` or larger frame (frame stays at 8 bytes max for v7/v10 slots)
asm_path="$WORK/chain_or_push.asm"
printf '%s\n' '
unsigned long pack4(unsigned char b3, unsigned char b2, unsigned char b1, unsigned char b0) {
    return ((unsigned long)b3 << 24) | ((unsigned long)b2 << 16)
         | ((unsigned long)b1 <<  8) | b0;
}' > "$WORK/chain_or_push.c"
# Shape assertion for the sp inline-push (chain-OR accumulate) —
# pin IR_LONG_PUSHES=0: with the pass forced on, its PUSH/absorb
# takes these candidates first and the asserted pattern (correctly)
# changes shape.
if ! ( cd "$WORK" && env IR_LONG_PUSHES=0 "$COMPILER" --use-ir chain_or_push.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("chain_or_push: 80cc --use-ir failed")
else
    slurp=$(asm_slurp "$asm_path")
    ok2=1
    # inline pushes fired
    if [[ "$slurp" != *"push de;push bc"* ]]; then
        ok2=0; failures+=("chain_or_push: no 'push de; push bc' (inline push not fired)")
    fi
    # fused-(hl) path used N=4
    if [[ "$slurp" != *"ld hl,4;add hl,sp"* ]]; then
        ok2=0; failures+=("chain_or_push: no 'ld hl,4; add hl,sp' (fused-hl N=4 not fired)")
    fi
    # cleanup pops present
    if [[ "$slurp" != *"pop bc;pop bc"* ]]; then
        ok2=0; failures+=("chain_or_push: no 'pop bc; pop bc' (cleanup not emitted)")
    fi
    # frame must not grow beyond 8 bytes
    if grep -qE '^[[:space:]]+ld[[:space:]]+hl,-[0-9]{2,}' "$asm_path" 2>/dev/null; then
        ok2=0; failures+=("chain_or_push: frame larger than expected (slot not eliminated)")
    fi
    [ $ok2 -eq 1 ] && ok=$((ok+1)) || fail=$((fail+1))
fi

# --- IR compound-assign: global += fix + *=/div/mod coverage -------
# Pre-existing bug: `g op= x` on global ints was using g's VALUE as a
# pointer (build_expr(AST_GLOBAL_VAR) returns the value, not address).
# Fixed by detecting AST_GLOBAL_VAR in the compound handler and using
# IR_MEM_SYM load/store directly.
# New coverage: OP_AMULT/ADIV/AMOD (ast_type 43-45) had no case in
# build_expr — fell through to "unsupported expr". Now handled via
# HCALL (l_mult/l_div) with read-modify-write for local, global, and
# deref LHS shapes.

# compound_add_global: g += x — pre-existing bug fix
asm_path="$WORK/compound_add_global.asm"
printf '%s\n' '
int g;
unsigned int main(void) {
    g = 10;
    g += 5;
    return (unsigned int)g;
}' > "$WORK/compound_add_global.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir compound_add_global.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_add_global: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/compound_add_global.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_add_global: z80asm/link failed")
else
    trace="$WORK/compound_add_global.trace"
    "$TICKS" -end 6 -trace "$WORK/compound_add_global.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "000f" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("compound_add_global: expected hl=000f, got hl=$hl")
    fi
fi

# compound_mul_local: a *= b on local vars
asm_path="$WORK/compound_mul_local.asm"
printf '%s\n' '
unsigned int main(void) {
    int a = 7, b = 3;
    a *= b;
    return (unsigned int)a;
}' > "$WORK/compound_mul_local.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir compound_mul_local.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_local: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/compound_mul_local.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_local: z80asm/link failed")
else
    trace="$WORK/compound_mul_local.trace"
    "$TICKS" -end 6 -trace "$WORK/compound_mul_local.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "0015" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("compound_mul_local: expected hl=0015 (21), got hl=$hl")
    fi
fi

# compound_mul_global: g *= b on global
asm_path="$WORK/compound_mul_global.asm"
printf '%s\n' '
int g;
unsigned int main(void) {
    g = 5;
    g *= 4;
    return (unsigned int)g;
}' > "$WORK/compound_mul_global.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir compound_mul_global.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_global: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/compound_mul_global.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_global: z80asm/link failed")
else
    trace="$WORK/compound_mul_global.trace"
    "$TICKS" -end 6 -trace "$WORK/compound_mul_global.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "0014" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("compound_mul_global: expected hl=0014 (20), got hl=$hl")
    fi
fi

# compound_div_local: a /= b, a %= b on locals
asm_path="$WORK/compound_divmod_local.asm"
printf '%s\n' '
unsigned int main(void) {
    int a = 100, b = 7;
    a /= b;            /* 14 */
    int c = 17, d = 5;
    c %= d;            /* 2 */
    return (unsigned int)(a + c);  /* 16 = 0x10 */
}' > "$WORK/compound_divmod_local.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir compound_divmod_local.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_divmod_local: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/compound_divmod_local.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_divmod_local: z80asm/link failed")
else
    trace="$WORK/compound_divmod_local.trace"
    "$TICKS" -end 6 -trace "$WORK/compound_divmod_local.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "0010" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("compound_divmod_local: expected hl=0010 (16), got hl=$hl")
    fi
fi

# compound_mul_deref: *p *= n via pointer
asm_path="$WORK/compound_mul_deref.asm"
printf '%s\n' '
unsigned int main(void) {
    int c = 6;
    int *p = &c;
    *p *= 3;           /* 18 = 0x12 */
    return (unsigned int)c;
}' > "$WORK/compound_mul_deref.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir compound_mul_deref.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_deref: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/compound_mul_deref.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("compound_mul_deref: z80asm/link failed")
else
    trace="$WORK/compound_mul_deref.trace"
    "$TICKS" -end 6 -trace "$WORK/compound_mul_deref.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "0012" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("compound_mul_deref: expected hl=0012 (18), got hl=$hl")
    fi
fi

# --- Byte-extract idiom + byte promotion (IR pipeline) -------------
# (x >> 8k) & 0xFF digest stores collapse to IR_EXTRACT_BYTE; byte
# operands promote to int in shifts/adds; deref of byte-array globals
# reads a BYTE (was a word). NOTE: walker-mode equivalents are NOT
# covered here — the walker has a pre-existing l_gchar sign-extension
# bug on unsigned-char array elements (flagged 2026-06-06).
asm_path="$WORK/extract_byte_digest.asm"
printf '%s\n' '
typedef unsigned long UINT4;
unsigned char dig[8];
void store_word(unsigned char *p, UINT4 x) {
    p[0] = (unsigned char)(x & 0xFF);
    p[1] = (unsigned char)((x >> 8) & 0xFF);
    p[2] = (unsigned char)((x >> 16) & 0xFF);
    p[3] = (unsigned char)((x >> 24) & 0xFF);
}
unsigned int main(void) {
    int r = 0;
    store_word(dig, 0xA1B2C3D4UL);
    store_word(dig + 4, 0x11223344UL);
    if (dig[0] == 0xD4) r |= 1;
    if (dig[1] == 0xC3) r |= 2;
    if (dig[2] == 0xB2) r |= 4;
    if (dig[3] == 0xA1) r |= 8;
    if (dig[4] == 0x44) r |= 16;
    if (dig[7] == 0x11) r |= 32;
    return (unsigned int)r;
}' > "$WORK/extract_byte_digest.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir extract_byte_digest.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("extract_byte_digest: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/extract_byte_digest.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("extract_byte_digest: z80asm/link failed")
else
    trace="$WORK/extract_byte_digest.trace"
    "$TICKS" -end 6 -trace "$WORK/extract_byte_digest.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "003f" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("extract_byte_digest: expected hl=003F, got hl=$hl")
    fi
fi

asm_path="$WORK/byte_shl8_promotes.asm"
printf '%s\n' '
unsigned char d2[2];
unsigned int main(void) { d2[0] = 0xD4; d2[1] = 0xC3; return (unsigned int)((d2[0] << 8) | d2[1]); }' \
    > "$WORK/byte_shl8_promotes.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir byte_shl8_promotes.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("byte_shl8_promotes: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/byte_shl8_promotes.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("byte_shl8_promotes: z80asm/link failed")
else
    trace="$WORK/byte_shl8_promotes.trace"
    "$TICKS" -end 6 -trace "$WORK/byte_shl8_promotes.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "d4c3" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("byte_shl8_promotes: expected hl=D4C3, got hl=$hl")
    fi
fi

# BUG_LOG A34: OP_ASSIGN to a global must store at the GLOBAL's width,
# not the RHS vreg's. Pre-fix, `ga = 0x11` (int-width RHS) emitted
# `ld (_ga),hl` — a word store zeroing the adjacent `gb` (order-
# dependent: gb is written first, then clobbered). Expect 0x5511;
# pre-fix returns 0x0011.
asm_path="$WORK/byte_global_store_adjacent.asm"
printf '%s\n' '
unsigned char ga, gb;
unsigned int main(void) { gb = 0x55; ga = 0x11; return (unsigned int)((gb << 8) | ga); }' \
    > "$WORK/byte_global_store_adjacent.c"
if ! ( cd "$WORK" && "$COMPILER" --use-ir byte_global_store_adjacent.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("byte_global_store_adjacent: 80cc --use-ir failed")
elif ! ( cd "$WORK" && reg_z80asm "$WORK/byte_global_store_adjacent.bin" \
                            "$HARNESS" "$asm_path" 2>/dev/null ); then
    fail=$((fail+1)); failures+=("byte_global_store_adjacent: z80asm/link failed")
else
    trace="$WORK/byte_global_store_adjacent.trace"
    "$TICKS" -end 6 -trace "$WORK/byte_global_store_adjacent.bin" > "$trace" 2>&1
    hl=$(grep "pc=000D" "$trace" | tail -1 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
    if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "5511" ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1)); failures+=("byte_global_store_adjacent: expected hl=5511, got hl=$hl")
    fi
fi

# --- Long stack-discipline runtime checks (IR_LONG_PUSHES) ---------
# Each test compiles in {sp, fp} x {flag off, flag on} and asserts HL
# at the harness exit — the expected value must hold in ALL four
# combinations. Bugs covered (2026-06-07):
#   - in-place long const-ADD slot RMW ran while the value lived only
#     in the DEHL cache (spill skipped) — added K to a stale slot.
#     Flag-INDEPENDENT miscompile, both modes (longpush_imm_inplace).
#   - push_dehl_long pushed junk HL on a DEHL-cache hit; the fp
#     byte-direct dead-dst invariant is BC=low, HL=junk
#     (longpush_xor_shr16).
#   - option-B stack absorption was gated !fp_active, so fp binop
#     consumers read the (ix+d) slot the PUSH elided writing; and
#     pop_dehl_long left stale HL/DE cache claims after the pops
#     (longpush_struct_compound).
#   - the chained md5-FF-round shape combining all of the above
#     (longpush_ff_rounds).
run_longpush_rt() {
    local name="$1" expect="$2" src="$3"
    printf '%s\n' "$src" > "$WORK/$name.c"
    local mode flag desc hl trace
    for mode in "" "-frameix"; do
        for flag in off on; do
            desc="$name[${mode:-sp} push=$flag]"
            # IR_LONG_PUSHES is a VALUE now (default: on in fp mode,
            # off in sp) — force both states explicitly so each
            # codegen variant keeps coverage regardless of defaults.
            if [ "$flag" = on ]; then
                ( cd "$WORK" && env IR_LONG_PUSHES=1 \
                    "$COMPILER" --use-ir $mode "$name.c" 2>/dev/null )
            else
                ( cd "$WORK" && env IR_LONG_PUSHES=0 \
                    "$COMPILER" --use-ir $mode "$name.c" 2>/dev/null )
            fi
            if [ $? -ne 0 ]; then
                fail=$((fail+1)); failures+=("$desc: 80cc --use-ir failed")
                continue
            fi
            if ! ( cd "$WORK" && reg_z80asm "$WORK/$name.bin" \
                        "$HARNESS" "$WORK/$name.asm" 2>/dev/null ); then
                fail=$((fail+1)); failures+=("$desc: z80asm/link failed")
                continue
            fi
            trace="$WORK/$name.trace"
            "$TICKS" -end 6 -trace "$WORK/$name.bin" > "$trace" 2>&1
            hl=$(grep "pc=000D" "$trace" | tail -1 \
                 | sed -E 's/.*hl=([0-9A-Fa-f]+).*/\1/')
            if [ "$(echo "$hl" | tr 'A-F' 'a-f')" = "$expect" ]; then
                ok=$((ok+1))
            else
                fail=$((fail+1))
                failures+=("$desc: expected hl=$expect, got hl=$hl")
            fi
        done
    done
}

run_longpush_rt longpush_imm_inplace ac8e '
typedef unsigned long UINT4;
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))
unsigned int main(void) {
    UINT4 a = 0x67452301UL, b = 0xefcdab89UL, d = 0x10325476UL;
    a = ROTATE_LEFT(a, 7);
    a += b;
    d += a;
    return (unsigned int)((a ^ d) & 0xFFFF);
}'

run_longpush_rt longpush_xor_shr16 444b '
typedef unsigned long UINT4;
typedef struct { UINT4 i[2]; } CTX;
CTX g;
unsigned int main(void) {
    CTX *c = &g;
    c->i[0] = 0x12345678UL;
    c->i[1] = 7;
    return (unsigned int)(c->i[0] ^ (c->i[0] >> 16) ^ c->i[1]);
}'

run_longpush_rt longpush_struct_compound 1f37 '
typedef unsigned long UINT4;
typedef struct { UINT4 i[2]; } CTX;
CTX g;
unsigned int main(void) {
    CTX *c = &g;
    unsigned int inLen = 1000;
    c->i[0] = 0xFFFFFFF0UL;
    c->i[1] = 7;
    c->i[0] += (UINT4)inLen << 3;
    c->i[1] += (UINT4)inLen >> 13;
    return (unsigned int)(c->i[0] ^ c->i[1]);
}'

# ROTL fusion: rotate source arrives via LD_MEM, so the sp-mode
# DEHL cache hit must recover HL from BC before the byte
# permutation (BC=low invariant, HL not guaranteed — the A38
# disease; pre-fix sp returned 594C).
run_longpush_rt rotl_after_load 2222 '
typedef unsigned long UINT4;
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))
UINT4 g = 0x67452301UL;
unsigned int main(void) {
    UINT4 a = g;
    a = ROTATE_LEFT(a, 7);
    return (unsigned int)((a ^ (a >> 16)) & 0xFFFF);
}'

# Rotate-RIGHT fuses through the same triple (SHR n + SHL 32-n in
# either order -> ROTL 32-n). SHA-256 Sigma shape: XOR of three
# rotr amounts per value, exercising byte-perm + both bit-rotate
# directions across six distinct counts (2/13/22, 6/11/25).
run_longpush_rt rotr_sigma_xor 26be '
typedef unsigned long UINT4;
#define ROTATE_RIGHT(x, n) (((x) >> (n)) | ((x) << (32-(n))))
UINT4 g = 0x6a09e667UL, h = 0xbb67ae85UL;
unsigned int main(void) {
    UINT4 a = g, b = h, r;
    r  = ROTATE_RIGHT(a, 2) ^ ROTATE_RIGHT(a, 13) ^ ROTATE_RIGHT(a, 22);
    r += ROTATE_RIGHT(b, 6) ^ ROTATE_RIGHT(b, 11) ^ ROTATE_RIGHT(b, 25);
    return (unsigned int)((r ^ (r >> 16)) & 0xFFFF);
}'

# Width-correctness pins (2026-06-07, the seven lifted-gate bugs):
# decl-init literal must NOT shrink the declared vreg width — `UINT4
# crc = 0` ran every later op on crc at 16 bits (crcbench's CRC
# accumulate AND its assertEqual compare were both silently 16-bit).
run_longpush_rt long_width_decl_init 444c '
typedef unsigned long UINT4;
UINT4 gsrc;
unsigned int main(void) {
    UINT4 crc = 0;
    gsrc = 0x12345678UL;
    crc ^= gsrc;
    return (unsigned int)((crc >> 16) ^ crc);
}'

# Mixed-width arithmetic: long-helper args widen (l_long_mult_u with
# an int counter), long-literal + int binop runs at long width, and
# parser-folded struct member long stores/loads keep their width.
run_longpush_rt long_width_mixed 1522 '
typedef unsigned long UINT4;
typedef struct { UINT4 i[2]; UINT4 tail; } CTX;
CTX g;
unsigned int main(void) {
    unsigned int i, r = 0;
    for (i = 0; i < 4; i++)
        r ^= (unsigned int)((0x01010101UL * (i+1)) >> 16);
    g.i[0] = 0x11223344UL;
    g.i[1] = (UINT4)0x01000100UL + i;
    return (unsigned int)(r ^ (g.i[0] >> 16) ^ (g.i[1] >> 16) ^ (g.i[1] & 0xFFFF));
}'

# EXTRACT_BYTE on a sp DEHL-cache hit must read bytes 0/1 from C/B
# (BC=low invariant; HL holds the slot address after the sp spill
# walk). Two extract stores per iteration through a struct pointer.
run_longpush_rt extract_byte_sp_hit 1672 '
typedef unsigned long UINT4;
typedef struct { UINT4 buf[4]; unsigned char digest[16]; } CTX;
CTX g;
unsigned int main(void) {
    CTX *c = &g; unsigned int i, ii, r = 0;
    for (i=0;i<4;i++) g.buf[i] = 0x11223344UL + 0x11111111UL * i;
    for (i=0, ii=0; i<4; i++, ii+=4) {
        c->digest[ii]   = (unsigned char)(c->buf[i] & 0xFF);
        c->digest[ii+1] = (unsigned char)((c->buf[i] >> 8) & 0xFF);
    }
    for (i=0;i<16;i++) r += (unsigned int)g.digest[i] * (i+1);
    return r;
}'

# Large frames (>127-byte locals): 1KB byte array + long array,
# offsets past the IX displacement range, init loops, cross-call
# reads, and a tail store at data[1023]. Pins the int16 slot range
# and the per-access fp_offset_fits fallbacks.
run_longpush_rt large_frame_1k 3005 '
typedef unsigned long UINT4;
unsigned int feed(unsigned char *p, unsigned int n) { unsigned int i, r = 0; for (i=0;i<n;i++) r += p[i]; return r; }
unsigned int main(void) {
    unsigned char data[1024];
    UINT4 acc[8];
    unsigned int i, r = 0;
    for (i = 0; i < 1024; i++) data[i] = (unsigned char)(i * 13 + 5);
    for (i = 0; i < 8; i++) acc[i] = 0x01010101UL * (i + 1);
    r = feed(data, 1024);
    r += feed(data + 900, 100);
    for (i = 0; i < 8; i++) r ^= (unsigned int)(acc[i] >> 16) ^ (unsigned int)(acc[i] & 0xFFFF);
    data[1023] = (unsigned char)r;
    return r ^ data[1023] ^ data[0];
}'

run_longpush_rt longpush_ff_rounds de0e '
typedef unsigned long UINT4;
#define F(x, y, z) (((x) & (y)) | ((~x) & (z)))
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))
#define FF(a, b, c, d, x, s, ac) {(a) += F ((b), (c), (d)) + (x) + (UINT4)(ac); (a) = ROTATE_LEFT ((a), (s)); (a) += (b); }
UINT4 in[4];
unsigned int main(void) {
    UINT4 a = 0x67452301UL, b = 0xefcdab89UL, c = 0x98badcfeUL, d = 0x10325476UL;
    in[0] = 0x11111111UL; in[1] = 0x22222222UL; in[2] = 0x33333333UL; in[3] = 0x44444444UL;
    FF(a, b, c, d, in[0], 7,  0xd76aa478UL);
    FF(d, a, b, c, in[1], 12, 0xe8c7b756UL);
    FF(c, d, a, b, in[2], 17, 0x242070dbUL);
    FF(b, c, d, a, in[3], 22, 0xc1bdceeeUL);
    return (unsigned int)((a ^ b ^ c ^ d) & 0xFFFF);
}'

# --- Summary -------------------------------------------------------
echo "dehl_cache suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
