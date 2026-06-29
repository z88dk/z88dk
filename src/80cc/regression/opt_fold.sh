#!/bin/bash
# sccz80 regression: codegen optimisations and bug fixes added in
# the May 2026 session. Covers:
#   #195 — cross-line C99 adjacent string literal concat
#   #196 — incomplete-extern array indexing scale
#   #197 — assignment-as-expression value preserved in HL
#   #198 — global[const] direct (sym+offset) load/store fold
#   #199 — &global[const] address fold
#   #200 — pre/post-step on global[const] direct fold
#
# Each test checks both runtime HL (correctness) and an asm pattern
# (proves the optimisation actually fired or — for the bug-fix
# tests — that the broken pattern is NOT present).

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_opt_fold}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.bin "$WORK"/*.trace "$WORK"/*.c "$WORK"/*.o

ok=0
fail=0
failures=()

# Args: name, expected_HL_hex, asm_must_contain_pattern, src
#   asm pattern uses grep -E ; if empty, no asm check is done.
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
    if [ -n "$pat" ] && ! grep -qE "$pat" "$asm"; then
        fail=$((fail+1)); failures+=("$name: pattern '$pat' missing"); return
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

# Args: cpu, name, expected_HL_hex, asm_must_contain_pattern, src
#   Generic CPU-targeted test. cpu = 8080 / 8085 / ez80_z80 / kc160
#   / r2ka / r4k / gbz80. Compiles with -m<cpu>, links with that
#   CPU's crt0 + test clib, runs ticks with -m<cpu>.
run_cpu_test() {
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

# Args: name, expected_HL_hex, asm_must_NOT_contain_pattern, src
run_negtest() {
    local name="$1"
    local expected="$2"
    local antipat="$3"
    local src="$4"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local bin="$WORK/$name.bin"
    local trace="$WORK/$name.trace"

    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" "$name.c" 2>/dev/null ); then
        fail=$((fail+1)); failures+=("$name: sccz80 failed"); return
    fi
    if [ -n "$antipat" ] && grep -qE "$antipat" "$asm"; then
        fail=$((fail+1)); failures+=("$name: anti-pattern '$antipat' present (regression)"); return
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

# --- #195 Cross-line C99 adjacent string literal concat ------------
# Earlier the lex_string concat-peek would absorb the trailing \n
# (looking for an adjacent `"`) and source_end overshot by 1, so
# lptr += span read past the end of line[] into stale bytes. After
# the fix, the tokeniser's lex_string saves/restores buf_pos when no
# adjacent literal follows, and tstr/qstr/sizeof loop at the parser
# level to splice across lines. `sizeof("one""two""three")` = 12
# (11 chars + NUL).
run_test "conststr_three_line_sizeof" "000C" '' '
int main(void) {
    return sizeof("one"
                  "two"
                  "three");
}'

# Pointer access to the spliced literal — verifies bytes land
# correctly across the join.
run_test "conststr_three_line_byte6" "0067" '' '
const char *s =
    "abc"
    "def"
    "ghij";
int main(void) {
    return s[6];                        /* "abcdefghij"[6] = g = 0x67 */
}'

# --- #196 Incomplete-extern array indexing scale -------------------
# `extern T x[]` had len=-1 / size=0, so size/len fallback failed
# and elem stayed at 1 — int-array indexing produced *(arr+i)
# instead of *(arr+i*2). After the fix the KIND_ARRAY-with-ptr path
# uses ltype->ptr->size directly. Verify scaling fires.
run_test "extern_intarr_scaled" "0014" 'add[[:space:]]+hl,hl' '
extern int data2[];
int g_idx;
int main(void) {
    g_idx = 1;                          /* defeat const-fold */
    return data2[g_idx];                /* 20 = 0x14 */
}
int data2[] = { 10, 20, 30 };
'

# --- #279 LICM must not hoist array-typed expressions -------------
# `for(i)for(j) sum ^= m[i][j]` on a global 2D array previously
# tripped a fatal "AST_DECL of kind 8" error: LICM noticed `m + i*N`
# was invariant w.r.t. j, decided to hoist it, and created a
# `1licm_N` stub sym whose ctype was the array type (`int[N][N]`).
# The walker's cg2_emit_decl can't allocate an "array-typed temp"
# and bailed out fatally. is_safe_to_hoist now rejects KIND_ARRAY
# result types. Test: a nested-loop XOR-walk of a 4x4 array compiles
# and produces the correct sum.
run_test "licm_no_array_hoist" "0055" '' '
int m[4][4];
int main(void) {
    int i, j, sum;
    sum = 0;
    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            m[i][j] = (1 << i) * (1 << j);
    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            sum ^= m[i][j];
    return sum;                 /* XOR of 16 byte values: 0x55 */
}
'

# --- #155 direct-to-DE LHS load skips the ex de,hl --------------
# When use_ex_de_hl fires AND L is a simple loadable expression with
# a CPU-supported direct-to-DE form (FP-indexed local, KC160 sp-rel
# local, or any-CPU bare global via `ld de,(nn)`), cg2_binop loads
# L directly into DE and skips the trailing ex de,hl. Test asserts
# the global-LHS path emits `ld de,(_g)` rather than `ld hl,(_g);
# ex de,hl`. Plain z80, no FP needed for this shape.
run_test "p155_de_direct_global_lhs" "000C" '' '
int g1, g2;
int main(void) {
    g1 = 5; g2 = 7;
    return (char)(g1 + g2);            /* 12 = 0x0c */
}
'
# Strict shape check: `ld de,(_g1)` must appear in the add sequence.
cfile_p155="$WORK/p155_de_direct_global.c"
asm_p155="$WORK/p155_de_direct_global.asm"
printf '%s\n' '
int g1, g2;
int main(void) {
    return g1 + g2;
}' > "$cfile_p155"
if ( cd "$WORK" && "$COMPILER" p155_de_direct_global.c 2>/dev/null ); then
    if grep -qE '^[[:space:]]*ld[[:space:]]+de,\(_g1\)' "$asm_p155"; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("p155_de_direct_global: expected ld de,(_g1) shape")
    fi
else
    fail=$((fail+1))
    failures+=("p155_de_direct_global: 80cc failed")
fi

# --- #278 2D-array-param stride correctly scaled by row size ------
# `m[i]` where `m` is `int(*)[N]` (a 2D array decayed to pointer)
# must scale `i` by sizeof(int[N]) = N*sizeof(int), not sizeof(int).
# Previously the runtime-index path used the buggy
# `(ptr->size/ptr->len) * ptr->ptr->size` = `sizeof(int)^2` formula,
# producing `i*4` instead of `i*N*2`. Test reads m[2][0] (row 2 of a
# 4x4 array of 1<<bit values) and expects 0x100 = 1<<(2*4+0).
# m[2][0] is at offset 2*4*sizeof(int) = 16 bytes from m.
run_test "ptr_2d_array_param_stride" "0100" '' '
int sum_at(int m[4][4], int row, int col) {
    return m[row][col];
}
int m[4][4];
int main(void) {
    int i, j;
    for (i = 0; i < 4; i++)
        for (j = 0; j < 4; j++)
            m[i][j] = 1 << (i*4 + j);
    return sum_at(m, 2, 0);          /* expect 1<<8 = 0x100 */
}
'

# --- #197 Assignment-as-expression value preserved ----------------
# `while ((n = expr) != K)` was emitting a store that left the
# destination ADDRESS in HL rather than the value, so the comparison
# ran against the address. After the fix, OP_ASSIGN local fastpath
# uses cg2_store_local_keep — value survives in HL.
run_test "assign_expr_value" "0003" '' '
int main(void) {
    int n;
    int count = 0;
    int src[] = { 1, 2, 3, 255 };
    int *p = src;
    while ((n = *p++) != 255) {
        count++;
    }
    return count;                       /* 3 elements before 255 */
}'

# --- #198 global[const] load fold ---------------------------------
# `arr[K]` for global int array should emit `ld hl,(_arr+offset)`
# directly — no `ld de,_arr; ld hl,N; add hl,de` runtime triple.
run_test "global_idx_load_int" "001E" 'ld[[:space:]]+hl,\(_arrL\+4\)' '
int arrL[] = { 10, 20, 30 };
int main(void) {
    return arrL[2];                     /* 30 = 0x1E */
}'

# Negative: the runtime address-arithmetic triple must NOT be present.
run_negtest "global_idx_load_no_triple" "001E" 'ld[[:space:]]+de,_arrL2' '
int arrL2[] = { 10, 20, 30 };
int main(void) {
    return arrL2[2];
}'

# --- #198 global[const] store fold --------------------------------
# `arr[K] = expr` should emit `ld (_arr+offset),hl`.
run_test "global_idx_store_int" "002A" 'ld[[:space:]]+\(_arrS\+2\),hl' '
int arrS[3];
int main(void) {
    arrS[1] = 42;
    return arrS[1];                     /* 42 = 0x2A */
}'

# --- #199 &global[const] address fold -----------------------------
# `&arr[K]` consumed as an address (here written through and read
# back) should emit `ld hl,_arr+offset` directly.
run_test "global_addr_via_ptr" "0021" 'ld[[:space:]]+hl,_bufA\+5' '
char bufA[16];
int main(void) {
    char *p = &bufA[5];
    *p = 0x21;
    return bufA[5];                     /* 33 = 0x21 */
}'

# --- #200 pre/post-step on global[const] fold ---------------------
# `++arr[K]` should emit `ld hl,(sym+off); inc hl; ld (sym+off),hl`
# — no push/pop/l_gint/l_pint sandwich.
run_test "global_idx_preinc_int" "0021" 'ld[[:space:]]+hl,\(_arrI\+4\)' '
int arrI[] = { 10, 20, 30 };
int main(void) {
    ++arrI[2];   /* 31 */
    ++arrI[2];   /* 32 */
    arrI[2]++;   /* 33 */
    return arrI[2];                     /* 33 = 0x21 */
}'

# Char step on global[const] — should NOT emit l_pchar/l_gchar pair.
run_test "global_idx_step_char" "002A" '' '
unsigned char arrC[10];
int main(void) {
    arrC[3] = 0x20;
    ++arrC[3]; arrC[3]++;
    ++arrC[3]; arrC[3]++;
    ++arrC[3]; arrC[3]++;
    ++arrC[3]; arrC[3]++;
    ++arrC[3]; arrC[3]++;
    return arrC[3];                     /* 0x20 + 10 = 0x2A */
}'

# --- #201 GBZ80: inline l_gint + ld hl,sp+d -----------------------
# GBZ80 lacks `ld hl,(nn)` so int loads go through a helper call. The
# helper boils down to `ld a,(hl+); ld h,(hl); ld l,a` — three bytes
# inline, same size as `call l_gint` but no call/ret overhead.
run_cpu_test gbz80 "gbz80_inline_gint" "0007" 'ld[[:space:]]+a,\(hl\+\)' '
int gG;
int main(void) {
    gG = 7;
    return gG;
}'

