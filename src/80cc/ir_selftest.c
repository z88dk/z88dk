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
#include "ir_match.h"

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

/* Exercise the arithmetic / bitwise / compare ops:
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
int c_intermix_ccode = 0;
int c_cline_directive = 0;
int lineno = 0;
void gen_emit_line(int line) { (void)line; }
void gen_comment(const char *message) { (void)message; }
const char *get_source_line(const char *filename, int n)
{
    (void)filename; (void)n; return NULL;
}

/* ===== ir_match engine tests =============================================
   Test-local pattern tables exercise each engine feature in isolation:
   binding consistency + generic apply, the single-use temp side
   condition, imm capture / predicates, either-order + commutative +
   check(), gap tolerance + barriers + bound-def breaks, the disable
   list, feature gating, and multi-round fixpoint. The production
   table is empty at stage 0; these patterns are synthetic. */

enum { MV_V = 1, MV_T, MV_D, MV_K };   /* binding var ids (1-based) */

/* dblneg: NEG t <- v; NEG d <- t  →  MOV d <- v */
static const PatternDef pat_dblneg = {
    .name = "dblneg", .n_ops = 2,
    .ops = {
        { .kind = IR_NEG, .dst = MV_T, .src0 = MV_V },
        { .kind = IR_NEG, .dst = MV_D, .src0 = MV_T },
    },
    .new_kind = IR_MOV, .new_src0 = MV_V,
};

/* Same, gap-tolerant. */
static const PatternDef pat_dblneg_gap = {
    .name = "dblneg_gap", .n_ops = 2, .flags = IR_PAT_GAP_OK,
    .ops = {
        { .kind = IR_NEG, .dst = MV_T, .src0 = MV_V },
        { .kind = IR_NEG, .dst = MV_D, .src0 = MV_T },
    },
    .new_kind = IR_MOV, .new_src0 = MV_V,
};

/* Same, gated on a feature bit. */
static const PatternDef pat_dblneg_feat = {
    .name = "dblneg_feat", .n_ops = 2, .features = IR_FEAT_CB_BITOPS,
    .ops = {
        { .kind = IR_NEG, .dst = MV_T, .src0 = MV_V },
        { .kind = IR_NEG, .dst = MV_D, .src0 = MV_T },
    },
    .new_kind = IR_MOV, .new_src0 = MV_V,
};

/* addfold: LD_IMM k; ADD d <- v, k  →  ADD d <- v (imm=k).
   Exercises src1 var binding, imm capture, and imm_from. */
static const PatternDef pat_addfold = {
    .name = "addfold", .n_ops = 2,
    .ops = {
        { .kind = IR_LD_IMM, .dst = MV_K, .imm_pred = IR_IMM_ANY },
        { .kind = IR_ADD, .dst = MV_D, .src0 = MV_V, .src1 = MV_K },
    },
    .new_kind = IR_ADD, .new_src0 = MV_V, .imm_from = 1,
};

/* addfold7: as addfold but the constant must be exactly 7. */
static const PatternDef pat_addfold7 = {
    .name = "addfold7", .n_ops = 2,
    .ops = {
        { .kind = IR_LD_IMM, .dst = MV_K,
          .imm_pred = IR_IMM_EQ, .imm_val = 7 },
        { .kind = IR_ADD, .dst = MV_D, .src0 = MV_V, .src1 = MV_K },
    },
    .new_kind = IR_ADD, .new_src0 = MV_V, .imm_from = 1,
};

/* trotl: the ROTATE_LEFT triple, rehearsing stage 2. Shifts in either
   order, OR operands either way, counts must sum to 32 (check). */
static int trotl_check(Func *f, BB *bb, const int idx[],
                       const int64_t imm[], const int bind[],
                       const int uc[])
{
    (void)f; (void)bb; (void)idx; (void)bind; (void)uc;
    int nl = (int)imm[0], nr = (int)imm[1];
    return nl >= 1 && nl <= 31 && nl + nr == 32;
}
static const PatternDef pat_trotl = {
    .name = "trotl", .n_ops = 3,
    .flags = IR_PAT_EITHER_ORDER | IR_PAT_COMMUTATIVE,
    .ops = {
        { .kind = IR_SHL, .dst = MV_T, .src0 = MV_V,
          .imm_pred = IR_IMM_ANY, .width = 4 },
        { .kind = IR_SHR, .dst = MV_D, .src0 = MV_V,
          .imm_pred = IR_IMM_ANY, .width = 4 },
        { .kind = IR_OR, .dst = MV_K, .src0 = MV_T, .src1 = MV_D,
          .width = 4 },
    },
    .check = trotl_check,
    .new_kind = IR_ROTL, .new_src0 = MV_V, .imm_from = 1,
};

/* movmov: MOV b <- a; MOV c <- b → MOV c <- a (rounds/fixpoint test). */
static const PatternDef pat_movmov = {
    .name = "movmov", .n_ops = 2,
    .ops = {
        { .kind = IR_MOV, .dst = MV_T, .src0 = MV_V },
        { .kind = IR_MOV, .dst = MV_D, .src0 = MV_T },
    },
    .new_kind = IR_MOV, .new_src0 = MV_V,
};

/* Build NEG t <- v; NEG d <- t with optional ops spliced between, run
   `pat`, and return the rewrite count. `between` values: 0 = nothing,
   1 = unrelated LD_IMM, 2 = IR_ASM barrier, 3 = redefinition of v. */
