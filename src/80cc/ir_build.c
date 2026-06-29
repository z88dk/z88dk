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
    /* Rebind an existing entry rather than appending a shadow. The legacy
       symbol table reuses one SYMBOL for same-named locals in sequential
       (non-overlapping) scopes — e.g. two `for (unsigned long i ...)` in a
       row. sym_map_get returns the FIRST match, so an append left the
       second `i`'s references resolving to the FIRST loop's vreg: the new
       loop's counter was never initialised and ran from a stale value. */
    for (int i = 0; i < b->sym_map_n; i++) {
        if (b->sym_map[i].sym == sym) {
            b->sym_map[i].vreg = vreg;
            return;
        }
    }
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

/* Float kinds the IR can currently lower (register tier only):
   KIND_FLOAT16 (always 2-byte _Float16, l_f16_* helpers, mode-
   independent) and KIND_DOUBLE *when* c_fp_size==4 (IEEE-32 / MBF-single
   / DAI / AM9511, l_f32_* helpers, DEHL). 5/6/8-byte doubles are the
   memory-FA tier and still bail to the walker. */
static int is_supported_float_kind(Kind k)
{
    return k == KIND_FLOAT16
        || (k == KIND_DOUBLE && c_fp_size == 4);
}

/* The value kind an operand actually produces. A function-pointer call
   node keeps its KIND_FUNC type because the call lowering still reads
   return_type/flags/funcattrs from it (direct calls are unwrapped to the
   return type by normalize_types; fnptr calls are not). For type
   inspection (e.g. choosing a float compare helper) we want the call's
   return kind, not KIND_FUNC. */
static Kind node_value_kind(Node *n)
{
    if (!n || !n->type) return KIND_NONE;
    if ((n->ast_type == AST_FUNCPTR_CALL || n->ast_type == AST_FUNC_CALL)
        && n->type->kind == KIND_FUNC && n->type->return_type)
        return n->type->return_type->kind;
    return n->type->kind;
}

/* Wide memory-accumulator float kind: KIND_DOUBLE in a 5/6-byte (d* /
   l_f48 family) or 8-byte (l_f64 / mbf64) format. Disjoint from
   is_supported_float_kind (the register tier).
   Works in both sp-mode and -frameix: the acc helpers clobber IX (their
   dcallee `pop ix` retaddr stash), so under -frameix a function using this
   tier is flagged `uses_acc` and the lowerer addresses sp-relative
   throughout, preserving the caller's IX with a plain push/pop rather than
   establishing an IX frame pointer. */
static int is_acc_float_kind(Kind k)
{
    return k == KIND_DOUBLE
        && (c_fp_size == 5 || c_fp_size == 6 || c_fp_size == 8);
}

/* True iff a symbol/type lives in a named address space (__addressmod).
   Its bank must be paged in (the page-in function) before access. The IR
   handles DIRECT scalar load/store of a namespaced global (lowerer emits
   the page-in call at the IR_MEM_SYM access) as well as INDIRECT access —
   array index (`arr[i]`) and pointer deref (`*p`) — by recovering the
   namespace from the pointee/element type and stamping the page-in fn onto
   MemOp.bank_fn, which the lowerer pages on at the IR_MEM_VREG access
   (matching sccz80, which pages for all of these). Only taking the ADDRESS
   of a namespaced symbol (`&g`) still bails — the namespace escapes into a
   plain pointer whose later deref site can't recover it. */
static int sym_is_namespaced(const SYMBOL *sym)
{
    return sym && sym->ctype && sym->ctype->namespace != NULL;
}
static int type_is_namespaced(const Type *t)
{
    return t && t->namespace != NULL;
}
/* Namespace name carried by a type itself OR by its pointee (a pointer/
   array type tags the space on ->ptr). NULL = default address space. */
static const char *type_or_pointee_ns(const Type *t)
{
    if (!t) return NULL;
    if (t->namespace) return t->namespace;
    if (t->ptr && t->ptr->namespace) return t->ptr->namespace;
    return NULL;
}
/* Page-in (bank) function for an indirect access through a deref/index
   node `n`: the value type (n->type) carries the namespace, or it lives on
   the pointer operand's pointee type. NULL for the default space. */
static const SYMBOL *deref_bank_fn(const Node *n)
{
    const char *ns = n ? type_or_pointee_ns(n->type) : NULL;
    if (!ns && n && n->operand)
        ns = type_or_pointee_ns(n->operand->type);
    return ns ? ir_namespace_bank_fn(ns) : NULL;
}

/* A __far pointer (KIND_CPTR): every access through it routes via an
   lp_* runtime helper (paging the bank in/out). Detected on the pointer
   node's own type. */
static int node_is_far_ptr(const Node *p)
{
    return p && p->type && p->type->kind == KIND_CPTR;
}

/* The lp_* far-access helper for an element of `kind`/`width`/`sign`.
   load=1 picks the lp_g* loaders, load=0 the lp_p* stores.

   Dispatch is by WIDTH with a few kind special-cases: a char carries its
   sign; a __far pointer element uses the D=0 ptr helpers; a wide (5/6/8B)
   double / long long routes through the accumulator helpers (FA /
   __i64_acc). 2- and 4-byte floats / fixes (_Float16, _Accum, the IEEE-32
   `double`) are plain HL / DEHL values, so they reuse the integer helpers
   — exactly as the walker does. Returns NULL only for widths with no far
   helper. (lp_gdoub/lp_glonglong may not exist in every maths lib — like
   the walker, we emit the call regardless and let the link resolve it.) */
static const char *far_helper(Kind elem, int width, int is_unsigned, int load)
{
    if (elem == KIND_CHAR)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (elem == KIND_CPTR)
        return load ? "lp_gptr" : "lp_pptr";
    if (elem == KIND_LONGLONG)
        return load ? "lp_glonglong" : "lp_i64_load"; /* sccz80's store name */
    if ((elem == KIND_DOUBLE || elem == KIND_FLOAT) && width >= 5)
        return load ? "lp_gdoub" : "lp_pdoub";        /* wide double → FA */
    if (width == 1)
        return load ? (is_unsigned ? "lp_guchar" : "lp_gchar") : "lp_pchar";
    if (width == 2)
        return load ? "lp_gint" : "lp_pint";
    if (width == 4)
        return load ? "lp_glong" : "lp_plong";
    return NULL;
}

/* Coerce a far-store RHS vreg to the element's in-register width. Wide
   (acc-tier double / long long) values pass through unchanged — they are
   already the right width from the front end and the lowerer's acc store
   handles them. Narrow values are TRUNC'd / ZX/SX'd to the element's
   register width (char→1, int/2-4B-float→2, long/cptr/4B-float→4).
   Returns the (possibly new) vreg, or -1 on error. */
static int far_store_value(Builder *b, const Node *n, Kind ek, int ew, int rhs_v)
{
    int wide = (ek == KIND_LONGLONG)
            || ((ek == KIND_DOUBLE || ek == KIND_FLOAT) && ew >= 5);
    if (wide) return rhs_v;
    int regw = (ek == KIND_CHAR || ew == 1) ? 1
             : (ek == KIND_LONG || ek == KIND_CPTR || ew == 4) ? 4 : 2;
    int rhs_w = b->f->vregs[rhs_v].width;
    if (rhs_w == regw) return rhs_v;
    int tmp = new_temp(b, regw);
    b->f->vregs[tmp].width = (int16_t)regw;
    if (ek == KIND_CPTR) b->f->vregs[tmp].kind = KIND_CPTR;
    OpKind cv = (rhs_w > regw)
        ? IR_CONV_TRUNC
        : (n->right && n->right->type && n->right->type->isunsigned
           ? IR_CONV_ZX : IR_CONV_SX);
    Op *cvo = ir_op_emit(cur_bb(b), cv);
    cvo->dst = tmp; cvo->src[0] = rhs_v;
    return tmp;
}

/* A FARACC symbol: a __banked global living in the far heap. Its address
   and every access route through the far machinery (l_far_mapaddr +
   lp_*), exactly like a __far pointer. */
static int sym_is_faracc(const SYMBOL *s)
{
    return s && s->ctype && (s->ctype->flags & FARACC);
}

/* Emit IR_LD_FARSYM: the far address (KIND_CPTR vreg) of a FARACC symbol. */
static int emit_far_symaddr(Builder *b, SYMBOL *sym)
{
    int fp = new_temp(b, 4);
    b->f->vregs[fp].width = 4;
    b->f->vregs[fp].kind  = KIND_CPTR;
    Op *op = ir_op_emit(cur_bb(b), IR_LD_FARSYM);
    op->dst = fp;
    op->mem.kind = IR_MEM_SYM;
    op->mem.sym  = sym;
    return fp;
}

/* Emit IR_LD_FAR: load element (ek/ew) through a far pointer vreg ptr_v.
   Result width/kind follow the helper-return convention: HL (char/int →
   width-2 promoted), DEHL (long / far-ptr / 4B float), or the accumulator
   (wide 5/6/8B double → FA, long long → __i64_acc). Returns the dst vreg. */
static int emit_far_load(Builder *b, int ptr_v, Kind ek, int ew, int is_uns)
{
    int wide = (ek == KIND_LONGLONG)
            || ((ek == KIND_DOUBLE || ek == KIND_FLOAT) && ew >= 5);
    int rw = wide ? ew
           : (ek == KIND_LONG || ek == KIND_CPTR || ew == 4) ? 4 : 2;
    int dst = new_temp(b, rw);
    b->f->vregs[dst].width = (int16_t)rw;
    if (ek == KIND_CPTR || wide || ew == 4)
        b->f->vregs[dst].kind = ek;
    Op *op = ir_op_emit(cur_bb(b), IR_LD_FAR);
    op->dst    = dst;
    op->src[0] = ptr_v;
    op->mem.elem = ek;
    op->imm      = is_uns;
    return dst;
}

/* Wide memory-accumulator integer kind: `long long` (width 8, the
   __i64_acc / l_i64_* set). Shares the IR_ACC_* layer with the float FA
   tier — distinguished by KIND (acc holds the RHS, the address-in-BC store
   convention, signed/unsigned helper variants). */
static int is_acc_int_kind(Kind k)
{
    return k == KIND_LONGLONG;
}

/* l_i64_* helper name for an i64 op stem. `is_unsigned` selects the *_u
   variants for mul/div/mod and the unsigned compares; add/sub/bitwise and
   eq/ne are sign-independent. Returns NULL for an unknown stem. */
static const char *acc_int_name(const char *stem, int is_unsigned)
{
    if (!strcmp(stem, "add")) return "l_i64_add";
    if (!strcmp(stem, "sub")) return "l_i64_sub";
    if (!strcmp(stem, "mul")) return is_unsigned ? "l_i64_mult_u" : "l_i64_mult";
    if (!strcmp(stem, "div")) return is_unsigned ? "l_i64_div_u"  : "l_i64_div";
    if (!strcmp(stem, "mod")) return is_unsigned ? "l_i64_mod_u"  : "l_i64_mod";
    if (!strcmp(stem, "and")) return "l_i64_and";
    if (!strcmp(stem, "or"))  return "l_i64_or";
    if (!strcmp(stem, "xor")) return "l_i64_xor";
    if (!strcmp(stem, "shl")) return "l_i64_asl";
    if (!strcmp(stem, "shr")) return is_unsigned ? "l_i64_asr_u" : "l_i64_asr";
    if (!strcmp(stem, "lt"))  return is_unsigned ? "l_i64_ult" : "l_i64_lt";
    if (!strcmp(stem, "le"))  return is_unsigned ? "l_i64_ule" : "l_i64_le";
    if (!strcmp(stem, "gt"))  return is_unsigned ? "l_i64_ugt" : "l_i64_gt";
    if (!strcmp(stem, "ge"))  return is_unsigned ? "l_i64_uge" : "l_i64_ge";
    if (!strcmp(stem, "eq"))  return "l_i64_eq";
    if (!strcmp(stem, "ne"))  return "l_i64_ne";
    return NULL;
}

/* Accumulator-tier helper name for an op stem, by the active maths
   width: 5/6-byte uses the d* / genmath set, 8-byte (mbf64) the
   l_f64_* set. Mirrors map_library_routine's fp_48bit / fp_64bit
   columns. Returns NULL for "loadpush" at width 8 (no combined
   primitive there) and for unknown stems. */
static const char *acc_name(const char *stem)
{
    int f64 = (c_fp_size == 8);
    if (!strcmp(stem, "load"))     return f64 ? "l_f64_load"  : "dload";
    if (!strcmp(stem, "store"))    return f64 ? "l_f64_store" : "dstore";
    if (!strcmp(stem, "push"))     return f64 ? "l_f64_dpush" : "dpush";
    if (!strcmp(stem, "loadpush")) return f64 ? NULL          : "dldpsh";
    if (!strcmp(stem, "add"))      return f64 ? "l_f64_add" : "dadd";
    if (!strcmp(stem, "sub"))      return f64 ? "l_f64_sub" : "dsub";
    if (!strcmp(stem, "mul"))      return f64 ? "l_f64_mul" : "dmul";
    if (!strcmp(stem, "div"))      return f64 ? "l_f64_div" : "ddiv";
    if (!strcmp(stem, "lt"))       return f64 ? "l_f64_lt"  : "dlt";
    if (!strcmp(stem, "le"))       return f64 ? "l_f64_le"  : "dleq";
    if (!strcmp(stem, "gt"))       return f64 ? "l_f64_gt"  : "dgt";
    if (!strcmp(stem, "ge"))       return f64 ? "l_f64_ge"  : "dge";
    if (!strcmp(stem, "eq"))       return f64 ? "l_f64_eq"  : "deq";
    if (!strcmp(stem, "ne"))       return f64 ? "l_f64_ne"  : "dne";
    if (!strcmp(stem, "neg"))      return f64 ? "l_f64_neg"    : "minusfa";
    if (!strcmp(stem, "ftof16"))   return f64 ? "l_f64_ftof16" : "l_f48_ftof16";
    if (!strcmp(stem, "f16tof"))   return f64 ? "l_f64_f16tof" : "l_f48_f16tof";
    if (!strcmp(stem, "sint2f"))   return f64 ? "l_f64_sint2f"  : "l_int2long_s_float";
    if (!strcmp(stem, "uint2f"))   return f64 ? "l_f64_uint2f"  : "l_int2long_u_float";
    if (!strcmp(stem, "slong2f"))  return f64 ? "l_f64_slong2f" : "float";
    if (!strcmp(stem, "ulong2f"))  return f64 ? "l_f64_ulong2f" : "ufloat";
    if (!strcmp(stem, "f2sint"))   return f64 ? "l_f64_f2sint"  : "ifix";
    if (!strcmp(stem, "f2slong"))  return f64 ? "l_f64_f2slong" : "ifix";
    return NULL;
}

