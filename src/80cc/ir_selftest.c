/*
 * ir_selftest.c — minimal exerciser for the IR skeleton.
 *
 * Constructs a tiny Func by hand (without ir_build, which doesn't exist
 * yet) and validates + dumps it. Compile and run standalone to confirm
 * the skeleton holds together:
 *
 *     cc -I. -o ir_selftest ir_selftest.c ir.c
 *     ./ir_selftest
 *
 * This is throwaway test code. Once ir_build exists and the full
 * pipeline can be exercised end-to-end via the compiler, this file
 * goes away.
 */

#include "ir.h"
#include "ir_lower.h"
#include "ir_analysis.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Stub for ir_sym_name — the real impl lives in ir_compiler_glue.c
 * which pulls in ccdefs.h. The selftest fakes a SYMBOL by stashing a
 * `char *` at offset 0 (the SYMBOL.name field) and reading it back. */
struct fake_sym { char name[64]; };
const char *ir_sym_name(const SYMBOL *sym)
{
    return sym ? ((const struct fake_sym *)sym)->name : "?";
}
const char *ir_sym_prefix(const SYMBOL *sym)
{
    (void)sym;
    return "_";
}

static int build_add_two(Func *f)
{
    /* C equivalent:
     *   int add(int a, int b) { return a + b; }
     */

    /* Vregs */
    int v_a   = ir_vreg_new(f, 2 /*KIND_INT placeholder*/, NULL, IR_VREG_PARAM);
    int v_b   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int v_sum = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
    (void)v_a; (void)v_b; (void)v_sum;

    /* Entry BB */
    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    /* v_sum = ADD v_a, v_b   (aliased: dst = src[0]; src[0]=v_a, src[1]=v_b) */
    ir_emit_binop(bb, IR_ADD, v_sum, v_a, v_b);

    /* RET v_sum */
    ir_emit_ret(bb, v_sum);

    return entry;
}

static int build_loop(Func *f)
{
    /* C equivalent:
     *   int sum_n(int n) {
     *     int s = 0;
     *     for (int i = 0; i < n; i++) s += i;
     *     return s;
     *   }
     */

    int v_n   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int v_s   = ir_vreg_new(f, 2, NULL, 0);
    int v_i   = ir_vreg_new(f, 2, NULL, IR_VREG_INDUCTION);
    int v_cmp = ir_vreg_new(f, 2, NULL, 0);

    int entry  = ir_bb_new(f);
    int header = ir_bb_new(f);
    int body   = ir_bb_new(f);
    int exitb  = ir_bb_new(f);

    /* entry: s = 0; i = 0; goto header */
    BB *bb = &f->bbs[entry];
    ir_emit_ld_imm(bb, v_s, 0);
    ir_emit_ld_imm(bb, v_i, 0);
    ir_emit_br(bb, header);

    /* header: cmp = i < n; if cmp == 0 → exit; else → body */
    bb = &f->bbs[header];
    ir_emit_binop(bb, IR_CMP_LT, v_cmp, v_i, v_n);
    ir_emit_br_zero(bb, v_cmp, exitb);
    bb->succ[1] = body;     /* fall-through to body */

    /* body: s = s + i; i = i + 1; goto header */
    bb = &f->bbs[body];
    ir_emit_binop(bb, IR_ADD, v_s, v_s, v_i);     /* aliased */
    ir_emit_unop(bb, IR_INC, v_i, v_i);            /* aliased */
    ir_emit_br(bb, header);

    /* exit: return s */
    bb = &f->bbs[exitb];
    ir_emit_ret(bb, v_s);

    return entry;
}

/* Build the simplest possible function for the lowerer test:
 *   int test_const(void) { return 7 + 3; }
 * No params, returns an int constant.
 */
static void build_const_add(Func *f)
{
    int v0  = ir_vreg_new(f, 2, NULL, 0);    /* 7 */
    int v1  = ir_vreg_new(f, 2, NULL, 0);    /* 3 */
    int v2  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);   /* sum */

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    ir_emit_ld_imm(bb, v0, 7);
    ir_emit_ld_imm(bb, v1, 3);
    ir_emit_binop(bb, IR_ADD, v2, v0, v1);
    ir_emit_ret(bb, v2);
}