# `ld hl,sp+d` (F8 dd) is a 2-byte GBZ80 instruction — saves 2 bytes
# vs `ld hl,N; add hl,sp` when the signed offset fits in 8 bits.
run_cpu_test gbz80 "gbz80_sp_offset" "002A" 'ld[[:space:]]+hl,sp' '
int gSrc;
int main(void) {
    int n;
    gSrc = 42;
    n = gSrc;        /* store to local needs sp-relative addr */
    return n;
}'

# Task #280: gbz80 inline sp-rel int LOAD (gen_load_local). Saves the
# `call l_gintNsp` round-trip — emits the helper body inline as
# `ld hl,sp+d; ld a,(hl+); ld h,(hl); ld l,a`. Verify no call to
# l_gintNsp appears for a local int reload.
cfile_g280a="$WORK/gbz80_local_int_load.c"; asm_g280a="$WORK/gbz80_local_int_load.asm"
cat > "$cfile_g280a" <<'EOF'
int sink;
int f(int a, int b) { return a + b; }
int main(void) { sink = f(3, 4); return sink; }
EOF
if ( cd "$WORK" && "$COMPILER" -mgbz80 gbz80_local_int_load.c 2>/dev/null ); then
    if grep -qE 'call[[:space:]]+l_gint[0-9]+sp' "$asm_g280a"; then
        fail=$((fail+1)); failures+=("gbz80_local_int_load: still calls l_gintNsp helper")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1)); failures+=("gbz80_local_int_load: build failed")
fi

# Task #280 follow-up: gen_store_local_keep on gbz80 inlines the int
# store as `ld (hl),e; inc hl; ld (hl),d` instead of `call l_pint`.
# Verify the keep-store sequence for a local int assignment whose
# result is reused in the next statement does not call l_pint.
# (l_pint may still be used by global stores — focus on crc_step only.)
cfile_g280b="$WORK/gbz80_keep_store_no_lpint.c"; asm_g280b="$WORK/gbz80_keep_store_no_lpint.asm"
cat > "$cfile_g280b" <<'EOF'
unsigned int crc_step(unsigned int crc)
{
    crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    return crc;
}
int main(void) { return (int)crc_step(0xABCDU); }
EOF
if ( cd "$WORK" && "$COMPILER" -mgbz80 gbz80_keep_store_no_lpint.c 2>/dev/null ); then
    # Limit scope to crc_step body only (between its label and the
    # function epilogue / next function header).
    body=$(awk '/^\._crc_step$/,/^[._]_?[a-zA-Z][a-zA-Z_0-9]*:?$/' "$asm_g280b" | head -200)
    if echo "$body" | grep -qE 'call[[:space:]]+l_pint\b'; then
        fail=$((fail+1)); failures+=("gbz80_keep_store_no_lpint: crc_step still calls l_pint")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1)); failures+=("gbz80_keep_store_no_lpint: build failed")
fi

# --- 8085: ldsi / lhlx / shlx int load/store (task #159) ----------
# 8085 has `lhlx` and `shlx` (load/store HL via [DE]) plus `ldsi d`
# (DE = SP+d). The assembler emits these in z80 mnemonics as
# `ld hl,(de)` / `ld (de),hl` / `ld de,sp+d`. Together they
# replace the generic `add hl,sp + call l_gint/l_pint` pattern.
# Verify the 8085 sp-relative store sequence fires.
run_cpu_test 8085 "i8085_sp_store" "002A" 'ld[[:space:]]+\(de\),hl' '
int g;
int main(void) {
    int n;
    g = 42;
    n = g;
    return n;
}'

# Same shape verifies the 8085 sp-relative load (lhlx form).
run_cpu_test 8085 "i8085_sp_load" "002A" 'ld[[:space:]]+hl,\(de\)' '
int g;
int main(void) {
    int n;
    g = 42;
    n = g;
    return n;
}'

# --- 8080: no CPU-specific instructions but global[const] fold ----
# 8080 doesnt have lhlx/shlx — uses the generic int load `lhld nn`
# (z80 `ld hl,(nn)` equivalent). Verify the #O1 (sym+off) fold works.
run_cpu_test 8080 "i8080_global_idx" "001E" 'lhld[[:space:]]+_arrG\+4|ld[[:space:]]+hl,\(_arrG\+4\)' '
int arrG[] = { 10, 20, 30 };
int main(void) {
    return arrG[2];                     /* 30 = 0x1E */
}'

# --- ez80_z80: inline `ld hl,(hl)` for l_gint (task #149) ---------
# EZ80 in z80 mode has `ld hl,(hl)` (ED 27) — 2-byte int load
# through HL, replacing `call l_gint` (3 bytes + call/ret cycles).
# Triggers when HL already holds the address and we need to deref —
# i.e. pointer indirection.
run_cpu_test ez80_z80 "ez80_indirect_load" "0011" 'ld[[:space:]]+hl,\(hl\)' '
int *gp;
int gv;
int main(void) {
    gv = 17;
    gp = &gv;
    return *gp;                          /* indirect deref → ld hl,(hl) */
}'

# --- kc160: ld rr,(sp+d) / ld (sp+d),rr (task #148) ---------------
# KC160 has signed-8 sp-relative int and long loads/stores.
run_cpu_test kc160 "kc160_sp_load" "0007" 'ld[[:space:]]+hl,\(sp' '
int g;
int main(void) {
    int n;
    g = 7;
    n = g;
    return n;
}'

# --- rabbit r2ka: ld hl,(sp+N) / ld (sp+N),hl (task #143) ---------
# Rabbit has unsigned-8 sp-relative `ld hl,(sp+N)` / `ld (sp+N),hl`
# (3 bytes vs the 7-byte z80 equivalent).
run_cpu_test r2ka "r2ka_sp_load" "002A" 'ld[[:space:]]+hl,\(sp\+' '
int g;
int main(void) {
    int n;
    g = 42;
    n = g;
    return n;
}'

# --- #R3 per-CPU breadth (task #209) ------------------------------

# Rabbit 16-bit AND / OR (task #144). int & int / int | int emit
# 2-byte `and hl,de` / `or hl,de` instead of `call l_and` /
# `call l_or`. Globals defeat the propagation pass so the
# Rabbit-specific binop fires.
run_cpu_test r2ka "r2ka_and16" "0F00" '^[[:space:]]*and[[:space:]]+hl,de' '
int rA, rB;
int main(void) {
    rA = 0xFF0F;
    rB = 0x0FF0;
    return rA & rB;            /* 0xFF0F & 0x0FF0 = 0x0F00 */
}'

run_cpu_test r2ka "r2ka_or16" "FFFF" '^[[:space:]]*or[[:space:]]+hl,de' '
int rA, rB;
int main(void) {
    rA = 0xFF0F;
    rB = 0x0FF0;
    return rA | rB;            /* 0xFF0F | 0x0FF0 = 0xFFFF */
}'

# Rabbit XOR via `xor hl,de` is R6K-only (codegen.c:4037-4042) —
# no r6k crt0 / clib in this z88dk build, so we can't link+run.
# Skipped here; covered indirectly by the and/or pair which share
# the binop walker path.

# Rabbit long sp-relative paired load. Rabbit has only `ld hl,(sp+N)`
# (no `ld de,(sp+N)`), so the 4-byte load goes high-first:
#   `ld hl,(sp+N+2); ex de,hl; ld hl,(sp+N)`
# Pattern checks for the high-half load at offset 2 (proves the
# load goes beyond the 2-byte boundary, i.e. it's a long fetch).
run_cpu_test r2ka "r2ka_long_sp_load" "5678" 'ld[[:space:]]+hl,\(sp\+2\)' '
long gL;
int main(void) {
    long n;
    gL = 0x12345678L;
    n = gL;
    return (int)n;             /* low 16 of 0x12345678 = 0x5678 */
}'

# KC160 long sp+d (extends #148, currently only int variant tested).
# KC160 has signed-8 offset so the same form fits 4-byte loads via
# `ld de,(sp+2)`.
run_cpu_test kc160 "kc160_long_sp" "5678" 'ld[[:space:]]+de,\(sp\+2\)' '
long kgL;
int main(void) {
    long n;
    kgL = 0x12345678L;
    n = kgL;
    return (int)n;
}'

# Rabbit unsigned long >> 1 (task #210). `or a; rr de; rr hl`
# (5 bytes) replaces `srl d; rr e; rr h; rr l` (8 bytes). Also
# fixed the upstream type-promotion bug where `unsigned long >>
# int` was landing as plain `long` and silently emitting the
# signed (sign-preserving) shift. Test value 0x80000000 >> 1
# distinguishes signed (= 0xC0000000) from unsigned (= 0x40000000).
# Returns the low 16 bits to land in HL: 0x0000 (low half is 0).
run_cpu_test r2ka "r2ka_ulong_shr" "0000" '^[[:space:]]*or[[:space:]]+a' '
unsigned long ulG;
unsigned long main(void) {
    ulG = 0x80000000UL;
    return ulG >> 1;            /* logical → 0x40000000, low16 = 0 */
}'

# Pattern check: the same shape emits `rr de` and `rr hl` (the
# Rabbit-specific 16-bit rotates). Use a different test to avoid
# coupling two patterns in one assertion.
run_cpu_test r2ka "r2ka_ulong_shr_rr_hl" "0000" '^[[:space:]]*rr[[:space:]]+hl' '
unsigned long ulG2;
unsigned long main(void) {
    ulG2 = 0x80000000UL;
    return ulG2 >> 1;
}'

# Signed long >> 1 on Rabbit: arithmetic-shift sign-preserving
# variant uses `ld a,d; rla` to lift bit 31 into carry, then
# rr de / rr hl. Test value -16L >> 1 = -8L = 0xFFFFFFF8; low 16
# = 0xFFF8.
run_cpu_test r2ka "r2ka_slong_shr" "FFF8" '^[[:space:]]*ld[[:space:]]+a,d' '
long slG;
long main(void) {
    slG = -16L;
    return slG >> 1;            /* arith → -8 = 0xFFFFFFF8 */
}'

# --- #211 promote_types preserves unsignedness -------------------
# Three tests that distinguish the new (C-correct) behaviour from
# the old buggy one. Each picks operand values where signed and
# unsigned arithmetic produce different bit patterns.

# Same-rank int mixing. `(int)-1 < (unsigned int)1`:
#   Per C §6.3.1.8: same rank, unsigned wins → both promoted to
#     unsigned int. -1 → 0xFFFF, 1 → 0x0001. 0xFFFF < 1 = false.
#   Old (buggy) promote_types returned plain int → signed compare:
#     -1 < 1 = true.
# Expected with fix: 0 (false). Old code would have returned 1.
run_cpu_test z80 "promote_int_mixed_sign_cmp" "0000" '' '
int sm; unsigned int um;
int main(void) {
    sm = -1;
    um = 1;
    return sm < um;
}'

# Same-rank long mixing. `(long)-10 / (unsigned long)3`:
#   Same-rank, unsigned wins → both promoted to unsigned long. -10
#   → 0xFFFFFFF6, divided unsigned by 3 = 0x55555552. Low 16 bits
#   = 0x5552.
#   Old: signed div, -10/3 = -3 = 0xFFFFFFFD, low16 = 0xFFFD.
run_cpu_test z80 "promote_long_mixed_sign_div" "5552" '' '
long sl; unsigned long ul;
int main(void) {
    sl = -10L;
    ul = 3UL;
    return (int)(sl / ul);
}'

