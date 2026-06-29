/*
 * ir_build.c — AST → IR translator.
 *
 * Phase 1 minimal cut. Target: grow this just enough to make the
 * CRC-16-CCITT kernel in test/suites/intbench/intbench.c compile and
 * run via the IR pipeline. Anything not yet handled aborts with a
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
    int   cur_bb_id;   /* index into f->bbs[]; pointer would be invalidated
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

/* Ensure current BB ends with a terminator. If it doesn't, emit an
   IR_BR to `target_bb` (fall-through). Used when transitioning BBs. */
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

static int build_fail(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);
    fprintf(stderr, "ir_build: [%s] ", cur_fn_name);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
    return -1;
}

/* ----- Expression walker — returns the vreg holding the result, or -1
   on failure. Width is inferred from node->type when available.

   `hint` is an optional caller-provided destination vreg. When >= 0 and
   the expression supports it, the result is written directly to `hint`
   and `hint` is returned. This eliminates the intermediate-temp + MOV
   pair that the caller would otherwise emit (`MOV dst, temp`). Cases
   that don't support a hint (e.g. a bare local-var read where the
   value already lives in another vreg) fall back to returning that
   vreg; the caller is responsible for emitting a MOV in that case.
   Pass -1 to force a fresh temp. */

static int build_expr_hinted(Builder *b, Node *n, int hint);

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

/* True for any integer-class kind we currently support (1/2/4 byte). */
static int is_supported_int_kind(Kind k)
{
    return k == KIND_CHAR || k == KIND_INT || k == KIND_SHORT
        || k == KIND_PTR  || k == KIND_LONG;
}

/* Width in bytes for the integer kinds we care about. Returns 0 for
   anything outside the supported set so callers can bail. */
static int width_for_kind(Kind k)
{
    if (k == KIND_CHAR)  return 1;
    if (k == KIND_INT || k == KIND_SHORT || k == KIND_PTR) return 2;
    if (k == KIND_LONG)  return 4;
    return 0;
}

/* Width for a Type pointer, falling back to 2 if absent. */
static int type_width(Type *t)
{
    if (!t) return 2;
    int w = width_for_kind(t->kind);
    return w ? w : 2;
}

/* Allocate a vreg for a local declared in the source. Registers it
   in the sym_map and gives it the local's sym for the dumper.

   Arrays (KIND_ARRAY) get a slot sized to sym->size. The vreg's
   `width` field is overloaded to mean "slot byte count" for arrays
   — VReg.width is int8_t, so arrays larger than 127 bytes can't be
   represented and the caller should bail. The vreg is always
   marked IR_VREG_ADDR_TAKEN since references decay to its address.
   The vreg's "value" is meaningless on its own — it's only ever
   read via IR_LEA in expression context. */
static int new_local_vreg(Builder *b, SYMBOL *sym)
{
    int v = ir_vreg_new(b->f, (int)sym->type, sym, 0);
    if ((Kind)sym->type == KIND_ARRAY) {
        /* Array byte count lives in sym->ctype->size (not sym->size,
           which is used for goto labels / per-symbol bookkeeping). */
        int sz = sym->ctype ? sym->ctype->size : 0;
        b->f->vregs[v].width = (int8_t)sz;
        b->f->vregs[v].flags |= IR_VREG_ADDR_TAKEN;
    } else {
        int w = width_for_kind((Kind)sym->type);
        b->f->vregs[v].width = (int8_t)(w ? w : 2);
    }
    sym_map_set(b, sym, v);
    return v;
}