/* Helper name for a float op on kind k, mirroring map_library_routine:
   KIND_FLOAT16 -> l_f16_*; supported KIND_DOUBLE -> l_f32_*. `base` is
   the op stem ("add","lt","sint2f",…). Returns NULL when the kind/width
   is not IR-supported, so callers bail. Names are literals (persist for
   the lifetime of the HelperInfo, which never frees ->name). */
static const char *float_helper(Kind k, const char *base)
{
    static const struct { const char *base, *f16, *f32; } m[] = {
        { "add", "l_f16_add", "l_f32_add" },
        { "sub", "l_f16_sub", "l_f32_sub" },
        { "mul", "l_f16_mul", "l_f32_mul" },
        { "div", "l_f16_div", "l_f32_div" },
        { "lt",  "l_f16_lt",  "l_f32_lt"  },
        { "le",  "l_f16_le",  "l_f32_le"  },
        { "gt",  "l_f16_gt",  "l_f32_gt"  },
        { "ge",  "l_f16_ge",  "l_f32_ge"  },
        { "eq",  "l_f16_eq",  "l_f32_eq"  },
        { "ne",  "l_f16_ne",  "l_f32_ne"  },
        { "sint2f",  "l_f16_sint2f",  "l_f32_sint2f"  },
        { "uint2f",  "l_f16_uint2f",  "l_f32_uint2f"  },
        { "slong2f", "l_f16_slong2f", "l_f32_slong2f" },
        { "ulong2f", "l_f16_ulong2f", "l_f32_ulong2f" },
        { "f2sint",  "l_f16_f2sint",  "l_f32_f2sint"  },
        { "f2uint",  "l_f16_f2uint",  "l_f32_f2uint"  },
        { "f2slong", "l_f16_f2slong", "l_f32_f2slong" },
        { "f2ulong", "l_f16_f2ulong", "l_f32_f2ulong" },
        { "ftof16",  NULL,            "l_f32_ftof16"  },
        { "f16tof",  NULL,            "l_f32_f16tof"  },
        { NULL, NULL, NULL }
    };
    int is16 = (k == KIND_FLOAT16);
    int is32 = (k == KIND_DOUBLE && c_fp_size == 4);
    if (!is16 && !is32) return NULL;
    for (int i = 0; m[i].base; i++)
        if (strcmp(m[i].base, base) == 0)
            return is16 ? m[i].f16 : m[i].f32;
    return NULL;
}

/* Width in bytes for the integer/fix kinds we care about. Returns 0
   for anything outside the supported set so callers can bail. */
static int width_for_kind(Kind k)
{
    if (k == KIND_CHAR)  return 1;
    if (k == KIND_INT || k == KIND_SHORT || k == KIND_PTR
        || k == KIND_ACCUM16 || k == KIND_FLOAT16) return 2;
    /* __far pointer (KIND_CPTR): modelled as a width-4 DEHL value
       (D=0, E=bank, HL=offset) — the low 3 bytes of a long. Reuses the
       long-tier register residency / arg-push / return ABI. The far
       pointer is 3 bytes in *memory* (load/store specialised below) but
       4 bytes in registers. */
    if (k == KIND_CPTR) return 4;
    if (k == KIND_LONG || k == KIND_ACCUM32)  return 4;
    if (k == KIND_LONGLONG) return 8;
    if (k == KIND_DOUBLE || k == KIND_FLOAT)  return c_fp_size;
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

/* Emit a float arithmetic HCALL computing `lv <op> rv` for a supported
   float kind fk (stem "add"/"sub"/"mul"/"div"). Returns the result vreg
   (width = the float's), or -1 if fk is unsupported. Left operand
   pushed, right in HL/DEHL, result in HL/DEHL — the l_f{16,32}_* ABI. */
static int emit_float_arith(Builder *b, Kind fk, const char *stem,
                            int lv, int rv)
{
    const char *name = float_helper(fk, stem);
    if (!name) return -1;
    int fw = width_for_kind(fk);
    int dst = new_temp(b, fw);
    b->f->vregs[dst].width = (int16_t)fw;
    b->f->vregs[dst].kind  = fk;
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2;
    hi->n_stacked = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* Emit a wide memory-accumulator binop (IR_ACC_BINOP) for a 5/6-byte
   double: stem "add"/"sub"/"mul"/"div" → dadd/dsub/dmul/ddiv (FA model,
   acc holds LHS). Returns the result vreg (width c_fp_size) or -1. */
static int emit_acc_binop(Builder *b, const char *stem, int lv, int rv)
{
    const char *name = acc_name(stem);
    if (!name) return -1;
    int w = c_fp_size;
    int dst = new_temp(b, w);
    b->f->vregs[dst].width = (int16_t)w;
    b->f->vregs[dst].kind  = KIND_DOUBLE;
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_BINOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_push = acc_name("push"); hi->acc_loadpush = acc_name("loadpush");
    hi->acc_width = w; hi->acc_holds_lhs = 0; hi->acc_store_bc = 0;
    op->hcall = hi;
    return dst;
}

/* int/long → 5/6-byte double (IR_ACC_UNOP, subkind 0): l_int2long_{s,u}_float
   (HL source) or float/ufloat (DEHL source). Result width c_fp_size. */
static int emit_acc_from_int(Builder *b, int src_v, int src_unsigned)
{
    int sw = b->f->vregs[src_v].width;
    const char *name = acc_name((sw == 4)
        ? (src_unsigned ? "ulong2f" : "slong2f")
        : (src_unsigned ? "uint2f"  : "sint2f"));
    int w = c_fp_size;
    int dst = new_temp(b, w);
    b->f->vregs[dst].width = (int16_t)w;
    b->f->vregs[dst].kind  = KIND_DOUBLE;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_width = w; hi->acc_subkind = ACC_SUB_INT2ACC;
    op->hcall = hi;
    return dst;
}

/* 5/6-byte double → int/long (IR_ACC_UNOP, subkind 1): ifix. ifix
   returns the full DEHL (signed long); a width-2 dst takes HL, a width-4
   dst takes DEHL (gen_acc_unop picks the store by dst width). */
static int emit_acc_to_int(Builder *b, int src_v, int ret_w)
{
    int dst = new_temp(b, ret_w);
    b->f->vregs[dst].width = (int16_t)ret_w;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = acc_name((ret_w == 4) ? "f2slong" : "f2sint");
    hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_width = c_fp_size; hi->acc_subkind = ACC_SUB_ACC2INT;
    op->hcall = hi;
    return dst;
}

/* Unary negate of a 5/6/8-byte double (IR_ACC_UNOP, subkind 4): load the
   value into FA, call minusfa / l_f64_neg (in-place sign flip), store FA
   back. Matches the walker's `dload; minusfa`. A sign-bit XOR would be
   format-specific (MBF's sign isn't the value's top bit), so the helper
   is the safe path. */
static int emit_acc_float_neg(Builder *b, int src_v)
{
    int w = c_fp_size;
    int dst = new_temp(b, w);
    b->f->vregs[dst].width = (int16_t)w;
    b->f->vregs[dst].kind  = KIND_DOUBLE;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = acc_name("neg"); hi->args = args; hi->n_args = 1;
    hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_width = w; hi->acc_subkind = ACC_SUB_ACC_UNARY;
    op->hcall = hi;
    return dst;
}

/* ----- long long (width-8 __i64_acc) builders ------------------------- */

/* Wide-accumulator i64 binop (IR_ACC_BINOP): stem add/sub/mul/div/mod/
   and/or/xor → l_i64_*. acc holds the RHS (`acc_holds_lhs=0`), LHS pushed;
   the helper self-pops the pushed operand. Result address goes to the
   store in BC (`acc_store_bc`). Returns the width-8 result vreg or -1. */
static int emit_acc_int_binop(Builder *b, const char *stem,
                              int lv, int rv, int is_unsigned)
{
    const char *name = acc_int_name(stem, is_unsigned);
    if (!name) return -1;
    int dst = new_temp(b, 8);
    b->f->vregs[dst].width = 8;
    b->f->vregs[dst].kind  = KIND_LONGLONG;
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_BINOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_push = "l_i64_push"; hi->acc_loadpush = NULL;
    hi->acc_width = 8; hi->acc_holds_lhs = 0; hi->acc_store_bc = 1;
    op->hcall = hi;
    return dst;
}

/* Wide-accumulator i64 compare (IR_ACC_CMP): l_i64_{lt,le,gt,ge,eq,ne}
   (+ unsigned ult/… variants) → int 0/1 bool in HL. Same push/load dance
   as the binop; no accumulator store. Returns the width-2 int dst or -1. */
static int emit_acc_int_cmp(Builder *b, const char *cstem,
                            int lv, int rv, int is_unsigned)
{
    const char *name = acc_int_name(cstem, is_unsigned);
    if (!name) return -1;
    int dst = new_temp(b, 2);
    b->f->vregs[dst].width = 2;
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_CMP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_push = "l_i64_push";
    hi->acc_loadpush = NULL;
    hi->acc_width = 8; hi->acc_holds_lhs = 0;
    op->hcall = hi;
    return dst;
}

/* int/long → i64 (IR_ACC_UNOP subkind 0): l_i64_{s,u}{int,long}2i64. The
   helpers take HL (int) / DEHL (long); char/byte sources are widened to
   int first by the caller. Result is the width-8 acc value. */
static int emit_acc_int_from_int(Builder *b, int src_v, int src_unsigned)
{
    int sw = b->f->vregs[src_v].width;
    const char *name = (sw == 4)
        ? (src_unsigned ? "l_i64_ulong2i64" : "l_i64_slong2i64")
        : (src_unsigned ? "l_i64_uint2i64"  : "l_i64_sint2i64");
    int dst = new_temp(b, 8);
    b->f->vregs[dst].width = 8;
    b->f->vregs[dst].kind  = KIND_LONGLONG;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_width = 8; hi->acc_subkind = ACC_SUB_INT2ACC; hi->acc_store_bc = 1;
    op->hcall = hi;
    return dst;
}

/* Promote an already-built operand to the i64 acc tier when it isn't
   already long long — the implicit C promotion in a mixed `ll OP int`
   (e.g. `(long long)a + 3`, where the literal stays int). Each operand
   widens by its own signedness. */
static int promote_to_acc_int(Builder *b, int v, int uns)
{
    if ((int)b->f->vregs[v].kind == KIND_LONGLONG)
        return v;
    if (b->f->vregs[v].width == 1) {
        int wt = new_temp(b, 2);
        b->f->vregs[wt].width = 2;
        Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
        cv->dst = wt; cv->src[0] = v; v = wt;
    }
    return emit_acc_int_from_int(b, v, uns);
}

/* Load a wide (long long / 5-8B double) constant from the const.c literal
   pool: emit `ld hl,i_<litlab>` + the wide-load helper (IR_MEM_POOL,
   dispatched on the dst KIND by the lowerer). Returns the wide dst vreg. */
static int emit_pool_load(Builder *b, int litlab, int width, Kind kind)
{
    int dst = new_temp(b, width);
    b->f->vregs[dst].width = (int16_t)width;
    b->f->vregs[dst].kind  = kind;
    Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
    op->dst       = dst;
    op->mem.kind  = IR_MEM_POOL;
    op->mem.offset = litlab;
    op->mem.base  = -1;
    op->mem.elem  = kind;
    return dst;
}

/* i64 → int/long (IR_ACC_UNOP subkind 1): l_i64_s64_toi32 truncates the
   accumulator to DEHL; a width-2 dst takes HL, width-4 takes DEHL. */
static int emit_acc_int_to_int(Builder *b, int src_v, int ret_w)
{
    int dst = new_temp(b, ret_w);
    b->f->vregs[dst].width = (int16_t)ret_w;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = "l_i64_s64_toi32";
    hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_width = 8; hi->acc_subkind = ACC_SUB_ACC2INT;
    op->hcall = hi;
    return dst;
}

/* l_f48_ / l_f64_ helper name for a long long <-> 5/6/8-byte double
   conversion, by the active maths width (8 -> l_f64_, else l_f48_; 5 and 6
   share the f48 column). stem: sllong2f/ullong2f (ll->double) or
   f2sllong/f2ullong (double->ll). Mirrors map_library_routine's
   fp_48bit/fp_64bit columns. */
static const char *acc_lldouble_name(const char *stem)
{
    int f64 = (c_fp_size == 8);
    if (!strcmp(stem, "sllong2f")) return f64 ? "l_f64_sllong2f" : "l_f48_sllong2f";
    if (!strcmp(stem, "ullong2f")) return f64 ? "l_f64_ullong2f" : "l_f48_ullong2f";
    if (!strcmp(stem, "f2sllong")) return f64 ? "l_f64_f2sllong" : "l_f48_f2sllong";
    if (!strcmp(stem, "f2ullong")) return f64 ? "l_f64_f2ullong" : "l_f48_f2ullong";
    return NULL;
}

/* long long <-> 5/6/8-byte double conversion (IR_ACC_UNOP subkind 3, a
   cross-accumulator op: __i64_acc <-> FA). `to_double` picks the
   direction. Source loaded with its family's load, result stored with the
   destination family's store. Returns the dst vreg. */
static int emit_acc_lldouble(Builder *b, int src_v, int to_double, int is_unsigned)
{
    const char *name = acc_lldouble_name(
        to_double ? (is_unsigned ? "ullong2f" : "sllong2f")
                  : (is_unsigned ? "f2ullong" : "f2sllong"));
    if (!name) return -1;
    int dst_w = to_double ? c_fp_size : 8;
    Kind dst_k = to_double ? KIND_DOUBLE : KIND_LONGLONG;
    int dst = new_temp(b, dst_w);
    b->f->vregs[dst].width = (int16_t)dst_w;
    b->f->vregs[dst].kind  = dst_k;
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_subkind = ACC_SUB_CROSS;
    if (to_double) {        /* src ll (l_i64_load) → dst double (dstore) */
        hi->acc_load = "l_i64_load";
        hi->acc_store = acc_name("store");
        hi->acc_store_bc = 0;
    } else {                /* src double (dload) → dst ll (l_i64_store, BC) */
        hi->acc_load = acc_name("load");
        hi->acc_store = "l_i64_store";
        hi->acc_store_bc = 1;
    }
    op->hcall = hi;
    return dst;
}

/* Float compound-assign `lhs op= rhs` (stem "add"/"sub"/"mul"/"div").
   n->left is OP_DEREF(lvalue); the lvalue may be a local, global, or
   *ptr. Loads the lvalue, computes via the float helper, stores back.
   Both operands must be the same IR-supported float kind (the front end
   converts the rhs); otherwise bail to the walker. */
static int build_float_compound(Builder *b, Node *n, const char *stem)
{
    if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
        return build_fail("float compound-assign LHS shape not supported");
    Kind fk = n->left->type ? n->left->type->kind : KIND_NONE;
    int is_acc = is_acc_float_kind(fk);
    if (!is_supported_float_kind(fk) && !is_acc)
        return build_fail("float compound-assign: unsupported kind %d", (int)fk);
    if (!n->right || !n->right->type || n->right->type->kind != fk)
        return build_fail("float compound-assign: rhs kind mismatch");
    Node *lvn = n->left->operand;
    int fw = width_for_kind(fk);
    Kind elem = is_acc ? KIND_DOUBLE : (fw == 2) ? KIND_INT : KIND_LONG;
    #define COMPOUND_ARITH(LV) (is_acc \
        ? emit_acc_binop(b, stem, (LV), rv) \
        : emit_float_arith(b, fk, stem, (LV), rv))

    int rv = build_expr(b, n->right);
    if (rv < 0) return -1;

    if (lvn->ast_type == AST_LOCAL_VAR) {
        int lhs_v = lvn->sym ? sym_map_get(b, lvn->sym) : -1;
        if (lhs_v < 0)
            return build_fail("float compound-assign: unknown local");
        int res = COMPOUND_ARITH(lhs_v);
        if (res < 0) return -1;
        ir_emit_mov(cur_bb(b), lhs_v, res);
        return lhs_v;
    }
    if (lvn->ast_type == AST_GLOBAL_VAR) {
        SYMBOL *g = lvn->sym;
        if (!g) return build_fail("float compound-assign: null global");
        int loaded = new_temp(b, fw);
        b->f->vregs[loaded].width = (int16_t)fw;
        b->f->vregs[loaded].kind  = fk;
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst = loaded; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = g;
        int res = COMPOUND_ARITH(loaded);
        if (res < 0) return -1;
        Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
        st->src[0] = res; st->mem.kind = IR_MEM_SYM; st->mem.sym = g;
        return res;
    }
    /* *ptr op= rhs (pages the bank on both load and store if namespaced) */
    SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
    int ptr_v = build_expr(b, lvn);
    if (ptr_v < 0) return -1;
    int loaded = new_temp(b, fw);
    b->f->vregs[loaded].width = (int16_t)fw;
    b->f->vregs[loaded].kind  = fk;
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = loaded; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = ptr_v; ld->mem.elem = elem;
    ld->mem.bank_fn = bf;
    int res = COMPOUND_ARITH(loaded);
    if (res < 0) return -1;
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0] = res; st->mem.kind = IR_MEM_VREG;
    st->mem.base = ptr_v; st->mem.elem = elem;
    st->mem.bank_fn = bf;
    return res;
    #undef COMPOUND_ARITH
}