# Cross-rank: unsigned long vs long → unsigned long (same rank,
# unsigned wins). Compare unsigned: 0xFFFFFFFF (=4G-1) > 1, so
# the lt-test returns false. Old code returned plain long →
# signed compare: -1L < 1L = true.
run_cpu_test z80 "promote_ulong_long_cmp" "0000" '' '
unsigned long ulC;
long slC;
int main(void) {
    ulC = 0xFFFFFFFFUL;
    slC = 1L;
    return ulC < slC;
}'

# EZ80 inline `ld (hl),de` (task #149) — the store counterpart to
# the existing `ld hl,(hl)` load test. Triggers when HL holds the
# pointer destination and DE holds the value. Use a pointer-store
# shape similar to the existing ez80_indirect_load.
run_cpu_test ez80_z80 "ez80_indirect_store" "0011" 'ld[[:space:]]+\(hl\),de' '
int *epp;
int epv;
int rhs(void) { return 17; }
int main(void) {
    epv = 0;
    epp = &epv;
    *epp = rhs();   /* non-literal RHS — keeps ld (hl),de pattern */
    return epv;
}'

# --- #R9 CPU-breadth (task #215) ----------------------------------

# z80n const shift via `bsra de,b` / `bsrl de,b`. Fires for int
# shift by [2..14] (excluding 1, 8, 15, 16 which have smaller
# shapes). Test value `100 >> 5` = 3, signed.
run_cpu_test z80n "z80n_const_shr" "0003" '^[[:space:]]*bsra[[:space:]]+de,b' '
int z80n_g;
int main(void) {
    z80n_g = 100;
    return z80n_g >> 5;
}'

# swapnib path in asr_const (codegen.c:4252) requires the shift to
# happen at KIND_CHAR width; current walker int-promotes char
# operands before the shift so asr_const sees KIND_INT and the
# swapnib branch never fires. Tracked elsewhere — not asserting
# until the char-width preservation lands.

# z180: no z180-specific opt emit in current codegen (mlt is a
# TODO at codegen.c:3158). Lock in compile + link + runtime for
# the generic z180 path so a refactor that breaks z180 lib
# linkage is caught.
run_cpu_test z180 "z180_smoke_int_mul" "002A" '' '
int z180_a, z180_b;
int main(void) {
    z180_a = 6; z180_b = 7;
    return z180_a * z180_b;             /* 42 = 0x2A via l_mult */
}'

# #145 ex de,hl fastpath / #155 direct-to-DE load. cg2_binop avoids
# push/pop when RHS is DE-safe (bare LV/GV deref or literal). Two
# acceptable shapes:
#   - #145: walk L into HL, then `ex de,hl` to move L into DE.
#   - #155: load L directly into DE (e.g. `ld de,(_g1ex)`) — skips
#           the trailing ex.
# Either way the win is "no push hl / pop de in the add sequence".
cfile_ex="$WORK/ex_de_hl_fastpath.c"; asm_ex="$WORK/ex_de_hl_fastpath.asm"
printf '%s\n' '
int g1ex, g2ex;
int main(void) {
    g1ex = 5; g2ex = 7;
    return g1ex + g2ex;
}' > "$cfile_ex"
if ( cd "$WORK" && "$COMPILER" -mz80 ex_de_hl_fastpath.c 2>/dev/null ); then
    # Either ex de,hl present (#145) or a direct ld de,(_g…) (#155)
    has_ex=$(grep -cE '^[[:space:]]*ex[[:space:]]+de,hl' "$asm_ex")
    has_de_direct=$(grep -cE '^[[:space:]]*ld[[:space:]]+de,\(_g[12]ex\)' "$asm_ex")
    # Negative pattern: no push/pop within the add sequence
    has_push=$(grep -cE '^[[:space:]]*push[[:space:]]+hl' "$asm_ex")
    has_pop=$(grep -cE '^[[:space:]]*pop[[:space:]]+de' "$asm_ex")
    if [ $((has_ex + has_de_direct)) -gt 0 ] && [ "$has_push" = 0 ] && [ "$has_pop" = 0 ]; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("ex_de_hl_fastpath: ex=$has_ex de_direct=$has_de_direct push=$has_push pop=$has_pop")
    fi
else
    fail=$((fail+1))
    failures+=("ex_de_hl_fastpath: sccz80 failed")
fi

# --- #218a char-literal store fastpath ----------------------------
# `char g; g = N;` at statement scope used to emit `ld hl,N; ld a,l;
# ld (_g),a` (7 bytes, widening for a value-in-HL contract that the
# discarded statement doesn't need). Now emits `ld a,N; ld (_g),a`
# (5 bytes). Walker threads a discard hint from cg2_compound to the
# OP_ASSIGN fast paths.

# Positive: emit pattern fires for global char store.
run_cpu_test z80 "char_const_store_global" "002A" '^[[:space:]]*ld[[:space:]]+a,42[[:space:]]*$' '
unsigned char gC;
int main(void) {
    gC = 42;
    return gC;            /* 42 = 0x2A */
}'

# Negative: the legacy `ld hl,N; ld a,l` pair should NOT appear for
# the char store now — explicit counter-pattern.
cfile_neg="$WORK/char_const_store_no_widen.c"; asm_neg="$WORK/char_const_store_no_widen.asm"
printf '%s\n' '
unsigned char gC2;
int main(void) {
    gC2 = 17;
    return gC2;
}' > "$cfile_neg"
if ( cd "$WORK" && "$COMPILER" -mz80 char_const_store_no_widen.c 2>/dev/null ); then
    # Pre-#218a shape: `ld hl,17; ld a,l; ld (_gC2),a`. Now should
    # be `ld a,17; ld (_gC2),a`. Assert NO `ld a,l` before the
    # char store.
    if grep -qE '^[[:space:]]*ld[[:space:]]+a,l[[:space:]]*$' "$asm_neg"; then
        # Could still be there from the return-value load — check
        # context. Simpler: count ld hl,17 occurrences. Pre-fix:
        # 1 (the widen). Post-fix: 0 for the store, possibly 1
        # for the return read. We expect at most 1.
        n=$(grep -cE '^[[:space:]]*ld[[:space:]]+hl,17[[:space:]]' "$asm_neg")
        if [ "$n" -le 0 ]; then ok=$((ok+1)); else
            fail=$((fail+1))
            failures+=("char_const_store_no_widen: ld hl,17 still emitted ($n times)")
        fi
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("char_const_store_no_widen: sccz80 failed")
fi

# Local char init: `char c; c = 5;` should emit `ld a,5; ld (ix-d),a`
# (FP) or `ld a,5; <addr>; ld (hl),a`. The `ld a,N` byte is the
# distinguishing token. Use `&c` to escape c so the prop pass
# doesn't fold the store + return into a single literal.
run_cpu_test z80 "char_const_store_local" "002A" '^[[:space:]]*ld[[:space:]]+a,42' '
unsigned char *ec_p;
int main(void) {
    unsigned char ec;
    ec_p = &ec;
    ec = 42;
    return *ec_p;
}'

# Negative case: chained `(c = N)` value used — fast path MUST NOT
# fire. The walker should fall back to the int-widening shape so
# HL has the assigned value. Pattern: `ld hl,N` must precede the
# return-value path.
run_cpu_test z80 "char_chained_assign_safe" "002A" 'ld[[:space:]]+hl,42' '
int main(void) {
    unsigned char c;
    int n;
    n = (c = 42);
    return n;
}'

# --- #218b char compare with literal in value context -------------
# `return c < K` and `return c == K` used to widen via l_gchar then
# run the int compare with its messy `rla; ccf; rra; sbc 128; rl l`
# materialise tail. Now uses the same gen_load_byte_cmp_const +
# carry-to-HL the cond context has had since #138/#139. ~6 bytes
# saved per site.

# Unsigned char `<` const, value context. Setup: g=5; return g < 10
# → 1. Pattern asserts no `l_gchar` call (widening) — the byte
# load is direct.
run_cpu_test z80 "char_lt_const_value" "0001" '^[[:space:]]*ld[[:space:]]+a,\(_uc218b\)' '
unsigned char uc218b;
int main(void) {
    uc218b = 5;
    return uc218b < 10;
}'

# Negative: the legacy `l_gchar` widen should NOT be called in the
# compare. Assert no `call l_gchar` in the function body.
cfile_neg2="$WORK/char_lt_no_gchar.c"; asm_neg2="$WORK/char_lt_no_gchar.asm"
printf '%s\n' '
unsigned char uc_b;
int main(void) {
    uc_b = 5;
    return uc_b < 10;
}' > "$cfile_neg2"
if ( cd "$WORK" && "$COMPILER" -mz80 char_lt_no_gchar.c 2>/dev/null ); then
    if grep -qE 'call[[:space:]]+l_gchar' "$asm_neg2"; then
        fail=$((fail+1))
        failures+=("char_lt_no_gchar: l_gchar still called")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("char_lt_no_gchar: sccz80 failed")
fi

# Signed char `<` negative const, value context. Setup: g=-5;
# return g < -10 → 0 (false; -5 > -10). Pattern asserts the signed
# variant uses `xor 128` (the monotonic mapping) before the cp.
run_cpu_test z80 "schar_lt_neg_const_value" "0000" '^[[:space:]]*xor[[:space:]]+128' '
signed char sc218b;
int main(void) {
    sc218b = -5;
    return sc218b < -10;
}'

# `==` in value context, both polarities.
run_cpu_test z80 "char_eq_const_value_true" "0001" '^[[:space:]]*cp[[:space:]]+42' '
unsigned char uce_t;
int main(void) {
    uce_t = 42;
    return uce_t == 42;
}'

run_cpu_test z80 "char_ne_const_value" "0001" '^[[:space:]]*cp[[:space:]]+99' '
unsigned char ucn;
int main(void) {
    ucn = 42;
    return ucn != 99;
}'

# OP_LE / OP_GT not handled by #218b fastpath (would need K+1
# wraparound check) — should fall through to the int compare path
# and still produce correct results.
run_cpu_test z80 "char_le_const_value_fallback" "0001" '' '
unsigned char ucl;
int main(void) {
    ucl = 10;
    return ucl <= 10;
}'

# --- #220 GBZ80 / Rabbit add sp,d for stack adjust ----------------
# modstk has a fastpath: `add sp,d` (2 bytes, signed-8) for stack
# allocs / restores when |d| > threshold && |d| <= 127. Rabbit
# threshold > 1 (4-clock add sp beats 7-clock pop for k>=2); GBZ80
# threshold > 2 (2-byte add sp vs 1-byte pop, only worth it for
# k>=4). Already wired in codegen.c::modstk (lines 2442-2452); test
# locks in the behaviour against regression.

