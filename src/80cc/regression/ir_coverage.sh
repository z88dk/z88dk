#!/bin/bash
# 80cc IR coverage regressions. Each test exercises a specific AST
# / IR shape that previously caused ir_build to bail (`deferred` /
# `not yet supported` / `unsupported`) and pushed the function to
# the walker. Asserts that the compile completes WITHOUT any
# `ir_build:` deferral message — i.e. the function is now fully
# handled by the IR pipeline.

set -u
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
reg_check_env || exit 2

WORK="${WORK:-/tmp/sccz80_reg_ir_coverage}"
mkdir -p "$WORK"
rm -f "$WORK"/*.asm "$WORK"/*.c "$WORK"/*.s "$WORK"/*.log

ok=0
fail=0
failures=()

# Compile $2 with --use-ir and assert no ir_build deferral fires
# AND (optionally) that the asm contains a marker pattern $3.
# $1 is the test name; $4 is the C source.
run_cover() {
    local name="$1"
    local marker="$2"
    local src="$3"
    local cfile="$WORK/$name.c"
    local asm="$WORK/$name.asm"
    local log="$WORK/$name.log"
    printf '%s\n' "$src" > "$cfile"
    if ! ( cd "$WORK" && "$COMPILER" --use-ir "$name.c" 2>"$log" ); then
        fail=$((fail+1))
        failures+=("$name: compile failed")
        return
    fi
    if grep -q "ir_build:" "$log"; then
        fail=$((fail+1))
        failures+=("$name: ir_build deferred — $(grep ir_build: "$log" | head -1)")
        return
    fi
    if [ -n "$marker" ]; then
        if ! grep -qE "$marker" "$asm"; then
            fail=$((fail+1))
            failures+=("$name: expected asm marker '$marker' missing")
            return
        fi
    fi
    ok=$((ok+1))
}

# --- 1. AST_FUNCPTR_CALL: indirect call through function pointer ---
# `fn(x)` where fn is a vreg holding a code address. Lowers via
# load_to_hl + `call l_jphl` (the jp (hl) thunk).
run_cover "funcptr_call" 'l_jphl' '
typedef int (*fn_t)(int);
int call_via(fn_t fn, int x) { return fn(x); }'

# --- 2. OP_OROR / OP_ANDAND: short-circuit && and || -----------------
# Produce canonical int 0/1 with a 2-BB diamond per operator. Test
# that the asm has the conditional branch the short-circuit emits.
run_cover "short_circuit_andand" '(jp\s+z|jp\s+nz)' '
int test(int a, int b) { return a && b; }'

run_cover "short_circuit_oror" '(jp\s+z|jp\s+nz)' '
int test(int a, int b) { return a || b; }'

# --- 3. AST_ASM stmt: inline asm pass-through -----------------------
# `asm("nop")` carries text in n->labelname; IR_ASM emits verbatim.
run_cover "ast_asm" 'nop' '
int test(int x) { asm("nop"); return x; }'

# --- 4. post/pre step on global var --------------------------------
# `g++` on a global lowers to IR_LD_MEM IR_MEM_SYM + IR_INC + IR_ST_MEM.
run_cover "post_inc_global" 'ld[[:space:]]+hl,\(_gcount\)' '
int gcount;
int bump(void) { return gcount++; }'

run_cover "pre_inc_global" 'ld[[:space:]]+hl,\(_gerr\)' '
int gerr;
int bumpit(void) { return ++gerr; }'

# Long global step uses ADD imm=1.
run_cover "post_inc_long_global" 'ld[[:space:]]+hl,\(_lg\)' '
unsigned long lg;
unsigned long bump_long(void) { return lg++; }'

# --- 6. Array > 127 bytes (int16_t slot width) --------------------
# md5's `data[1024]` archetype. VReg.width was int8_t (cap 127);
# now int16_t so multi-KB locals fit.
run_cover "large_array_local" 'ld[[:space:]]+hl,-10[0-9][0-9]' '
void use_byte(unsigned char *);
void big_buf(void) {
    unsigned char data[1024];
    use_byte(data);
}'

# --- 7. OP_CAST as a statement -------------------------------------
# `(void)x;` / `(int)expr;` — value discarded, side effects kept.
# Stmt walker default now routes OP_CAST through build_expr.
run_cover "cast_as_stmt" '_v_used' '
extern int v_used;
void test(void) { (int)v_used; }'

# --- 5. AST_FUNC_CALL fastcall convention --------------------------
# A function declared __z88dk_fastcall takes its last arg in HL
# (or DEHL for long) with no stack push. Synthesise our own to
# avoid system-header lookups.
run_cover "fastcall_call" 'call\s+_my_fc' '
extern int my_fc(int n) __z88dk_fastcall;
int outer(int x) { return my_fc(x) + 1; }'

# --- 8. AST_SWITCH stmt coverage -----------------------------------
# `switch (e) { case K1: ...; default: ...; }` lowers to IR_SWITCH:
# int scrutinee → `call l_case` + inline defw table. Body is walked
# normally; case labels are AST_LABELs handled by the existing path.
run_cover "switch_basic" 'call\s+l_case' '
int test(int x) {
    switch (x) {
    case 1: return 10;
    case 2: return 20;
    default: return -1;
    }
}'

# AST_COMPOUND_STMT as expression (doexpr() wraps every expression in
# a singleton compound). Switch sw_expr is the first consumer; comma
# expressions in for(;cond;) / if(cond) also rely on it.
run_cover "comma_expr" '' '
int test(int a, int b, int c) {
    return (a + 1, b + 2, c + 3);
}'

# --- 9. _Accum: ADD/SUB/CMP/NEG lower as integer ops. MUL/DIV go
# through l_fix16_{mul,div}{s,u} (HL = RHS, stack = LHS). Parser
# blocks bitwise & shift on _Accum so they never reach IR.
run_cover "accum16_add" 'add[[:space:]]+hl,de' '
_Accum a_add(_Accum a, _Accum b) { return a + b; }'

run_cover "accum16_cmp" 'sbc[[:space:]]+hl,de' '
int a_lt(_Accum a, _Accum b) { return a < b; }'

run_cover "accum16_neg" 'sbc[[:space:]]+hl,de' '
_Accum a_neg(_Accum a) { return -a; }'

run_cover "accum32_add" 'adc[[:space:]]+a,\(hl\)' '
long _Accum la_add(long _Accum a, long _Accum b) { return a + b; }'

run_cover "accum16_mul_signed" 'call\s+l_fix16_muls' '
_Accum a_mul(_Accum a, _Accum b) { return a * b; }'

run_cover "accum16_div_signed" 'call\s+l_fix16_divs' '
_Accum a_div(_Accum a, _Accum b) { return a / b; }'

run_cover "accum16_mul_unsigned" 'call\s+l_fix16_mulu' '
unsigned _Accum a_umul(unsigned _Accum a, unsigned _Accum b) { return a * b; }'

# long _Accum mul/div emit l_fix32_* helper calls (helpers don't yet
# exist in libsrc — link-fails at z80asm time same as walker — but
# the IR-side emit is verified).
run_cover "accum32_mul_signed" 'call\s+l_fix32_muls' '
long _Accum t(long _Accum a, long _Accum b) { return a * b; }'

run_cover "accum32_to_int" 'call\s+l_fix32_f2sint' '
long _Accum a; int t(void) { return (int) a; }'

run_cover "int_to_accum32" 'call\s+l_fix32_sint2f' '
int x; long _Accum t(void) { return (long _Accum) x; }'

# --- 10. &(*x): address-of through a deref ------------------------
# The parser emits `(addr (deref X))` for array-decay shapes like
# `&(*jp)` where jp is pointer-to-array. Semantically it's just X's
# rvalue. Verifies the build_expr passthrough works.
run_cover "addr_of_deref" 'call\s+_lj' '
extern void lj(int *p, int v);
void f(int **jp) { lj(&(*jp), 0); }'

# --- 11. &p->member / &arr[i]: folded additive address-of ----------
# The parser folds these to `(addr (+ ...))` — the operand already
# computes the address, so OP_ADDR just evaluates it.
run_cover "addr_member_via_ptr" '' '
typedef struct { int x; int y; } P;
int f(P *p) { int *py = &p->y; *py = 7; return p->y; }'

run_cover "addr_array_elem" '' '
int g(int i) { int arr[4]; int *pa = &arr[i]; *pa = 11; return arr[i]; }'

# --- 12. prototype param names differ from the definition ----------
# The param vreg mapping resolves loctab by name; the definition'\''s
# names are synced onto the retained prototype Type at definition
# time (declparse), covering renamed and unnamed-prototype params.
run_cover "proto_param_rename" '' '
extern int f(char *name, int namelen, char *buf);
int f(char *name, int len, char *buf) { return len + (int)name[0]; }'

# (Plain prototype, not fastcall: fastcall CALLEES defer to the
# walker — the IR prologue doesn't model the pushed-HL param yet.)
run_cover "proto_param_unnamed" '' '
extern unsigned char g(unsigned char *);
unsigned char g(unsigned char *p) { return *p + 1; }'

# --- 13. switch dispatch routes ------------------------------------
# char scrutinee → inline cp chain (no l_case); long → l_long_case.
run_cover "switch_char_inline" 'cp\s+98' '
int test(char c) {
    switch (c) {
    case 97: return 1;
    case 98: return 2;
    default: return 0;
    }
}'

run_cover "switch_long_table" 'call\s+l_long_case' '
int test(unsigned long v) {
    switch (v) {
    case 0x10001UL: return 1;
    case 0x20002UL: return 2;
    default: return 0;
    }
}'

# --- 14. trampoline elision ----------------------------------------
# BR-only BBs emit as `defc Lx = Ly` label aliases instead of
# label+jp — 3 bytes and a 10T hop saved per trampoline, which sits
# on the back-edge of builder-generated while loops.
run_cover "trampoline_defc" 'defc\s+L_f' '
int sum(unsigned char *p, int n) {
    int s = 0;
    while (n--) s += *p++;
    return s;
}'

# --- Summary -------------------------------------------------------
echo "ir_coverage suite:"
echo "  ok:   $ok"
echo "  fail: $fail"
if [ $fail -gt 0 ]; then
    for f in "${failures[@]}"; do echo "  - $f"; done
    exit 1
fi
exit 0
