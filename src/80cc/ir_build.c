/*
 * ir_build.c — AST → IR translator.
 *
 * Coverage grows on demand: anything not yet handled aborts with a
 * diagnostic so we can see exactly which AST shape needs the next
 * coverage bump.
 *
 * Pulls in the full compiler headers (ccdefs.h) — IR core (ir.h /
 * ir.c) stays decoupled so ir_selftest can build standalone, but
 * this translator obviously needs the AST type system.
 */

#include "ccdefs.h"
#include "ir.h"
#include "ir_build.h"
#include "ir_lower.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ----- Builder state --------------------------------------------------- */

typedef struct {
    Func *f;
    int   cur_bb_id;   /* index into f->bbs[]; a pointer would dangle
                          when ir_bb_new realloc's the array */

    /* Map from SYMBOL* → vreg id. Linear search — function-local syms
       are few (tens at most). Refine later if profiling shows it. */
    struct sym_vreg {
        SYMBOL *sym;
        int     vreg;
    } *sym_map;
    int sym_map_n;
    int sym_map_cap;

    /* Map from C label id (n->label) → BB id. Lazy: get-or-create on
       first reference (forward or backward). */
    struct label_bb {
        int label_id;
        int bb_id;
    } *label_map;
    int label_map_n;
    int label_map_cap;
} Builder;

static BB *cur_bb(Builder *b)
{
    return &b->f->bbs[b->cur_bb_id];
}

static int get_or_create_label_bb(Builder *b, int label_id)
{
    for (int i = 0; i < b->label_map_n; i++)
        if (b->label_map[i].label_id == label_id)
            return b->label_map[i].bb_id;
    if (b->label_map_n >= b->label_map_cap) {
        b->label_map_cap = b->label_map_cap ? b->label_map_cap * 2 : 8;
        b->label_map = realloc(b->label_map,
                               b->label_map_cap * sizeof(*b->label_map));
    }
    int bb = ir_bb_new(b->f);
    b->label_map[b->label_map_n].label_id = label_id;
    b->label_map[b->label_map_n].bb_id    = bb;
    b->label_map_n++;
    return bb;
}

/* Ensure current BB ends with a terminator; if not, emit IR_BR to
   `target_bb` (fall-through). Used when transitioning BBs. */
static void close_bb_with_fallthrough(Builder *b, int target_bb)
{
    BB *bb = cur_bb(b);
    if (bb->n_ops == 0 ||
        !ir_op_is_terminator(bb->ops[bb->n_ops - 1].kind)) {
        ir_emit_br(bb, target_bb);
    }
}

static void builder_init(Builder *b, Func *f)
{
    memset(b, 0, sizeof(*b));
    b->f = f;
}

static void builder_free(Builder *b)
{
    free(b->sym_map);
    free(b->label_map);
}

static void sym_map_set(Builder *b, SYMBOL *sym, int vreg)
{
    if (b->sym_map_n >= b->sym_map_cap) {
        b->sym_map_cap = b->sym_map_cap ? b->sym_map_cap * 2 : 8;
        b->sym_map = realloc(b->sym_map,
                             b->sym_map_cap * sizeof(*b->sym_map));
    }
    b->sym_map[b->sym_map_n].sym  = sym;
    b->sym_map[b->sym_map_n].vreg = vreg;
    b->sym_map_n++;
}

static int sym_map_get(const Builder *b, const SYMBOL *sym)
{
    for (int i = 0; i < b->sym_map_n; i++)
        if (b->sym_map[i].sym == sym) return b->sym_map[i].vreg;
    return -1;
}

/* ----- Bail-out diagnostic --------------------------------------------- */

/* Set by ir_generate_code so build_fail() can name the offending func.
   Plain global — single-threaded compiler. */
static const char *cur_fn_name = "?";

/* Set by build_fail so ir_generate_code can tell a diagnosed bail from a
   SILENT one (a bare `return -1`/`-2` that named no reason). A silent
   fall-back to the walker is invisible — it quietly drops IR coverage
   (and can mask a walker miscompile), as the dstar_gencon return-in-loop
   case did — so we flag it. */
static int build_fail_emitted;

static int build_fail(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fprintf(stderr, "ir_build: [%s] ", cur_fn_name);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
    build_fail_emitted = 1;
    return -1;
}

/* ----- Expression walker — returns the vreg holding the result, or -1
   on failure. Width is inferred from node->type when available.

   `hint` is an optional caller-provided destination vreg. When >= 0 and
   the expression supports it, the result is written directly to `hint`
   and `hint` is returned, eliminating the intermediate-temp + MOV the
   caller would otherwise emit. Cases that don't support a hint (e.g. a
   bare local-var read where the value already lives in another vreg)
   return that vreg; the caller must emit the MOV. Pass -1 to force a
   fresh temp. */

static int build_expr_hinted(Builder *b, Node *n, int hint);
static int init_typed_region(Builder *b, int base, int off,
                             Type *t, Node *init, int *budget);

/* The inline mem/str loop forms (IR_MEMSET ldir/djnz, IR_MEMCPY ldir,
   IR_STRCPY ldi, IR_STRCHR jr) use Z80-only block ops and relative
   jumps. 8080/8085 lack them; gbz80 encodes them differently than the
   IR loop forms emit. On those targets we keep the inline only for the
   pure ld/inc unrolls (tiny counts) and otherwise fall back to the
   library call — correct, just not inlined. Mirrors the walker, which
   bails its inline builtins entirely on IS_808x. */
static int ir_inline_block_ops_ok(void)
{
    return !IS_808x() && !IS_GBZ80();
}

static int build_expr(Builder *b, Node *n)
{
    return build_expr_hinted(b, n, -1);
}

/* Allocate a fresh int-width vreg as a temp. */
static int new_temp(Builder *b, int width)
{
    int v = ir_vreg_new(b->f, 2 /* KIND_INT placeholder */, NULL, 0);
    b->f->vregs[v].width = (width > 0) ? width : 2;
    return v;
}

/* True for kinds the builder can store in a 2-byte slot. */
static int is_int2_kind(Kind k)
{
    return k == KIND_INT || k == KIND_SHORT || k == KIND_PTR;
}

/* Integer kinds + _Accum. _Accum ADD/SUB/CMP/NEG are bit-identical
   to integer ops; MUL/DIV need fix-scaling helpers and bail. */
static int is_supported_int_kind(Kind k)
{
    return k == KIND_CHAR || k == KIND_INT || k == KIND_SHORT
        || k == KIND_PTR  || k == KIND_LONG
        || k == KIND_ACCUM16 || k == KIND_ACCUM32;
}

/* Width in bytes for the integer/fix kinds we care about. Returns 0
   for anything outside the supported set so callers can bail. */
static int width_for_kind(Kind k)
{
    if (k == KIND_CHAR)  return 1;
    if (k == KIND_INT || k == KIND_SHORT || k == KIND_PTR
        || k == KIND_ACCUM16) return 2;
    if (k == KIND_LONG || k == KIND_ACCUM32)  return 4;
    return 0;
}

/* Scale an AST_LITERAL's zval to the raw bit pattern for target
   kind k. _Accum / long _Accum get the Q-format multiply (×256 /
   ×65536, round to nearest). Everything else is a plain truncate
   to int64_t. */
static int64_t scale_literal_for_kind(const Node *lit, Kind k)
{
    double v = (double)lit->zval;
    if (k == KIND_ACCUM16) return (int64_t)(v * 256.0   + (v >= 0 ? 0.5 : -0.5));
    if (k == KIND_ACCUM32) return (int64_t)(v * 65536.0 + (v >= 0 ? 0.5 : -0.5));
    return (int64_t)v;
}

/* Width for a Type pointer, falling back to 2 if absent. */
static int type_width(Type *t)
{
    if (!t) return 2;
    int w = width_for_kind(t->kind);
    return w ? w : 2;
}

/* Allocate a vreg for a source-declared local. Registers it in the
   sym_map and gives it the local's sym for the dumper.

   Arrays/structs overload the vreg's int16_t `width` as slot byte
   count (so ~32KB fits) and mark it IR_VREG_ADDR_TAKEN: references
   decay to its address, and the value is only ever read via IR_LEA. */
static int new_local_vreg(Builder *b, SYMBOL *sym)
{
    int v = ir_vreg_new(b->f, (int)sym->type, sym, 0);
    Kind k = (Kind)sym->type;
    if (k == KIND_ARRAY || k == KIND_STRUCT) {
        /* Byte count lives in sym->ctype->size (sym->size is used
           for goto labels / per-sym bookkeeping). */
        int sz = sym->ctype ? sym->ctype->size : 0;
        b->f->vregs[v].width = (int16_t)sz;
        b->f->vregs[v].flags |= IR_VREG_ADDR_TAKEN;
    } else {
        int w = width_for_kind(k);
        b->f->vregs[v].width = (int16_t)(w ? w : 2);
    }
    sym_map_set(b, sym, v);
    return v;
}

/* Typed-region initialiser for AST_DECL aggregate init lists.

   Walks the TYPE (struct fields / array elements / scalar leaf) in
   parallel with the init nodes, emitting IR_ST_MEM at base+off for
   each leaf — and ZERO-FILLING leaves the list doesn't cover (C
   semantics: a partial initialiser zeroes the remainder; the old
   flattener skipped this, leaving `int a[4] = {9}` with garbage in
   a[1..3]).

   `*budget` caps the total stores (zero-fill of a big `= {0}` array
   would explode the function — past the cap we bail to the walker,
   which emits a fill loop).

   Returns 0 ok, -1 hard error (already reported), -2 unsupported
   shape (caller emits the build_fail; the partially built IR is
   discarded with the function). */
#define INIT_REGION_MAX_STORES 32

static int init_typed_region(Builder *b, int base, int off,
                             Type *t, Node *init, int *budget)
{
    if (!t) return -2;

    if (t->kind == KIND_STRUCT) {
        Type *tag = t->tag ? t->tag : t;
        if (!tag->isstruct) return -2;          /* union init */
        if (init && init->ast_type != AST_INIT_LIST) return -2;
        int n_init = (init && init->stmts)
                   ? (int)array_len(init->stmts) : 0;
        int n_fld = tag->fields ? (int)array_len(tag->fields) : 0;
        for (int i = 0; i < n_fld; i++) {
            Type *fld = array_get_byindex(tag->fields, i);
            if (!fld) continue;
            if (fld->bit_size > 0) return -2;   /* bitfields */
            Node *sub = (i < n_init)
                      ? array_get_byindex(init->stmts, i) : NULL;
            int rc = init_typed_region(b, base, off + (int)fld->offset,
                                       fld, sub, budget);
            if (rc < 0) return rc;
        }
        return 0;
    }

    if (t->kind == KIND_ARRAY) {
        Type *el = t->ptr;
        if (!el) return -2;
        int n = t->len;
        if (n <= 0) return -2;
        int el_sz = (el->kind == KIND_STRUCT || el->kind == KIND_ARRAY)
                  ? (int)el->size : type_width(el);
        if (el_sz <= 0) return -2;
        if (init && init->ast_type != AST_INIT_LIST) return -2;
        int n_init = (init && init->stmts)
                   ? (int)array_len(init->stmts) : 0;
        for (int i = 0; i < n; i++) {
            Node *sub = (i < n_init)
                      ? array_get_byindex(init->stmts, i) : NULL;
            int rc = init_typed_region(b, base, off + i * el_sz,
                                       el, sub, budget);
            if (rc < 0) return rc;
        }
        return 0;
    }

    /* Scalar leaf. */
    int w = width_for_kind(t->kind);
    if (t->kind == KIND_PTR || t->kind == KIND_CPTR) w = 2;
    if (w != 1 && w != 2 && w != 4) return -2;
    if (--(*budget) < 0) return -2;
    int val_v;
    if (init) {
        if (init->ast_type == AST_INIT_LIST) return -2; /* over-braced */
        val_v = build_expr(b, init);
        if (val_v < 0) return -1;
        int vw = b->f->vregs[val_v].width;
        if (vw != w) {
            int tmp = new_temp(b, w);
            b->f->vregs[tmp].width = (int16_t)w;
            OpKind cv = (vw > w)
                ? IR_CONV_TRUNC
                : (init->type && init->type->isunsigned
                   ? IR_CONV_ZX : IR_CONV_SX);
            Op *op = ir_op_emit(cur_bb(b), cv);
            op->dst = tmp; op->src[0] = val_v;
            val_v = tmp;
        }
    } else {
        val_v = new_temp(b, w);
        b->f->vregs[val_v].width = (int16_t)w;
        ir_emit_ld_imm(cur_bb(b), val_v, 0);
    }
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0]   = val_v;
    st->mem.kind = IR_MEM_VREG;
    st->mem.base = base;
    st->mem.offset = off;
    st->mem.elem = (w == 1) ? KIND_CHAR : (w == 2) ? KIND_INT : KIND_LONG;
    return 0;
}

/* Map a C OP_* binary op to an IR OpKind. Returns IR_OP_COUNT for
   shapes the builder can't lower. */
static OpKind op_to_ir_binop(int op)
{
    switch (op) {
    case OP_ADD:  return IR_ADD;
    case OP_SUB:  return IR_SUB;
    case OP_AND:  return IR_AND;
    case OP_OR:   return IR_OR;
    case OP_XOR:  return IR_XOR;
    case OP_USHL: return IR_SHL;
    case OP_SSHL: return IR_SHL;
    case OP_USHR: return IR_SHR;
    case OP_SSHR: return IR_SHR;   /* logical for now; #289 limitation */
    case OP_EQ:   return IR_CMP_EQ;
    case OP_NE:   return IR_CMP_NE;
    case OP_LT:   return IR_CMP_LT;    /* signed default */
    case OP_LE:   return IR_CMP_LE;
    case OP_GT:   return IR_CMP_GT;
    case OP_GE:   return IR_CMP_GE;
    default:      return IR_OP_COUNT;
    }
}