# Rabbit frame_size=4 should emit `add sp,-4` prologue + `add sp,4`
# epilogue. Force a real frame by escaping two locals so they can'\''t
# be const-propped.
run_cpu_test r2ka "r2ka_add_sp_4" "0003" '^[[:space:]]*add[[:space:]]+sp,-4' '
int adsp_g;
int *adsp_p1; int *adsp_p2;
int main(void) {
    int adsp_a, adsp_b;
    adsp_p1 = &adsp_a; adsp_p2 = &adsp_b;
    adsp_a = 1; adsp_b = 2;
    adsp_g = *adsp_p1 + *adsp_p2;
    return adsp_g;
}'

# GBZ80 frame_size=4 — same shape, same `add sp,-4`. (For frame=2
# GBZ80 prefers pop/push because that'\''s 1 byte vs 2 — modstk
# threshold > 2 captures that.)
run_cpu_test gbz80 "gbz80_add_sp_4" "0003" '^[[:space:]]*add[[:space:]]+sp,-4' '
int adgb_g;
int *adgb_p1; int *adgb_p2;
int main(void) {
    int adgb_a, adgb_b;
    adgb_p1 = &adgb_a; adgb_p2 = &adgb_b;
    adgb_a = 1; adgb_b = 2;
    adgb_g = *adgb_p1 + *adgb_p2;
    return adgb_g;
}'

# Negative: GBZ80 with frame_size=2 must NOT use add sp,2 (size
# threshold). Expected: `push bc` + `pop bc`. Assert no add sp,
# in the function body.
cfile_neg5="$WORK/gbz80_no_add_sp_2.c"; asm_neg5="$WORK/gbz80_no_add_sp_2.asm"
printf '%s\n' '
int *nadgb_p;
int main(void) {
    int nadgb_a;
    nadgb_p = &nadgb_a;
    nadgb_a = 7;
    return *nadgb_p;
}' > "$cfile_neg5"
if ( cd "$WORK" && "$COMPILER" -mgbz80 gbz80_no_add_sp_2.c 2>/dev/null ); then
    if grep -qE '^[[:space:]]*add[[:space:]]+sp,[+-]?2[[:space:]]*$' "$asm_neg5"; then
        fail=$((fail+1))
        failures+=("gbz80_no_add_sp_2: add sp,2 fired but should use pop")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("gbz80_no_add_sp_2: sccz80 failed")
fi

# --- #219 local init via push -------------------------------------
# `int x = 10;` at function entry used to emit `push bc` (alloc) +
# `ld hl,10; ld (slot),hl` (store). Now: `ld hl,10; push hl` —
# alloc AND store in one push. Each int-class init'd local at the
# function-body top saves 4-8 bytes (depending on FP mode / no-FP
# store sequence).

# Positive: assert push hl appears for the init and NO ld (slot),hl
# materialise. Returns 10 = 0x000A.
run_cpu_test z80 "push_init_one_local" "000A" '^[[:space:]]*push[[:space:]]+hl' '
int *r219_p;
int main(void) {
    int x = 10;
    r219_p = &x;
    return *r219_p;
}'

# Two leading inits — both should push.
run_cpu_test z80 "push_init_two_locals" "001E" '^[[:space:]]*push[[:space:]]+hl' '
int *r219b_p1; int *r219b_p2;
int main(void) {
    int a = 10;
    int b = 20;
    r219b_p1 = &a; r219b_p2 = &b;
    return *r219b_p1 + *r219b_p2;
}'

# Mixed: leading init + later non-init (the ca_value_used regression).
# x has init, y has no init. push x; alloc y. Returns 60 (50+10) -
# 50 - 10 (after compound) = ... actually: x += 10 → x=60; y = x*2
# = 120; return y - x = 60. Hex: 0x3C.
run_cpu_test z80 "push_init_mixed_init_noinit" "003C" '^[[:space:]]*push[[:space:]]+hl' '
int main(void) {
    int x = 50;
    int y;
    y = (x += 10) * 2;
    return y - x;
}'

# Negative: a leading decl with no init should NOT push (no value to
# push). frame allocated normally via push bc / modstk.
cfile_neg6="$WORK/no_push_init.c"; asm_neg6="$WORK/no_push_init.asm"
printf '%s\n' '
int *npi_p;
int main(void) {
    int z;
    npi_p = &z;
    z = 99;
    return z;
}' > "$cfile_neg6"
if ( cd "$WORK" && "$COMPILER" -mz80 no_push_init.c 2>/dev/null ); then
    # Should NOT see a push hl preceded by ld hl,<const> at function
    # start — that would mean we wrongly pushed an uninit value.
    # Instead expect push bc (alloc-only). Verify by checking the
    # asm shape — the simplest: prologue starts with push bc.
    if grep -A1 '^\._main' "$asm_neg6" | grep -qE '^[[:space:]]*push[[:space:]]+bc'; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("no_push_init: expected push bc prologue, got something else")
    fi
else
    fail=$((fail+1))
    failures+=("no_push_init: sccz80 failed")
fi

# --- #254 long push-init -------------------------------------------
# Extends #219 to 4-byte locals (LONG/CPTR/ACCUM32). `long a = X;`
# was emitting modstk (4-byte alloc) + push de;push hl;ld hl,N;
# add hl,sp;ld b,h;ld c,l;pop hl;pop de;call l_plong (~10 insns).
# Now: walk-and-widen leaves DE:HL = X, then push de;push hl (2 insns).
# Also handles multi-declarator decls `long a = X, b = Y, ...;` by
# descending one level of nested AST_COMPOUND_STMT.
# Hot for MD5Transform-style preludes.