/* Exercise the new Phase 1.3 ops:
 *   int test_ops(void) {
 *     int a = 17, b = 5;
 *     int s = a - b;          // SUB
 *     int n = -s;             // NEG
 *     int m = ~n;             // NOT
 *     int x = m & 0x0F;       // AND
 *     int y = x | 0x30;       // OR
 *     int z = y ^ 0x55;       // XOR
 *     int cmp_lt = (a < b);   // CMP_LT (signed)
 *     int cmp_ult = (a < b);  // CMP_ULT (unsigned)
 *     int cmp_eq = (a == b);  // CMP_EQ
 *     return z + cmp_lt + cmp_ult + cmp_eq;
 *   }
 * No params; just verifies shape + assembly.
 */
static void build_ops_mix(Func *f)
{
    int va  = ir_vreg_new(f, 2, NULL, 0);
    int vb  = ir_vreg_new(f, 2, NULL, 0);
    int vs  = ir_vreg_new(f, 2, NULL, 0);
    int vn  = ir_vreg_new(f, 2, NULL, 0);
    int vm  = ir_vreg_new(f, 2, NULL, 0);
    int vk_0f = ir_vreg_new(f, 2, NULL, 0);
    int vk_30 = ir_vreg_new(f, 2, NULL, 0);
    int vk_55 = ir_vreg_new(f, 2, NULL, 0);
    int vx  = ir_vreg_new(f, 2, NULL, 0);
    int vy  = ir_vreg_new(f, 2, NULL, 0);
    int vz  = ir_vreg_new(f, 2, NULL, 0);
    int vlt = ir_vreg_new(f, 2, NULL, 0);
    int vult = ir_vreg_new(f, 2, NULL, 0);
    int veq = ir_vreg_new(f, 2, NULL, 0);
    int vt1 = ir_vreg_new(f, 2, NULL, 0);
    int vt2 = ir_vreg_new(f, 2, NULL, 0);
    int vret = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    ir_emit_ld_imm(bb, va, 17);
    ir_emit_ld_imm(bb, vb, 5);
    ir_emit_binop(bb, IR_SUB, vs, va, vb);
    ir_emit_unop(bb, IR_NEG, vn, vs);
    ir_emit_unop(bb, IR_NOT, vm, vn);
    ir_emit_ld_imm(bb, vk_0f, 0x0F);
    ir_emit_ld_imm(bb, vk_30, 0x30);
    ir_emit_ld_imm(bb, vk_55, 0x55);
    ir_emit_binop(bb, IR_AND, vx, vm, vk_0f);
    ir_emit_binop(bb, IR_OR,  vy, vx, vk_30);
    ir_emit_binop(bb, IR_XOR, vz, vy, vk_55);
    ir_emit_binop(bb, IR_CMP_LT,  vlt,  va, vb);
    ir_emit_binop(bb, IR_CMP_ULT, vult, va, vb);
    ir_emit_binop(bb, IR_CMP_EQ,  veq,  va, vb);
    ir_emit_binop(bb, IR_ADD, vt1, vz,  vlt);
    ir_emit_binop(bb, IR_ADD, vt2, vt1, vult);
    ir_emit_binop(bb, IR_ADD, vret, vt2, veq);
    ir_emit_ret(bb, vret);
}

/* Static buffers giving us "SYMBOL" addresses to point at. The lowerer
 * only reads `name`; the rest of the fields are unused, so a plain
 * fake_sym with a name field is enough for selftest. */
static struct fake_sym sym_g   = { "g" };
static struct fake_sym sym_arr = { "arr" };

/*  extern int g;
 *  extern int arr[];
 *  int test_sym(void) {
 *      g = 42;
 *      return g + arr[3];
 *  }
 */
static void build_sym_test(Func *f)
{
    int v_42  = ir_vreg_new(f, 2, NULL, 0);
    int v_gld = ir_vreg_new(f, 2, NULL, 0);
    int v_arr = ir_vreg_new(f, 2, NULL, 0);
    int v_ret = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    /* g = 42 */
    ir_emit_ld_imm(bb, v_42, 42);
    Op *st = ir_op_emit(bb, IR_ST_MEM);
    st->src[0] = v_42;
    st->mem.kind = IR_MEM_SYM;
    st->mem.sym  = (SYMBOL *)&sym_g;
    st->mem.offset = 0;

    /* g_load = (g) */
    Op *ld = ir_op_emit(bb, IR_LD_MEM);
    ld->dst = v_gld;
    ld->mem.kind = IR_MEM_SYM;
    ld->mem.sym  = (SYMBOL *)&sym_g;

    /* arr3 = (arr + 6) */
    Op *ld2 = ir_op_emit(bb, IR_LD_MEM);
    ld2->dst = v_arr;
    ld2->mem.kind = IR_MEM_SYM;
    ld2->mem.sym  = (SYMBOL *)&sym_arr;
    ld2->mem.offset = 6;

    ir_emit_binop(bb, IR_ADD, v_ret, v_gld, v_arr);
    ir_emit_ret(bb, v_ret);
}