/* long long compound-assign `lhs op= rhs` via the acc-int tier
   (load-modify-store, l_i64_*). stem add/sub/mul/div/mod/and/or/xor.
   ast_opt folds `x = x OP y` into these OP_A* nodes, so this is the path
   a self-referential ll assignment takes. Local, global, and *ptr LHS. */
static int build_ll_compound(Builder *b, Node *n, const char *stem)
{
    if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
        return build_fail("ll compound-assign LHS shape not supported");
    Kind fk = n->left->type ? n->left->type->kind : KIND_NONE;
    if (!is_acc_int_kind(fk))
        return build_fail("ll compound-assign: LHS not long long");
    if (!n->right || !n->right->type)
        return build_fail("ll compound-assign: rhs has no type");
    Node *lvn = n->left->operand;
    /* For a shift the helper signedness is the shifted (LHS) operand's —
       the count's signedness is irrelevant (and `<<` ignores it). Other
       ops use the usual either-operand-unsigned rule. */
    int is_shift = (!strcmp(stem, "shl") || !strcmp(stem, "shr"));
    int is_uns = is_shift
        ? n->left->type->isunsigned
        : (n->left->type->isunsigned || n->right->type->isunsigned);
    int rv = build_expr(b, n->right);
    if (rv < 0) return -1;
    /* Promote a narrower rhs to long long (`x += 3`). */
    rv = promote_to_acc_int(b, rv, n->right->type->isunsigned);
    if (rv < 0) return -1;

    if (lvn->ast_type == AST_LOCAL_VAR) {
        int lhs_v = lvn->sym ? sym_map_get(b, lvn->sym) : -1;
        if (lhs_v < 0) return build_fail("ll compound-assign: unknown local");
        int res = emit_acc_int_binop(b, stem, lhs_v, rv, is_uns);
        if (res < 0) return -1;
        ir_emit_mov(cur_bb(b), lhs_v, res);
        return lhs_v;
    }
    if (lvn->ast_type == AST_GLOBAL_VAR) {
        SYMBOL *g = lvn->sym;
        if (!g) return build_fail("ll compound-assign: null global");
        int loaded = new_temp(b, 8);
        b->f->vregs[loaded].width = 8; b->f->vregs[loaded].kind = KIND_LONGLONG;
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst = loaded; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = g;
        ld->mem.elem = KIND_LONGLONG;
        int res = emit_acc_int_binop(b, stem, loaded, rv, is_uns);
        if (res < 0) return -1;
        Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
        st->src[0] = res; st->mem.kind = IR_MEM_SYM; st->mem.sym = g;
        st->mem.elem = KIND_LONGLONG;
        return res;
    }
    /* *ptr op= rhs (pages the bank on both load and store if namespaced) */
    SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
    int ptr_v = build_expr(b, lvn);
    if (ptr_v < 0) return -1;
    int loaded = new_temp(b, 8);
    b->f->vregs[loaded].width = 8; b->f->vregs[loaded].kind = KIND_LONGLONG;
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = loaded; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = ptr_v; ld->mem.elem = KIND_LONGLONG;
    ld->mem.bank_fn = bf;
    int res = emit_acc_int_binop(b, stem, loaded, rv, is_uns);
    if (res < 0) return -1;
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0] = res; st->mem.kind = IR_MEM_VREG;
    st->mem.base = ptr_v; st->mem.elem = KIND_LONGLONG;
    st->mem.bank_fn = bf;
    return res;
}

/* Address of an aggregate (struct/union/array) lvalue node into a fresh
   vreg, used by whole-aggregate copy and by-value argument passing. Mirrors
   the OP_ADDR shapes: a bare global → IR_LD_SYM; a bare local → IR_LEA (slot
   marked addr-taken); a folded address expression (`(+ base K)` / deref) is
   already an address, so just evaluate it. Returns -1 (with build_fail) for
   shapes that don't yield a stable address. */
