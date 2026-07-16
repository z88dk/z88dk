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
    Type *ret_type;    /* current function's C return type — used to widen
                          a narrower `return x;` to the declared width */
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

/* Set by build_fail so ir_generate_code can tell a diagnosed bail (named
   reason) from a SILENT one — a bare `return -1`/`-2`. A silent bail drops
   IR coverage with no diagnostic, so we flag it. */
static int build_fail_emitted;

/* Source location of the node currently being built — updated at each
   build_stmt / build_expr entry so build_fail can name the file:line (and
   echo the offending source line). Kept separate from ir_set_emit_loc so
   finer expression-level tracking here does NOT perturb the statement-level
   C_LINE stamping on emitted ops. */
static const char *cur_node_file;
static int         cur_node_line;

/* Copy `file` into `buf` stripped of the surrounding quotes that node
   filenames carry (set from `Filename`, which keeps the #line quotes).
   Returns buf, or NULL if file is empty. */
static const char *unquote_file(const char *file, char *buf, size_t n)
{
    if (!file || !*file) return NULL;
    size_t len = strlen(file);
    if (len >= 2 && file[0] == '"' && file[len-1] == '"') { file++; len -= 2; }
    if (len >= n) len = n - 1;
    memcpy(buf, file, len);
    buf[len] = 0;
    return buf;
}

/* Echo the offending source line (gcc-style), indented, to stderr. The
   node filenames are the original sources (same as C_LINE), so this opens
   the real .c — best-effort, silent on any error. */
static void build_fail_show_src(const char *file, int line)
{
    char path[512];
    if (!unquote_file(file, path, sizeof path) || line <= 0) return;
    FILE *f = fopen(path, "r");
    if (!f) return;
    char buf[512];
    int cur = 0;
    while (fgets(buf, sizeof buf, f)) {
        if (++cur != line) continue;
        size_t len = strlen(buf);
        while (len && (buf[len-1] == '\n' || buf[len-1] == '\r')) buf[--len] = 0;
        const char *p = buf;
        while (*p == ' ' || *p == '\t') p++;   /* trim leading indent */
        fprintf(stderr, "    %s\n", p);
        break;
    }
    fclose(f);
}

static int build_fail(const char *fmt, ...)
{
    char path[512];
    const char *file = unquote_file(cur_node_file, path, sizeof path);
    va_list ap;
    va_start(ap, fmt);
    /* Lead with `file:line:` (gcc-style) so editors / make output scanners
       pick it up; the ir_build tag + function follow the `error:` keyword. */
    if (file && cur_node_line > 0)
        fprintf(stderr, "%s:%d: error: ir_build: [%s] ",
                file, cur_node_line, cur_fn_name);
    else
        fprintf(stderr, "ir_build: [%s] ", cur_fn_name);
    vfprintf(stderr, fmt, ap);
    fputc('\n', stderr);
    va_end(ap);
    build_fail_show_src(cur_node_file, cur_node_line);
    build_fail_emitted = 1;
    return -1;
}

/* ----- Expression builder — returns the vreg holding the result, or -1
   on failure. Width is inferred from node->type when available.

   `hint` is an optional caller-provided destination vreg. When >= 0 and
   the expression supports it, the result is written directly to `hint`
   and `hint` is returned, eliminating the intermediate-temp + MOV the
   caller would otherwise emit. Cases that don't support a hint (e.g. a
   bare local-var read where the value already lives in another vreg)
   return that vreg; the caller must emit the MOV. Pass -1 to force a
   fresh temp. */

static int build_expr_hinted(Builder *b, Node *n, int hint);
static int build_binop_integer(Builder *b, Node *n, OpKind k, int hint);
static int build_assign(Builder *b, Node *n);
static int build_cast(Builder *b, Node *n);
static int build_cond(Builder *b, Node *n, int true_bb, int false_bb);
static int build_muldiv_integer(Builder *b, Node *n);
static int coerce_int_to_float_kind(Builder *b, int v, Node *src, Kind dst_k);
static int init_typed_region(Builder *b, int base, int off,
                             Type *t, Node *init, int *budget);

/* The inline mem/str loop forms (IR_MEMSET ldir/djnz, IR_MEMCPY ldir,
   IR_STRCPY ldi, IR_STRCHR jr) use Z80-only block ops and relative
   jumps. 8080/8085 lack them; gbz80 encodes them differently than the
   IR loop forms emit. On those targets we keep the inline only for the
   pure ld/inc unrolls (tiny counts) and otherwise fall back to the
   library call — correct, just not inlined. */
static int ir_inline_block_ops_ok(void)
{
    return !IS_808x() && !IS_GBZ80();
}

static int build_expr(Builder *b, Node *n)
{
    return build_expr_hinted(b, n, -1);
}

/* The INTEGER kind whose natural width is `w`. Used by new_temp so a freshly-
   minted integer temp is born kind/width-CONSISTENT rather than carrying a
   KIND_CHAR placeholder a width-2/4/8 consumer (one that reads kind) would
   misread.
   Only the unambiguous integer widths are mapped; non-integer widths (6-byte
   double, etc.) keep KIND_CHAR so the float-tier heuristics (uses_acc / IX
   frame-pointer choice) are not perturbed — those temps are typed explicitly
   at their call site, which is the only place that can pick among same-width
   kinds (int / float16 / accum / ptr). */
static Kind int_kind_for_width(int w)
{
    switch (w) {
    case 2:  return KIND_INT;
    case 4:  return KIND_LONG;
    case 6:  return KIND_DOUBLE;   /* math48 6-byte double temp — correct kind
                                      drives uses_acc / non-IX frame (the double
                                      helpers clobber IX) */
    case 8:  return KIND_LONGLONG;
    default: return KIND_CHAR;     /* 1 (already consistent) + other widths */
    }
}

/* Allocate a fresh temp of the given width, born with a width-consistent
   (integer/double) kind. Callers holding a non-integer same-width kind
   (float16, _Accum, pointer, cptr, a double in a non-6-byte mode) override
   .kind right after — see int_kind_for_width. Prefer new_temp_kind() when the
   kind is known: it sets kind AND derives the matching width in one call. */
static int new_temp(Builder *b, int width)
{
    int w = (width > 0) ? width : 2;
    int v = ir_vreg_new(b->f, int_kind_for_width(w), NULL, 0);
    b->f->vregs[v].width = w;
    return v;
}

static int width_for_kind(Kind k);   /* defined below; maths-mode-aware */

/* Allocate a fresh temp of a known KIND, deriving its width from the kind
   (width_for_kind — maths-mode-aware for double/float). The sound counterpart
   to new_temp(width): kind is authoritative, width follows. Folds the common
   `new_temp(b,W); vregs[t].kind=K; vregs[t].width=W` triple into one call.
   Not for aggregates (KIND_ARRAY/STRUCT), whose size isn't kind-derivable —
   use new_temp(width) there. */
static int new_temp_kind(Builder *b, Kind k)
{
    int v = ir_vreg_new(b->f, k, NULL, 0);
    int w = width_for_kind(k);
    b->f->vregs[v].width = (int16_t)((w > 0) ? w : 2);
    return v;
}

/* Integer kinds + _Accum. _Accum ADD/SUB/CMP/NEG are bit-identical
   to integer ops; MUL/DIV need fix-scaling helpers and bail. */
static int is_register_int_kind(Kind k)
{
    return k == KIND_CHAR || k == KIND_INT || k == KIND_SHORT
        || k == KIND_PTR  || k == KIND_LONG
        || k == KIND_ACCUM16 || k == KIND_ACCUM32;
}

/* Float kinds the IR can currently lower (register tier only):
   KIND_FLOAT16 (always 2-byte _Float16, l_f16_* helpers, mode-
   independent) and KIND_DOUBLE *when* c_fp_size==4 (IEEE-32 / MBF-single
   / DAI / AM9511, l_f32_* helpers, DEHL). 5/6/8-byte doubles are the
   memory-FA tier, not yet lowered. */
static int is_register_float_kind(Kind k)
{
    return k == KIND_FLOAT16
        || (k == KIND_DOUBLE && c_fp_size == 4);
}

/* __sdcccall(1) passes/returns a double in the 4-byte HLDE slot, which only
   works when `double` is 4 bytes (c_fp_size==4: -fp-mode=ieee / --math-mbf32).
   A 6/8-byte double can't use the register ABI — interop would be silently
   wrong, so reject it. Returns 1 if `fntype` has a double param or return and
   c_fp_size != 4. */
static int sc1_has_wide_double(const Type *fntype)
{
    if (c_fp_size == 4 || !fntype) return 0;
    if (fntype->return_type && fntype->return_type->kind == KIND_DOUBLE)
        return 1;
    if (fntype->parameters)
        for (int i = 0; i < (int)array_len(fntype->parameters); i++) {
            Type *pt = array_get_byindex(fntype->parameters, i);
            if (pt && pt->kind == KIND_DOUBLE) return 1;
        }
    return 0;
}

/* The value kind an operand actually produces. A function-pointer call
   node keeps its KIND_FUNC type because the call lowering still reads
   return_type/flags/funcattrs from it (direct calls are unwrapped to the
   return type by normalize_types; fnptr calls are not). For type
   inspection (e.g. choosing a float compare helper) we want the call's
   return kind, not KIND_FUNC. */
static Type *node_value_type(Node *n)
{
    if (!n || !n->type) return n ? n->type : NULL;
    if ((n->ast_type == AST_FUNCPTR_CALL || n->ast_type == AST_FUNC_CALL)
        && n->type->kind == KIND_FUNC && n->type->return_type)
        return n->type->return_type;
    return n->type;
}
static Kind node_value_kind(Node *n)
{
    Type *t = node_value_type(n);
    return t ? t->kind : KIND_NONE;
}

/* Wide memory-accumulator float kind: KIND_DOUBLE in a 5/6-byte (d* /
   l_f48 family) or 8-byte (l_f64 / mbf64) format. Disjoint from
   is_register_float_kind (the register tier).
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
   `double`) are plain HL / DEHL values, so they reuse the integer helpers.
   Returns NULL only for widths with no far helper. (lp_gdoub/lp_glonglong
   may not exist in every maths lib — we emit the call regardless and let
   the link resolve it.) */
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
    int fp = new_temp_kind(b, KIND_CPTR);
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
    /* Shift count never exceeds 63, so it always fits in A — use the
       count-in-A entries (l_i64_aslo/asro/asr_uo) and never widen the count
       to an i64 (the l_i64_asl/asr entries just copy __i64_acc's low byte
       into A and fall through to these). */
    if (!strcmp(stem, "shl")) return "l_i64_aslo";
    if (!strcmp(stem, "shr")) return is_unsigned ? "l_i64_asr_uo" : "l_i64_asro";
    if (!strcmp(stem, "lt"))  return is_unsigned ? "l_i64_ult" : "l_i64_lt";
    if (!strcmp(stem, "le"))  return is_unsigned ? "l_i64_ule" : "l_i64_le";
    if (!strcmp(stem, "gt"))  return is_unsigned ? "l_i64_ugt" : "l_i64_gt";
    if (!strcmp(stem, "ge"))  return is_unsigned ? "l_i64_uge" : "l_i64_ge";
    if (!strcmp(stem, "eq"))  return "l_i64_eq";
    if (!strcmp(stem, "ne"))  return "l_i64_ne";
    return NULL;
}

/* Operands of these stems are interchangeable, so the lowerer may push
   whichever is already accumulator-resident (skipping a reload). Excludes
   sub/div/mod/shifts and the ordered compares (lt/le/gt/ge). */
static int acc_stem_commutative(const char *stem)
{
    return stem && (!strcmp(stem, "add") || !strcmp(stem, "and")
                 || !strcmp(stem, "or")  || !strcmp(stem, "xor")
                 || !strcmp(stem, "mul") || !strcmp(stem, "eq")
                 || !strcmp(stem, "ne"));
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
        { "invf",    "l_f16_invf",    "l_f32_invf"    },
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
    /* float/double width is the active maths mode (not kind-derivable);
       everything else comes from the shared kind_scalar_width (ir_kind.h),
       which the IR/analysis layer also uses. __far KIND_CPTR is width-4 in
       registers (D=0,E=bank,HL=offset — low 3 bytes of a long; 3B in mem). */
    if (k == KIND_DOUBLE || k == KIND_FLOAT)  return c_fp_size;
    return kind_scalar_width(k);
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
    /* volatile local: force a memory slot so every access is a real
       load/store (no register residency, const-prop or store-forward). */
    if (sym->ctype && sym->ctype->isvolatile)
        b->f->vregs[v].flags |= IR_VREG_VOLATILE;
    sym_map_set(b, sym, v);
    return v;
}

/* Typed-region initialiser for AST_DECL aggregate init lists.

   Walks the TYPE (struct fields / array elements / scalar leaf) in
   parallel with the init nodes, emitting IR_ST_MEM at base+off for
   each leaf — and ZERO-FILLING leaves the list doesn't cover (C
   semantics: a partial initialiser zeroes the remainder, so `int a[4]
   = {9}` zeroes a[1..3]).

   `*budget` caps the total stores (zero-fill of a big `= {0}` array
   would explode the function — past the cap we bail with -2).

   Returns 0 ok, -1 hard error (already reported), -2 unsupported
   shape (caller emits the build_fail; the partially built IR is
   discarded with the function). */
#define INIT_REGION_MAX_STORES 32

/* Store one bitfield's initialiser into its storage unit at base+unit_off.
   The struct region was zeroed first (caller), so this only has to OR in
   `(value & mask) << bit_offset` (no clear-bits step). Read-modify-write of
   the unit preserves sibling fields already written. Returns 0 / -1 / -2. */