/*  extern int g;
 *  int *test_addr(void) { return &g; }
 */
static void build_addr_test(Func *f)
{
    int v_addr = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    Op *ld = ir_op_emit(bb, IR_LD_SYM);
    ld->dst = v_addr;
    ld->mem.kind = IR_MEM_SYM;
    ld->mem.sym  = (SYMBOL *)&sym_g;
    ld->mem.offset = 0;

    ir_emit_ret(bb, v_addr);
}

/* Exercise CONV_TRUNC + CONV_ZX:
 *   int x = 0x1234;
 *   char c = (char)x;       // CONV_TRUNC 2→1
 *   int  y = (unsigned char)c;  // CONV_ZX 1→2
 *   return y;
 */
static void build_conv_test(Func *f)
{
    int v_x = ir_vreg_new(f, 2, NULL, 0);
    int v_c = ir_vreg_new(f, 1, NULL, 0);
    f->vregs[v_c].width = 1;
    int v_y = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    ir_emit_ld_imm(bb, v_x, 0x1234);
    Op *tr = ir_op_emit(bb, IR_CONV_TRUNC);
    tr->dst = v_c; tr->src[0] = v_x;
    Op *zx = ir_op_emit(bb, IR_CONV_ZX);
    zx->dst = v_y; zx->src[0] = v_c;
    ir_emit_ret(bb, v_y);
}

/* CONV_SX 1→2: signed-extend a byte back to int. */
static void build_sx_test(Func *f)
{
    int v_x = ir_vreg_new(f, 2, NULL, 0);
    int v_c = ir_vreg_new(f, 1, NULL, 0);
    f->vregs[v_c].width = 1;
    int v_y = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    ir_emit_ld_imm(bb, v_x, 0x00FF);    /* -1 when re-extended */
    Op *tr = ir_op_emit(bb, IR_CONV_TRUNC);
    tr->dst = v_c; tr->src[0] = v_x;
    Op *sx = ir_op_emit(bb, IR_CONV_SX);
    sx->dst = v_y; sx->src[0] = v_c;
    ir_emit_ret(bb, v_y);
}

/* Variable shift: int y = 0x42 << 3; return y; */
static void build_shift_test(Func *f)
{
    int v_x = ir_vreg_new(f, 2, NULL, 0);
    int v_n = ir_vreg_new(f, 2, NULL, 0);
    int v_l = ir_vreg_new(f, 2, NULL, 0);
    int v_r = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    ir_emit_ld_imm(bb, v_x, 0x42);
    ir_emit_ld_imm(bb, v_n, 3);
    ir_emit_binop(bb, IR_SHL, v_l, v_x, v_n);
    ir_emit_binop(bb, IR_SHR, v_r, v_l, v_n);
    ir_emit_ret(bb, v_r);
}

static struct fake_sym sym_callee = { "callee" };

/*  int test_call(int a, int b) {
 *      return callee(a, b) + 1;
 *  }
 *  Exercises: param-init (a,b → vreg slots), IR_CALL with 2 args, return-store.
 */
static void build_call_test(Func *f)
{
    int v_a   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int v_b   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int v_ret = ir_vreg_new(f, 2, NULL, 0);    /* callee's return */
    int v_one = ir_vreg_new(f, 2, NULL, 0);
    int v_sum = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    int *args = calloc(2, sizeof(int));
    args[0] = v_a;
    args[1] = v_b;
    Op *call = ir_op_emit(bb, IR_CALL);
    CallInfo *ci = calloc(1, sizeof(CallInfo));
    ci->target     = (SYMBOL *)&sym_callee;
    ci->fnptr_vreg = -1;
    ci->args       = args;
    ci->n_args     = 2;
    ci->ret_vreg   = v_ret;
    ci->abi        = 0;  /* SMALLC */
    call->call     = ci;

    ir_emit_ld_imm(bb, v_one, 1);
    ir_emit_binop(bb, IR_ADD, v_sum, v_ret, v_one);
    ir_emit_ret(bb, v_sum);
}