static int agg_lvalue_addr(Builder *b, Node *node)
{
    if (!node) return build_fail("aggregate address of NULL node");
    if (node->ast_type == AST_GLOBAL_VAR && node->sym
        && !sym_is_faracc(node->sym) && !sym_is_namespaced(node->sym)) {
        int addr = new_temp(b, 2); b->f->vregs[addr].width = 2;
        Op *op = ir_op_emit(cur_bb(b), IR_LD_SYM);
        op->dst = addr; op->mem.kind = IR_MEM_SYM; op->mem.sym = node->sym;
        return addr;
    }
    if (node->ast_type == AST_LOCAL_VAR && node->sym) {
        int src = sym_map_get(b, node->sym);
        if (src < 0) return build_fail("aggregate address of unknown local %s",
                                       node->sym->name);
        b->f->vregs[src].flags |= IR_VREG_ADDR_TAKEN;
        int addr = new_temp(b, 2); b->f->vregs[addr].width = 2;
        Op *op = ir_op_emit(cur_bb(b), IR_LEA);
        op->dst = addr; op->src[0] = src;
        return addr;
    }
    /* `*ptr` as an aggregate lvalue: its address is the pointer value, i.e.
       the deref's operand — NOT a load through it (build_expr on the deref
       itself would try to load the aggregate). */
    if (node->ast_type == OP_DEREF)
        return build_expr(b, node->operand);
    /* `&arr[i]` / `&s.m` fold to an additive address expression that already
       computes the address. */
    if (node->ast_type == OP_ADD || node->ast_type == OP_SUB)
        return build_expr(b, node);
    return build_fail("aggregate address lvalue shape deferred");
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
        /* Float literal (typed float, or a float constant being
           implicitly converted into a float dst): materialise the raw
           bit pattern, NOT a truncated integer. _Float16 is always
           IEEE16 (mode-independent, 2 bytes); KIND_DOUBLE uses the
           active maths mode (only the width-4 modes are IR-supported). */
        Kind lit_target = (hint >= 0) ? (Kind)b->f->vregs[hint].kind
                                      : KIND_NONE;
        Kind lit_fk = (lit_target == KIND_FLOAT16
                       || (n->type && n->type->kind == KIND_FLOAT16))
                          ? KIND_FLOAT16
                    : (lit_target == KIND_DOUBLE
                       || (n->type && kind_is_floating(n->type->kind)))
                          ? KIND_DOUBLE
                    : KIND_NONE;
        if (lit_fk == KIND_FLOAT16) {
            unsigned char fa[8];
            dofloat(MATHS_IEEE16, (double)n->zval, fa);
            int fv = new_temp(b, 2);
            b->f->vregs[fv].width = 2;
            b->f->vregs[fv].kind  = KIND_FLOAT16;
            ir_emit_ld_imm(cur_bb(b), fv,
                           (int64_t)(((int)fa[1] << 8) | fa[0]));
            return fv;
        }
        if (lit_fk == KIND_DOUBLE && is_supported_float_kind(KIND_DOUBLE)) {
            unsigned char fa[8];
            dofloat(c_maths_mode, (double)n->zval, fa);
            int fv = new_temp(b, 4);
            b->f->vregs[fv].width = 4;
            b->f->vregs[fv].kind  = KIND_DOUBLE;
            uint32_t bits = ((uint32_t)fa[3] << 24) | ((uint32_t)fa[2] << 16)
                          | ((uint32_t)fa[1] << 8)  | (uint32_t)fa[0];
            ir_emit_ld_imm(cur_bb(b), fv, (int64_t)bits);
            return fv;
        }
        if (lit_fk == KIND_DOUBLE)
            /* 5/6/8-byte double literal: materialise the FA bit pattern in
               the const.c literal pool and dload it. (Width-2/4 f16/f32
               literals were handled above as immediates.) */
            return emit_pool_load(b, ir_pool_litlab_double(n->zval),
                                  c_fp_size, KIND_DOUBLE);
        /* long long literal: the width-1/2/4 path below would clamp it to
           an int. Values fitting in signed/unsigned 32 bits materialise
           cheaply via a long LD_IMM widened through l_i64_*int2i64; wider
           constants come from the literal pool (l_i64_load). */
        if ((n->type && n->type->kind == KIND_LONGLONG)
            || lit_target == KIND_LONGLONG) {
            if (n->zval < -2147483648.0L || n->zval > 4294967295.0L)
                return emit_pool_load(b, ir_pool_litlab_llong(n->zval),
                                      8, KIND_LONGLONG);
            int64_t val = (int64_t)n->zval;
            /* Extend by the VALUE, not the declared signedness: a negative
               (or signed-32-fitting) value sign-extends; a value in
               (2^31, 2^32) zero-extends. Keying off the type's isunsigned
               zero-extended `(long long)-1` to 0x00000000FFFFFFFF. */
            int ext_uns = (val > 2147483647LL);
            int lt = new_temp(b, 4);
            b->f->vregs[lt].width = 4;
            ir_emit_ld_imm(cur_bb(b), lt, val & 0xffffffffLL);
            return emit_acc_int_from_int(b, lt, ext_uns);
        }
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
        /* FARACC (`__banked`) global: lives in the far heap. Its rvalue
           is a far access — map the far address (l_far_mapaddr) then read
           through it (lp_g*), instead of a plain near `ld hl,(_g)` (which
           silently dropped the banking). */
        if (n->sym && sym_is_faracc(n->sym)
            && (Kind)n->sym->type != KIND_ARRAY
            && (Kind)n->sym->type != KIND_STRUCT
            && (Kind)n->sym->type != KIND_FUNC) {
            Kind ek = (Kind)n->sym->type;
            int  ew = type_width(n->type);   /* NULL → 2 */
            if (!far_helper(ek, ew, n->type && n->type->isunsigned, 1))
                return build_fail("FARACC load kind %d width %d deferred",
                                  ek, ew);
            int fp = emit_far_symaddr(b, n->sym);
            return emit_far_load(b, fp, ek, ew,
                                 n->type && n->type->isunsigned);
        }
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
        /* Wide long long global: set the vreg KIND so the wide load picks
           l_i64_load rather than the float dload. */
        if (gv_w == 8 && n->sym && is_acc_int_kind((Kind)n->sym->type))
            b->f->vregs[v].kind = KIND_LONGLONG;
        Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
        op->dst = v;
        op->mem.kind = IR_MEM_SYM;
        op->mem.sym  = n->sym;
        /* __far pointer VALUE (3 bytes in memory): tag the vreg + load so
           the lowerer does the 3-byte read (`ld hl,(sym); ld de,(sym+2);
           ld d,0`) instead of a 4-byte long read that would pull a
           garbage 4th byte. */
        if (n->sym && (Kind)n->sym->type == KIND_CPTR) {
            b->f->vregs[v].kind = KIND_CPTR;
            op->mem.elem = KIND_CPTR;
        }
        return v;
    }

    case OP_DEREF:
        /* Bitfield rvalue: a member access folds to a plain deref whose
           TYPE carries bit_offset/bit_size. Load the whole storage unit,
           shift the field down to bit 0, then mask to its width. (Was a
           silent miscompile — the deref loaded the unit unmasked.) Signed
           bitfields need sign-extension of the masked value — defer those
           to the walker for now. */
        if (n->type && n->type->bit_size > 0) {
            int bsize = n->type->bit_size;
            int boff  = n->type->bit_offset;
            n->type->bit_size = 0;          /* load the plain storage unit */
            int cont = build_expr(b, n);
            n->type->bit_size = (int16_t)bsize;
            if (cont < 0) return -1;
            int val = cont;
            if (boff > 0) {
                int t = new_temp(b, 2); b->f->vregs[t].width = 2;
                Op *sh = ir_op_emit(cur_bb(b), IR_SHR);
                sh->dst = t; sh->src[0] = val; sh->src[1] = -1; sh->imm = boff;
                val = t;
            }
            int m = new_temp(b, 2); b->f->vregs[m].width = 2;
            Op *an = ir_op_emit(cur_bb(b), IR_AND);
            an->dst = m; an->src[0] = val; an->src[1] = -1;
            an->imm = ((int64_t)1 << bsize) - 1;
            /* Signed bitfield: sign-extend the bsize-bit value. Branchless
               `(x ^ sb) - sb` with sb = 1<<(bsize-1) (avoids the IR's
               logical-only shift-right). */
            if (!n->type->isunsigned && bsize < 16) {
                int64_t sb = (int64_t)1 << (bsize - 1);
                int x = new_temp(b, 2); b->f->vregs[x].width = 2;
                Op *xo = ir_op_emit(cur_bb(b), IR_XOR);
                xo->dst = x; xo->src[0] = m; xo->src[1] = -1; xo->imm = sb;
                int r = new_temp(b, 2); b->f->vregs[r].width = 2;
                Op *su = ir_op_emit(cur_bb(b), IR_SUB);
                su->dst = r; su->src[0] = x; su->src[1] = -1; su->imm = sb;
                return r;
            }
            return m;
        }
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
            ld->mem.bank_fn = (SYMBOL *)deref_bank_fn(n);  /* `*p++` into a space */
            if (!is_pre) EMIT_BUMP();
            #undef EMIT_BUMP

            return dst;
        }
        /* __far pointer deref (`*fp`, `fp[const]`): every access routes
           through an lp_g* helper that pages the bank. Materialize the far
           pointer VALUE (DEHL: D=0, E=bank, HL=offset), then IR_LD_FAR.

           The far ACCESS is the OUTER deref of a far-pointer VALUE. A
           plain variable read (`OP_DEREF(AST_GLOBAL_VAR fp)` / the local
           vreg) is the INNER deref that produces that value from near
           memory — NOT a far access. The parser nests these
           (`*fp` = OP_DEREF(OP_DEREF(gv fp))), so a bare-lvalue operand is
           the inner read; exclude it (it routes to the 3-byte value
           load below). */
        if (node_is_far_ptr(n->operand)
            && n->operand->ast_type != AST_GLOBAL_VAR
            && n->operand->ast_type != AST_LOCAL_VAR) {
            int ptr_v = build_expr(b, n->operand);
            if (ptr_v < 0) return -1;
            Kind ek    = n->type ? n->type->kind : KIND_INT;
            int is_uns = n->type ? n->type->isunsigned : 0;
            int ew     = type_width(n->type);
            if (!far_helper(ek, ew, is_uns, 1))
                return build_fail("__far load of element kind %d width %d "
                                  "deferred", ek, ew);
            /* Result width: a char/int promotes into HL (width-2); long /
               far-ptr / 4-byte float into DEHL (width-4); a wide (5/6/8B)
               double lands in FA and long long in __i64_acc (the lowerer's
               width>4 acc path). */
            int wide = (ek == KIND_LONGLONG)
                    || ((ek == KIND_DOUBLE || ek == KIND_FLOAT) && ew >= 5);
            int rw = wide ? ew
                   : (ek == KIND_LONG || ek == KIND_CPTR || ew == 4) ? 4 : 2;
            int dst = new_temp(b, rw);
            b->f->vregs[dst].width = (int16_t)rw;
            if (ek == KIND_CPTR || wide || ew == 4)
                b->f->vregs[dst].kind = ek;   /* acc store / float ops dispatch on kind */
            Op *op = ir_op_emit(cur_bb(b), IR_LD_FAR);
            op->dst    = dst;
            op->src[0] = ptr_v;
            op->mem.elem = ek;
            op->imm      = is_uns;
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
        if (n->operand && n->operand->ast_type == AST_GLOBAL_VAR
            && sym_is_faracc(n->operand->sym)
            && (Kind)n->operand->sym->type != KIND_ARRAY
            && (Kind)n->operand->sym->type != KIND_STRUCT) {
            /* Reading a FARACC (`__banked`) scalar global: this deref reads
               the variable, which lives in the far heap — map its far
               address then load through it (lp_g*). */
            Kind ek = (Kind)n->operand->sym->type;
            int  ew = type_width(n->type);
            int  uns = n->type && n->type->isunsigned;
            if (!far_helper(ek, ew, uns, 1))
                return build_fail("FARACC load kind %d width %d deferred",
                                  ek, ew);
            int fp = emit_far_symaddr(b, n->operand->sym);
            return emit_far_load(b, fp, ek, ew, uns);
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
            /* A wide long long global needs its vreg KIND set so the
               wide load picks l_i64_load (not the float dload). */
            if (gv_w == 8 && n->operand->sym
                && is_acc_int_kind((Kind)n->operand->sym->type))
                b->f->vregs[v].kind = KIND_LONGLONG;
            Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
            op->dst = v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->operand->sym;
            /* Reading a __far pointer VARIABLE: its 3-byte value loads with
               the 4th byte zeroed (DEHL far-ptr invariant). */
            if (n->type && n->type->kind == KIND_CPTR) {
                b->f->vregs[v].kind = KIND_CPTR;
                op->mem.elem = KIND_CPTR;
            }
            return v;
        }
        /* Real indirection: operand is a pointer expression. Walk it
           to get a vreg holding the address, then emit IR_LD_MEM via
           MEM_VREG. Element width comes from the deref's result type. */
        if (n->operand) {
            /* Deref of a pointer into a named address space (`*p`, `arr[i]`):
               recover the page-in fn from the pointee/element type and stamp
               it on the load; the lowerer pages the bank in at the MEM_VREG
               access (push/pop bc around the call). Matches sccz80. */
            SYMBOL *bf = (SYMBOL *)deref_bank_fn(n);
            int ptr_v = build_expr(b, n->operand);
            if (ptr_v < 0) return -1;
            if (n->type && is_acc_float_kind(n->type->kind)) {
                /* `*p` wide double load via dload (elem=KIND_DOUBLE). */
                int dv = new_temp(b, c_fp_size);
                b->f->vregs[dv].width = (int16_t)c_fp_size;
                b->f->vregs[dv].kind  = KIND_DOUBLE;
                Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
                op->dst = dv; op->mem.kind = IR_MEM_VREG;
                op->mem.base = ptr_v; op->mem.elem = KIND_DOUBLE;
                op->mem.bank_fn = bf;
                return dv;
            }
            if (n->type && is_acc_int_kind(n->type->kind)) {
                /* `*p` wide long long load via l_i64_load. */
                int dv = new_temp(b, 8);
                b->f->vregs[dv].width = 8;
                b->f->vregs[dv].kind  = KIND_LONGLONG;
                Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
                op->dst = dv; op->mem.kind = IR_MEM_VREG;
                op->mem.base = ptr_v; op->mem.elem = KIND_LONGLONG;
                op->mem.bank_fn = bf;
                return dv;
            }
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
            op->mem.bank_fn = bf;
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

        /* Floating-point binops are helper calls, not integer ops —
           intercept before any integer promotion/imm-fold machinery.
           Only KIND_FLOAT16 ADD/SUB are handled here (l_f16_add/sub:
           left pushed, right in HL, result HL — same shape as the
           l_fix16_* helpers). Everything else with a float operand
           (KIND_DOUBLE, all float compares) bails to the walker. */
        {
            Kind res_k = n->type ? n->type->kind : KIND_NONE;
            Kind lkf = node_value_kind(n->left);
            Kind rkf = node_value_kind(n->right);
            if (kind_is_floating(res_k) || kind_is_floating(lkf)
                || kind_is_floating(rkf)) {
                if (is_supported_float_kind(res_k)
                    && (n->ast_type == OP_ADD || n->ast_type == OP_SUB)) {
                    int fw = width_for_kind(res_k);   /* 2 or 4 */
                    int lf = build_expr(b, n->left);
                    if (lf < 0) return -1;
                    int rf = build_expr(b, n->right);
                    if (rf < 0) return -1;
                    int dst = new_temp(b, fw);
                    b->f->vregs[dst].width = (int16_t)fw;
                    b->f->vregs[dst].kind  = res_k;
                    int *fargs = calloc(2, sizeof(int));
                    fargs[0] = lf;   /* left  → pushed */
                    fargs[1] = rf;   /* right → HL/DEHL */
                    Op *fop = ir_op_emit(cur_bb(b), IR_HCALL);
                    fop->dst = dst;
                    HelperInfo *fhi = calloc(1, sizeof(HelperInfo));
                    fhi->name      = float_helper(res_k,
                                       (n->ast_type == OP_ADD) ? "add" : "sub");
                    fhi->args      = fargs;
                    fhi->n_args    = 2;
                    fhi->n_stacked = 1;
                    fhi->ret_vreg  = dst;
                    fop->hcall = fhi;
                    return dst;
                }
                /* Float compare: l_f{16,32}_{lt,le,gt,ge,eq,ne} return the
                   int bool (0/1) in HL (left pushed, right in HL/DEHL) — a
                   plain value-returning HCALL, result is a width-2 int.
                   Only when BOTH operands are the same supported float
                   kind (mixed float/int should have been converted by the
                   front end; if not, bail). */
                if (is_supported_float_kind(lkf) && lkf == rkf) {
                    const char *stem = NULL;
                    switch (n->ast_type) {
                    case OP_LT: stem = "lt"; break;
                    case OP_LE: stem = "le"; break;
                    case OP_GT: stem = "gt"; break;
                    case OP_GE: stem = "ge"; break;
                    case OP_EQ: stem = "eq"; break;
                    case OP_NE: stem = "ne"; break;
                    default: break;
                    }
                    const char *cmp = stem ? float_helper(lkf, stem) : NULL;
                    if (cmp) {
                        int lf = build_expr(b, n->left);
                        if (lf < 0) return -1;
                        int rf = build_expr(b, n->right);
                        if (rf < 0) return -1;
                        int dst = new_temp(b, 2);   /* int bool result */
                        b->f->vregs[dst].width = 2;
                        int *cargs = calloc(2, sizeof(int));
                        cargs[0] = lf;   /* left  → pushed */
                        cargs[1] = rf;   /* right → HL */
                        Op *cop = ir_op_emit(cur_bb(b), IR_HCALL);
                        cop->dst = dst;
                        HelperInfo *chi = calloc(1, sizeof(HelperInfo));
                        chi->name      = cmp;
                        chi->args      = cargs;
                        chi->n_args    = 2;
                        chi->n_stacked = 1;
                        chi->ret_vreg  = dst;
                        cop->hcall = chi;
                        return dst;
                    }
                }
                /* 5/6-byte double compare → wide-accumulator compare
                   (dlt/dleq/dgt/dge/deq/dne → int 0/1 bool in HL). */
                if (is_acc_float_kind(lkf) && lkf == rkf) {
                    const char *cstem = NULL;
                    switch (n->ast_type) {
                    case OP_LT: cstem = "lt"; break;
                    case OP_LE: cstem = "le"; break;
                    case OP_GT: cstem = "gt"; break;
                    case OP_GE: cstem = "ge"; break;
                    case OP_EQ: cstem = "eq"; break;
                    case OP_NE: cstem = "ne"; break;
                    default: break;
                    }
                    if (cstem) {
                        int lf = build_expr(b, n->left);
                        if (lf < 0) return -1;
                        int rf = build_expr(b, n->right);
                        if (rf < 0) return -1;
                        int dst = new_temp(b, 2);
                        b->f->vregs[dst].width = 2;
                        int *cargs = calloc(2, sizeof(int));
                        cargs[0] = lf; cargs[1] = rf;
                        Op *cop = ir_op_emit(cur_bb(b), IR_ACC_CMP);
                        cop->dst = dst;
                        HelperInfo *chi = calloc(1, sizeof(HelperInfo));
                        chi->name = acc_name(cstem);
                        chi->args = cargs; chi->n_args = 2; chi->ret_vreg = dst;
                        chi->acc_load = acc_name("load");
                        chi->acc_push = acc_name("push");
                        chi->acc_loadpush = acc_name("loadpush");
                        chi->acc_width = c_fp_size; chi->acc_holds_lhs = 0;
                        cop->hcall = chi;
                        return dst;
                    }
                }
                /* 5/6-byte double add/sub → wide-accumulator op. */
                if (is_acc_float_kind(res_k)
                    && (n->ast_type == OP_ADD || n->ast_type == OP_SUB)) {
                    int lf = build_expr(b, n->left);
                    if (lf < 0) return -1;
                    int rf = build_expr(b, n->right);
                    if (rf < 0) return -1;
                    int dst = emit_acc_binop(b,
                                 (n->ast_type == OP_ADD) ? "add" : "sub",
                                 lf, rf);
                    if (dst < 0) return build_fail("acc add/sub emit failed");
                    return dst;
                }
                return build_fail("float binop kind %d op %d not yet supported",
                                  (int)res_k, (int)n->ast_type);
            }
        }

        /* long long (width-8 __i64_acc): add/sub, bitwise and/or/xor,
           shifts, and the six compares lower to l_i64_* via the shared
           IR_ACC_* layer. Mul/div/mod are in the OP_MULT/DIV/MOD case. */
        {
            Kind lki = (n->left  && n->left->type)  ? n->left->type->kind  : KIND_NONE;
            Kind rki = (n->right && n->right->type) ? n->right->type->kind : KIND_NONE;
            Kind reski = n->type ? n->type->kind : KIND_NONE;
            const char *stem = NULL, *cstem = NULL;
            int shift_uns = -1;   /* >=0 overrides the helper signedness */
            switch (n->ast_type) {
            case OP_ADD: stem = "add"; break;
            case OP_SUB: stem = "sub"; break;
            case OP_AND: stem = "and"; break;
            case OP_OR:  stem = "or";  break;
            case OP_XOR: stem = "xor"; break;
            case OP_USHL: case OP_SSHL: stem = "shl"; shift_uns = 0; break;
            case OP_USHR: case OP_SSHR:
                /* A right shift is logical iff the shifted (left) operand is
                   unsigned — the parser doesn't always pick OP_USHR for a
                   cast like `(unsigned long long)x >> n`. */
                stem = "shr";
                shift_uns = (n->left && n->left->type
                             && n->left->type->isunsigned);
                break;
            case OP_LT: cstem = "lt"; break;
            case OP_LE: cstem = "le"; break;
            case OP_GT: cstem = "gt"; break;
            case OP_GE: cstem = "ge"; break;
            case OP_EQ: cstem = "eq"; break;
            case OP_NE: cstem = "ne"; break;
            default: break;
            }
            /* Arithmetic/shift is long long iff the RESULT is (so `ptr + ll`
               stays pointer arithmetic); a compare (int result) is long
               long iff either operand is. */
            int ll_arith = stem  && is_acc_int_kind(reski);
            int ll_cmp   = cstem && (is_acc_int_kind(lki) || is_acc_int_kind(rki));
            if (ll_arith || ll_cmp) {
                /* Shift helper signedness comes from the op (asr vs asr_u);
                   other ops use the usual either-operand-unsigned rule. */
                int is_uns = (shift_uns >= 0) ? shift_uns
                    : ((n->left->type && n->left->type->isunsigned)
                       || (n->right->type && n->right->type->isunsigned));
                int l = build_expr(b, n->left);
                if (l < 0) return -1;
                int r = build_expr(b, n->right);
                if (r < 0) return -1;
                /* Promote mixed int operands to long long (C promotion; for
                   a shift the count widens too — the helper reads its low
                   byte from __i64_acc). */
                l = promote_to_acc_int(b, l,
                        n->left->type && n->left->type->isunsigned);
                r = promote_to_acc_int(b, r,
                        n->right->type && n->right->type->isunsigned);
                if (l < 0 || r < 0) return -1;
                int dst = stem ? emit_acc_int_binop(b, stem, l, r, is_uns)
                               : emit_acc_int_cmp(b, cstem, l, r, is_uns);
                if (dst < 0) return build_fail("i64 binop/cmp emit failed");
                return dst;
            }
        }

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

        /* `lit - var` is non-commutative, so the swap above left the
           literal on the LHS. Rather than materialise it into a vreg
           (which forces a push/pop to preserve it across the var load
           on every CPU without a register-preserving slot load), emit
           IR_RSUB (dst = imm - src[0]); the lowerer does immediate-
           minus-register. Int width only — long stays on the SUB path. */
        if (k == IR_SUB
            && lhs && lhs->ast_type == AST_LITERAL
            && rhs && rhs->ast_type != AST_LITERAL
            && rhs->type && is_supported_int_kind(rhs->type->kind)
            && (int)type_width(rhs->type) <= 2
            && (!n->type || (int)type_width(n->type) <= 2)
            && (int64_t)lhs->zval >= -32768 && (int64_t)lhs->zval <= 65535) {
            int rv = build_expr(b, rhs);
            if (rv < 0) return -1;
            if (b->f->vregs[rv].width == 1) {
                int uns = !rhs->type || rhs->type->isunsigned;
                int wt = new_temp(b, 2);
                b->f->vregs[wt].width = 2;
                Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wt; cv->src[0] = rv;
                rv = wt;
            }
            int dst = ALLOC_DST(2);
            Op *op = ir_op_emit(cur_bb(b), IR_RSUB);
            op->dst = dst; op->src[0] = rv; op->src[1] = -1;
            op->imm = (int64_t)lhs->zval;
            b->f->vregs[dst].width = 2;
            return dst;
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
            int64_t imm = (int64_t)rhs->zval;
            /* GT/LE with a const RHS has no correct direct lowering at any
               width — the const-RHS handlers only exist for LT/GE, and the
               GT/LE paths read an uninitialised slot for the constant
               (width-1/2) or fatally bail (width-4). Canonicalize
               `a>K` -> `a>=K+1` and `a<=K` -> `a<K+1` so it routes to the
               LT/GE-const path. Exact for integers unless K is the type
               max (K+1 wraps) — leave that degenerate edge alone. The
               type max is keyed off the compare's signedness (unsigned for
               U* kinds) and the operand width. */
            if (k == IR_CMP_LE || k == IR_CMP_GT
                || k == IR_CMP_ULE || k == IR_CMP_UGT) {
                int uns = (k == IR_CMP_ULE || k == IR_CMP_UGT);
                int64_t mask = (width <= 1) ? 0xFFLL
                             : (width == 2) ? 0xFFFFLL : 0xFFFFFFFFLL;
                int64_t tmax = uns ? mask
                             : ((width <= 1) ? 0x7F
                              : (width == 2) ? 0x7FFF : 0x7FFFFFFFLL);
                /* Interpret the literal at the operand's width+signedness:
                   an unsigned compare with a negative literal (`a <= -1`)
                   means `a <= UMAX`, not a<=-1. */
                int64_t eff = uns ? (imm & mask) : imm;
                int is_le = (k == IR_CMP_LE || k == IR_CMP_ULE);
                if (eff >= tmax) {
                    /* `a <= typemax` is always true, `a > typemax` always
                       false (K+1 would wrap). `a` (= l) was already built;
                       DCE drops it if its eval is side-effect-free. */
                    int dst = ALLOC_DST(2);
                    ir_emit_ld_imm(cur_bb(b), dst, is_le ? 1 : 0);
                    b->f->vregs[dst].width = 2;
                    return dst;
                }
                switch (k) {
                case IR_CMP_LE:  k = IR_CMP_LT;  break;
                case IR_CMP_GT:  k = IR_CMP_GE;  break;
                case IR_CMP_ULE: k = IR_CMP_ULT; break;
                case IR_CMP_UGT: k = IR_CMP_UGE; break;
                default: break;
                }
                imm = eff + 1;
            }
            int dst = ALLOC_DST(dst_w);
            Op *op = ir_op_emit(cur_bb(b), k);
            op->dst    = dst;
            op->src[0] = l;
            op->src[1] = -1;
            op->imm    = imm;
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
        /* Pointer DIFFERENCE: `p - q` yields the element COUNT, not the
           byte difference — divide the IR_SUB result by sizeof(*p) when
           both operands are pointer-typed (KIND_PTR/CPTR/ARRAY). Mirrors
           the walker's gen_ptr_diff_scale: a power-of-2 element is a
           logical shift right (`srl;rr` ×log2, signedness per sccz80),
           else an l_div_u. Without this the IR returned the raw byte
           count for near AND far pointer subtraction. */
        if (n->ast_type == OP_SUB && lhs && rhs && lhs->type && rhs->type
            && (lhs->type->kind == KIND_PTR || lhs->type->kind == KIND_CPTR
                || lhs->type->kind == KIND_ARRAY)
            && (rhs->type->kind == KIND_PTR || rhs->type->kind == KIND_CPTR
                || rhs->type->kind == KIND_ARRAY)
            && lhs->type->ptr) {
            int elem = lhs->type->ptr->size;
            if (elem > 1) {
                int e = elem, log2 = 0;
                while (e > 1 && (e & 1) == 0) { e >>= 1; log2++; }
                if (e == 1) {                       /* power of two → shift */
                    Op *sh = ir_op_emit(cur_bb(b), IR_SHR);
                    sh->dst = dst; sh->src[0] = dst; sh->src[1] = -1;
                    sh->imm = log2;
                } else if (dst_w == 2) {            /* odd size → l_div_u */
                    int dv = new_temp(b, 2);
                    b->f->vregs[dv].width = 2;
                    int kimm = new_temp(b, 2);
                    b->f->vregs[kimm].width = 2;
                    ir_emit_ld_imm(cur_bb(b), kimm, elem);
                    /* l_div_u computes DE/HL → HL: walker sets HL=divisor
                       (elem), DE=dividend (byte-diff). HCALL puts args[0]
                       in HL, args[1] in DE. */
                    int *dargs = calloc(2, sizeof(int));
                    dargs[0] = kimm; dargs[1] = dst;
                    Op *dop = ir_op_emit(cur_bb(b), IR_HCALL);
                    dop->dst = dv;
                    HelperInfo *dhi = calloc(1, sizeof(HelperInfo));
                    dhi->name = "l_div_u"; dhi->args = dargs;
                    dhi->n_args = 2; dhi->ret_vreg = dv;
                    dop->hcall = dhi;
                    return dv;
                } else {
                    return build_fail("far pointer diff by non-power-of-2 "
                                      "element size %d", elem);
                }
            }
        }
        return dst;
    }

    case OP_ASSIGN: {
        /* LHS = RHS. LHS is an lvalue: AST_LOCAL_VAR (address) or
           AST_GLOBAL_VAR or a more complex address expression. Bare
           local / bare global only. */
        if (!n->left)
            return build_fail("OP_ASSIGN with NULL LHS");
        /* Bitfield store = read-modify-write of the storage unit: clear the
           field's bits, OR in the shifted value, write the unit back (the
           plain store would clobber the neighbouring fields). The parser
           records the bitfield member type on the OP_ASSIGN node (n->type)
           and the storage unit's address as n->left — a global/local lvalue
           or, for a field in a byte beyond the first, the folded address
           expression `(+ (gv) K)`. The unit is byte-wide when the field
           fits in one byte (matches sccz80's byte rmw), word-wide otherwise;
           a byte store is essential for a non-zero byte offset, where a word
           store would run past the struct into the next object. */
        {
            Type *bft = (n->type && n->type->bit_size > 0) ? n->type
                      : (n->left->type && n->left->type->bit_size > 0)
                          ? n->left->type : NULL;
            if (bft) {
                int bsize = bft->bit_size, boff = bft->bit_offset;
                int64_t mask = ((int64_t)1 << bsize) - 1;
                int64_t fieldmask = mask << boff;          /* bits this field owns */
                int unit_w = (boff + bsize <= 8) ? 1 : 2;
                Kind unit_k = (unit_w == 1) ? KIND_CHAR : KIND_INT;
                /* Address of the storage unit into a vreg. */
                Node *lv = n->left;
                int addr;
                if (lv->ast_type == AST_GLOBAL_VAR && lv->sym
                    && !sym_is_faracc(lv->sym) && !sym_is_namespaced(lv->sym)) {
                    addr = new_temp(b, 2); b->f->vregs[addr].width = 2;
                    Op *op = ir_op_emit(cur_bb(b), IR_LD_SYM);
                    op->dst = addr; op->mem.kind = IR_MEM_SYM; op->mem.sym = lv->sym;
                } else if (lv->ast_type == AST_LOCAL_VAR && lv->sym) {
                    int src = sym_map_get(b, lv->sym);
                    if (src < 0) return build_fail("bitfield store unknown local");
                    b->f->vregs[src].flags |= IR_VREG_ADDR_TAKEN;
                    addr = new_temp(b, 2); b->f->vregs[addr].width = 2;
                    Op *op = ir_op_emit(cur_bb(b), IR_LEA);
                    op->dst = addr; op->src[0] = src;
                } else if (lv->ast_type == OP_ADD || lv->ast_type == OP_SUB
                        || lv->ast_type == OP_DEREF) {
                    addr = build_expr(b, lv);
                    if (addr < 0) return -1;
                } else {
                    return build_fail("bitfield store lvalue shape deferred");
                }
                int v = build_expr(b, n->right);
                if (v < 0) return -1;
                if (b->f->vregs[v].width != 2) {
                    int t = new_temp(b, 2); b->f->vregs[t].width = 2;
                    OpKind cv = (b->f->vregs[v].width > 2)
                              ? IR_CONV_TRUNC
                              : (n->right->type && n->right->type->isunsigned
                                 ? IR_CONV_ZX : IR_CONV_SX);
                    Op *c = ir_op_emit(cur_bb(b), cv);
                    c->dst = t; c->src[0] = v; v = t;
                }
                /* (v & mask) << boff */
                int vm = new_temp(b, 2); b->f->vregs[vm].width = 2;
                Op *a1 = ir_op_emit(cur_bb(b), IR_AND);
                a1->dst = vm; a1->src[0] = v; a1->src[1] = -1; a1->imm = mask;
                int vms = vm;
                if (boff > 0) {
                    vms = new_temp(b, 2); b->f->vregs[vms].width = 2;
                    Op *sl = ir_op_emit(cur_bb(b), IR_SHL);
                    sl->dst = vms; sl->src[0] = vm; sl->src[1] = -1; sl->imm = boff;
                }
                /* container & ~fieldmask */
                int cont = new_temp(b, 2); b->f->vregs[cont].width = 2;
                Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
                ld->dst = cont; ld->mem.kind = IR_MEM_VREG;
                ld->mem.base = addr; ld->mem.elem = unit_k;
                int cleared = new_temp(b, 2); b->f->vregs[cleared].width = 2;
                Op *a2 = ir_op_emit(cur_bb(b), IR_AND);
                a2->dst = cleared; a2->src[0] = cont; a2->src[1] = -1;
                a2->imm = (~fieldmask) & (unit_w == 1 ? 0xFF : 0xFFFF);
                /* new = cleared | vms */
                int newv = new_temp(b, 2); b->f->vregs[newv].width = 2;
                ir_emit_binop(cur_bb(b), IR_OR, newv, cleared, vms);
                Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
                st->src[0] = newv; st->mem.kind = IR_MEM_VREG;
                st->mem.base = addr; st->mem.elem = unit_k;
                return v;
            }
        }
        /* Whole-aggregate (struct/union) copy `s1 = s2`: block-copy sizeof
           bytes via IR_MEMCPY. Key off the assign node's type — an `*d`
           LHS is mis-typed as the pointer. A struct-returning call RHS
           bails in agg_lvalue_addr (NRV return unimplemented). */
        if (n->type && n->type->kind == KIND_STRUCT) {
            int size = n->type->size;
            if (size <= 0 || size > 65536)
                return build_fail("struct copy size %d", size);
            int dstp = agg_lvalue_addr(b, n->left);
            if (dstp < 0) return -1;
            int srcp = agg_lvalue_addr(b, n->right);
            if (srcp < 0) return -1;
            Op *op = ir_op_emit(cur_bb(b), IR_MEMCPY);
            op->dst = -1; op->src[0] = dstp; op->src[1] = srcp;
            op->imm = size;
            return dstp;
        }
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
            /* FARACC (`__banked`) global store: map the far address then
               write through it (lp_p*), not a plain near `ld (_g),hl`. */
            if (n->left->sym && sym_is_faracc(n->left->sym)
                && (Kind)n->left->sym->type != KIND_ARRAY
                && (Kind)n->left->sym->type != KIND_STRUCT) {
                Kind ek = (Kind)n->left->sym->type;
                int  ew = type_width(n->left->type);
                if (!far_helper(ek, ew, 0, 0))
                    return build_fail("FARACC store kind %d width %d "
                                      "deferred", ek, ew);
                int fp = emit_far_symaddr(b, n->left->sym);
                rhs_v = far_store_value(b, n, ek, ew, rhs_v);
                if (rhs_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_ST_FAR);
                op->src[0]   = fp;
                op->src[1]   = rhs_v;
                op->mem.elem = ek;
                return rhs_v;
            }
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
            if (is_acc_float_kind(gk)) {
                /* Wide double global store via dstore (elem=KIND_DOUBLE);
                   rhs is already the width-c_fp_size value. */
                Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                op->src[0]   = rhs_v;
                op->mem.kind = IR_MEM_SYM;
                op->mem.sym  = n->left->sym;
                op->mem.elem = KIND_DOUBLE;
                return rhs_v;
            }
            if (is_acc_int_kind(gk)) {
                /* Wide long long global store via l_i64_store; promote a
                   narrower rhs to long long first. */
                rhs_v = promote_to_acc_int(b, rhs_v,
                            n->right && n->right->type
                            && n->right->type->isunsigned);
                if (rhs_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                op->src[0]   = rhs_v;
                op->mem.kind = IR_MEM_SYM;
                op->mem.sym  = n->left->sym;
                op->mem.elem = KIND_LONGLONG;
                return rhs_v;
            }
            if (gk == KIND_CPTR) {
                /* __far pointer VALUE store (`fp = q`): write only the
                   low 3 bytes (`ld (sym),hl; ld a,e; ld (sym+2),a`) so
                   the 4th DEHL byte never clobbers the adjacent global. */
                Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                op->src[0]   = rhs_v;
                op->mem.kind = IR_MEM_SYM;
                op->mem.sym  = n->left->sym;
                op->mem.elem = KIND_CPTR;
                return rhs_v;
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
            /* `*p = X` into a named address space: page in the bank at the
               store (namespace recovered from the deref's pointee type). */
            SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
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
            /* __far store (`*fp = v`): route through an lp_p* helper.
               Element kind = the far pointer's POINTEE (n->left->operand
               is the CPTR value; its ->type->ptr is the element). The
               OP_ASSIGN's own type / n->left->type can read back as the
               far-pointer kind, so prefer the pointee. */
            if (node_is_far_ptr(n->left->operand)) {
                Type *pte = n->left->operand->type
                          ? n->left->operand->type->ptr : NULL;
                Kind ek = pte ? pte->kind
                        : (n->type ? n->type->kind : KIND_INT);
                int  ew = pte ? type_width(pte) : 2;
                if (!far_helper(ek, ew, 0, 0))
                    return build_fail("__far store of element kind %d "
                                      "width %d deferred", ek, ew);
                rhs_v = far_store_value(b, n, ek, ew, rhs_v);
                if (rhs_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_ST_FAR);
                op->src[0]   = ptr_v;   /* far pointer (DEHL) */
                op->src[1]   = rhs_v;   /* value */
                op->mem.elem = ek;
                return rhs_v;
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
            {
                /* Stored-value kind. Prefer a floating n->type, but also
                   accept a floating lvalue (n->left->type, the deref'd
                   member/pointee type) — for a struct-member store like
                   `gs.d = X` the parser can record n->type as int, which
                   would mis-size the store below. */
                Kind dk = (n->type && kind_is_floating(n->type->kind))
                            ? n->type->kind
                        : (n->left->type
                           && kind_is_floating(n->left->type->kind))
                            ? n->left->type->kind
                        : (n->left->type
                           && n->left->type->kind == KIND_PTR
                           && n->left->type->ptr)
                            ? n->left->type->ptr->kind : KIND_NONE;
                if (is_acc_float_kind(dk)) {
                    /* `*p = X` wide double store via dstore. */
                    Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                    op->src[0]   = rhs_v;
                    op->mem.kind = IR_MEM_VREG;
                    op->mem.base = ptr_v;
                    op->mem.elem = KIND_DOUBLE;
                    op->mem.bank_fn = bf;
                    return rhs_v;
                }
                /* 4-byte f32 double: a plain 4-byte DEHL value — store all
                   4 bytes. n->type can read back as int for the member
                   shape (elem_w=2 above), which would truncate; force 4. */
                if (dk == KIND_DOUBLE || dk == KIND_FLOAT)
                    elem_w = 4;
                if (is_acc_int_kind(dk)) {
                    /* `*p = X` wide long long store via l_i64_store. */
                    rhs_v = promote_to_acc_int(b, rhs_v,
                                n->right && n->right->type
                                && n->right->type->isunsigned);
                    if (rhs_v < 0) return -1;
                    Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                    op->src[0]   = rhs_v;
                    op->mem.kind = IR_MEM_VREG;
                    op->mem.base = ptr_v;
                    op->mem.elem = KIND_LONGLONG;
                    op->mem.bank_fn = bf;
                    return rhs_v;
                }
            }
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
            op->mem.bank_fn = bf;
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
        /* Address-yielding __far LHS (`fp[i] = v`, `*(fp+K) = v`): the
           parser folds the subscript-assign into a bare far-pointer
           expression (OP_ADD, type CPTR). Store through an lp_p* helper. */
        if (n->left->type && n->left->type->kind == KIND_CPTR) {
            Type *pte = n->left->type->ptr;
            Kind ek = pte ? pte->kind : KIND_INT;
            int  ew = pte ? type_width(pte) : 2;
            if (!far_helper(ek, ew, 0, 0))
                return build_fail("__far store of element kind %d width %d "
                                  "deferred", ek, ew);
            int ptr_v = build_expr(b, n->left);
            if (ptr_v < 0) return -1;
            rhs_v = far_store_value(b, n, ek, ew, rhs_v);
            if (rhs_v < 0) return -1;
            Op *op = ir_op_emit(cur_bb(b), IR_ST_FAR);
            op->src[0]   = ptr_v;
            op->src[1]   = rhs_v;
            op->mem.elem = ek;
            return rhs_v;
        }
        if (n->left->type
            && ((n->left->type->kind == KIND_PTR
                 || n->left->type->kind == KIND_ARRAY)
                || is_supported_int_kind(n->left->type->kind))
            && (n->left->type->ptr
                || is_supported_int_kind(n->left->type->kind))) {
            /* `arr[i] = X` into a named address space: page in the bank at
               the store (namespace recovered from the array element type). */
            SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
            int ptr_v = build_expr(b, n->left);
            if (ptr_v < 0) return -1;
            /* Wide-value store (this path otherwise only handles 1/2/4-byte
               integers). The member/element lvalue type can read back as
               int (e.g. `gs.d = X` records n->left->type int), so key the
               float/long-long decision off n->type (the value type).
               acc-double → dstore; f32 → plain 4-byte store; long long →
               l_i64_store. */
            {
                Kind vk = (n->type && (kind_is_floating(n->type->kind)
                                       || n->type->kind == KIND_LONGLONG))
                            ? n->type->kind
                        : (n->left->type
                           && (kind_is_floating(n->left->type->kind)
                               || n->left->type->kind == KIND_LONGLONG))
                            ? n->left->type->kind : KIND_NONE;
                if (is_acc_float_kind(vk) || vk == KIND_DOUBLE
                    || vk == KIND_FLOAT) {
                    Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                    op->src[0]   = rhs_v;
                    op->mem.kind = IR_MEM_VREG;
                    op->mem.base = ptr_v;
                    /* acc-double uses the dstore helper (elem=DOUBLE); f32
                       is a plain 4-byte DEHL value (elem=LONG). */
                    op->mem.elem = is_acc_float_kind(vk) ? KIND_DOUBLE
                                                         : KIND_LONG;
                    op->mem.bank_fn = bf;
                    return rhs_v;
                }
                if (is_acc_int_kind(vk)) {
                    rhs_v = promote_to_acc_int(b, rhs_v,
                                n->right && n->right->type
                                && n->right->type->isunsigned);
                    if (rhs_v < 0) return -1;
                    Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                    op->src[0]   = rhs_v;
                    op->mem.kind = IR_MEM_VREG;
                    op->mem.base = ptr_v;
                    op->mem.elem = KIND_LONGLONG;
                    op->mem.bank_fn = bf;
                    return rhs_v;
                }
            }
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
            op->mem.bank_fn = bf;
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
        Kind flt_k   = lk;   /* the float kind when is_flt (lk == rk) */
        int is_flt   = kind_is_floating(lk) || kind_is_floating(rk)
                    || (n->type && kind_is_floating(n->type->kind));
        if ((is_fix16 || is_fix32) && n->ast_type == OP_MOD)
            return build_fail("OP_MOD on _Accum not defined");
        if (is_flt) {
            if (n->ast_type != OP_MULT && n->ast_type != OP_DIV)
                return build_fail("float op %d not yet supported", (int)n->ast_type);
            /* 5/6-byte double mul/div → wide-accumulator op. */
            if (is_acc_float_kind(lk) && lk == rk) {
                int l = build_expr(b, n->left);
                if (l < 0) return -1;
                int r = build_expr(b, n->right);
                if (r < 0) return -1;
                int dst = emit_acc_binop(b,
                             (n->ast_type == OP_MULT) ? "mul" : "div", l, r);
                if (dst < 0) return build_fail("acc mul/div emit failed");
                return dst;
            }
            /* Register-tier float: both operands the same supported kind;
               mixed float/int bails to the walker (front end converts). */
            if (!is_supported_float_kind(lk) || lk != rk)
                return build_fail("float mul/div: operands not both supported float");
        }
        /* long long mul/div/mod → wide-accumulator op (l_i64_mult/div/mod,
           signed/unsigned by operand signedness). Gated on the result kind
           (a mixed `ll * int` promotes to ll). */
        if (is_acc_int_kind(n->type ? n->type->kind : KIND_NONE)
            || (is_acc_int_kind(lk) && is_acc_int_kind(rk))) {
            int is_uns = (n->left->type && n->left->type->isunsigned)
                      || (n->right->type && n->right->type->isunsigned);
            int l = build_expr(b, n->left);
            if (l < 0) return -1;
            int r = build_expr(b, n->right);
            if (r < 0) return -1;
            l = promote_to_acc_int(b, l,
                    n->left->type && n->left->type->isunsigned);
            r = promote_to_acc_int(b, r,
                    n->right->type && n->right->type->isunsigned);
            if (l < 0 || r < 0) return -1;
            const char *stem = (n->ast_type == OP_MULT) ? "mul"
                             : (n->ast_type == OP_DIV)  ? "div" : "mod";
            int dst = emit_acc_int_binop(b, stem, l, r, is_uns);
            if (dst < 0) return build_fail("i64 mul/div/mod emit failed");
            return dst;
        }
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
        if (is_flt) {
            /* l_f{16,32}_mul / _div: rhs in HL/DEHL, lhs pushed; result
               in HL/DEHL, helper pops the pushed lhs — same shape as
               fix16/long. */
            helper = float_helper(flt_k,
                       (n->ast_type == OP_MULT) ? "mul" : "div");
            args[0] = l; args[1] = r; n_stacked = 1;
        } else if (is_fix16) {
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
        if (is_flt) b->f->vregs[dst].kind = flt_k;
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
        /* Float negate is a sign-bit flip, not integer two's-complement.
           For FLOAT16 (IEEE half, sign in bit 15) that's just XOR 0x8000
           on the 2-byte value — no helper, same as the walker's inline
           `xor 128` on the high byte. KIND_DOUBLE bails. */
        if (n->operand->type && kind_is_floating(n->operand->type->kind)) {
            Kind nk = n->operand->type->kind;
            int fv = build_expr(b, n->operand);
            if (fv < 0) return -1;
            if (nk == KIND_FLOAT16) {
                /* IEEE half: sign in bit 15 — XOR 0x8000, no helper. */
                int dst = new_temp(b, 2);
                b->f->vregs[dst].width = 2;
                b->f->vregs[dst].kind  = KIND_FLOAT16;
                Op *op = ir_op_emit(cur_bb(b), IR_XOR);
                op->dst = dst; op->src[0] = fv; op->src[1] = -1;
                op->imm = 0x8000;
                return dst;
            }
            if (is_acc_float_kind(nk))     /* 5/6/8-byte double: minusfa */
                return emit_acc_float_neg(b, fv);
            /* 4-byte float (IEEE single / MBF32 / daimath / …): negate is
               a sign-bit flip. IEEE sign = bit 31 → XOR 0x80000000 (byte
               D); MBF32 sign = bit 23 → XOR 0x00800000 (byte E). Both
               match sccz80 neg(). Any other 4-byte format (sign location
               unknown here) → the l_f32_negate helper. */
            if (b->f->vregs[fv].width == 4) {
                uint32_t mask = (c_maths_mode == MATHS_IEEE) ? 0x80000000U
                              : (c_maths_mode == MATHS_MBFS) ? 0x00800000U
                              : 0;
                int dst = new_temp(b, 4);
                b->f->vregs[dst].width = 4;
                b->f->vregs[dst].kind  = nk;
                if (mask) {
                    Op *op = ir_op_emit(cur_bb(b), IR_XOR);
                    op->dst = dst; op->src[0] = fv; op->src[1] = -1;
                    op->imm = (int64_t)mask;
                } else {
                    int *args = calloc(1, sizeof(int)); args[0] = fv;
                    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
                    op->dst = dst;
                    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
                    hi->name = "l_f32_negate"; hi->args = args;
                    hi->n_args = 1; hi->ret_vreg = dst;
                    op->hcall = hi;
                }
                return dst;
            }
            return build_fail("float unary neg kind %d not yet supported",
                              (int)nk);
        }
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
        /* Struct/union BY-VALUE argument: the walker allocates `size`
           bytes on the stack and ldir's the struct in; the IR's arg path
           only knows how to push a 2/4-byte scalar, so a struct arg would
           push its 2-byte address instead — a silent miscompile. Defer the
           whole call to the walker until the by-value push path exists.
           (The struct-param callee already bails on "param kind 11".) */
        for (int i = 0; i < n_args; i++) {
            Node *a = array_get_byindex(n->args, i);
            if (a && a->type && a->type->kind == KIND_STRUCT)
                return build_fail("struct-by-value argument deferred");
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
                /* __z88dk_sdccdecl: a char parameter is passed as ONE
                   byte (not the smallc 2-byte int promotion). Truncate
                   the arg to width-1 so gen_call emits the 1-byte push
                   and the callee's 1-byte param slot lines up. (A width-1
                   arg also fails the pushable test below, so the call
                   falls to gen_call's slot loop where the 1-byte push
                   lives.) */
                if ((n->sym->ctype->flags & SDCCDECL)
                    && n->sym->ctype->parameters) {
                    Type *pt = array_get_byindex(n->sym->ctype->parameters, i);
                    if (pt && pt->kind == KIND_CHAR
                        && b->f->vregs[v].width != 1) {
                        int t = new_temp(b, 1);
                        b->f->vregs[t].width = 1;
                        Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                        cv->dst = t; cv->src[0] = v;
                        v = t;
                    }
                }
                /* Widen a narrow integer ARG to a wider prototyped PARAM.
                   The front-end leaves the int→long / int→long-long
                   promotion to codegen (the walker uses l_int2long_s /
                   l_i64_sint2i64); without it the value is pushed at its
                   own width and the param's high bytes are stack garbage.
                   Only long / long long params (the confirmed-broken
                   cases — char→int already promotes via the smallc push);
                   integer args only; an unprototyped (variadic) slot has
                   no Type and is left as-is. */
                if (n->sym->ctype && n->sym->ctype->parameters) {
                    Type *pt = array_get_byindex(n->sym->ctype->parameters, i);
                    Kind ak  = a->type ? (Kind)a->type->kind : KIND_NONE;
                    int  uns = a->type && a->type->isunsigned;
                    if (pt && kind_is_integer(pt->kind) && kind_is_integer(ak)) {
                        int aw = b->f->vregs[v].width;
                        if (pt->kind == KIND_LONGLONG && ak != KIND_LONGLONG) {
                            if (aw == 1) {
                                int wt = new_temp(b, 2);
                                b->f->vregs[wt].width = 2;
                                Op *cv = ir_op_emit(cur_bb(b),
                                          uns ? IR_CONV_ZX : IR_CONV_SX);
                                cv->dst = wt; cv->src[0] = v; v = wt;
                            }
                            v = emit_acc_int_from_int(b, v, uns);
                        } else if (type_width(pt) == 4 && aw < 4) {
                            int wt = new_temp(b, 4);
                            b->f->vregs[wt].width = 4;
                            Op *cv = ir_op_emit(cur_bb(b),
                                      uns ? IR_CONV_ZX : IR_CONV_SX);
                            cv->dst = wt; cv->src[0] = v; v = wt;
                        }
                    }
                }
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
        /* long long args ride the wide stack-push path (l_i64_load +
           l_i64_push, 8 bytes); a long long return uses the stuffed-pointer
           ABI below. */
        int ret_ll = (n->sym->ctype && n->sym->ctype->return_type
                      && n->sym->ctype->return_type->kind == KIND_LONGLONG);
        int ret_v = new_temp(b, ret_w);
        if (ret_ll) b->f->vregs[ret_v].kind = KIND_LONGLONG;
        Op *op = ir_op_emit(cur_bb(b), IR_CALL);
        op->dst = ret_v;
        CallInfo *ci = calloc(1, sizeof(CallInfo));
        ci->ret_longlong = ret_ll;
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
        /* Special calling conventions live on ci->flags (a copy of the
           target's ctype flags); gen_call reads them with `& bit` and
           emits the trampoline / rst / banked dispatch instead of a plain
           `call _name` (each was a silent miscompile). Args/cleanup/return
           stay the normal ABI. The rst/module/address operands aren't in
           the flags, so carry them as values. */
        ci->flags = flags;
        if (flags & SHORTCALL) {
            ci->shortcall_rst   = n->sym->ctype->funcattrs.shortcall_rst;
            ci->shortcall_value = n->sym->ctype->funcattrs.shortcall_value;
        }
        if (flags & HL_CALL) {
            ci->hlcall_module = n->sym->ctype->funcattrs.hlcall_module;
            ci->hlcall_addr   = n->sym->ctype->funcattrs.hlcall_addr;
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
        int ret_ll = (fntype && fntype->return_type
                      && fntype->return_type->kind == KIND_LONGLONG);
        int ret_v = new_temp(b, ret_w);
        if (ret_ll) b->f->vregs[ret_v].kind = KIND_LONGLONG;
        Op *op = ir_op_emit(cur_bb(b), IR_CALL);
        op->dst = ret_v;
        CallInfo *ci = calloc(1, sizeof(CallInfo));
        ci->ret_longlong = ret_ll;
        ci->target     = NULL;       /* indirect */
        ci->fnptr_vreg = fnptr_v;
        /* __far function pointer: dispatch via the banking trampoline
           (l_farcall) rather than the near l_jphl, which silently dropped
           the bank and only did a near `jp (hl)`. */
        ci->far_fnptr  = node_is_far_ptr(n->callee);
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
        /* int/long → float: l_f{16,32}_{s,u}{int,long}2f. The int2f
           helpers take HL (int) / DEHL (long), not a bare byte — widen a
           char source to int first (by its own signedness). Result width
           is the float's (2 for f16, 4 for f32). */
        if (!kind_is_floating(src_k) && !is_acc_int_kind(src_k)
            && is_supported_float_kind(dst_k)) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            if (b->f->vregs[src_v].width == 1) {
                int wtmp = new_temp(b, 2);
                b->f->vregs[wtmp].width = 2;
                Op *cv = ir_op_emit(cur_bb(b),
                                    uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wtmp; cv->src[0] = src_v;
                src_v = wtmp;
            }
            int sw = b->f->vregs[src_v].width;
            const char *helper = float_helper(dst_k, (sw == 4)
                ? (uns ? "ulong2f" : "slong2f")
                : (uns ? "uint2f"  : "sint2f"));
            int fw = width_for_kind(dst_k);
            int conv_v = new_temp(b, fw);
            b->f->vregs[conv_v].width = (int16_t)fw;
            b->f->vregs[conv_v].kind  = dst_k;
            int *args = calloc(1, sizeof(int)); args[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = conv_v;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = helper; hi->args = args;
            hi->n_args = 1; hi->ret_vreg = conv_v;
            op->hcall = hi;
            return conv_v;
        }
        /* float → int/long: l_f{16,32}_f2{s,u}{int,long}, HL/DEHL in,
           HL (int) or DEHL (long) out; a char dst narrows the result. A
           long long dst is not "int" here — it would need f2sllong (a
           register-tier ll<->float path not yet built), so exclude it and
           let it bail to the walker. */
        if (is_supported_float_kind(src_k) && !kind_is_floating(dst_k)
            && !is_acc_int_kind(dst_k)) {
            int dst_uns = n->type && n->type->isunsigned;
            int ret_w = (dst_w == 4) ? 4 : 2;
            const char *helper = float_helper(src_k, (ret_w == 4)
                ? (dst_uns ? "f2ulong" : "f2slong")
                : (dst_uns ? "f2uint"  : "f2sint"));
            int conv_v = new_temp(b, ret_w);
            b->f->vregs[conv_v].width = (int16_t)ret_w;
            int *args = calloc(1, sizeof(int)); args[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = conv_v;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = helper; hi->args = args;
            hi->n_args = 1; hi->ret_vreg = conv_v;
            op->hcall = hi;
            if (dst_w == 1) {
                int bt = new_temp(b, 1);
                b->f->vregs[bt].width = 1;
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = bt; tr->src[0] = conv_v;
                return bt;
            }
            return conv_v;
        }
        /* int/long → 5/6-byte double (accumulator tier). A long long source
           is NOT an int here — it routes through the ll<->double branch
           below (sllong2f), so exclude it. char source is
           widened to int first (the conv helpers take HL/DEHL). */
        if (!kind_is_floating(src_k) && !is_acc_int_kind(src_k)
            && is_acc_float_kind(dst_k)) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            if (b->f->vregs[src_v].width == 1) {
                int wt = new_temp(b, 2);
                b->f->vregs[wt].width = 2;
                Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wt; cv->src[0] = src_v;
                src_v = wt;
            }
            return emit_acc_from_int(b, src_v, uns);
        }
        /* 5/6-byte double → int/long via ifix (returns DEHL; HL taken for
           int, DEHL for long). A long long dst routes through the
           ll<->double branch below (f2sllong), so exclude it. A char dst
           narrows the int result. */
        if (is_acc_float_kind(src_k) && !kind_is_floating(dst_k)
            && !is_acc_int_kind(dst_k)) {
            int iv = emit_acc_to_int(b, src_v, (dst_w == 4) ? 4 : 2);
            if (dst_w == 1) {
                int bt = new_temp(b, 1);
                b->f->vregs[bt].width = 1;
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = bt; tr->src[0] = iv;
                return bt;
            }
            return iv;
        }
        /* int/char/long → long long (l_i64_{s,u}{int,long}2i64). char
           source is widened to int first (the helpers take HL/DEHL). */
        if (!kind_is_floating(src_k) && is_acc_int_kind(dst_k)) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            if (b->f->vregs[src_v].width == 1) {
                int wt = new_temp(b, 2);
                b->f->vregs[wt].width = 2;
                Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = wt; cv->src[0] = src_v;
                src_v = wt;
            }
            return emit_acc_int_from_int(b, src_v, uns);
        }
        /* long long → int/long via l_i64_s64_toi32 (truncates to DEHL; HL
           for an int dst, DEHL for long). A char dst narrows further. */
        if (is_acc_int_kind(src_k) && !kind_is_floating(dst_k)) {
            int iv = emit_acc_int_to_int(b, src_v, (dst_w == 4) ? 4 : 2);
            if (dst_w == 1) {
                int bt = new_temp(b, 1);
                b->f->vregs[bt].width = 1;
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = bt; tr->src[0] = iv;
                return bt;
            }
            return iv;
        }
        /* long long → 5/6/8-byte double (sllong2f/ullong2f): __i64_acc → FA.
           Signedness from the ll source. */
        if (is_acc_int_kind(src_k) && is_acc_float_kind(dst_k)) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            return emit_acc_lldouble(b, src_v, /*to_double=*/1, uns);
        }
        /* 5/6/8-byte double → long long (f2sllong/f2ullong): FA → __i64_acc.
           Signedness from the ll destination. */
        if (is_acc_float_kind(src_k) && is_acc_int_kind(dst_k)) {
            int uns = n->type && n->type->isunsigned;
            return emit_acc_lldouble(b, src_v, /*to_double=*/0, uns);
        }
        /* long long <-> 4-byte f32 double: no acc tier (f32 lives in DEHL,
           not FA). Emit the conventional l_f32_{s,u}llong2f / f2{s,u}llong
           helper call. These may be absent from a given f32 lib — prefer a
           LINK error there over a hard compile-time bail (the call is
           emitted so the op assembles; the missing symbol surfaces at
           link). */
        if (is_acc_int_kind(src_k) && dst_k == KIND_DOUBLE && c_fp_size == 4) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            int dst = new_temp(b, 4);
            b->f->vregs[dst].width = 4; b->f->vregs[dst].kind = KIND_DOUBLE;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL); op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = uns ? "l_f32_ullong2f" : "l_f32_sllong2f";
            hi->args = a; hi->n_args = 1; hi->ret_vreg = dst;
            op->hcall = hi;
            return dst;
        }
        if (src_k == KIND_DOUBLE && c_fp_size == 4 && is_acc_int_kind(dst_k)) {
            int uns = n->type && n->type->isunsigned;
            int dst = new_temp(b, 8);
            b->f->vregs[dst].width = 8; b->f->vregs[dst].kind = KIND_LONGLONG;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL); op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = uns ? "l_f32_f2ullong" : "l_f32_f2sllong";
            hi->args = a; hi->n_args = 1; hi->ret_vreg = dst;
            op->hcall = hi;
            return dst;
        }
        /* _Float16 <-> 5/6/8-byte double (FA cross-format): l_f48_f16tof
           loads an f16 (HL) into FA; l_f48_ftof16 converts FA back to an
           f16 (HL). Reuse the acc-unop int<->acc shapes — the f16 rides
           the width-2 "int reg" slot. (f32-tier double, c_fp_size==4, is
           NOT acc-tier and still bails below.) */
        if (src_k == KIND_FLOAT16 && is_acc_float_kind(dst_k)) {
            int w = c_fp_size;
            int dst = new_temp(b, w);
            b->f->vregs[dst].width = (int16_t)w;
            b->f->vregs[dst].kind  = KIND_DOUBLE;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
            op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = acc_name("f16tof"); hi->args = a; hi->n_args = 1;
            hi->ret_vreg = dst;
            hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
            hi->acc_width = w; hi->acc_subkind = ACC_SUB_INT2ACC;
            op->hcall = hi;
            return dst;
        }
        if (is_acc_float_kind(src_k) && dst_k == KIND_FLOAT16) {
            int dst = new_temp(b, 2);
            b->f->vregs[dst].width = 2;
            b->f->vregs[dst].kind  = KIND_FLOAT16;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
            op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = acc_name("ftof16"); hi->args = a; hi->n_args = 1;
            hi->ret_vreg = dst;
            hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
            hi->acc_width = c_fp_size; hi->acc_subkind = ACC_SUB_ACC2INT;
            op->hcall = hi;
            return dst;
        }
        /* _Float16 <-> 4-byte (f32-tier) double: register-based l_f32
           conversions. f16 in HL, f32 in DEHL. */
        if (src_k == KIND_FLOAT16 && dst_k == KIND_DOUBLE && c_fp_size == 4) {
            int dst = new_temp(b, 4);
            b->f->vregs[dst].width = 4;
            b->f->vregs[dst].kind  = KIND_DOUBLE;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = float_helper(KIND_DOUBLE, "f16tof");
            hi->args = a; hi->n_args = 1; hi->ret_vreg = dst;
            op->hcall = hi;
            return dst;
        }
        if (src_k == KIND_DOUBLE && c_fp_size == 4 && dst_k == KIND_FLOAT16) {
            int dst = new_temp(b, 2);
            b->f->vregs[dst].width = 2;
            b->f->vregs[dst].kind  = KIND_FLOAT16;
            int *a = calloc(1, sizeof(int)); a[0] = src_v;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            hi->name = float_helper(KIND_DOUBLE, "ftof16");
            hi->args = a; hi->n_args = 1; hi->ret_vreg = dst;
            op->hcall = hi;
            return dst;
        }
        /* Remaining float conversions (DOUBLE, float↔float of different
           formats) are NOT yet lowered. Bail rather than fall through to
           the width-based paths below, which would reinterpret the float
           bit pattern as a same-width integer (a miscompile, since e.g.
           _Float16 and int are both width 2). A no-op same-kind cast
           (FLOAT16→FLOAT16) is fine and handled by src_w==dst_w. */
        if ((kind_is_floating(src_k) || kind_is_floating(dst_k))
            && src_k != dst_k)
            return build_fail("float OP_CAST kind %d→%d not yet supported",
                              (int)src_k, (int)dst_k);
        /* → __far pointer: build the 4-byte DEHL far representation with
           bank (E) and pad (D) = 0. A near pointer / int widens by
           ZERO-extension (the high half is the bank, never a sign
           extension); an already-4-byte source (far/long) is just
           reinterpreted. */
        if (dst_k == KIND_CPTR) {
            if (src_w >= 4) {
                b->f->vregs[src_v].kind = KIND_CPTR;
                return src_v;
            }
            int dst = new_temp(b, 4);
            b->f->vregs[dst].width = 4;
            b->f->vregs[dst].kind  = KIND_CPTR;
            Op *op = ir_op_emit(cur_bb(b), IR_CONV_ZX);
            op->dst = dst; op->src[0] = src_v;
            return dst;
        }
        /* __far pointer → near pointer / int / char: drop the bank by
           truncating to the low half (offset). Falls through to the
           width-based TRUNC paths (4→2 / 4→1) below. */
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
            /* &faracc_global: a __banked global's address IS a far pointer
               — map it via l_far_mapaddr (IR_LD_FARSYM → KIND_CPTR). */
            if (sym_is_faracc(n->operand->sym))
                return emit_far_symaddr(b, n->operand->sym);
            /* &namespaced_global escapes the address into a plain pointer
               whose later deref can't page the bank — bail. */
            if (sym_is_namespaced(n->operand->sym))
                return build_fail("address of __addressmod symbol deferred");
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
           result temp, and the caller skips the wrapping MOV. Size the
           result from the ternary's type: hardcoding width 2 truncated
           a double/long/long-long ternary (`c ? da : db`) to its low
           word via the arm MOVs. */
        int rw = n->type ? width_for_kind(n->type->kind) : 2;
        if (rw <= 0) rw = 2;
        int result  = ALLOC_DST(rw);
        b->f->vregs[result].width = (int16_t)rw;
        if (n->type) b->f->vregs[result].kind = n->type->kind;

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

        /* Float compound-assign: load-modify-store via the l_f{16,32}_*
           helper. Only += and -= are valid on floats; &= |= ^= <<= >>=
           are invalid C and bail. */
        if ((n->left && n->left->type
             && kind_is_floating(n->left->type->kind))
            || (n->type && kind_is_floating(n->type->kind))) {
            if (n->ast_type == OP_AADD)
                return build_float_compound(b, n, "add");
            if (n->ast_type == OP_ASUB)
                return build_float_compound(b, n, "sub");
            return build_fail("float bitwise/shift compound-assign invalid");
        }

        /* long long compound-assign (ast_opt folds `x = x OP y` here). */
        if (n->left && n->left->type
            && is_acc_int_kind(n->left->type->kind)) {
            const char *stem = (n->ast_type == OP_AADD) ? "add"
                             : (n->ast_type == OP_ASUB) ? "sub"
                             : (n->ast_type == OP_AAND) ? "and"
                             : (n->ast_type == OP_AOR)  ? "or"
                             : (n->ast_type == OP_AXOR) ? "xor"
                             : (n->ast_type == OP_ASSHL)? "shl"
                             : (n->ast_type == OP_ASSHR)? "shr" : NULL;
            if (!stem)
                return build_fail("ll compound-assign op %d not supported",
                                  (int)n->ast_type);
            return build_ll_compound(b, n, stem);
        }

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
            /* A width-4 LHS (long, or a __far pointer whose scaled index
               is a width-2 int — `fp += i`) needs the RHS widened to 4
               bytes first: the aliased 4-byte add otherwise reads the
               high half of the narrow RHS from below sp (garbage). */
            int lw = b->f->vregs[lhs_v].width;
            int rw = b->f->vregs[rhs_v].width;
            if (lw == 4 && rw < 4) {
                int tmp = new_temp(b, 4);
                b->f->vregs[tmp].width = 4;
                int uns = n->right->type && n->right->type->isunsigned;
                Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = tmp; cv->src[0] = rhs_v;
                rhs_v = tmp;
            }
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
           combine, store back. A namespaced LHS (`arr[i] += x`) pages the
           bank on both the load and the store; the lowerer dedups the two
           page-in calls to one (same bank, no intervening call), matching
           sccz80's single `_setb1` for the rmw. */
        SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
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
        ld->mem.bank_fn = bf;
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
        st->mem.bank_fn = bf;
        return dst;
    }

    case OP_AMULT: case OP_ADIV: case OP_AMOD: {
        /* Compound multiply/divide/modulo: LHS op= RHS.
           Always uses a runtime helper (no direct IR binop).
           Same helper table and argument convention as OP_MULT/DIV/MOD. */
        if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
            return build_fail("compound *=/div/mod LHS shape not yet supported");

        /* Float compound *= / /= via the l_f{16,32}_* helper; %= on a
           float is invalid C and bails. */
        if ((n->left->type && kind_is_floating(n->left->type->kind))
            || (n->type && kind_is_floating(n->type->kind))) {
            if (n->ast_type == OP_AMULT)
                return build_float_compound(b, n, "mul");
            if (n->ast_type == OP_ADIV)
                return build_float_compound(b, n, "div");
            return build_fail("float %%= invalid");
        }

        /* long long compound *= /= %= (ast_opt folds `x = x OP y` here). */
        if (n->left->type && is_acc_int_kind(n->left->type->kind)) {
            const char *stem = (n->ast_type == OP_AMULT) ? "mul"
                             : (n->ast_type == OP_ADIV)  ? "div" : "mod";
            return build_ll_compound(b, n, stem);
        }

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
        }
        SYMBOL *bf_md = NULL;
        if (!is_local && !is_global) {
            /* `arr[i] *= x` into a named address space: page the bank on
               both the load and the store (the helper call between them
               resets the dedup, so both re-page — matching sccz80). */
            bf_md = (SYMBOL *)deref_bank_fn(n->left);
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
            ld->mem.bank_fn = bf_md;
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
            st->mem.bank_fn = bf_md;
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

/* A __naked function body may contain ONLY asm — no prologue/epilogue/frame
   is generated, so any C statement would have no frame to run against.
   True iff `n` is a bare asm block, or a compound of nothing but asm blocks.
   An empty body is vacuously asm-only (emits nothing). */
static int naked_body_is_asm_only(const Node *n)
{
    if (!n) return 1;
    if (n->ast_type == AST_ASM) return 1;
    if (n->ast_type == AST_COMPOUND_STMT) {
        if (!n->stmts) return 1;
        int ns = (int)array_len(n->stmts);
        for (int i = 0; i < ns; i++) {
            const Node *s = array_get_byindex(n->stmts, i);
            if (s && s->ast_type != AST_ASM) return 0;
        }
        return 1;
    }
    return 0;
}

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
        if (!is_supported_int_kind(n->sym->type)
            && !is_supported_float_kind(n->sym->type)
            && !is_acc_float_kind(n->sym->type)
            && !is_acc_int_kind(n->sym->type)
            && (Kind)n->sym->type != KIND_CPTR)   /* __far pointer local */
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
            /* Wide accumulator local (long long / 5-8B double) initialised
               from a narrower scalar: the parser leaves the implicit C
               conversion off the init expr, so build it at its own width
               and insert the int→acc conversion here. A raw wide MOV would
               reinterpret the integer's bytes as a wide value (garbage —
               this also silently mis-lowered `double d = i;`). Don't hint
               into v: v is wider than the register the init lands in. */
            Kind vk = (Kind)n->sym->type;
            if (is_acc_int_kind(vk) || is_acc_float_kind(vk)) {
                int init_v = build_expr(b, n->declvar);
                if (init_v < 0) return -1;
                Kind ik = b->f->vregs[init_v].kind;
                if (b->f->vregs[init_v].width <= 4
                    && ((is_acc_int_kind(vk)   && !is_acc_int_kind(ik))
                     || (is_acc_float_kind(vk) && !kind_is_floating(ik)))) {
                    int uns = n->declvar->type && n->declvar->type->isunsigned;
                    if (b->f->vregs[init_v].width == 1) {
                        int wt = new_temp(b, 2); b->f->vregs[wt].width = 2;
                        Op *cv = ir_op_emit(cur_bb(b),
                                            uns ? IR_CONV_ZX : IR_CONV_SX);
                        cv->dst = wt; cv->src[0] = init_v; init_v = wt;
                    }
                    init_v = is_acc_int_kind(vk)
                        ? emit_acc_int_from_int(b, init_v, uns)
                        : emit_acc_from_int(b, init_v, uns);
                    if (init_v < 0) return -1;
                }
                if (init_v != v)
                    ir_emit_mov(cur_bb(b), v, init_v);
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
    /* Wide memory-accumulator primitive names for the active maths mode —
       the lowerer's generic MOV/LD_MEM/ST_MEM/RET/CALL paths read these
       (keeps ir_lower decoupled from c_fp_size / the maths table). */
    f->acc_load     = acc_name("load");
    f->acc_store    = acc_name("store");
    f->acc_push     = acc_name("push");
    f->acc_loadpush = acc_name("loadpush");

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
    /* Fastcall CALLEE: the last param arrives in HL (width 1/2) or DEHL
       (width 4 — long / __far ptr / IEEE-32 double). emit_prologue captures
       it into the param's home across the frame alloc (width 1/2 via DE,
       width 4 via BC for the low half — DE keeps the high half). A wide
       (5/6/8-byte) arg arrives in the FA / __i64_acc accumulator and is
       stored to its slot after the frame alloc. Only widths 3 and 0 (none
       real for a scalar) bail. */
    if (fn->ctype && (fn->ctype->flags & FASTCALL)
        && fn->ctype->parameters && array_len(fn->ctype->parameters) > 0) {
        Type *fa = array_get_byindex(fn->ctype->parameters,
                                     array_len(fn->ctype->parameters) - 1);
        int fw = fa ? width_for_kind(fa->kind) : 0;
        if (fw != 1 && fw != 2 && fw != 4 && fw < 5) {
            builder_free(&b);
            ir_func_free(f);
            return build_fail("fastcall callee arg width %d not yet supported",
                              fw);
        }
    }

    /* __naked: the user owns the entire body. No prologue/epilogue/frame
       is generated — `is_naked` gates the IX setup, frame alloc and the
       trailing `ret` off (the asm provides its own). Because there is no
       frame, the body may contain ONLY asm; any C statement would have
       nothing to run against. Reject anything else with a hard error
       (not a walker bail, which would silently miscompile it). */
    if (fn->ctype && (fn->ctype->flags & NAKED)) {
        f->is_naked = 1;
        if (!naked_body_is_asm_only(body)) {
            errorfmt_at(body ? body->filename : NULL,
                        body ? body->line : 0, 0,
                        "__naked function '%s' may contain only an asm block",
                        fn->name[0] ? fn->name : "?");
            builder_free(&b);
            ir_func_free(f);
            return 0;   /* error reported; do NOT fall back to the walker */
        }
        /* fall through — build the asm with no params/frame/epilogue */
    }

    /* A function that *returns* long long receives a hidden stuffed
       pointer (result-buffer address) just above the return address, so
       every param offset shifts +2 (the lowerer keys off this flag). The
       result is produced in __i64_acc, which survives teardown, so the
       return needs no copy. */
    if (fn->ctype && fn->ctype->return_type
        && fn->ctype->return_type->kind == KIND_LONGLONG)
        f->returns_longlong = 1;

    /* Copy the function's ctype flags onto the IR func so the lowerer can
       test modifiers (SDCCDECL, …) with `& bit`. __z88dk_sdccdecl makes a
       char param occupy 1 caller-byte (not the smallc 2-byte int promote);
       the prologue / param-offset layout reads f->flags & SDCCDECL. */
    if (fn->ctype) f->flags = fn->ctype->flags;

    /* __z88dk_params_offset(N) (and the implicit 4 for a TICALC banked
       definition): every parameter sits N bytes higher on the caller
       stack. emit_prologue / param_caller_off add this to the base. */
    if (fn->ctype) f->params_offset = fn->ctype->funcattrs.params_offset;

    /* __interrupt: the IR owns the epilogue (pop-all + reti/retn). The
       irq value picks the return form (bare __interrupt = -1 → reti). */
    if (fn->ctype && (fn->ctype->flags & INTERRUPT)) {
        f->is_interrupt  = 1;
        f->interrupt_irq = fn->ctype->funcattrs.interrupt;
    }

    /* Pre-create PARAM vregs in declaration order so the lowerer's
       param-init prologue picks them up before any temps. Each param's
       SYMBOL lives in loctab keyed by its source name. (Naked functions
       have no managed prologue — the asm reads params directly off the
       caller stack — so skip param vregs entirely.) */
    if (!f->is_naked && fn->ctype && fn->ctype->parameters) {
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
            if (!is_supported_int_kind(psym->type)
                && !is_supported_float_kind(psym->type)
                && !is_acc_float_kind(psym->type)
                && !is_acc_int_kind(psym->type)
                && (Kind)psym->type != KIND_CPTR) {  /* __far pointer param */
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

    /* Flag a function that uses an IX-clobbering maths helper so the
       lowerer keeps it off the IX frame under -frameix. The only such
       helper now is genmath (6-byte double, c_fp_size==6): its dcallee
       shim stashes the return address in IX. long long (l_i64_*) and
       4/5-byte double (daimath32/cpcmath) preserve IX, so those stay on
       the frame pointer. */
    if (c_fp_size == 6) {
        for (int i = 0; i < f->n_vregs; i++) {
            if (f->vregs[i].width > 4
                && f->vregs[i].kind == KIND_DOUBLE) {
                f->uses_acc = 1;
                break;
            }
        }
    }

    rc = ir_lower_to_output(f);
    /* A lowering failure (ir_lower returns nonzero) used to propagate as a
       SILENT bail — ir_lower has no build_fail. Name it so the bail is
       diagnosed (the walker is gone, so this is fatal). ir_lower prints
       its own `ir_lower: ...` reason above for the specific op. */
    if (rc != 0 && !build_fail_emitted)
        build_fail("ir_lower could not lower an op (see ir_lower diagnostic above)");

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