static int init_bitfield(Builder *b, int base, int unit_off,
                         Type *fld, Node *init, int *budget)
{
    int bsize = fld->bit_size, boff = fld->bit_offset;
    int unit_w = (boff + bsize <= 8) ? 1 : 2;
    Kind unit_k = (unit_w == 1) ? KIND_CHAR : KIND_INT;
    int64_t mask = ((int64_t)1 << bsize) - 1;
    if (--(*budget) < 0) return -2;
    int v = build_expr(b, init);
    if (v < 0) return -1;
    if (b->f->vregs[v].width != 2) {
        int t2 = new_temp(b, 2); b->f->vregs[t2].width = 2;
        OpKind cv = (b->f->vregs[v].width > 2)
                  ? IR_CONV_TRUNC
                  : (init->type && init->type->isunsigned ? IR_CONV_ZX : IR_CONV_SX);
        Op *c = ir_op_emit(cur_bb(b), cv); c->dst = t2; c->src[0] = v; v = t2;
    }
    /* (v & mask) << boff. unit_w-wide so a byte unit emits a BYTE RMW (the
       lowerer sizes mem ops by vreg width, not elem); a word RMW would clobber
       the neighbouring byte. A byte unit's value fits a byte (boff+bsize<=8). */
    int vm = new_temp(b, unit_w); b->f->vregs[vm].width = (int16_t)unit_w;
    Op *a1 = ir_op_emit(cur_bb(b), IR_AND);
    a1->dst = vm; a1->src[0] = v; a1->src[1] = -1; a1->imm = mask;
    int vms = vm;
    if (boff > 0) {
        vms = new_temp(b, unit_w); b->f->vregs[vms].width = (int16_t)unit_w;
        Op *sl = ir_op_emit(cur_bb(b), IR_SHL);
        sl->dst = vms; sl->src[0] = vm; sl->src[1] = -1; sl->imm = boff;
    }
    int cont = new_temp(b, unit_w); b->f->vregs[cont].width = (int16_t)unit_w;
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = cont; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = base; ld->mem.offset = unit_off; ld->mem.elem = unit_k;
    int newv = new_temp(b, unit_w); b->f->vregs[newv].width = (int16_t)unit_w;
    ir_emit_binop(cur_bb(b), IR_OR, newv, cont, vms);
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0] = newv; st->mem.kind = IR_MEM_VREG;
    st->mem.base = base; st->mem.offset = unit_off; st->mem.elem = unit_k;
    return 0;
}

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
        int has_bf = 0;
        for (int i = 0; i < n_fld; i++) {
            Type *fld = array_get_byindex(tag->fields, i);
            if (fld && fld->bit_size > 0) { has_bf = 1; break; }
        }
        /* Bitfields pack several fields (and unnamed padding) into one storage
           unit, so a per-field plain store would clobber siblings. Zero the
           whole struct region first, then OR each named bitfield in — padding /
           unnamed / unlisted bits stay 0. */
        if (has_bf) {
            int sz = (int)t->size;
            for (int z = 0; z < sz; ) {
                int cw = (sz - z >= 2) ? 2 : 1;
                if (--(*budget) < 0) return -2;
                int zv = new_temp(b, cw); b->f->vregs[zv].width = (int16_t)cw;
                ir_emit_ld_imm(cur_bb(b), zv, 0);
                Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
                st->src[0] = zv; st->mem.kind = IR_MEM_VREG; st->mem.base = base;
                st->mem.offset = off + z;
                st->mem.elem = (cw == 1) ? KIND_CHAR : KIND_INT;
                z += cw;
            }
        }
        /* `ii` walks the init list; an UNNAMED bitfield occupies layout but
           consumes no initialiser (C positional rule), so it doesn't advance
           ii. For a struct without unnamed bitfields ii == field index. */
        int ii = 0;
        for (int i = 0; i < n_fld; i++) {
            Type *fld = array_get_byindex(tag->fields, i);
            if (!fld) continue;
            if (fld->bit_size > 0) {
                if (!fld->name[0]) continue;  /* unnamed: zeroed */
                Node *sub = (ii < n_init)
                          ? array_get_byindex(init->stmts, ii) : NULL;
                ii++;
                if (!sub) continue;                          /* zero-initialised */
                if (sub->ast_type == AST_INIT_LIST) return -2;
                int rc = init_bitfield(b, base, off + (int)fld->offset,
                                       fld, sub, budget);
                if (rc < 0) return rc;
                continue;
            }
            Node *sub = (ii < n_init)
                      ? array_get_byindex(init->stmts, ii) : NULL;
            ii++;
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
    /* Wide accumulator-tier leaf: a 5-8B double or a long long. Stored via
       IR_ST_MEM's acc path (dload→FA→dstore / __i64 helpers) with the
       element's true kind, base+off honoured by the lowerer. */
    int wide_acc = ((t->kind == KIND_DOUBLE || t->kind == KIND_FLOAT) && w >= 5)
                || (t->kind == KIND_LONGLONG);
    if (w != 1 && w != 2 && w != 4 && !wide_acc) return -2;
    if (--(*budget) < 0) return -2;
    int val_v;
    if (init) {
        if (init->ast_type == AST_INIT_LIST) return -2; /* over-braced */
        val_v = build_expr(b, init);
        if (val_v < 0) return -1;
        int vw = b->f->vregs[val_v].width;
        if (wide_acc) {
            /* The init must already be the leaf's wide type — int→double /
               narrowing conversions aren't modelled here; bail (whole
               function) rather than miscompile. */
            if (vw != w) return -2;
        } else if (vw != w) {
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
    } else if (wide_acc) {
        /* Zero-fill an uninitialised wide leaf word/byte-wise — no acc
           zero literal needed (partial init: `double a[4]={1.0}`). */
        for (int z = 0; z < w; ) {
            int cw = (w - z >= 2) ? 2 : 1;
            if (--(*budget) < 0) return -2;
            int zv = new_temp(b, cw); b->f->vregs[zv].width = (int16_t)cw;
            ir_emit_ld_imm(cur_bb(b), zv, 0);
            Op *zst = ir_op_emit(cur_bb(b), IR_ST_MEM);
            zst->src[0] = zv; zst->mem.kind = IR_MEM_VREG; zst->mem.base = base;
            zst->mem.offset = off + z;
            zst->mem.elem = (cw == 1) ? KIND_CHAR : KIND_INT;
            z += cw;
        }
        return 0;
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
    st->mem.elem = wide_acc ? t->kind
                 : (w == 1) ? KIND_CHAR : (w == 2) ? KIND_INT : KIND_LONG;
    return 0;
}

/* True if an initialiser zero-fills its whole object — NULL (default init),
   an all-zero brace list, or a literal 0. Lets a `= {0}` / `= {}` aggregate
   be lowered as one block-zero instead of per-element stores. */
static int init_is_all_zero(const Node *init)
{
    if (!init) return 1;
    if (init->ast_type == AST_INIT_LIST) {
        int n = init->stmts ? (int)array_len(init->stmts) : 0;
        for (int i = 0; i < n; i++)
            if (!init_is_all_zero(array_get_byindex(init->stmts, i))) return 0;
        return 1;
    }
    if (init->ast_type == AST_LITERAL) return init->zval == 0;
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
    int dst = new_temp_kind(b, fk);
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

/* True when `n` is a numeric literal equal to 1 (int `1` or float `1.0`) —
   the dividend that turns `1.0 / x` into a reciprocal. */
static int node_is_numeric_one(Node *n)
{
    return n && n->ast_type == AST_LITERAL && (double)n->zval == 1.0;
}

/* Reciprocal-eligible float kinds, mirroring sccz80 zdiv_dconst: the half
   float and IEEE single ship an inverse helper; the acc-tier 48/64-bit
   doubles and MBF32 do not, so `1.0/x` stays a full divide there. */
static int float_reciprocal_ok(Kind fk)
{
    if (fk == KIND_FLOAT16) return 1;
    if (fk == KIND_DOUBLE && c_fp_size == 4 && c_maths_mode == MATHS_IEEE)
        return 1;
    return 0;
}

/* Emit a register-float reciprocal HCALL (l_f{16,32}_invf) computing 1/rv.
   Unary ABI: operand in HL/DEHL, result in HL/DEHL. Returns the result
   vreg or -1 if fk has no inverse helper. */
static int emit_float_reciprocal(Builder *b, Kind fk, int rv)
{
    const char *name = float_helper(fk, "invf");
    if (!name) return -1;
    int dst = new_temp_kind(b, fk);
    int *args = calloc(1, sizeof(int)); args[0] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
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
    int dst = new_temp_kind(b, KIND_DOUBLE);
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_BINOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_push = acc_name("push"); hi->acc_loadpush = acc_name("loadpush");
    hi->acc_width = w; hi->acc_holds_lhs = 0; hi->acc_store_bc = 0;
    hi->acc_commutative = acc_stem_commutative(stem);
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
    int dst = new_temp_kind(b, KIND_DOUBLE);
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
   back. A sign-bit XOR would be format-specific (MBF's sign isn't the
   value's top bit), so the helper is the safe path. */
static int emit_acc_float_neg(Builder *b, int src_v)
{
    int w = c_fp_size;
    int dst = new_temp_kind(b, KIND_DOUBLE);
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
    int dst = new_temp_kind(b, KIND_LONGLONG);
    int *args = calloc(2, sizeof(int));
    args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_BINOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_push = "l_i64_push"; hi->acc_loadpush = NULL;
    hi->acc_width = 8; hi->acc_holds_lhs = 0; hi->acc_store_bc = 1;
    hi->acc_commutative = acc_stem_commutative(stem);
    op->hcall = hi;
    return dst;
}

/* i64 shift (stem "shl"/"shr"): `val` is the i64 value (pushed), the count's
   low byte goes in A — the count-in-A helper entries shift by A, so the count
   is never widened to an i64. A LITERAL count (has_imm) is emitted as `ld a,N`
   (args[1]=-1, op->imm=N); a variable count is the int vreg `count` (loaded to
   A after the value push, so it must be slot-backed — the allocator slots it
   as it's live across the push). Returns the result. */
static int emit_acc_int_shift(Builder *b, const char *stem, int val,
                              int count, int64_t imm, int has_imm,
                              int is_unsigned)
{
    const char *name = acc_int_name(stem, is_unsigned);
    if (!name) return -1;
    int dst = new_temp_kind(b, KIND_LONGLONG);
    int *args = calloc(2, sizeof(int));
    args[0] = val; args[1] = has_imm ? -1 : count;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_BINOP);
    op->dst = dst;
    if (has_imm) op->imm = imm & 0xff;     /* shift count, 0..63 */
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_push = "l_i64_push"; hi->acc_loadpush = NULL;
    hi->acc_width = 8; hi->acc_holds_lhs = 0; hi->acc_store_bc = 1;
    hi->acc_count_in_a = 1;
    op->hcall = hi;
    return dst;
}

/* Wide-accumulator i64 compare (IR_ACC_CMP): l_i64_{lt,le,gt,ge,eq,ne}
   (+ unsigned ult/… variants) → int 0/1 bool in HL. Same push/load dance
   as the binop; no accumulator store. Returns the width-2 int dst or -1. */
/* `l_pool`/`r_pool` >= 0 mark that operand as a literal-pool constant (i_<litlab>)
   rather than a vreg — the lowerer loads it directly into the accumulator, so it
   needs no materialised slot, and the other (computed) operand stays adjacent to
   its producer (its store then drops out). -1 = ordinary vreg lv/rv. */
static int emit_acc_int_cmp(Builder *b, const char *cstem, int lv, int l_pool,
                            int rv, int r_pool, int is_unsigned)
{
    const char *name = acc_int_name(cstem, is_unsigned);
    if (!name) return -1;
    int dst = new_temp_kind(b, KIND_INT);
    int *args = calloc(2, sizeof(int));
    args[0] = (l_pool >= 0) ? -1 : lv;
    args[1] = (r_pool >= 0) ? -1 : rv;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_CMP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 2; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_push = "l_i64_push";
    hi->acc_loadpush = NULL;
    hi->acc_width = 8; hi->acc_holds_lhs = 0;
    hi->acc_commutative = acc_stem_commutative(cstem);
    if (l_pool >= 0) { hi->acc_src_is_pool[0] = 1; hi->acc_src_litlab[0] = l_pool; }
    if (r_pool >= 0) { hi->acc_src_is_pool[1] = 1; hi->acc_src_litlab[1] = r_pool; }
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
    int dst = new_temp_kind(b, KIND_LONGLONG);
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

/* In-place unary op on a width-8 long long (IR_ACC_UNOP, subkind 4): load
   the value into __i64_acc, call the in-place helper (l_i64_neg two's
   complement / l_i64_com bitwise complement), store back. There is no
   width-8 IR_NEG/IR_NOT lowering — gen_neg/gen_not only handle 2/4-byte — so
   long long `-x` / `~x` must take this path, not emit IR_NEG/IR_NOT. */
static int emit_acc_int_unary(Builder *b, int src_v, const char *name)
{
    int dst = new_temp_kind(b, KIND_LONGLONG);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = "l_i64_load"; hi->acc_store = "l_i64_store";
    hi->acc_width = 8; hi->acc_subkind = ACC_SUB_ACC_UNARY; hi->acc_store_bc = 1;
    op->hcall = hi;
    return dst;
}

/* Widen a narrow integer call ARG (vreg v, source AST node a) to its
   prototyped PARAM type pt. The front-end leaves the int→long /
   int→long-long promotion to codegen, so widen here to fill the param's
   high bytes. Only long / long long params and integer args (char→int
   already promotes via the
   smallc push); an unprototyped (variadic) slot has no Type → left as-is.
   Returns the (possibly new) vreg. Shared by direct + fnptr call paths. */
static int widen_arg_to_param(Builder *b, int v, Node *a, Type *pt)
{
    if (!pt) return v;
    /* Near pointer / narrow value passed to a __far (KIND_CPTR) param:
       build the 4-byte far representation (bank high word = 0) by
       zero-extension, matching an explicit (T *__far) cast — else the
       callee reads a garbage bank byte. An already-far source keeps
       its KIND_CPTR. */
    if (pt->kind == KIND_CPTR) {
        if (b->f->vregs[v].width >= 4 || (Kind)b->f->vregs[v].kind == KIND_CPTR) {
            b->f->vregs[v].kind = KIND_CPTR;
            return v;
        }
        int wt = new_temp_kind(b, KIND_CPTR);
        Op *cv = ir_op_emit(cur_bb(b), IR_CONV_ZX);
        cv->dst = wt; cv->src[0] = v;
        return wt;
    }
    /* Float param: convert the arg to the param's float kind — the
       int→float / cross-float conversion the front end leaves to codegen.
       Else an int arg (e.g. `f(6400)` to a `double` param) is pushed at its
       int width and the callee reads a garbage wide value. coerce no-ops when
       the arg is already that kind. */
    if (kind_is_floating(pt->kind))
        return coerce_int_to_float_kind(b, v, a, pt->kind);
    /* _Accum / fixed param: a numeric LITERAL arg (e.g. EPSILON=0.1) scales to
       Q-format at compile time — matching sccz80, which never calls the
       runtime double→_Accum helper. Without this the double literal is pushed
       at its wide size and the callee's narrow _Accum param misaligns (the
       built `v` double is discarded). A non-literal _Accum arg is left as-is. */
    if (kind_is_fixed(pt->kind)) {
        if (a->ast_type == AST_LITERAL) {
            int av = new_temp_kind(b, pt->kind);
            b->f->vregs[av].width = (pt->kind == KIND_ACCUM32) ? 4 : 2;
            ir_emit_ld_imm(cur_bb(b), av, scale_literal_for_kind(a, pt->kind));
            return av;
        }
        return v;
    }
    if (!kind_is_integer(pt->kind)) return v;
    Kind ak  = a->type ? (Kind)a->type->kind : KIND_NONE;
    if (!kind_is_integer(ak)) return v;
    int  uns = a->type && a->type->isunsigned;
    int  aw  = b->f->vregs[v].width;
    if (pt->kind == KIND_LONGLONG && ak != KIND_LONGLONG) {
        if (aw == 1) {
            int wt = new_temp_kind(b, KIND_INT);
            Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = wt; cv->src[0] = v; v = wt;
        }
        v = emit_acc_int_from_int(b, v, uns);
    } else if (type_width(pt) == 4 && aw < 4) {
        int wt = new_temp_kind(b, KIND_LONG);
        Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
        cv->dst = wt; cv->src[0] = v; v = wt;
    } else if (type_width(pt) == 2 && aw == 4) {
        /* WIDE arg to a narrow int/short param: truncate to 2 bytes. Else
           a __smallc/__z88dk_callee callee pops a fixed frame that doesn't
           match the over-wide push (qsort `nel = 550L` pushed the long as
           4 bytes vs the 2-byte `unsigned int` param → 2 stray bytes left
           on the stack → corrupted return → crash). */
        int wt = new_temp_kind(b, KIND_INT);
        Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
        cv->dst = wt; cv->src[0] = v; v = wt;
    }
    return v;
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
        int wt = new_temp_kind(b, KIND_INT);
        Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
        cv->dst = wt; cv->src[0] = v; v = wt;
    }
    return emit_acc_int_from_int(b, v, uns);
}

/* Emit `v << sh` (logical left) at width w; sh==0 returns v unchanged. */
static int sr_shift_left(Builder *b, int v, int sh, int w)
{
    if (sh == 0) return v;
    int t = new_temp_kind(b, (w == 4) ? KIND_LONG : KIND_INT);
    Op *s = ir_op_emit(cur_bb(b), IR_SHL);
    s->dst = t; s->src[0] = v; s->src[1] = -1; s->imm = sh;
    return t;
}

/* Constant-multiply strength reduction: rewrite x*C into shifts + one
   add/sub when C decomposes into <=2 power-of-two terms — cheaper than the
   l_mult / l_long_mult helper on targets without a hardware multiply. v is
   the non-constant operand, already at the result width w (2 or 4). A
   product's low w bytes are sign-agnostic, so SHL/ADD/SUB serve signed and
   unsigned alike. Covers C = 2^a (defensive), 2^a+2^b, and runs of 1-bits
   (2^a-2^b: 3,5,6,7,9,10,12,14,15,...). Returns the result vreg or -1 (use
   the helper). pow2 is normally already reduced at the AST level. */
static int emit_const_mult_sr(Builder *b, int v, int64_t C, int w)
{
    if (w != 2 && w != 4) return -1;
    if (C < 3) return -1;                       /* 0/1/2: fold / pow2 path */
    uint64_t u = (uint64_t)C;
    int maxsh = (w == 4) ? 31 : 15;
    Kind kw = (w == 4) ? KIND_LONG : KIND_INT;

    int lo_bit = 0; while (!((u >> lo_bit) & 1u)) lo_bit++;
    int hi_bit = 0, pop = 0;
    for (int i = 0; i < 64; i++) if ((u >> i) & 1u) { hi_bit = i; pop++; }
    if (hi_bit > maxsh) return -1;              /* top term shifts out of range */

    if (pop == 1)                               /* pure power of two */
        return sr_shift_left(b, v, lo_bit, w);

    if (pop == 2) {                             /* (v<<hi) + (v<<lo) */
        int hi = sr_shift_left(b, v, hi_bit, w);
        int lo = sr_shift_left(b, v, lo_bit, w);
        int dst = new_temp_kind(b, kw);
        ir_emit_binop(cur_bb(b), IR_ADD, dst, hi, lo);
        return dst;
    }

    /* Run of consecutive 1-bits: C = 2^a - 2^lo → (v<<a) - (v<<lo). */
    uint64_t lb = u & (~u + 1u);                /* lowest set bit */
    uint64_t up = u + lb;
    if ((up & (up - 1)) == 0) {                 /* u+lb a power of two ⇒ run */
        int a = 0;
        for (int i = 0; i < 64; i++) if ((up >> i) & 1u) a = i;
        if (a > maxsh) return -1;
        int hi = sr_shift_left(b, v, a, w);
        int lo = sr_shift_left(b, v, lo_bit, w);
        int dst = new_temp_kind(b, kw);
        ir_emit_binop(cur_bb(b), IR_SUB, dst, hi, lo);
        return dst;
    }

    /* General constant (>=3 non-run terms, e.g. an LCG's *181 or a hash's *31):
       the Horner binary shift-add chain — acc = v (the top set bit), then for
       each lower bit MSB->LSB: acc <<= 1 (double), and acc += v when the bit is
       set. Cost = hi_bit doublings (each `add hl,hl`) + (pop-1) adds — the same
       decomposition sdcc emits. Replaces the l_mult CALL with straight-line
       code. Cost-gated by `hi_bit + pop` (the op count): l_mult is a slow
       bit-serial 16x16, so for a WORD (each chain op is a single add hl,hl /
       add hl,de) the inline chain wins across the whole range — inline any int
       constant (max hi_bit+pop is 31). A LONG chain doubles/adds 32 bits per
       step (several ops each) and competes with l_long_mult, so keep the
       tighter bound there. (An LCG's *25173 = 14+7 = 21 was just over the old
       flat 20 and fell to l_mult → histbench -41%.) */
    if (hi_bit + pop <= (w == 2 ? 32 : 20)) {
        int acc = v;                            /* coefficient for 2^hi_bit */
        for (int bit = hi_bit - 1; bit >= 0; bit--) {
            acc = sr_shift_left(b, acc, 1, w);  /* double */
            if ((u >> bit) & 1u) {
                int dst = new_temp_kind(b, kw);
                ir_emit_binop(cur_bb(b), IR_ADD, dst, acc, v);
                acc = dst;
            }
        }
        return acc;
    }
    return -1;
}

/* Load a wide (long long / 5-8B double) constant from the const.c literal
   pool: emit `ld hl,i_<litlab>` + the wide-load helper (IR_MEM_POOL,
   dispatched on the dst KIND by the lowerer). Returns the wide dst vreg. */
static int emit_pool_load(Builder *b, int litlab, int width, Kind kind)
{
    int dst = new_temp_kind(b, kind);
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
    Kind dst_k = to_double ? KIND_DOUBLE : KIND_LONGLONG;
    int dst = new_temp_kind(b, dst_k);
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

/* _Float16 → acc-tier double (l_f48_f16tof / l_f64_f16tof): f16 in HL, result
   double in FA, stored to the dst slot — same IR_ACC_UNOP shape as int2f. */
static int emit_acc_from_f16(Builder *b, int src_v)
{
    const char *name = (c_fp_size == 8) ? "l_f64_f16tof" : "l_f48_f16tof";
    int w = c_fp_size;
    int dst = new_temp_kind(b, KIND_DOUBLE);
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

/* acc-tier double → _Float16 (l_f48_ftof16 / l_f64_ftof16): double in FA,
   result f16 in HL, stored to the 2-byte dst — mirror of f2sint. */
static int emit_f16_from_acc(Builder *b, int src_v)
{
    const char *name = (c_fp_size == 8) ? "l_f64_ftof16" : "l_f48_ftof16";
    int dst = new_temp_kind(b, KIND_FLOAT16);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_width = c_fp_size; hi->acc_subkind = ACC_SUB_ACC2INT;
    op->hcall = hi;
    return dst;
}

/* _Accum (fixed) → acc-tier double (l_f48_fix16tof / l_f48_fix32tof): the
   fixed value in HL (Q8.8) / DEHL (Q16.16) → double in FA → dst slot. */
static int emit_acc_from_accum(Builder *b, int src_v, Kind src_k)
{
    const char *name = (src_k == KIND_ACCUM32)
        ? (c_fp_size == 8 ? "l_f64_fix32tof" : "l_f48_fix32tof")
        : (c_fp_size == 8 ? "l_f64_fix16tof" : "l_f48_fix16tof");
    int w = c_fp_size;
    int dst = new_temp_kind(b, KIND_DOUBLE);
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

/* acc-tier double → _Accum (l_f48_ftofix16{s,u} / l_f48_ftofix32{s,u}): double
   in FA → fixed in HL/DEHL → dst slot. */
static int emit_accum_from_acc(Builder *b, int src_v, Kind dst_k, int uns)
{
    const char *name = (dst_k == KIND_ACCUM32)
        ? (c_fp_size == 8 ? (uns ? "l_f64_ftofix32u" : "l_f64_ftofix32s")
                          : (uns ? "l_f48_ftofix32u" : "l_f48_ftofix32s"))
        : (c_fp_size == 8 ? (uns ? "l_f64_ftofix16u" : "l_f64_ftofix16s")
                          : (uns ? "l_f48_ftofix16u" : "l_f48_ftofix16s"));
    int dst = new_temp_kind(b, dst_k);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_ACC_UNOP);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    hi->acc_load = acc_name("load"); hi->acc_store = acc_name("store");
    hi->acc_width = c_fp_size; hi->acc_subkind = ACC_SUB_ACC2INT;
    op->hcall = hi;
    return dst;
}

/* Runtime integer → _Accum (l_fix16_{s,u}int2f / l_fix32_{s,u}int2f): scales
   the integer by the Q factor (×256 for Q8.8, ×65536 for Q16.16). Source in
   HL (fix16) — width-4 pre-truncated; fix32 HL→DEHL. 1-arg HCALL. */
static int emit_accum_from_int(Builder *b, int src_v, Kind fk, int uns)
{
    if (fk == KIND_ACCUM16 && b->f->vregs[src_v].width == 4) {
        int t = new_temp(b, 2); b->f->vregs[t].width = 2;
        Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
        tr->dst = t; tr->src[0] = src_v; src_v = t;
    }
    const char *name = (fk == KIND_ACCUM32)
        ? (uns ? "l_fix32_uint2f" : "l_fix32_sint2f")
        : (uns ? "l_fix16_uint2f" : "l_fix16_sint2f");
    int dst = new_temp_kind(b, fk);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* Build `node` as the _Accum kind `fk`, promoting a mixed operand: an int
   LITERAL is scaled to Q-format at compile time (3 → 3<<8); an int variable
   via emit_accum_from_int; a double via emit_accum_from_acc; same-kind as-is.
   Returns -1 if not promotable. */
static int build_operand_as_accum(Builder *b, Node *node, Kind fk)
{
    Kind k = node_value_kind(node);
    /* Any numeric literal (int OR fp, e.g. `a * 2.5`) scales to Q-format at
       compile time — no runtime conversion, and `_Accum * fp-literal` stays
       _Accum (sccz80 semantics). */
    if (node && node->ast_type == AST_LITERAL
        && (kind_is_integer(k) || kind_is_floating(k))) {
        int v = new_temp_kind(b, fk);
        ir_emit_ld_imm(cur_bb(b), v, scale_literal_for_kind(node, fk));
        return v;
    }
    int v = build_expr(b, node);
    if (v < 0) return -1;
    if (k == fk) return v;
    int uns = node && node->type && node->type->isunsigned;
    if (kind_is_integer(k)) return emit_accum_from_int(b, v, fk, uns);
    if (is_acc_float_kind(k)) return emit_accum_from_acc(b, v, fk, uns);
    return -1;
}


/* Build `node` and promote it to the acc-tier double when it is an integer
   operand — the mixed `int OP double` usual arithmetic conversion.
   Covers every integer width: char/short widen to int first, int/short→int2f,
   long→long2f, long long→sllong2f (cross-acc). Returns -1 if the operand is
   neither an acc-double nor a promotable int (a register-tier float16 / _Accum
   is handled by its own path). node_value_kind unwraps a fnptr/func-call's
   KIND_FUNC so a double-returning call is recognised as already-double. */
/* Convert an already-built INTEGER vreg `v` to the acc-tier double. Width
   dispatch: char/short widen to int, int/short→int2f, long→long2f, long
   long→sllong2f (cross-acc). Returns -1 on an unhandled width. */
static int conv_int_vreg_to_acc(Builder *b, int v, int uns)
{
    int w = b->f->vregs[v].width;
    if (w == 8)                                         /* long long → double */
        return emit_acc_lldouble(b, v, 1, uns);
    if (w == 1) {                                       /* char → widen to int */
        int t = new_temp_kind(b, KIND_INT);
        Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
        cv->dst = t; cv->src[0] = v;
        v = t; w = 2;
    }
    if (w == 2 || w == 4)
        return emit_acc_from_int(b, v, uns);
    return -1;
}

/* Build `node` and promote it to the acc-tier double when it is an integer
   operand — the mixed `int OP double` usual arithmetic conversion.
   Returns -1 if the operand is neither an acc-double nor a promotable int (a
   register-tier float16 / _Accum is handled by its own path). node_value_kind
   unwraps a fnptr/func-call's KIND_FUNC so a double-returning call is
   recognised as already-double. */
static int build_operand_as_acc(Builder *b, Node *node)
{
    int v = build_expr(b, node);
    if (v < 0) return -1;
    Kind k = node_value_kind(node);
    if (is_acc_float_kind(k)) return v;                 /* already double */
    if (k == KIND_FLOAT16) return emit_acc_from_f16(b, v);  /* f16 → double */
    if (k == KIND_ACCUM16 || k == KIND_ACCUM32)            /* _Accum → double */
        return emit_acc_from_accum(b, v, k);
    if (!kind_is_integer(k)) return -1;
    return conv_int_vreg_to_acc(b, v, node->type && node->type->isunsigned);
}


/* int → register-tier float (f16 / IEEE-32) conversion: l_f{16,32}_{s,u}{int,
   long}2f. char/short widen to int first; the int source goes in HL (2-byte)
   or DEHL (4-byte), the float result comes back in HL/DEHL. 1-arg HCALL.
   Returns dst, or -1 if no helper for the kind (e.g. width-8 ll, not built). */
static int emit_float_reg_from_int(Builder *b, int src_v, Kind fk, int uns)
{
    if (b->f->vregs[src_v].width == 1) {
        int wtmp = new_temp_kind(b, KIND_INT);
        Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
        cv->dst = wtmp; cv->src[0] = src_v;
        src_v = wtmp;
    }
    int sw = b->f->vregs[src_v].width;
    if (sw != 2 && sw != 4) return -1;       /* width-8 ll → reg float: not built */
    const char *helper = float_helper(fk, (sw == 4)
        ? (uns ? "ulong2f" : "slong2f")
        : (uns ? "uint2f"  : "sint2f"));
    if (!helper) return -1;
    int dst = new_temp_kind(b, fk);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = helper; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* Convert between the two register-tier floats: _Float16 (HL) and IEEE-32
   (DEHL). l_f32_f16tof widens f16→f32, l_f32_ftof16 narrows f32→f16 — 1-arg
   HCALLs, arg/result marshalled by their vreg widths. -1 if not a reg pair. */
static int emit_reg_float_convert(Builder *b, int src_v, Kind from_k, Kind to_k)
{
    const char *helper;
    if (from_k == KIND_FLOAT16 && to_k == KIND_DOUBLE)
        helper = float_helper(KIND_DOUBLE, "f16tof");
    else if (from_k == KIND_DOUBLE && to_k == KIND_FLOAT16)
        helper = float_helper(KIND_DOUBLE, "ftof16");
    else
        return -1;
    if (!helper) return -1;
    int dst = new_temp_kind(b, to_k);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = helper; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* register-float (f16 / IEEE-32) → _Accum16, via the DIRECT helper
   l_f{16,32}_ftofix16{s,u} (value in HL/DEHL, fix16 in HL) — not the f16→int
   `f2sint` (which drops the fraction) nor the 48-bit-FA detour. 1-arg HCALL.
   _Accum32 has no f16/f32-source helper in libsrc, so return -1 there. */
static int emit_fix_from_float(Builder *b, int src_v, Kind src_fk, int uns)
{
    const char *name =
        (src_fk == KIND_FLOAT16) ? (uns ? "l_f16_ftofix16u" : "l_f16_ftofix16s")
      : (src_fk == KIND_DOUBLE && c_fp_size == 4)
                                 ? (uns ? "l_f32_ftofix16u" : "l_f32_ftofix16s")
      : NULL;
    if (!name) return -1;
    int dst = new_temp_kind(b, KIND_ACCUM16);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* _Accum16 → register-float (f16 / IEEE-32), via l_f{16,32}_fix16tof. 1-arg
   HCALL; result width from the dst float kind. -1 for unsupported tiers. */
static int emit_float_from_fix(Builder *b, int src_v, Kind dst_fk)
{
    const char *name =
        (dst_fk == KIND_FLOAT16) ? "l_f16_fix16tof"
      : (dst_fk == KIND_DOUBLE && c_fp_size == 4) ? "l_f32_fix16tof"
      : NULL;
    if (!name) return -1;
    int dst = new_temp_kind(b, dst_fk);
    int *args = calloc(1, sizeof(int)); args[0] = src_v;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = name; hi->args = args; hi->n_args = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* The common register-float kind of two register-float operands: C's usual
   arithmetic conversions promote to the wider (IEEE-32 over _Float16). */
static Kind reg_float_common(Kind a, Kind b)
{
    return (width_for_kind(a) >= width_for_kind(b)) ? a : b;
}

/* Build `node`, promoting a mixed operand to the register-tier float kind `fk`
   (the f16/f32 analog of build_operand_as_acc). Already-`fk` returns as-is; an
   integer source converts via int→float; the other register float converts
   f16↔f32. A width-8 int / acc-double source isn't handled here (-1). */
static int build_operand_as_float_reg(Builder *b, Node *node, Kind fk)
{
    int v = build_expr(b, node);
    if (v < 0) return -1;
    Kind k = node_value_kind(node);
    if (k == fk) return v;
    if (is_register_float_kind(k))
        return emit_reg_float_convert(b, v, k, fk);
    if (!kind_is_integer(k)) return -1;
    int uns = node->type && node->type->isunsigned;
    return emit_float_reg_from_int(b, v, fk, uns);
}

/* Materialise a compile-time float constant (`value`) directly in float kind
   fk: the FA/IEEE bit pattern as an immediate (f16 / register f32) or a
   const-pool dload (acc-tier double). Mirrors the AST_LITERAL float path so a
   CONSTANT int→float conversion folds here instead of a runtime l_f32_sint2f.
   Returns the vreg, or -1 if fk isn't a register/acc float kind. */
static int emit_float_const(Builder *b, double value, Kind fk)
{
    if (fk == KIND_FLOAT16) {
        unsigned char fa[8];
        dofloat(MATHS_IEEE16, value, fa);
        int fv = new_temp_kind(b, KIND_FLOAT16);
        ir_emit_ld_imm(cur_bb(b), fv, (int64_t)(((int)fa[1] << 8) | fa[0]));
        return fv;
    }
    if (fk == KIND_DOUBLE) {
        if (is_register_float_kind(KIND_DOUBLE)) {   /* IEEE-32 / MBF-single */
            unsigned char fa[8];
            dofloat(c_maths_mode, value, fa);
            uint32_t bits = ((uint32_t)fa[3] << 24) | ((uint32_t)fa[2] << 16)
                          | ((uint32_t)fa[1] << 8)  | (uint32_t)fa[0];
            int fv = new_temp_kind(b, KIND_DOUBLE);
            ir_emit_ld_imm(cur_bb(b), fv, (int64_t)bits);
            return fv;
        }
        return emit_pool_load(b, ir_pool_litlab_double((zdouble)value),
                              c_fp_size, KIND_DOUBLE);   /* 5/6/8-byte double */
    }
    return -1;
}

/* Coerce an already-built value `v` (from `src`) into the float kind `dst_k`
   for an assignment / initialiser / return. Integer source → the right
   int→float conversion (acc or register tier). Same float kind or a
   non-integer source (incl. cross-tier float→float, handled elsewhere) is
   returned unchanged. Centralises the conversion the front end no longer
   inserts. */
static int coerce_int_to_float_kind(Builder *b, int v, Node *src, Kind dst_k)
{
    if (v < 0) return v;
    Kind sk = node_value_kind(src);
    if (sk == dst_k) return v;
    int uns = src && src->type && src->type->isunsigned;
    /* Constant int → register/acc float: fold the conversion at compile time
       (store the float bit pattern) rather than emit a runtime l_f32_sint2f /
       int→acc call. `Au[i] = 0` becomes a direct 0.0 store, matching sdcc. */
    if (src && src->ast_type == AST_LITERAL && kind_is_integer(sk)
        && (is_register_float_kind(dst_k) || is_acc_float_kind(dst_k))) {
        int c = emit_float_const(b, (double)src->zval, dst_k);
        if (c >= 0) return c;
    }
    if (is_acc_float_kind(dst_k)) {                     /* → 5/6/8-byte double */
        if (sk == KIND_FLOAT16) return emit_acc_from_f16(b, v);
        if (sk == KIND_ACCUM16 || sk == KIND_ACCUM32) return emit_acc_from_accum(b, v, sk);
        if (kind_is_integer(sk)) { int c = conv_int_vreg_to_acc(b, v, uns); return c < 0 ? v : c; }
        return v;
    }
    if (is_register_float_kind(dst_k)) {               /* → f16 / IEEE-32 */
        if (dst_k == KIND_FLOAT16 && is_acc_float_kind(sk))
            return emit_f16_from_acc(b, v);             /* acc double → f16 */
        if (sk == KIND_ACCUM16) {                       /* _Accum16 → f16/f32 */
            int c = emit_float_from_fix(b, v, dst_k); return c < 0 ? v : c;
        }
        if (is_register_float_kind(sk)) {               /* f16 ↔ f32 */
            int c = emit_reg_float_convert(b, v, sk, dst_k); return c < 0 ? v : c;
        }
        if (kind_is_integer(sk)) { int c = emit_float_reg_from_int(b, v, dst_k, uns); return c < 0 ? v : c; }
        return v;
    }
    if (dst_k == KIND_ACCUM16 || dst_k == KIND_ACCUM32) {   /* → _Accum (fixed) */
        if (kind_is_integer(sk)) return emit_accum_from_int(b, v, dst_k, uns);
        if (dst_k == KIND_ACCUM16 && is_register_float_kind(sk)) {
            int c = emit_fix_from_float(b, v, sk, uns); return c < 0 ? v : c;
        }
        if (is_acc_float_kind(sk)) return emit_accum_from_acc(b, v, dst_k, uns);
        return v;
    }
    return v;
}

/* Coerce a float/double RHS to an INTEGER destination — the implicit
   conversion the front end leaves to codegen (`int i = dbl;`, `return dbl;`
   from an int function, `arr[k] = dbl;`). Mirrors OP_CAST's acc-float→int:
   ifix/f2s{int,long} to int/long, then narrow to a byte dst. Without it the
   6-byte double flows into the integer width-coercion below and gets a plain
   CONV_TRUNC (a bail at 6→1, garbage otherwise). Source must be the 5/6/8-byte
   acc double (the default `double`); f16 / f32-tier and long long dsts are
   handled by their own cast paths. Returns v unchanged when it doesn't apply. */
static int coerce_float_to_int_kind(Builder *b, int v, Node *src,
                                    Kind dst_k, int dst_w)
{
    if (v < 0) return v;
    Kind sk = node_value_kind(src);
    if (!is_acc_float_kind(sk)) return v;
    if (!kind_is_integer(dst_k) || is_acc_int_kind(dst_k)) return v;
    int iv = emit_acc_to_int(b, v, (dst_w == 4) ? 4 : 2);
    if (dst_w == 1) {
        int bt = new_temp_kind(b, KIND_CHAR);
        Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
        tr->dst = bt; tr->src[0] = iv;
        return bt;
    }
    return iv;
}

/* A "1.0" constant in the decimal kind `fk` — for ++/-- on a float/_Accum.
   _Accum scales 1 to Q-format at compile time; double/f16/f32 convert int 1. */
static int emit_decimal_one(Builder *b, Kind fk)
{
    if (fk == KIND_ACCUM16 || fk == KIND_ACCUM32) {
        int v = new_temp_kind(b, fk);
        ir_emit_ld_imm(cur_bb(b), v, (fk == KIND_ACCUM32) ? (1LL << 16) : (1LL << 8));
        return v;
    }
    int one = new_temp_kind(b, KIND_INT);
    ir_emit_ld_imm(cur_bb(b), one, 1);
    if (is_acc_float_kind(fk)) return conv_int_vreg_to_acc(b, one, 0);
    if (is_register_float_kind(fk)) return emit_float_reg_from_int(b, one, fk, 0);
    return -1;
}

/* value `v` (decimal kind `fk`) +/- 1.0 — the step for float/_Accum ++/--. */
static int emit_decimal_step(Builder *b, int v, Kind fk, int is_inc)
{
    int one = emit_decimal_one(b, fk);
    if (one < 0) return -1;
    const char *stem = is_inc ? "add" : "sub";
    if (is_acc_float_kind(fk)) return emit_acc_binop(b, stem, v, one);
    if (is_register_float_kind(fk)) return emit_float_arith(b, fk, stem, v, one);
    if (fk == KIND_ACCUM16 || fk == KIND_ACCUM32) {
        int dst = new_temp_kind(b, fk);
        Op *o = ir_op_emit(cur_bb(b), is_inc ? IR_ADD : IR_SUB);
        o->dst = dst; o->src[0] = v; o->src[1] = one;
        return dst;
    }
    return -1;
}

/* Float compound-assign `lhs op= rhs` (stem "add"/"sub"/"mul"/"div").
   n->left is OP_DEREF(lvalue); the lvalue may be a local, global, or
   *ptr. Loads the lvalue, computes via the float helper, stores back.
   Both operands must be the same IR-supported float kind (the front end
   converts the rhs); otherwise build_fail. */
static int build_float_compound(Builder *b, Node *n, const char *stem)
{
    if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
        return build_fail("float compound-assign LHS shape not supported");
    Kind fk = n->left->type ? n->left->type->kind : KIND_NONE;
    int is_acc = is_acc_float_kind(fk);
    if (!is_register_float_kind(fk) && !is_acc)
        return build_fail("float compound-assign: unsupported kind %d", (int)fk);
    if (!n->right || !n->right->type)
        return build_fail("float compound-assign: null rhs");
    Node *lvn = n->left->operand;
    int fw = width_for_kind(fk);
    Kind elem = is_acc ? KIND_DOUBLE : (fw == 2) ? KIND_INT : KIND_LONG;
    /* For a commutative register-float op (`acc += x`, `acc *= x`) put the
       rhs — built first, typically a call/mul result — in the STACKED slot
       so the lowerer can push it to the data stack inline (Lever A), and
       the freshly-loaded accumulator in the DEHL/reg slot. Matches sccz80's
       staging; without it the rhs is spilled to a frame slot and reloaded.
       Acc tier (FA model) keeps lhs-first — it doesn't use the DEHL stack. */
    int fc_commutative = !is_acc
        && (!strcmp(stem, "add") || !strcmp(stem, "mul"))
        && getenv("IR_NO_F32_STACK_ARG") == NULL;
    #define COMPOUND_ARITH(LV) (is_acc \
        ? emit_acc_binop(b, stem, (LV), rv) \
        : fc_commutative ? emit_float_arith(b, fk, stem, rv, (LV)) \
                         : emit_float_arith(b, fk, stem, (LV), rv))

    int rv = build_expr(b, n->right);
    if (rv < 0) return -1;
    /* Convert a mixed rhs (int, or the other float tier) to the lvalue's
       float kind — the conversion the front end no longer inserts. */
    rv = coerce_int_to_float_kind(b, rv, n->right, fk);

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
        int loaded = new_temp_kind(b, fk);
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
    int loaded = new_temp_kind(b, fk);
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

/* Compute `lv op rv` for a fixed-point (_Accum) compound assign. add/sub are
   plain integer ops on the Q-format representation (Q is additive); mul/div go
   through l_fix{16,32}_{mul,div}{s,u} (multiply-then-shift). Returns the result
   vreg (kind ak). */
static int emit_accum_compound_op(Builder *b, int lv, int rv, int ast_type,
                                  Kind ak, int uns)
{
    if (ast_type == OP_AADD || ast_type == OP_ASUB) {
        int dst = new_temp_kind(b, ak);
        Op *o = ir_op_emit(cur_bb(b), ast_type == OP_AADD ? IR_ADD : IR_SUB);
        o->dst = dst; o->src[0] = lv; o->src[1] = rv;
        return dst;
    }
    const char *helper = (ak == KIND_ACCUM32)
        ? (ast_type == OP_AMULT ? (uns ? "l_fix32_mulu" : "l_fix32_muls")
                                : (uns ? "l_fix32_divu" : "l_fix32_divs"))
        : (ast_type == OP_AMULT ? (uns ? "l_fix16_mulu" : "l_fix16_muls")
                                : (uns ? "l_fix16_divu" : "l_fix16_divs"));
    int dst = new_temp_kind(b, ak);
    int *args = calloc(2, sizeof(int)); args[0] = lv; args[1] = rv;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = helper; hi->args = args; hi->n_args = 2;
    hi->n_stacked = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* _Accum compound-assign `lhs op= rhs` (op = AADD/ASUB/AMULT/ADIV). Mirror of
   build_float_compound: load the fixed lvalue, build the rhs scaled to the same
   _Accum kind, op, store back. The rhs build scales a fixed/int literal to
   Q-format (so `a += 2.5k` adds 640, not a raw 2) and uses the fixed mul/div
   helpers (so `a *= b` is l_fix16_muls, not an integer l_mult). */
static int build_accum_compound(Builder *b, Node *n, Kind ak)
{
    if (!n->left || n->left->ast_type != OP_DEREF || !n->left->operand)
        return build_fail("_Accum compound-assign LHS shape not supported");
    if (!n->right || !n->right->type)
        return build_fail("_Accum compound-assign: null rhs");
    Node *lvn = n->left->operand;
    int uns = (n->left->type && n->left->type->isunsigned);
    int rv = build_operand_as_accum(b, n->right, ak);   /* scales literal rhs */
    if (rv < 0) return -1;
    Kind elem = (ak == KIND_ACCUM32) ? KIND_LONG : KIND_INT;
    #define ACC_ARITH(LV) emit_accum_compound_op(b, (LV), rv, n->ast_type, ak, uns)

    if (lvn->ast_type == AST_LOCAL_VAR) {
        int lhs_v = lvn->sym ? sym_map_get(b, lvn->sym) : -1;
        if (lhs_v < 0)
            return build_fail("_Accum compound-assign: unknown local");
        int res = ACC_ARITH(lhs_v);
        if (res < 0) return -1;
        ir_emit_mov(cur_bb(b), lhs_v, res);
        return lhs_v;
    }
    if (lvn->ast_type == AST_GLOBAL_VAR) {
        SYMBOL *g = lvn->sym;
        if (!g) return build_fail("_Accum compound-assign: null global");
        int loaded = new_temp_kind(b, ak);
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst = loaded; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = g;
        int res = ACC_ARITH(loaded);
        if (res < 0) return -1;
        Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
        st->src[0] = res; st->mem.kind = IR_MEM_SYM; st->mem.sym = g;
        return res;
    }
    /* *ptr op= rhs */
    SYMBOL *bf = (SYMBOL *)deref_bank_fn(n->left);
    int ptr_v = build_expr(b, lvn);
    if (ptr_v < 0) return -1;
    int loaded = new_temp_kind(b, ak);
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = loaded; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = ptr_v; ld->mem.elem = elem;
    ld->mem.bank_fn = bf;
    int res = ACC_ARITH(loaded);
    if (res < 0) return -1;
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0] = res; st->mem.kind = IR_MEM_VREG;
    st->mem.base = ptr_v; st->mem.elem = elem;
    st->mem.bank_fn = bf;
    return res;
    #undef ACC_ARITH
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
    /* A literal shift count becomes an immediate (no count vreg); otherwise
       build it. For a shift the count stays an int (low byte in A, not widened);
       other ops promote the rhs to long long (`x += 3`). */
    Node *cn = n->right;
    int count_is_imm = is_shift && cn && cn->ast_type == AST_LITERAL;
    int64_t count_imm = count_is_imm ? (int64_t)cn->zval : 0;
    int rv = -1;
    if (!count_is_imm) {
        rv = build_expr(b, n->right);
        if (rv < 0) return -1;
        if (!is_shift) {
            rv = promote_to_acc_int(b, rv, n->right->type->isunsigned);
            if (rv < 0) return -1;
        }
    }

    if (lvn->ast_type == AST_LOCAL_VAR) {
        int lhs_v = lvn->sym ? sym_map_get(b, lvn->sym) : -1;
        if (lhs_v < 0) return build_fail("ll compound-assign: unknown local");
        Kind lk = lvn->sym ? (Kind)lvn->sym->type : KIND_NONE;
        if (lk == KIND_ARRAY || lk == KIND_STRUCT) {
            /* Folded offset-0 aggregate element (`la[0] op= x`): lhs_v is the
               slot base, NOT a scalar value — LEA &la[0] then load-modify-
               store (mirrors the *ptr branch). Treating it as a scalar would
               read/overwrite the array base vreg with the result. */
            int addr = new_temp(b, 2);
            Op *lea = ir_op_emit(cur_bb(b), IR_LEA);
            lea->dst = addr; lea->src[0] = lhs_v;
            int loaded = new_temp_kind(b, KIND_LONGLONG);
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst = loaded; ld->mem.kind = IR_MEM_VREG;
            ld->mem.base = addr; ld->mem.elem = KIND_LONGLONG;
            int res = is_shift ? emit_acc_int_shift(b, stem, loaded, rv, count_imm, count_is_imm, is_uns)
                               : emit_acc_int_binop(b, stem, loaded, rv, is_uns);
            if (res < 0) return -1;
            Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
            st->src[0] = res; st->mem.kind = IR_MEM_VREG;
            st->mem.base = addr; st->mem.elem = KIND_LONGLONG;
            return res;
        }
        int res = is_shift ? emit_acc_int_shift(b, stem, lhs_v, rv, count_imm, count_is_imm, is_uns)
                           : emit_acc_int_binop(b, stem, lhs_v, rv, is_uns);
        if (res < 0) return -1;
        ir_emit_mov(cur_bb(b), lhs_v, res);
        return lhs_v;
    }
    if (lvn->ast_type == AST_GLOBAL_VAR) {
        SYMBOL *g = lvn->sym;
        if (!g) return build_fail("ll compound-assign: null global");
        int loaded = new_temp_kind(b, KIND_LONGLONG);
        Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
        ld->dst = loaded; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = g;
        ld->mem.elem = KIND_LONGLONG;
        int res = is_shift ? emit_acc_int_shift(b, stem, loaded, rv, count_imm, count_is_imm, is_uns)
                           : emit_acc_int_binop(b, stem, loaded, rv, is_uns);
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
    int loaded = new_temp_kind(b, KIND_LONGLONG);
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = loaded; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = ptr_v; ld->mem.elem = KIND_LONGLONG;
    ld->mem.bank_fn = bf;
    int res = is_shift ? emit_acc_int_shift(b, stem, loaded, rv, count_imm, count_is_imm, is_uns)
                       : emit_acc_int_binop(b, stem, loaded, rv, is_uns);
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

/* Read-modify-write store of value vreg `v` into the bitfield `bft`
   (carries bit_size/bit_offset) whose storage unit is addressed by the
   lvalue node `lv` (global / local / folded address expr). `unsigned_rhs`
   selects ZX vs SX when `v` is narrower than a word. Clears the field's
   bits in the loaded unit and ORs in `(v & mask) << boff`, then writes the
   unit back at its natural width (byte if the field fits in one byte, else
   word — a wider store would clobber the neighbour / overrun the struct).
   Returns `v` (the assigned value) or -1 on a deferred lvalue shape. Shared
   by plain `bf = x` (OP_ASSIGN) and `bf op= x` (compound). */
static int emit_bitfield_store(Builder *b, Node *lv, Type *bft,
                               int v, int unsigned_rhs)
{
    int bsize = bft->bit_size, boff = bft->bit_offset;
    int64_t mask = ((int64_t)1 << bsize) - 1;
    int64_t fieldmask = mask << boff;
    int unit_w = (boff + bsize <= 8) ? 1 : 2;
    Kind unit_k = (unit_w == 1) ? KIND_CHAR : KIND_INT;
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
    if (b->f->vregs[v].width != 2) {
        int t = new_temp(b, 2); b->f->vregs[t].width = 2;
        OpKind cv = (b->f->vregs[v].width > 2) ? IR_CONV_TRUNC
                  : (unsigned_rhs ? IR_CONV_ZX : IR_CONV_SX);
        Op *c = ir_op_emit(cur_bb(b), cv);
        c->dst = t; c->src[0] = v; v = t;
    }
    /* (v & mask) << boff — unit_w-wide so a byte field emits byte mem ops. */
    int vm = new_temp(b, unit_w); b->f->vregs[vm].width = (int16_t)unit_w;
    Op *a1 = ir_op_emit(cur_bb(b), IR_AND);
    a1->dst = vm; a1->src[0] = v; a1->src[1] = -1; a1->imm = mask;
    int vms = vm;
    if (boff > 0) {
        vms = new_temp(b, unit_w); b->f->vregs[vms].width = (int16_t)unit_w;
        Op *sl = ir_op_emit(cur_bb(b), IR_SHL);
        sl->dst = vms; sl->src[0] = vm; sl->src[1] = -1; sl->imm = boff;
    }
    int cont = new_temp(b, unit_w); b->f->vregs[cont].width = (int16_t)unit_w;
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst = cont; ld->mem.kind = IR_MEM_VREG;
    ld->mem.base = addr; ld->mem.elem = unit_k;
    int cleared = new_temp(b, unit_w); b->f->vregs[cleared].width = (int16_t)unit_w;
    Op *a2 = ir_op_emit(cur_bb(b), IR_AND);
    a2->dst = cleared; a2->src[0] = cont; a2->src[1] = -1;
    a2->imm = (~fieldmask) & (unit_w == 1 ? 0xFF : 0xFFFF);
    int newv = new_temp(b, unit_w); b->f->vregs[newv].width = (int16_t)unit_w;
    ir_emit_binop(cur_bb(b), IR_OR, newv, cleared, vms);
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0] = newv; st->mem.kind = IR_MEM_VREG;
    st->mem.base = addr; st->mem.elem = unit_k;
    return v;
}

/* True if this binop has a float family operand or result (KIND_FLOAT16 /
   KIND_DOUBLE) — handled by build_binop_float, not the integer path. */
static int binop_is_float(Node *n)
{
    Kind res_k = n->type ? n->type->kind : KIND_NONE;
    return kind_is_floating(res_k)
        || kind_is_floating(node_value_kind(n->left))
        || kind_is_floating(node_value_kind(n->right));
}

static int build_binop_float(Builder *b, Node *n)
{
    Kind res_k = n->type ? n->type->kind : KIND_NONE;
    Kind lkf = node_value_kind(n->left);
    Kind rkf = node_value_kind(n->right);
    if (is_register_float_kind(res_k)
        && (n->ast_type == OP_ADD || n->ast_type == OP_SUB)) {
        int lf = build_operand_as_float_reg(b, n->left, res_k);
        if (lf < 0) return build_fail("float add/sub: lhs not promotable");
        int rf = build_operand_as_float_reg(b, n->right, res_k);
        if (rf < 0) return build_fail("float add/sub: rhs not promotable");
        int dst = new_temp_kind(b, res_k);
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
    if ((is_register_float_kind(lkf) || is_register_float_kind(rkf))
        && !is_acc_float_kind(lkf) && !is_acc_float_kind(rkf)) {
        /* Both register tier (f16/f32). A register-float vs an
           acc-double promotes to the WIDER (double) — defer to the
           acc compare below, which promotes f16→double. Two different
           register floats (f16 vs f32) promote to the wider here. */
        Kind fk = (is_register_float_kind(lkf) && is_register_float_kind(rkf))
                  ? reg_float_common(lkf, rkf)
                  : (is_register_float_kind(lkf) ? lkf : rkf);
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
        const char *cmp = stem ? float_helper(fk, stem) : NULL;
        if (cmp) {
            int lf = build_operand_as_float_reg(b, n->left, fk);
            if (lf < 0) return build_fail("float cmp: lhs not promotable");
            int rf = build_operand_as_float_reg(b, n->right, fk);
            if (rf < 0) return build_fail("float cmp: rhs not promotable");
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
       (dlt/dleq/dgt/dge/deq/dne → int 0/1 bool in HL). Either
       operand may be a mixed int → promoted to double first. */
    if (is_acc_float_kind(lkf) || is_acc_float_kind(rkf)) {
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
            int lf = build_operand_as_acc(b, n->left);
            if (lf < 0) return build_fail("float cmp: lhs not promotable");
            /* A genuine double literal RHS becomes a direct pool constant
               (loaded into FA by the compare), so the computed LHS stays
               adjacent to its producer and that store drops out. Only for a
               real FA accumulator (c_fp_size > 4); a 4-byte register-tier
               double doesn't go through this slot-resident acc path. */
            int r_pool = (c_fp_size > 4 && n->right && n->right->ast_type == AST_LITERAL
                          && n->right->type && n->right->type->kind == KIND_DOUBLE)
                       ? ir_pool_litlab_double(n->right->zval) : -1;
            int rf = (r_pool >= 0) ? -1 : build_operand_as_acc(b, n->right);
            if (r_pool < 0 && rf < 0) return build_fail("float cmp: rhs not promotable");
            int dst = new_temp_kind(b, KIND_INT);
            int *cargs = calloc(2, sizeof(int));
            cargs[0] = lf; cargs[1] = (r_pool >= 0) ? -1 : rf;
            Op *cop = ir_op_emit(cur_bb(b), IR_ACC_CMP);
            cop->dst = dst;
            HelperInfo *chi = calloc(1, sizeof(HelperInfo));
            chi->name = acc_name(cstem);
            chi->args = cargs; chi->n_args = 2; chi->ret_vreg = dst;
            chi->acc_load = acc_name("load");
            chi->acc_push = acc_name("push");
            chi->acc_loadpush = acc_name("loadpush");
            chi->acc_width = c_fp_size; chi->acc_holds_lhs = 0;
            chi->acc_commutative = acc_stem_commutative(cstem);
            if (r_pool >= 0) { chi->acc_src_is_pool[1] = 1; chi->acc_src_litlab[1] = r_pool; }
            cop->hcall = chi;
            return dst;
        }
    }
    /* 5/6-byte double add/sub → wide-accumulator op. Promote a
       mixed int operand to double first. */
    if (is_acc_float_kind(res_k)
        && (n->ast_type == OP_ADD || n->ast_type == OP_SUB)) {
        int lf = build_operand_as_acc(b, n->left);
        if (lf < 0) return build_fail("float add/sub: lhs not promotable");
        int rf = build_operand_as_acc(b, n->right);
        if (rf < 0) return build_fail("float add/sub: rhs not promotable");
        int dst = emit_acc_binop(b,
                     (n->ast_type == OP_ADD) ? "add" : "sub",
                     lf, rf);
        if (dst < 0) return build_fail("acc add/sub emit failed");
        return dst;
    }
    return build_fail("float binop kind %d op %d not yet supported",
                      (int)res_k, (int)n->ast_type);
}

/* The _Accum (fixed-point) kind of a mixed-operand binop, or KIND_NONE if this
   isn't a fixed-mixed ADD/SUB/compare. "Mixed" = one operand _Accum, the other
   a plain int/literal (lka != rka), neither floating. */
static Kind binop_fixed_mixed_kind(Node *n)
{
    Kind lka = node_value_kind(n->left), rka = node_value_kind(n->right);
    Kind ak = (lka == KIND_ACCUM16 || lka == KIND_ACCUM32) ? lka
            : (rka == KIND_ACCUM16 || rka == KIND_ACCUM32) ? rka
            : KIND_NONE;
    int is_cmp = (n->ast_type == OP_EQ || n->ast_type == OP_NE
               || n->ast_type == OP_LT || n->ast_type == OP_LE
               || n->ast_type == OP_GT || n->ast_type == OP_GE);
    if (ak != KIND_NONE && lka != rka
        && (n->ast_type == OP_ADD || n->ast_type == OP_SUB || is_cmp)
        && !kind_is_floating(lka) && !kind_is_floating(rka))
        return ak;
    return KIND_NONE;
}

/* Fixed-mixed _Accum binop/compare: scale the int to Q-format, then a plain
   integer op (Q is additive + ordered like int). `ak` from the guard. */
static int build_binop_fixed(Builder *b, Node *n, OpKind k, Kind ak)
{
    int is_cmp = (n->ast_type == OP_EQ || n->ast_type == OP_NE
               || n->ast_type == OP_LT || n->ast_type == OP_LE
               || n->ast_type == OP_GT || n->ast_type == OP_GE);
    int l = build_operand_as_accum(b, n->left, ak);
    int r = build_operand_as_accum(b, n->right, ak);
    if (l < 0 || r < 0) return build_fail("_Accum binop operand");
    int dst = new_temp_kind(b, is_cmp ? KIND_INT : ak);
    Op *o = ir_op_emit(cur_bb(b), k);
    o->dst = dst; o->src[0] = l; o->src[1] = r;
    return dst;
}

/* long long binop? arith/shift result acc-int (a shift follows the LHS, whose
   declared type is unreliable for a fnptr call → check the LHS value kind);
   compare with an acc-int operand. VALUE types (a fnptr call keeps KIND_FUNC). */
static int binop_is_i64(Node *n)
{
    int is_cmp = (n->ast_type == OP_EQ || n->ast_type == OP_NE
               || n->ast_type == OP_LT || n->ast_type == OP_LE
               || n->ast_type == OP_GT || n->ast_type == OP_GE);
    int is_shift = (n->ast_type == OP_USHL || n->ast_type == OP_SSHL
                 || n->ast_type == OP_USHR || n->ast_type == OP_SSHR);
    Type *lvt = node_value_type(n->left);
    Type *rvt = node_value_type(n->right);
    Kind lki = lvt ? lvt->kind : KIND_NONE;
    Kind rki = rvt ? rvt->kind : KIND_NONE;
    Kind reski = n->type ? n->type->kind : KIND_NONE;
    if (is_cmp) return is_acc_int_kind(lki) || is_acc_int_kind(rki);
    return is_acc_int_kind(reski) || (is_shift && is_acc_int_kind(lki));
}

/* long long binop/compare → l_i64_* via IR_ACC_*. */
static int build_binop_i64(Builder *b, Node *n)
{
    Type *lvt = node_value_type(n->left);
    Type *rvt = node_value_type(n->right);
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
        shift_uns = (lvt && lvt->isunsigned);
        break;
    case OP_LT: cstem = "lt"; break;
    case OP_LE: cstem = "le"; break;
    case OP_GT: cstem = "gt"; break;
    case OP_GE: cstem = "ge"; break;
    case OP_EQ: cstem = "eq"; break;
    case OP_NE: cstem = "ne"; break;
    default: break;
    }
    /* Shift helper signedness comes from the op (asr vs asr_u); other ops use
       the usual either-operand-unsigned rule. */
    int is_uns = (shift_uns >= 0) ? shift_uns
        : ((lvt && lvt->isunsigned) || (rvt && rvt->isunsigned));
    int l = build_expr(b, n->left);
    if (l < 0) return -1;
    int is_shift = stem && (!strcmp(stem, "shl") || !strcmp(stem, "shr"));
    if (is_shift) {
        /* value -> i64; the count stays an int (low byte in A). A literal
           count goes straight to an immediate, materialising no count vreg. */
        l = promote_to_acc_int(b, l, lvt && lvt->isunsigned);
        if (l < 0) return -1;
        Node *cn = n->right;
        int dst;
        if (cn && cn->ast_type == AST_LITERAL) {
            dst = emit_acc_int_shift(b, stem, l, -1, (int64_t)cn->zval, 1, is_uns);
        } else {
            int r = build_expr(b, n->right);
            if (r < 0) return -1;
            dst = emit_acc_int_shift(b, stem, l, r, 0, 0, is_uns);
        }
        if (dst < 0) return build_fail("i64 shift emit failed");
        return dst;
    }
    if (stem) {
        int r = build_expr(b, n->right);
        if (r < 0) return -1;
        l = promote_to_acc_int(b, l, lvt && lvt->isunsigned);
        r = promote_to_acc_int(b, r, rvt && rvt->isunsigned);
        if (l < 0 || r < 0) return -1;
        int dst = emit_acc_int_binop(b, stem, l, r, is_uns);
        if (dst < 0) return build_fail("i64 binop emit failed");
        return dst;
    }
    /* Compare: a literal right operand becomes a pool constant the compare
       loads directly (no vreg), keeping the computed left operand adjacent to
       its producer so the producer's store drops out. */
    int r_pool = (n->right && n->right->ast_type == AST_LITERAL)
               ? ir_pool_litlab_llong((int64_t)n->right->zval) : -1;
    int r = (r_pool >= 0) ? -1 : build_expr(b, n->right);
    if (r_pool < 0 && r < 0) return -1;
    l = promote_to_acc_int(b, l, lvt && lvt->isunsigned);
    if (l < 0) return -1;
    if (r_pool < 0) {
        r = promote_to_acc_int(b, r, rvt && rvt->isunsigned);
        if (r < 0) return -1;
    }
    int dst = emit_acc_int_cmp(b, cstem, l, -1, r, r_pool, is_uns);
    if (dst < 0) return build_fail("i64 cmp emit failed");
    return dst;
}

/* True if this mul/div/mod is a long long op: acc-int result, or both operands
   acc-int (a mixed `ll * int` promotes to ll, caught by the result). */
static int muldiv_is_i64(Node *n)
{
    Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
    Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
    Kind res = n->type ? n->type->kind : KIND_NONE;
    return is_acc_int_kind(res) || (is_acc_int_kind(lk) && is_acc_int_kind(rk));
}

/* long long mul/div/mod → l_i64_* via IR_ACC_*. */
static int build_muldiv_i64(Builder *b, Node *n)
{
    int is_uns = (n->left->type && n->left->type->isunsigned)
              || (n->right->type && n->right->type->isunsigned);
    int l = build_expr(b, n->left);
    if (l < 0) return -1;
    int r = build_expr(b, n->right);
    if (r < 0) return -1;
    l = promote_to_acc_int(b, l, n->left->type && n->left->type->isunsigned);
    r = promote_to_acc_int(b, r, n->right->type && n->right->type->isunsigned);
    if (l < 0 || r < 0) return -1;
    const char *stem = (n->ast_type == OP_MULT) ? "mul"
                     : (n->ast_type == OP_DIV)  ? "div" : "mod";
    int dst = emit_acc_int_binop(b, stem, l, r, is_uns);
    if (dst < 0) return build_fail("i64 mul/div/mod emit failed");
    return dst;
}

/* The _Accum result kind of a fixed-point mul/div (one operand _Accum, result
   _Accum), or KIND_NONE. `_Accum OP double` (result double) is NOT fixed —
   it's left to the float path. */
static Kind muldiv_fixed_kind(Node *n)
{
    Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
    Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
    Kind res = n->type ? n->type->kind : KIND_NONE;
    if ((kind_is_fixed(lk) || kind_is_fixed(rk))
        && (n->ast_type == OP_MULT || n->ast_type == OP_DIV)
        && kind_is_fixed(res))
        return res;
    return KIND_NONE;
}

/* Fixed-point mul/div: scale operands to Q-format, then l_fix{16,32}_{mul,div}{s,u}. */
static int build_muldiv_fixed(Builder *b, Node *n, Kind ak)
{
    int l = build_operand_as_accum(b, n->left, ak);
    int r = build_operand_as_accum(b, n->right, ak);
    if (l < 0 || r < 0) return build_fail("_Accum mul/div operand");
    int us = (n->left->type && n->left->type->isunsigned)
          || (n->right->type && n->right->type->isunsigned);
    const char *helper = (ak == KIND_ACCUM32)
        ? (n->ast_type == OP_MULT ? (us ? "l_fix32_mulu" : "l_fix32_muls")
                                  : (us ? "l_fix32_divu" : "l_fix32_divs"))
        : (n->ast_type == OP_MULT ? (us ? "l_fix16_mulu" : "l_fix16_muls")
                                  : (us ? "l_fix16_divu" : "l_fix16_divs"));
    int dst = new_temp_kind(b, ak);
    int *args = calloc(2, sizeof(int)); args[0] = l; args[1] = r;
    Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
    op->dst = dst;
    HelperInfo *hi = calloc(1, sizeof(HelperInfo));
    hi->name = helper; hi->args = args; hi->n_args = 2;
    hi->n_stacked = 1; hi->ret_vreg = dst;
    op->hcall = hi;
    return dst;
}

/* True if this mul/div has a float operand or result (register f16/f32 or
   5/6-byte double) — handled by build_muldiv_float. */
static int muldiv_is_float(Node *n)
{
    Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
    Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
    return kind_is_floating(lk) || kind_is_floating(rk)
        || (n->type && kind_is_floating(n->type->kind));
}

/* Float mul/div: double via the accumulator, register f16/f32 via
   emit_float_arith, promoting a mixed int. *handled=0 for the one case it
   doesn't emit — same-kind register float (f16*f16) falls through to int. */
static int build_muldiv_float(Builder *b, Node *n, int *handled)
{
    *handled = 1;
    Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
    Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
    if (n->ast_type != OP_MULT && n->ast_type != OP_DIV)
        return build_fail("float op %d not yet supported", (int)n->ast_type);
    /* `1.0 / x` → reciprocal(x): a float divide is reciprocal-then-multiply,
       so a unit numerator lets us call the inverse helper directly and skip
       the trailing multiply-by-one (and the 1.0 operand load). Only where a
       register-float inverse helper exists (see float_reciprocal_ok). */
    if (n->ast_type == OP_DIV && node_is_numeric_one(n->left)) {
        Kind rfk = (n->type && kind_is_floating(n->type->kind))
                     ? n->type->kind
                 : is_register_float_kind(rk) ? rk : KIND_NONE;
        if (float_reciprocal_ok(rfk)) {
            int r = build_operand_as_float_reg(b, n->right, rfk);
            if (r < 0) return build_fail("reciprocal: divisor not promotable");
            int dst = emit_float_reciprocal(b, rfk, r);
            if (dst < 0) return build_fail("reciprocal emit failed");
            return dst;
        }
    }
    /* 5/6-byte double mul/div → wide-accumulator op. */
    if (is_acc_float_kind(lk) && lk == rk) {
        int l = build_expr(b, n->left);
        if (l < 0) return -1;
        int r = build_expr(b, n->right);
        if (r < 0) return -1;
        int dst = emit_acc_binop(b, (n->ast_type == OP_MULT) ? "mul" : "div", l, r);
        if (dst < 0) return build_fail("acc mul/div emit failed");
        return dst;
    }
    /* Mixed `int OP double` (result acc-double): promote the int to double. */
    if (is_acc_float_kind(n->type ? n->type->kind : KIND_NONE)) {
        int l = build_operand_as_acc(b, n->left);
        if (l < 0) return build_fail("float mul/div: lhs not promotable");
        int r = build_operand_as_acc(b, n->right);
        if (r < 0) return build_fail("float mul/div: rhs not promotable");
        int dst = emit_acc_binop(b, (n->ast_type == OP_MULT) ? "mul" : "div", l, r);
        if (dst < 0) return build_fail("acc mul/div emit failed");
        return dst;
    }
    /* Mixed int × register-float (f16 / IEEE-32): promote the int to the float
       kind, then l_f{16,32}_mul/div. Same-kind (both supported) falls through. */
    if (is_register_float_kind(lk) != is_register_float_kind(rk)) {
        Kind fk = is_register_float_kind(lk) ? lk : rk;
        int l = build_operand_as_float_reg(b, n->left, fk);
        if (l < 0) return build_fail("float mul/div: lhs not promotable");
        int r = build_operand_as_float_reg(b, n->right, fk);
        if (r < 0) return build_fail("float mul/div: rhs not promotable");
        int dst = emit_float_arith(b, fk, (n->ast_type == OP_MULT) ? "mul" : "div", l, r);
        if (dst < 0) return build_fail("float mul/div emit failed");
        return dst;
    }
    /* Two different register floats (f16 vs IEEE-32): promote both to the
       wider, then l_f{16,32}_mul/div. */
    if (is_register_float_kind(lk) && is_register_float_kind(rk) && lk != rk) {
        Kind fk = reg_float_common(lk, rk);
        int l = build_operand_as_float_reg(b, n->left, fk);
        if (l < 0) return build_fail("float mul/div: lhs not promotable");
        int r = build_operand_as_float_reg(b, n->right, fk);
        if (r < 0) return build_fail("float mul/div: rhs not promotable");
        int dst = emit_float_arith(b, fk, (n->ast_type == OP_MULT) ? "mul" : "div", l, r);
        if (dst < 0) return build_fail("float mul/div emit failed");
        return dst;
    }
    /* Register-tier float: both same supported kind; anything else bails. */
    if (!is_register_float_kind(lk) || lk != rk)
        return build_fail("float mul/div: operands not both supported float");
    *handled = 0;   /* same-kind register float: not emitted here, fall through */
    return -1;
}

/* Integer compound-assign RMW: load the lvalue (bitfield/local/global/deref),
   combine in place with op k, store back. */
static int build_compound_int(Builder *b, Node *n, OpKind k)
{
    /* Arithmetic-vs-logical `>>=`: signed LHS → arithmetic (IR_SHR_ARITH),
       mirrored from the expression path. Stamped onto every IR_SHR this
       function emits (const + variable forms). */
    Type *cmp_lvt = n->left ? node_value_type(n->left) : NULL;
    int64_t shr_arith_bit = (k == IR_SHR && !(cmp_lvt && cmp_lvt->isunsigned))
                          ? IR_SHR_ARITH : 0;
    /* Bitfield compound assign: `bf op= rhs` == `bf = extract(bf) op rhs`,
       then a read-modify-write store. The generic paths below treat the
       LHS as the whole storage unit, which operates on the wrong bits
       (e.g. `b |= 1` at bit offset 3 ORs bit 0). The LHS rvalue
       (OP_DEREF carrying bit_size) extracts the field on read; the
       helper re-inserts the result at the field's offset. */
    if (n->left && n->left->ast_type == OP_DEREF && n->left->operand
        && n->left->type && n->left->type->bit_size > 0) {
        Type *bft = n->left->type;
        int cur = build_expr(b, n->left);       /* extracted field value */
        if (cur < 0) return -1;
        int rhs = build_expr(b, n->right);
        if (rhs < 0) return -1;
        if (b->f->vregs[cur].width != 2) {
            int t = new_temp(b, 2); b->f->vregs[t].width = 2;
            Op *c = ir_op_emit(cur_bb(b),
                bft->isunsigned ? IR_CONV_ZX : IR_CONV_SX);
            c->dst = t; c->src[0] = cur; cur = t;
        }
        if (b->f->vregs[rhs].width != 2) {
            int t = new_temp(b, 2); b->f->vregs[t].width = 2;
            OpKind cv = (b->f->vregs[rhs].width > 2) ? IR_CONV_TRUNC
                      : (n->right->type && n->right->type->isunsigned
                         ? IR_CONV_ZX : IR_CONV_SX);
            Op *c = ir_op_emit(cur_bb(b), cv);
            c->dst = t; c->src[0] = rhs; rhs = t;
        }
        int res = new_temp(b, 2); b->f->vregs[res].width = 2;
        { Op *o = ir_emit_binop(cur_bb(b), k, res, cur, rhs); o->imm |= shr_arith_bit; }
        return emit_bitfield_store(b, n->left->operand, bft, res,
                                   bft->isunsigned);
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
            int tmp = new_temp_kind(b, KIND_INT);
            if (n->right && n->right->ast_type == AST_LITERAL) {
                Op *op = ir_op_emit(cur_bb(b), k);
                op->dst = tmp; op->src[0] = lhs_v;
                op->src[1] = -1; op->imm = (int64_t)n->right->zval | shr_arith_bit;
            } else {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                { Op *o = ir_emit_binop(cur_bb(b), k, tmp, lhs_v, rhs_v); o->imm |= shr_arith_bit; }
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
            op->imm    = (int64_t)n->right->zval | shr_arith_bit;
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
            int tmp = new_temp_kind(b, KIND_LONG);
            int uns = n->right->type && n->right->type->isunsigned;
            Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = tmp; cv->src[0] = rhs_v;
            rhs_v = tmp;
        }
        { Op *o = ir_emit_binop(cur_bb(b), k, lhs_v, lhs_v, rhs_v); o->imm |= shr_arith_bit; }  /* aliased */
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
            op->src[1] = -1; op->imm = (int64_t)n->right->zval | shr_arith_bit;
        } else {
            int rhs_v = build_expr(b, n->right);
            if (rhs_v < 0) return -1;
            { Op *o = ir_emit_binop(cur_bb(b), k, dst_g, loaded_g, rhs_v); o->imm |= shr_arith_bit; }
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
    /* Keep the element kind in a local: the `ld` Op* points into the BB's
       ops array, which the emits below (binop, store) can realloc — reading
       ld->mem.elem afterwards would be a use-after-free. */
    Kind elem_k = (elem_w == 1) ? KIND_CHAR
                : (elem_w == 2) ? KIND_INT
                :                 KIND_LONG;
    Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
    ld->dst       = loaded;
    ld->mem.kind  = IR_MEM_VREG;
    ld->mem.base  = ptr_v;
    ld->mem.elem  = elem_k;
    ld->mem.bank_fn = bf;
    int dst = new_temp(b, elem_w);
    b->f->vregs[dst].width = elem_w;
    if (n->right && n->right->ast_type == AST_LITERAL) {
        Op *op = ir_op_emit(cur_bb(b), k);
        op->dst    = dst;
        op->src[0] = loaded;
        op->src[1] = -1;
        op->imm    = (int64_t)n->right->zval | shr_arith_bit;
    } else {
        int rhs_v = build_expr(b, n->right);
        if (rhs_v < 0) return -1;
        { Op *o = ir_emit_binop(cur_bb(b), k, dst, loaded, rhs_v); o->imm |= shr_arith_bit; }
    }
    Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
    st->src[0]    = dst;
    st->mem.kind  = IR_MEM_VREG;
    st->mem.base  = ptr_v;
    st->mem.elem  = elem_k;   /* NOT ld->mem.elem — `ld` may be realloc-stale */
    st->mem.bank_fn = bf;
    return dst;
}

/* Integer compound *= /= %= RMW: load lvalue, l_mult/l_long_mult/l_div,
   store back. */
static int build_compound_muldiv(Builder *b, Node *n)
{

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
        lhs_v = new_temp_kind(b, elem_kind);
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
        lhs_v = new_temp_kind(b, elem_kind);
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

/* Result dest: the caller's `hint` vreg if given (>= 0), else a fresh temp.
   The hint lets the result write straight into the target slot, no copy. */
static inline int get_dest_vreg(Builder *b, int hint, int width)
{
    return hint >= 0 ? hint : new_temp(b, width);
}

/* get_dest_vreg + stamp the result's width and kind. */
static inline int get_dest_typed(Builder *b, int hint, int width, Kind kind)
{
    int v = get_dest_vreg(b, hint, width);
    b->f->vregs[v].width = (int16_t)width;
    b->f->vregs[v].kind  = kind;
    return v;
}

static int build_expr_hinted(Builder *b, Node *n, int hint)
{
    if (n && n->filename && n->line > 0) {
        cur_node_file = n->filename;
        cur_node_line = n->line;
    }
    if (!n) return build_fail("null expr node");

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
            int fv = new_temp_kind(b, KIND_FLOAT16);
            ir_emit_ld_imm(cur_bb(b), fv,
                           (int64_t)(((int)fa[1] << 8) | fa[0]));
            return fv;
        }
        if (lit_fk == KIND_DOUBLE) {
            if (is_register_float_kind(KIND_DOUBLE)) {
                /* IEEE-32 / MBF-single (c_fp_size==4): materialise the FA bit
                   pattern as a 4-byte immediate. */
                unsigned char fa[8];
                dofloat(c_maths_mode, (double)n->zval, fa);
                int fv = new_temp_kind(b, KIND_DOUBLE);
                uint32_t bits = ((uint32_t)fa[3] << 24) | ((uint32_t)fa[2] << 16)
                              | ((uint32_t)fa[1] << 8)  | (uint32_t)fa[0];
                ir_emit_ld_imm(cur_bb(b), fv, (int64_t)bits);
                return fv;
            }
            /* 5/6/8-byte double literal: materialise the FA bit pattern in the
               const.c literal pool and dload it. (Width-2/4 f16/f32 literals
               were handled above as immediates.) */
            return emit_pool_load(b, ir_pool_litlab_double(n->zval),
                                  c_fp_size, KIND_DOUBLE);
        }
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
               (2^31, 2^32) zero-extends. (Keying off the type's isunsigned
               would zero-extend `(long long)-1` to 0x00000000FFFFFFFF.) */
            int ext_uns = (val > 2147483647LL);
            int lt = new_temp_kind(b, KIND_LONG);
            ir_emit_ld_imm(cur_bb(b), lt, val & 0xffffffffLL);
            return emit_acc_int_from_int(b, lt, ext_uns);
        }
        /* Width from the literal's type. A `long` constant must
           materialise into a width-4 vreg — width=2 drops the high
           half. Default to int when type info is gone. */
        int w = n->type ? type_width(n->type) : 2;
        if (w != 1 && w != 2 && w != 4) w = 2;
        /* If the caller hinted a destination vreg whose kind is
           _Accum, the literal is an FP value being implicitly
           converted — scale to Q-format raw bits and use the
           target width (ACCUM32 needs width 4 even when the
           literal was a 2-byte double). */
        Kind target_k = (hint >= 0) ? (Kind)b->f->vregs[hint].kind
                                    : KIND_NONE;
        /* Effective fixed-point kind for the Q-format scaling. Prefer the hint
           dst (an int literal implicitly converted, `_Accum a = 3;` → 3×256),
           but fall back to the literal's OWN type — a folded or cast-operand
           _Accum constant carries no hint yet must still materialise scaled,
           else `(int)(1.5k+1.5k)` emits raw 3 (→ l_fix16_f2sint → 0) instead of
           768. Mirrors how the FLOAT16/DOUBLE paths above key on n->type->kind. */
        Kind accum_k = (target_k == KIND_ACCUM16 || target_k == KIND_ACCUM32)
                         ? target_k
                     : (n->type && (n->type->kind == KIND_ACCUM16
                                    || n->type->kind == KIND_ACCUM32))
                         ? n->type->kind
                     : KIND_NONE;
        if      (accum_k == KIND_ACCUM32) w = 4;
        else if (accum_k == KIND_ACCUM16) w = 2;
        int v = get_dest_vreg(b, hint, w);
        /* A hinted dst (decl-init) keeps its DECLARED width — the
           literal adapts to the variable, not vice versa, so `UINT4
           crc = 0` doesn't shrink crc's vreg to the int literal's
           width 2 (which would run every later long op on crc 16-bit). */
        if (hint >= 0 && b->f->vregs[v].width > 0
            && accum_k != KIND_ACCUM16 && accum_k != KIND_ACCUM32)
            w = b->f->vregs[v].width;
        b->f->vregs[v].width = (int16_t)w;
        if (accum_k == KIND_ACCUM16 || accum_k == KIND_ACCUM32)
            b->f->vregs[v].kind = accum_k;
        ir_emit_ld_imm(cur_bb(b), v, scale_literal_for_kind(n, accum_k));
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
           through it (lp_g*), not a plain near `ld hl,(_g)` that would
           ignore the banking. */
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
           in expression context (C §6.3.2.1): emit `ld hl,_sym`, not
           `ld hl,(_sym)`. Aggregates (struct/union) at the AST level are
           usually flagged separately — start with the two most common
           decays and extend if needed. */
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
        /* Global — load from MEM_SYM, width from the symbol's kind
           (sym->type is the KIND_* code). */
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
        /* __far pointer VALUE (3 bytes in memory): tag the vreg so the
           lowerer does a 3-byte read, not a 4-byte long read. */
        if (n->sym && (Kind)n->sym->type == KIND_CPTR) {
            b->f->vregs[v].kind = KIND_CPTR;
            op->mem.elem = KIND_CPTR;
        }
        return v;
    }

    case OP_DEREF:
        /* Bitfield rvalue: a member access folds to a plain deref whose
           TYPE carries bit_offset/bit_size. Load the whole storage unit,
           shift the field down to bit 0, then mask to its width. Signed
           bitfields need sign-extension of the masked value — not yet
           supported. */
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
            if (elem_w != 1 && elem_w != 2 && elem_w != 4)
                return build_fail("deref-step elem width %d not supported",
                                  elem_w);
            /* Step amount: sizeof(*p). char* → +/-1 (IR_INC/IR_DEC);
               int* → +/-2 (IR_ADD/SUB with imm). Pointee width from
               the local's pointed-to type, falling back to the deref's
               result width if unavailable. */
            int pointee_w = lsym->ctype && lsym->ctype->ptr
                ? type_width(lsym->ctype->ptr) : elem_w;
            if (pointee_w != 1 && pointee_w != 2 && pointee_w != 4)
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
            /* Width-4 element (long / pointer-to-pointer): the result lands
               in DEHL — tag the vreg kind so the long store/use path
               dispatches correctly. */
            Kind ek = n->type ? (Kind)n->type->kind : KIND_NONE;
            if (elem_w == 4)
                b->f->vregs[dst].kind = ek;
            Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
            ld->dst      = dst;
            ld->mem.kind = IR_MEM_VREG;
            ld->mem.base = p_vreg;
            ld->mem.elem = (elem_w == 1) ? KIND_CHAR
                         : (elem_w == 2) ? KIND_INT
                         :                 KIND_LONG;
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
                Kind ek = n->type ? (Kind)n->type->kind : KIND_NONE;
                int wide_acc = ((ek == KIND_DOUBLE || ek == KIND_FLOAT)
                                && elem_w >= 5) || ek == KIND_LONGLONG;
                if (elem_w != 1 && elem_w != 2 && elem_w != 4 && !wide_acc)
                    return build_fail("OP_DEREF aggregate elem width %d "
                                      "not supported", elem_w);
                int base = new_temp(b, 2);
                Op *lea = ir_op_emit(cur_bb(b), IR_LEA);
                lea->dst = base; lea->src[0] = v;
                int dst = new_temp(b, elem_w);
                b->f->vregs[dst].width = (int16_t)elem_w;
                if (wide_acc || elem_w == 4 || ek == KIND_CPTR)
                    b->f->vregs[dst].kind = ek; /* acc/float ops dispatch on kind */
                Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
                ld->dst       = dst;
                ld->mem.kind  = IR_MEM_VREG;
                ld->mem.base  = base;
                ld->mem.elem  = wide_acc ? ek
                              : (elem_w == 1) ? KIND_CHAR
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
               above, so OP_DEREF(global long) keeps its width. For
               ARRAY globals the deref reads ELEMENT 0 (the parser
               const-folds `arr[0]` to this shape): width must come
               from the element type — KIND_ARRAY itself has no width. */
            int gv_w = 2;
            SYMBOL *gs = n->operand->sym;
            /* The deref node's own type is the VALUE type — the only
               reliable width source when the parser folds a struct
               member read (`g.i[0]`, struct sym, offset 0) to this
               bare-global shape: KIND_STRUCT has no usable elem in
               ctype->ptr. */
            if (n->type && is_register_int_kind(n->type->kind)) {
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
                int dv = new_temp_kind(b, KIND_DOUBLE);
                Op *op = ir_op_emit(cur_bb(b), IR_LD_MEM);
                op->dst = dv; op->mem.kind = IR_MEM_VREG;
                op->mem.base = ptr_v; op->mem.elem = KIND_DOUBLE;
                op->mem.bank_fn = bf;
                return dv;
            }
            if (n->type && is_acc_int_kind(n->type->kind)) {
                /* `*p` wide long long load via l_i64_load. */
                int dv = new_temp_kind(b, KIND_LONGLONG);
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

        /* Dispatch by operand family (each handler emits the fused helper /
           IR_ACC_* op); build_binop_integer is the residual fall-through.
           _Accum mixed = scale-to-Q + integer op; float = f16/f32 + double
           acc helpers; long long = l_i64_* via IR_ACC_*. Mul/div/mod live in
           the OP_MULT/DIV/MOD case. */
        Kind ak = binop_fixed_mixed_kind(n);
        if (ak != KIND_NONE)   return build_binop_fixed(b, n, k, ak);
        if (binop_is_float(n)) return build_binop_float(b, n);
        if (binop_is_i64(n))   return build_binop_i64(b, n);

        return build_binop_integer(b, n, k, hint);
    }

        case OP_ASSIGN: return build_assign(b, n);

    case AST_PRESERVE_BC:
        /* Expression context: passthrough — our IR doesn't pin to BC.
           Same rationale as the statement-context handler. */
        return n->operand ? build_expr(b, n->operand) : -1;

    case OP_MOD:
    case OP_MULT:
    case OP_DIV: {
        Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
        Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
        if ((kind_is_fixed(lk) || kind_is_fixed(rk)) && n->ast_type == OP_MOD)
            return build_fail("OP_MOD on _Accum not defined");

        /* Dispatch by operand family; build_muldiv_integer is the residual
           (and lands the same-kind register-float fall-through). _Accum mixed
           mul/div = scale-to-Q + l_fix helper; double/mixed = acc/f16/f32;
           long long = l_i64_*. */
        Kind ak = muldiv_fixed_kind(n);
        if (ak != KIND_NONE) return build_muldiv_fixed(b, n, ak);
        if (muldiv_is_float(n)) {
            int handled;
            int r = build_muldiv_float(b, n, &handled);
            if (handled) return r;
        }
        /* long long mul/div/mod → l_i64_mult/div/mod via IR_ACC_*. */
        if (muldiv_is_i64(n)) return build_muldiv_i64(b, n);
        return build_muldiv_integer(b, n);
    }

    case OP_NEG: {
        if (!n->operand) return build_fail("OP_NEG with no operand");
        /* Float negate is a sign-bit flip, not integer two's-complement.
           FLOAT16 (IEEE half, sign in bit 15) is XOR 0x8000 on the 2-byte
           value (no helper); 4-byte and acc-tier doubles below. */
        if (n->operand->type && kind_is_floating(n->operand->type->kind)) {
            Kind nk = n->operand->type->kind;
            int fv = build_expr(b, n->operand);
            if (fv < 0) return -1;
            if (nk == KIND_FLOAT16) {
                /* IEEE half: sign in bit 15 — XOR 0x8000, no helper. */
                int dst = new_temp_kind(b, KIND_FLOAT16);
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
                int dst = new_temp_kind(b, nk);
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
        /* long long: no width-8 IR_NEG lowering — negate via __i64_acc. */
        if ((int)b->f->vregs[v].kind == KIND_LONGLONG)
            return emit_acc_int_unary(b, v, "l_i64_neg");
        int width = b->f->vregs[v].width;
        int dst = get_dest_typed(b, hint, width, b->f->vregs[v].kind);
        ir_emit_unop(cur_bb(b), IR_NEG, dst, v);
        return dst;
    }

    case OP_COMP: {
        /* ~x — bitwise complement. */
        if (!n->operand) return build_fail("OP_COMP with no operand");
        int v = build_expr(b, n->operand);
        if (v < 0) return -1;
        /* long long: no width-8 IR_NOT lowering — complement via __i64_acc. */
        if ((int)b->f->vregs[v].kind == KIND_LONGLONG)
            return emit_acc_int_unary(b, v, "l_i64_com");
        int width = b->f->vregs[v].width;
        int dst = get_dest_typed(b, hint, width, b->f->vregs[v].kind);
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
        int dst = new_temp_kind(b, KIND_INT);
        /* Width 4 (long/far-ptr, byte-wise XOR-OR chain) and width 1 (byte,
           tested with `or a` — no 16-bit widen) both use the const-RHS EQ-0
           fold; only the plain int case needs a materialised 0 vreg. */
        if (b->f->vregs[v].width == 4 || b->f->vregs[v].width == 1) {
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
        if (!c_disable_builtins
            && strcmp(n->sym->name, "__builtin_memset") == 0
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
        if (!c_disable_builtins
            && strcmp(n->sym->name, "__builtin_memcpy") == 0
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
        if (!c_disable_builtins
            && strcmp(n->sym->name, "__builtin_strcpy") == 0
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
        if (!c_disable_builtins
            && strcmp(n->sym->name, "__builtin_strchr") == 0
            && n_args == 2 && ir_inline_block_ops_ok()) {
            Node *c_node = array_get_byindex(n->args, 1);
            int str_v = build_expr(b, array_get_byindex(n->args, 0));
            if (str_v < 0) return -1;
            /* Evaluate the search-char operand BEFORE emitting IR_STRCHR
               (mirrors the strcpy builder above).  Emitting the op first and
               then build_expr()ing the char appended the char's loads AFTER
               the op that consumes them — a use-before-def that reached the
               lowerer with the operand in no register and no slot (abort). */
            int c_v = -1, c_imm = 0, c_is_literal = 0;
            if (c_node && c_node->ast_type == AST_LITERAL) {
                c_is_literal = 1;
                c_imm = (int)c_node->zval;   /* literal search char */
            } else {
                c_v = build_expr(b, c_node);
                if (c_v < 0) return -1;
            }
            int dst = new_temp_kind(b, KIND_INT);
            Op *op = ir_op_emit(cur_bb(b), IR_STRCHR);
            op->dst    = dst;
            op->src[0] = str_v;          /* string pointer */
            if (c_is_literal) {
                op->src[1] = -1;
                op->imm    = c_imm;
            } else {
                op->src[1] = c_v;        /* search char value */
            }
            return dst;
        }
        /* R→L build/push order ONLY for plain stdc — CALLEE pushes
           L→R like SMALLC (must mirror gen_call's push_step). */
        uint32_t fl = n->sym->ctype ? n->sym->ctype->flags : 0;
        int is_stdc = !is_fastcall && !(fl & SMALLC) && !(fl & CALLEE);
        int *args = NULL;
        int *arg_pushed_bytes = NULL;
        int pre_pushed = 0;
        if (n_args > 0) {
            args = calloc(n_args, sizeof(int));
            arg_pushed_bytes = calloc(n_args, sizeof(int));
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
            /* __sdcccall(1) passes its args in registers (loaded by
               gen_call), so none are pre-pushed — leave them in args[]. */
            int is_sdcccall1 = (fl & SDCCCALL1) != 0;
            int n_to_push = is_fastcall ? n_args - 1
                          : is_sdcccall1 ? 0
                          : n_args;
            int push_bb   = b->cur_bb_id;
            int pushable  = 1;
            int push_ops[64];
            int n_push_ops = 0;
            int has_struct_arg = 0;
            for (int k = 0; k < n_args; k++) {
                int i;
                if (is_fastcall)
                    i = k;                    /* 0..n-2 pushed, n-1 last */
                else if (is_stdc)
                    i = n_args - 1 - k;       /* right-to-left */
                else
                    i = k;                    /* left-to-right */
                Node *a = array_get_byindex(n->args, i);
                /* A struct argument is materialised as its ADDRESS
                   (agg_lvalue_addr bails on shapes it can't address, rolling
                   back the whole call). What happens next depends on the
                   PARAMETER type:
                     - param is also a struct (by value): push a COPY of
                       `size` bytes (IR_PUSH_STRUCT) — sccz80 / SDCC
                       sdcccall(0) ABI.
                     - param is a pointer / void* (or unprototyped): the
                       struct decays to its address — push that 2-byte
                       pointer like any scalar (z88dk's lax by-reference
                       idiom, e.g. memcmp(struct,struct,n)). */
                int arg_is_struct = (a && a->type && a->type->kind == KIND_STRUCT);
                Type *pt_i = (n->sym->ctype && n->sym->ctype->parameters
                              && i < (int)array_len(n->sym->ctype->parameters))
                           ? array_get_byindex(n->sym->ctype->parameters, i)
                           : NULL;
                int is_struct = arg_is_struct && pt_i && pt_i->kind == KIND_STRUCT;
                if (is_struct) has_struct_arg = 1;
                int v = arg_is_struct ? agg_lvalue_addr(b, a) : build_expr(b, a);
                if (v < 0) { free(args); free(arg_pushed_bytes); return -1; }
                /* __z88dk_sdccdecl: a char parameter is passed as ONE
                   byte (not the smallc 2-byte int promotion). Truncate
                   the arg to width-1 so gen_call emits the 1-byte push
                   and the callee's 1-byte param slot lines up. (A width-1
                   arg also fails the pushable test below, so the call
                   falls to gen_call's slot loop where the 1-byte push
                   lives.) */
                if (!arg_is_struct
                    && (n->sym->ctype->flags & (SDCCDECL | SDCCCALL1))
                    && n->sym->ctype->parameters) {
                    Type *pt = array_get_byindex(n->sym->ctype->parameters, i);
                    if (pt && pt->kind == KIND_CHAR
                        && b->f->vregs[v].width != 1) {
                        int t = new_temp_kind(b, KIND_CHAR);
                        Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                        cv->dst = t; cv->src[0] = v;
                        v = t;
                    }
                }
                /* Widen a narrow integer ARG to a wider prototyped PARAM.
                   The front-end leaves the int→long / int→long-long
                   promotion to codegen, so widen here to fill the param's
                   high bytes. Only long / long long params (char→int
                   already promotes via the smallc push); integer args
                   only; an unprototyped (variadic) slot has no Type and is
                   left as-is. */
                if (!arg_is_struct && n->sym->ctype && n->sym->ctype->parameters) {
                    Type *pt = array_get_byindex(n->sym->ctype->parameters, i);
                    v = widen_arg_to_param(b, v, a, pt);
                }
                args[i] = v;
                /* Bytes this arg occupies on the caller stack: a struct's full
                   size (its vreg is just the 2-byte address), else the vreg
                   width. Drives the variadic count + caller cleanup. */
                int struct_bytes = is_struct ? a->type->size : 0;
                arg_pushed_bytes[i] = is_struct ? struct_bytes
                                                : b->f->vregs[v].width;
                if (b->cur_bb_id != push_bb) pushable = 0;
                int w = b->f->vregs[v].width;
                int want_push = (k < n_to_push);
                if (want_push && pushable && is_struct
                    && struct_bytes > 0 && n_push_ops < 64) {
                    /* Push a copy of the struct's bytes (size in imm). */
                    Op *p = ir_op_emit(cur_bb(b), IR_PUSH_STRUCT);
                    p->src[0] = v;
                    p->src[1] = -1;
                    p->imm    = struct_bytes;
                    push_ops[n_push_ops++] = cur_bb(b)->n_ops - 1;
                } else if (want_push && pushable && !is_struct
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
                /* The legacy slot loop in gen_call pushes scalar args from
                   their slots; it has no struct block-copy, so a rolled-back
                   struct arg would push only its 2-byte address (silent ABI
                   break). Rare (struct-address eval spanning BBs) — bail. */
                if (has_struct_arg) {
                    free(args); free(arg_pushed_bytes);
                    return build_fail("struct-by-value argument not pre-pushable "
                                      "(address computation spans basic blocks) "
                                      "— not yet supported");
                }
            }
            /* fastcall puts the last arg in HL and __sdcccall(1) passes args
               in registers — neither can carry a by-value struct, and those
               paths don't pre-push it. Bail rather than mishandle. */
            if (has_struct_arg && (is_fastcall || is_sdcccall1)) {
                free(args); free(arg_pushed_bytes);
                return build_fail("struct-by-value argument under fastcall / "
                                  "__sdcccall(1) not yet supported");
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
           strchr) have no callable library symbol — redirect to the real
           same-name/same-ABI library function, which the smallc lib
           provides; the prefix/ABI come from the (LIBRARY __smallc)
           builtin sym, so only the emitted name changes. */
        if (strncmp(n->sym->name, "__builtin_", 10) == 0) {
            const char *base = n->sym->name + 10;
            if (!strcmp(base, "memset") || !strcmp(base, "memcpy")
             || !strcmp(base, "strcpy") || !strcmp(base, "strchr"))
                ci->target_name = base;
        }
        ci->fnptr_vreg = -1;
        ci->args       = args;
        ci->arg_pushed_bytes = arg_pushed_bytes;
        ci->n_args     = n_args;
        ci->ret_vreg   = ret_v;
        /* ABI is determined by ctype flags. SMALLC = L→R push (z88dk
           default); absence = STDC = R→L push (matches C standard).
           CALLEE wins regardless: callee pops its own args. FASTCALL
           overrides — last arg goes in HL/DEHL, rest pushed in ABI
           order. */
        uint32_t flags = n->sym->ctype ? n->sym->ctype->flags : 0;
        if ((flags & SDCCCALL1) && sc1_has_wide_double(n->sym->ctype)) {
            free(args); free(arg_pushed_bytes);
            return build_fail("__sdcccall(1) call needs 4-byte doubles for a "
                              "double param/return (build with -fp-mode=ieee "
                              "or --math-mbf32); current double is %d bytes",
                              c_fp_size);
        }
        if (is_fastcall) {
            ci->abi = IR_ABI_FASTCALL;
        } else if (flags & SDCCCALL1) {
            /* __sdcccall(1) cleanup is return-size dependent (SDCC
               isFuncCalleeStackCleanup): a 1-2 byte return is callee-cleaned
               (IR_ABI_CALLEE), a 4-byte/long return is caller-cleaned
               (IR_ABI_STDC). The stacked-remainder push order is STDC (R→L)
               either way — gen_call forces that for the SDCCCALL1 flag. */
            int rw = n->sym->ctype && n->sym->ctype->return_type
                   ? type_width(n->sym->ctype->return_type) : 2;
            ci->abi = (rw == 4) ? IR_ABI_STDC : IR_ABI_CALLEE;
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
           `call _name`. Args/cleanup/return stay the normal ABI. The
           rst/module/address operands aren't in the flags, so carry them
           as values. */
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
           is computed at runtime from `n->callee`. Fastcall fnptrs are
           handled in the lowerer (ix/iy when a spare index reg is free,
           else a pushed-retaddr `ret` dance). */
        if (!n->callee)
            return build_fail("AST_FUNCPTR_CALL without callee");
        Type *fntype = n->type; /* callfunction() stashes the FUNC
                                   type on the call node */
        uint32_t flags = fntype ? fntype->flags : 0;
        /* __sdcccall(1) via a function pointer: dispatched through the fastcall
           ix/iy / push+ret machinery — see gen_call. __far and wide-double sc1
           fnptrs are rejected: SDCC has no __far sc1, and a 6/8-byte double
           can't ride the 4-byte HLDE slot. */
        if ((flags & SDCCCALL1) && node_is_far_ptr(n->callee))
            return build_fail("__sdcccall(1) via a __far function pointer is not "
                              "supported");
        if ((flags & SDCCCALL1) && sc1_has_wide_double(fntype))
            return build_fail("__sdcccall(1) fnptr needs 4-byte doubles for a "
                              "double param/return (build with -fp-mode=ieee or "
                              "--math-mbf32); current double is %d bytes",
                              c_fp_size);
        /* Fastcall through a fnptr: when a spare index reg is free the fnptr
           rides it (ix/iy) while the arg occupies HL/DEHL; otherwise the
           lowerer pushes the fnptr and dispatches via pushed-retaddr + `ret`
           (covers idx2-off, reserved-index targets, 808x and gbz80). */
        int n_args = n->args ? (int)array_len(n->args) : 0;
        int *args = NULL;
        if (n_args > 0) {
            args = calloc(n_args, sizeof(int));
            for (int i = 0; i < n_args; i++) {
                Node *a = array_get_byindex(n->args, i);
                /* Struct/union by value → its address (z88dk by-reference
                   aggregate ABI; same as the direct-call path above). */
                int v = (a && a->type && a->type->kind == KIND_STRUCT)
                      ? agg_lvalue_addr(b, a)
                      : build_expr(b, a);
                if (v < 0) { free(args); return -1; }
                /* sc1/sdccdecl char arg: pass as ONE byte (not the smallc int
                   promotion) so the 1-byte push/slot align — as the direct path. */
                if ((flags & (SDCCDECL | SDCCCALL1)) && fntype && fntype->parameters) {
                    Type *pt = array_get_byindex(fntype->parameters, i);
                    if (pt && pt->kind == KIND_CHAR && b->f->vregs[v].width != 1) {
                        int t = new_temp_kind(b, KIND_CHAR);
                        Op *cv = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                        cv->dst = t; cv->src[0] = v;
                        v = t;
                    }
                }
                /* Widen narrow int args to the fnptr's prototyped param
                   width (long / long long) — same as the direct-call
                   path, else long params get corrupted through a fnptr. */
                if (fntype && fntype->parameters) {
                    Type *pt = array_get_byindex(fntype->parameters, i);
                    v = widen_arg_to_param(b, v, a, pt);
                }
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
           (l_farcall) rather than the near l_jphl, which would drop the
           bank and only do a near `jp (hl)`. */
        ci->far_fnptr  = node_is_far_ptr(n->callee);
        ci->args       = args;
        ci->n_args     = n_args;
        ci->ret_vreg   = ret_v;
        /* Carry the stack-layout calling conventions onto ci so gen_call sees
           them via `& bit` (other dispatch flags like SHORTCALL/BANKED can't
           apply to a fnptr — they need a fixed symbol). */
        ci->flags = flags & (SDCCCALL1 | SDCCDECL);
        if (flags & FASTCALL)      ci->abi = IR_ABI_FASTCALL;
        else if (flags & SDCCCALL1) {
            /* sc1 cleanup is return-size dependent (same as the direct path):
               1-2 byte return callee-cleaned, 4-byte caller-cleaned. */
            ci->abi = (ret_w == 4) ? IR_ABI_STDC : IR_ABI_CALLEE;
        }
        else if (flags & CALLEE)   ci->abi = IR_ABI_CALLEE;
        else if (flags & SMALLC)   ci->abi = IR_ABI_SMALLC;
        else                       ci->abi = IR_ABI_STDC;
        ci->is_variadic = (fntype && fntype->funcattrs.hasva) ? 1 : 0;
        op->call = ci;
        return ret_v;
    }

        case OP_CAST: return build_cast(b, n);

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

        /* Float / _Accum ++/-- : step by 1.0 in the value's type (not a raw
           integer inc of the bits). Load lvalue, decimal-step, store back,
           return old (post) / new (pre). Local + global lvalues. */
        {
            Kind lvk = n->operand->type ? n->operand->type->kind : KIND_NONE;
            int dec = is_acc_float_kind(lvk) || is_register_float_kind(lvk)
                   || lvk == KIND_ACCUM16 || lvk == KIND_ACCUM32;
            if (dec && n->operand->ast_type == AST_LOCAL_VAR && n->operand->sym) {
                int v = sym_map_get(b, n->operand->sym);
                if (v < 0) return build_fail("decimal step unknown local");
                int old = -1;
                if (is_post) {
                    old = new_temp_kind(b, lvk);
                    ir_emit_mov(cur_bb(b), old, v);
                }
                int stepped = emit_decimal_step(b, v, lvk, is_inc);
                if (stepped < 0) return build_fail("decimal step emit");
                ir_emit_mov(cur_bb(b), v, stepped);
                return is_post ? old : v;
            }
            if (dec && n->operand->ast_type == AST_GLOBAL_VAR && n->operand->sym) {
                SYMBOL *g = n->operand->sym;
                int x = new_temp_kind(b, lvk);
                Op *ld = ir_op_emit(cur_bb(b), IR_LD_MEM);
                ld->dst = x; ld->mem.kind = IR_MEM_SYM; ld->mem.sym = g; ld->mem.elem = lvk;
                int old = -1;
                if (is_post) {
                    old = new_temp_kind(b, lvk);
                    ir_emit_mov(cur_bb(b), old, x);
                }
                int stepped = emit_decimal_step(b, x, lvk, is_inc);
                if (stepped < 0) return build_fail("decimal step emit");
                Op *st = ir_op_emit(cur_bb(b), IR_ST_MEM);
                st->src[0] = stepped; st->mem.kind = IR_MEM_SYM; st->mem.sym = g; st->mem.elem = lvk;
                return is_post ? old : stepped;
            }
        }

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
            /* A scalar whose address escapes can be read/written through that
               pointer (aliasing). Force memory residency (treat like volatile)
               so every access goes through the slot — otherwise a cached or
               const-forwarded value survives an aliasing `*p = …` store:
               `long n; long *p=&n; n=10; *p+=31; return n;` returned the stale
               10. Aggregate locals are already memory-resident (the vreg holds
               a slot base, not a forwarded value), so leave them alone. */
            Kind lk = sym ? (Kind)sym->type : KIND_NONE;
            if (lk != KIND_ARRAY && lk != KIND_STRUCT)
                b->f->vregs[src].flags |= IR_VREG_VOLATILE;
            int dst = new_temp(b, 2);
            Op *op = ir_op_emit(cur_bb(b), IR_LEA);
            op->dst = dst;
            op->src[0] = src;
            return dst;
        }
        return build_fail("cannot take the address of a non-lvalue — `&` needs "
                          "a variable, *ptr, array element or struct member, not "
                          "an expression/rvalue (operand ast_type=%d; e.g. `&&x` "
                          "or a macro that already added `&`)",
                          n->operand ? (int)n->operand->ast_type : -1);

    case AST_TERNARY: {
        /* Ternary as expression: cond ? then_e : els_e, both arms
           produce values; mov each into a shared result vreg. */
        if (!n->cond || !n->then || !n->els)
            return build_fail("AST_TERNARY expr with missing arm");

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
        Kind rk = n->type ? (Kind)n->type->kind : KIND_INT;
        /* Reuse the caller's hint only when it ALREADY has the ternary's type.
           Stamping the hint's kind/width to the ternary type corrupts a live
           variable of a different type: `long v = c ? i-j : 0` passes v (long)
           as the hint, and re-typing it to the int ternary makes the arms store
           2 bytes into the 4-byte local — a later consistency pass restores v to
           long/width-4 while the arm binop keeps int operands, so the widened
           read aborts (register-only) or silently reads garbage. Fresh temp of
           the ternary's own type otherwise; the caller (build_assign) converges
           the width with a CONV. */
        int result;
        if (hint >= 0
            && b->f->vregs[hint].width == (int16_t)rw
            && (Kind)b->f->vregs[hint].kind == rk) {
            result = hint;
        } else {
            result = new_temp(b, rw);
            b->f->vregs[result].width = (int16_t)rw;
            b->f->vregs[result].kind  = rk;
        }

        /* Short-circuit the condition (arms produce the value). Targets are
           pre-created above so their ids stay above the test block. */
        if (build_cond(b, n->cond, then_bb, els_bb) != 0) return -1;

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

        /* _Accum (fixed) += / -=: integer add/sub of the Q-format reps, but the
           rhs literal must be scaled (`a += 2.5k` adds 640). Bitwise/shift on a
           fixed value fall to the integer path. */
        if ((n->ast_type == OP_AADD || n->ast_type == OP_ASUB)
            && n->left && n->left->type
            && kind_is_fixed(n->left->type->kind))
            return build_accum_compound(b, n, n->left->type->kind);

        return build_compound_int(b, n, k);
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
        /* _Accum (fixed) *= / /= via l_fix{16,32}_{mul,div}{s,u} (the integer
           l_mult/l_div would skip the Q-format shift). %= falls to integer. */
        if ((n->ast_type == OP_AMULT || n->ast_type == OP_ADIV)
            && n->left->type && kind_is_fixed(n->left->type->kind))
            return build_accum_compound(b, n, n->left->type->kind);
        return build_compound_muldiv(b, n);
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

        int result   = get_dest_vreg(b, hint, 2);
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

    case AST_ASM: {
        /* Inline asm used as an expression VALUE (a z88dk/BDS-C extension,
           e.g. bdscio.h's `#define sbrk(a) malloc(a)?asm("\n"):-1`). The asm
           leaves its result in the return register(s) — HL for width <= 2,
           DEHL for width 4 — exactly like a function-call return. The width
           follows the consuming context: the caller's hint when present,
           else the node's resolved type, else int. A width-4 (long/pointer)
           context trusts DEHL as the asm left it — NO HL->DEHL widening (the
           asm is responsible for filling the high half). */
        int w = (hint >= 0) ? b->f->vregs[hint].width
              : (n->type ? type_width(n->type) : 2);
        if (w != 1 && w != 2 && w != 4) w = 2;
        int dst = new_temp(b, w);
        b->f->vregs[dst].width = (int16_t)w;
        Op *op = ir_op_emit(cur_bb(b), IR_ASM);
        op->asm_text = n->labelname;
        op->dst = dst;
        return dst;
    }

    default:
        return build_fail("unsupported expr ast_type=%d", (int)n->ast_type);
    }
}

/* ----- Statement builder ----------------------------------------------- */

/* A __naked function body may contain ONLY asm — no prologue/epilogue/frame
   is generated, so any C statement would have no frame to run against.
   True iff `n` is a bare asm block, or a compound of nothing but asm blocks.
   An empty body is vacuously asm-only (emits nothing). */
/* Integer-family binop/compare — the residual after the fixed/float/long
   long guards: operand-type-aware compare signedness, literal-operand
   swap, and the generic IR_x emit (get_dest_vreg uses the hint to write the
   result into the caller's target slot). */
/* Integer mul/div/mod residual (after the fixed/double/long long guards):
   operand build + width convergence, constant-multiply strength reduction,
   and the helper emit. Also lands the same-kind register-float (f16/f32)
   case that build_muldiv_float deliberately falls through (the helper-
   select below keys on is_flt/flt_k), hence the flags are recomputed. */
/* Convert the operand to the cast type — a sequence of src/dst family
   interceptions (some chain, e.g. _Accum->char does _Accum->int then
   int->char), ending in the generic int resize. */
/* LHS = RHS store. Dispatches by destination: bitfield (read-modify-
   write), whole-aggregate struct copy, bare local, global, pointer
   deref — each with int/float/double/_Accum/long long value handling. */
static int build_assign(Builder *b, Node *n)
{
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
            int v = build_expr(b, n->right);
            if (v < 0) return -1;
            int uns = n->right->type && n->right->type->isunsigned;
            return emit_bitfield_store(b, n->left, bft, v, uns);
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
    /* Any pointer/array-to-_Accum address LHS: `*p` (OP_DEREF), `a[i]`
       (OP_ADD address, type KIND_PTR) AND a global _Accum array index
       (type KIND_ARRAY, element in ->ptr). Without these, `acc_arr[i] = 5`
       built the int literal unscaled (no _Accum hint) and stored the raw
       integer — reading back ~0. */
    if (n->left->type
        && (n->left->type->kind == KIND_PTR
            || n->left->type->kind == KIND_ARRAY)
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
            /* Wide float/double element (`double a[N]; a[0] = x;`): build the
               RHS as a float (converting an int RHS to the element's format)
               and store via IR_ST_MEM's acc path. The integer LEA+ST_MEM
               below would CONV_TRUNC the float to garbage / bail on width 6. */
            if (is_acc_float_kind(elem_k)) {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                if (!is_acc_float_kind(node_value_kind(n->right)))
                    rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, elem_k);
                int faddr = new_temp(b, 2);
                Op *flea = ir_op_emit(cur_bb(b), IR_LEA);
                flea->dst = faddr; flea->src[0] = dst_v;
                Op *fst = ir_op_emit(cur_bb(b), IR_ST_MEM);
                fst->src[0]   = rhs_v;
                fst->mem.kind = IR_MEM_VREG;
                fst->mem.base = faddr;
                fst->mem.elem = elem_k;
                return rhs_v;
            }
            /* Register-float element (`_Float16 a[N]; a[0] = x;` or IEEE-32
               `float`): convert the RHS to the element's float format — an
               int RHS becomes the folded float constant, not raw int bits
               stored as if they were a float. The generic int path below
               stores the same-width RHS unconverted. */
            if (is_register_float_kind(elem_k)) {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                if (node_value_kind(n->right) != elem_k)
                    rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, elem_k);
                int faddr = new_temp(b, 2);
                Op *flea = ir_op_emit(cur_bb(b), IR_LEA);
                flea->dst = faddr; flea->src[0] = dst_v;
                Op *fst = ir_op_emit(cur_bb(b), IR_ST_MEM);
                fst->src[0]   = rhs_v;
                fst->mem.kind = IR_MEM_VREG;
                fst->mem.base = faddr;
                fst->mem.elem = elem_k;
                return rhs_v;
            }
            /* Wide long long element (`long long a[N]; a[0] = x;`): widen the
               RHS into the i64 acc and store via IR_ST_MEM's l_i64_store path
               (mirrors the indexed `arr[i] = <long long>` and `*p = <long
               long>` stores, which already route here). */
            if (is_acc_int_kind(elem_k)) {
                int rhs_v = build_expr(b, n->right);
                if (rhs_v < 0) return -1;
                rhs_v = promote_to_acc_int(b, rhs_v,
                            n->right && n->right->type
                            && n->right->type->isunsigned);
                if (rhs_v < 0) return -1;
                int laddr = new_temp(b, 2);
                Op *llea = ir_op_emit(cur_bb(b), IR_LEA);
                llea->dst = laddr; llea->src[0] = dst_v;
                Op *lst = ir_op_emit(cur_bb(b), IR_ST_MEM);
                lst->src[0]   = rhs_v;
                lst->mem.kind = IR_MEM_VREG;
                lst->mem.base = laddr;
                lst->mem.elem = KIND_LONGLONG;
                return rhs_v;
            }
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
        /* Float/double RHS into an integer local (`int i = dbl;`): convert
           float→int first, then store. Without this the 6-byte double
           reaches the byte/general paths below and gets a plain CONV_TRUNC
           (bail at 6→1, garbage at 6→2/4). */
        if (kind_is_integer(lk) && !is_acc_int_kind(lk)
            && n->right && is_acc_float_kind(node_value_kind(n->right))) {
            int rv = build_expr(b, n->right);
            if (rv < 0) return -1;
            rv = coerce_float_to_int_kind(b, rv, n->right, lk,
                                          b->f->vregs[dst_v].width);
            if (rv != dst_v) ir_emit_mov(cur_bb(b), dst_v, rv);
            return dst_v;
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
        /* Integer RHS into a float local: build WITHOUT the dst hint (so
           the int producer can't write its raw value into the float vreg),
           convert int→float, then move. */
        Kind ldst_k = n->left->type ? n->left->type->kind : KIND_NONE;
        if (is_acc_float_kind(ldst_k) || is_register_float_kind(ldst_k)
            || ldst_k == KIND_ACCUM16 || ldst_k == KIND_ACCUM32) {
            int rv = build_expr(b, n->right);
            if (rv < 0) return -1;
            rv = coerce_int_to_float_kind(b, rv, n->right, ldst_k);
            if (rv != dst_v) ir_emit_mov(cur_bb(b), dst_v, rv);
            return dst_v;
        }
        /* Pass dst_v as hint: the RHS writes into it directly when
           it can (skipping the MOV), else returns another vreg we
           copy. The hint vreg's kind also drives literal-to-_Accum
           scaling in the AST_LITERAL handler. */
        int rhs_v = build_expr_hinted(b, n->right, dst_v);
        if (rhs_v < 0) return -1;
        if (rhs_v != dst_v) {
            /* Converge width before the copy: build_expr_hinted may return a
               vreg NARROWER than the integer local (a plain int variable, or a
               const-multiply strength-reduce result, assigned to a `long`). A
               bare MOV would leave the high bytes unset — garbage, or a
               register-only source aborting in load_to_dehl. Sign/zero-extend
               (long long via the accumulator) — mirrors the global store path. */
            int rhs_w = b->f->vregs[rhs_v].width;
            if (rhs_w != ldst_w && is_acc_int_kind(lk)) {
                rhs_v = promote_to_acc_int(b, rhs_v,
                            n->right && n->right->type
                            && n->right->type->isunsigned);
                if (rhs_v < 0) return -1;
            } else if (rhs_w != ldst_w && (ldst_w == 2 || ldst_w == 4)) {
                OpKind cv = (rhs_w > ldst_w)
                    ? IR_CONV_TRUNC
                    : (n->right->type && n->right->type->isunsigned
                       ? IR_CONV_ZX : IR_CONV_SX);
                Op *op = ir_op_emit(cur_bb(b), cv);
                op->dst = dst_v; op->src[0] = rhs_v;
                return dst_v;
            }
            if (rhs_v != dst_v)
                ir_emit_mov(cur_bb(b), dst_v, rhs_v);
        }
        return dst_v;
    }
    /* Non-local LHS: for a float-literal RHS heading into an
       _Accum slot, allocate a typed hint vreg so the literal
       handler's scaling fires. */
    int rhs_hint = -1;
    if (dst_accum != KIND_NONE
        && n->right && n->right->ast_type == AST_LITERAL) {
        rhs_hint = new_temp_kind(b, dst_accum);
    }
    int rhs_v = (rhs_hint >= 0)
              ? build_expr_hinted(b, n->right, rhs_hint)
              : build_expr(b, n->right);
    if (rhs_v < 0) return -1;
    /* Non-literal int RHS into an _Accum lvalue (`acc_arr[i] = intvar`):
       scale it to fixed-point. The hint above only scales LITERALS; a
       variable needs the runtime int→_Accum conversion, and the coerce
       below keys off n->left->type (KIND_PTR/ARRAY for an indexed store,
       not the _Accum kind) so it would miss. No-op if already _Accum. */
    if (dst_accum != KIND_NONE && rhs_hint < 0) {
        rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, dst_accum);
        if (rhs_v < 0) return -1;
    }
    /* Storing an integer into a float lvalue: convert int→float (the front
       end no longer inserts the cast). Derive the destination float kind from
       the LHS type, unwrapping a folded array/index shape (`f16_arr[0] = 100`
       leaves n->left->type as KIND_ARRAY, its element in ->ptr) — a deref `*p`
       already carries the element kind directly. n->type is unreliable here:
       for a deref store it is the RHS (int) type, which would suppress the
       conversion and store the raw integer bits. */
    {
        Kind ldk = n->left->type ? n->left->type->kind : KIND_NONE;
        /* Only a folded bare register-float array (`f16_arr[0] = 100` /
           `f32_arr[0] = 100`, n->left is the bare array var) needs unwrapping
           to the element here. _Accum / acc-double arrays are already scaled
           by the dst_accum path above (unwrapping them would double-convert),
           and a deref `*p` carries its pointee kind with its own store-side
           conversion. */
        if (ldk == KIND_ARRAY && n->left->type->ptr
            && is_register_float_kind(n->left->type->ptr->kind))
            ldk = n->left->type->ptr->kind;
        rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, ldk);
    }
    /* Symmetric: storing a float/double into an integer lvalue
       (`arr[k] = dbl;`, `g = dbl;`). Convert float→long here; the
       per-shape width-coercion below narrows to the element/global width.
       Without it the raw double reaches CONV_TRUNC (bail/garbage). */
    {
        /* The stored value's type is the assign node's own type (n->type)
           — reliable even when the parser folds `g.member = X` /
           `arr[k] = X` to a bare-global / address shape whose lvalue type
           is a pointer/array/struct (same reason the global path below
           keys elem_w off n->type). Deriving from n->left->type would
           read a folded double-member ADDRESS as an integer and wrongly
           convert (ifix) a double→double member store. */
        Kind store_k = n->type ? n->type->kind : KIND_NONE;
        if ((store_k == KIND_PTR || store_k == KIND_ARRAY) && n->type->ptr)
            store_k = n->type->ptr->kind;
        if (is_acc_float_kind(node_value_kind(n->right))
            && kind_is_integer(store_k) && !is_acc_int_kind(store_k))
            rhs_v = emit_acc_to_int(b, rhs_v, 4);
    }
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
        if (n->type && is_register_int_kind(n->type->kind)) {
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
        /* For an aggregate global (`ll_arr[0] = x`, `g.d = x`) the wide-
           element decision keys off the element/value type, not the
           array/struct kind itself (gk == KIND_ARRAY/STRUCT carries no
           width). n->type is the stored-value (element) type. */
        Kind wk = gk;
        if ((gk == KIND_ARRAY || gk == KIND_STRUCT) && n->type)
            wk = n->type->kind;
        if (is_acc_float_kind(wk)) {
            /* Wide double global store via dstore (elem=KIND_DOUBLE);
               rhs is already the width-c_fp_size value. */
            Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
            op->src[0]   = rhs_v;
            op->mem.kind = IR_MEM_SYM;
            op->mem.sym  = n->left->sym;
            op->mem.elem = KIND_DOUBLE;
            return rhs_v;
        }
        if (is_acc_int_kind(wk)) {
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
           Deriving elem_w purely from n->left truncates long stores to
           int for the chained-assign / member-store shape, where the
           parser records the scalar value type. */
        int elem_w = 0;
        if (n->type && is_register_int_kind(n->type->kind))
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
                /* `*p = X` wide double store via dstore. Coerce an INTEGER
                   rhs to the acc-double (`*p = 5` → 5.0): without it the raw
                   int vreg is dstore'd as garbage. No-op when already a
                   double. */
                rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, dk);
                if (rhs_v < 0) return -1;
                Op *op = ir_op_emit(cur_bb(b), IR_ST_MEM);
                op->src[0]   = rhs_v;
                op->mem.kind = IR_MEM_VREG;
                op->mem.base = ptr_v;
                op->mem.elem = KIND_DOUBLE;
                op->mem.bank_fn = bf;
                return rhs_v;
            }
            /* Register-float element: a plain 2-byte (f16) or 4-byte (f32)
               DEHL value — store the whole element. n->type can read back as
               int for the member shape (elem_w=2 above), which would truncate;
               force the float width. Coerce an INTEGER rhs to the float format
               (`*p = 5` → 5.0): the raw int vreg stored as float bits is a
               denormal (~0) / garbage, not 5.0. No-op when rhs is already that
               float kind. */
            if (dk == KIND_DOUBLE || dk == KIND_FLOAT || dk == KIND_FLOAT16) {
                elem_w = (dk == KIND_FLOAT16) ? 2 : 4;
                rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, dk);
                if (rhs_v < 0) return -1;
            }
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
       fusion, fp mode is a net win on md5 so fp ungates; sp still
       trails (the per-input-byte copy loop's slot walks), so sp
       stays gated until that flips too. */
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
            || is_register_int_kind(n->left->type->kind))
        && (n->left->type->ptr
            || is_register_int_kind(n->left->type->kind))) {
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
            /* A double/ll *array* lvalue reads back as KIND_ARRAY/KIND_PTR
               with the element float/ll kind on ->ptr, and n->type can be
               int (`da[i] = 100`). Follow the pointee so the coercion below
               fires — else the raw int is stored into the wide slot. */
            if (vk == KIND_NONE && n->left->type
                && (n->left->type->kind == KIND_PTR
                    || n->left->type->kind == KIND_ARRAY)
                && n->left->type->ptr
                && (kind_is_floating(n->left->type->ptr->kind)
                    || n->left->type->ptr->kind == KIND_LONGLONG))
                vk = n->left->type->ptr->kind;
            if (is_acc_float_kind(vk) || vk == KIND_DOUBLE
                || vk == KIND_FLOAT) {
                /* Coerce an INTEGER rhs to the float kind (`o[i] = 0` →
                   0.0): without it the raw int vreg (width 2) is stored as
                   the 4-byte value, writing only 2 bytes and leaving the
                   double's high half stale. No-op when rhs is already that
                   float kind (`o[i] = 1.0`). */
                rhs_v = coerce_int_to_float_kind(b, rhs_v, n->right, vk);
                if (rhs_v < 0) return -1;
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
        if (n->type && is_register_int_kind(n->type->kind))
            elem_w = type_width(n->type);
        if (elem_w == 0 && n->left->type->ptr)
            elem_w = type_width(n->left->type->ptr);
        if (elem_w == 0 && is_register_int_kind(n->left->type->kind))
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
    return build_fail("OP_ASSIGN LHS shape not yet supported");
}

static int build_cast(Builder *b, Node *n)
{
    /* (cast T expr): convert expr's width to T's width. Operand
       width comes from operand->type; dst width from node->type. */
    if (!n->operand)
        return build_fail("OP_CAST without operand");
    int src_w = type_width(n->operand->type);
    int dst_w = type_width(n->type);
    /* A fnptr-call operand keeps its KIND_FUNC type (direct calls are
       unwrapped to the return type by normalize_types, indirect ones are
       not) — type_width(FUNC) is meaningless, so take the return type's
       width. Without this the ll→int narrow below never fires for
       `(int)fnptr(...)` and the truncated result is left unloaded. */
    if ((n->operand->ast_type == AST_FUNCPTR_CALL
      || n->operand->ast_type == AST_FUNC_CALL)
        && n->operand->type && n->operand->type->kind == KIND_FUNC
        && n->operand->type->return_type)
        src_w = type_width(n->operand->type->return_type);
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
                int dst = new_temp_kind(b, KIND_LONG);
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
    Kind src_k = node_value_kind(n->operand);   /* unwraps a fnptr call's KIND_FUNC */
    Kind dst_k = n->type ? n->type->kind : KIND_NONE;
    /* Literal → _Accum: fold the Q-format scaling into the
       IR_LD_IMM at IR-build time. Bypasses the build_expr
       dance — same value goes straight to the right vreg. */
    if (n->operand->ast_type == AST_LITERAL
        && (dst_k == KIND_ACCUM16 || dst_k == KIND_ACCUM32)) {
        int v = new_temp_kind(b, dst_k);
        ir_emit_ld_imm(cur_bb(b), v,
                       scale_literal_for_kind(n->operand, dst_k));
        return v;
    }
    int src_v = build_expr(b, n->operand);
    if (src_v < 0) return -1;
    /* A KIND_FUNC src_k is a stale type propagated up from a fnptr-call
       operand (the call node keeps KIND_FUNC and any parent expr — a
       shift, an arith op — inherits it). The built vreg carries the real
       kind/width, so trust it; otherwise the ll/double→int narrow below
       never fires and the converted value is left unloaded. */
    if (src_k == KIND_FUNC) {
        Kind vk = (Kind)b->f->vregs[src_v].kind;
        int  vw = b->f->vregs[src_v].width;
        if (vk == KIND_LONGLONG || vk == KIND_DOUBLE) src_k = vk;
        else if (vw == 8) src_k = KIND_LONGLONG;
        if (vw > 0) src_w = vw;
    }
    /* integer → _Accum: l_fix16_{s,u}{char,int,long}2f or
       l_fix32_{s,u}{int,long}2f. Source goes through HL (the
       fix16 helpers operate on HL only, so width-4 sources are
       pre-truncated); the fix32 helpers expect HL on entry and
       produce DEHL on exit. */
    if (!kind_is_decimal(src_k)
        && (dst_k == KIND_ACCUM16 || dst_k == KIND_ACCUM32)) {
        if (b->f->vregs[src_v].width == 4) {
            int tmp = new_temp_kind(b, KIND_INT);
            Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
            tr->dst = tmp; tr->src[0] = src_v;
            src_v = tmp;
        }
        int src_unsigned = n->operand->type
                        && n->operand->type->isunsigned;
        const char *helper;
        if (dst_k == KIND_ACCUM32) {
            helper = src_unsigned ? "l_fix32_uint2f"
                                  : "l_fix32_sint2f";
        } else {
            helper = src_unsigned ? "l_fix16_uint2f"
                                  : "l_fix16_sint2f";
        }
        int conv_v = new_temp_kind(b, dst_k);
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
           Helpers don't exist in libsrc yet — emitted regardless. */
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
    /* register-float (f16/f32) ↔ _Accum16: DIRECT l_f{16,32}_ftofix16{s,u} /
       l_f{16,32}_fix16tof. Must precede the generic float↔int branches below —
       _Accum is not kind_is_floating, so those would treat it as an int and
       pick l_f16_f2sint (drops the fraction, and is undefined in the lib). */
    if (is_register_float_kind(src_k) && dst_k == KIND_ACCUM16) {
        int uns = n->type && n->type->isunsigned;
        int c = emit_fix_from_float(b, src_v, src_k, uns);
        if (c >= 0) return c;
    }
    if (src_k == KIND_ACCUM16 && is_register_float_kind(dst_k)) {
        int c = emit_float_from_fix(b, src_v, dst_k);
        if (c >= 0) return c;
    }
    /* int/long → float: l_f{16,32}_{s,u}{int,long}2f. The int2f
       helpers take HL (int) / DEHL (long), not a bare byte — widen a
       char source to int first (by its own signedness). Result width
       is the float's (2 for f16, 4 for f32). _Accum src is excluded
       (handled by the fixed↔float branch above / l_fix16_fix16tof). */
    if (!kind_is_floating(src_k) && !is_acc_int_kind(src_k)
        && !kind_is_fixed(src_k)
        && is_register_float_kind(dst_k)) {
        int uns = n->operand->type && n->operand->type->isunsigned;
        if (b->f->vregs[src_v].width == 1) {
            int wtmp = new_temp_kind(b, KIND_INT);
            Op *cv = ir_op_emit(cur_bb(b),
                                uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = wtmp; cv->src[0] = src_v;
            src_v = wtmp;
        }
        int sw = b->f->vregs[src_v].width;
        const char *helper = float_helper(dst_k, (sw == 4)
            ? (uns ? "ulong2f" : "slong2f")
            : (uns ? "uint2f"  : "sint2f"));
        int conv_v = new_temp_kind(b, dst_k);
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
       register-tier ll<->float path not yet built), so exclude it
       (build_fail). */
    if (is_register_float_kind(src_k) && !kind_is_floating(dst_k)
        && !is_acc_int_kind(dst_k) && !kind_is_fixed(dst_k)) {
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
            int bt = new_temp_kind(b, KIND_CHAR);
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
            int wt = new_temp_kind(b, KIND_INT);
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
            int bt = new_temp_kind(b, KIND_CHAR);
            Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
            tr->dst = bt; tr->src[0] = iv;
            return bt;
        }
        return iv;
    }
    /* int/char/long → long long (l_i64_{s,u}{int,long}2i64). char
       source is widened to int first (the helpers take HL/DEHL).
       Excludes a long long source: a ll↔ull cast is a same-width
       signedness reinterpret (handled by the src_w==dst_w no-op below),
       not an int2i64 conversion — feeding the already-width-8 value to
       l_i64_{u,s}int2i64 would re-extend only its low 16 bits. */
    if (!kind_is_floating(src_k) && !is_acc_int_kind(src_k)
        && is_acc_int_kind(dst_k)) {
        int uns = n->operand->type && n->operand->type->isunsigned;
        if (b->f->vregs[src_v].width == 1) {
            int wt = new_temp_kind(b, KIND_INT);
            Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = wt; cv->src[0] = src_v;
            src_v = wt;
        }
        return emit_acc_int_from_int(b, src_v, uns);
    }
    /* long long → int/long via l_i64_s64_toi32 (truncates to DEHL; HL
       for an int dst, DEHL for long). A char dst narrows further.
       Excludes a long long dst (ll↔ull): that is the same-width
       reinterpret handled by the src_w==dst_w no-op below. */
    if (is_acc_int_kind(src_k)) {
        /* long long → int/char: __i64_acc → HL/DEHL, narrow to a byte if the
           dst is char. (ll → ll same-width reinterpret falls through to the
           no-op below.) */
        if (!kind_is_floating(dst_k) && !is_acc_int_kind(dst_k)) {
            int iv = emit_acc_int_to_int(b, src_v, (dst_w == 4) ? 4 : 2);
            if (dst_w == 1) {
                int bt = new_temp_kind(b, KIND_CHAR);
                Op *tr = ir_op_emit(cur_bb(b), IR_CONV_TRUNC);
                tr->dst = bt; tr->src[0] = iv;
                return bt;
            }
            return iv;
        }
        /* long long → 5/6/8-byte double (sllong2f/ullong2f): __i64_acc → FA,
           signedness from the ll source. */
        if (is_acc_float_kind(dst_k)) {
            int uns = n->operand->type && n->operand->type->isunsigned;
            return emit_acc_lldouble(b, src_v, /*to_double=*/1, uns);
        }
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
        int dst = new_temp_kind(b, KIND_DOUBLE);
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
        int dst = new_temp_kind(b, KIND_LONGLONG);
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
        int dst = new_temp_kind(b, KIND_DOUBLE);
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
        int dst = new_temp_kind(b, KIND_FLOAT16);
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
        int dst = new_temp_kind(b, KIND_DOUBLE);
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
        int dst = new_temp_kind(b, KIND_FLOAT16);
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
        int dst = new_temp_kind(b, KIND_CPTR);
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
        int dst = new_temp_kind(b, KIND_LONG);
        Op *op = ir_op_emit(cur_bb(b),
                            unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
        op->dst    = dst;
        op->src[0] = src_v;
        return dst;
    }
    if (src_w == 2 && dst_w == 1) {
        int dst = new_temp_kind(b, KIND_CHAR);
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

/* Emit a native hardware multiply op: dst(width) = l * r. imm carries the
   unsigned flag (1=unsigned, 0=signed); the lowerer selects 8x8 vs 16x16 from
   the operand vreg width. Only called under the CPU/width guards below. */
static int emit_ir_mul(Builder *b, int l, int r, int width, int unsigned_op)
{
    int dst = new_temp(b, width);
    b->f->vregs[dst].width = (int16_t)width;
    Op *op = ir_op_emit(cur_bb(b), IR_MUL);
    op->dst = dst; op->src[0] = l; op->src[1] = r;
    op->imm = unsigned_op ? 1 : 0;
    return dst;
}

/* Narrowing-multiply source: if `nd` is an unsigned value that fits in 16 bits
   (possibly widened to a long by explicit casts, e.g. `(unsigned long)a`), return
   the ≤16-bit unsigned sub-expression to build in its place; else NULL. Peels
   widening unsigned casts (cast source lives in ->operand). A signed source is
   rejected — `(unsigned long)(int x)` for x<0 is a large 32-bit value, not a u16;
   a truncating cast (`(unsigned short)long_expr`) stops the peel and its u16 result
   is itself a valid narrow operand. */
static Node *mul_u16_narrow_src(Node *nd)
{
    Node *cur = nd;
    while (cur && cur->ast_type == OP_CAST && cur->operand && cur->operand->type
           && cur->type && cur->type->isunsigned
           && type_width(cur->type) >= type_width(cur->operand->type))
        cur = cur->operand;
    if (cur && cur->type && cur->type->isunsigned && type_width(cur->type) <= 2)
        return cur;
    return NULL;
}

/* Zero-extend a ≤16-bit unsigned operand vreg to exactly width 2 (a char u8
   widens to u16 for the 16x16 helper's HL/DE arg). */
static int widen_u16_to_int(Builder *b, int v)
{
    if (v < 0 || b->f->vregs[v].width >= 2) return v;
    int t = new_temp(b, 2);
    b->f->vregs[t].width = 2;
    Op *cv = ir_op_emit(cur_bb(b), IR_CONV_ZX);
    cv->dst = t; cv->src[0] = v;
    return t;
}

static int build_muldiv_integer(Builder *b, Node *n)
{
    Kind lk = n->left  && n->left->type  ? n->left->type->kind  : KIND_NONE;
    Kind rk = n->right && n->right->type ? n->right->type->kind : KIND_NONE;
    int is_fix16 = (lk == KIND_ACCUM16 || rk == KIND_ACCUM16);
    int is_fix32 = (lk == KIND_ACCUM32 || rk == KIND_ACCUM32);
    Kind flt_k   = lk;
    int is_flt   = kind_is_floating(lk) || kind_is_floating(rk)
                || (n->type && kind_is_floating(n->type->kind));
    /* Narrowing multiply: `(unsigned long)u16 * u16` → the 16x16→32 helper
       l_mulu_32_16x16 (dehl = hl * de) instead of widening both operands to 32
       bits for l_long_mult_u. The canonical helper dispatches to native hardware
       multiply on z180/ez80/z80n/kc160/rabbit and the size/speed loop on z80.
       Unsigned only (no signed 16x16→32 helper). Checked before building the
       operands so the wide casts are never emitted (no double-evaluation).
       IR_NO_NARROW_MUL opts out. */
    if (n->ast_type == OP_MULT && !is_flt && !is_fix16 && !is_fix32
        && n->type && type_width(n->type) == 4
        && !IS_808x() && !IS_GBZ80()   /* l_mulu_32_16x16 undefined there */
        && !getenv("IR_NO_NARROW_MUL")) {
        Node *ln = mul_u16_narrow_src(n->left);   /* type width <= 2, unsigned */
        Node *rn = mul_u16_narrow_src(n->right);
        if (ln && rn) {
            int lv = build_expr(b, ln);
            if (lv < 0) return -1;
            int rv = build_expr(b, rn);
            if (rv < 0) return -1;
            lv = widen_u16_to_int(b, lv);         /* u8 -> u16 for HL/DE */
            rv = widen_u16_to_int(b, rv);
            int dst = new_temp(b, 4);
            b->f->vregs[dst].width = 4;
            Op *op = ir_op_emit(cur_bb(b), IR_HCALL);
            op->dst = dst;
            HelperInfo *hi = calloc(1, sizeof(HelperInfo));
            int *args = calloc(2, sizeof(int));
            args[0] = lv; args[1] = rv;   /* HL, DE (multiply is commutative) */
            hi->name = "l_mulu_32_16x16";
            hi->args = args; hi->n_args = 2; hi->n_stacked = 0;
            hi->ret_vreg = dst; hi->ret_in_de = 0;
            op->hcall = hi;
            return dst;
        }
    }
    int l = build_expr(b, n->left);
    if (l < 0) return -1;
    int r = build_expr(b, n->right);
    if (r < 0) return -1;
    /* Hardware char*char multiply — matched BEFORE the int promotion so the
       operands stay bytes for the 8x8 hardware multiply. kc160 has signed and
       unsigned 8x8 (mul/muls hl), so it takes any same-signedness char pair;
       z180/ez80/z80n have unsigned-only 8x8 (mlt / mul de), so unsigned char
       only (signed char falls through to the promotion + helper path). Mixed
       signedness falls through too (promotes each operand by its own sign). */
    if (n->ast_type == OP_MULT
        && b->f->vregs[l].width == 1 && b->f->vregs[r].width == 1) {
        int lu = n->left  && n->left->type  && n->left->type->isunsigned;
        int ru = n->right && n->right->type && n->right->type->isunsigned;
        if (IS_KC160() && lu == ru)
            return emit_ir_mul(b, l, r, 2, lu);
        if ((c_cpu == CPU_Z180 || IS_EZ80() || IS_Z80N()) && lu && ru)
            return emit_ir_mul(b, l, r, 2, 1);
    }
    int width = b->f->vregs[l].width;
    if (b->f->vregs[r].width > width) width = b->f->vregs[r].width;
    /* C integer promotion: mul/div/mod have no byte-width helper, so a
       char operand must widen to int (>=2) BEFORE the HCALL. Without this
       floor two char operands share width 1, skip the conversion below,
       and reach l_div/l_mult as bytes — gen_hcall then zero-extends each
       (`ld h,0`), silently dropping the sign of a signed char (`-100/7`
       became 156/7). */
    if (width < 2) width = 2;
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
    /* Constant-multiply strength reduction: x*C → shifts + add/sub for
       cheap C, replacing the l_mult/l_long_mult helper. Skipped on
       targets with a hardware multiply (Rabbit `mul`), which keep the
       helper. Integer width 2/4 only; one literal operand. */
    if (n->ast_type == OP_MULT
        && !IS_RABBIT()
        && (width == 2 || width == 4)) {
        Node *litn = (n->right && n->right->ast_type == AST_LITERAL) ? n->right
                   : (n->left  && n->left->ast_type  == AST_LITERAL) ? n->left
                   : NULL;
        if (litn) {
            int vv = (litn == n->right) ? l : r;  /* non-constant operand */
            int srd = emit_const_mult_sr(b, vv, (int64_t)litn->zval, width);
            if (srd >= 0) return srd;
        }
    }
    /* C arithmetic conversion: result is unsigned if either
       operand is unsigned. */
    int unsigned_op = (n->type && n->type->isunsigned)
        || (n->left  && n->left->type  && n->left->type->isunsigned)
        || (n->right && n->right->type && n->right->type->isunsigned);
    /* kc160: 16x16 int multiply is a single `mul de,hl` (low 16 bits are
       sign-agnostic, so the unsigned form serves signed and unsigned alike). */
    if (n->ast_type == OP_MULT && IS_KC160() && width == 2)
        return emit_ir_mul(b, l, r, 2, 1);
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
           libsrc yet — emitted regardless. */
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

static int build_binop_integer(Builder *b, Node *n, OpKind k, int hint)
{
    /* ---- integer family (the residual) ---------------------------- */

    /* Operand-type-aware compare dispatch. op_to_ir_binop maps
       OP_LT/LE/GT/GE to the signed variants unconditionally. C's
       usual arithmetic conversions promote `signed < unsigned` to
       unsigned-vs-unsigned at the same rank, so if either operand
       is unsigned the compare is unsigned (else `unsigned long < K`
       picks the signed S^V correction, wrong for bit-31-set values).
       EQ/NE are sign-independent (the byte XOR-OR chain doesn't
       care). */
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
        && rhs->type && is_register_int_kind(rhs->type->kind)
        && (int)type_width(rhs->type) <= 2
        && (!n->type || (int)type_width(n->type) <= 2)
        && (int64_t)lhs->zval >= -32768 && (int64_t)lhs->zval <= 65535) {
        int rv = build_expr(b, rhs);
        if (rv < 0) return -1;
        if (b->f->vregs[rv].width == 1) {
            int uns = !rhs->type || rhs->type->isunsigned;
            int wt = new_temp_kind(b, KIND_INT);
            Op *cv = ir_op_emit(cur_bb(b), uns ? IR_CONV_ZX : IR_CONV_SX);
            cv->dst = wt; cv->src[0] = rv;
            rv = wt;
        }
        int dst = get_dest_vreg(b, hint, 2);
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
            int dst = new_temp_kind(b, KIND_INT);
            Op *bh = ir_op_emit(cur_bb(b), IR_CONV_BYTE_TO_HIGH);
            bh->dst = dst;
            bh->src[0] = l;
            return dst;
        }
        int wtmp = new_temp_kind(b, KIND_INT);
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
    /* Arithmetic (signed) right shift marker for the emitted IR_SHR. A `>>`
       is arithmetic iff the shifted (left) operand is signed — the parser's
       OP_USHR/OP_SSHR split is unreliable across casts (#289), so read the
       LHS value type's signedness directly, exactly as the i64 path does. */
    Type *shift_lvt = node_value_type(n->left);
    int64_t shr_arith_bit = (k == IR_SHR && !(shift_lvt && shift_lvt->isunsigned))
                          ? IR_SHR_ARITH : 0;
    int is_ptrish = (n->type && (n->type->kind == KIND_PTR
                                 || n->type->kind == KIND_ARRAY))
                 || (lhs->type && (lhs->type->kind == KIND_PTR
                                   || lhs->type->kind == KIND_ARRAY));
    /* Byte compare against a byte-range constant: an unsigned char compared to a
       constant in [0,255] (`c == ' '`, `c >= 'a'`, `c <= 'z'`) stays a byte `cp`
       instead of widening c to int for a 16-bit compare — the C-promotion is
       value-preserving here, and a widened compare reloads/extends c per test
       (lexbench classify: ~7 instrs/test vs 2). All EQ/NE and unsigned relations:
       ULE/UGT are canonicalised below to `<K+1`/`>=K+1` at the kept byte width, so
       K<=254 folds to a byte ULT/UGE and K==255 constant-folds (`eff>=tmax`) — both
       correct. Unsigned LHS so the zero-extended value is exactly the byte. */
    int keep_byte_cmp = 0;
    if (is_cmp && width == 1 && rhs && rhs->ast_type == AST_LITERAL
        && lhs->type) {
        int64_t C = (int64_t)rhs->zval;
        if (lhs->type->isunsigned
            && C >= 0 && C <= 255
            && (k == IR_CMP_EQ  || k == IR_CMP_NE
                || k == IR_CMP_ULT || k == IR_CMP_UGE
                || k == IR_CMP_ULE || k == IR_CMP_UGT))
            keep_byte_cmp = 1;
        /* Signed char EQ/NE: byte-pattern equality is bias-free (a `cp K` sets Z
           iff the bytes match, sign-independent). Restrict to a printable-range
           constant [0,127] — a signed byte genuinely holds those values, and the
           existing byte-`cp` lowering already accepts [0,255], so no relational
           +128 bias path is needed. (Signed relational — `c < 0` — would need
           that bias; left widened.) Covers `char c == 'x'` for plain (signed by
           default) char, the common text-scan form. */
        else if (!lhs->type->isunsigned
                 && (k == IR_CMP_EQ || k == IR_CMP_NE)
                 && C >= 0 && C <= 127)
            keep_byte_cmp = 1;
        /* Signed char relational (`c < ' '`, `c >= '0'`): kept a byte and lowered
           with the +128 bias (`xor 0x80; cp K^0x80` → unsigned cp) instead of
           sign-extend + 16-bit compare. Const in the signed-char range [-128,127];
           `c REL 0` is taken by the sign-test path in the lowerer. */
        else if (!lhs->type->isunsigned
                 && (k == IR_CMP_LT || k == IR_CMP_GE
                     || k == IR_CMP_LE || k == IR_CMP_GT)
                 && C >= -128 && C <= 127)
            keep_byte_cmp = 1;
    }
    /* Widen the LHS to the RESULT width when the literal RHS or
       the expression type is wider than the LHS vreg. The
       commutative swap above moves literals to the RHS, so
       `0x01000100UL + i` arrives with l = i (width 2) and a LONG
       literal — else the add runs at 16 bits, truncating the
       constant to its low word. */
    if (!is_shift && !is_ptrish && !keep_byte_cmp
        && rhs && rhs->ast_type == AST_LITERAL) {
        int tw = width;
        if (rhs->type && is_register_int_kind(rhs->type->kind)
            && type_width(rhs->type) > tw)
            tw = type_width(rhs->type);
        if (n->type && is_register_int_kind(n->type->kind)
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
                int dst = get_dest_vreg(b, hint, 2);
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
        int dst = get_dest_vreg(b, hint, dst_w);
        Op *op = ir_op_emit(cur_bb(b), k);
        op->dst    = dst;
        op->src[0] = l;
        op->src[1] = -1;
        op->imm    = imm | shr_arith_bit;
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
    /* Pointer/array + integer: the address stays 16-bit, so the index is
       converged to the BASE width — a WIDER index (`arr[longvar]`) is TRUNCATED
       (not widened into the base, which would sign-extend the base pointer to a
       bogus 4-byte "address" then read a register-only DEHL as a 16-bit address:
       sp masks it, fp aborts), and a NARROWER index (`arr[char_c]`) is extended
       as before. CPTR is a genuine 4-byte far pointer, so its arithmetic keeps
       width 4 (excluded from is_ptrish). */
    if (is_ptrish && !is_shift && !is_cmp
        && b->f->vregs[r].width != width) {
        OpKind cvk;
        if (b->f->vregs[r].width > width)
            cvk = IR_CONV_TRUNC;
        else
            cvk = (!rhs->type || rhs->type->isunsigned)
                ? IR_CONV_ZX : IR_CONV_SX;
        int wtmp = new_temp(b, width);
        b->f->vregs[wtmp].width = (int16_t)width;
        Op *cv = ir_op_emit(cur_bb(b), cvk);
        cv->dst = wtmp; cv->src[0] = r;
        r = wtmp;
    }
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
    int dst = get_dest_vreg(b, hint, dst_w);
    Op *bop = ir_emit_binop(cur_bb(b), k, dst, l, r);
    if (shr_arith_bit) bop->imm |= shr_arith_bit;   /* variable-count signed >> */
    b->f->vregs[dst].width = (int16_t)dst_w;
    /* Pointer DIFFERENCE: `p - q` yields the element COUNT, not the
       byte difference — divide the IR_SUB result by sizeof(*p) when
       both operands are pointer-typed (KIND_PTR/CPTR/ARRAY). A
       power-of-2 element is a logical shift right (`srl;rr` ×log2,
       signedness per sccz80), else an l_div_u. */
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
                int dv = new_temp_kind(b, KIND_INT);
                int kimm = new_temp_kind(b, KIND_INT);
                ir_emit_ld_imm(cur_bb(b), kimm, elem);
                /* l_div_u computes DE/HL → HL with HL=divisor (elem),
                   DE=dividend (byte-diff); HCALL puts args[0] in HL,
                   args[1] in DE. */
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

/* ---- Control-context (short-circuit) condition lowering ----------------
   `build_cond(cond, true_bb, false_bb)` lowers a boolean condition feeding a
   branch into direct short-circuit jumps to true_bb / false_bb, instead of the
   value-context path (`build_expr` → 0/1 vreg → BR_ZERO), which materialises a
   boolean per operand of every `&&`/`||`. Control-context lowering emits one
   conditional branch per comparison (the lowerer then fuses CMP+branch) — the
   standard "jumping code" for booleans.

   These emit NO new BBs — every conditional branch targets the caller's
   pre-created true_bb/false_bb and the block ends with one BR, so the builder's
   BB-id order (forward edges → higher ids) is preserved. In an &&-chain every
   conditional exit goes to false_bb (dedup'd into one CFG successor by
   bb_add_succ); the final BR goes to true_bb — two distinct successors. `||`
   is the mirror. A polarity-flipped nested logical (`||` under `&&`, or vice
   versa) can't fall through in one block; it's handled as a value leaf
   (build_expr + branch), still short-circuiting the enclosing chain. */

static int emit_cond_false_exit(Builder *b, Node *n, int false_bb);
static int emit_cond_true_exit(Builder *b, Node *n, int true_bb);

/* Branch to false_bb when `n` is FALSE, else fall through — an && operand. */
static int emit_cond_false_exit(Builder *b, Node *n, int false_bb)
{
    if (!n) return build_fail("build_cond: null && operand");
    switch (n->ast_type) {
    case OP_ANDAND:
        if (!n->left || !n->right)
            return build_fail("OP_ANDAND with missing operand");
        if (emit_cond_false_exit(b, n->left, false_bb) != 0) return -1;
        return emit_cond_false_exit(b, n->right, false_bb);
    case OP_OROR: {
        /* Polarity-flipped nest (`||` under `&&`): `A || B` is FALSE iff both are
           false. Branch-lower via a "n is true" continuation so the leaves stay
           branch-fused (byte cp) rather than materialising boolean values. */
        if (!n->left || !n->right)
            return build_fail("OP_OROR with missing operand");
        int ft = ir_bb_new(b->f);
        if (emit_cond_true_exit(b, n->left, ft) != 0) return -1;      /* A true → ft */
        if (emit_cond_false_exit(b, n->right, false_bb) != 0) return -1; /* B false → false_bb */
        ir_emit_br(cur_bb(b), ft);                                    /* B true → ft */
        b->cur_bb_id = ft;
        return 0;
    }
    case OP_LNEG:   /* !x is false ⟺ x is true → x-true exits to false_bb */
        if (!n->operand) return build_fail("OP_LNEG with missing operand");
        return emit_cond_true_exit(b, n->operand, false_bb);
    default: {
        int v = build_expr(b, n);
        if (v < 0) return -1;
        ir_emit_br_zero(cur_bb(b), v, false_bb);
        return 0;
    }
    }
}

/* Branch to true_bb when `n` is TRUE, else fall through — an || operand. */
static int emit_cond_true_exit(Builder *b, Node *n, int true_bb)
{
    if (!n) return build_fail("build_cond: null || operand");
    switch (n->ast_type) {
    case OP_OROR:
        if (!n->left || !n->right)
            return build_fail("OP_OROR with missing operand");
        if (emit_cond_true_exit(b, n->left, true_bb) != 0) return -1;
        return emit_cond_true_exit(b, n->right, true_bb);
    case OP_ANDAND: {
        /* Polarity-flipped nest (`&&` under `||`, e.g. classify's
           `(c>='a'&&c<='z') || …`): `A && B` is TRUE iff both are true.
           Branch-lower via a "n is false" continuation so the leaves stay
           branch-fused (byte cp) rather than materialising boolean values. */
        if (!n->left || !n->right)
            return build_fail("OP_ANDAND with missing operand");
        int ft = ir_bb_new(b->f);
        if (emit_cond_false_exit(b, n->left, ft) != 0) return -1;     /* A false → ft */
        if (emit_cond_true_exit(b, n->right, true_bb) != 0) return -1;/* B true → true_bb */
        ir_emit_br(cur_bb(b), ft);                                    /* B false → ft */
        b->cur_bb_id = ft;
        return 0;
    }
    case OP_LNEG:   /* !x is true ⟺ x is false → x-false exits to true_bb */
        if (!n->operand) return build_fail("OP_LNEG with missing operand");
        return emit_cond_false_exit(b, n->operand, true_bb);
    default: {
        int v = build_expr(b, n);
        if (v < 0) return -1;
        ir_emit_br_cond(cur_bb(b), v, true_bb);
        return 0;
    }
    }
}

static int build_cond(Builder *b, Node *n, int true_bb, int false_bb)
{
    if (!n) return build_fail("build_cond: null condition");
    switch (n->ast_type) {
    case OP_ANDAND:
        if (emit_cond_false_exit(b, n, false_bb) != 0) return -1;
        ir_emit_br(cur_bb(b), true_bb);
        return 0;
    case OP_OROR:
        if (emit_cond_true_exit(b, n, true_bb) != 0) return -1;
        ir_emit_br(cur_bb(b), false_bb);
        return 0;
    case OP_LNEG:   /* !cond → branch with the targets swapped */
        if (!n->operand) return build_fail("OP_LNEG with missing operand");
        return build_cond(b, n->operand, false_bb, true_bb);
    default: {
        int v = build_expr(b, n);
        if (v < 0) return -1;
        ir_emit_br_zero(cur_bb(b), v, false_bb);
        ir_emit_br(cur_bb(b), true_bb);
        return 0;
    }
    }
}

static int build_stmt(Builder *b, Node *n)
{
    if (!n) return 0;

    /* Stamp source location on every op emitted for this stmt — the
       lowerer reads it to drive C_LINE / -cc emission. AST_COMPOUND_STMT
       recurses, so child stmts will override before their ops fire. */
    if (n->filename && n->line > 0) {
        ir_set_emit_loc(n->filename, n->line);
        cur_node_file = n->filename;   /* also for build_fail diagnostics */
        cur_node_line = n->line;
    }

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
            /* `return <float>;` from an integer function: convert float→int
               first (to the return type's width), so the byte/int widening
               below handles the ABI. Without it the raw double reached the
               return unconverted (garbage). */
            {
                Kind retk0 = b->ret_type ? b->ret_type->kind : KIND_NONE;
                if (kind_is_integer(retk0) && !is_acc_int_kind(retk0)
                    && is_acc_float_kind(node_value_kind(rv)))
                    v = coerce_float_to_int_kind(b, v, rv, retk0,
                                                 type_width(b->ret_type));
            }
            /* Widen byte retvals to int — z80 return ABI puts the
               value in HL even when the C return type is char. */
            if (b->f->vregs[v].width == 1) {
                int unsigned_src = rv->type && rv->type->isunsigned;
                int tmp = new_temp_kind(b, KIND_INT);
                Op *cv = ir_op_emit(cur_bb(b),
                                    unsigned_src ? IR_CONV_ZX : IR_CONV_SX);
                cv->dst = tmp; cv->src[0] = v;
                v = tmp;
            }
            /* `return <int>` from a float function: convert int→float. */
            Kind retk = b->ret_type ? b->ret_type->kind : KIND_NONE;
            if (is_acc_float_kind(retk) || is_register_float_kind(retk)) {
                v = coerce_int_to_float_kind(b, v, rv, retk);
            } else {
                /* Widen a narrower integer `return x;` to the declared return
                   width (int→long / int→long long). The front-end leaves the
                   implicit C conversion to codegen, else a long long returner
                   that `return`s an int produces only HL/2 bytes and the
                   caller reads the rest as garbage. widen_arg_to_param keys
                   off the SOURCE node's type vs the target Type. */
                v = widen_arg_to_param(b, v, rv, b->ret_type);
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
                /* `= {0}` / `= {}` : block-zero the whole slot — one IR_MEMSET
                   (unrolls small / `ldir` large) rather than per-element stores
                   that blow the budget on a big array-of-struct. */
                if (init_is_all_zero(n->declvar)
                    && (sz <= 8 || ir_inline_block_ops_ok())) {
                    int zc = new_temp_kind(b, KIND_INT);
                    ir_emit_ld_imm(cur_bb(b), zc, 0);
                    Op *ms = ir_op_emit(cur_bb(b), IR_MEMSET);
                    ms->dst = -1; ms->src[0] = base; ms->src[1] = zc;
                    ms->imm = sz;
                    return 0;
                }
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
        if (!is_register_int_kind(n->sym->type)
            && !is_register_float_kind(n->sym->type)
            && !is_acc_float_kind(n->sym->type)
            && !is_acc_int_kind(n->sym->type)
            && (Kind)n->sym->type != KIND_CPTR)   /* __far pointer local */
            return build_fail("AST_DECL: kind %d not yet supported (sym=%s)",
                              (int)n->sym->type, n->sym->name);
        int v = new_local_vreg(b, n->sym);
        if (n->declvar) {
            /* Float/double initialiser into an integer local (`int i = dbl;`,
               `char c = dbl;`): convert float→int first — the byte/int/long
               store paths below would otherwise CONV_TRUNC the raw 6-byte
               double (bail at 6→1, garbage else). */
            {
                Kind vk0 = (Kind)n->sym->type;
                if (kind_is_integer(vk0) && !is_acc_int_kind(vk0)
                    && is_acc_float_kind(node_value_kind(n->declvar))) {
                    int iv = build_expr(b, n->declvar);
                    if (iv < 0) return -1;
                    iv = coerce_float_to_int_kind(b, iv, n->declvar, vk0,
                                                  b->f->vregs[v].width);
                    if (iv != v) ir_emit_mov(cur_bb(b), v, iv);
                    return 0;
                }
            }
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
               reinterpret the integer's bytes as a wide value (garbage,
               e.g. `double d = i;`). Don't hint into v: v is wider than
               the register the init lands in. */
            Kind vk = (Kind)n->sym->type;
            if (is_acc_int_kind(vk) || is_acc_float_kind(vk)
                || is_register_float_kind(vk)
                || vk == KIND_ACCUM16 || vk == KIND_ACCUM32) {
                int init_v = build_expr(b, n->declvar);
                if (init_v < 0) return -1;
                Kind ik = b->f->vregs[init_v].kind;
                if (is_acc_int_kind(vk)) {
                    /* int → long long */
                    if (b->f->vregs[init_v].width <= 4 && !is_acc_int_kind(ik)) {
                        int uns = n->declvar->type && n->declvar->type->isunsigned;
                        if (b->f->vregs[init_v].width == 1) {
                            int wt = new_temp(b, 2); b->f->vregs[wt].width = 2;
                            Op *cv = ir_op_emit(cur_bb(b),
                                                uns ? IR_CONV_ZX : IR_CONV_SX);
                            cv->dst = wt; cv->src[0] = init_v; init_v = wt;
                        }
                        init_v = emit_acc_int_from_int(b, init_v, uns);
                        if (init_v < 0) return -1;
                    }
                } else {
                    /* int → float (acc or register tier); same-kind passthrough. */
                    init_v = coerce_int_to_float_kind(b, init_v, n->declvar, vk);
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
        int then_bb = ir_bb_new(b->f);
        int exit_bb = ir_bb_new(b->f);
        int els_bb  = n->els ? ir_bb_new(b->f) : exit_bb;

        /* Short-circuit control-context lowering: compound `&&`/`||` become
           direct branches to then_bb/els_bb (targets pre-created so their ids
           stay above the test block). build_cond creates no BBs. */
        if (build_cond(b, n->cond, then_bb, els_bb) != 0) return -1;

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

    case AST_ASM: {
        /* `asm("...")` / `__asm__` / `#asm` block. Pass the captured
           text through verbatim; the IR pipeline treats it as a full
           register/memory clobber (handled by the lowerer's IR_ASM emit
           + cache invalidations). */
        Op *op = ir_op_emit(cur_bb(b), IR_ASM);
        op->asm_text = n->labelname;
        return 0;
    }

    default: {
        /* Expression statement — every other node in statement position is
           an expression whose result is discarded (the parser only places
           expression nodes here). Function calls, assignments, compound
           assigns, inc/dec, casts, derefs all carry side effects; pure
           expressions (`a == b;`, `x + y;`, a bare var, `a ? b : c;`,
           `"foo";`, `42;`) are no-ops that leave a dead vreg DCE removes.
           A side-effecting subexpression (`arr[i++];`, `(a=f())==0;`)
           still fires. build_expr emits its own diagnostic for a node it
           genuinely cannot build, so a real gap is never silent. */
        int v = build_expr(b, n);
        return v < 0 ? -1 : 0;
    }
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
    f->cpu = (uint32_t)c_cpu;   /* one-hot CPU id; ir_match gates patterns on it */
    f->idx2_reg = ir_idx2_reg();
    f->idx3_reg = ir_idx3_reg();
    f->exx_reg  = ir_exx_reg();
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
    b.ret_type = (fn->ctype) ? fn->ctype->return_type : NULL;

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
       nothing to run against. Reject anything else with a hard error. */
    if (fn->ctype && (fn->ctype->flags & NAKED)) {
        f->is_naked = 1;
        if (!naked_body_is_asm_only(body)) {
            errorfmt_at(body ? body->filename : NULL,
                        body ? body->line : 0, 0,
                        "__naked function '%s' may contain only an asm block",
                        fn->name[0] ? fn->name : "?");
            builder_free(&b);
            ir_func_free(f);
            return 0;   /* error reported; abort this function */
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
    if (fn->ctype && fn->ctype->return_type)
        f->ret_width = type_width(fn->ctype->return_type);

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
    /* __sdcccall(1) callee: validate the supported subset (z80, <=2 params
       passed in A/HL + DE, 1-2 byte return). The register-passed params are
       captured from registers in emit_prologue and forced to spill slots
       below so the placement never has to juggle register homes. */
    int fn_sc1 = (f->flags & SDCCCALL1) != 0;
    if (fn_sc1 && !f->is_naked && sc1_has_wide_double(fn->ctype)) {
        builder_free(&b);
        ir_func_free(f);
        return build_fail("__sdcccall(1) needs 4-byte doubles for a double "
                          "param/return (build with -fp-mode=ieee or "
                          "--math-mbf32); current double is %d bytes", c_fp_size);
    }
    if (fn_sc1 && !f->is_naked) {
        int np = fn->ctype && fn->ctype->parameters
               ? (int)array_len(fn->ctype->parameters) : 0;
        int rw = fn->ctype && fn->ctype->return_type
               ? type_width(fn->ctype->return_type) : 0;
        int w0 = np >= 1 ? type_width(array_get_byindex(fn->ctype->parameters, 0)) : 0;
        int w1 = np >= 2 ? type_width(array_get_byindex(fn->ctype->parameters, 1)) : 0;
        /* register slots: 1st in A/HL/HLDE; 2nd in DE iff the 1st is A/HL and
           the 2nd is 2 bytes. Everything past those stacks (STDC layout). The
           A,L two-char combo and a non-register 1st (struct/wide) are still
           deferred. Stacked params: int/long only for now. */
        int r1_ok     = (w0 == 1 || w0 == 2 || w0 == 4);
        int snd_in_de = (np >= 2) && (w0 == 1 || w0 == 2) && (w1 == 2);
        int snd_in_l  = (np >= 2) && (w0 == 1) && (w1 == 1);  /* A,L two-char */
        int reg_count = (w0 == 4) ? 1 : (snd_in_de || snd_in_l) ? 2 : 1;
        int bad = (rw != 1 && rw != 2 && rw != 4) || !r1_ok;
        for (int i = 0; i < np && !bad; i++) {
            Type *pt = array_get_byindex(fn->ctype->parameters, i);
            int w = pt ? type_width(pt) : 0;
            if (pt && pt->kind == KIND_ELLIPSES) { bad = 1; break; }
            if (i >= reg_count && w != 1 && w != 2 && w != 4) bad = 1;  /* stacked: char/int/long */
        }
        if (bad) {
            builder_free(&b);
            ir_func_free(f);
            return build_fail("__sdcccall(1) function shape not yet supported "
                              "(1st char/int/long, 2nd char->L or int->DE, "
                              "extra args stacked as int/long, 1-2-4 byte "
                              "return; no struct/wide 1st)");
        }
    }
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
            /* struct/union by-value param: a struct-sized, address-taken vreg
               accessed IN PLACE in the caller's pushed arg area. ir_alloc marks
               it PARAM_IN_PLACE (no local slot, no prologue copy — so no double
               stack), slot_off resolves to the caller offset, and member access
               reuses the aggregate-local LEA+offset path. Do NOT set the sc1
               VOLATILE flag below (a struct is never a register arg; VOLATILE
               would force an unsupported prologue copy-in). */
            if ((Kind)psym->type == KIND_STRUCT) {
                int sz = psym->ctype ? psym->ctype->size : 0;
                if (sz <= 0 || sz > 32767) {
                    builder_free(&b);
                    ir_func_free(f);
                    return build_fail("struct-by-value param %s size %d "
                                      "unsupported", pt->name, sz);
                }
                int sv = ir_vreg_new(b.f, (int)psym->type, psym, IR_VREG_PARAM);
                b.f->vregs[sv].width  = (int16_t)sz;
                b.f->vregs[sv].flags |= IR_VREG_ADDR_TAKEN;
                sym_map_set(&b, psym, sv);
                continue;
            }
            if (!is_register_int_kind(psym->type)
                && !is_register_float_kind(psym->type)
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
            /* __sdcccall(1) register params arrive in A/HL/DE and are placed
               into their slots by emit_prologue; force a spill slot so the
               placement is a plain store (no register-home juggling). */
            if (fn_sc1)
                b.f->vregs[v].flags |= IR_VREG_VOLATILE;
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
    /* ir_lower has no build_fail of its own, so a lowering failure (nonzero
       return) would be a SILENT, undiagnosed fatal bail. Name it here.
       ir_lower prints its own `ir_lower: ...` reason above for the op. */
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
    /* A nonzero rc is fatal — the caller reports it and exits. If we got
       there without printing a reason, the failure was SILENT — surface it
       so unsupported shapes can't quietly degrade. Only fires on failure. */
    if (rc != 0 && !build_fail_emitted)
        fprintf(stderr, "ir_build: [%s] silent build failure "
                "(no diagnostic — please report)\n",
                fn && fn->name[0] ? fn->name : "?");
    return rc;
}