static int match_dblneg_shape(const PatternDef *pat, int between,
                              int extra_use_of_t)
{
    Func *f = ir_func_new(NULL);
    int v = ir_vreg_new(f, 2, NULL, 0);
    int t = ir_vreg_new(f, 2, NULL, 0);
    int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
    int u = ir_vreg_new(f, 2, NULL, 0);
    int e = ir_bb_new(f);
    BB *bb = &f->bbs[e];
    ir_emit_ld_imm(bb, v, 5);
    ir_emit_unop(bb, IR_NEG, t, v);
    if (between == 1) ir_emit_ld_imm(bb, u, 9);
    if (between == 2) {
        Op *a = ir_op_emit(bb, IR_ASM);
        a->asm_text = "nop";
    }
    if (between == 3) ir_emit_ld_imm(bb, v, 1);
    bb = &f->bbs[e];
    ir_emit_unop(bb, IR_NEG, d, t);
    if (extra_use_of_t) ir_emit_binop(bb, IR_ADD, u, t, v);
    ir_emit_ret(bb, d);
    int n = ir_match_run_table(f, pat, 1);
    int valid = ir_validate(f) == 0;
    ir_func_free(f);
    return valid ? n : -1;
}

/* Build the rotl triple. order: 0 = SHL first, 1 = SHR first.
   swap_or: OR srcs as (t2,t1). width: vreg width for v/t1/t2/r. */
static int match_trotl_shape(int order, int swap_or, int width,
                             int nl, int nr, Func **out)
{
    Func *f = ir_func_new(NULL);
    int v  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
    int t1 = ir_vreg_new(f, 2, NULL, 0);
    int t2 = ir_vreg_new(f, 2, NULL, 0);
    int r  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
    f->vregs[v].width  = (int16_t)width;
    f->vregs[t1].width = (int16_t)width;
    f->vregs[t2].width = (int16_t)width;
    f->vregs[r].width  = (int16_t)width;
    int e = ir_bb_new(f);
    BB *bb = &f->bbs[e];
    Op *o;
    if (order == 0) {
        o = ir_emit_binop(bb, IR_SHL, t1, v, -1); o->imm = nl;
        o = ir_emit_binop(bb, IR_SHR, t2, v, -1); o->imm = nr;
    } else {
        o = ir_emit_binop(bb, IR_SHR, t2, v, -1); o->imm = nr;
        o = ir_emit_binop(bb, IR_SHL, t1, v, -1); o->imm = nl;
    }
    if (swap_or)
        ir_emit_binop(bb, IR_OR, r, t2, t1);
    else
        ir_emit_binop(bb, IR_OR, r, t1, t2);
    ir_emit_ret(bb, r);
    int n = ir_match_run_table(f, &pat_trotl, 1);
    if (out) *out = f; else ir_func_free(f);
    return n;
}