/*  int test_hcall(int v) {
 *      return l_abs(v);    // hypothetical helper
 *  }
 */
static void build_hcall_test(Func *f)
{
    int v_in  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int v_out = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);

    int entry = ir_bb_new(f);
    BB *bb = &f->bbs[entry];

    int *args = calloc(1, sizeof(int));
    args[0] = v_in;
    Op *h = ir_op_emit(bb, IR_HCALL);
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name     = "l_abs";
    hi->args     = args;
    hi->n_args   = 1;
    hi->ret_vreg = v_out;
    h->hcall     = hi;

    ir_emit_ret(bb, v_out);
}

/* Compiler globals the lowerer consults; ir_selftest links standalone
   so we stub the ones it needs to default-off values. */
int c_framepointer_is_ix = -1;
int litlab = 0;

int main(void)
{
    printf("=== smoke: add two ints (param form) ===\n");
    Func *f1 = ir_func_new(NULL);
    build_add_two(f1);
    if (ir_validate(f1) != 0) {
        fprintf(stderr, "FAIL: add_two failed validation\n");
        return 1;
    }
    ir_dump_func(stdout, f1);
    ir_func_free(f1);

    printf("\n=== smoke: loop sum (param + branches) ===\n");
    Func *f2 = ir_func_new(NULL);
    build_loop(f2);
    if (ir_validate(f2) != 0) {
        fprintf(stderr, "FAIL: loop failed validation\n");
        return 1;
    }
    ir_dump_func(stdout, f2);
    ir_func_free(f2);

    printf("\n=== op metadata spot-check ===\n");
    printf("IR_ADD: name=%s aliased=%d term=%d\n",
           ir_op_name(IR_ADD), ir_op_is_aliased(IR_ADD), ir_op_is_terminator(IR_ADD));
    printf("IR_BR: name=%s aliased=%d term=%d\n",
           ir_op_name(IR_BR), ir_op_is_aliased(IR_BR), ir_op_is_terminator(IR_BR));
    printf("IR_LD_MEM: name=%s aliased=%d term=%d\n",
           ir_op_name(IR_LD_MEM), ir_op_is_aliased(IR_LD_MEM), ir_op_is_terminator(IR_LD_MEM));

    printf("\n=== lowerer: const_add (return 7+3) ===\n");
    Func *f3 = ir_func_new(NULL);
    build_const_add(f3);
    if (ir_validate(f3) != 0) {
        fprintf(stderr, "FAIL: const_add validation\n");
        return 1;
    }
    fputs("--- IR ---\n", stdout);
    ir_dump_func(stdout, f3);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f3) != 0) {
        fprintf(stderr, "FAIL: const_add lower\n");
        return 1;
    }
    ir_func_free(f3);

    printf("\n=== lowerer: ops_mix (SUB/NEG/NOT/AND/OR/XOR/CMP_LT/CMP_ULT/CMP_EQ) ===\n");
    Func *f5 = ir_func_new(NULL);
    build_ops_mix(f5);
    if (ir_validate(f5) != 0) {
        fprintf(stderr, "FAIL: ops_mix validation\n");
        return 1;
    }
    fputs("--- IR ---\n", stdout);
    ir_dump_func(stdout, f5);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f5) != 0) {
        fprintf(stderr, "FAIL: ops_mix lower\n");
        return 1;
    }
    ir_func_free(f5);

    printf("\n=== lowerer: sym ops (LD_SYM/LD_MEM/ST_MEM via global sym) ===\n");
    Func *f_sym = ir_func_new(NULL);
    build_sym_test(f_sym);
    if (ir_validate(f_sym) != 0) {
        fprintf(stderr, "FAIL: sym_test validation\n");
        return 1;
    }
    fputs("--- IR ---\n", stdout);
    ir_dump_func(stdout, f_sym);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_sym) != 0) {
        fprintf(stderr, "FAIL: sym_test lower\n");
        return 1;
    }
    ir_func_free(f_sym);

    printf("\n=== lowerer: addr-of (LD_SYM only) ===\n");
    Func *f_addr = ir_func_new(NULL);
    build_addr_test(f_addr);
    if (ir_validate(f_addr) != 0) {
        fprintf(stderr, "FAIL: addr_test validation\n");
        return 1;
    }
    fputs("--- IR ---\n", stdout);
    ir_dump_func(stdout, f_addr);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_addr) != 0) {
        fprintf(stderr, "FAIL: addr_test lower\n");
        return 1;
    }
    ir_func_free(f_addr);

    printf("\n=== lowerer: conv_test (CONV_TRUNC + CONV_ZX) ===\n");
    Func *f_conv = ir_func_new(NULL);
    build_conv_test(f_conv);
    if (ir_validate(f_conv) != 0) { fputs("FAIL conv\n", stderr); return 1; }
    fputs("--- IR ---\n", stdout); ir_dump_func(stdout, f_conv);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_conv) != 0) { fputs("FAIL conv lower\n", stderr); return 1; }
    ir_func_free(f_conv);

    printf("\n=== lowerer: sx_test (CONV_SX) ===\n");
    Func *f_sx = ir_func_new(NULL);
    build_sx_test(f_sx);
    if (ir_validate(f_sx) != 0) { fputs("FAIL sx\n", stderr); return 1; }
    fputs("--- IR ---\n", stdout); ir_dump_func(stdout, f_sx);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_sx) != 0) { fputs("FAIL sx lower\n", stderr); return 1; }
    ir_func_free(f_sx);

    printf("\n=== lowerer: shift_test (IR_SHL + IR_SHR with var count) ===\n");
    Func *f_sh = ir_func_new(NULL);
    build_shift_test(f_sh);
    if (ir_validate(f_sh) != 0) { fputs("FAIL shift\n", stderr); return 1; }
    fputs("--- IR ---\n", stdout); ir_dump_func(stdout, f_sh);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_sh) != 0) { fputs("FAIL shift lower\n", stderr); return 1; }
    ir_func_free(f_sh);

    printf("\n=== lowerer: call_test (params + IR_CALL + ret) ===\n");
    Func *f_call = ir_func_new(NULL);
    build_call_test(f_call);
    if (ir_validate(f_call) != 0) { fputs("FAIL call\n", stderr); return 1; }
    fputs("--- IR ---\n", stdout); ir_dump_func(stdout, f_call);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_call) != 0) { fputs("FAIL call lower\n", stderr); return 1; }
    ir_func_free(f_call);

    printf("\n=== lowerer: hcall_test (IR_HCALL) ===\n");
    Func *f_hc = ir_func_new(NULL);
    build_hcall_test(f_hc);
    if (ir_validate(f_hc) != 0) { fputs("FAIL hcall\n", stderr); return 1; }
    fputs("--- IR ---\n", stdout); ir_dump_func(stdout, f_hc);
    fputs("--- asm ---\n", stdout);
    if (ir_lower_func(stdout, f_hc) != 0) { fputs("FAIL hcall lower\n", stderr); return 1; }
    ir_func_free(f_hc);

    printf("\n=== lowerer: loop_sum (no params: needs IR rewrite) ===\n");
    /* The loop_sum function takes a param. The Phase 1 lowerer doesn't
       handle params yet, so we'd need a "init v_n from somewhere" prologue.
       For now, just verify the lowerer can SEE the IR without crashing — it
       will emit code referencing the un-initialised param slot. That's
       fine for shape validation; param-init lands in Phase 1.3. */
    Func *f4 = ir_func_new(NULL);
    build_loop(f4);
    fputs("--- asm (with un-initialised param slot — for shape only) ---\n",
          stdout);
    if (ir_lower_func(stdout, f4) != 0) {
        fprintf(stderr, "FAIL: loop lower\n");
        return 1;
    }
    ir_func_free(f4);

    printf("\n=== liveness: loop_sum BB live_in/live_out ===\n");
    /* Re-build the loop func and print per-BB liveness. The loop has
       4 BBs (entry / header / body / exit) — the induction var `i`
       and accumulator `s` should be live across the back-edge. */
    Func *fL = ir_func_new(NULL);
    build_loop(fL);
    if (ir_validate(fL) != 0) { fputs("FAIL loop validation\n", stderr); return 1; }
    ir_compute_liveness(fL);
    for (int i = 0; i < fL->n_bbs; i++) {
        BB *bb = &fL->bbs[i];
        printf("  BB%d live_in: ", bb->id);
        BitSet *lin = (BitSet *)bb->live_in;
        for (int v = 0; v < fL->n_vregs; v++) {
            if (ir_bitset_get(lin, v)) printf("v%d ", v);
        }
        printf("\n  BB%d live_out: ", bb->id);
        BitSet *lout = (BitSet *)bb->live_out;
        for (int v = 0; v < fL->n_vregs; v++) {
            if (ir_bitset_get(lout, v)) printf("v%d ", v);
        }
        printf("\n");
    }

    /* Per-op liveness sanity. Walk each BB; verify the live-in of the
       last op is what bb_use_def-style stepping would produce from
       bb->live_out, and that live_in_per_op[0] equals bb->live_in. */
    printf("\n=== per-op liveness ===\n");
    ir_compute_op_liveness(fL);
    int per_op_ok = 1;
    for (int i = 0; i < fL->n_bbs; i++) {
        BB *bb = &fL->bbs[i];
        if (bb->n_ops <= 0) continue;
        const BitSet *li0 = ir_op_live_in(bb, 0);
        BitSet *bbli = (BitSet *)bb->live_in;
        /* live_in_per_op[0] must equal bb->live_in (the same fixed-
           point answer, just observed at op 0). */
        for (int v = 0; v < fL->n_vregs; v++) {
            int a = ir_bitset_get(li0, v);
            int b = ir_bitset_get(bbli, v);
            if (a != b) {
                printf("  FAIL BB%d v%d: per-op[0]=%d bb->live_in=%d\n",
                       bb->id, v, a, b);
                per_op_ok = 0;
            }
        }
        printf("  BB%d ops=%d ", bb->id, bb->n_ops);
        for (int j = 0; j < bb->n_ops; j++) {
            const BitSet *lin = ir_op_live_in(bb, j);
            printf("op%d{", j);
            for (int v = 0; v < fL->n_vregs; v++)
                if (ir_bitset_get(lin, v)) printf("v%d ", v);
            printf("} ");
        }
        printf("\n");
    }
    if (!per_op_ok) { fputs("FAIL per-op liveness\n", stderr); return 1; }

    /* Live ranges: per-vreg [start, end] in global op-index. Sanity on
       the same function used for per-op liveness above. */
    printf("\n=== live ranges ===\n");
    ir_compute_live_ranges(fL);
    int total_ops = ir_func_total_ops(fL);
    printf("  total ops: %d\n", total_ops);
    int lr_ok = 1;
    for (int v = 0; v < fL->n_vregs; v++) {
        const LiveRange *r = ir_live_range(fL, v);
        if (!r) { printf("  FAIL v%d: range NULL\n", v); lr_ok = 0; continue; }
        if (r->start < 0 && r->end < 0) {
            printf("  v%d: unused\n", v);
            continue;
        }
        if (r->start < 0 || r->end < 0 || r->start > r->end) {
            printf("  FAIL v%d: bad [%d,%d]\n", v, r->start, r->end);
            lr_ok = 0;
            continue;
        }
        if (r->end >= total_ops) {
            printf("  FAIL v%d: end %d >= total %d\n", v, r->end, total_ops);
            lr_ok = 0;
            continue;
        }
        printf("  v%d: [%d,%d]\n", v, r->start, r->end);
    }
    if (!lr_ok) { fputs("FAIL live ranges\n", stderr); return 1; }

    /* Overlap predicate: two unused vregs never overlap; a vreg always
       overlaps with itself when in use. Pick a couple of pairs to
       spot-check via a transitive sanity. */
    for (int v = 0; v < fL->n_vregs; v++) {
        const LiveRange *r = ir_live_range(fL, v);
        if (!r || r->start < 0) continue;
        if (!ir_live_ranges_overlap(fL, v, v)) {
            printf("  FAIL v%d: not self-overlapping\n", v);
            lr_ok = 0;
        }
    }
    if (!lr_ok) { fputs("FAIL live ranges overlap\n", stderr); return 1; }

    ir_free_liveness(fL);
    ir_func_free(fL);

    printf("\nALL CHECKS PASSED\n");
    return 0;
}