static int build_expr_hinted(Builder *b, Node *n, int hint)
{
    if (!n) return build_fail("null expr node");

    /* alloc_dst: return `hint` if provided, else a fresh temp.
       Not every site is hint-safe: aliased-constraint ops (binops
       where dst aliases src[0]) would need hint == src[0], which the
       caller can't guarantee, so binops still allocate a fresh dst.
       The win is in LD_IMM, unary ops, and the passthrough cases. */
    #define ALLOC_DST(width) ((hint) >= 0 ? (hint) : new_temp(b, (width)))

    switch (n->ast_type) {

    case AST_LITERAL: {
        /* Width from the literal's type. A `long` constant must
           materialise into a width-4 vreg — width=2 would silently
           drop the high half. Default to int when type info is gone. */
        int w = n->type ? type_width(n->type) : 2;
        if (w != 1 && w != 2 && w != 4) w = 2;
        /* If the caller hinted a destination vreg whose kind is
           _Accum, the literal is an FP value being implicitly
           converted — scale to Q-format raw bits and use the
           target width (ACCUM32 needs width 4 even when the
           literal was a 2-byte double). */
        Kind target_k = (hint >= 0) ? (Kind)b->f->vregs[hint].kind
                                    : KIND_NONE;
        if      (target_k == KIND_ACCUM32) w = 4;
        else if (target_k == KIND_ACCUM16) w = 2;
        int v = ALLOC_DST(w);
        /* A hinted dst (decl-init) keeps its DECLARED width — the
           literal adapts to the variable, not vice versa. `UINT4
           crc = 0` used to shrink crc's vreg to the int literal's
           width 2, so EVERY later long op on crc ran 16-bit
           (crcbench's accumulate; masked for ages because the
           assertEqual compare was truncated by the same bug). */
        if (hint >= 0 && b->f->vregs[v].width > 0
            && target_k != KIND_ACCUM16 && target_k != KIND_ACCUM32)
            w = b->f->vregs[v].width;
        b->f->vregs[v].width = (int16_t)w;
        if (target_k == KIND_ACCUM16 || target_k == KIND_ACCUM32)
            b->f->vregs[v].kind = target_k;
        ir_emit_ld_imm(cur_bb(b), v, scale_literal_for_kind(n, target_k));
        return v;
    }

    case AST_STR_LIT: {
        /* String-literal queue ref: IR_LD_STR emits
           `ld hl,i_<litlab>+<zval>`. */
        int v = new_temp(b, 2);
        Op *op = ir_op_emit(cur_bb(b), IR_LD_STR);
        op->dst = v;
        op->imm = n->zval;
        return v;
    }

    case AST_LOCAL_VAR:
        /* Bare AST_LOCAL_VAR for scalars is the *address* of the local
           — rvalue reads come through OP_DEREF (handled below), and
           the bare form appears only as the LHS of OP_ASSIGN (handled
           there). Arrays are the exception: by C decay rules, an
           array name in expression context evaluates to a pointer to
           the first element — emit IR_LEA to produce that address. */
        if (n->sym && ((Kind)n->sym->type == KIND_ARRAY
                    || (Kind)n->sym->type == KIND_STRUCT)) {
            int src = sym_map_get(b, n->sym);
            if (src < 0)
                return build_fail("AST_LOCAL_VAR aggregate unmapped %s",
                                  n->sym->name);
            int dst = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LEA);
            op->dst    = dst;
            op->src[0] = src;
            return dst;
        }
        /* Scalar bare local in a value context — e.g. a ternary / logical
           condition the parser left un-deref'd (`k ? a : b`, `while (k)`).
           In the IR a scalar local's value lives in its vreg, so return
           that — consistent with the OP_DEREF / OP_ASSIGN local-operand
           shortcuts, which also read the value via sym_map_get. A scalar
           local's *address* only ever arrives via OP_ADDR (handled
           separately), so this is unambiguously the value. */
        {
            int v = sym_map_get(b, n->sym);
            if (v < 0)
                return build_fail("bare AST_LOCAL_VAR unmapped %s",
                                  n->sym ? n->sym->name : "?");
            return v;
        }

    case AST_GLOBAL_VAR: {
        /* Function-typed and array-typed globals decay to their ADDRESS
           in expression context (C §6.3.2.1). Walker emits `ld hl,_sym`
           (not `ld hl,(_sym)`). Aggregates (struct/union) at the AST
           level are usually flagged separately — start with the two
           most common decays and extend if needed. */
        if (n->sym && n->sym->ctype &&
            (n->sym->ctype->kind == KIND_FUNC ||
             n->sym->ctype->kind == KIND_ARRAY ||
             n->sym->ctype->kind == KIND_STRUCT)) {
            int v = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LD_SYM);
            op->dst = v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->sym;
            return v;
        }
        /* Global — load from MEM_SYM. Width from the symbol's type
           kind so long globals stay long through the lowerer; without
           it `unsigned long g; foo(g)` truncates g to int on read
           (mirror of the long-store-to-global bug). sym->type is the
           KIND_* code (KIND_LONG → 4), as new_local_vreg uses. */
        int gv_w = 2;
        if (n->sym) {
            int w = width_for_kind((Kind)n->sym->type);
            if (w > 0) gv_w = w;
        }
        int v = new_temp(b, gv_w);
        Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
        op->dst = v;
        op->mem.kind = IR_MEM_SYM;
        op->mem.sym  = n->sym;
        return v;
    }

    case OP_DEREF:
        /* Most common shape: OP_DEREF(AST_LOCAL_VAR) — read a local.
           OP_DEREF(AST_GLOBAL_VAR) is also accepted so we can
           collapse `(deref (gv=x))` to a sym-mem load.

           OP_DEREF wrapping a pre/post step (`(deref (post++ X))`) is
           a parser-side rvalue() habit — the step already produces the
           value; pass through. (Matches cg2_walk's behaviour.) */
        if (n->operand && (n->operand->ast_type == OP_PRE_INC ||
                           n->operand->ast_type == OP_POST_INC ||
                           n->operand->ast_type == OP_PRE_DEC ||
                           n->operand->ast_type == OP_POST_DEC)) {
            /* sccz80's rvalue() wraps every step in this OP_DEREF
               stamped with the lvalue's value type (lval->ltype). The
               step node's own type was left at the operand's *address*
               type by normalize_types, so it can't size loads/stores.
               Transfer this OP_DEREF's value type onto the step for
               the duration of the call. */
            Type *saved = n->operand->type;
            if (n->type) n->operand->type = n->type;
            int r = build_expr(b, n->operand);
            n->operand->type = saved;
            return r;
        }
        /* `*p++` / `*p--` / `*++p` / `*--p` fastpath.
           AST shape: OP_DEREF(OP_DEREF(POST/PRE_INC/DEC(AST_LOCAL_VAR))).
           The outer OP_DEREF is the byte/int read through the pointer;
           the inner OP_DEREF is the parser's rvalue habit on the step's
           result. C "as-if" rule lets us deref through p's CURRENT
           value first, then bump p in place — skipping the `MOV old, p`
           temp the default lowering emits. Saves a slot + 11 instr/
           occurrence in tight loops like crc16_ccitt's `*data++`. */
        if (n->operand
            && n->operand->ast_type == OP_DEREF
            && n->operand->operand
            && (n->operand->operand->ast_type == OP_POST_INC ||
                n->operand->operand->ast_type == OP_PRE_INC  ||
                n->operand->operand->ast_type == OP_POST_DEC ||
                n->operand->operand->ast_type == OP_PRE_DEC)
            && n->operand->operand->operand
            && n->operand->operand->operand->ast_type == AST_LOCAL_VAR) {
            Node *step = n->operand->operand;
            SYMBOL *lsym = step->operand->sym;
            int p_vreg = sym_map_get(b, lsym);
            if (p_vreg < 0)
                return build_fail("deref-step on unknown local %s",
                                  lsym ? lsym->name : "?");
            int is_inc = (step->ast_type == OP_POST_INC ||
                          step->ast_type == OP_PRE_INC);
            int is_pre = (step->ast_type == OP_PRE_INC ||
                          step->ast_type == OP_PRE_DEC);
            int elem_w = type_width(n->type);
            if (elem_w != 1 && elem_w != 2)
                return build_fail("deref-step elem width %d not supported",
                                  elem_w);
            /* Step amount: sizeof(*p). char* → +/-1 (IR_INC/IR_DEC);
               int* → +/-2 (IR_ADD/SUB with imm). Pointee width from
               the local's pointed-to type, falling back to the deref's
               result width if unavailable. */
            int pointee_w = lsym->ctype && lsym->ctype->ptr
                ? type_width(lsym->ctype->ptr) : elem_w;
            if (pointee_w != 1 && pointee_w != 2)
                return build_fail("deref-step pointee width %d "
                                  "not supported", pointee_w);

            #define EMIT_BUMP() do { \
                if (pointee_w == 1) { \
                    ir_emit_unop(cur_bb(b), is_inc ? IR_INC : IR_DEC, \
                                 p_vreg, p_vreg); \
                } else { \
                    Op *bop = ir_op_emit(cur_bb(b), \
                                         is_inc ? IR_ADD : IR_SUB); \
                    bop->dst    = p_vreg; \
                    bop->src[0] = p_vreg; \
                    bop->src[1] = -1; \
                    bop->imm    = pointee_w; \
                } \
            } while (0)

            if (is_pre) EMIT_BUMP();
            int dst = new_temp(b, elem_w);
            b->f->vregs[dst].width = (int16_t)elem_w;
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst      = dst;
            ld->mem.kind = IR_MEM_VREG;
            ld->mem.base = p_vreg;
            ld->mem.elem = (elem_w == 1) ? KIND_CHAR : KIND_INT;
            if (!is_pre) EMIT_BUMP();
            #undef EMIT_BUMP

            return dst;
        }
        if (n->operand && n->operand->ast_type == AST_LOCAL_VAR) {
            int v = sym_map_get(b, n->operand->sym);
            if (v < 0) return build_fail("deref of unknown local %s",
                                  n->operand->sym ? n->operand->sym->name : "?");
            /* Aggregate local: the vreg is the slot base. The parser
               folds offset-0 member access to `(deref (lv=struct_p))`
               — we need a real load through &p, not the bare vreg. */
            Kind lk = n->operand->sym ? (Kind)n->operand->sym->type
                                       : KIND_NONE;
            if (lk == KIND_STRUCT || lk == KIND_ARRAY) {
                int elem_w = type_width(n->type);
                if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                    return build_fail("OP_DEREF aggregate elem width %d "
                                      "not supported", elem_w);
                int base = new_temp(b, 2);
                Op *lea = ir_op_emit(cur_bb(b), IR_LEA);
                lea->dst = base; lea->src[0] = v;
                int dst = new_temp(b, elem_w);
                b->f->vregs[dst].width = (int16_t)elem_w;
                Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
                ld->dst       = dst;
                ld->mem.kind  = IR_MEM_VREG;
                ld->mem.base  = base;
                ld->mem.elem  = (elem_w == 1) ? KIND_CHAR
                              : (elem_w == 2) ? KIND_INT
                              :                 KIND_LONG;
                return dst;
            }
            return v;
        }
        if (n->operand && n->operand->ast_type == AST_GLOBAL_VAR) {
            /* Same width sourcing as the bare-AST_GLOBAL_VAR case
               above — without this, OP_DEREF(global long) truncates
               to int. For ARRAY globals the deref reads ELEMENT 0
               (the parser const-folds `arr[0]` to this shape):
               width must come from the element type — KIND_ARRAY
               itself has no width and silently defaulted to a WORD
               load of byte arrays. */
            int gv_w = 2;
            SYMBOL *gs = n->operand->sym;
            /* The deref node's own type is the VALUE type — the only
               reliable width source when the parser folds a struct
               member read (`g.i[0]`, struct sym, offset 0) to this
               bare-global shape: KIND_STRUCT has no usable elem in
               ctype->ptr (q4: long member read 16-bit). */
            if (n->type && is_supported_int_kind(n->type->kind)) {
                int w = type_width(n->type);
                if (w > 0) gv_w = w;
                gs = NULL;   /* width resolved; skip sym fallback */
            }
            if (gs) {
                if ((Kind)gs->type == KIND_ARRAY
                    && gs->ctype && gs->ctype->ptr) {
                    int w = type_width(gs->ctype->ptr);
                    if (w > 0) gv_w = w;
                } else {
                    int w = width_for_kind((Kind)gs->type);
                    if (w > 0) gv_w = w;
                }
            }
            int v = new_temp(b, gv_w);
            Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
            op->dst = v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->operand->sym;
            return v;
        }
        /* Real indirection: operand is a pointer expression. Walk it
           to get a vreg holding the address, then emit IR_LD_MEM via
           MEM_VREG. Element width comes from the deref's result type. */
        if (n->operand) {
            int ptr_v = build_expr(b, n->operand);
            if (ptr_v < 0) return -1;
            int elem_w = type_width(n->type);
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("OP_DEREF elem width %d not supported",
                                  elem_w);
            int dst = new_temp(b, elem_w);
            b->f->vregs[dst].width = elem_w;
            Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
            op->dst       = dst;
            op->mem.kind  = IR_MEM_VREG;
            op->mem.base  = ptr_v;
            op->mem.elem  = (elem_w == 1) ? KIND_CHAR
                          : (elem_w == 2) ? KIND_INT
                          :                 KIND_LONG;
            return dst;
        }
        return build_fail("OP_DEREF without operand");

    case OP_ADD: case OP_SUB:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_USHL: case OP_SSHL:
    case OP_USHR: case OP_SSHR:
    case OP_EQ: case OP_NE:
    case OP_LT: case OP_LE: case OP_GT: case OP_GE: {
        OpKind k = op_to_ir_binop(n->ast_type);
        if (k == IR_OP_COUNT) return build_fail("binop dispatch hole");

        /* Operand-type-aware compare dispatch. op_to_ir_binop maps
           OP_LT/LE/GT/GE to the signed variants unconditionally. C's
           usual arithmetic conversions promote `signed < unsigned` to
           unsigned-vs-unsigned at the same rank, so if either operand
           is unsigned the compare is unsigned. Without this,
           `unsigned long < K` emitted the signed S^V correction and
           miscompiled values with bit 31 set. EQ/NE are sign-
           independent (the byte XOR-OR chain doesn't care). */
        if (k == IR_CMP_LT || k == IR_CMP_LE
            || k == IR_CMP_GT || k == IR_CMP_GE) {
            int uns = (n->left  && n->left->type  && n->left->type->isunsigned)
                   || (n->right && n->right->type && n->right->type->isunsigned);
            if (uns) {
                switch (k) {
                case IR_CMP_LT: k = IR_CMP_ULT; break;
                case IR_CMP_LE: k = IR_CMP_ULE; break;
                case IR_CMP_GT: k = IR_CMP_UGT; break;
                case IR_CMP_GE: k = IR_CMP_UGE; break;
                default: break;
                }
            }
        }

        /* If the LHS is AST_LITERAL and the op is commutative (or can
           be made so by inverting), swap operands so the literal lands
           on the RHS where the imm-fold path handles it.

           ast_opt already commutes the truly-commutative cases (ADD,
           AND, OR, XOR, EQ, NE) but leaves the compares (LT/LE/GT/GE)
           as `lit OP var` since swapping them inverts the op
           (`5 < x` → `x > 5`). Catch those here. */
        Node *lhs = n->left;
        Node *rhs = n->right;
        if (lhs && lhs->ast_type == AST_LITERAL &&
            (!rhs || rhs->ast_type != AST_LITERAL)) {
            OpKind swapped = IR_OP_COUNT;
            switch (k) {
            case IR_CMP_LT:  swapped = IR_CMP_GT;  break;
            case IR_CMP_LE:  swapped = IR_CMP_GE;  break;
            case IR_CMP_GT:  swapped = IR_CMP_LT;  break;
            case IR_CMP_GE:  swapped = IR_CMP_LE;  break;
            case IR_CMP_ULT: swapped = IR_CMP_UGT; break;
            case IR_CMP_ULE: swapped = IR_CMP_UGE; break;
            case IR_CMP_UGT: swapped = IR_CMP_ULT; break;
            case IR_CMP_UGE: swapped = IR_CMP_ULE; break;
            default: break;
            }
            if (swapped != IR_OP_COUNT) {
                k = swapped;
                Node *tmp = lhs; lhs = rhs; rhs = tmp;
            }
            /* Commutative ops (ADD/AND/OR/XOR/EQ/NE) shouldn't normally
               see lit-LHS after ast_opt, but in case they slip through
               (e.g. through CSE-synth), swap unconditionally. */
            else if (k == IR_ADD  || k == IR_AND || k == IR_OR ||
                     k == IR_XOR  || k == IR_CMP_EQ || k == IR_CMP_NE) {
                Node *tmp = lhs; lhs = rhs; rhs = tmp;
            }
        }

        int l = build_expr(b, lhs);
        if (l < 0) return -1;
        int width = b->f->vregs[l].width;
        /* Integer promotion: byte operands take part in arithmetic
           and shifts as int — a width-1 result vreg would compute
           `byte << 8` as zero and truncate `byte + byte` carries.
           `byte << 8` itself is the combined widen+shift op. */
        if (width == 1
            && (k == IR_ADD || k == IR_SUB
             || k == IR_SHL || k == IR_SHR)) {
            int uns = !lhs->type || lhs->type->isunsigned;
            if (k == IR_SHL && rhs && rhs->ast_type == AST_LITERAL
                && (int64_t)rhs->zval == 8) {
                int dst = new_temp(b, 2);
                b->f->vregs[dst].width = 2;
                Op *bh = ir_op_emit(cur_bb(b), IR_CONV_BYTE_TO_HIGH);
                bh->dst = dst;
                bh->src[0] = l;
                return dst;
            }
            int wtmp = new_temp(b, 2);
            b->f->vregs[wtmp].width = 2;
            Op *cvp = ir_op_emit(cur_bb(b),
                                 uns ? IR_CONV_ZX : IR_CONV_SX);
            cvp->dst = wtmp;
            cvp->src[0] = l;
            l = wtmp;
            width = 2;
        }
        /* Long binops: ADD/SUB via helper calls; AND/OR/XOR byte-wise
           inline; SHL/SHR with const count inline; CMP_EQ/NE byte-wise
           OR-of-diffs (#340). Others bail. */
        if (width == 4
            && k != IR_ADD && k != IR_SUB
            && k != IR_AND && k != IR_OR && k != IR_XOR
            && k != IR_SHL && k != IR_SHR
            && k != IR_CMP_EQ && k != IR_CMP_NE
            && k != IR_CMP_LT && k != IR_CMP_LE
            && k != IR_CMP_GT && k != IR_CMP_GE
            && k != IR_CMP_ULT && k != IR_CMP_ULE
            && k != IR_CMP_UGT && k != IR_CMP_UGE)
            return build_fail("long binop op %d deferred (operand width 4)",
                              (int)k);
        /* Comparisons produce a bool/int result regardless of operand
           width — the dst is always width 2. */
        int is_cmp = (k >= IR_CMP_EQ && k <= IR_CMP_UGE);
        /* Shift counts never participate in width convergence (the
           count is an imm / width-2 vreg, not an arithmetic operand);
           pointer results keep 16-bit address math. */
        int is_shift = (k == IR_SHL || k == IR_SHR);
        int is_ptrish = (n->type && n->type->kind == KIND_PTR)
                     || (lhs->type && lhs->type->kind == KIND_PTR);
        /* Widen the LHS to the RESULT width when the literal RHS or
           the expression type is wider than the LHS vreg. The
           commutative swap above moves literals to the RHS, so
           `0x01000100UL + i` arrives with l = i (width 2) and a LONG
           literal — without this the add ran at 16 bits, truncating
           the constant to its low word (tt2/tt3: png[i] init lost
           the 0x0100 high half in BOTH modes). */
        if (!is_shift && !is_ptrish
            && rhs && rhs->ast_type == AST_LITERAL) {
            int tw = width;
            if (rhs->type && is_supported_int_kind(rhs->type->kind)
                && type_width(rhs->type) > tw)
                tw = type_width(rhs->type);
            if (n->type && is_supported_int_kind(n->type->kind)
                && type_width(n->type) > tw)
                tw = type_width(n->type);
            if (tw > width) {
                int uns = !lhs->type || lhs->type->isunsigned;
                int wtmp = new_temp(b, tw);
                b->f->vregs[wtmp].width = (int16_t)tw;
                Op *cv = ir_op_emit(cur_bb(b),
                                    uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wtmp; cv->src[0] = l;
                l = wtmp;
                width = tw;
            }
        }
        int dst_w  = is_cmp ? 2 : width;
        /* Literal-RHS fold: emit the binop with src[1] = -1 and
           op->imm = literal so the lowerer materialises the constant
           inline (`ld de, K` for binops, unrolled `add hl,hl` for
           shifts). Saves a frame slot and the LD_IMM/store/reload
           churn of the dumb path. */
        if (rhs && rhs->ast_type == AST_LITERAL) {
            int dst = ALLOC_DST(dst_w);
            Op *op = ir_op_emit(cur_bb(b), k);
            op->dst    = dst;
            op->src[0] = l;
            op->src[1] = -1;
            op->imm    = (int64_t)rhs->zval;
            b->f->vregs[dst].width = (int16_t)dst_w;
            return dst;
        }
        int r = build_expr(b, rhs);
        if (r < 0) return -1;
        if (b->f->vregs[r].width == 4
            && k != IR_ADD && k != IR_SUB
            && k != IR_AND && k != IR_OR && k != IR_XOR
            && k != IR_SHL && k != IR_SHR
            && k != IR_CMP_EQ && k != IR_CMP_NE
            && k != IR_CMP_LT && k != IR_CMP_LE
            && k != IR_CMP_GT && k != IR_CMP_GE
            && k != IR_CMP_ULT && k != IR_CMP_ULE
            && k != IR_CMP_UGT && k != IR_CMP_UGE)
            return build_fail("long binop rhs op %d deferred", (int)k);
        /* Mixed-width variable operands: converge to the wider side
           (each by its OWN signedness) — the long lowerings read
           BOTH operands at the binop width, so a narrower vreg would
           contribute a garbage high half. Shifts keep their width-2
           count; pointer math stays 16-bit. */
        if (!is_shift && !is_ptrish
            && b->f->vregs[r].width != width) {
            if (b->f->vregs[r].width > width) {
                int uns = !lhs->type || lhs->type->isunsigned;
                int tw = b->f->vregs[r].width;
                int wtmp = new_temp(b, tw);
                b->f->vregs[wtmp].width = (int16_t)tw;
                Op *cv = ir_op_emit(cur_bb(b),
                                    uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wtmp; cv->src[0] = l;
                l = wtmp;
                width = tw;
                dst_w = is_cmp ? 2 : width;
            } else {
                int uns = !rhs->type || rhs->type->isunsigned;
                int wtmp = new_temp(b, width);
                b->f->vregs[wtmp].width = (int16_t)width;
                Op *cv = ir_op_emit(cur_bb(b),
                                    uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wtmp; cv->src[0] = r;
                r = wtmp;
            }
        }
        int dst = ALLOC_DST(dst_w);
        ir_emit_binop(cur_bb(b), k, dst, l, r);
        b->f->vregs[dst].width = (int16_t)dst_w;
        return dst;
    }

    case OP_ASSIGN: {
        /* LHS = RHS. LHS is an lvalue: AST_LOCAL_VAR (address) or
           AST_GLOBAL_VAR or a more complex address expression. Bare
           local / bare global only. */
        if (!n->left)
            return build_fail("OP_ASSIGN with NULL LHS");
        /* Derive the destination's _Accum kind so float-literal RHS
           gets Q-format scaling. Only set when the LHS sym carries a
           fix-point type. */
        Kind dst_accum = KIND_NONE;
        if (n->left->ast_type == AST_GLOBAL_VAR
            && n->left->sym
            && ((Kind)n->left->sym->type == KIND_ACCUM16
             || (Kind)n->left->sym->type == KIND_ACCUM32))
            dst_accum = (Kind)n->left->sym->type;
        if (n->left->ast_type == OP_DEREF
            && n->left->type
            && n->left->type->kind == KIND_PTR
            && n->left->type->ptr
            && (n->left->type->ptr->kind == KIND_ACCUM16
             || n->left->type->ptr->kind == KIND_ACCUM32))
            dst_accum = n->left->type->ptr->kind;
        if (n->left->ast_type == AST_LOCAL_VAR) {
            int dst_v = sym_map_get(b, n->left->sym);
            if (dst_v < 0)
                return build_fail("OP_ASSIGN to unknown local %s",
                                  n->left->sym ? n->left->sym->name : "?");
            Kind lk = n->left->sym ? (Kind)n->left->sym->type : KIND_NONE;
            if (lk == KIND_ARRAY || lk == KIND_STRUCT) {
                /* Folded offset-0 aggregate store: parser collapses
                   `arr[0] = X` to `(= (lv=arr) X)`. Emit LEA + ST_MEM
                   with element width from ctype->ptr. */
                Type *elem_t = n->left->sym->ctype
                             ? n->left->sym->ctype->ptr : NULL;
                int elem_w = type_width(elem_t);
                Kind elem_k = elem_t ? elem_t->kind : KIND_INT;
                if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                    return build_fail("OP_ASSIGN aggregate elem width %d",
                                      elem_w);
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                int rhs_w = b->f->vregs[rhs_v].width;
                if (rhs_w != elem_w) {
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int16_t)elem_w;
                    OpKind cv = (rhs_w > elem_w)
                        ? IR_CONV_TRUNC
                        : (n->right->type && n->right->type->isunsigned
                           ? IR_CONV_ZX : IR_CONV_SX);
                    Op *op = ir_op_emit(cur_bb(b), cv);
                    op->dst = tmp; op->src[0] = rhs_v;
                    rhs_v = tmp;
                }
                int addr = new_temp(b, 2);
                Op *lea = ir_op_emit(cur_bb(b), IR_LEA);
                lea->dst = addr; lea->src[0] = dst_v;
                Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
                st->src[0]   = rhs_v;
                st->mem.kind = IR_MEM_VREG;
                st->mem.base = addr;
                st->mem.elem = elem_k;
                return rhs_v;
            }
            /* Byte (width-1) local: build the RHS at its natural
               (int-promoted) width and TRUNC into the byte slot. Hinting
               dst_v would let a wider producer (binop / deref / cast)
               write its 2-byte result straight into the 1-byte slot and
               overrun the adjacent local — `c ^= *p` (char c) wrote HL
               (2 bytes) into c's 1-byte slot, clobbering the next local.
               This is BUG_LOG A33's overrun class, the store-side dual of
               the byte paths already in gen_ld_imm / gen_ld_mem. */
            int ldst_w = b->f->vregs[dst_v].width;
            if (ldst_w == 1) {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                if (b->f->vregs[rhs_v].width == 1) {
                    ir_emit_mov(cur_bb(b), dst_v, rhs_v);
                } else {
                    Op *op = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                    op->dst = dst_v; op->src[0] = rhs_v;
                }
                return dst_v;
            }
            /* Pass dst_v as hint: the RHS writes into it directly when
               it can (skipping the MOV), else returns another vreg we
               copy. The hint vreg's kind also drives literal-to-_Accum
               scaling in the AST_LITERAL handler. */
            int rhs_v = build_expr_hinted(b, n->right, dst_v);
            if (rhs_v < 0) return -1;
            if (rhs_v != dst_v)
                ir_emit_mov(cur_bb(b), dst_v, rhs_v);
            return dst_v;
        }
        /* Non-local LHS: for a float-literal RHS heading into an
           _Accum slot, allocate a typed hint vreg so the literal
           handler's scaling fires. */
        int rhs_hint = -1;
        if (dst_accum != KIND_NONE
            && n->right && n->right->ast_type == AST_LITERAL) {
            int w = (dst_accum == KIND_ACCUM32) ? 4 : 2;
            rhs_hint = new_temp(b, w);
            b->f->vregs[rhs_hint].width = (int16_t)w;
            b->f->vregs[rhs_hint].kind  = dst_accum;
        }
        int rhs_v = (rhs_hint >= 0)
                  ? build_expr_hinted(b, n->right, rhs_hint)
                  : build_expr(b, n->right);
        if (rhs_v < 0) return -1;
        if (n->left->ast_type == AST_GLOBAL_VAR) {
            /* Store width comes from the GLOBAL's type, not the RHS
               vreg: gen_st_mem keys the store size off src width, so
               an int-width RHS into a byte global emits `ld (_g),hl`
               and clobbers the adjacent byte (the parser also folds
               `g[0] = X` into this bare-global shape). Converge the
               RHS to the element width first, mirroring the local
               aggregate path above. */
            Kind gk = n->left->sym ? (Kind)n->left->sym->type : KIND_NONE;
            int elem_w;
            if (n->type && is_supported_int_kind(n->type->kind)) {
                /* OP_ASSIGN's own type IS the stored value type —
                   and the only reliable source when the parser folds
                   `g.member = X` / `g_arr[0] = X` to a bare-global
                   assign: a STRUCT sym's ctype->ptr is NOT the member
                   type (q4: g.i[0] = long stored 16 bits via that
                   path). */
                elem_w = type_width(n->type);
            } else if (gk == KIND_ARRAY || gk == KIND_STRUCT) {
                Type *elem_t = n->left->sym->ctype
                             ? n->left->sym->ctype->ptr : NULL;
                elem_w = type_width(elem_t);
            } else {
                int w = width_for_kind(gk);
                elem_w = w ? w : 2;
            }
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("OP_ASSIGN global elem width %d",
                                  elem_w);
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != elem_w) {
                int tmp = new_temp(b, elem_w);
                b->f->vregs[tmp].width = (int16_t)elem_w;
                OpKind cv = (rhs_w > elem_w)
                    ? IR_CONV_TRUNC
                    : (n->right->type && n->right->type->isunsigned
                       ? IR_CONV_ZX : IR_CONV_SX);
                Op *op = ir_op_emit(cur_bb(b), cv);
                op->dst = tmp; op->src[0] = rhs_v;
                rhs_v = tmp;
            }
            Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
            op->src[0]   = rhs_v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->left->sym;
            op->mem.elem = (elem_w == 1) ? KIND_CHAR
                         : (elem_w == 2) ? KIND_INT : KIND_LONG;
            return rhs_v;
        }
        if (n->left->ast_type == OP_DEREF && n->left->operand) {
            /* Indirect store `*p = X`: walk p to a vreg holding the
               address, emit IR_ST_MEM via IR_MEM_VREG, element width
               from the LHS deref's result type.

               Special case: a bare AST_LOCAL_VAR pointer operand
               (`*q = X`, q a pointer local). build_expr would bail
               "bare AST_LOCAL_VAR outside lvalue context", but here we
               want the local's *value* (the pointer), which its vreg
               already holds. Shortcut to the vreg map. */
            int ptr_v;
            if (n->left->operand->ast_type == AST_LOCAL_VAR) {
                ptr_v = sym_map_get(b, n->left->operand->sym);
                if (ptr_v < 0)
                    return build_fail("OP_ASSIGN deref-of-local "
                                      "unmapped %s",
                                      n->left->operand->sym
                                          ? n->left->operand->sym->name
                                          : "?");
            } else {
                ptr_v = build_expr(b, n->left->operand);
                if (ptr_v < 0) return -1;
            }
            /* Element width: prefer n->type (the OP_ASSIGN's own type
               = stored value type, most reliable). Fall back to
               n->left->type->ptr (OP_DEREF lvalue convention), then
               n->left->type itself (parser's scalar-folded shape).
               Deriving elem_w purely from n->left silently truncated
               long stores to int for the chained-assign / member-store
               shape, where the parser records the scalar value type. */
            int elem_w = 0;
            if (n->type && is_supported_int_kind(n->type->kind))
                elem_w = type_width(n->type);
            if (elem_w == 0 && n->left->type
                && n->left->type->kind == KIND_PTR
                && n->left->type->ptr)
                elem_w = type_width(n->left->type->ptr);
            if (elem_w == 0)
                elem_w = type_width(n->left->type);
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("OP_ASSIGN via deref elem width %d "
                                  "not yet supported", elem_w);
            /* Match rhs width to the store's element width (TRUNC or
               ZX/SX). The lowerer's IR_ST_MEM dispatches on src vreg
               width — a mismatch emits a wrong-sized store (e.g. a
               4-byte source writing only 2 bytes for a long deref). */
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != elem_w) {
                if (rhs_w > elem_w) {
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int16_t)elem_w;
                    Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                    cv->dst    = tmp;
                    cv->src[0] = rhs_v;
                    rhs_v = tmp;
                } else {
                    /* Widen. Sign-extend if the rhs's type is signed,
                       zero-extend otherwise. Default to zero-extend
                       when type info is missing (safer for pointers). */
                    int unsigned_src = !n->right->type ||
                                       n->right->type->isunsigned;
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int16_t)elem_w;
                    Op *cv = ir_op_emit(cur_bb(b),
                                        unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
                    cv->dst    = tmp;
                    cv->src[0] = rhs_v;
                    rhs_v = tmp;
                }
            }
            Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
            op->src[0]   = rhs_v;
            op->mem.kind = IR_MEM_VREG;
            op->mem.base = ptr_v;
            op->mem.elem = (elem_w == 1) ? KIND_CHAR
                         : (elem_w == 2) ? KIND_INT
                         :                 KIND_LONG;
            return rhs_v;
        }
        /* Address-yielding LHS (#342 / #343): the parser folds
           `*(p + K)`, array subscripts (`arr[i] = K`, `global_arr[N]
           = K`), and chained assigns into a bare expression in lvalue
           context. n->left is an OP_ADD / OP_SUB / etc. yielding an
           address. The type kind on n->left varies:
             - KIND_PTR  (`p[K]` for pointer p)        → use ->ptr
             - KIND_ARRAY (`arr[K]` for an array local) → use ->ptr
             - element scalar kind (KIND_INT/LONG/CHAR) — the parser
               sometimes records the value type on a folded address
               node, losing the "pointer to". Treat n->left->type
               itself as the element type.
           KIND_ARRAY long-element stores (`in[i] = long`) are gated
           off in sp mode only. With byte-pack + pointer-spill-skip +
           offset folds + the stack-free long store + post-step
           fusion, ungated md5 BEATS the walker mix in fp mode
           (36.55M vs 36.84M) — so fp ungates. sp still trails
           (38.51M vs 37.14M, +3.7%): the remaining sp residue is
           the per-input-byte copy loop's slot walks. sp stays gated
           until that flips too. */
        if (n->left->type
            && ((n->left->type->kind == KIND_PTR
                 || n->left->type->kind == KIND_ARRAY)
                || is_supported_int_kind(n->left->type->kind))
            && (n->left->type->ptr
                || is_supported_int_kind(n->left->type->kind))) {
            int ptr_v = build_expr(b, n->left);
            if (ptr_v < 0) return -1;
            /* Prefer n->type (OP_ASSIGN's own type = stored value
               type) over n->left->type->ptr — same as the OP_DEREF-LHS
               #344 fix. For chained assigns the inner OP_ASSIGN's
               RHS-value type IS the store width; the LHS pointer type
               can mislead. */
            int elem_w = 0;
            if (n->type && is_supported_int_kind(n->type->kind))
                elem_w = type_width(n->type);
            if (elem_w == 0 && n->left->type->ptr)
                elem_w = type_width(n->left->type->ptr);
            if (elem_w == 0 && is_supported_int_kind(n->left->type->kind))
                elem_w = type_width(n->left->type);
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("OP_ASSIGN ptr-LHS elem width %d "
                                  "not yet supported", elem_w);
            /* Match rhs vreg width to elem_w (same logic as the
               OP_DEREF LHS path — widen via ZX/SX or truncate). */
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != elem_w) {
                if (rhs_w > elem_w) {
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int16_t)elem_w;
                    Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                    cv->dst    = tmp;
                    cv->src[0] = rhs_v;
                    rhs_v = tmp;
                } else {
                    int unsigned_src = !n->right->type ||
                                       n->right->type->isunsigned;
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int16_t)elem_w;
                    Op *cv = ir_op_emit(cur_bb(b),
                                        unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
                    cv->dst    = tmp;
                    cv->src[0] = rhs_v;
                    rhs_v = tmp;
                }
            }
            Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
            op->src[0]   = rhs_v;
            op->mem.kind = IR_MEM_VREG;
            op->mem.base = ptr_v;
            op->mem.elem = (elem_w == 1) ? KIND_CHAR
                         : (elem_w == 2) ? KIND_INT
                         :                 KIND_LONG;
            return rhs_v;
        }
        ptr_lhs_skip:
        return build_fail("OP_ASSIGN LHS shape not yet supported");
    }

    case AST_PRESERVE_BC:
        /* Expression context: passthrough — our IR doesn't pin to BC.
           Same rationale as the statement-context handler. */
        return n->operand ? build_expr(b, n->operand) : -1;

    case OP_MOD:
    case OP_MULT:
    case OP_DIV: {
        Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
        Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
        int is_fix16 = (lk == KIND_ACCUM16 || rk == KIND_ACCUM16);
        int is_fix32 = (lk == KIND_ACCUM32 || rk == KIND_ACCUM32);
        if ((is_fix16 || is_fix32) && n->ast_type == OP_MOD)
            return build_fail("OP_MOD on _Accum not defined");
        int l = build_expr(b, n->left);
        if (l < 0) return -1;
        int r = build_expr(b, n->right);
        if (r < 0) return -1;
        int width = b->f->vregs[l].width;
        if (b->f->vregs[r].width > width) width = b->f->vregs[r].width;
        /* Converge mixed-width operands to the helper width BEFORE
           the HCALL: gen_hcall marshals each arg by its vreg width,
           so a narrower operand hands the helper a garbage high half
           (`(UINT4)K * (i+1)` fed l_long_mult_u a 16-bit i+1 — junk
           above bit 15; sp hung, fp returned wrong products). Each
           operand widens by its OWN signedness (C value-preserving
           promotion). */
        if (b->f->vregs[l].width != width) {
            int uns = n->left && n->left->type
                   && n->left->type->isunsigned;
            int tmp = new_temp(b, width);
            b->f->vregs[tmp].width = (int16_t)width;
            Op *cv = ir_op_emit(cur_bb(b),
                                uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = tmp; cv->src[0] = l;
            l = tmp;
        }
        if (b->f->vregs[r].width != width) {
            int uns = n->right && n->right->type
                   && n->right->type->isunsigned;
            int tmp = new_temp(b, width);
            b->f->vregs[tmp].width = (int16_t)width;
            Op *cv = ir_op_emit(cur_bb(b),
                                uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = tmp; cv->src[0] = r;
            r = tmp;
        }
        /* C arithmetic conversion: result is unsigned if either
           operand is unsigned. */
        int unsigned_op = (n->type && n->type->isunsigned)
            || (n->left  && n->left->type  && n->left->type->isunsigned)
            || (n->right && n->right->type && n->right->type->isunsigned);
        const char *helper;
        int n_stacked = 0;
        int ret_in_de = 0;
        int *args = calloc(2, sizeof(int));
        if (is_fix16) {
            /* l_fix16_{muls,mulu,divs,divu}: hl = rhs, stack = lhs;
               result in hl, helper pops the pushed lhs itself. */
            helper = (n->ast_type == OP_MULT)
                ? (unsigned_op ? "l_fix16_mulu" : "l_fix16_muls")
                : (unsigned_op ? "l_fix16_divu" : "l_fix16_divs");
            args[0] = l; args[1] = r; n_stacked = 1;
        } else if (is_fix32) {
            /* l_fix32_{muls,mulu,divs,divu}: same shape as l_long_*
               (DEHL=RHS, stack=LHS, result DEHL). Helpers not in
               libsrc yet — walker references them too. */
            helper = (n->ast_type == OP_MULT)
                ? (unsigned_op ? "l_fix32_mulu" : "l_fix32_muls")
                : (unsigned_op ? "l_fix32_divu" : "l_fix32_divs");
            args[0] = l; args[1] = r; n_stacked = 1;
        } else if (width == 4) {
            /* l_long_{mult,mult_u,div,div_u,mod,mod_u}: dehl = arg1,
               stack = arg2 (4 bytes), result in DEHL, helper pops. */
            if (n->ast_type == OP_MULT)
                helper = unsigned_op ? "l_long_mult_u" : "l_long_mult";
            else if (n->ast_type == OP_DIV)
                helper = unsigned_op ? "l_long_div_u" : "l_long_div";
            else
                helper = unsigned_op ? "l_long_mod_u" : "l_long_mod";
            /* For long: helper's dehl = RHS, stack = LHS. */
            args[0] = l;            /* pushed */
            args[1] = r;            /* DEHL */
            n_stacked = 1;
        } else if (n->ast_type == OP_MULT) {
            helper = "l_mult";
            args[0] = l; args[1] = r;
        } else {
            /* l_div / l_div_u: hl = de/hl (quot in HL, rem in DE). */
            helper = unsigned_op ? "l_div_u" : "l_div";
            args[0] = r;            /* RHS → HL (primary) */
            args[1] = l;            /* LHS → DE (secondary) */
            if (n->ast_type == OP_MOD) ret_in_de = 1;
        }
        int dst = new_temp(b, width);
        b->f->vregs[dst].width = (int16_t)width;
        Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
        op->dst = dst;
        HelperInfo *hi = calloc(1, sizeof(HelperInfo));
        hi->name      = helper;
        hi->args      = args;
        hi->n_args    = 2;
        hi->n_stacked = n_stacked;
        hi->ret_vreg  = dst;
        hi->ret_in_de = ret_in_de;
        op->hcall = hi;
        return dst;
    }

    case OP_NEG: {
        if (!n->operand) return build_fail("OP_NEG with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        int width = b->f->vregs[v].width;
        int dst = ALLOC_DST(width);
        b->f->vregs[dst].width = (int16_t)width;
        ir_emit_unop(cur_bb(b), IR_NEG, dst, v);
        return dst;
    }

    case OP_COMP: {
        /* ~x — bitwise complement. */
        if (!n->operand) return build_fail("OP_COMP with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        int width = b->f->vregs[v].width;
        int dst = ALLOC_DST(width);
        b->f->vregs[dst].width = (int16_t)width;
        ir_emit_unop(cur_bb(b), IR_NOT, dst, v);
        return dst;
    }

    case OP_LNEG: {
        /* !x logical not, materialised as `x == 0`. Long form
           uses the IR_CMP_EQ const-RHS fold (lowerer's byte-wise
           XOR-OR chain); int form goes through a fresh 0 vreg. */
        if (!n->operand) return build_fail("OP_LNEG with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        int dst = new_temp(b, 2);
        b->f->vregs[dst].width = 2;
        if (b->f->vregs[v].width == 4) {
            Op *op = ir_op_emit(cur_bb(b), IR_CMP_EQ);
            op->dst = dst; op->src[0] = v; op->src[1] = -1; op->imm = 0;
            return dst;
        }
        int zero_v = new_temp(b, 2);
        ir_emit_ld_imm(cur_bb(b), zero_v, 0);
        ir_emit_binop(cur_bb(b), IR_CMP_EQ, dst, v, zero_v);
        return dst;
    }

    case AST_FUNC_CALL: {
        /* Direct call only (sym set, callee NULL). All args are walked
           to int-width vregs. Result lands in a new int vreg via
           IR_CALL's ret_vreg. Int-class args + return only; variadic /
           fastcall / fnptr-call all deferred. */
        if (!n->sym)
            return build_fail("AST_FUNC_CALL without sym (fnptr deferred)");
        int is_fastcall = (n->sym->ctype
                           && (n->sym->ctype->flags & FASTCALL));
        int n_args = n->args ? (int)array_len(n->args) : 0;
        /* Inline a const-count __builtin_memset as IR_MEMSET — the whole
           point of the builtin is to inline when the count is const, no
           call. The lowerer unrolls `ld (hl),e; inc hl` for small counts
           and uses an overlapping-`ldir` fill for larger ones. Any const
           count (1..65536, ldir's BC limit) inlines; non-const falls
           through to the library memset (redirected below). */
        if (n->sym->name && strcmp(n->sym->name, "__builtin_memset") == 0
            && n_args == 3) {
            Node *cnt = array_get_byindex(n->args, 2);
            if (cnt && cnt->ast_type == AST_LITERAL
                && cnt->zval > 0 && cnt->zval <= 65536
                && (cnt->zval <= 8 || ir_inline_block_ops_ok())) {
                int dst_v = build_expr(b, array_get_byindex(n->args, 0));
                if (dst_v < 0) return -1;
                int c_v = build_expr(b, array_get_byindex(n->args, 1));
                if (c_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_MEMSET);
                op->dst    = -1;
                op->src[0] = dst_v;          /* dst pointer */
                op->src[1] = c_v;            /* fill byte value */
                op->imm    = (int)cnt->zval; /* byte count */
                /* memset returns dst; the dst vreg still holds it. */
                return dst_v;
            }
        }
        /* Inline a const-count __builtin_memcpy as IR_MEMCPY — same idea:
           tiny counts unroll, larger ones use `ldir`, any const count
           (1..65536) inlines; non-const falls back to the library
           memcpy. memcpy returns dst (the dst vreg still holds it). */
        if (n->sym->name && strcmp(n->sym->name, "__builtin_memcpy") == 0
            && n_args == 3) {
            Node *cnt = array_get_byindex(n->args, 2);
            if (cnt && cnt->ast_type == AST_LITERAL
                && cnt->zval > 0 && cnt->zval <= 65536
                && (cnt->zval <= 3 || ir_inline_block_ops_ok())) {
                int dst_v = build_expr(b, array_get_byindex(n->args, 0));
                if (dst_v < 0) return -1;
                int src_v = build_expr(b, array_get_byindex(n->args, 1));
                if (src_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_MEMCPY);
                op->dst    = -1;
                op->src[0] = dst_v;          /* dst pointer */
                op->src[1] = src_v;          /* src pointer */
                op->imm    = (int)cnt->zval; /* byte count */
                return dst_v;
            }
        }
        /* Inline __builtin_strcpy (always — variable length, no const
           needed): IR_STRCPY (dst, src), lowered to a NUL-terminated
           copy loop. strcpy returns dst. */
        if (n->sym->name && strcmp(n->sym->name, "__builtin_strcpy") == 0
            && n_args == 2 && ir_inline_block_ops_ok()) {
            int dst_v = build_expr(b, array_get_byindex(n->args, 0));
            if (dst_v < 0) return -1;
            int src_v = build_expr(b, array_get_byindex(n->args, 1));
            if (src_v < 0) return -1;
            Op *op = ir_op_emit(cur_bb(b), IR_STRCPY);
            op->dst    = -1;
            op->src[0] = dst_v;          /* dst pointer */
            op->src[1] = src_v;          /* src pointer */
            return dst_v;
        }
        /* Inline __builtin_strchr: IR_STRCHR (result = dst), src[0] =
           string, src[1] = char vreg (or -1 + imm for a literal char),
           lowered to a scan loop leaving the match pointer / NULL in the
           result vreg. */
        if (n->sym->name && strcmp(n->sym->name, "__builtin_strchr") == 0
            && n_args == 2 && ir_inline_block_ops_ok()) {
            Node *c_node = array_get_byindex(n->args, 1);
            int str_v = build_expr(b, array_get_byindex(n->args, 0));
            if (str_v < 0) return -1;
            int dst = new_temp(b, 2);
            b->f->vregs[dst].width = 2;
            Op *op = ir_op_emit(cur_bb(b), IR_STRCHR);
            op->dst    = dst;
            op->src[0] = str_v;          /* string pointer */
            if (c_node && c_node->ast_type == AST_LITERAL) {
                op->src[1] = -1;
                op->imm    = (int)c_node->zval;   /* literal search char */
            } else {
                int c_v = build_expr(b, c_node);
                if (c_v < 0) return -1;
                op->src[1] = c_v;        /* search char value */
            }
            return dst;
        }
        /* R→L build/push order ONLY for plain stdc — CALLEE pushes
           L→R like SMALLC (must mirror gen_call's push_step). */
        uint32_t fl = n->sym->ctype ? n->sym->ctype->flags : 0;
        int is_stdc = !is_fastcall && !(fl & SMALLC) && !(fl & CALLEE);
        int *args = NULL;
        int pre_pushed = 0;
        if (n_args > 0) {
            args = calloc(n_args, sizeof(int));
            /* Push-at-producer: build args in PUSH order (smallc /
               callee: left-to-right; stdc: right-to-left; fastcall:
               first n-1 pushed, last arg built last for the HL load)
               and emit IR_PUSH_ARG right after each producer. The
               value is consumed at the very next op, so the dead-
               spill analysis keeps these temps in HL/DEHL — no slot,
               no store. Constraints: pushes must stay in ONE BB
               (cur_sp_adjust resets at BB boundaries) and widths must
               be 2 or 4 (byte args use the slot-load promote path).
               Any violation rolls ALL pushes back to IR_NOP — the
               legacy slot path in gen_call still works off args[]. */
            int n_to_push = is_fastcall ? n_args - 1 : n_args;
            int push_bb   = b->cur_bb_id;
            int pushable  = 1;
            int push_ops[64];
            int n_push_ops = 0;
            for (int k = 0; k < n_args; k++) {
                int i;
                if (is_fastcall)
                    i = k;                    /* 0..n-2 pushed, n-1 last */
                else if (is_stdc)
                    i = n_args - 1 - k;       /* right-to-left */
                else
                    i = k;                    /* left-to-right */
                Node *a = array_get_byindex(n->args, i);
                int v = build_expr(b, a);
                if (v < 0) { free(args); return -1; }
                args[i] = v;
                if (b->cur_bb_id != push_bb) pushable = 0;
                int w = b->f->vregs[v].width;
                int want_push = (k < n_to_push);
                if (want_push && pushable
                    && (w == 2 || w == 4)
                    && n_push_ops < 64) {
                    Op *p = ir_op_emit(cur_bb(b), IR_PUSH_ARG);
                    p->src[0] = v;
                    p->src[1] = -1;
                    /* imm=1 marks the call's FIRST push: if the
                       function keeps a PR_BC tenant, the lowerer
                       saves BC there — BELOW the arg block — and
                       gen_call pops it after the cleanup. */
                    p->imm = (n_push_ops == 0) ? 1 : 0;
                    push_ops[n_push_ops++] = cur_bb(b)->n_ops - 1;
                } else if (want_push) {
                    pushable = 0;
                }
            }
            if (pushable && n_push_ops == n_to_push) {
                pre_pushed = n_to_push;
            } else {
                /* Roll back: NOP the pushes; gen_call loads from
                   slots as before. (All pushes live in push_bb —
                   pushable drops to 0 the moment the BB changes.) */
                BB *pbb = &b->f->bbs[push_bb];
                for (int k = 0; k < n_push_ops; k++)
                    pbb->ops[push_ops[k]].kind = IR_NOP;
                pre_pushed = 0;
            }
        }
        /* Return vreg width from the callee's return type — long
           returns need width 4 so later IR_ST_MEM / IR_MOV operate on
           all four bytes (long-return convention is DEHL). Without it,
           crc32's `g = shr1(x)` truncated to int: the ret vreg was
           hardcoded width 2 and ST_MEM IR_MEM_SYM wrote only HL. */
        int ret_w = 2;
        if (n->sym->ctype && n->sym->ctype->return_type) {
            int w = type_width(n->sym->ctype->return_type);
            if (w > 0) ret_w = w;
        }
        int ret_v = new_temp(b, ret_w);
        Op *op = ir_op_emit(cur_bb(b), IR_CALL);
        op->dst = ret_v;
        CallInfo *ci = calloc(1, sizeof(CallInfo));
        ci->target     = n->sym;
        /* Inline string/mem builtins (__builtin_memset/memcpy/strcpy/
           strchr) have no callable library symbol — the walker inlines
           them (cg2_try_builtin_call). In IR, redirect to the real
           same-name/same-ABI library function, which the smallc lib
           provides; the prefix/ABI come from the (LIBRARY __smallc)
           builtin sym, so only the emitted name changes. */
        if (n->sym->name && strncmp(n->sym->name, "__builtin_", 10) == 0) {
            const char *base = n->sym->name + 10;
            if (!strcmp(base, "memset") || !strcmp(base, "memcpy")
             || !strcmp(base, "strcpy") || !strcmp(base, "strchr"))
                ci->target_name = base;
        }
        ci->fnptr_vreg = -1;
        ci->args       = args;
        ci->n_args     = n_args;
        ci->ret_vreg   = ret_v;
        /* ABI is determined by ctype flags. SMALLC = L→R push (z88dk
           default); absence = STDC = R→L push (matches C standard).
           CALLEE wins regardless: callee pops its own args. FASTCALL
           overrides — last arg goes in HL/DEHL, rest pushed in ABI
           order. */
        uint32_t flags = n->sym->ctype ? n->sym->ctype->flags : 0;
        if (is_fastcall) {
            ci->abi = IR_ABI_FASTCALL;
        } else if (flags & CALLEE) {
            ci->abi = IR_ABI_CALLEE;
        } else if (flags & SMALLC) {
            ci->abi = IR_ABI_SMALLC;
        } else {
            ci->abi = IR_ABI_STDC;
        }
        ci->is_variadic = (n->sym->ctype && n->sym->ctype->funcattrs.hasva)
                          ? 1 : 0;
        ci->pre_pushed  = pre_pushed;
        op->call = ci;
        return ret_v;
    }

    case AST_FUNCPTR_CALL: {
        /* Indirect call through a function pointer (`(*fp)(args)` or
           `fp(args)`). Same arg shape as AST_FUNC_CALL but the target
           is computed at runtime from `n->callee`. Fastcall fnptrs
           are deferred (legacy walker handles the zpush/ex(sp),hl
           gymnastics that keep the fnptr addressable while args are
           evaluated). */
        if (!n->callee)
            return build_fail("AST_FUNCPTR_CALL without callee");
        Type *fntype = n->type; /* callfunction() stashes the FUNC
                                   type on the call node */
        uint32_t flags = fntype ? fntype->flags : 0;
        if (flags & FASTCALL)
            return build_fail("AST_FUNCPTR_CALL fastcall deferred");
        int n_args = n->args ? (int)array_len(n->args) : 0;
        int *args = NULL;
        if (n_args > 0) {
            args = calloc(n_args, sizeof(int));
            for (int i = 0; i < n_args; i++) {
                Node *a = array_get_byindex(n->args, i);
                int v = build_expr(b, a);
                if (v < 0) { free(args); return -1; }
                args[i] = v;
            }
        }
        /* Compute the callee address last so the vreg holding it is
           still live at call-emit time (it'll get loaded into HL). */
        int fnptr_v = build_expr(b, n->callee);
        if (fnptr_v < 0) { free(args); return -1; }
        int ret_w = 2;
        if (fntype && fntype->return_type) {
            int w = type_width(fntype->return_type);
            if (w > 0) ret_w = w;
        }
        int ret_v = new_temp(b, ret_w);
        Op *op = ir_op_emit(cur_bb(b), IR_CALL);
        op->dst = ret_v;
        CallInfo *ci = calloc(1, sizeof(CallInfo));
        ci->target     = NULL;       /* indirect */
        ci->fnptr_vreg = fnptr_v;
        ci->args       = args;
        ci->n_args     = n_args;
        ci->ret_vreg   = ret_v;
        if (flags & CALLEE)        ci->abi = IR_ABI_CALLEE;
        else if (flags & SMALLC)   ci->abi = IR_ABI_SMALLC;
        else                       ci->abi = IR_ABI_STDC;
        ci->is_variadic = (fntype && fntype->funcattrs.hasva) ? 1 : 0;
        op->call = ci;
        return ret_v;
    }

    case OP_CAST: {
        /* (cast T expr): convert expr's width to T's width. Operand
           width comes from operand->type; dst width from node->type. */
        if (!n->operand)
            return build_fail("OP_CAST without operand");
        int src_w = type_width(n->operand->type);
        int dst_w = type_width(n->type);
        /* (cast long *p++) fastpath: recognise the
              OP_CAST(long, OP_DEREF(OP_DEREF(POST/PRE_INC/DEC(LV=p))))
           shape and emit a single fused IR_LD_MEM that loads the byte,
           steps the pointer, and zero-extends to long — bypassing the
           default 3-op IR sequence (IR_LD_MEM byte + IR_INC p +
           IR_CONV_ZX byte→long) which forces a byte spill across the
           IR_INC. Hot inner pattern in crcbench's crc32 (per-byte
           loop). */
        if (dst_w == 4 && src_w == 1
            && n->operand
            && n->operand->ast_type == OP_DEREF
            && n->operand->operand
            && n->operand->operand->ast_type == OP_DEREF
            && n->operand->operand->operand
            && (n->operand->operand->operand->ast_type == OP_POST_INC ||
                n->operand->operand->operand->ast_type == OP_PRE_INC  ||
                n->operand->operand->operand->ast_type == OP_POST_DEC ||
                n->operand->operand->operand->ast_type == OP_PRE_DEC)
            && n->operand->operand->operand->operand
            && n->operand->operand->operand->operand->ast_type
                   == AST_LOCAL_VAR) {
            Node *step = n->operand->operand->operand;
            SYMBOL *lsym = step->operand->sym;
            int p_vreg = sym_map_get(b, lsym);
            if (p_vreg >= 0) {
                int is_inc = (step->ast_type == OP_POST_INC
                           || step->ast_type == OP_PRE_INC);
                /* Only POST_* matches the canonical fastpath shape;
                   PRE_* would need the step before the load. Skip
                   PRE_* for now — falls through to the generic path. */
                if (step->ast_type == OP_POST_INC
                    || step->ast_type == OP_POST_DEC) {
                    int dst = new_temp(b, 4);
                    b->f->vregs[dst].width = 4;
                    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
                    ld->dst       = dst;
                    ld->mem.kind  = IR_MEM_VREG;
                    ld->mem.base  = p_vreg;
                    ld->mem.elem  = KIND_CHAR;
                    ld->mem.post_step = is_inc ? 1 : -1;
                    return dst;
                }
            }
        }
        Kind src_k = n->operand->type ? n->operand->type->kind : KIND_NONE;
        Kind dst_k = n->type ? n->type->kind : KIND_NONE;
        /* Literal → _Accum: fold the Q-format scaling into the
           IR_LD_IMM at IR-build time. Bypasses the build_expr
           dance — same value goes straight to the right vreg. */
        if (n->operand->ast_type == AST_LITERAL
            && (dst_k == KIND_ACCUM16 || dst_k == KIND_ACCUM32)) {
            int w = (dst_k == KIND_ACCUM32) ? 4 : 2;
            int v = new_temp(b, w);
            b->f->vregs[v].width = (int16_t)w;
            b->f->vregs[v].kind  = dst_k;
            ir_emit_ld_imm(cur_bb(b), v,
                           scale_literal_for_kind(n->operand, dst_k));
            return v;
        }
        int src_v = build_expr(b, n->operand);
        if (src_v < 0) return -1;
        /* integer → _Accum: l_fix16_{s,u}{char,int,long}2f or
           l_fix32_{s,u}{int,long}2f. Source goes through HL (the
           fix16 helpers operate on HL only, so width-4 sources are
           pre-truncated); the fix32 helpers expect HL on entry and
           produce DEHL on exit. */
        if (!kind_is_decimal(src_k)
            && (dst_k == KIND_ACCUM16 || dst_k == KIND_ACCUM32)) {
            if (b->f->vregs[src_v].width == 4) {
                int tmp = new_temp(b, 2);
                b->f->vregs[tmp].width = 2;
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = tmp; tr->src[0] = src_v;
                src_v = tmp;
            }
            int src_unsigned = n->operand->type
                            && n->operand->type->isunsigned;
            const char *helper;
            int conv_w;
            if (dst_k == KIND_ACCUM32) {
                helper = src_unsigned ? "l_fix32_uint2f"
                                      : "l_fix32_sint2f";
                conv_w = 4;
            } else {
                helper = src_unsigned ? "l_fix16_uint2f"
                                      : "l_fix16_sint2f";
                conv_w = 2;
            }
            int conv_v = new_temp(b, conv_w);
            b->f->vregs[conv_v].width = (int16_t)conv_w;
            b->f->vregs[conv_v].kind  = dst_k;
            int *args = calloc(1, sizeof(int));
            args[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = conv_v;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name     = helper;
            hi->args     = args;
            hi->n_args   = 1;
            hi->ret_vreg = conv_v;
            op->hcall = hi;
            return conv_v;
        }
        /* _Accum → integer: l_fix16_f2{s,u}{int,long} preserves
           signed semantics for negative values (arithmetic shift +
           sign-extend). Helper overhead is acceptable — _Accum is
           not a hot type. */
        if (src_k == KIND_ACCUM16 && !kind_is_decimal(dst_k)) {
            int dst_unsigned = n->type && n->type->isunsigned;
            int helper_ret_w = (dst_w == 4) ? 4 : 2;
            const char *helper;
            if (helper_ret_w == 4)
                helper = dst_unsigned ? "l_fix16_f2ulong"
                                       : "l_fix16_f2slong";
            else
                helper = dst_unsigned ? "l_fix16_f2uint"
                                       : "l_fix16_f2sint";
            int conv_v = new_temp(b, helper_ret_w);
            b->f->vregs[conv_v].width = (int16_t)helper_ret_w;
            int *args = calloc(1, sizeof(int));
            args[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = conv_v;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name     = helper;
            hi->args     = args;
            hi->n_args   = 1;
            hi->ret_vreg = conv_v;
            op->hcall = hi;
            src_v = conv_v;
            if (helper_ret_w == dst_w) return src_v;
            /* Fall through (e.g. _Accum → char: helper gave int,
               TRUNC below narrows to byte). */
        } else if (src_k == KIND_ACCUM32 && !kind_is_decimal(dst_k)) {
            /* long _Accum → integer via l_fix32_f2{s,u}{int,long}.
               DEHL in, HL or DEHL out depending on dst width.
               Helpers don't exist in libsrc yet — walker references
               them too. */
            int dst_unsigned = n->type && n->type->isunsigned;
            int helper_ret_w = (dst_w == 4) ? 4 : 2;
            const char *helper;
            if (helper_ret_w == 4)
                helper = dst_unsigned ? "l_fix32_f2ulong"
                                       : "l_fix32_f2slong";
            else
                helper = dst_unsigned ? "l_fix32_f2uint"
                                       : "l_fix32_f2sint";
            int conv_v = new_temp(b, helper_ret_w);
            b->f->vregs[conv_v].width = (int16_t)helper_ret_w;
            int *args = calloc(1, sizeof(int));
            args[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = conv_v;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name     = helper;
            hi->args     = args;
            hi->n_args   = 1;
            hi->ret_vreg = conv_v;
            op->hcall = hi;
            src_v = conv_v;
            if (helper_ret_w == dst_w) return src_v;
        }
        if (src_w == dst_w) {
            /* Same-width (e.g. signed↔unsigned int) — no codegen. */
            return src_v;
        }
        if (src_w == 1 && (dst_w == 2 || dst_w == 4)) {
            /* Char → int / long widening. Zero-extend if source is
               unsigned char, sign-extend otherwise. C's default `char`
               signedness is implementation-defined; treat as signed
               unless the operand's type explicitly carries isunsigned. */
            int unsigned_src = n->operand->type &&
                               n->operand->type->isunsigned;
            int dst = new_temp(b, dst_w);
            b->f->vregs[dst].width = (int16_t)dst_w;
            Op *op = ir_op_emit(cur_bb(b),
                                unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
            op->dst    = dst;
            op->src[0] = src_v;
            return dst;
        }
        if (src_w == 2 && dst_w == 4) {
            /* Int → long widening. */
            int unsigned_src = n->operand->type &&
                               n->operand->type->isunsigned;
            int dst = new_temp(b, 4);
            b->f->vregs[dst].width = 4;
            Op *op = ir_op_emit(cur_bb(b),
                                unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
            op->dst    = dst;
            op->src[0] = src_v;
            return dst;
        }
        if (src_w == 2 && dst_w == 1) {
            int dst = new_temp(b, 1);
            b->f->vregs[dst].width = 1;
            Op *op = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
            op->dst    = dst;
            op->src[0] = src_v;
            return dst;
        }
        if (src_w == 4 && (dst_w == 2 || dst_w == 1)) {
            /* Long → int / char truncation: take the low half (HL of
               DEHL), then narrow to byte if needed via another TRUNC. */
            int dst = new_temp(b, dst_w);
            b->f->vregs[dst].width = (int16_t)dst_w;
            Op *op = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
            op->dst    = dst;
            op->src[0] = src_v;
            return dst;
        }
        return build_fail("OP_CAST %d→%d not yet supported", src_w, dst_w);
    }

    case OP_PRE_INC: case OP_POST_INC:
    case OP_PRE_DEC: case OP_POST_DEC: {
        /* Step on a lvalue: increment / decrement by 1, returning
           either the new value (PRE) or the old (POST). */
        if (!n->operand)
            return build_fail("post/pre step with NULL operand");
        int is_inc = (n->ast_type == OP_PRE_INC ||
                      n->ast_type == OP_POST_INC);
        int is_post = (n->ast_type == OP_POST_INC ||
                       n->ast_type == OP_POST_DEC);

        /* Bare local fastpath: 16-bit slot, IR_INC/IR_DEC aliased
           write to the same vreg. A POINTER local steps by sizeof(the
           pointee), not 1 — `++p` on `struct S *p` must add sizeof(S),
           not 1 (the regex `++test` over a 6-byte struct array read
           garbage when it advanced one byte). char* keeps stride 1
           (IR_INC), which is why byte-pointer `*data++` was unaffected. */
        if (n->operand->ast_type == AST_LOCAL_VAR) {
            SYMBOL *lsym = n->operand->sym;
            int v = sym_map_get(b, lsym);
            if (v < 0)
                return build_fail("step on unknown local %s",
                                  lsym ? lsym->name : "?");
            int stride = 1;
            Kind lk = lsym ? (Kind)lsym->type : KIND_NONE;
            if (lk == KIND_PTR || lk == KIND_CPTR) {
                Type *pte = (lsym->ctype) ? lsym->ctype->ptr : NULL;
                /* sizeof(pointee): struct/array carry the real byte size
                   in ->size; scalars come from type_width (type_width
                   returns 2 for aggregates, so it can't be used alone). */
                stride = !pte ? 0
                       : (pte->kind == KIND_STRUCT || pte->kind == KIND_ARRAY)
                         ? (int)pte->size : type_width(pte);
                if (stride <= 0)
                    return build_fail("step on pointer to incomplete/"
                                      "unknown type (sym=%s)",
                                      lsym ? lsym->name : "?");
            }
            #define EMIT_STEP_LOCAL() do { \
                if (stride == 1) { \
                    ir_emit_unop(cur_bb(b), is_inc ? IR_INC : IR_DEC, v, v); \
                } else { \
                    Op *sop = ir_op_emit(cur_bb(b), is_inc ? IR_ADD : IR_SUB); \
                    sop->dst = v; sop->src[0] = v; sop->src[1] = -1; \
                    sop->imm = stride; \
                } \
            } while (0)
            if (is_post) {
                int old = new_temp(b, 2);
                ir_emit_mov(cur_bb(b), old, v);
                EMIT_STEP_LOCAL();
                return old;
            }
            EMIT_STEP_LOCAL();
            #undef EMIT_STEP_LOCAL
            return v;
        }

        /* Global var step: load via IR_LD_MEM IR_MEM_SYM, step,
           store back via IR_ST_MEM IR_MEM_SYM. Common shape
           (`gcount++`, ISR counter bumps, etc.). int/long widths
           supported via type_width on n->type. */
        if (n->operand->ast_type == AST_GLOBAL_VAR
            && n->operand->sym) {
            SYMBOL *gsym = n->operand->sym;
            int w = type_width(n->type);
            if (w <= 0) w = 2;
            if (w != 1 && w != 2 && w != 4)
                return build_fail("step on global width %d not supported",
                                  w);
            int old_v = new_temp(b, w);
            b->f->vregs[old_v].width = (int16_t)w;
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst       = old_v;
            ld->mem.kind  = IR_MEM_SYM;
            ld->mem.sym   = gsym;

            int new_v = new_temp(b, w);
            b->f->vregs[new_v].width = (int16_t)w;
            if (w == 1 || w == 2) {
                ir_emit_unop(cur_bb(b), is_inc ? IR_INC : IR_DEC,
                             new_v, old_v);
            } else {
                /* Long step: ADD/SUB with imm=1. */
                Op *bop = ir_op_emit(cur_bb(b),
                                     is_inc ? IR_ADD : IR_SUB);
                bop->dst    = new_v;
                bop->src[0] = old_v;
                bop->src[1] = -1;
                bop->imm    = 1;
                b->f->vregs[new_v].width = (int16_t)w;
            }

            Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
            st->src[0]    = new_v;
            st->mem.kind  = IR_MEM_SYM;
            st->mem.sym   = gsym;

            return is_post ? old_v : new_v;
        }

        /* Non-LV: build address, load, step, store back. Mirrors
           cg2_step's general path. The lvalue's value type is taken
           from n->type (the step's own result type — see #344 for
           why this matters: the parser sometimes records the value
           kind on a folded address sub-tree). */
        Node *addr_node = NULL;
        if (n->operand->ast_type == OP_DEREF && n->operand->operand) {
            addr_node = n->operand->operand;
        } else if (n->operand->ast_type == OP_ADD
                || n->operand->ast_type == OP_SUB) {
            addr_node = n->operand;
        }
        if (!addr_node)
            return build_fail("post/pre step on non-LV not yet "
                              "supported (operand ast=%d)",
                              n->operand->ast_type);

        /* Restrict to plain integer kinds. KIND_PTR would need
           sizeof(pointee) scaling on the step, which this path
           doesn't yet implement — those still bail. */
        if (!n->type
            || (n->type->kind != KIND_CHAR
             && n->type->kind != KIND_INT
             && n->type->kind != KIND_SHORT
             && n->type->kind != KIND_LONG))
            return build_fail("post/pre step on non-LV kind=%d not "
                              "yet supported",
                              n->type ? n->type->kind : -1);
        int elem_w = type_width(n->type);
        if (elem_w != 1 && elem_w != 2 && elem_w != 4)
            return build_fail("post/pre step elem width %d not "
                              "yet supported (non-LV)", elem_w);

        /* Bare AST_LOCAL_VAR pointer operand (`(*q)++`, q a pointer
           local): want the local's *value* (the pointer), which
           sym_map holds directly. Same shortcut as OP_ASSIGN's
           deref-LHS path. */
        int ptr_v;
        if (addr_node->ast_type == AST_LOCAL_VAR) {
            ptr_v = sym_map_get(b, addr_node->sym);
            if (ptr_v < 0)
                return build_fail("post/pre step deref-of-local "
                                  "unmapped %s",
                                  addr_node->sym
                                      ? addr_node->sym->name : "?");
        } else {
            ptr_v = build_expr(b, addr_node);
            if (ptr_v < 0) return -1;
        }

        int old_v = new_temp(b, elem_w);
        b->f->vregs[old_v].width = (int16_t)elem_w;
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst       = old_v;
        ld->mem.kind  = IR_MEM_VREG;
        ld->mem.base  = ptr_v;
        ld->mem.elem  = (elem_w == 1) ? KIND_CHAR
                      : (elem_w == 2) ? KIND_INT : KIND_LONG;

        int new_v = new_temp(b, elem_w);
        b->f->vregs[new_v].width = (int16_t)elem_w;
        if (elem_w == 1 || elem_w == 2) {
            ir_emit_unop(cur_bb(b), is_inc ? IR_INC : IR_DEC,
                         new_v, old_v);
        } else {
            /* Long step: IR_ADD/SUB with imm=1 takes the long
               const-RHS path in the lowerer (no helper call). */
            Op *step = ir_op_emit(cur_bb(b), is_inc ? IR_ADD : IR_SUB);
            step->dst    = new_v;
            step->src[0] = old_v;
            step->src[1] = -1;
            step->imm    = 1;
        }

        Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
        st->src[0]   = new_v;
        st->mem.kind = IR_MEM_VREG;
        st->mem.base = ptr_v;
        st->mem.elem = ld->mem.elem;

        return is_post ? old_v : new_v;
    }

    case AST_ADDR:
    case OP_ADDR:
        /* &x. AST_GLOBAL_VAR operand → IR_LD_SYM. AST_LOCAL_VAR
           operand → IR_LEA on the local's vreg; the source must be
           marked addr-taken so the allocator keeps it in memory.
           &(*x) → x (the parser emits this for array-decay shapes
           like `&(*jp)` where jp is a pointer-to-array). */
        if (n->operand && n->operand->ast_type == OP_DEREF)
            return build_expr(b, n->operand);
        /* &p->member / &arr[i]: the parser folds these to an additive
           address expression — `(addr (+ (deref (lv=p)) K))` etc. The
           operand already computes the address (aggregate locals decay
           via IR_LEA, array/struct globals via IR_LD_SYM), so just
           evaluate it. */
        if (n->operand && (n->operand->ast_type == OP_ADD
                        || n->operand->ast_type == OP_SUB))
            return build_expr(b, n->operand);
        if (n->operand && n->operand->ast_type == AST_GLOBAL_VAR) {
            int dst = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LD_SYM);
            op->dst = dst;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->operand->sym;
            return dst;
        }
        if (n->operand && n->operand->ast_type == AST_LOCAL_VAR) {
            SYMBOL *sym = n->operand->sym;
            int src = sym ? sym_map_get(b, sym) : -1;
            if (src < 0)
                return build_fail("OP_ADDR on unknown local %s",
                                  sym ? sym->name : "?");
            b->f->vregs[src].flags |= IR_VREG_ADDR_TAKEN;
            int dst = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LEA);
            op->dst = dst;
            op->src[0] = src;
            return dst;
        }
        return build_fail("OP_ADDR on non-global/non-local not yet supported");

    case AST_TERNARY: {
        /* Ternary as expression: cond ? then_e : els_e, both arms
           produce values; mov each into a shared result vreg. */
        if (!n->cond || !n->then || !n->els)
            return build_fail("AST_TERNARY expr with missing arm");

        int cond_v = build_expr(b, n->cond);
        if (cond_v < 0) return -1;

        int then_bb = ir_bb_new(b->f);
        int els_bb  = ir_bb_new(b->f);
        int exit_bb = ir_bb_new(b->f);
        /* A hint vreg lets both arms write the value directly — no
           result temp, and the caller skips the wrapping MOV. */
        int result  = ALLOC_DST(2);

        /* current bb: BR_ZERO to els, then explicit BR to then.
           Conditional jumps are not terminators in our IR — the BB
           always ends with an unconditional terminator so fall-through
           doesn't depend on BB array order. ir_emit_br_zero records
           els_bb as a succ; ir_emit_br fills in the second succ slot. */
        ir_emit_br_zero(cur_bb(b), cond_v, els_bb);
        ir_emit_br(cur_bb(b), then_bb);

        b->cur_bb_id = then_bb;
        int t = build_expr_hinted(b, n->then, result);
        if (t < 0) return -1;
        if (t != result) ir_emit_mov(cur_bb(b), result, t);
        ir_emit_br(cur_bb(b), exit_bb);

        b->cur_bb_id = els_bb;
        int e = build_expr_hinted(b, n->els, result);
        if (e < 0) return -1;
        if (e != result) ir_emit_mov(cur_bb(b), result, e);
        ir_emit_br(cur_bb(b), exit_bb);

        b->cur_bb_id = exit_bb;
        return result;
    }

    case OP_AADD: case OP_ASUB:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHL: case OP_ASSHR: {
        /* Compound assign: LHS op= RHS. LHS in the AST is the *rvalue*
           expression — OP_DEREF(AST_LOCAL_VAR) for a local, or
           OP_DEREF(OP_DEREF(AST_LOCAL_VAR p)) for indirection through
           a pointer (`*p op= x` / `p[0] op= x` after fold). */
        OpKind k = (n->ast_type == OP_AADD) ? IR_ADD
                 : (n->ast_type == OP_ASUB) ? IR_SUB
                 : (n->ast_type == OP_AAND) ? IR_AND
                 : (n->ast_type == OP_AOR)  ? IR_OR
                 : (n->ast_type == OP_AXOR) ? IR_XOR
                 : (n->ast_type == OP_ASSHL)? IR_SHL
                 :                            IR_SHR;

        if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
            return build_fail("compound OP_A* LHS shape not yet supported");

        /* Bare local var: `local op= x`. */
        if (n->left->operand->ast_type == AST_LOCAL_VAR) {
            SYMBOL *lsym = n->left->operand->sym;
            int lhs_v = sym_map_get(b, lsym);
            if (lhs_v < 0)
                return build_fail("compound to unknown local %s",
                                  lsym ? lsym->name : "?");
            /* Byte (width-1) local: the binop computes the int-promoted
               result in HL and store_hl writes 2 bytes — into a 1-byte
               slot, overrunning the adjacent local (the `crc ^= *p` /
               `c ^= *d` bug; BUG_LOG A33 class). Compute into a width-2
               temp then TRUNC back to the byte slot. */
            if (b->f->vregs[lhs_v].width == 1) {
                int tmp = new_temp(b, 2);
                b->f->vregs[tmp].width = 2;
                if (n->right && n->right->ast_type == AST_LITERAL) {
                    Op *op = ir_op_emit(cur_bb(b), k);
                    op->dst = tmp; op->src[0] = lhs_v;
                    op->src[1] = -1; op->imm = (int64_t)n->right->zval;
                } else {
                    int rhs_v = build_expr(b, n->right);
                    if (rhs_v < 0) return -1;
                    ir_emit_binop(cur_bb(b), k, tmp, lhs_v, rhs_v);
                }
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = lhs_v; tr->src[0] = tmp;
                return lhs_v;
            }
            /* Literal-RHS fold (mirror of binop). */
            if (n->right && n->right->ast_type == AST_LITERAL) {
                Op *op = ir_op_emit(cur_bb(b), k);
                op->dst    = lhs_v;
                op->src[0] = lhs_v;
                op->src[1] = -1;
                op->imm    = (int64_t)n->right->zval;
                return lhs_v;
            }
            int rhs_v = build_expr(b, n->right);
            if (rhs_v < 0) return -1;
            ir_emit_binop(cur_bb(b), k, lhs_v, lhs_v, rhs_v);  /* aliased */
            return lhs_v;
        }

        /* Global scalar: `g op= x`. load/store via MEM_SYM — no pointer
           indirection (build_expr on AST_GLOBAL_VAR yields the value, not
           the address, so using it as ptr_v would dereference a garbage
           address). */
        if (n->left->operand->ast_type == AST_GLOBAL_VAR) {
            SYMBOL *gsym = n->left->operand->sym;
            if (!gsym) return build_fail("compound op= on null global sym");
            int gv_w = 2;
            { int w = width_for_kind((Kind)gsym->type); if (w > 0) gv_w = w; }
            int loaded_g = new_temp(b, gv_w);
            b->f->vregs[loaded_g].width = (int16_t)gv_w;
            Op *ld_g = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld_g->dst = loaded_g; ld_g->mem.kind = IR_MEM_SYM;
            ld_g->mem.sym = gsym;
            int dst_g = new_temp(b, gv_w);
            b->f->vregs[dst_g].width = (int16_t)gv_w;
            if (n->right && n->right->ast_type == AST_LITERAL) {
                Op *op = ir_op_emit(cur_bb(b), k);
                op->dst = dst_g; op->src[0] = loaded_g;
                op->src[1] = -1; op->imm = (int64_t)n->right->zval;
            } else {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                ir_emit_binop(cur_bb(b), k, dst_g, loaded_g, rhs_v);
            }
            Op *st_g = ir_op_emit(cur_bb(b), IR_ST_MEM);
            st_g->src[0] = dst_g; st_g->mem.kind = IR_MEM_SYM;
            st_g->mem.sym = gsym;
            return dst_g;
        }

        /* Indirection: `*p op= x` / `*(p+K) op= x`. LHS->operand is any
           pointer expression — walk it to a vreg, load through it,
           combine, store back. */
        int ptr_v = build_expr(b, n->left->operand);
        if (ptr_v < 0) return -1;
        int elem_w = type_width(n->left->type);
        if (elem_w != 1 && elem_w != 2 && elem_w != 4)
            return build_fail("compound deref elem width %d not supported",
                              elem_w);
        int loaded = new_temp(b, elem_w);
        b->f->vregs[loaded].width = elem_w;
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst       = loaded;
        ld->mem.kind  = IR_MEM_VREG;
        ld->mem.base  = ptr_v;
        ld->mem.elem  = (elem_w == 1) ? KIND_CHAR
                      : (elem_w == 2) ? KIND_INT
                      :                 KIND_LONG;
        int dst = new_temp(b, elem_w);
        b->f->vregs[dst].width = elem_w;
        if (n->right && n->right->ast_type == AST_LITERAL) {
            Op *op = ir_op_emit(cur_bb(b), k);
            op->dst    = dst;
            op->src[0] = loaded;
            op->src[1] = -1;
            op->imm    = (int64_t)n->right->zval;
        } else {
            int rhs_v = build_expr(b, n->right);
            if (rhs_v < 0) return -1;
            ir_emit_binop(cur_bb(b), k, dst, loaded, rhs_v);
        }
        Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
        st->src[0]    = dst;
        st->mem.kind  = IR_MEM_VREG;
        st->mem.base  = ptr_v;
        st->mem.elem  = ld->mem.elem;
        return dst;
    }

    case OP_AMULT: case OP_ADIV: case OP_AMOD: {
        /* Compound multiply/divide/modulo: LHS op= RHS.
           Always uses a runtime helper (no direct IR binop).
           Same helper table and argument convention as OP_MULT/DIV/MOD. */
        if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
            return build_fail("compound *=/div/mod LHS shape not yet supported");

        int is_local  = (n->left->operand->ast_type == AST_LOCAL_VAR);
        int is_global = (n->left->operand->ast_type == AST_GLOBAL_VAR);
        int lhs_v, ptr_v = -1, elem_w;
        Kind elem_kind = KIND_INT;
        SYMBOL *gsym_md = NULL;   /* set when is_global */

        if (is_local) {
            SYMBOL *lsym = n->left->operand->sym;
            lhs_v = sym_map_get(b, lsym);
            if (lhs_v < 0)
                return build_fail("compound *=/div/mod to unknown local %s",
                                  lsym ? lsym->name : "?");
            elem_w = b->f->vregs[lhs_v].width;
        } else if (is_global) {
            gsym_md = n->left->operand->sym;
            if (!gsym_md)
                return build_fail("compound *=/div/mod on null global sym");
            elem_w = 2;
            { int w = width_for_kind((Kind)gsym_md->type); if (w > 0) elem_w = w; }
            elem_kind = (elem_w == 1) ? KIND_CHAR
                      : (elem_w == 2) ? KIND_INT : KIND_LONG;
            lhs_v = new_temp(b, elem_w);
            b->f->vregs[lhs_v].width = (int16_t)elem_w;
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst = lhs_v; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = gsym_md;
        } else {
            ptr_v = build_expr(b, n->left->operand);
            if (ptr_v < 0) return -1;
            elem_w = type_width(n->left->type);
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("compound *=/div/mod deref elem width %d not supported",
                                  elem_w);
            elem_kind = (elem_w == 1) ? KIND_CHAR
                      : (elem_w == 2) ? KIND_INT : KIND_LONG;
            lhs_v = new_temp(b, elem_w);
            b->f->vregs[lhs_v].width = (int16_t)elem_w;
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst      = lhs_v;
            ld->mem.kind = IR_MEM_VREG;
            ld->mem.base = ptr_v;
            ld->mem.elem = elem_kind;
        }

        int rhs_v = build_expr(b, n->right);
        if (rhs_v < 0) return -1;

        /* Widen or truncate rhs to match element width. */
        int rhs_w = b->f->vregs[rhs_v].width;
        if (rhs_w != elem_w) {
            int unsigned_rhs = !n->right->type || n->right->type->isunsigned;
            int tmp = new_temp(b, elem_w);
            b->f->vregs[tmp].width = (int16_t)elem_w;
            Op *cv = ir_op_emit(cur_bb(b),
                                (rhs_w > elem_w) ? IR_CONV_TRUNC
                                : unsigned_rhs   ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = tmp; cv->src[0] = rhs_v;
            rhs_v = tmp;
        }

        int unsigned_op = (n->type && n->type->isunsigned)
            || (n->left->type && n->left->type->isunsigned);
        const char *helper;
        int n_stacked = 0, ret_in_de = 0;
        int *args = calloc(2, sizeof(int));
        if (elem_w == 4) {
            if (n->ast_type == OP_AMULT)
                helper = unsigned_op ? "l_long_mult_u" : "l_long_mult";
            else if (n->ast_type == OP_ADIV)
                helper = unsigned_op ? "l_long_div_u" : "l_long_div";
            else
                helper = unsigned_op ? "l_long_mod_u" : "l_long_mod";
            args[0] = lhs_v; args[1] = rhs_v; n_stacked = 1;
        } else if (n->ast_type == OP_AMULT) {
            helper = "l_mult";
            args[0] = lhs_v; args[1] = rhs_v;
        } else {
            helper = unsigned_op ? "l_div_u" : "l_div";
            args[0] = rhs_v; args[1] = lhs_v;
            if (n->ast_type == OP_AMOD) ret_in_de = 1;
        }

        int dst = new_temp(b, elem_w);
        b->f->vregs[dst].width = (int16_t)elem_w;
        Op *call = ir_op_emit(cur_bb(b), IR_HCALL);
        call->dst = dst;
        HelperInfo *hi = calloc(1, sizeof(HelperInfo));
        hi->name      = helper;
        hi->args      = args;
        hi->n_args    = 2;
        hi->n_stacked = n_stacked;
        hi->ret_vreg  = dst;
        hi->ret_in_de = ret_in_de;
        call->hcall   = hi;

        if (is_local) {
            ir_emit_mov(cur_bb(b), lhs_v, dst);
            return lhs_v;
        } else if (is_global) {
            Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
            st->src[0] = dst; st->mem.kind = IR_MEM_SYM;
            st->mem.sym = gsym_md;
            return dst;
        } else {
            Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
            st->src[0]   = dst;
            st->mem.kind = IR_MEM_VREG;
            st->mem.base = ptr_v;
            st->mem.elem = elem_kind;
            return dst;
        }
    }

    case OP_OROR:
    case OP_ANDAND: {
        /* Short-circuit `a && b` / `a || b`. C semantics: result is
           int 0/1, b is evaluated only when a's truth value doesn't
           settle the outcome.

           Lowering uses 2 new BBs (eval-b path + exit) and a shared
           result vreg pre-loaded with the short-circuit value:
             ANDAND: result = 0; if (a == 0) skip eval_b; result = (b!=0)
             OROR:   result = 1; if (a != 0) skip eval_b; result = (b!=0)
           In both cases, when we DO eval b, the result is set to the
           truthiness of b (== 0 → 0, != 0 → 1). */
        if (!n->left || !n->right)
            return build_fail("OP_%s with missing operand",
                              n->ast_type == OP_ANDAND ? "ANDAND" : "OROR");
        int a_v = build_expr(b, n->left);
        if (a_v < 0) return -1;

        int result   = ALLOC_DST(2);
        int short_v  = (n->ast_type == OP_ANDAND) ? 0 : 1;
        int eval_bb  = ir_bb_new(b->f);
        int exit_bb  = ir_bb_new(b->f);

        /* Pre-load result with the short-circuit value. */
        ir_emit_ld_imm(cur_bb(b), result, short_v);

        /* ANDAND: if a == 0, skip b (use short value). BR_ZERO matches.
           OROR:   if a != 0, skip b (use short value). BR_COND matches. */
        if (n->ast_type == OP_ANDAND)
            ir_emit_br_zero(cur_bb(b), a_v, exit_bb);
        else
            ir_emit_br_cond(cur_bb(b), a_v, exit_bb);
        ir_emit_br(cur_bb(b), eval_bb);

        /* eval_bb: result = (b != 0 ? 1 : 0) — done via CMP_NE
           with zero so the result is canonical 0/1. */
        b->cur_bb_id = eval_bb;
        int b_v = build_expr(b, n->right);
        if (b_v < 0) return -1;
        int zero_v = new_temp(b, 2);
        ir_emit_ld_imm(cur_bb(b), zero_v, 0);
        int b_truth = new_temp(b, 2);
        ir_emit_binop(cur_bb(b), IR_CMP_NE, b_truth, b_v, zero_v);
        /* Both ANDAND and OROR set result = (b != 0) in the eval
           path — the short-circuit pre-load is only used when we
           don't evaluate b. Overwrite the pre-loaded result. */
        ir_emit_mov(cur_bb(b), result, b_truth);
        ir_emit_br(cur_bb(b), exit_bb);

        b->cur_bb_id = exit_bb;
        return result;
    }

    case AST_COMPOUND_STMT: {
        /* Comma expression / doexpr() singleton wrap. Walk each
           sub-expression in order, discarding all results except
           the last (which becomes the compound's value). The parser
           wraps every doexpr-collected statement in this even when
           there's only one comma operand — switch sw_expr, for
           init/step, and any context using doexpr(). */
        if (!n->stmts) return -1;
        int n_stmts = (int)array_len(n->stmts);
        if (n_stmts == 0) return -1;
        int last = -1;
        for (int i = 0; i < n_stmts; i++) {
            Node *s = array_get_byindex(n->stmts, i);
            last = build_expr(b, s);
            if (last < 0) return -1;
        }
        return last;
    }

    default:
        return build_fail("unsupported expr ast_type=%d", (int)n->ast_type);
    }
}

/* ----- Statement walker ------------------------------------------------ */

static int build_stmt(Builder *b, Node *n)
{
    if (!n) return 0;

    /* Stamp source location on every op emitted for this stmt — the
       lowerer reads it to drive C_LINE / -cc emission. AST_COMPOUND_STMT
       recurses, so child stmts will override before their ops fire. */
    if (n->filename && n->line > 0)
        ir_set_emit_loc(n->filename, n->line);

    switch (n->ast_type) {

    case AST_COMPOUND_STMT: {
        if (!n->stmts) return 0;
        int n_stmts = (int)array_len(n->stmts);
        for (int i = 0; i < n_stmts; i++) {
            Node *s = array_get_byindex(n->stmts, i);
            if (build_stmt(b, s) != 0) return -1;
        }
        return 0;
    }

    case AST_RETURN: {
        int v = -1;
        Node *rv = n->retval;
        /* A void `return;` desugared inside a loop/if can arrive with
           retval set to an empty AST_COMPOUND_STMT (the parser's noop
           wrap) rather than NULL — treat that as no return value, else
           build_expr bails silently on the empty compound. */
        if (rv && rv->ast_type == AST_COMPOUND_STMT
            && (!rv->stmts || array_len(rv->stmts) == 0))
            rv = NULL;
        if (rv) {
            v = build_expr(b, rv);
            if (v < 0) return -1;
            /* Widen byte retvals to int — z80 return ABI puts the
               value in HL even when the C return type is char. */
            if (b->f->vregs[v].width == 1) {
                int unsigned_src = rv->type && rv->type->isunsigned;
                int tmp = new_temp(b, 2);
                b->f->vregs[tmp].width = 2;
                Op *cv = ir_op_emit(cur_bb(b),
                                    unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = tmp; cv->src[0] = v;
                v = tmp;
            }
        }
        ir_emit_ret(cur_bb(b), v);
        return 0;
    }

    case AST_DECL: {
        /* Local declaration. Scalars (int-class or long) get a vreg
           sized for their value. Aggregates (struct / array) get a
           vreg whose slot is sym->ctype->size bytes — references
           decay to the address via IR_LEA. Init lists initialise
           field-by-field / element-by-element via init_typed_region
           (zero-filling what the list doesn't cover, per C). */
        if (!n->sym)
            return build_fail("AST_DECL without sym");
        if ((Kind)n->sym->type == KIND_STRUCT
            || (Kind)n->sym->type == KIND_ARRAY) {
            int sz = n->sym->ctype ? n->sym->ctype->size : 0;
            if (sz <= 0 || sz > 32767)
                return build_fail("AST_DECL aggregate sym=%s size=%d "
                                  "out of int16_t slot range",
                                  n->sym->name, sz);
            int agg_v = new_local_vreg(b, n->sym);
            if (n->declvar) {
                int base = new_temp(b, 2);
                Op *lea = ir_op_emit(cur_bb(b), IR_LEA);
                lea->dst = base; lea->src[0] = agg_v;
                int budget = INIT_REGION_MAX_STORES;
                int rc = init_typed_region(b, base, 0, n->sym->ctype,
                                           n->declvar, &budget);
                if (rc == -1) return -1;
                if (rc == -2)
                    return build_fail("AST_DECL aggregate init shape "
                                      "not supported (sym=%s)",
                                      n->sym->name);
            }
            return 0;
        }
        if (!is_supported_int_kind(n->sym->type))
            return build_fail("AST_DECL: kind %d not yet supported (sym=%s)",
                              (int)n->sym->type, n->sym->name);
        int v = new_local_vreg(b, n->sym);
        if (n->declvar) {
            /* Byte (width-1) local init: build at natural width and
               TRUNC into the byte slot — same overrun guard as the
               OP_ASSIGN byte path (a wide initialiser hinted into the
               1-byte slot would store 2 bytes and clobber the next
               local). */
            if (b->f->vregs[v].width == 1) {
                int init_v = build_expr(b, n->declvar);
                if (init_v < 0) return -1;
                if (b->f->vregs[init_v].width == 1) {
                    ir_emit_mov(cur_bb(b), v, init_v);
                } else {
                    Op *op = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                    op->dst = v; op->src[0] = init_v;
                }
                return 0;
            }
            /* Hint the init expr to write directly into v's vreg.
               For AST_LITERAL inits this skips an LD_IMM + MOV pair
               and the intermediate slot. */
            int init_v = build_expr_hinted(b, n->declvar, v);
            if (init_v < 0) return -1;
            if (init_v != v)
                ir_emit_mov(cur_bb(b), v, init_v);
        }
        return 0;
    }

    case AST_UNDECL:
        /* Marker — no codegen action. */
        return 0;

    case AST_PRESERVE_BC:
        /* Legacy uses this to push/pop BC around a body that may
           clobber it (the loop-reverse counter lives in BC). Our IR
           doesn't pin anything to BC — the counter is a vreg — so
           this is a pure passthrough to the wrapped stmt. */
        return n->operand ? build_stmt(b, n->operand) : 0;

    case AST_LOOP_COUNTDOWN: {
        /* Reversed loop: counter starts at loop_init's value, body
           runs counter times. Has a pre-test for the zero-trip case
           (decrementing past 0 would wrap). Optional continue target
           is loop_step_label; the break target is loop_exit_label.
           Width (8 vs 16) doesn't change the IR shape — we just use
           a 16-bit counter vreg regardless. */
        if (!n->loop_init || !n->loop_body)
            return build_fail("AST_LOOP_COUNTDOWN missing init/body");
        int init_v = build_expr(b, n->loop_init);
        if (init_v < 0) return -1;

        int counter = new_temp(b, 2);
        ir_emit_mov(cur_bb(b), counter, init_v);

        int header_bb = ir_bb_new(b->f);
        int exit_bb   = get_or_create_label_bb(b, n->loop_exit_label);
        int step_bb   = n->loop_step_label
                      ? get_or_create_label_bb(b, n->loop_step_label)
                      : ir_bb_new(b->f);

        /* Pre-test: if counter==0, skip the loop. */
        ir_emit_br_zero(cur_bb(b), counter, exit_bb);
        ir_emit_br(cur_bb(b), header_bb);

        b->cur_bb_id = header_bb;
        if (build_stmt(b, n->loop_body) != 0) return -1;
        close_bb_with_fallthrough(b, step_bb);

        b->cur_bb_id = step_bb;
        ir_emit_unop(cur_bb(b), IR_DEC, counter, counter);
        ir_emit_br_cond(cur_bb(b), counter, header_bb);
        ir_emit_br(cur_bb(b), exit_bb);

        b->cur_bb_id = exit_bb;
        return 0;
    }

    case AST_LABEL: {
        /* Get-or-create the BB for this label, fall through into it
           from the current BB. */
        int target = get_or_create_label_bb(b, n->label);
        close_bb_with_fallthrough(b, target);
        b->cur_bb_id = target;
        return 0;
    }

    case AST_JUMP: {
        /* Unconditional goto — resolve label, emit IR_BR. After a
           branch the current BB is "dead"; subsequent stmts that
           aren't labels will have nowhere to land. The parser puts
           a label after every backward goto (loops), and forward
           gotos end blocks. Spin up a fresh anonymous BB so any
           accidentally-following ops have a home; if a label comes
           next it will close + redirect via close_bb_with_fallthrough. */
        int target = get_or_create_label_bb(b, n->label);
        ir_emit_br(cur_bb(b), target);
        b->cur_bb_id = ir_bb_new(b->f);
        return 0;
    }

    case AST_SWITCH: {
        /* `switch (e) { case K1: ...; case K2: ...; default: ...; }`.
           sw_cases is the dispatch array of AST_SWITCH_CASE nodes
           (each with sw_value = case constant, sw_label = goto
           target). sw_body contains AST_LABELs that match those
           targets, plus the case bodies. sw_default_label is the
           default target (== sw_exit_label if no `default:`).
           sw_exit_label is the break / post-switch target.

           Lowering: eval sw_expr → v, then one IR_SWITCH terminator
           carrying the (value, target-BB) table + default. The
           lowerer routes by kind: char → inline cp chain, int →
           l_case table, long → l_long_case table. Walk sw_body —
           its AST_LABELs land cleanly via the existing AST_LABEL
           handler. */
        if (!n->sw_expr)
            return build_fail("AST_SWITCH missing sw_expr");
        Kind swk = n->type ? (Kind)n->type->kind : KIND_INT;
        if (swk == KIND_LONGLONG)
            return build_fail("switch on long long not yet supported");
        int v = build_expr(b, n->sw_expr);
        if (v < 0) return -1;
        int n_cases = n->sw_cases ? (int)array_len(n->sw_cases) : 0;
        int default_bb = get_or_create_label_bb(b, n->sw_default_label);
        if (n_cases > 0) {
            SwitchInfo *sw = calloc(1, sizeof(SwitchInfo));
            int64_t *vals  = calloc((size_t)n_cases, sizeof(int64_t));
            int     *tgts  = calloc((size_t)n_cases, sizeof(int));
            if (!sw || !vals || !tgts) {
                free(sw); free(vals); free(tgts);
                return build_fail("switch: out of memory");
            }
            int nc = 0;
            for (int i = 0; i < n_cases; i++) {
                Node *c = array_get_byindex(n->sw_cases, i);
                if (!c || c->ast_type != AST_SWITCH_CASE) continue;
                vals[nc] = c->sw_value ? (int64_t)c->sw_value->zval : 0;
                tgts[nc] = get_or_create_label_bb(b, c->sw_label);
                nc++;
            }
            sw->values     = vals;
            sw->target_bb  = tgts;
            sw->n_cases    = nc;
            sw->default_bb = default_bb;
            sw->is_char    = (swk == KIND_CHAR);
            Op *op = ir_op_emit(cur_bb(b), IR_SWITCH);
            op->src[0] = v;
            op->src[1] = -1;
            op->sw     = sw;
        } else {
            ir_emit_br(cur_bb(b), default_bb);
        }
        /* Walk the body. First label in the body (the first case
           or default:) will redirect via close_bb_with_fallthrough. */
        b->cur_bb_id = ir_bb_new(b->f);
        if (n->sw_body && build_stmt(b, n->sw_body) != 0) return -1;
        if (n->sw_exit_label) {
            int exit_bb = get_or_create_label_bb(b, n->sw_exit_label);
            close_bb_with_fallthrough(b, exit_bb);
            b->cur_bb_id = exit_bb;
        }
        return 0;
    }

    case AST_IF:
    case AST_TERNARY: {
        /* Statement context: cond + then-stmt + optional else-stmt
           (AST_IF) / mandatory else-stmt (AST_TERNARY-as-stmt — the
           parser desugars `while` into this shape with else=goto).
           Empty then (e.g. `if (cond) ;`) is allowed; we still emit
           the cond test so any side-effects fire. */
        if (!n->cond) {
            /* Condition-less loop test: the parser emits `for(;;)` as
               ast_conditional(NULL, then, els=goto-exit) (stmt.c dofor) —
               the condition is "always true", so take `then` (empty for
               a bare for(;;)) and never the else. Build `then` and fall
               through to the loop body; iteration is the loop's own
               back-edge jump and exit is via break/goto to the exit
               label, so the else (goto-exit) is correctly dropped. */
            if (n->then && build_stmt(b, n->then) != 0) return -1;
            return 0;
        }
        int cond_v = build_expr(b, n->cond);
        if (cond_v < 0) return -1;

        int then_bb = ir_bb_new(b->f);
        int exit_bb = ir_bb_new(b->f);
        int els_bb  = n->els ? ir_bb_new(b->f) : exit_bb;

        /* BR_ZERO is non-terminator; add explicit BR to then for the
           cond-true case. Avoids relying on BB array-emit order
           matching the desired fall-through. */
        ir_emit_br_zero(cur_bb(b), cond_v, els_bb);
        ir_emit_br(cur_bb(b), then_bb);

        b->cur_bb_id = then_bb;
        if (n->then && build_stmt(b, n->then) != 0) return -1;
        close_bb_with_fallthrough(b, exit_bb);

        if (n->els) {
            b->cur_bb_id = els_bb;
            if (build_stmt(b, n->els) != 0) return -1;
            close_bb_with_fallthrough(b, exit_bb);
        }

        b->cur_bb_id = exit_bb;
        return 0;
    }

    default:
        /* Expression statement — many AST_FUNC_CALL, OP_*, etc. land
           here. Walk as an expression and discard the result. Same set
           the AST validates as legal in statement context (any
           side-effecting expression). */
        if (n->ast_type == AST_FUNC_CALL ||
            n->ast_type == AST_FUNCPTR_CALL ||
            n->ast_type == OP_ASSIGN ||
            n->ast_type == OP_AADD || n->ast_type == OP_ASUB ||
            n->ast_type == OP_AAND || n->ast_type == OP_AOR ||
            n->ast_type == OP_AXOR ||
            n->ast_type == OP_AMULT || n->ast_type == OP_ADIV ||
            n->ast_type == OP_AMOD || n->ast_type == OP_ASSHR ||
            n->ast_type == OP_ASSHL ||
            n->ast_type == OP_PRE_INC || n->ast_type == OP_POST_INC ||
            n->ast_type == OP_PRE_DEC || n->ast_type == OP_POST_DEC ||
            n->ast_type == OP_DEREF ||
            n->ast_type == OP_CAST ||
            n->ast_type == AST_STR_LIT ||
            n->ast_type == AST_LITERAL) {
            /* OP_DEREF / OP_CAST as a statement — discarded read, but
               the operand may carry side effects (`*p++;`, function
               call return, etc.). Walk as an expression; the loaded
               value just lands in a dead vreg. AST_STR_LIT / AST_LITERAL
               as a bare statement (`"foo";` / `42;`) are side-effect-free
               no-ops — walk-and-discard leaves a dead vreg DCE removes. */
            int v = build_expr(b, n);
            (void)v;
            return v < 0 ? -1 : 0;
        }
        if (n->ast_type == AST_ASM) {
            /* `asm("...")` / `__asm__` / `#asm` block. Pass the
               captured text through verbatim; the IR pipeline treats
               it as a full register/memory clobber (handled by the
               lowerer's IR_ASM emit + cache invalidations). */
            Op *op = ir_op_emit(cur_bb(b), IR_ASM);
            op->asm_text = n->labelname;
            return 0;
        }
        return build_fail("unsupported stmt ast_type=%d", (int)n->ast_type);
    }
}

/* ----- Public entry ---------------------------------------------------- */

static int ir_generate_code_impl(Node *body, SYMBOL *fn)
{
    if (!body) return 0;
    if (!fn)   return build_fail("ir_generate_code with NULL fn");
    cur_fn_name = (fn->name[0] ? fn->name : "?");

    Func *f = ir_func_new(fn);
    if (!f) return build_fail("ir_func_new returned NULL");
    f->features = ir_features_from_cpu();

    /* Entry BB. */
    int entry = ir_bb_new(f);
    Builder b;
    builder_init(&b, f);
    b.cur_bb_id = entry;

    /* Fastcall CALLEES are wrong-code on the IR path: the prologue's
       `push hl` (the fastcall arg) isn't reflected in the param slot
       offsets — the body reads the return address as the arg and the
       ret leaks 2 bytes of stack. Defer to the walker until the IR
       prologue models the pushed-HL param. (Calling INTO fastcall
       targets works fine — this is the definition side only.) */
    if (fn->ctype && (fn->ctype->flags & FASTCALL)
        && fn->ctype->parameters && array_len(fn->ctype->parameters) > 0) {
        builder_free(&b);
        ir_func_free(f);
        return build_fail("fastcall callee not yet supported");
    }

    /* Pre-create PARAM vregs in declaration order so the lowerer's
       param-init prologue picks them up before any temps. Each param's
       SYMBOL lives in loctab keyed by its source name. */
    if (fn->ctype && fn->ctype->parameters) {
        int np = (int)array_len(fn->ctype->parameters);
        for (int i = 0; i < np; i++) {
            Type *pt = array_get_byindex(fn->ctype->parameters, i);
            if (!pt) continue;
            SYMBOL *psym = findloc(pt->name);
            if (!psym) {
                builder_free(&b);
                ir_func_free(f);
                return build_fail("param %s not in loctab", pt->name);
            }
            /* KIND_ELLIPSES is the `...` marker for variadic functions
               — no actual storage, no vreg needed. va_start/va_arg
               access the caller's stack directly via the address of
               the last named parameter's slot, which IS allocated as
               a regular vreg in this loop. Skip the marker. */
            if ((Kind)psym->type == KIND_ELLIPSES)
                continue;
            if (!is_supported_int_kind(psym->type)) {
                builder_free(&b);
                ir_func_free(f);
                return build_fail("param %s kind %d not yet supported",
                                  pt->name, (int)psym->type);
            }
            int v = ir_vreg_new(b.f, (int)psym->type, psym, IR_VREG_PARAM);
            int pw = width_for_kind((Kind)psym->type);
            b.f->vregs[v].width = (int16_t)(pw ? pw : 2);
            sym_map_set(&b, psym, v);
        }
    }

    int rc = build_stmt(&b, body);
    if (rc != 0) {
        builder_free(&b);
        ir_func_free(f);
        return rc;
    }

    /* If the function fell off the end without a return, append one.
       (Real C would warn / be UB; the IR validator requires a
       terminator on every BB.) */
    BB *tail = cur_bb(&b);
    if (tail->n_ops == 0 ||
        !ir_op_is_terminator(tail->ops[tail->n_ops - 1].kind)) {
        ir_emit_ret(tail, -1);
    }

    /* Any BBs that were created lazily (labels referenced via goto but
       never visited as a statement) need terminators too. Walk all BBs
       and append a sentinel RET if any are open — happens if a goto
       points to a label that the parser dropped. */
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        if (bb->n_ops == 0 ||
            !ir_op_is_terminator(bb->ops[bb->n_ops - 1].kind)) {
            ir_emit_ret(bb, -1);
        }
    }

    if (ir_validate(f) != 0) {
        builder_free(&b);
        ir_func_free(f);
        return build_fail("ir_validate failed for %s",
                          fn->name[0] ? fn->name : "?");
    }

    rc = ir_lower_to_output(f);

    builder_free(&b);
    ir_func_free(f);
    return rc;
}

int ir_generate_code(Node *body, SYMBOL *fn)
{
    build_fail_emitted = 0;
    int rc = ir_generate_code_impl(body, fn);
    /* A nonzero rc routes the caller to the legacy walker. If we got
       there without printing a reason, the bail was SILENT — surface it
       so unsupported shapes can't quietly degrade (or miscompile, as a
       walker bug then would). Cheap, only fires on the fall-back path. */
    if (rc != 0 && !build_fail_emitted)
        fprintf(stderr, "ir_build: [%s] silent bail to walker "
                "(no diagnostic — please report)\n",
                fn && fn->name[0] ? fn->name : "?");
    return rc;
}