/* Map a C OP_* binary op to an IR OpKind. Returns IR_OP_COUNT (invalid)
   for shapes the Phase 1 builder can't lower. */
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
       Use this whenever an op writes a result into a new vreg.
       Note that not every site is hint-safe: ops with an aliased
       constraint (binops where dst aliases src[0]) need the hint
       to be the same as src[0], which the caller can't guarantee
       — so binops still allocate a fresh dst for now. The win is
       elsewhere: LD_IMM, unary ops, and the "passthrough" cases. */
    #define ALLOC_DST(width) ((hint) >= 0 ? (hint) : new_temp(b, (width)))

    switch (n->ast_type) {

    case AST_LITERAL: {
        /* Width comes from the literal's type. A `long` constant
           (e.g. 0x12345678UL) must materialise into a 4-byte vreg —
           writing it into width=2 truncates the high half silently.
           Default to int when type info is missing. */
        int w = n->type ? type_width(n->type) : 2;
        if (w != 1 && w != 2 && w != 4) w = 2;
        int v = ALLOC_DST(w);
        b->f->vregs[v].width = (int8_t)w;
        ir_emit_ld_imm(cur_bb(b), v, (int64_t)n->zval);
        return v;
    }

    case AST_STR_LIT: {
        /* String-literal queue ref: address of `i_<litlab>+<zval>`.
           IR_LD_STR emits `ld hl,i_<litlab>+<offs>`. */
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
        if (n->sym && (Kind)n->sym->type == KIND_ARRAY) {
            int src = sym_map_get(b, n->sym);
            if (src < 0)
                return build_fail("AST_LOCAL_VAR array unmapped %s",
                                  n->sym->name);
            int dst = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LEA);
            op->dst    = dst;
            op->src[0] = src;
            return dst;
        }
        return build_fail("bare AST_LOCAL_VAR outside lvalue context");

    case AST_GLOBAL_VAR: {
        /* Function-typed and array-typed globals decay to their ADDRESS
           in expression context (C §6.3.2.1). Walker emits `ld hl,_sym`
           (not `ld hl,(_sym)`). Aggregates (struct/union) at the AST
           level are usually flagged separately — start with the two
           most common decays and extend if needed. */
        if (n->sym && n->sym->ctype &&
            (n->sym->ctype->kind == KIND_FUNC ||
             n->sym->ctype->kind == KIND_ARRAY)) {
            int v = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LD_SYM);
            op->dst = v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->sym;
            return v;
        }
        /* Global — load from MEM_SYM. Width comes from the symbol's
           type kind so long globals stay long through the lowerer.
           Without this, `unsigned long g = ...; foo(g);` truncates
           `g` to int on read (mirror of the long-store-to-global bug).
           sym->type is the symbol-table KIND_* code (KIND_LONG → 4),
           same convention new_local_vreg uses. */
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
           Phase 1 also accepts OP_DEREF(AST_GLOBAL_VAR) so we can
           collapse `(deref (gv=x))` to a sym-mem load.

           OP_DEREF wrapping a pre/post step (`(deref (post++ X))`) is
           a parser-side rvalue() habit — the step already produces the
           value; pass through. (Matches cg2_walk's behaviour.) */
        if (n->operand && (n->operand->ast_type == OP_PRE_INC ||
                           n->operand->ast_type == OP_POST_INC ||
                           n->operand->ast_type == OP_PRE_DEC ||
                           n->operand->ast_type == OP_POST_DEC)) {
            /* sccz80's rvalue() wraps every step with this OP_DEREF
               and stamps it with the lvalue's value type
               (lval->ltype). The inner step node's own type was left
               at the operand's *address* type by normalize_types, so
               the step builder can't use it to size loads/stores.
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
            /* Step amount: sizeof(*p) for pointer arithmetic. char* →
               +/-1 (IR_INC/IR_DEC); int* → +/-2 (IR_ADD/SUB with imm).
               The pointee width comes from the local's pointed-to type;
               fall back to the deref's result width if unavailable. */
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
            b->f->vregs[dst].width = (int8_t)elem_w;
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
            return v;
        }
        if (n->operand && n->operand->ast_type == AST_GLOBAL_VAR) {
            /* Same width sourcing as the bare-AST_GLOBAL_VAR case
               above — without this, OP_DEREF(global long) truncates
               to int. */
            int gv_w = 2;
            if (n->operand->sym) {
                int w = width_for_kind((Kind)n->operand->sym->type);
                if (w > 0) gv_w = w;
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
           OP_LT / LE / GT / GE to the signed IR_CMP_LT / LE / GT / GE
           variants unconditionally. C's usual arithmetic conversions
           promote `signed < unsigned` to unsigned-vs-unsigned at the
           same rank, so checking either operand's `isunsigned` is
           sufficient — if either is unsigned, the compare is unsigned.
           Without this, `unsigned long < K` emitted the signed S^V
           correction, miscompiling for values with bit 31 set. EQ/NE
           are sign-independent (the byte XOR-OR chain doesn't care)
           so they're left alone. */
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

           ast_opt already commutes for the truly-commutative cases
           (ADD, AND, OR, XOR, EQ, NE) — but it leaves the non-symmetric
           compares (LT/LE/GT/GE) with `lit OP var` because swapping
           them requires inverting the op (`5 < x` → `x > 5`). Catch
           those here. */
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
        int dst_w  = is_cmp ? 2 : width;
        /* Literal-RHS fold: when rhs is an AST_LITERAL, emit
           the binop with src[1] = -1 and op->imm = literal value.
           This lets the lowerer materialise the constant inline
           (`ld de, K` for binops, unrolled `add hl,hl` for shifts).
           Saves a frame slot and the LD_IMM-then-store-then-reload
           churn the dumb path would otherwise emit. */
        if (rhs && rhs->ast_type == AST_LITERAL) {
            int dst = ALLOC_DST(dst_w);
            Op *op = ir_op_emit(cur_bb(b), k);
            op->dst    = dst;
            op->src[0] = l;
            op->src[1] = -1;
            op->imm    = (int64_t)rhs->zval;
            b->f->vregs[dst].width = (int8_t)dst_w;
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
        int dst = ALLOC_DST(dst_w);
        ir_emit_binop(cur_bb(b), k, dst, l, r);
        b->f->vregs[dst].width = (int8_t)dst_w;
        return dst;
    }

    case OP_ASSIGN: {
        /* LHS = RHS. LHS is an lvalue: AST_LOCAL_VAR (address) or
           AST_GLOBAL_VAR or a more complex address expression. Phase 1:
           bare local / bare global only. */
        if (!n->left)
            return build_fail("OP_ASSIGN with NULL LHS");
        if (n->left->ast_type == AST_LOCAL_VAR) {
            int dst_v = sym_map_get(b, n->left->sym);
            if (dst_v < 0)
                return build_fail("OP_ASSIGN to unknown local %s",
                                  n->left->sym ? n->left->sym->name : "?");
            /* Pass dst_v as hint: if the RHS expression supports it,
               it will write directly into dst_v and we can skip the
               MOV. Otherwise it returns a different vreg and we copy. */
            int rhs_v = build_expr_hinted(b, n->right, dst_v);
            if (rhs_v < 0) return -1;
            if (rhs_v != dst_v)
                ir_emit_mov(cur_bb(b), dst_v, rhs_v);
            return dst_v;
        }
        int rhs_v = build_expr(b, n->right);
        if (rhs_v < 0) return -1;
        if (n->left->ast_type == AST_GLOBAL_VAR) {
            Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
            op->src[0]   = rhs_v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->left->sym;
            return rhs_v;
        }
        if (n->left->ast_type == OP_DEREF && n->left->operand) {
            /* Indirect store: `*p = X`, where p is some pointer
               expression. Walk it to a vreg holding the address,
               then emit IR_ST_MEM via IR_MEM_VREG. Element width
               comes from the LHS deref's result type.

               Special case: a bare AST_LOCAL_VAR pointer operand
               (`*q = X` where q is a pointer-typed local). The
               generic build_expr would bail with "bare AST_LOCAL_VAR
               outside lvalue context" — but here we want the local's
               *value* (the pointer), which the symbol's vreg already
               holds directly. Shortcut to the vreg map. */
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
            /* Element width: prefer n->type (the OP_ASSIGN's own type,
               which is by definition the stored value's type — the
               most reliable source). Fall back to n->left->type->ptr
               for the OP_DEREF lvalue convention, then to
               n->left->type itself for the parser's scalar-folded
               shape. Earlier code derived elem_w purely from n->left
               which silently truncated long stores to int for the
               chained-assign / member-store shape because the parser
               sometimes records the scalar value type there. */
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
            /* Match the rhs vreg's width to the store's element width
               via narrow (TRUNC) or widen (ZX/SX) as needed. The
               lowerer's IR_ST_MEM dispatches on src vreg width — a
               mismatch here would emit the wrong-sized store (e.g. a
               4-byte source storing only 2 bytes for a long deref). */
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != elem_w) {
                if (rhs_w > elem_w) {
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int8_t)elem_w;
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
                    b->f->vregs[tmp].width = (int8_t)elem_w;
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
           context. n->left is an OP_ADD / OP_SUB / etc. that evaluates
           to an address. The type kind on n->left varies:
             - KIND_PTR  (e.g. `p[K]` for pointer p) → use ->ptr
             - KIND_ARRAY (e.g. `arr[K]` for an array local) → use ->ptr
             - element scalar kind (KIND_INT/LONG/CHAR) — the parser
               sometimes uses the value type on a folded address node,
               losing the "pointer to" wrapping. Treat n->left->type
               itself as the element type. */
        if (n->left->type
            && (n->left->type->kind == KIND_PTR
             || (n->left->type->kind == KIND_ARRAY
                 && (!n->type || n->type->kind != KIND_LONG)))
            && n->left->type->ptr) {
            /* KIND_ARRAY (local- or global-array stores like
               `arr[i] = K`) gated on non-long element width.
               Char/int/ptr element stores compile through IR cleanly
               and give measurable wins (intbench -6.8% from the
               `buffer[i] = byte` shape in init_data + similar).

               Long-element array stores (`in[i] = long_val` in
               MD5Update's bit-packing loop) DO compile correctly here
               but expose a structural slowdown: every intermediate
               long value (byte<<24 / byte<<16 / etc.) spills to a
               frame slot — costing ~50T per spill + 40T per reload —
               because long vregs can't sit in PR_HL / PR_DE / PR_BC
               (those are width-2 only) and we don't yet have stack-
               push preservation for cross-op long lifetimes. Net
               +39% on md5 with the long-array case enabled.

               Re-enable for long element width once Phase D (stack
               push/pop preservation for long DEHL across DEHL-
               clobbering ops) lands. See src/80cc/.tmp/HELPER_PLAN.md. */
            int ptr_v = build_expr(b, n->left);
            if (ptr_v < 0) return -1;
            /* Prefer n->type (the OP_ASSIGN's own type = stored value
               type) over n->left->type->ptr — same reasoning as the
               OP_DEREF-LHS path's #344 fix. For chained assigns the
               inner OP_ASSIGN's RHS-value type IS the store width;
               the LHS pointer type can mislead. */
            int elem_w = 0;
            if (n->type && is_supported_int_kind(n->type->kind))
                elem_w = type_width(n->type);
            if (elem_w == 0)
                elem_w = type_width(n->left->type->ptr);
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("OP_ASSIGN ptr-LHS elem width %d "
                                  "not yet supported", elem_w);
            /* Match rhs vreg width to elem_w (same logic as the
               OP_DEREF LHS path — widen via ZX/SX or truncate). */
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != elem_w) {
                if (rhs_w > elem_w) {
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int8_t)elem_w;
                    Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                    cv->dst    = tmp;
                    cv->src[0] = rhs_v;
                    rhs_v = tmp;
                } else {
                    int unsigned_src = !n->right->type ||
                                       n->right->type->isunsigned;
                    int tmp = new_temp(b, elem_w);
                    b->f->vregs[tmp].width = (int8_t)elem_w;
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
        /* Expression context: passthrough to operand. Same rationale
           as the statement-context handler — our IR doesn't pin to BC. */
        return n->operand ? build_expr(b, n->operand) : -1;

    case OP_MOD:
        /* The l_div_*-family helpers return quot in HL, rem in DE.
           For mod we want DE — needs an `ex de,hl` after the call
           that IR_HCALL doesn't currently express. Defer to legacy. */
        return build_fail("OP_MOD deferred (needs HL/DE swap path)");

    case OP_MULT:
    case OP_DIV: {
        /* 16-bit integer mul/div via runtime helpers. Convention:
           HL = LHS, DE = RHS, return in HL. */
        int l = build_expr(b, n->left);
        if (l < 0) return -1;
        int r = build_expr(b, n->right);
        if (r < 0) return -1;
        const char *helper;
        int unsigned_op = n->type && n->type->isunsigned;
        if (n->ast_type == OP_MULT) {
            /* Multiplication: low 16 bits are identical for signed and
               unsigned, so a single helper suffices. */
            helper = "l_mult";
        } else {
            helper = unsigned_op ? "l_div_u" : "l_div";
        }
        /* IR_HCALL puts args[0] in HL, args[1] in DE.
           - l_mult: hl = hl * de — args = [LHS, RHS]
           - l_div / l_div_u: computes secondary/primary = DE/HL.
             To get LHS/RHS, LHS must be in DE (secondary), RHS in HL
             (primary). So args = [RHS, LHS] — swapped. */
        int dst = new_temp(b, 2);
        int *args = calloc(2, sizeof(int));
        if (n->ast_type == OP_MULT) {
            args[0] = l;
            args[1] = r;
        } else {
            args[0] = r;        /* RHS → HL (primary) */
            args[1] = l;        /* LHS → DE (secondary) */
        }
        Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
        op->dst = dst;
        HelperInfo *hi = calloc(1, sizeof(HelperInfo));
        hi->name     = helper;
        hi->args     = args;
        hi->n_args   = 2;
        hi->ret_vreg = dst;
        op->hcall = hi;
        return dst;
    }

    case OP_NEG: {
        if (!n->operand) return build_fail("OP_NEG with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        int width = b->f->vregs[v].width;
        int dst = ALLOC_DST(width);
        b->f->vregs[dst].width = (int8_t)width;
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
        b->f->vregs[dst].width = (int8_t)width;
        ir_emit_unop(cur_bb(b), IR_NOT, dst, v);
        return dst;
    }

    case OP_LNEG: {
        /* !x — logical not. Materialise as `x == 0` so we get a 0/1
           result. IR_CMP_EQ compares against a fresh 0 vreg. */
        if (!n->operand) return build_fail("OP_LNEG with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        if (b->f->vregs[v].width == 4)
            return build_fail("long OP_LNEG deferred (operand width 4)");
        int zero_v = new_temp(b, 2);
        ir_emit_ld_imm(cur_bb(b), zero_v, 0);
        int dst = new_temp(b, 2);
        ir_emit_binop(cur_bb(b), IR_CMP_EQ, dst, v, zero_v);
        return dst;
    }

    case AST_FUNC_CALL: {
        /* Direct call only (sym set, callee NULL). All args are walked
           to int-width vregs. Result lands in a new int vreg via
           IR_CALL's ret_vreg. Phase 1: int-class args + return only;
           variadic / fastcall / fnptr-call all deferred. */
        if (!n->sym)
            return build_fail("AST_FUNC_CALL without sym (fnptr deferred)");
        /* Fastcall callees pass args via HL/DEHL — not via the stack.
           Bail out so the legacy walker handles these (it knows the
           per-arg register pinning). */
        if (n->sym->ctype && (n->sym->ctype->flags & FASTCALL))
            return build_fail("AST_FUNC_CALL to fastcall %s deferred",
                              n->sym->name);
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
        /* Width of the return vreg comes from the callee's return
           type — for long-returning functions this needs to be 4 so
           subsequent IR_ST_MEM / IR_MOV / etc. operate on all four
           bytes (the long-return convention is DEHL). Without this,
           crc32's `g = shr1(x)` silently truncated to int because the
           ret vreg was hardcoded to width 2 and ST_MEM IR_MEM_SYM
           then wrote only HL. */
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
        ci->fnptr_vreg = -1;
        ci->args       = args;
        ci->n_args     = n_args;
        ci->ret_vreg   = ret_v;
        /* ABI is determined by ctype flags. SMALLC = L→R push (z88dk
           default); absence = STDC = R→L push (matches C standard).
           CALLEE wins regardless: callee pops its own args. */
        uint32_t flags = n->sym->ctype ? n->sym->ctype->flags : 0;
        if (flags & CALLEE) {
            ci->abi = IR_ABI_CALLEE;
        } else if (flags & SMALLC) {
            ci->abi = IR_ABI_SMALLC;
        } else {
            ci->abi = IR_ABI_STDC;
        }
        ci->is_variadic = (n->sym->ctype && n->sym->ctype->funcattrs.hasva)
                          ? 1 : 0;
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
        int src_v = build_expr(b, n->operand);
        if (src_v < 0) return -1;
        if (src_w == dst_w) {
            /* Same-width cast (e.g. signed↔unsigned int) — no codegen. */
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
            b->f->vregs[dst].width = (int8_t)dst_w;
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
            b->f->vregs[dst].width = (int8_t)dst_w;
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
           write to the same vreg. */
        if (n->operand->ast_type == AST_LOCAL_VAR) {
            SYMBOL *lsym = n->operand->sym;
            int v = sym_map_get(b, lsym);
            if (v < 0)
                return build_fail("step on unknown local %s",
                                  lsym ? lsym->name : "?");
            OpKind step_op = is_inc ? IR_INC : IR_DEC;
            if (is_post) {
                int old = new_temp(b, 2);
                ir_emit_mov(cur_bb(b), old, v);
                ir_emit_unop(cur_bb(b), step_op, v, v);
                return old;
            }
            ir_emit_unop(cur_bb(b), step_op, v, v);
            return v;
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
        if (elem_w != 2 && elem_w != 4)
            return build_fail("post/pre step elem width %d not "
                              "yet supported (non-LV)", elem_w);

        /* Bare AST_LOCAL_VAR pointer operand (`(*q)++` where q is
           a pointer-typed local). build_expr would bail "bare
           AST_LOCAL_VAR outside lvalue context" — we want the
           local's *value* (the pointer), which sym_map already
           holds directly. Same shortcut as OP_ASSIGN's deref-LHS
           path takes. */
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
        b->f->vregs[old_v].width = (int8_t)elem_w;
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst       = old_v;
        ld->mem.kind  = IR_MEM_VREG;
        ld->mem.base  = ptr_v;
        ld->mem.elem  = (elem_w == 2) ? KIND_INT : KIND_LONG;

        int new_v = new_temp(b, elem_w);
        b->f->vregs[new_v].width = (int8_t)elem_w;
        if (elem_w == 2) {
            /* 16-bit step: single inc/dec hl after load. */
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
           marked addr-taken so the allocator keeps it in memory. */
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
        /* If the caller passed a hint vreg, write the ternary's value
           directly into it from both arms — no separate result temp,
           and the caller skips the wrapping MOV. */
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

    default:
        return build_fail("unsupported expr ast_type=%d", (int)n->ast_type);
    }
}

/* ----- Statement walker ------------------------------------------------ */

static int build_stmt(Builder *b, Node *n)
{
    if (!n) return 0;

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
        if (n->retval) {
            v = build_expr(b, n->retval);
            if (v < 0) return -1;
        }
        ir_emit_ret(cur_bb(b), v);
        return 0;
    }

    case AST_DECL: {
        /* Local declaration. Scalars (int-class or long) get a vreg
           sized for their value. Arrays (KIND_ARRAY) get a vreg whose
           slot is sym->size bytes — references decay to the address
           via IR_LEA. Init lists for arrays are not yet handled (the
           declvar branch only fires for scalar inits). */
        if (!n->sym)
            return build_fail("AST_DECL without sym");
        if ((Kind)n->sym->type == KIND_ARRAY) {
            /* Array byte count lives in sym->ctype->size. Bail on
               arrays > 127 bytes — VReg.width is int8_t and we
               overload it as the slot size. */
            int sz = n->sym->ctype ? n->sym->ctype->size : 0;
            if (sz <= 0 || sz > 127)
                return build_fail("AST_DECL array sym=%s size=%d "
                                  "out of int8_t slot range",
                                  n->sym->name, sz);
            (void)new_local_vreg(b, n->sym);
            /* declvar (initializer) for arrays would be an init list —
               not yet handled; fall through to legacy. */
            if (n->declvar)
                return build_fail("AST_DECL array init list not yet "
                                  "supported (sym=%s)", n->sym->name);
            return 0;
        }
        if (!is_supported_int_kind(n->sym->type))
            return build_fail("AST_DECL: kind %d not yet supported (sym=%s)",
                              (int)n->sym->type, n->sym->name);
        int v = new_local_vreg(b, n->sym);
        if (n->declvar) {
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

        /* header_bb: body, then dec + back-edge */
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

    case AST_IF:
    case AST_TERNARY: {
        /* Statement context: cond + then-stmt + optional else-stmt
           (AST_IF) / mandatory else-stmt (AST_TERNARY-as-stmt — the
           parser desugars `while` into this shape with else=goto).
           Empty then (e.g. `if (cond) ;`) is allowed; we still emit
           the cond test so any side-effects fire. */
        if (!n->cond)
            return build_fail("AST_IF/TERNARY stmt missing cond");
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
            n->ast_type == OP_DEREF) {
            /* OP_DEREF as a statement (#343) — discarded read, but
               the operand may carry side effects (`*p++;`, function
               call return, etc.). Walk as an expression; the loaded
               value just lands in a dead vreg. */
            int v = build_expr(b, n);
            (void)v;
            return v < 0 ? -1 : 0;
        }
        return build_fail("unsupported stmt ast_type=%d", (int)n->ast_type);
    }
}

/* ----- Public entry ---------------------------------------------------- */

int ir_generate_code(Node *body, SYMBOL *fn)
{
    if (!body) return 0;
    if (!fn)   return build_fail("ir_generate_code with NULL fn");
    cur_fn_name = (fn->name[0] ? fn->name : "?");

    Func *f = ir_func_new(fn);
    if (!f) return build_fail("ir_func_new returned NULL");

    /* Entry BB. */
    int entry = ir_bb_new(f);
    Builder b;
    builder_init(&b, f);
    b.cur_bb_id = entry;

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
            b.f->vregs[v].width = (int8_t)(pw ? pw : 2);
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