static int run_match_tests(void)
{
    int fails = 0;
#define MCHECK(cond, name) do { \
        if (!(cond)) { fprintf(stderr, "FAIL ir_match: %s\n", name); fails++; } \
    } while (0)

    /* 1 — adjacent fuse, binding consistency, generic apply. */
    {
        Func *f = ir_func_new(NULL);
        int v = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, v, 5);
        ir_emit_unop(bb, IR_NEG, t, v);
        ir_emit_unop(bb, IR_NEG, d, t);
        ir_emit_ret(bb, d);
        int n = ir_match_run_table(f, &pat_dblneg, 1);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 3
               && bb->ops[1].kind == IR_MOV
               && bb->ops[1].dst == d && bb->ops[1].src[0] == v
               && bb->ops[1].src[1] == -1
               && ir_validate(f) == 0, "dblneg fuse");
        ir_func_free(f);
    }

    /* 2 — multi-use temp blocks the match. */
    MCHECK(match_dblneg_shape(&pat_dblneg, 0, 1) == 0,
           "multi-use temp rejected");

    /* 3 — gap tolerance: unrelated op between satellites. */
    MCHECK(match_dblneg_shape(&pat_dblneg, 1, 0) == 0,
           "adjacent pattern rejects gapped shape");
    MCHECK(match_dblneg_shape(&pat_dblneg_gap, 1, 0) == 1,
           "gap pattern accepts gapped shape");
    MCHECK(match_dblneg_shape(&pat_dblneg_gap, 2, 0) == 0,
           "gap pattern stops at barrier");
    MCHECK(match_dblneg_shape(&pat_dblneg_gap, 3, 0) == 0,
           "gap pattern stops at bound-vreg redefinition");

    /* 4 — imm capture + imm_from (addfold) and IR_IMM_EQ (addfold7). */
    {
        for (int variant = 0; variant < 3; variant++) {
            /* 0: addfold, k=7. 1: addfold7, k=7. 2: addfold7, k=8. */
            const PatternDef *p = variant ? &pat_addfold7 : &pat_addfold;
            int64_t k = (variant == 2) ? 8 : 7;
            Func *f = ir_func_new(NULL);
            int v  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int vk = ir_vreg_new(f, 2, NULL, 0);
            int d  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            ir_emit_ld_imm(bb, vk, k);
            ir_emit_binop(bb, IR_ADD, d, v, vk);
            ir_emit_ret(bb, d);
            int n = ir_match_run_table(f, p, 1);
            bb = &f->bbs[e];
            if (variant == 2) {
                MCHECK(n == 0, "addfold7 rejects imm 8");
            } else {
                MCHECK(n == 1 && bb->n_ops == 2
                       && bb->ops[0].kind == IR_ADD
                       && bb->ops[0].dst == d && bb->ops[0].src[0] == v
                       && bb->ops[0].src[1] == -1 && bb->ops[0].imm == 7
                       && ir_validate(f) == 0,
                       variant ? "addfold7 fires on imm 7"
                               : "addfold imm capture");
            }
            ir_func_free(f);
        }
    }

    /* 5 — either-order + commutative + check() + width gate. */
    {
        Func *f = NULL;
        int n = match_trotl_shape(0, 0, 4, 5, 27, &f);
        BB *bb = &f->bbs[0];
        MCHECK(n == 1 && bb->n_ops == 2
               && bb->ops[0].kind == IR_ROTL && bb->ops[0].imm == 5
               && bb->ops[0].src[1] == -1
               && ir_validate(f) == 0, "trotl shl-first");
        ir_func_free(f);
        MCHECK(match_trotl_shape(1, 0, 4, 5, 27, NULL) == 1,
               "trotl shr-first (either-order)");
        MCHECK(match_trotl_shape(0, 1, 4, 5, 27, NULL) == 1,
               "trotl swapped OR srcs (commutative)");
        MCHECK(match_trotl_shape(0, 0, 4, 5, 25, NULL) == 0,
               "trotl rejects counts not summing to 32");
        MCHECK(match_trotl_shape(0, 0, 2, 5, 27, NULL) == 0,
               "trotl rejects width 2");
    }

    /* 6 — disable list (--opt-disable=pattern:<name> path). */
    ir_match_disable("dblneg");
    MCHECK(match_dblneg_shape(&pat_dblneg, 0, 0) == 0,
           "disabled pattern skipped");
    ir_match_clear_disabled();
    MCHECK(match_dblneg_shape(&pat_dblneg, 0, 0) == 1,
           "cleared disable fires again");

    /* 7 — feature gating. */
    MCHECK(match_dblneg_shape(&pat_dblneg_feat, 0, 0) == 0,
           "missing feature bit gates pattern off");
    {
        Func *f = ir_func_new(NULL);
        f->features = IR_FEAT_CB_BITOPS;
        int v = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, v, 5);
        ir_emit_unop(bb, IR_NEG, t, v);
        ir_emit_unop(bb, IR_NEG, d, t);
        ir_emit_ret(bb, d);
        MCHECK(ir_match_run_table(f, &pat_dblneg_feat, 1) == 1,
               "present feature bit lets pattern fire");
        ir_func_free(f);
    }

    /* 9 — production immconv pattern (via ir_match_run): fold values
       per conv kind, satellite kept, gap over a barrier (GAP_VALUES),
       multi-consumer + chained folds across rounds, redefinition
       picks the latest imm. */
    {
        /* TRUNC across an ASM barrier, two consumers of one LD_IMM. */
        Func *f = ir_func_new(NULL);
        int v  = ir_vreg_new(f, 2, NULL, 0);
        int c1 = ir_vreg_new(f, 1, NULL, 0);
        int c2 = ir_vreg_new(f, 1, NULL, 0);
        f->vregs[c1].width = 1;
        f->vregs[c2].width = 1;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, v, 0x1234);
        Op *a = ir_op_emit(bb, IR_ASM);
        a->asm_text = "nop";
        Op *t1 = ir_op_emit(bb, IR_CONV_TRUNC);
        t1->dst = c1; t1->src[0] = v;
        Op *t2 = ir_op_emit(bb, IR_CONV_TRUNC);
        t2->dst = c2; t2->src[0] = v;
        ir_emit_ret(bb, -1);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->n_ops == 5
               && bb->ops[0].kind == IR_LD_IMM   /* satellite kept */
               && bb->ops[2].kind == IR_LD_IMM && bb->ops[2].imm == 0x34
               && bb->ops[3].kind == IR_LD_IMM && bb->ops[3].imm == 0x34
               && ir_validate(f) == 0,
               "immconv trunc x2 across barrier, satellite kept");
        ir_func_free(f);
    }
    {
        /* Fold-value matrix: SX / ZX / BYTE_TO_HIGH. */
        struct { OpKind k; int sw, dw; int64_t in, out; } cases[] = {
            { IR_CONV_SX,           1, 2, 0xFF, 0xFFFF },
            { IR_CONV_SX,           1, 2, 0x7F, 0x7F   },
            { IR_CONV_ZX,           1, 2, 0x80, 0x80   },
            { IR_CONV_BYTE_TO_HIGH, 1, 2, 0xAB, 0xAB00 },
            { IR_CONV_TRUNC,        4, 2, 0x12345678, 0x5678 },
        };
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; i++) {
            Func *f = ir_func_new(NULL);
            int v = ir_vreg_new(f, 2, NULL, 0);
            int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            f->vregs[v].width = (int16_t)cases[i].sw;
            f->vregs[d].width = (int16_t)cases[i].dw;
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            ir_emit_ld_imm(bb, v, cases[i].in);
            Op *cv = ir_op_emit(bb, cases[i].k);
            cv->dst = d; cv->src[0] = v;
            ir_emit_ret(bb, d);
            int n = ir_match_run(f);
            bb = &f->bbs[e];
            MCHECK(n == 1 && bb->ops[1].kind == IR_LD_IMM
                   && bb->ops[1].imm == cases[i].out
                   && ir_validate(f) == 0, "immconv fold-value case");
            ir_func_free(f);
        }
    }
    {
        /* Chain: TRUNC of a folded TRUNC converges across rounds. */
        Func *f = ir_func_new(NULL);
        int va = ir_vreg_new(f, 2, NULL, 0);
        int vb = ir_vreg_new(f, 2, NULL, 0);
        int vc = ir_vreg_new(f, 1, NULL, IR_VREG_RETURN);
        f->vregs[va].width = 4;
        f->vregs[vc].width = 1;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, va, 0x12345678);
        Op *cb = ir_op_emit(bb, IR_CONV_TRUNC);
        cb->dst = vb; cb->src[0] = va;
        Op *cc = ir_op_emit(bb, IR_CONV_TRUNC);
        cc->dst = vc; cc->src[0] = vb;
        ir_emit_ret(bb, vc);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->ops[2].kind == IR_LD_IMM
               && bb->ops[2].imm == 0x78
               && ir_validate(f) == 0, "immconv chained fold");
        ir_func_free(f);
    }
    {
        /* Redefinition between LD_IMM and CONV: latest imm wins. */
        Func *f = ir_func_new(NULL);
        int v = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 1, NULL, IR_VREG_RETURN);
        f->vregs[d].width = 1;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, v, 1);
        ir_emit_ld_imm(bb, v, 2);
        Op *cv = ir_op_emit(bb, IR_CONV_TRUNC);
        cv->dst = d; cv->src[0] = v;
        ir_emit_ret(bb, d);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->ops[2].kind == IR_LD_IMM
               && bb->ops[2].imm == 2
               && ir_validate(f) == 0, "immconv folds from latest def");
        ir_func_free(f);
    }

    /* 10 — production rotl pattern (via ir_match_run): triple fuses
       to IR_ROTL and the satellite shifts are compacted out (the
       NO_COMPACT parity crutch was dropped — padding NOPs fed phantom
       distance to the long-push inserter). */
    {
        Func *f = ir_func_new(NULL);
        int v  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int t1 = ir_vreg_new(f, 2, NULL, 0);
        int t2 = ir_vreg_new(f, 2, NULL, 0);
        int r  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        f->vregs[v].width = 4;  f->vregs[t1].width = 4;
        f->vregs[t2].width = 4; f->vregs[r].width  = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *o;
        o = ir_emit_binop(bb, IR_SHL, t1, v, -1); o->imm = 5;
        o = ir_emit_binop(bb, IR_SHR, t2, v, -1); o->imm = 27;
        ir_emit_binop(bb, IR_OR, r, t2, t1);   /* swapped operands */
        ir_emit_ret(bb, r);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 2     /* shifts compacted out */
               && bb->ops[0].kind == IR_ROTL
               && bb->ops[0].dst == r && bb->ops[0].src[0] == v
               && bb->ops[0].imm == 5
               && bb->ops[1].kind == IR_RET
               && ir_validate(f) == 0,
               "production rotl fuses, satellites compacted");
        ir_func_free(f);
    }
    {
        /* The md5 shape: `a = ROTATE_LEFT(a, s)` — the OR writes back
           into the source vreg. The anchor's dst must stay
           unconstrained or it collides with the source binding. */
        Func *f = ir_func_new(NULL);
        int v  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int t1 = ir_vreg_new(f, 2, NULL, 0);
        int t2 = ir_vreg_new(f, 2, NULL, 0);
        f->vregs[v].width = 4;  f->vregs[t1].width = 4;
        f->vregs[t2].width = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *o;
        o = ir_emit_binop(bb, IR_SHL, t1, v, -1); o->imm = 7;
        o = ir_emit_binop(bb, IR_SHR, t2, v, -1); o->imm = 25;
        ir_emit_binop(bb, IR_OR, v, t1, t2);     /* dst == v */
        ir_emit_ret(bb, v);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->ops[2].kind == IR_ROTL
               && bb->ops[2].dst == v && bb->ops[2].src[0] == v
               && bb->ops[2].imm == 7
               && ir_validate(f) == 0,
               "production rotl with aliased dst (a = ROTL(a))");
        ir_func_free(f);
    }

    /* 12 — production late phase (ir_match_run_late): the
       extract-byte family. */
    {
        /* Full chain: SHR 16 / AND 0xFF / TRUNC w1 → EXTRACT_BYTE
           imm 2; satellites compacted. v multi-use is fine. */
        Func *f = ir_func_new(NULL);
        int v = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int w = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 1, NULL, IR_VREG_RETURN);
        f->vregs[v].width = 4; f->vregs[w].width = 4;
        f->vregs[t].width = 4; f->vregs[d].width = 1;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *o;
        o = ir_emit_binop(bb, IR_SHR, w, v, -1); o->imm = 16;
        o = ir_emit_binop(bb, IR_AND, t, w, -1); o->imm = 0xFF;
        Op *tr = ir_op_emit(bb, IR_CONV_TRUNC);
        tr->dst = d; tr->src[0] = t;
        ir_emit_ret(bb, d);
        int n = ir_match_run_late(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 2
               && bb->ops[0].kind == IR_EXTRACT_BYTE
               && bb->ops[0].dst == d && bb->ops[0].src[0] == v
               && bb->ops[0].imm == 2
               && ir_validate(f) == 0, "xbyte full chain");
        ir_func_free(f);
    }
    {
        /* Fallback: SHR's dst multi-use → AND-only byte-0 fold of w,
           SHR kept (the old pass's exact degradation). */
        Func *f = ir_func_new(NULL);
        int v = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int w = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 1, NULL, 0);
        int u = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        f->vregs[v].width = 4; f->vregs[w].width = 4;
        f->vregs[t].width = 4; f->vregs[d].width = 1;
        f->vregs[u].width = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *o;
        o = ir_emit_binop(bb, IR_SHR, w, v, -1); o->imm = 8;
        o = ir_emit_binop(bb, IR_AND, t, w, -1); o->imm = 0xFF;
        Op *tr = ir_op_emit(bb, IR_CONV_TRUNC);
        tr->dst = d; tr->src[0] = t;
        ir_emit_binop(bb, IR_XOR, u, w, v);   /* second use of w */
        ir_emit_ret(bb, u);
        int n = ir_match_run_late(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->ops[0].kind == IR_SHR  /* SHR kept */
               && bb->ops[1].kind == IR_EXTRACT_BYTE
               && bb->ops[1].src[0] == w && bb->ops[1].imm == 0
               && ir_validate(f) == 0,
               "xbyte_b0 fallback on multi-use w");
        ir_func_free(f);
    }
    {
        /* SHR-only: w1 dst fuses (imm k); w2 dst rejected; bad shift
           count rejected; AND with non-0xFF mask rejected. */
        struct { int dw; int64_t shr; int and_op; int64_t mask;
                 int expect; } cases[] = {
            { 1, 24, 0, 0,     1 },   /* SHR-only to byte: fuse imm 3 */
            { 2, 24, 0, 0,     0 },   /* SHR-only to w2: reject */
            { 1, 12, 0, 0,     0 },   /* shift 12: reject */
            { 1,  8, 1, 0xF0,  0 },   /* AND 0xF0: reject */
        };
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; i++) {
            Func *f = ir_func_new(NULL);
            int v = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int t = ir_vreg_new(f, 2, NULL, 0);
            int t2 = ir_vreg_new(f, 2, NULL, 0);
            int d = ir_vreg_new(f, 1, NULL, IR_VREG_RETURN);
            f->vregs[v].width = 4; f->vregs[t].width = 4;
            f->vregs[t2].width = 4;
            f->vregs[d].width = (int16_t)cases[i].dw;
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            Op *o;
            o = ir_emit_binop(bb, IR_SHR, t, v, -1);
            o->imm = cases[i].shr;
            int trunc_src = t;
            if (cases[i].and_op) {
                o = ir_emit_binop(bb, IR_AND, t2, t, -1);
                o->imm = cases[i].mask;
                trunc_src = t2;
            }
            Op *tr = ir_op_emit(bb, IR_CONV_TRUNC);
            tr->dst = d; tr->src[0] = trunc_src;
            ir_emit_ret(bb, d);
            int n = ir_match_run_late(f);
            int ok = cases[i].expect
                   ? (n == 1 && f->bbs[e].ops[0].kind == IR_EXTRACT_BYTE
                      && f->bbs[e].ops[0].imm == cases[i].shr / 8)
                   : (n == 0);
            MCHECK(ok && ir_validate(f) == 0, "xbyte gate case");
            ir_func_free(f);
        }
    }
    {
        /* Two chains off one v (digest store shape): both fuse. */
        Func *f = ir_func_new(NULL);
        int v  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int t1 = ir_vreg_new(f, 2, NULL, 0);
        int t2 = ir_vreg_new(f, 2, NULL, 0);
        int d1 = ir_vreg_new(f, 1, NULL, 0);
        int d2 = ir_vreg_new(f, 1, NULL, 0);
        f->vregs[v].width = 4; f->vregs[t1].width = 4;
        f->vregs[t2].width = 4;
        f->vregs[d1].width = 1; f->vregs[d2].width = 1;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *o;
        o = ir_emit_binop(bb, IR_SHR, t1, v, -1); o->imm = 8;
        Op *r1 = ir_op_emit(bb, IR_CONV_TRUNC);
        r1->dst = d1; r1->src[0] = t1;
        o = ir_emit_binop(bb, IR_SHR, t2, v, -1); o->imm = 24;
        Op *r2 = ir_op_emit(bb, IR_CONV_TRUNC);
        r2->dst = d2; r2->src[0] = t2;
        Op *st = ir_op_emit(bb, IR_ST_MEM);
        st->src[0] = d1;
        st->mem.kind = IR_MEM_SYM; st->mem.sym = (SYMBOL *)&sym_g;
        Op *st2 = ir_op_emit(bb, IR_ST_MEM);
        st2->src[0] = d2;
        st2->mem.kind = IR_MEM_SYM; st2->mem.sym = (SYMBOL *)&sym_arr;
        ir_emit_ret(bb, -1);
        int n = ir_match_run_late(f);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->ops[0].kind == IR_EXTRACT_BYTE
               && bb->ops[0].imm == 1
               && bb->ops[1].kind == IR_EXTRACT_BYTE
               && bb->ops[1].imm == 3
               && ir_validate(f) == 0, "xbyte two lanes off one v");
        ir_func_free(f);
    }

    /* 13 — production offset folds (main run): symoff and the three
       vregoff shapes. */
    {
        /* symoff: LD_SYM a <- g+2; ADD b <- a (imm 4) → LD_SYM b <-
           g+6; then vregoff_sym folds the absolute access in round 2:
           LD_MEM [b, 1] → LD_MEM SYM g+7. */
        Func *f = ir_func_new(NULL);
        int a = ir_vreg_new(f, 2, NULL, 0);
        int b = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *ld = ir_op_emit(bb, IR_LD_SYM);
        ld->dst = a;
        ld->mem.kind = IR_MEM_SYM;
        ld->mem.sym = (SYMBOL *)&sym_g;
        ld->mem.offset = 2;
        Op *ar = ir_emit_binop(bb, IR_ADD, b, a, -1);
        ar->imm = 4;
        Op *mo = ir_op_emit(bb, IR_LD_MEM);
        mo->dst = d;
        mo->mem.kind = IR_MEM_VREG;
        mo->mem.base = b;
        mo->mem.offset = 1;
        ir_emit_ret(bb, d);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->n_ops == 2
               && bb->ops[0].kind == IR_LD_MEM
               && bb->ops[0].mem.kind == IR_MEM_SYM
               && bb->ops[0].mem.sym == (SYMBOL *)&sym_g
               && bb->ops[0].mem.offset == 7
               && ir_validate(f) == 0,
               "symoff + vregoff_sym chain to absolute access");
        ir_func_free(f);
    }
    {
        /* vregoff_imm: ADD t <- p (imm 3); ST_MEM [t, 1], v →
           ST_MEM [p, 4], v. SUB variant subtracts. */
        for (int sub = 0; sub < 2; sub++) {
            Func *f = ir_func_new(NULL);
            int p = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int t = ir_vreg_new(f, 2, NULL, 0);
            int v = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            Op *ad = ir_emit_binop(bb, sub ? IR_SUB : IR_ADD,
                                   t, p, -1);
            ad->imm = 3;
            Op *st = ir_op_emit(bb, IR_ST_MEM);
            st->src[0] = v;
            st->mem.kind = IR_MEM_VREG;
            st->mem.base = t;
            st->mem.offset = 1;
            ir_emit_ret(bb, -1);
            int n = ir_match_run(f);
            bb = &f->bbs[e];
            MCHECK(n == 1 && bb->ops[0].kind == IR_ST_MEM
                   && bb->ops[0].mem.base == p
                   && bb->ops[0].mem.offset == (sub ? -2 : 4)
                   && ir_validate(f) == 0,
                   sub ? "vregoff_imm SUB" : "vregoff_imm ADD");
            ir_func_free(f);
        }
    }
    {
        /* vregoff_imm gates: post_step, volatile, multi-use t. */
        for (int variant = 0; variant < 3; variant++) {
            Func *f = ir_func_new(NULL);
            int p = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int t = ir_vreg_new(f, 2, NULL, 0);
            int u = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            Op *ad = ir_emit_binop(bb, IR_ADD, t, p, -1);
            ad->imm = 3;
            Op *mo = ir_op_emit(bb, IR_LD_MEM);
            mo->dst = u;
            mo->mem.kind = IR_MEM_VREG;
            mo->mem.base = t;
            if (variant == 0) mo->mem.post_step = 2;
            if (variant == 1) mo->mem.volatile_ = 1;
            if (variant == 2) {
                Op *x = ir_emit_binop(bb, IR_ADD, u, u, t);
                (void)x;
            }
            ir_emit_ret(bb, u);
            MCHECK(ir_match_run(f) == 0,
                   variant == 0 ? "vregoff_imm rejects post_step"
                 : variant == 1 ? "vregoff_imm rejects volatile"
                                : "vregoff_imm rejects multi-use t");
            ir_func_free(f);
        }
    }
    {
        /* vregoff_idx: ADD t1 <- i (imm 3); ADD t2 <- p,t1 (both
           operand orders); LD_MEM [t2] → ADD t2 <- p,i; LD_MEM
           [t2, 3]. The middle ADD survives. */
        for (int swap = 0; swap < 2; swap++) {
            Func *f = ir_func_new(NULL);
            int p  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int i  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int t1 = ir_vreg_new(f, 2, NULL, 0);
            int t2 = ir_vreg_new(f, 2, NULL, 0);
            int d  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            Op *ad = ir_emit_binop(bb, IR_ADD, t1, i, -1);
            ad->imm = 3;
            if (swap)
                ir_emit_binop(bb, IR_ADD, t2, t1, p);
            else
                ir_emit_binop(bb, IR_ADD, t2, p, t1);
            Op *mo = ir_op_emit(bb, IR_LD_MEM);
            mo->dst = d;
            mo->mem.kind = IR_MEM_VREG;
            mo->mem.base = t2;
            ir_emit_ret(bb, d);
            int n = ir_match_run(f);
            bb = &f->bbs[e];
            int slot_ok = swap
                ? (bb->ops[0].src[0] == i && bb->ops[0].src[1] == p)
                : (bb->ops[0].src[0] == p && bb->ops[0].src[1] == i);
            MCHECK(n == 1 && bb->n_ops == 3
                   && bb->ops[0].kind == IR_ADD     /* a2 kept */
                   && bb->ops[0].dst == t2 && slot_ok
                   && bb->ops[1].kind == IR_LD_MEM
                   && bb->ops[1].mem.base == t2
                   && bb->ops[1].mem.offset == 3
                   && ir_validate(f) == 0,
                   swap ? "vregoff_idx t1-first"
                        : "vregoff_idx t1-second");
            ir_func_free(f);
        }
    }

    /* 14 — production incmhl (main run): the long (*p)++ triple
       becomes HCALL l_long_inc_mhl(p). */
    {
        Func *f = ir_func_new(NULL);
        int p   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int old = ir_vreg_new(f, 2, NULL, 0);
        int nw  = ir_vreg_new(f, 2, NULL, 0);
        f->vregs[old].width = 4;
        f->vregs[nw].width  = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *ld = ir_op_emit(bb, IR_LD_MEM);
        ld->dst = old;
        ld->mem.kind = IR_MEM_VREG; ld->mem.base = p;
        Op *ad = ir_emit_binop(bb, IR_ADD, nw, old, -1);
        ad->imm = 1;
        Op *st = ir_op_emit(bb, IR_ST_MEM);
        st->src[0] = nw;
        st->mem.kind = IR_MEM_VREG; st->mem.base = p;
        ir_emit_ret(bb, -1);
        int n = ir_match_run(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 2
               && bb->ops[0].kind == IR_HCALL
               && bb->ops[0].hcall
               && strcmp(bb->ops[0].hcall->name, "l_long_inc_mhl") == 0
               && bb->ops[0].hcall->n_args == 1
               && bb->ops[0].hcall->args[0] == p
               && bb->ops[0].hcall->ret_vreg == -1
               && ir_validate(f) == 0, "production incmhl fuses");
        ir_func_free(f);
    }
    {
        /* incmhl gates: nonzero offset, imm 2, value used afterwards,
           base mismatch — all stay inline. */
        for (int variant = 0; variant < 4; variant++) {
            Func *f = ir_func_new(NULL);
            int p   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int q   = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
            int old = ir_vreg_new(f, 2, NULL, 0);
            int nw  = ir_vreg_new(f, 2, NULL, 0);
            f->vregs[old].width = 4;
            f->vregs[nw].width  = 4;
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            Op *ld = ir_op_emit(bb, IR_LD_MEM);
            ld->dst = old;
            ld->mem.kind = IR_MEM_VREG; ld->mem.base = p;
            if (variant == 0) ld->mem.offset = 4;
            Op *ad = ir_emit_binop(bb, IR_ADD, nw, old, -1);
            ad->imm = (variant == 1) ? 2 : 1;
            Op *st = ir_op_emit(bb, IR_ST_MEM);
            st->src[0] = nw;
            st->mem.kind = IR_MEM_VREG;
            st->mem.base = (variant == 3) ? q : p;
            if (variant == 0) st->mem.offset = 4;
            if (variant == 2) {
                Op *st2 = ir_op_emit(bb, IR_ST_MEM);  /* reuse nw */
                st2->src[0] = nw;
                st2->mem.kind = IR_MEM_SYM;
                st2->mem.sym = (SYMBOL *)&sym_g;
            }
            ir_emit_ret(bb, -1);
            MCHECK(ir_match_run(f) == 0,
                   variant == 0 ? "incmhl rejects nonzero offset"
                 : variant == 1 ? "incmhl rejects imm 2"
                 : variant == 2 ? "incmhl rejects used value"
                                : "incmhl rejects base mismatch");
            ir_func_free(f);
        }
    }

    /* 15 — production packbytes (ir_match_run_packbytes): the
       4-lane little-endian byte pack collapses to a width-4 load. */
    {
        /* b[k+0..3] little-endian into r:
             LD b0<-[t,0]; ZX l0<-b0;
             LD b1<-[t,1]; ZX l1<-b1; SHL s1<-l1,8;
             LD b2<-[t,2]; ZX l2<-b2; SHL s2<-l2,16;
             LD b3<-[t,3]; ZX l3<-b3; SHL s3<-l3,24;
             OR o1<-l0,s1; OR o2<-s2,s3; OR r<-o1,o2  */
        Func *f = ir_func_new(NULL);
        int t  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int b[4], l[4], s[4];
        for (int i = 0; i < 4; i++) {
            b[i] = ir_vreg_new(f, 1, NULL, 0); f->vregs[b[i]].width = 1;
            l[i] = ir_vreg_new(f, 2, NULL, 0); f->vregs[l[i]].width = 4;
            s[i] = ir_vreg_new(f, 2, NULL, 0); f->vregs[s[i]].width = 4;
        }
        int o1 = ir_vreg_new(f, 2, NULL, 0); f->vregs[o1].width = 4;
        int o2 = ir_vreg_new(f, 2, NULL, 0); f->vregs[o2].width = 4;
        int r  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        f->vregs[r].width = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        for (int i = 0; i < 4; i++) {
            Op *ld = ir_op_emit(bb, IR_LD_MEM);
            ld->dst = b[i];
            ld->mem.kind = IR_MEM_VREG; ld->mem.base = t;
            ld->mem.offset = i;
            Op *zx = ir_op_emit(bb, IR_CONV_ZX);
            zx->dst = l[i]; zx->src[0] = b[i];
            if (i > 0) {
                Op *sh = ir_emit_binop(bb, IR_SHL, s[i], l[i], -1);
                sh->imm = 8 * i;
            }
        }
        /* lane 0 uses l[0] directly (no shift). */
        ir_emit_binop(bb, IR_OR, o1, l[0], s[1]);
        ir_emit_binop(bb, IR_OR, o2, s[2], s[3]);
        ir_emit_binop(bb, IR_OR, r, o1, o2);
        ir_emit_ret(bb, r);
        int n = ir_match_run_packbytes(f);
        bb = &f->bbs[e];
        /* The root OR (last op before RET) is now the wide load; the
           12 chain ops + 2 inner ORs are gone. */
        int wide = -1;
        for (int j = 0; j < bb->n_ops; j++)
            if (bb->ops[j].kind == IR_LD_MEM
                && bb->ops[j].dst == r) wide = j;
        MCHECK(n == 1 && wide >= 0
               && bb->ops[wide].mem.kind == IR_MEM_VREG
               && bb->ops[wide].mem.base == t
               && bb->ops[wide].mem.offset == 0
               && bb->n_ops == 2          /* wide load + RET */
               && ir_validate(f) == 0, "production packbytes collapse");
        ir_func_free(f);
    }
    {
        /* Gate: a store between a lane load and the root OR blocks the
           pack (aliasing). The chain stays intact. */
        Func *f = ir_func_new(NULL);
        int t  = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int b[4], l[4], s[4];
        for (int i = 0; i < 4; i++) {
            b[i] = ir_vreg_new(f, 1, NULL, 0); f->vregs[b[i]].width = 1;
            l[i] = ir_vreg_new(f, 2, NULL, 0); f->vregs[l[i]].width = 4;
            s[i] = ir_vreg_new(f, 2, NULL, 0); f->vregs[s[i]].width = 4;
        }
        int o1 = ir_vreg_new(f, 2, NULL, 0); f->vregs[o1].width = 4;
        int o2 = ir_vreg_new(f, 2, NULL, 0); f->vregs[o2].width = 4;
        int r  = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        f->vregs[r].width = 4;
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        for (int i = 0; i < 4; i++) {
            Op *ld = ir_op_emit(bb, IR_LD_MEM);
            ld->dst = b[i];
            ld->mem.kind = IR_MEM_VREG; ld->mem.base = t;
            ld->mem.offset = i;
            Op *zx = ir_op_emit(bb, IR_CONV_ZX);
            zx->dst = l[i]; zx->src[0] = b[i];
            if (i > 0) {
                Op *sh = ir_emit_binop(bb, IR_SHL, s[i], l[i], -1);
                sh->imm = 8 * i;
            }
            if (i == 1) {   /* aliasing store inside the window */
                Op *st = ir_op_emit(bb, IR_ST_MEM);
                st->src[0] = b[0];
                st->mem.kind = IR_MEM_SYM; st->mem.sym = (SYMBOL *)&sym_g;
            }
        }
        ir_emit_binop(bb, IR_OR, o1, l[0], s[1]);
        ir_emit_binop(bb, IR_OR, o2, s[2], s[3]);
        ir_emit_binop(bb, IR_OR, r, o1, o2);
        ir_emit_ret(bb, r);
        MCHECK(ir_match_run_packbytes(f) == 0 && ir_validate(f) == 0,
               "packbytes blocked by aliasing store");
        ir_func_free(f);
    }

    /* 8 — rounds: a 3-MOV chain needs two rounds to coalesce. */
    {
        Func *f = ir_func_new(NULL);
        int a = ir_vreg_new(f, 2, NULL, IR_VREG_PARAM);
        int b = ir_vreg_new(f, 2, NULL, 0);
        int c = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_mov(bb, b, a);
        ir_emit_mov(bb, c, b);
        ir_emit_mov(bb, d, c);
        ir_emit_ret(bb, d);
        int n = ir_match_run_table(f, &pat_movmov, 1);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->n_ops == 2
               && bb->ops[0].kind == IR_MOV
               && bb->ops[0].dst == d && bb->ops[0].src[0] == a
               && ir_validate(f) == 0, "movmov chain converges in rounds");
        ir_func_free(f);
    }

    /* 11 — production early phase (ir_match_run_early): poststep and
       movfuse, anchor-on-first-op rewrites. */
    {
        /* poststep: MOV t <- x; INC x → POSTSTEP t <- x (imm 1),
           INC gone, compacted. x stays multi-use (the RET reads t,
           the loop would read x) — no single-use gate. */
        Func *f = ir_func_new(NULL);
        int x = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, x, 9);
        ir_emit_mov(bb, t, x);
        ir_emit_unop(bb, IR_INC, x, x);
        Op *st = ir_op_emit(bb, IR_ST_MEM);   /* keep x used after */
        st->src[0] = x;
        st->mem.kind = IR_MEM_SYM;
        st->mem.sym  = (SYMBOL *)&sym_g;
        ir_emit_ret(bb, t);
        int n = ir_match_run_early(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 4
               && bb->ops[1].kind == IR_POSTSTEP
               && bb->ops[1].dst == t && bb->ops[1].src[0] == x
               && bb->ops[1].imm == 1
               && ir_validate(f) == 0,
               "production poststep fuses (INC, multi-use x)");
        ir_func_free(f);
    }
    {
        /* poststep DEC variant → imm -1. */
        Func *f = ir_func_new(NULL);
        int x = ir_vreg_new(f, 2, NULL, 0);
        int t = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, x, 9);
        ir_emit_mov(bb, t, x);
        ir_emit_unop(bb, IR_DEC, x, x);
        ir_emit_ret(bb, t);
        int n = ir_match_run_early(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->ops[1].kind == IR_POSTSTEP
               && bb->ops[1].imm == -1
               && ir_validate(f) == 0, "production poststep DEC");
        ir_func_free(f);
    }
    {
        /* poststep gates: width-4 pair and volatile x both rejected. */
        for (int variant = 0; variant < 2; variant++) {
            Func *f = ir_func_new(NULL);
            int x = ir_vreg_new(f, 2, NULL,
                                variant ? IR_VREG_VOLATILE : 0);
            int t = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            if (!variant) {
                f->vregs[x].width = 4;
                f->vregs[t].width = 4;
            }
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            ir_emit_mov(bb, t, x);
            ir_emit_unop(bb, IR_INC, x, x);
            ir_emit_ret(bb, t);
            MCHECK(ir_match_run_early(f) == 0,
                   variant ? "poststep rejects volatile x"
                           : "poststep rejects width 4");
            ir_func_free(f);
        }
    }
    {
        /* movfuse: LD_MEM t <- [g]; MOV d <- t (t single-use) →
           LD_MEM d <- [g]; MOV gone. */
        Func *f = ir_func_new(NULL);
        int t = ir_vreg_new(f, 2, NULL, 0);
        int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        Op *ld = ir_op_emit(bb, IR_LD_MEM);
        ld->dst = t;
        ld->mem.kind = IR_MEM_SYM;
        ld->mem.sym  = (SYMBOL *)&sym_g;
        ir_emit_mov(bb, d, t);
        ir_emit_ret(bb, d);
        int n = ir_match_run_early(f);
        bb = &f->bbs[e];
        MCHECK(n == 1 && bb->n_ops == 2
               && bb->ops[0].kind == IR_LD_MEM && bb->ops[0].dst == d
               && bb->ops[1].kind == IR_RET
               && ir_validate(f) == 0, "production movfuse LD_MEM");
        ir_func_free(f);
    }
    {
        /* movfuse gates: multi-use t, width mismatch, and a
           non-producer kind (CALL) all rejected. */
        for (int variant = 0; variant < 3; variant++) {
            Func *f = ir_func_new(NULL);
            int t = ir_vreg_new(f, 2, NULL, 0);
            int d = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
            int u = ir_vreg_new(f, 2, NULL, 0);
            if (variant == 1) f->vregs[d].width = 1;
            int e = ir_bb_new(f);
            BB *bb = &f->bbs[e];
            if (variant == 2) {
                Op *call = ir_op_emit(bb, IR_CALL);
                CallInfo *ci = calloc(1, sizeof(CallInfo));
                ci->target = (SYMBOL *)&sym_callee;
                ci->fnptr_vreg = -1;
                ci->ret_vreg = t;
                call->call = ci;
                call->dst = t;
            } else {
                ir_emit_ld_imm(bb, t, 5);
            }
            ir_emit_mov(bb, d, t);
            if (variant == 0)
                ir_emit_binop(bb, IR_ADD, u, t, d); /* second use of t */
            ir_emit_ret(bb, d);
            MCHECK(ir_match_run_early(f) == 0,
                   variant == 0 ? "movfuse rejects multi-use t"
                 : variant == 1 ? "movfuse rejects width mismatch"
                                : "movfuse rejects CALL producer");
            ir_func_free(f);
        }
    }
    {
        /* movfuse chain: LD_IMM a; MOV b<-a; MOV c<-b converges to
           LD_IMM c across rounds. */
        Func *f = ir_func_new(NULL);
        int a = ir_vreg_new(f, 2, NULL, 0);
        int b = ir_vreg_new(f, 2, NULL, 0);
        int c = ir_vreg_new(f, 2, NULL, IR_VREG_RETURN);
        int e = ir_bb_new(f);
        BB *bb = &f->bbs[e];
        ir_emit_ld_imm(bb, a, 5);
        ir_emit_mov(bb, b, a);
        ir_emit_mov(bb, c, b);
        ir_emit_ret(bb, c);
        int n = ir_match_run_early(f);
        bb = &f->bbs[e];
        MCHECK(n == 2 && bb->n_ops == 2
               && bb->ops[0].kind == IR_LD_IMM && bb->ops[0].dst == c
               && ir_validate(f) == 0, "production movfuse chain");
        ir_func_free(f);
    }

#undef MCHECK
    return fails;
}

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
    /* loop_sum takes a param, but no init prologue is built here —
       just verify the lowerer can SEE the IR without crashing. The
       emitted code references an un-initialised param slot, which is
       fine for shape validation. */
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

    printf("\n=== ir_match engine (pattern matcher) ===\n");
    {
        int fails = run_match_tests();
        if (fails) {
            fprintf(stderr, "FAIL: %d ir_match test(s)\n", fails);
            return 1;
        }
        printf("  all ir_match tests passed\n");
    }

    printf("\nALL CHECKS PASSED\n");
    return 0;
}