# Positive: assert no `call l_plong` for a single long init. Verify
# that the four push-init bytes (push de;push hl, then nothing else
# before the next statement) appear at function start. Returns 7.
cfile_p254="$WORK/push_init_long.c"; asm_p254="$WORK/push_init_long.asm"
printf '%s\n' '
extern long g(void);
long sink;
int main(void) {
    long a = g();
    sink = a;
    return 7;
}' > "$cfile_p254"
if ( cd "$WORK" && "$COMPILER" -mz80 push_init_long.c 2>/dev/null ); then
    # The function must not contain `call l_plong` (the legacy alloc+
    # store dance that push-init replaces).
    if grep -qE '^[[:space:]]*call[[:space:]]+l_plong[[:space:]]*$' "$asm_p254"; then
        fail=$((fail+1))
        failures+=("push_init_long: l_plong still called (alloc+store dance not replaced)")
    # Function start: call g; push de; push hl ... (push-init pattern)
    elif ! awk '
        /^\._main/ { in_fn=1; next }
        in_fn && /^[[:space:]]*call[[:space:]]+_g[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*push[[:space:]]+de[[:space:]]*$/  { st=2; next }
        st==2 && /^[[:space:]]*push[[:space:]]+hl[[:space:]]*$/  { found=1; exit }
        in_fn { st=0 }
        END { exit !found }
    ' "$asm_p254"; then
        fail=$((fail+1))
        failures+=("push_init_long: call _g; push de; push hl push-init sequence not found")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("push_init_long: sccz80 failed")
fi

# Multi-declarator: `long a=X, b=Y, c=Z, d=W;` becomes nested
# AST_COMPOUND_STMT. Verify push-init still fires for all four.
# Each long init = one `push de; push hl`. Expect at least four
# pairs at function start with no intervening `call l_plong`.
cfile_p254m="$WORK/push_init_long_multi.c"; asm_p254m="$WORK/push_init_long_multi.asm"
printf '%s\n' '
extern long g(int);
long sink_a, sink_b, sink_c, sink_d;
int main(void) {
    long a = g(0), b = g(1), c = g(2), d = g(3);
    sink_a = a; sink_b = b; sink_c = c; sink_d = d;
    return 0;
}' > "$cfile_p254m"
if ( cd "$WORK" && "$COMPILER" -mz80 push_init_long_multi.c 2>/dev/null ); then
    if grep -qE '^[[:space:]]*call[[:space:]]+l_plong[[:space:]]*$' "$asm_p254m"; then
        fail=$((fail+1))
        failures+=("push_init_long_multi: l_plong still called (multi-declarator descent failed)")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("push_init_long_multi: sccz80 failed")
fi

# Runtime sanity: a single long push-init must produce the value
# we'd expect post-init. Returns low half of (0x11223344) = 0x3344.
run_test "push_init_long_runtime" "3344" '' '
long pil_seed(void) { return 0x11223344L; }
int main(void) {
    long a = pil_seed();
    return (int)(a & 0xFFFFL);
}'

# --- #255 copt rule: elide redundant sp-rel address recompute ------
# After `ld hl,N; add hl,sp; push hl` the walker often emits
# `ld hl,N+2; add hl,sp` to recompute the SAME slot address (since
# the push moved sp by 2). Push doesn't modify HL — HL still has
# &slot — so the recompute is dead weight. The copt rule in
# lib/80cc_rules.1 deletes the redundant `ld hl,N+2; add hl,sp`
# when N+2 follows N with a push hl between (the %eval guard
# checks `%2 - %1 == 2`).
# This fires in compound-assign chains on long locals (MD5
# Transform shape) — measured ~280k cycles saved per md5sum run
# on z80/8080/8085/z180.

cfile_p255="$WORK/copt_addr_recompute.c"; asm_p255="$WORK/copt_addr_recompute.asm"
printf '%s\n' '
extern long g(void);
int main(void) {
    long a = g();
    a += g();
    a += g();
    return (int)a;
}' > "$cfile_p255"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_addr_recompute.c 2>/dev/null ); then
    # Count how many `ld hl,N; add hl,sp; push hl` are immediately
    # followed by `ld hl,M; add hl,sp` where M == N+2 (the pattern
    # the rule should have eliminated). Should be 0 after copt.
    count=$(awk '
        /^[[:space:]]*ld[[:space:]]+hl,[0-9]+[[:space:]]+;const[[:space:]]*$/ {
            l=$0; sub(/^.*ld[[:space:]]+hl,/, "", l); sub(/[[:space:]]+;.*$/, "", l)
            o1=l+0; st=1; next
        }
        st==1 && /^[[:space:]]*add[[:space:]]+hl,sp[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*push[[:space:]]+hl[[:space:]]*$/ { st=3; next }
        st==3 && /^[[:space:]]*ld[[:space:]]+hl,[0-9]+[[:space:]]+;const[[:space:]]*$/ {
            l=$0; sub(/^.*ld[[:space:]]+hl,/, "", l); sub(/[[:space:]]+;.*$/, "", l)
            o2=l+0
            if (o2 == o1+2) c++
            st=0; next
        }
        { st=0 }
        END { print c+0 }
    ' "$asm_p255")
    if [ "$count" -ne 0 ]; then
        fail=$((fail+1))
        failures+=("copt_addr_recompute: $count redundant addr-recompute pattern(s) survived")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_addr_recompute: sccz80 failed")
fi

# Runtime sanity: same C must produce correct result. g()=3 each
# call, so final a = 9, low half = 0x0009.
run_test "copt_addr_recompute_runtime" "0009" '' '
long pil_three(void) { return 3L; }
int main(void) {
    long a = pil_three();
    a += pil_three();
    a += pil_three();
    return (int)a;
}'

# --- #256 copt rules: long-narrow + redundant zero -----------------
# #256a — `ld de,0; ld h,0; ld de,0` collapses to first two. Fires
# in walker emit for "narrow long to byte zero-padded" idioms where
# the walker emits a duplicate clear.
# #256b — `l_glong; ex de,hl; ld de,0` is loading a long then
# narrowing to just the HIGH HALF (low half discarded). Rewrites to
# `l_gint` at offset+2 (loading just the high half directly) +
# `ld de,0`. Saves an l_glong → l_gint helper swap (lighter call).
# #256c/d — Similar but for byte-3 (high byte of high half). The
# `ld l,d; ld h,0` shuffle extracts byte 3 of the long; rewrite
# to direct `ld l,(hl)` from offset+3. Two variants — with and
# without an intervening `srl l`.
# Combined gain: ~130k cycles per md5sum run on z80/z180; ~30k
# on 8080/8085 (the inline patterns map to the same rules
# regardless of CPU, but srl-l is z80-only so #256c gates that).

# Test #256b: long-to-high-half narrow. We construct a shape that
# exercises the walker's `(long >> 16)` cast pattern. The result
# in HL must equal the high half (0x1234 of 0x12345678).
cfile_p256b="$WORK/copt_long_narrow_high.c"; asm_p256b="$WORK/copt_long_narrow_high.asm"
printf '%s\n' '
extern unsigned long g(void);
extern void take(unsigned int);
void f(void) {
    unsigned long a = g();
    unsigned long b = g();
    take((unsigned int)(a >> 16));
    take((unsigned int)(b >> 16));
}
int main(void) { f(); return 0; }
extern unsigned long g(void);
unsigned long g(void) { return 0x12345678UL; }
extern void take(unsigned int);
void take(unsigned int x) { (void)x; }' > "$cfile_p256b"
RULES="${RULES:-$Z88DK_LIB/80cc_rules.1}"
asm_p256b_post="${asm_p256b%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_long_narrow_high.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256b" > "$asm_p256b_post" 2>/dev/null; then
    # After applying 80cc_rules.1, the #256b pattern must be gone.
    if awk '
        /^[[:space:]]*call[[:space:]]+l_glong[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*ex[[:space:]]+de,hl[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+de,0[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p256b_post"; then
        fail=$((fail+1))
        failures+=("copt_long_narrow_high: #256b pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_long_narrow_high: walker or copt failed")
fi

# Test #256a: the redundant ld de,0 pattern. Constructed shape
# triggers a narrow-to-byte where the walker emits the duplicate
# clear. Easier path: use the `(unsigned int)(long >> 24)` cast
# which lowers to the byte-3 extract pattern.
cfile_p256a="$WORK/copt_redundant_dezero.c"; asm_p256a="$WORK/copt_redundant_dezero.asm"
printf '%s\n' '
extern unsigned long g(void);
extern void take(unsigned char);
void f(void) {
    unsigned long a = g();
    take((unsigned char)(a >> 24));
}
int main(void) { f(); return 0; }
unsigned long g(void) { return 0xABCDEF12UL; }
void take(unsigned char x) { (void)x; }' > "$cfile_p256a"
asm_p256a_post="${asm_p256a%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_redundant_dezero.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256a" > "$asm_p256a_post" 2>/dev/null; then
    # After applying 80cc_rules.1, the #256a pattern must be gone.
    if awk '
        /^[[:space:]]*ld[[:space:]]+de,0[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*ld[[:space:]]+h,0[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+de,0[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p256a_post"; then
        fail=$((fail+1))
        failures+=("copt_redundant_dezero: #256a pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_redundant_dezero: walker or copt failed")
fi

# --- #256h compound long add (two sp-relative longs) → inline loop --
# `*dst += *src` on two sp-relative longs lowers to 4 runtime
# calls (l_glong×2, l_long_add, l_plong) + push/pop scaffolding,
# ~315t. Rewrite as a 4-iteration djnz byte-loop with carry: no
# helper calls, ~236t. Saves ~80t per fire AND shrinks code by
# 1-3 bytes vs the original sequence.
# 64 static fires in MD5Transform; ~2.6M cycles saved on z80,
# ~3.8M on 8080/8085, ~2.3M on z180. Also shrinks binary by
# 320 bytes on z80/z180, 192 on 8080, 189 on 8085.
cfile_p256h="$WORK/copt_long_add_inline.c"; asm_p256h="$WORK/copt_long_add_inline.asm"
printf '%s\n' '
extern long g(void);
int main(void) {
    long a = g();
    long b = g();
    a += b;
    return (int)a;
}' > "$cfile_p256h"
asm_p256h_post="${asm_p256h%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_long_add_inline.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256h" > "$asm_p256h_post" 2>/dev/null; then
    # Pattern must be replaced: no `call l_long_add` should follow
    # the compound-assign load sequence. Also, the rule's
    # signature instructions (`adc a,(hl)` inside a djnz loop)
    # should appear.
    if grep -qE "^[[:space:]]*call[[:space:]]+l_long_add[[:space:]]*$" "$asm_p256h_post"; then
        fail=$((fail+1))
        failures+=("copt_long_add_inline: l_long_add survived copt")
    elif ! grep -qE "^[[:space:]]*adc[[:space:]]+a,\(hl\)[[:space:]]*$" "$asm_p256h_post"; then
        fail=$((fail+1))
        failures+=("copt_long_add_inline: adc a,(hl) byte-loop body not emitted")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_long_add_inline: walker or copt failed")
fi

# Runtime sanity: long add via byte-loop must be correct.
# 0x12345678 + 0x11111111 = 0x23456789; low half = 0x6789.
run_test "copt_long_add_inline_runtime" "6789" '' '
long s1(void) { return 0x12345678L; }
long s2(void) { return 0x11111111L; }
int main(void) {
    long a = s1();
    long b = s2();
    a += b;
    return (int)(a & 0xFFFFL);
}'

# --- #256j zero-high long-OR → 16-bit OR ----------------------------
# `ld de,0; call l_long_or` ORs a 16-bit-in-HL (high half zero)
# with a stacked long. Equivalent to: low half = HL | LHS_low,
# high half = 0 | LHS_high = LHS_high. Rewrite uses two pops + a
# 16-bit OR: `pop de` (LHS_low) → `call l_or` (DE | HL → HL) →
# `pop de` (LHS_high). End state identical, ~30t faster and 1
# byte shorter per fire. Fires on all CPU targets uniformly —
# 20 sites in MD5.
cfile_p256j="$WORK/copt_long_or_zero_hi.c"; asm_p256j="$WORK/copt_long_or_zero_hi.asm"
printf '%s\n' '
extern unsigned long g(void);
extern unsigned int h(void);
unsigned long f(void) {
    unsigned long a = g();
    unsigned int b = h();
    return a | (unsigned long)b;
}
int main(void) { return (int)f(); }' > "$cfile_p256j"
asm_p256j_post="${asm_p256j%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_long_or_zero_hi.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256j" > "$asm_p256j_post" 2>/dev/null; then
    if awk '
        /^[[:space:]]*ld[[:space:]]+de,0[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*call[[:space:]]+l_long_or[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p256j_post"; then
        fail=$((fail+1))
        failures+=("copt_long_or_zero_hi: #256j pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_long_or_zero_hi: walker or copt failed")
fi

# --- #256i shift-right-8 long-load → inline 3-byte load --------------
# `l_glong; ld l,h; ld h,e; ld e,d; ld d,0` is "load long, shift
# right by 8 bits (drop low byte, zero top)". The shuffle picks
# up bytes 1-3 of the long into L/H/E with D=0. Rewrite skips
# the runtime helper and loads bytes 1-3 directly from sp+(N+1).
# Same size (12 bytes), ~22t faster per fire. 17 sites in MD5.
cfile_p256i="$WORK/copt_long_shr8.c"; asm_p256i="$WORK/copt_long_shr8.asm"
printf '%s\n' '
extern unsigned long g(void);
int main(void) {
    unsigned long a = g();
    return (int)((a >> 8) & 0xFFFFL);
}' > "$cfile_p256i"
asm_p256i_post="${asm_p256i%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_long_shr8.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256i" > "$asm_p256i_post" 2>/dev/null; then
    if awk '
        /^[[:space:]]*call[[:space:]]+l_glong[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*ld[[:space:]]+l,h[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+h,e[[:space:]]*$/ { st=3; next }
        st==3 && /^[[:space:]]*ld[[:space:]]+e,d[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p256i_post"; then
        fail=$((fail+1))
        failures+=("copt_long_shr8: #256i pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_long_shr8: walker or copt failed")
fi

# --- #256g sp+N int + const offset → BC inline ----------------------
# `ld hl,N; call l_gintsp; ex de,hl; ld hl,M; add hl,de` loads an
# int from sp+N then computes M+int. Rewrites to inline byte-pair
# load into BC, then HL = M+BC: 7 instructions vs 5, ~23t faster
# per fire. Heavily used in MD5Transform for `in[k]` indexing
# patterns — 76 static occurrences. Saves 660k cycles on z80,
# 640k on 8080, 1.23M on gbz80 (huge — gbz80's helper calls are
# more expensive), 170k on ez80, 620k on z180.
# Safety: BC is caller-clobber per the ABI. The original sequence
# leaves DE = the loaded int but that's not used in walker emit
# patterns (the next op consumes HL = address).

cfile_p256g="$WORK/copt_gintsp_offset.c"; asm_p256g="$WORK/copt_gintsp_offset.asm"
printf '%s\n' '
extern long g(unsigned long *);
unsigned long arr[4];
long f(unsigned long *p) {
    long a = g(p+1);
    long b = g(p+2);
    return a + b;
}
int main(void) { return (int)f(arr); }' > "$cfile_p256g"
asm_p256g_post="${asm_p256g%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_gintsp_offset.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256g" > "$asm_p256g_post" 2>/dev/null; then
    # Pattern `call l_gintsp; ex de,hl; ld hl,N; add hl,de` must be gone.
    if awk '
        st==1 && /^[[:space:]]*ex[[:space:]]+de,hl[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+hl,[0-9]+/ { st=3; next }
        st==3 && /^[[:space:]]*add[[:space:]]+hl,de[[:space:]]*$/ { found=1; exit }
        /^[[:space:]]*call[[:space:]]+l_gintsp[[:space:]]*$/ { st=1; next }
        { st=0 }
        END { exit !found }
    ' "$asm_p256g_post"; then
        fail=$((fail+1))
        failures+=("copt_gintsp_offset: #256g pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_gintsp_offset: walker or copt failed")
fi

# --- #256f l_gint2sp → inline pop/push ------------------------------
# `call l_gint2sp` loads the int at sp+2. Replace with
# `pop bc; pop hl; push hl; push bc` which stashes sp+0 in BC,
# loads sp+2 into HL, restores both slots. 1 byte larger (4 vs 3)
# but ~18t faster (skips the helper call/ret overhead and the
# inline `add hl,sp + ld a,(hl) + inc hl + ld h,(hl) + ld l,a`).
# BC is caller-clobber per the ABI so the trick is safe.
# Fires ~7 times statically in MD5Update's inner loop — heavily
# executed dynamically, ~400k cycles saved per md5sum run on
# z80/8080/z180. 8085 / Rabbit / KC160 use different load paths
# the rule doesn't match (and don't need it — they already beat
# sccz80).
cfile_p256f="$WORK/copt_gint2sp.c"; asm_p256f="$WORK/copt_gint2sp.asm"
printf '%s\n' '
extern int g(int);
int main(void) {
    int a = g(1);
    int b = g(2);
    return a + b;
}' > "$cfile_p256f"
asm_p256f_post="${asm_p256f%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_gint2sp.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p256f" > "$asm_p256f_post" 2>/dev/null; then
    # After copt, no `call l_gint2sp` should remain anywhere in main.
    if grep -qE "^[[:space:]]*call[[:space:]]+l_gint2sp[[:space:]]*$" "$asm_p256f_post"; then
        fail=$((fail+1))
        failures+=("copt_gint2sp: l_gint2sp survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_gint2sp: walker or copt failed")
fi

# --- range-elide must respect C usual-arithmetic-conversions -------
# `(int)(left|right) == (int)0xFDFF` was wrongly folded to "always
# false" because the range-elide pass only considered the typed
# operand's signed range. C promotes both sides to a common type;
# a positive literal beyond signed range can still match a negative-
# valued signed operand. The fix widens the elide range to the union
# of signed + unsigned for the operand's width — elision only fires
# when the literal is outside BOTH. Runtime check: the comparison
# returns 1 (matches). Repros test/suites/sccz80/bitwise.h:25.
run_test "range_elide_signed_unsigned_match" "0001" '' '
int main(void) {
    int left  = (int)0x3df7;
    int right = (int)0xc1ec;
    int r = (int)(left | right);   /* = (int)0xFDFF = -513 */
    int e = (int)0xFDFF;           /* = -513 */
    return r == e;                 /* must NOT fold to 0 */
}'

# Negative: the comparison must not be folded away. Compile the
# shape in isolation and grep the asm for any compare emission
# (`l_eq` helper call, or inline `sbc hl,de` after a sub). A wrongly
# folded result has `ld hl,0; ret` and nothing else.
cfile_re="$WORK/range_elide_check.c"; asm_re="$WORK/range_elide_check.asm"
printf '%s\n' '
int test_or_eq(int x, int y) {
    int r = (int)(x | y);
    int e = (int)0xFDFF;
    return r == e;
}' > "$cfile_re"
if ( cd "$WORK" && "$COMPILER" -mz80 range_elide_check.c 2>/dev/null ); then
    if grep -qE 'call[[:space:]]+l_eq|sbc[[:space:]]+hl' "$asm_re"; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("range_elide_check: comparison folded away (no l_eq / sbc hl)")
    fi
else
    fail=$((fail+1))
    failures+=("range_elide_check: sccz80 failed")
fi

# --- #253 pop hl/push hl fastpath for int sp+0 load ----------------
# gen_load_local for KIND_INT at sp+0 used to emit
# `ld hl,0; call l_gintsp` (6 bytes, ~57t). On z80 / z80n / z180 /
# gbz80 / ez80 (the CPUs with no native stack-relative int load) we
# now emit `pop hl; push hl` (2 bytes, 21t). Saves 4 bytes and ~36t
# per matching load. Runtime check: the cached value of `x` at sp+0
# after side_effect() must be correct.
run_test "pop_push_int_sp0" "002A" '^[[:space:]]*pop[[:space:]]+hl$' '
extern int side_effect(void);
static int side_effect_count;
int side_effect(void) { return ++side_effect_count; }
int main(void) {
    int x = side_effect();         /* push-init: x at sp+0 */
    return x + side_effect() + 39; /* x reads sp+0; result 1+2+39 = 0x2A */
}'

# Negative: the same shape must NOT emit `call l_gintsp` for the
# sp+0 read (would mean the fastpath didn't fire).
cfile_p253="$WORK/pop_push_check.c"; asm_p253="$WORK/pop_push_check.asm"
printf '%s\n' '
extern int g(void);
int f(void) {
    int x = g();
    return x + g();
}' > "$cfile_p253"
if ( cd "$WORK" && "$COMPILER" -mz80 pop_push_check.c 2>/dev/null ); then
    # Should see `pop hl` followed by `push hl` in f's body, and no
    # `call l_gintsp` (the unoptimised form would emit the helper
    # call with HL = 0).
    if ! grep -qE '^\s*pop\s+hl[[:space:]]*$' "$asm_p253"; then
        fail=$((fail+1))
        failures+=("pop_push_check: pop hl not emitted")
    elif grep -qE '^\s*call\s+l_gintsp[[:space:]]*$' "$asm_p253"; then
        fail=$((fail+1))
        failures+=("pop_push_check: l_gintsp still called for sp+0")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("pop_push_check: sccz80 failed")
fi

# Long sp+0 fastpath: gen_load_local for KIND_LONG at off=0 emits
# `pop hl; pop de; push de; push hl` (4 bytes, ~46t) instead of
# `ld hl,0; add hl,sp; call l_glong` (6 bytes, ~80t). Stack
# unchanged, DE:HL = the long.
# Test shape: long local x at sp+0, store to global — the store
# RHS routes through gen_load_local (not l_glong2sp, which is a
# binop-LHS-only fastpath that bypasses this path).
cfile_p253l="$WORK/pop_push_long.c"; asm_p253l="$WORK/pop_push_long.asm"
printf '%s\n' '
extern long g(void);
long sink;
void f(void) {
    long x = g();
    sink = x;
}' > "$cfile_p253l"
if ( cd "$WORK" && "$COMPILER" -mz80 pop_push_long.c 2>/dev/null ); then
    # Expect the four-instruction inline sequence in order.
    if ! awk '
        /^[[:space:]]*pop[[:space:]]+hl[[:space:]]*$/   { st=1; next }
        st==1 && /^[[:space:]]*pop[[:space:]]+de[[:space:]]*$/   { st=2; next }
        st==2 && /^[[:space:]]*push[[:space:]]+de[[:space:]]*$/  { st=3; next }
        st==3 && /^[[:space:]]*push[[:space:]]+hl[[:space:]]*$/  { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p253l"; then
        fail=$((fail+1))
        failures+=("pop_push_long: pop hl/pop de/push de/push hl not emitted (sp+0 long fastpath missing)")
    elif grep -qE '^\s*call\s+l_glong[[:space:]]*$' "$asm_p253l"; then
        fail=$((fail+1))
        failures+=("pop_push_long: l_glong still called for sp+0")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("pop_push_long: sccz80 failed")
fi

# --- 8085 ldsi/lhlx int-load fastpath must preserve DE -------------
# gen_load_local for KIND_INT on 8085 used to emit `ld de,sp+N;
# ld hl,(de)` which clobbers DE. The walker's contract for int
# loads is "HL=value, DE preserved" — z80's l_gintsp helper doesn't
# touch DE, and at least one long-arith pattern in md5sum keeps the
# long high half in DE across an int load mid-expression. Surfaced
# as md5sum on 8085 producing a wrong digest. Fix wraps the
# sequence in push/pop de so the contract is honored:
# `push de; ld de,sp+(N+2); ld hl,(de); pop de`. Asm assertion:
# any `ld de,sp+N` for the int-load fastpath must be immediately
# preceded by `push de`.
cfile_8085de="$WORK/ldsi_de_preserve.c"; asm_8085de="$WORK/ldsi_de_preserve.asm"
printf '%s\n' '
int f(int a, int b) {
    int x = a + b;
    return x;             /* forces an int store-then-load at sp+0 */
}' > "$cfile_8085de"
if ( cd "$WORK" && "$COMPILER" -m8085 ldsi_de_preserve.c 2>/dev/null ); then
    # Find any `ld de,sp+N` in the function body — every one must be
    # preceded by `push de` on the immediate previous line. If we see
    # a bare `ld de,sp+N` not preceded by push de, the fix regressed.
    if awk '
        /^[[:space:]]*ld[[:space:]]+de,sp\+/ {
            if (prev !~ /^[[:space:]]*push[[:space:]]+de[[:space:]]*$/) {
                print "BARE: " prev " ; " $0
                exit 1
            }
        }
        { prev = $0 }
    ' "$asm_8085de" >/dev/null; then
        ok=$((ok+1))
    else
        fail=$((fail+1))
        failures+=("ldsi_de_preserve: ld de,sp+N not preceded by push de (regression)")
    fi
else
    fail=$((fail+1))
    failures+=("ldsi_de_preserve: sccz80 -m8085 failed")
fi

# --- #260a byte→int<<8 inline fuse -----------------------------------
# `(unsigned int)*p << 8` walks as `ld l,(hl); ld h,0; ld h,l; ld l,0`
# (load byte → widen → shift left 8). Rewrite folds the four
# instructions into `ld h,(hl); ld l,0` — 3 bytes / 11 cycles
# saved. Fires once per inner loop in CRC-16-style code.
cfile_p260a="$WORK/copt_byte_shl8.c"; asm_p260a="$WORK/copt_byte_shl8.asm"
printf '%s\n' '
extern unsigned char *get_p(void);
unsigned int f(void) {
    unsigned char *p = get_p();
    return (unsigned int)*p << 8;
}
int main(void) { return (int)f(); }' > "$cfile_p260a"
asm_p260a_post="${asm_p260a%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_byte_shl8.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p260a" > "$asm_p260a_post" 2>/dev/null; then
    # The four-instruction LHS must NOT survive in the post-copt
    # output; the fused `ld h,(hl); ld l,0` must appear.
    if awk '
        /^[[:space:]]*ld[[:space:]]+l,\(hl\)[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*ld[[:space:]]+h,0[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+h,l[[:space:]]*$/ { st=3; next }
        st==3 && /^[[:space:]]*ld[[:space:]]+l,0[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p260a_post"; then
        fail=$((fail+1))
        failures+=("copt_byte_shl8: #260a LHS pattern survived copt")
    elif ! awk '
        /^[[:space:]]*ld[[:space:]]+h,\(hl\)[[:space:]]*$/ { st=1; next }
        st==1 && /^[[:space:]]*ld[[:space:]]+l,0[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p260a_post"; then
        fail=$((fail+1))
        failures+=("copt_byte_shl8: fused ld h,(hl);ld l,0 not emitted")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_byte_shl8: walker or copt failed")
fi

# Runtime sanity: byte 0x12 shifted left 8 must yield 0x1200.
run_test "copt_byte_shl8_runtime" "1200" '' '
static unsigned char b = 0x12U;
int main(void) { return (int)((unsigned int)b << 8); }'

# --- #260b drop redundant ld a,h;or l before jp z after and N ---------
# Walker emits `ld a,h; and N; ld h,a; ld l,0; ld a,h; or l; jp z,L`
# for `if (hi & N)` style truthiness on a 16-bit value that the
# walker has just narrowed-via-mask. The `ld a,h; or l` re-tests A
# but the Z flag from `and N` already covers the same condition
# (intervening LDs don't touch flags, and `or l` with L=0 is `or 0`
# which preserves A and sets Z based on A — same Z). Drop the two
# redundant instructions: 2 bytes / 8 cycles per fire.
cfile_p260b="$WORK/copt_test_and_jp.c"; asm_p260b="$WORK/copt_test_and_jp.asm"
printf '%s\n' '
extern unsigned int g(void);
int f(void) {
    unsigned int x = g();
    if (x & 0x8000U) return 1;
    return 0;
}
int main(void) { return f(); }' > "$cfile_p260b"
asm_p260b_post="${asm_p260b%.asm}.post.asm"
if ( cd "$WORK" && "$COMPILER" -mz80 copt_test_and_jp.c 2>/dev/null ) \
    && z88dk-copt -mz80 "$RULES" < "$asm_p260b" > "$asm_p260b_post" 2>/dev/null; then
    # The `ld a,h; or l; jp z` triplet must NOT survive immediately
    # after `ld l,0` (which itself must be preceded by `and N`).
    if awk '
        /^[[:space:]]*and[[:space:]]+/ { st=1; next }
        st==1 && /^[[:space:]]*ld[[:space:]]+h,a[[:space:]]*$/ { st=2; next }
        st==2 && /^[[:space:]]*ld[[:space:]]+l,0[[:space:]]*$/ { st=3; next }
        st==3 && /^[[:space:]]*ld[[:space:]]+a,h[[:space:]]*$/ { st=4; next }
        st==4 && /^[[:space:]]*or[[:space:]]+l[[:space:]]*$/ { found=1; exit }
        { st=0 }
        END { exit !found }
    ' "$asm_p260b_post"; then
        fail=$((fail+1))
        failures+=("copt_test_and_jp: #260b LHS pattern survived copt")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("copt_test_and_jp: walker or copt failed")
fi

# Runtime sanity: high-bit tests must still branch correctly.
run_test "copt_test_and_jp_runtime_hi" "0001" '' '
static unsigned int x = 0x8000U;
int main(void) { return (x & 0x8000U) ? 1 : 0; }'
run_test "copt_test_and_jp_runtime_lo" "0000" '' '
static unsigned int x = 0x0001U;
int main(void) { return (x & 0x8000U) ? 1 : 0; }'

# --- #261 CSE-synth cost-model gate ---------------------------------
# `crc << 1` appears twice in `(crc & 0x8000) ? ((crc<<1)^P) : (crc<<1)`.
# Pre-#261, cse-synth unconditionally hoisted it into a `1cse_<N>`
# synth temp — but on plain z80 each load from the temp slot costs
# more than the `add hl,hl` it replaces, AND the temp's
# `always_interferes=1` displaces the hot crc out of sp+2 into a
# deeper slot. Result: 45% intbench slowdown.
# After #261, the cost-model gate (recompute_total vs hoist_total)
# rejects the hoist. Test asserts no `1cse_` symbol survives in the
# emitted asm for a CRC-16-shaped function. Also asserts runtime
# correctness via a 1-iteration call.
cfile_p261="$WORK/cse_cost_model_no_hoist.c"
asm_p261="$WORK/cse_cost_model_no_hoist.asm"
printf '%s\n' '
extern unsigned char get_byte(void);
unsigned int f(void) {
    unsigned int crc = 0xFFFFU;
    crc ^= ((unsigned int)get_byte()) << 8;
    crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    return crc;
}
int main(void) { return (int)f(); }' > "$cfile_p261"
if ( cd "$WORK" && "$COMPILER" -mz80 cse_cost_model_no_hoist.c 2>/dev/null ); then
    if grep -qE "1cse_[0-9]" "$asm_p261"; then
        fail=$((fail+1))
        failures+=("cse_cost_model_no_hoist: 1cse_ temp synthesized (cost-model gate failed)")
    else
        ok=$((ok+1))
    fi
else
    fail=$((fail+1))
    failures+=("cse_cost_model_no_hoist: walker failed")
fi

# Companion runtime test: an EXPENSIVE subexpr (long multiply, ~200t)
# appearing twice SHOULD still be hoisted by cse-synth — the cost
# model must not be so conservative that it kills legitimate hoists.
# Two uses of `(a * b * c)` (long×long×long) in close stmts should
# be hoisted; we don't assert the hoist directly (would be fragile)
# but assert the runtime stays correct so the cost model and the
# resulting codegen don't silently miscompile.
run_test "cse_cost_model_long_mul_runtime" "0084" '' '
extern long g(void);
int main(void) {
    long a = 3, b = 4, c = 5;
    long x = (a * b * c) + 8;
    long y = (a * b * c) + 4;
    return (int)((x + y) & 0xFFFFL);
}'

# --- #264 byte-op-into-int compound assign fastpath -----------------
# `crc ^= ((unsigned int)*data++) << 8` produces, on 80cc, an in-place
# byte XOR into crc's high byte instead of the load / l_xor / l_pint
# shape. Verify runtime correctness for all three ops (^, |, &) and
# both shifts (0, 8).

run_test "p264_xor_shift8" "BDFF" '' '
unsigned int f(unsigned char *p) {
    unsigned int crc = 0xFFFFU;
    crc ^= ((unsigned int)*p++) << 8;
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x42, 0 };
    return (int)f(buf);
}'

run_test "p264_xor_shift0" "FFBD" '' '
unsigned int f(unsigned char *p) {
    unsigned int crc = 0xFFFFU;
    crc ^= (unsigned int)*p++;
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x42, 0 };
    return (int)f(buf);
}'

run_test "p264_or_shift8" "FFFF" '' '
unsigned int f(unsigned char *p) {
    unsigned int crc = 0xBDFFU;
    crc |= ((unsigned int)*p++) << 8;
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x42, 0 };
    return (int)f(buf);
}'

run_test "p264_and_shift8" "4200" '' '
unsigned int f(unsigned char *p) {
    unsigned int crc = 0xFFFFU;
    crc &= ((unsigned int)*p++) << 8;
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x42, 0 };
    return (int)f(buf);
}'

# Closer to the intbench shape: crc16-ccitt over 1 byte.
run_test "p264_crc16_ccitt_1byte" "F1D1" '' '
unsigned int crc16(unsigned char *data, unsigned int len) {
    unsigned int crc = 0xFFFFU;
    unsigned char *end = data + len;
    int i;
    while (data < end) {
        crc ^= ((unsigned int)*data++) << 8;
        for (i = 0; i < 8; i++)
            crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    }
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x01 };
    return (int)crc16(buf, 1);
}'

# 2-byte case — quickest way to spot a cross-iteration bug.
run_test "p264_crc16_ccitt_2byte" "0E7C" '' '
unsigned int crc16(unsigned char *data, unsigned int len) {
    unsigned int crc = 0xFFFFU;
    unsigned char *end = data + len;
    int i;
    while (data < end) {
        crc ^= ((unsigned int)*data++) << 8;
        for (i = 0; i < 8; i++)
            crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    }
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x01, 0x02 };
    return (int)crc16(buf, 2);
}'

# Closer to the intbench shape: full crc16-ccitt over 4 bytes.
run_test "p264_crc16_ccitt_4bytes" "89C3" '' '
unsigned int crc16(unsigned char *data, unsigned int len) {
    unsigned int crc = 0xFFFFU;
    unsigned char *end = data + len;
    int i;
    while (data < end) {
        crc ^= ((unsigned int)*data++) << 8;
        for (i = 0; i < 8; i++)
            crc = (crc & 0x8000U) ? ((crc << 1) ^ 0x1021U) : (crc << 1);
    }
    return crc;
}
int main(void) {
    static unsigned char buf[] = { 0x01, 0x02, 0x03, 0x04 };
    return (int)crc16(buf, 4);
}'

# #258 — multi-declarator + C99 for-decl slot-coloring miscompile.
# Pre-fix: parser wraps `unsigned int a=1,b=2,c=3,d=4;` in its own
# nested AST_COMPOUND_STMT (scope 1), and the following
# `for (unsigned int i = 0; ...)` body is also a sibling compound
# (scope 2). plan_walk treated them as non-interfering siblings so
# `i` got coloured into a/b/c/d's slot. Fix: flatten all-AST_DECL
# nested compounds back into the parent scope. Expected MD5-style
# mix on (x=0xCAFE, n=1) → 0xF084.
run_test "p258_for_decl_after_multi_decl" "F084" '' '
unsigned int mix(unsigned int x, unsigned int n) {
    unsigned int a=0x1234U, b=0x5678U, c=0x9ABCU, d=0xDEF0U;
    for (unsigned int i = 0; i < n; i++) {
        a = a + ((b & c) | ((~b) & d)) + x + 0x789AU;
    }
    return a;
}
int main(void) { return (int)mix(0xCAFE, 1); }'

# #258 — also exercise `for (int i = 0; ...)` (signed counter) with
# the same multi-declarator preamble, since the AST shape is the
# same as the unsigned variant.
run_test "p258_for_decl_signed_counter" "F084" '' '
unsigned int mix(unsigned int x, unsigned int n) {
    unsigned int a=0x1234U, b=0x5678U, c=0x9ABCU, d=0xDEF0U;
    for (int i = 0; i < (int)n; i++) {
        a = a + ((b & c) | ((~b) & d)) + x + 0x789AU;
    }
    return a;
}
int main(void) { return (int)mix(0xCAFE, 1); }'

# #265 — (unsigned char) cast on a signed char source. Walker loaded
# the source via the sign-extending `l_gcharsp` helper, leaving HL =
# 0xFFB2 for x=-78, but OP_CAST didn't strip the high byte for the
# unsigned target. Result: `(unsigned char)x` returned 0xFFB2
# instead of 0x00B2, surfaced as a charbench miscompile. Fix: add a
# `to == KIND_CHAR` case to OP_CAST that normalizes HL — `ld h,0` for
# unsigned, sign-extend from L's bit 7 for signed — when the cast
# crosses signedness or narrows from wider.
run_test "p265_unsigned_cast_signed_char" "00B2" '' '
static signed char g = -78;
int main(void) {
    signed char x = g;
    int y = (unsigned char)x;
    return y;
}'

# #265 — same shape via a parameter (avoids ast_opt cast-chain
# elision, which can remove no-op intermediate casts and bypass the
# walker's OP_CAST entirely — see #266).
run_test "p265_unsigned_cast_param" "00B2" '' '
static int convert(signed char x) {
    return (unsigned char)x;
}
int main(void) {
    return convert((signed char)-78);
}'

# #267 — char-self-feed ternary fastpath. CRC-8 bit-iter shape:
# `c = (c & SINGLE_BIT) ? byte_expr(c) : byte_expr(c)` should load c
# into A once, test via non-destructive `bit B,a`, evaluate each
# branch on A, store once. Asserts the asm uses `bit 7,a` (not the
# legacy `ld a,l; and 128; ld l,a; ld h,0; or l; jp z,...` widening
# dance) and runtime returns the correct shifted+xored byte.
run_test "p267_crc_bit_iter_local" "00FB" 'bit	7,a' '
static unsigned char g = 0xFEU;
int main(void) {
    unsigned char c = g;  /* c = 0xFE — bit 7 set; (c<<1)&0xFF = 0xFC; ^0x07 = 0xFB */
    c = (c & 0x80U) ? ((unsigned char)(c << 1) ^ 0x07U) : (unsigned char)(c << 1);
    return c;
}'

# #267 — global char variant. Same pattern but with c as a static
# global. The fastpath uses `ld a,(_sym)` / `ld (_sym),a` (no HL
# arithmetic needed) so the asm should not have `l_gcharsp` either.
run_test "p267_crc_bit_iter_global" "00FB" 'bit	7,a' '
static unsigned char c;
int main(void) {
    c = 0xFEU;
    c = (c & 0x80U) ? ((unsigned char)(c << 1) ^ 0x07U) : (unsigned char)(c << 1);
    return c;
}'

# #267 — else-branch fires when bit clear. c=0x42, bit 7 clear, so
# result is (c<<1) = 0x84.
run_test "p267_crc_bit_iter_else" "0084" 'bit	7,a' '
static unsigned char g = 0x42U;
int main(void) {
    unsigned char c = g;
    c = (c & 0x80U) ? ((unsigned char)(c << 1) ^ 0x07U) : (unsigned char)(c << 1);
    return c;
}'

# #268 — general byte-arith-in-A fastpath. `char_LV = char_op_char`
# shapes from schar_mix etc. Default path called `l_gcharsp` twice
# (each: load + sign-extend to int, ~64 cyc) then did a 16-bit
# subtraction; the fastpath does `ld a,(addr1); ld hl,&addr2;
# sub (hl); ld (addr1),a` instead. Assert the asm uses `sub (hl)`
# / `add a,(hl)` (not `l_gcharsp` / `l_xor`) and runtime returns
# the correct byte. acc=-50, b=20 → acc-b = -70 = 0xBA.
run_test "p268_char_sub_local" "00BA" 'sub[[:space:]]+\(hl\)' '
static signed char ga = -50;
static signed char gb = 20;
int main(void) {
    signed char a = ga;
    signed char b = gb;
    a = (signed char)(a - b);
    return (unsigned char)a;
}'

# #268 — char ADD between two LVs. acc=100, b=50 → acc+b = 150 = 0x96
# as signed char = -106. Low byte 0x96.
run_test "p268_char_add_local" "0096" 'add[[:space:]]+\(hl\)' '
static signed char ga = 100;
static signed char gb = 50;
int main(void) {
    signed char a = ga;
    signed char b = gb;
    a = (signed char)(a + b);
    return (unsigned char)a;
}'

# #268 — combined shape `(c << 1) ^ b` from schar_mix. acc=0x42 (=66),
# b=0x07 → (acc<<1)^b = 0x84^0x07 = 0x83.
run_test "p268_char_shift_xor_combo" "0083" 'xor[[:space:]]+\(hl\)' '
static signed char ga = 0x42;
static signed char gb = 0x07;
int main(void) {
    signed char a = ga;
    signed char b = gb;
    a = (signed char)((a << 1) ^ b);
    return (unsigned char)a;
}'

# #268 — global char target. Same shape but with c as a static global.
# Assert the asm has direct `ld a,(_c)` / `ld (_c),a` paths.
run_test "p268_char_sub_global" "00BA" 'ld[[:space:]]+\(_c\),a' '
static signed char c = -50;
static signed char b = 20;
int main(void) {
    c = (signed char)(c - b);
    return (unsigned char)c;
}'

# --- #274 AST_PRESERVE_BC type propagation -------------------------
# Loop-reversal pass wraps function calls inside the loop body in an
# AST_PRESERVE_BC node. Pre-fix, that wrapper had a NULL type field,
# so cg2_walk_to_long saw the wrapper as KIND_INT and emitted a
# spurious `call l_int2long_s` after the long-returning func call.
# That destroyed DE (the high half of the long return), causing
# crcbench to miscompile.
#
# Fix: ast_preserve_bc() propagates child->type onto itself.
# Compile-only check: a for-loop body XOR-assigning a long-returning
# call must NOT emit l_int2long_s anywhere in the function.
cfile_p274="$WORK/p274_preserve_bc.c"
asm_p274="$WORK/p274_preserve_bc.asm"
printf '%s\n' '
extern unsigned long get_long(void);
unsigned long sink;
int main(void) {
    unsigned long crc = 0;
    unsigned int rep;
    for (rep = 0; rep < 3; rep++) {
        crc ^= get_long();
    }
    sink = crc;
    return 0;
}' > "$cfile_p274"
if ! ( cd "$WORK" && "$COMPILER" p274_preserve_bc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("p274_preserve_bc: 80cc failed")
elif grep -qE 'call[[:space:]]+l_int2long_s' "$asm_p274"; then
    fail=$((fail+1)); failures+=("p274_preserve_bc: spurious l_int2long_s after long-returning call")
else
    ok=$((ok+1))
fi

# --- #283 long++ via l_inclong → l_long_inc_mhl --------------------
# When a stack-local long has a side-effecting `(*p)++` (or similar
# `long_var++` discarded as a statement), the walker emits the
# generic 5-instruction sequence `push hl; call l_glong; call
# l_inclong; pop bc; call l_plong`. l_long_inc_mhl does the same
# in-place via `inc (hl); inc hl; inc (hl); ...` byte-by-byte and
# saves the load+store round-trip when HL is dead after.
#
# Test: post-inc through a pointer, result discarded. Assert no
# `call l_inclong` (the pre-rule helper) in the emit.
cfile_p283="$WORK/p283_long_inc.c"
asm_p283="$WORK/p283_long_inc.asm"
asm_p283_post="$WORK/p283_long_inc.post.asm"
RULES_p283="$Z88DK_LIB/80cc_rules.1"
printf '%s\n' '
extern unsigned long *gp;
int main(void) {
    (*gp)++;
    return 0;
}
unsigned long sink;
unsigned long *gp = &sink;' > "$cfile_p283"
if ! ( cd "$WORK" && "$COMPILER" p283_long_inc.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("p283_long_inc: 80cc failed")
elif ! z88dk-copt -mz80 "$RULES_p283" < "$asm_p283" > "$asm_p283_post" 2>/dev/null; then
    fail=$((fail+1)); failures+=("p283_long_inc: copt failed")
elif grep -qE 'call[[:space:]]+l_inclong' "$asm_p283_post"; then
    fail=$((fail+1)); failures+=("p283_long_inc: copt didn't collapse l_inclong → l_long_inc_mhl")
elif ! grep -qE 'call[[:space:]]+l_long_inc_mhl' "$asm_p283_post"; then
    fail=$((fail+1)); failures+=("p283_long_inc: l_long_inc_mhl not present post-copt")
else
    ok=$((ok+1))
fi

# --- #218b/c walker literal-store fastpath -------------------------
# OP_ASSIGN with AST_LITERAL RHS and discarded result now bypasses
# the load-K + helper-call round-trip and emits direct
# `gen_local_addr / cg2_walk(lhs)` followed by `ld (hl),lo; inc hl;
# ld (hl),hi[; ...]`. Replaces the copt rule #284 with a walker fold
# that also extends to struct fields, array elements, and pointer
# stores. Test: a function full of `x = K` stores should produce
# zero `call l_pint` / `call l_plong` in the emitted asm.
cfile_p218bc="$WORK/p218bc_literal_stores.c"
asm_p218bc="$WORK/p218bc_literal_stores.asm"
printf '%s\n' '
struct S { int a; long b; char c; };
struct S g;
int arr[4];
unsigned long lg;
int main(void) {
    int li = 0;
    long ll = 0L;
    li = 42;          /* local int */
    ll = 0x1234UL;    /* local long */
    g.a = 7;          /* struct field int */
    g.b = 0xCAFEUL;   /* struct field long */
    g.c = 99;         /* struct field char */
    arr[2] = 11;      /* array elem (const idx) */
    lg = 0xBABEUL;    /* global long */
    return li + g.a + g.c + arr[2] + (int)ll + (int)g.b + (int)lg;
}' > "$cfile_p218bc"
if ! ( cd "$WORK" && "$COMPILER" p218bc_literal_stores.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("p218bc_literal_stores: 80cc failed")
elif grep -qE 'call[[:space:]]+l_pint\b' "$asm_p218bc"; then
    fail=$((fail+1)); failures+=("p218bc_literal_stores: l_pint not elided")
elif grep -qE 'call[[:space:]]+l_plong\b' "$asm_p218bc"; then
    fail=$((fail+1)); failures+=("p218bc_literal_stores: l_plong not elided")
else
    ok=$((ok+1))
fi

# --- #L1 / #L2 / #L5 long-fastpath OR/AND/XOR const ----------------
# zor_const / zand_const / zxor_const now inline byte-wise ops on
# the long's low half when the upper 16 bits are 0 (#L1, OR/XOR) or
# 0xFFFF (#L2 AND, #L5 OR/XOR), instead of falling through to the
# generic `lpush + vlongconst + l_long_*` runtime sandwich. Test:
# a function full of the relevant masks should emit zero
# `call l_long_or` / `call l_long_and` / `call l_long_xor`.
cfile_pL125="$WORK/pL125_long_op_const.c"
asm_pL125="$WORK/pL125_long_op_const.asm"
printf '%s\n' '
unsigned long g;
void or_u0_multi(void)    { g |= 0x00001234UL; }  /* #L1 */
void or_u1_multi(void)    { g |= 0xFFFF1234UL; }  /* #L5 */
void or_u1_lowzero(void)  { g |= 0xFFFF0000UL; }  /* #L5 low=0 */
void xor_u0_multi(void)   { g ^= 0x00001234UL; }  /* #L1 */
void xor_u1_multi(void)   { g ^= 0xFFFF1234UL; }  /* #L5 */
void xor_u1_lowzero(void) { g ^= 0xFFFF0000UL; }  /* #L5 low=0 */
void and_u1_multi(void)   { g &= 0xFFFF1234UL; }  /* #L2 */
int main(void) {
    g = 0;
    or_u0_multi();    or_u1_multi();    or_u1_lowzero();
    xor_u0_multi();   xor_u1_multi();   xor_u1_lowzero();
    and_u1_multi();
    return 0;
}' > "$cfile_pL125"
if ! ( cd "$WORK" && "$COMPILER" pL125_long_op_const.c 2>/dev/null ); then
    fail=$((fail+1)); failures+=("pL125_long_op_const: 80cc failed")
elif grep -qE 'call[[:space:]]+l_long_or\b' "$asm_pL125"; then
    fail=$((fail+1)); failures+=("pL125_long_op_const: l_long_or not elided (#L1/#L5)")
elif grep -qE 'call[[:space:]]+l_long_and\b' "$asm_pL125"; then
    fail=$((fail+1)); failures+=("pL125_long_op_const: l_long_and not elided (#L2)")
elif grep -qE 'call[[:space:]]+l_long_xor\b' "$asm_pL125"; then
    fail=$((fail+1)); failures+=("pL125_long_op_const: l_long_xor not elided (#L1/#L5)")
else
    ok=$((ok+1))
fi

# --- Summary -------------------------------------------------------
echo "opt_fold suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
