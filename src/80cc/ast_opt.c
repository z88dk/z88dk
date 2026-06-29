/*
 *      sccz80 — AST optimization passes
 *
 *  Self-contained tree-rewrite passes that run between AST construction
 *  and any consumer (the print walker for validation, eventually a
 *  codegen walker).
 *
 *  Implemented passes (run in this order from ast_opt_run()):
 *    1. ast_fold_constants — replaces binary/unary operators over
 *       literal-only operands with a single AST_LITERAL.
 *    2. ast_simplify_algebraic — identity reductions: x+0 → x,
 *       x*1 → x, x*0 → 0, x-x → 0, etc. Runs after fold so e.g.
 *       (x+1)+0 first folds to (x+1) before the +0 identity fires.
 *    3. ast_dead_code — drops unreachable branches of `if (0)` /
 *       `if (1)`, ternary with constant cond, statements after an
 *       unconditional AST_JUMP / AST_RETURN within a compound.
 *
 *  Each pass mutates the tree in place. Replaced sub-trees are leaked
 *  (acceptable for compilation lifetime). Side-effecting ops
 *  (assignments, pre/post-step) are never folded or rewritten away.
 */

#include "ccdefs.h"
#include "define.h"
#include "ast_iter.h"

extern Node *ast_literal(Type *type, zdouble value);

static int try_fold_unop(int kind, int64_t v, int64_t *out)
{
    switch (kind) {
    case OP_NEG:  *out = -v;       return 1;
    case OP_COMP: *out = ~v;       return 1;
    case OP_LNEG: *out = (v == 0); return 1;
    }
    return 0;
}

static int try_fold_binop(int kind, int64_t l, int64_t r, int64_t *out)
{
    switch (kind) {
    case OP_ADD:  *out = l + r; return 1;
    case OP_SUB:  *out = l - r; return 1;
    case OP_MULT: *out = l * r; return 1;
    case OP_DIV:  if (r == 0) return 0; *out = l / r; return 1;
    /* CAVEAT — signed `%` folds with C99 semantics (remainder takes the
       dividend's sign): -1 % 2 == -1. sdcc folds it identically and fails the
       same sccz80 division-suite cases we do — so 80cc matches sdcc here, NOT
       a regression. sccz80 alone passes the suite: it does NOT fold signed
       `% 2^k` at all — it strength-reduces to inline `|val| & mask` (always
       non-negative, -1 % 2 -> 1), with l_div for other divisors. That mix
       follows no single convention (it yields 1 % -32 == 1 but -1 % -4 == -1),
       and the suite was written to it. So our C99 fold is correct and
       sdcc-consistent; "matching sccz80" would mean reproducing its non-C99
       ad-hoc modulo in the fold. Left as-is pending a decision on whether to
       make z88dk's signed `%` C99-conforming lib-wide. (Signed `/` agrees with
       the runtime either way: both truncate toward zero, like C99.) */
    case OP_MOD:  if (r == 0) return 0; *out = l % r; return 1;
    case OP_AND:  *out = l & r; return 1;
    case OP_OR:   *out = l | r; return 1;
    case OP_XOR:  *out = l ^ r; return 1;
    case OP_EQ:   *out = (l == r); return 1;
    case OP_NE:   *out = (l != r); return 1;
    case OP_LT:   *out = (l <  r); return 1;
    case OP_LE:   *out = (l <= r); return 1;
    case OP_GT:   *out = (l >  r); return 1;
    case OP_GE:   *out = (l >= r); return 1;
    case OP_SSHR: *out = l >> r; return 1;                  /* arithmetic */
    case OP_USHR: *out = (int64_t)((uint64_t)l >> r); return 1; /* logical: a
                    64-bit value with bit 63 set (e.g. 0x8000…ULL) folded with
                    the signed `>>` sign-extended instead of zero-filling */
    case OP_SSHL:
    case OP_USHL: *out = (int64_t)((uint64_t)l << r); return 1; /* shift the
                    bit pattern; signed `<<` into bit 63 is UB in C */
    case OP_OROR:   *out = (l || r); return 1;
    case OP_ANDAND: *out = (l && r); return 1;
    }
    return 0;
}

/* Decimal counterpart for floating / fixed-point literal-pair fold.
   Only the arithmetic and comparison operators apply — modular and
   bitwise ops aren't defined for non-integer operands and bail.
   Comparisons return 0/1 as zdouble; the caller's result type is
   already int so subsequent integer fold handles it. */
static int is_compare_op(int kind)
{
    return kind == OP_EQ || kind == OP_NE || kind == OP_LT
        || kind == OP_LE || kind == OP_GT || kind == OP_GE;
}

/* Promoted integer width (bits) and signedness of a fold operand's type,
   per C's integer promotions: char (and anything narrower than int) promotes
   to signed int — a 16-bit signed int represents every 8-bit value, so even
   unsigned char becomes signed. short/int stay 16-bit (z88dk short == int);
   long/pointers 32-bit; long long 64-bit. Null type → signed int. */
static void fold_promoted_int_type(const Type *t, int *width, int *is_unsigned)
{
    Kind k = t ? t->kind : KIND_INT;
    if (k == KIND_LONGLONG)       { *width = 64; *is_unsigned = t->isunsigned; }
    else if (k == KIND_LONG || k == KIND_CPTR || k == KIND_PTR)
                                  { *width = 32; *is_unsigned = t ? t->isunsigned : 0; }
    else if ((k == KIND_INT || k == KIND_SHORT) && t && t->isunsigned)
                                  { *width = 16; *is_unsigned = 1; }
    else                          { *width = 16; *is_unsigned = 0; }
}

/* Sign-extend the low `width` bits of v into a full int64_t. */
static int64_t fold_sext(int64_t v, int width)
{
    if (width >= 64) return v;
    int sh = 64 - width;
    return (int64_t)((uint64_t)v << sh) >> sh;
}

/* Fold an integer comparison honouring C's usual arithmetic conversions:
   normalise both operands to their common type's width and signedness before
   comparing. Without this the operands are compared as raw signed int64, so
   e.g. (int)0x8000 == (unsigned)0x8000 folds false (-32768 vs 32768) instead
   of true (both 0x8000 as unsigned int). */
static int try_fold_compare(int kind, int64_t l, int64_t r,
                            const Type *lt, const Type *rt, int64_t *out)
{
    int wl, ul, wr, ur;
    fold_promoted_int_type(lt, &wl, &ul);
    fold_promoted_int_type(rt, &wr, &ur);
    int cw, cu;
    if (wl == wr)      { cw = wl;          cu = ul || ur; }
    else if (wl > wr)  { cw = wl;          cu = ul; }
    else               { cw = wr;          cu = ur; }

    if (cu) {
        uint64_t mask = (cw >= 64) ? ~(uint64_t)0 : (((uint64_t)1 << cw) - 1);
        uint64_t a = (uint64_t)l & mask, b = (uint64_t)r & mask;
        switch (kind) {
        case OP_EQ: *out = (a == b); return 1;
        case OP_NE: *out = (a != b); return 1;
        case OP_LT: *out = (a <  b); return 1;
        case OP_LE: *out = (a <= b); return 1;
        case OP_GT: *out = (a >  b); return 1;
        case OP_GE: *out = (a >= b); return 1;
        }
    } else {
        int64_t a = fold_sext(l, cw), b = fold_sext(r, cw);
        switch (kind) {
        case OP_EQ: *out = (a == b); return 1;
        case OP_NE: *out = (a != b); return 1;
        case OP_LT: *out = (a <  b); return 1;
        case OP_LE: *out = (a <= b); return 1;
        case OP_GT: *out = (a >  b); return 1;
        case OP_GE: *out = (a >= b); return 1;
        }
    }
    return 0;
}

static int try_fold_binop_decimal(int kind, zdouble l, zdouble r, zdouble *out)
{
    switch (kind) {
    case OP_ADD:  *out = l + r; return 1;
    case OP_SUB:  *out = l - r; return 1;
    case OP_MULT: *out = l * r; return 1;
    case OP_DIV:  if (r == 0) return 0; *out = l / r; return 1;
    case OP_EQ:   *out = (zdouble)(l == r); return 1;
    case OP_NE:   *out = (zdouble)(l != r); return 1;
    case OP_LT:   *out = (zdouble)(l <  r); return 1;
    case OP_LE:   *out = (zdouble)(l <= r); return 1;
    case OP_GT:   *out = (zdouble)(l >  r); return 1;
    case OP_GE:   *out = (zdouble)(l >= r); return 1;
    }
    return 0;
}

/*
 * Recursive fold. Returns the (possibly replaced) node. Caller assigns
 * the return back to the original slot.
 *
 * Post-order: recurse children first via the generic iterator, then
 * apply the local rewrite (literal-on-literal fold, cast narrowing,
 * div/0 + over-width-shift warnings) on the now-folded children.
 */
static void fold_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = ast_fold_constants(n);
    if (r != n) ast_slot_set(slot, r);
}

Node *ast_fold_constants(Node *node)
{
    if (!node) return NULL;

    ast_for_each_child(node, fold_visit, NULL);

    switch (node->ast_type) {
    /* Unary ops: fold if the operand is a literal (excluding the
       lvalue/address marker ops and the side-effect-laden steps). */
    case OP_NEG: case OP_COMP: case OP_LNEG:
        if (node->operand && node->operand->ast_type == AST_LITERAL) {
            /* Floating literal: fold in the double domain. The integer
               path below casts zval to int64_t, which would truncate the
               fraction (e.g. -2.5 → -2.0). ~ on a float is invalid C —
               leave it for diagnosis. */
            if (node->operand->type
                && kind_is_floating(node->operand->type->kind)) {
                zdouble fv = node->operand->zval;
                Type *t = node->type ? node->type : node->operand->type;
                if (node->ast_type == OP_NEG)
                    return ast_literal(t, -fv);
                if (node->ast_type == OP_LNEG)
                    return ast_literal(type_int, (zdouble)(fv == 0));
                return node;
            }
            int64_t v = (int64_t)node->operand->zval, r;
            if (try_fold_unop(node->ast_type, v, &r)) {
                Type *t = node->type ? node->type : node->operand->type;
                return ast_literal(t ? t : type_int, (zdouble)r);
            }
        }
        return node;

    case OP_CAST:
        /* Absorb an integer-literal operand into a literal with the cast
           type. Without this, an OP_ADD whose operands are `(char)200`
           + `(char)100` doesn't fold because the OP_CAST wrappers block
           the literal-literal pattern below. We narrow the value to the
           target width *only* when the cast actually narrows (dst kind
           strictly narrower than src kind) — mirrors docast()'s
           `if (cast_type->kind < val_type)` gate. A `(char)` applied to
           a literal already typed `char` is a no-op for value purposes,
           matching legacy's "char + char fits → int" promotion path. We
           fold integer→integer and integer→pointer casts; the
           latter covers `(T*)0` patterns (e.g. NULL written as
           `((void*)0)`) so they reduce to a literal usable as a
           constant initialiser. Float and fixed-point casts keep
           their OP_CAST so the walker emits the proper conversion
           helper. */
        if (node->operand
            && node->operand->ast_type == AST_LITERAL
            && node->type
            && (kind_is_integer(node->type->kind)
                || node->type->kind == KIND_PTR
                || node->type->kind == KIND_CPTR)
            && node->operand->type
            && kind_is_integer(node->operand->type->kind)) {
            int64_t v = (int64_t)node->operand->zval;
            int64_t narrowed = v;
            Kind dst = node->type->kind;
            Kind src = node->operand->type->kind;
            /* Reduce the literal to the TARGET type's representable range:
               mask to its width and reinterpret per its signedness. Not
               gated on dst<src — a same-width signedness change is also a
               value change (`(unsigned int)-1` is 65535, not -1; `(int)
               0xffff` is -1) and a widen-to-unsigned reinterprets a
               negative (`(unsigned long)-1` is 0xFFFFFFFF). The range MUST
               track signedness: a sign-agnostic [-128,255]-style range
               leaves `(unsigned char)-7` as -7 and `(signed char)200` as
               200. In-range values mask to themselves (no-op). KIND src
               ordering: CHAR<SHORT<INT<LONG<LONGLONG. */
            (void)src;
            if (kind_is_integer(dst)) {
                int is_un = node->type->isunsigned;
                int64_t lo = 0, hi = 0;
                int known = 1;
                if (dst == KIND_CHAR) {
                    lo = is_un ? 0 : -128;       hi = is_un ? 255 : 127;
                } else if (dst == KIND_INT || dst == KIND_SHORT) {
                    lo = is_un ? 0 : -32768;     hi = is_un ? 65535 : 32767;
                } else if (dst == KIND_LONG) {
                    lo = is_un ? 0 : INT32_MIN;  hi = is_un ? UINT32_MAX : INT32_MAX;
                } else {
                    known = 0;   /* LONGLONG: int64 zval already models it */
                }
                if (known && (v < lo || v > hi)) {
                    if (dst == KIND_CHAR) {
                        narrowed = is_un ? (int64_t)(uint8_t)(v & 0xff)
                                         : (int64_t)(int8_t)(v & 0xff);
                    } else if (dst == KIND_INT || dst == KIND_SHORT) {
                        narrowed = is_un ? (int64_t)(uint16_t)(v & 0xffff)
                                         : (int64_t)(int16_t)(v & 0xffff);
                    } else {
                        narrowed = is_un ? (int64_t)(uint32_t)(v & 0xffffffff)
                                         : (int64_t)(int32_t)(v & 0xffffffff);
                    }
                }
            }
            return ast_literal(node->type, (zdouble)narrowed);
        }
        return node;

    /* Binary ops we can fold (16-bit int-class). Side-effecting ops
       (assignments) are never folded. */
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE:  case OP_GT:  case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND: {
        Node *L = node->left, *R = node->right;
        /* Div/mod by zero. Fires whenever the RHS is a literal 0
           regardless of whether the LHS is a literal — so this
           catches both `5/0` (folded directly) and `x/0` after
           const-prop turned `x = 0;` into a literal. Result is
           defined as zero to match legacy plnge2a behaviour. */
        if ((node->ast_type == OP_DIV || node->ast_type == OP_MOD)
            && R && R->ast_type == AST_LITERAL
            && (int64_t)R->zval == 0) {
            warningfmt_at("division-by-zero", node->filename, node->line,
                "Division by zero, result set to be zero");
            Type *t = node->type ? node->type
                    : (L && L->type ? L->type : type_int);
            return ast_literal(t, (zdouble)0);
        }
        /* Shift count out of range. C leaves over-width shifts as
           undefined behaviour; legacy folded to zero to match user
           intent. Width comes from the LHS operand's type. */
        if ((node->ast_type == OP_SSHL || node->ast_type == OP_USHL
          || node->ast_type == OP_SSHR || node->ast_type == OP_USHR)
            && R && R->ast_type == AST_LITERAL
            && L && L->type) {
            int width = 0;
            Kind k = L->type->kind;
            /* Integer promotion: char and short shift as int, so only
               counts >= the PROMOTED width are out of range. Folding
               `byte << 8` to zero silently deleted valid code like
               `(dig[0] << 8) | dig[1]`. */
            if      (k == KIND_CHAR || k == KIND_SHORT
                  || k == KIND_INT)      width = 16;
            else if (k == KIND_LONG || k == KIND_CPTR) width = 32;
            else if (k == KIND_LONGLONG) width = 64;
            int64_t shamt = (int64_t)R->zval;
            if (width && (shamt < 0 || shamt >= width)) {
                const char *dir = (node->ast_type == OP_SSHL
                                || node->ast_type == OP_USHL)
                                ? "Left" : "Right";
                warningfmt_at("limited-range",
                    node->filename, node->line,
                    "%s shifting by more than size of object, changed to zero",
                    dir);
                return ast_literal(L->type, (zdouble)0);
            }
        }
        if (L && R && L->ast_type == AST_LITERAL && R->ast_type == AST_LITERAL) {
            /* Use decimal arithmetic when either operand is a float /
               fixed-point literal. Preserves zdouble precision; the
               integer fold would otherwise truncate (e.g.
               `0.1 + 0.2` → 0 instead of 0.3). */
            int decimal = (L->type && kind_is_decimal(L->type->kind))
                       || (R->type && kind_is_decimal(R->type->kind));
            if (decimal) {
                zdouble lv = L->zval, rv = R->zval, dv;
                if (try_fold_binop_decimal(node->ast_type, lv, rv, &dv)) {
                    /* A comparison yields int (0/1) — force int so the
                       literal isn't re-encoded as a DOUBLE 1.0/0.0 (IEEE
                       0x3F800000). Arithmetic keeps the operand type. */
                    Type *t = is_compare_op(node->ast_type) ? type_int
                            : (node->type ? node->type : L->type);
                    return ast_literal(t ? t : type_int, dv);
                }
            } else {
                int64_t l = (int64_t)L->zval;
                int64_t r = (int64_t)R->zval;
                int64_t v;
                int fold_op = node->ast_type;
                /* `>>` is parsed OP_SSHR unconditionally; for an unsigned
                   LHS it shifts LOGICALLY (and the runtime lowers both to
                   the logical IR_SHR). Fold logically so `0x8000…ULL >> 1`
                   zero-fills (0x4000…) instead of sign-extending (0xC000…). */
                if (fold_op == OP_SSHR && L->type && L->type->isunsigned)
                    fold_op = OP_USHR;
                /* Comparisons need the usual arithmetic conversions applied
                   to the operands' common type; the raw signed-int64 path
                   below mis-handles mixed signedness (e.g. int vs unsigned
                   int at the 0x8000 boundary). Result type is always int. */
                if (is_compare_op(fold_op)) {
                    if (try_fold_compare(fold_op, l, r, L->type, R->type, &v))
                        return ast_literal(type_int, (zdouble)v);
                } else if (try_fold_binop(fold_op, l, r, &v)) {
                    Type *t = node->type ? node->type : L->type;
                    return ast_literal(t ? t : type_int, (zdouble)v);
                }
            }
        }
        return node;
    }

    default:
        return node;
    }
}

/* ----- Algebraic identities ------------------------------------------ */

/* True if `node` is an AST_LITERAL of integer kind whose value equals
   `target`. Pointer-typed literals don't qualify (a constant address is
   not the integer 0). */
static int is_int_literal(Node *node, int64_t target)
{
    if (!node || node->ast_type != AST_LITERAL) return 0;
    if (node->type) {
        Kind k = node->type->kind;
        if (k != KIND_INT && k != KIND_CHAR && k != KIND_SHORT &&
            k != KIND_LONG && k != KIND_LONGLONG) return 0;
    }
    return (int64_t)node->zval == target;
}

/* True if `op` is a relational/equality comparison, i.e. produces 0/1. */
static int is_comparison_op(int op)
{
    return op == OP_EQ || op == OP_NE || op == OP_LT || op == OP_LE
        || op == OP_GT || op == OP_GE;
}

/* Predicate-flip for De Morgan's on `!(a cmp b)`. */
static int negate_comparison_op(int op)
{
    switch (op) {
    case OP_EQ: return OP_NE;
    case OP_NE: return OP_EQ;
    case OP_LT: return OP_GE;
    case OP_LE: return OP_GT;
    case OP_GT: return OP_LE;
    case OP_GE: return OP_LT;
    }
    return op;
}

/* Reflect a comparison around its operands: `a OP b` ↔ `b OP' a`.
   EQ/NE are symmetric; LT↔GT, LE↔GE swap direction. */
static int reflect_comparison_op(int op)
{
    switch (op) {
    case OP_LT: return OP_GT;
    case OP_LE: return OP_GE;
    case OP_GT: return OP_LT;
    case OP_GE: return OP_LE;
    }
    return op;
}

/* For a comparison oriented as `typed_operand OP literal`, return 1
   (always true), 0 (always false), or -1 (not statically determinable)
   based on whether the literal lies outside the typed operand's
   representable range. Range comes from the operand type's kind +
   signedness; only char/short/int operands narrow the range usefully
   (long is the widest sccz80 type the walker manipulates routinely).

   Subtle: C usual-arithmetic-conversions promote both sides to a
   common type before comparing, so a "positive out-of-signed-range"
   literal can still match a negative-valued signed operand (the
   signed side gets promoted to unsigned, and `(unsigned)-513 ==
   65023` is true). We therefore widen the range to the union of the
   signed and unsigned ranges for the operand's width: the literal
   must be outside BOTH for elision to be safe. */
static int range_elide_compare(int op, Type *t, int64_t lit)
{
    if (!t) return -1;
    int64_t min, max;
    Kind k = t->kind;
    if (k == KIND_CHAR) {
        min = -128;   max = 255;
    } else if (k == KIND_INT || k == KIND_SHORT) {
        min = -32768; max = 65535;
    } else {
        return -1;
    }
    if (lit >= min && lit <= max) return -1;
    if (lit > max) {
        switch (op) {
        case OP_LT: case OP_LE: case OP_NE: return 1;
        case OP_GT: case OP_GE: case OP_EQ: return 0;
        }
    } else { /* lit < min */
        switch (op) {
        case OP_GT: case OP_GE: case OP_NE: return 1;
        case OP_LT: case OP_LE: case OP_EQ: return 0;
        }
    }
    return -1;
}

/* True if `op` is guaranteed to produce a 0/1 boolean result. Used to
   decide when `cond ? 1 : 0` collapses to `cond`. */
static int is_boolean_op(int op)
{
    return is_comparison_op(op)
        || op == OP_OROR || op == OP_ANDAND || op == OP_LNEG;
}

/* Conservative side-effect-free predicate: reading a non-volatile local
   or global, computing arithmetic over those, or taking an address. Any
   pre/post-step, assignment, function call, or unrecognised node is
   rejected. */
static int is_side_effect_free(Node *n)
{
    if (!n) return 1;
    switch (n->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_LABEL:
        return 1;
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST:
    case OP_SIZEOF:
        return is_side_effect_free(n->operand);
    case OP_ADDR: case AST_ADDR:
        return 1;        /* &x doesn't actually read x */
    case OP_DEREF: case AST_DEREF: {
        /* Reading volatile memory is the only side effect of a deref.
           normalize_types attaches the post-deref type to the node,
           so `node->type->isvolatile` covers both `volatile int v; v`
           (the rvalue load of a volatile local) and `volatile int *p;
           *p` (deref of a pointer-to-volatile). The pointer expression
           must also be SEF (e.g. no embedded function call). */
        if (n->type && n->type->isvolatile) return 0;
        /* For symbol rvalue loads where normalize_types couldn't run
           or didn't propagate volatility, fall back to checking the
           SYMBOL's ctype. */
        Node *o = n->operand;
        if (o && (o->ast_type == AST_LOCAL_VAR || o->ast_type == AST_GLOBAL_VAR)) {
            SYMBOL *s = o->sym;
            if (s && s->ctype && s->ctype->isvolatile) return 0;
        }
        return is_side_effect_free(n->operand);
    }
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        return is_side_effect_free(n->left) && is_side_effect_free(n->right);
    case AST_TERNARY:
        return is_side_effect_free(n->cond)
            && is_side_effect_free(n->then)
            && is_side_effect_free(n->els);
    default:
        return 0;
    }
}

/* Structural equivalence over the SEF subset. Two nodes are "equivalent"
   if evaluating them in sequence yields the same value. Conservative —
   only matches the exact node forms is_side_effect_free handles, plus a
   value match for literals. */
static int nodes_equivalent(Node *a, Node *b)
{
    if (a == b) return 1;
    if (!a || !b) return 0;
    if (a->ast_type != b->ast_type) return 0;

    switch (a->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
        return (int64_t)a->zval == (int64_t)b->zval;
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        return a->sym == b->sym;
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST:
    case OP_DEREF: case AST_DEREF:
    case OP_ADDR:  case AST_ADDR:
        return nodes_equivalent(a->operand, b->operand);
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        return nodes_equivalent(a->left, b->left)
            && nodes_equivalent(a->right, b->right);
    default:
        return 0;
    }
}

/* Unary simplifications (rules 1 + 2):
     - `!(a cmp b)` → `a !cmp b`              (De Morgan on comparison)
     - `-(-x)` → `x`                          (involutive)
     - `~~x`   → `x`                          (involutive)
     - `!!!x`  → `!x`                         (three-NOT collapse)
   `!!x → x` is *not* applied: `!!` is a 0/1 boolean coercion, not
   identity. ast_fold_constants already handles unary-on-literal so we
   don't repeat that here. */
static Node *try_simplify_unop(Node *node)
{
    int op = node->ast_type;
    Node *o = node->operand;
    if (!o) return node;

    /* Involutive: `-(-x)` and `~~x`. */
    if (op == OP_NEG  && o->ast_type == OP_NEG  && o->operand) return o->operand;
    if (op == OP_COMP && o->ast_type == OP_COMP && o->operand) return o->operand;

    /* `!(a cmp b)` → flipped comparison. */
    if (op == OP_LNEG && is_comparison_op(o->ast_type)) {
        o->ast_type = negate_comparison_op(o->ast_type);
        return o;
    }

    /* `!!!x` → `!x`. (Outer LNEG with operand LNEG(LNEG(x)).) */
    if (op == OP_LNEG && o->ast_type == OP_LNEG
        && o->operand && o->operand->ast_type == OP_LNEG) {
        return o->operand;
    }

    return node;
}

/* Ternary simplification (rule 3): `cond ? 1 : 0` → `cond` when cond is
   guaranteed boolean (otherwise the values differ — `2 ? 1 : 0` is 1 but
   `2` is 2). `cond ? 0 : 1` → `!cond` under the same precondition. */
static Node *try_simplify_ternary(Node *node)
{
    Node *c = node->cond;
    Node *t = node->then;
    Node *e = node->els;
    if (!c || !t || !e) return node;

    int t_one  = is_int_literal(t, 1);
    int t_zero = is_int_literal(t, 0);
    int e_one  = is_int_literal(e, 1);
    int e_zero = is_int_literal(e, 0);
    if (!t_one && !t_zero) return node;
    if (!e_one && !e_zero) return node;

    /* Peel a single OP_DEREF rvalue wrap before classifying cond. */
    Node *cinner = c;
    while (cinner && cinner->ast_type == OP_DEREF) cinner = cinner->operand;
    if (!cinner || !is_boolean_op(cinner->ast_type)) return node;

    if (t_one && e_zero) return c;       /* cond ? 1 : 0 → cond */
    if (t_zero && e_one) {
        Node *neg = calloc(1, sizeof(Node));
        neg->ast_type = OP_LNEG;
        neg->operand = c;
        neg->type = node->type;
        neg->filename = node->filename;
        neg->line = node->line;
        return try_simplify_unop(neg);
    }
    return node;
}

/* Try a couple of identities for binary ops where one side is a
   literal. Returns the replacement node, or `node` unchanged. */
static Node *try_simplify_binop(Node *node)
{
    Node *l = node->left;
    Node *r = node->right;
    int   op = node->ast_type;

    /* Rule 4: self-equivalence on side-effect-free operands.
         x - x   → 0      x ^ x   → 0
         x == x  → 1      x != x  → 0
         x <  x  → 0      x >  x  → 0
         x <= x  → 1      x >= x  → 1
         x &  x  → x      x |  x  → x
       OP_DIV / OP_MOD avoided: trapping when x == 0. */
    if (l && r && nodes_equivalent(l, r) && is_side_effect_free(l)) {
        Type *t_int = node->type ? node->type : type_int;
        Type *t_op  = node->type ? node->type : (l->type ? l->type : type_int);
        switch (op) {
        case OP_SUB:
        case OP_XOR:
            return ast_literal(t_op, (zdouble)0);
        case OP_NE:
        case OP_LT:
        case OP_GT:
            return ast_literal(t_int, (zdouble)0);
        case OP_EQ:
        case OP_LE:
        case OP_GE:
            return ast_literal(t_int, (zdouble)1);
        case OP_AND:
        case OP_OR:
            return l;
        }
    }

    /* Identities involving 0 on either side. */
    if (is_int_literal(r, 0)) {
        switch (op) {
        case OP_ADD: case OP_SUB:
        case OP_OR:  case OP_XOR:
        case OP_SSHR: case OP_SSHL:
        case OP_USHR: case OP_USHL:
            return l;          /* x + 0, x - 0, x | 0, x ^ 0, x >> 0, x << 0 → x */
        case OP_MULT:
        case OP_AND:
            /* x * 0 / x & 0 → 0, but only if x has no side effect. */
            if (l && l->ast_type == AST_LITERAL) {
                /* both literal — already handled by fold; leave for
                   completeness. */
            }
            return r;          /* literal 0 (could short-circuit eval of l, but x might have side effects) */
            /* TODO: preserve side effects of l. For now: keep node. */
        /* NOT `x || 0 → x`: the result of || is a normalised 0/1 bool, but
           x can be any nonzero value (or a wide/float whose low word is 0).
           `int r = x || 0` proved this folds to the raw x. Build the OROR. */
        case OP_ANDAND:
            return r;          /* x && 0 → 0 (x might have side effects! but legacy short-circuits anyway) */
        }
    }
    if (is_int_literal(l, 0)) {
        switch (op) {
        case OP_ADD:
        case OP_OR:  case OP_XOR:
            return r;          /* 0 + x, 0 | x, 0 ^ x → x */
        case OP_MULT:
        case OP_AND:
            return l;          /* 0 * x / 0 & x → 0 (assuming x side-effect-free; conservative) */
        /* NOT `0 || x → x`: result is a normalised 0/1 bool, not raw x. */
        case OP_ANDAND:
            return l;          /* 0 && x → 0 (x not evaluated; 0 side-effect-free) */
        }
    }

    /* Identities involving 1. */
    if (is_int_literal(r, 1)) {
        switch (op) {
        case OP_MULT:
        case OP_DIV:
            return l;          /* x * 1, x / 1 → x */
        }
    }
    if (is_int_literal(l, 1)) {
        if (op == OP_MULT) return r;   /* 1 * x → x */
    }

    /* x * -1 / x / -1 → -x. */
    if (is_int_literal(r, -1)) {
        if (op == OP_MULT || op == OP_DIV) {
            Node *neg = calloc(1, sizeof(Node));
            neg->ast_type = OP_NEG;
            neg->operand = l;
            neg->type = node->type;
            neg->filename = node->filename;
            neg->line = node->line;
            return neg;
        }
    }

    /* Rule 5: mask saturate. For sccz80 ints/shorts (16-bit) and
       unsigned char (8-bit), a mask of all-ones is a no-op; an OR
       against all-ones produces all-ones. We exclude signed char
       because promotion to int sign-extends, and `signed_char & 0xFF`
       would clip the sign-extended high byte and change the value. */
    if (r && r->ast_type == AST_LITERAL && l && l->type
        && (op == OP_AND || op == OP_OR)) {
        int64_t v = (int64_t)r->zval;
        Kind k = l->type->kind;
        int64_t all_bits = 0;
        int known = 0;
        if (k == KIND_INT || k == KIND_SHORT) {
            all_bits = 0xFFFF; known = 1;
        } else if (k == KIND_CHAR && l->type->isunsigned) {
            all_bits = 0xFF; known = 1;
        }
        if (known && (v & 0xFFFFLL) == (all_bits & 0xFFFFLL)) {
            if (op == OP_AND) return l;
            if (op == OP_OR && is_side_effect_free(l)) return r;
        }
    }

    /* Negative-literal flip: `e + (-N)` → `e - N` and `e - (-N)` → `e + N`.
       Cosmetic — easier to read and matches what a programmer would
       write. Doesn't affect codegen semantics. */
    if (r && r->ast_type == AST_LITERAL && (int64_t)r->zval < 0
        && (op == OP_ADD || op == OP_SUB)) {
        Node *neg_lit = ast_literal(r->type ? r->type : type_int,
                                    (zdouble)(-(int64_t)r->zval));
        Node *flipped = calloc(1, sizeof(Node));
        flipped->ast_type = (op == OP_ADD) ? OP_SUB : OP_ADD;
        flipped->left = l;
        flipped->right = neg_lit;
        flipped->type = node->type;
        flipped->filename = node->filename;
        flipped->line = node->line;
        return flipped;
    }

    /* Canonical-form swap: for commutative ops, put the literal on the
       right. Doing this before reassociation lets the reassoc patterns
       below match `(e op C1) op C2` regardless of whether the inputs
       were `1 + x + 5` or `x + 1 + 5`. */
    if (l && r && l->ast_type == AST_LITERAL && r->ast_type != AST_LITERAL) {
        if (op == OP_ADD || op == OP_MULT
            || op == OP_AND || op == OP_OR || op == OP_XOR
            || op == OP_EQ  || op == OP_NE) {
            node->left = r;
            node->right = l;
            l = node->left;
            r = node->right;
        }
    }

    /* Range-elision for comparisons: `typed_operand OP literal` where
       the literal is outside the typed operand's representable range
       folds to 0 or 1. Catches `unsigned char c; c == 256` (always
       false), `int x; x >= 100000` (always false), etc. Subsequent
       dead-code elimination then drops the now-constant if/while
       branch. We only fold when the typed operand is side-effect-free;
       otherwise we'd silently drop the side effect. The warning fires
       regardless so the user still hears about it. */
    if (is_comparison_op(op)) {
        Node *typed = NULL;
        int64_t lit = 0;
        int cmp_op = op;
        if (r && r->ast_type == AST_LITERAL && l && l->ast_type != AST_LITERAL) {
            typed = l;  lit = (int64_t)r->zval;
        } else if (l && l->ast_type == AST_LITERAL && r && r->ast_type != AST_LITERAL) {
            typed = r;  lit = (int64_t)l->zval;
            cmp_op = reflect_comparison_op(op);
        }
        if (typed && typed->type) {
            int always = range_elide_compare(cmp_op, typed->type, lit);
            if (always >= 0) {
                warningfmt_at("limited-range", node->filename, node->line,
                    "Due to limited range of data type, expression is always %s",
                    always ? "true" : "false");
                if (is_side_effect_free(typed)) {
                    return ast_literal(node->type ? node->type : type_int,
                                       (zdouble)always);
                }
            }
        }
    }

    /* Reassociate adjacent constants so left-associative chains fold.
       After the swap above, the canonical shape is `(L op C)`, so a
       chain like `(e op_inner C1) op_outer C2` is detectable directly. */
    if (r && r->ast_type == AST_LITERAL
        && l && (l->ast_type == OP_ADD || l->ast_type == OP_SUB
                 || l->ast_type == OP_MULT)
        && l->right && l->right->ast_type == AST_LITERAL) {
        int  inner_op = l->ast_type;
        int64_t IC = (int64_t)l->right->zval;
        int64_t OC = (int64_t)r->zval;
        Node *e   = l->left;
        Node *new_op_node = NULL;
        int64_t new_const = 0;
        int new_op = -1;

        if (op == OP_ADD && inner_op == OP_ADD) {
            new_op = OP_ADD; new_const = IC + OC;       /* (e + IC) + OC → e + (IC+OC) */
        } else if (op == OP_ADD && inner_op == OP_SUB) {
            new_op = OP_ADD; new_const = OC - IC;       /* (e - IC) + OC → e + (OC-IC) */
        } else if (op == OP_SUB && inner_op == OP_ADD) {
            new_op = OP_ADD; new_const = IC - OC;       /* (e + IC) - OC → e + (IC-OC) */
        } else if (op == OP_SUB && inner_op == OP_SUB) {
            new_op = OP_SUB; new_const = IC + OC;       /* (e - IC) - OC → e - (IC+OC) */
        } else if (op == OP_MULT && inner_op == OP_MULT) {
            new_op = OP_MULT; new_const = IC * OC;      /* (e * IC) * OC → e * (IC*OC) */
        }

        if (new_op != -1) {
            new_op_node = calloc(1, sizeof(Node));
            new_op_node->ast_type = new_op;
            new_op_node->left = e;
            new_op_node->right = ast_literal(node->type ? node->type : type_int,
                                             (zdouble)new_const);
            new_op_node->type = node->type;
            new_op_node->filename = node->filename;
            new_op_node->line = node->line;
            /* Recurse so derived patterns (e.g. negative literal that
               came out of `IC - OC`) get further simplified. */
            return ast_simplify_algebraic(new_op_node);
        }
    }

    return node;
}

/* ----- Strength reduction ------------------------------------------- */

/* If `v` is a positive power of 2 in [1..32768], set *shift to its
   log2 and return 1. Else return 0. We bound at 32768 because that's
   the largest power of 2 that fits in a signed 16-bit int (well, 16384
   does — 32768 wraps to MIN_INT, but as a multiply factor it's fine).
   Caller should still respect the operand's bit width. */
static int extract_pow2(int64_t v, int *shift)
{
    if (v <= 0) return 0;
    if (v & (v - 1)) return 0;  /* not a power of 2 */
    int s = 0;
    while ((((int64_t)1) << s) != v) {
        s++;
        if (s > 31) return 0;
    }
    *shift = s;
    return 1;
}

/* True if the operand is integer-class AND fits in a 16-bit register
   path. Long / longlong / float / accum types have their own legacy
   paths and aren't worth touching at the AST level. */
static int is_int_class_16(Node *n)
{
    if (!n || !n->type) return 0;
    Kind k = n->type->kind;
    return (k == KIND_INT || k == KIND_CHAR || k == KIND_SHORT);
}

/* True if integer-class up to 32-bit (long included). Used to gate
   power-of-2 strength reduction for 32-bit ops where the resulting
   shift/mask sequence is cheaper than the runtime helper call. */
static int is_int_class_32(Node *n)
{
    if (!n || !n->type) return 0;
    Kind k = n->type->kind;
    return (k == KIND_INT || k == KIND_CHAR || k == KIND_SHORT
         || k == KIND_LONG);
}

/* True if the type is unsigned. NULL type → conservative (return 0). */
static int type_is_unsigned(Type *t)
{
    return t && t->isunsigned;
}

static Node *try_strength_reduce(Node *node)
{
    int op = node->ast_type;
    Node *l = node->left;
    Node *r = node->right;

    /* Commutative swap so the literal is on the right for OP_MULT.
       (DIV / MOD aren't commutative.) */
    if (op == OP_MULT && r && r->ast_type != AST_LITERAL
        && l && l->ast_type == AST_LITERAL) {
        Node *t = l; l = r; r = t;
        node->left = l;
        node->right = r;
    }

    if (!r || r->ast_type != AST_LITERAL) return node;
    if (!is_int_class_32(l)) return node;
    int is_long = (l->type->kind == KIND_LONG);

    int shift;
    int64_t v = (int64_t)r->zval;
    if (!extract_pow2(v, &shift)) return node;
    if (shift == 0) return node;     /* x*1, x/1, x%1 — already in simplify */
    int shift_limit = is_long ? 31 : 15;
    if (shift > shift_limit) return node;

    switch (op) {
    case OP_MULT: {
        /* x * 2^N → x << N (signed-or-unsigned: same low bits). */
        Node *shl = calloc(1, sizeof(Node));
        shl->ast_type = OP_SSHL;
        shl->left = l;
        shl->right = ast_literal(type_int, (zdouble)shift);
        shl->type = node->type;
        shl->filename = node->filename;
        shl->line = node->line;
        return shl;
    }
    case OP_DIV:
        /* x / 2^N → x >> N — only safe when x is unsigned. Signed
           division rounds toward zero (`-1 / 2 == 0` in C), but
           arithmetic shift right rounds toward minus infinity
           (`-1 >> 1 == -1`). Skip for signed. */
        if (!type_is_unsigned(l->type)) return node;
        {
            Node *shr = calloc(1, sizeof(Node));
            shr->ast_type = OP_USHR;
            shr->left = l;
            shr->right = ast_literal(type_int, (zdouble)shift);
            shr->type = node->type;
            shr->filename = node->filename;
            shr->line = node->line;
            return shr;
        }
    case OP_MOD:
        /* x % 2^N → x & (2^N - 1) — only safe when x is unsigned.
           Signed mod takes the sign of x in C; bitwise AND doesn't. */
        if (!type_is_unsigned(l->type)) return node;
        {
            Node *and_node = calloc(1, sizeof(Node));
            and_node->ast_type = OP_AND;
            and_node->left = l;
            /* Mask literal type tracks the LHS width so the IR
               builder picks the right binop kind (long vs int). */
            Type *mask_type = is_long ? type_ulong : type_int;
            and_node->right = ast_literal(mask_type, (zdouble)(v - 1));
            and_node->type = node->type;
            and_node->filename = node->filename;
            and_node->line = node->line;
            return and_node;
        }
    }
    return node;
}

/* Type-check pass — pure warnings, no rewrites. Emits the type-mismatch
   diagnostics that legacy plnge2a / plnge2b / force() used to fire at
   parse time. Runs after const-prop + fold so a literal that came from
   propagation is treated the same as an explicit literal — i.e. we don't
   warn about `5 + ptr` when `5` was originally a constant variable.

   Cases handled:
   1. OP_MULT/OP_DIV/OP_MOD: signedness mismatch between non-literal
      operands.
   2. OP_EQ/NE/LT/LE/GT/GE: one side is a pointer, the other is a
      non-pointer non-literal.
   3. OP_ADD: non-pointer LHS + non-char pointer RHS, both non-literal
      ("converting integer type to pointer without cast"). The
      conventional `ptr + int` indexing pattern is silent.
   4. OP_SUB: pointer minus pointer with non-matching element types
      (neither char-pointer).
   5. OP_CAST: KIND_CPTR narrowed to KIND_INT / KIND_PTR. */

static int tc_kind_is_pointer(Kind k)
{
    return k == KIND_PTR || k == KIND_CPTR || k == KIND_ARRAY;
}

static int tc_is_literal(Node *n)
{
    return n && (n->ast_type == AST_LITERAL || n->ast_type == AST_STR_LIT);
}

/* Pointee kind for a pointer/array type. Returns KIND_NONE when not a
   pointer-bearing type. */
static Kind tc_pointee_kind(Type *t)
{
    if (!t) return KIND_NONE;
    if (!tc_kind_is_pointer(t->kind)) return KIND_NONE;
    return t->ptr ? t->ptr->kind : KIND_NONE;
}

static void ast_typecheck_visit(const AstSlot *slot, void *ctx);

/* Per-node checks. Pure function of `node` and its already-stamped
   operand types; no recursion here — the caller (ast_typecheck_visit)
   walks children via ast_for_each_child. */
static void ast_typecheck_check_node(Node *node)
{
    switch (node->ast_type) {
    case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR: case OP_XOR:
    case OP_SSHL: case OP_SSHR: case OP_USHL: case OP_USHR: {
        Node *l = node->left, *r = node->right;
        /* Pointer operand on a non-arithmetic / non-comparison binop
           is invalid in C. Migrated from plnge2a's parser-side
           errorfmt — emits a fatal error keyed on the AST node's
           original source position. */
        if (l && r && l->type && r->type) {
            int lptr = tc_kind_is_pointer(l->type->kind);
            int rptr = tc_kind_is_pointer(r->type->kind);
            if (lptr || rptr) {
                errorfmt_at(node->filename, node->line, 1,
                    "Invalid pointer arithmetic");
                break;
            }
        }
        /* Signedness mismatch — only on mult/div/mod, not bitwise/
           shifts (those are unsigned-typed by intent in C). */
        if ((node->ast_type == OP_MULT || node->ast_type == OP_DIV
                                       || node->ast_type == OP_MOD)
            && l && r && l->type && r->type
            && !tc_is_literal(l) && !tc_is_literal(r)
            && (l->type->isunsigned != r->type->isunsigned)) {
            warningfmt_at("signedness", node->filename, node->line,
                "Operation on different signedness!");
        }
        break;
    }
    case OP_EQ: case OP_NE: case OP_LT: case OP_LE:
    case OP_GT: case OP_GE: {
        Node *l = node->left, *r = node->right;
        if (l && r && l->type && r->type) {
            int lptr = tc_kind_is_pointer(l->type->kind);
            int rptr = tc_kind_is_pointer(r->type->kind);
            if ((lptr && !rptr && !tc_is_literal(r))
             || (rptr && !lptr && !tc_is_literal(l))) {
                warningfmt_at("incompatible-pointer-types",
                    node->filename, node->line,
                    "Comparison of pointer with non-pointer value");
            }
        }
        break;
    }
    case OP_ADD: {
        Node *l = node->left, *r = node->right;
        if (l && r && l->type && r->type
            && !tc_is_literal(l) && !tc_is_literal(r)) {
            /* "int + ptr" with ptr being non-char-pointer is suspicious
               (legacy `dbltest(lval2, lval)` in plnge2b). The reflected
               `ptr + int` form is the usual indexing pattern and is
               silent. */
            int lptr = tc_kind_is_pointer(l->type->kind);
            int rptr = tc_kind_is_pointer(r->type->kind);
            if (!lptr && rptr && tc_pointee_kind(r->type) != KIND_CHAR) {
                UT_string *str;
                utstring_new(str);
                utstring_printf(str,
                    "Converting integer type to pointer without cast. From ");
                type_describe(l->type, str);
                utstring_printf(str, " to ");
                type_describe(r->type, str);
                warningfmt_at("incompatible-pointer-types",
                    node->filename, node->line,
                    "%s", utstring_body(str));
                utstring_free(str);
            }
        }
        break;
    }
    case OP_SUB: {
        Node *l = node->left, *r = node->right;
        if (l && r && l->type && r->type
            && tc_kind_is_pointer(l->type->kind)
            && tc_kind_is_pointer(r->type->kind)) {
            Kind lp = tc_pointee_kind(l->type);
            Kind rp = tc_pointee_kind(r->type);
            if (lp != rp && lp != KIND_CHAR && rp != KIND_CHAR) {
                UT_string *str;
                utstring_new(str);
                utstring_printf(str,
                    "Pointer arithmetic with non-matching types: ");
                type_describe(l->type, str);
                utstring_printf(str, " - ");
                type_describe(r->type, str);
                warningfmt_at("incompatible-pointer-types",
                    node->filename, node->line,
                    "%s", utstring_body(str));
                utstring_free(str);
            }
        }
        break;
    }
    case OP_CAST: {
        /* Narrowing far→near pointer. node->type is the cast target
           (output), node->operand->type is the input. */
        if (node->type && node->operand && node->operand->type) {
            Kind src = node->operand->type->kind;
            Kind dst = node->type->kind;
            if (src == KIND_CPTR && (dst == KIND_INT || dst == KIND_PTR)) {
                warningfmt_at("incompatible-pointer-types",
                    node->filename, node->line,
                    "Narrowing pointer from far to near");
            }
        }
        break;
    }
    default:
        break;
    }
}

static void ast_typecheck_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (!n) return;
    ast_typecheck_check_node(n);
    ast_for_each_child(n, ast_typecheck_visit, ctx);
}

Node *ast_typecheck(Node *root)
{
    AstSlot s = { .direct = &root };
    ast_typecheck_visit(&s, NULL);
    return root;
}

static void sr_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = ast_strength_reduce(n);
    if (r != n) ast_slot_set(slot, r);
}

Node *ast_strength_reduce(Node *node)
{
    if (!node) return NULL;
    ast_for_each_child(node, sr_visit, NULL);

    /* Targets: MULT / DIV / MOD with literal rhs that's a power of 2. */
    switch (node->ast_type) {
    case OP_MULT: case OP_DIV: case OP_MOD:
        return try_strength_reduce(node);
    default:
        return node;
    }
}

static void sa_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = ast_simplify_algebraic(n);
    if (r != n) ast_slot_set(slot, r);
}

Node *ast_simplify_algebraic(Node *node)
{
    if (!node) return NULL;
    ast_for_each_child(node, sa_visit, NULL);

    switch (node->ast_type) {
    case AST_TERNARY:
        return try_simplify_ternary(node);

    case OP_NEG: case OP_COMP: case OP_LNEG:
        return try_simplify_unop(node);

    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        return try_simplify_binop(node);

    default:
        return node;
    }
}

/* ----- Dead-code elimination ----------------------------------------- */

/* True if `n` is an AST_LITERAL with non-zero integer value. Used to
   identify always-true conds. */
static int literal_truthy(Node *n)
{
    if (!n || n->ast_type != AST_LITERAL) return -1;
    if (!n->type) return ((int64_t)n->zval != 0);
    Kind k = n->type->kind;
    if (k == KIND_INT || k == KIND_CHAR || k == KIND_SHORT ||
        k == KIND_LONG || k == KIND_LONGLONG) {
        return ((int64_t)n->zval != 0);
    }
    return -1;
}

/* True if `n` ends control flow at the top level — return, goto, or a
   compound whose last statement does. Used to drop subsequent dead
   siblings. */
static int unconditionally_exits(Node *n)
{
    if (!n) return 0;
    switch (n->ast_type) {
    case AST_RETURN:
    case AST_JUMP:
        return 1;
    case AST_COMPOUND_STMT: {
        int len = (int)array_len(n->stmts);
        if (len == 0) return 0;
        return unconditionally_exits(array_get_byindex(n->stmts, len - 1));
    }
    default:
        return 0;
    }
}

static void dc_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = ast_dead_code(n);
    if (r != n) ast_slot_set(slot, r);
}

/* #231: rewrite `a = a op b` → `a op= b` when `a` is a side-effect-
   free lvalue (AST_LOCAL_VAR / AST_GLOBAL_VAR). Routes the walker
   through cg2_compound_assign, which has the save-address fastpath
   (#146/#147) and avoids re-walking the LHS expression as part of
   the RHS evaluation. Composes with #237 — both fastpaths produce
   the same shape for bare local long, so this just extends the
   benefit to integer / global / etc. */

static int binop_to_compound_op(int op)
{
    switch (op) {
    case OP_ADD:  return OP_AADD;
    case OP_SUB:  return OP_ASUB;
    case OP_MULT: return OP_AMULT;
    case OP_DIV:  return OP_ADIV;
    case OP_MOD:  return OP_AMOD;
    case OP_AND:  return OP_AAND;
    case OP_OR:   return OP_AOR;
    case OP_XOR:  return OP_AXOR;
    case OP_SSHL: case OP_USHL: return OP_ASSHL;
    case OP_SSHR: case OP_USHR: return OP_ASSHR;
    default: return -1;
    }
}

/* OP_ASSIGN's LHS is a bare AST_LOCAL_VAR / AST_GLOBAL_VAR (the
   address). The matching rvalue use on the RHS must be
   `OP_DEREF(bare lvalue)` — that's how the parser builds reads of
   simple variables. Reject anything else (including bare lvalue
   appearing directly on the RHS) so the rewrite is only applied
   when we're certain about the shape both sides take. */
static int bare_lvalue_same(Node *lhs, Node *rhs_use)
{
    if (!lhs || !rhs_use) return 0;
    if (rhs_use->ast_type != OP_DEREF || !rhs_use->operand) return 0;
    Node *peeled = rhs_use->operand;
    if (lhs->ast_type != peeled->ast_type) return 0;
    if (lhs->ast_type != AST_LOCAL_VAR && lhs->ast_type != AST_GLOBAL_VAR) return 0;
    return lhs->sym && lhs->sym == peeled->sym;
}

static void ca_visit(const AstSlot *slot, void *ctx);

Node *ast_compoundify_assign(Node *node)
{
    if (!node) return NULL;
    ast_for_each_child(node, ca_visit, NULL);

    if (node->ast_type == OP_ASSIGN && node->left && node->right) {
        Node *rhs = node->right;
        int compound_op = binop_to_compound_op(rhs->ast_type);
        if (compound_op != -1 && rhs->left && rhs->right
            && bare_lvalue_same(node->left, rhs->left)) {
            /* Rewrite in place. cg2_compound_assign expects the
               LHS to be `(deref addr-expr)` (matching the parser-
               built compound-assign shape), so take the BINOP's
               left — which already is `(deref bare_lvalue)`. */
            node->ast_type = compound_op;
            node->left = rhs->left;
            node->right = rhs->right;
        }
    }
    return node;
}

static void ca_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = ast_compoundify_assign(n);
    if (r != n) ast_slot_set(slot, r);
}

Node *ast_dead_code(Node *node)
{
    if (!node) return NULL;
    ast_for_each_child(node, dc_visit, NULL);

    switch (node->ast_type) {
    case AST_IF:
    case AST_TERNARY: {
        /* Peel a single OP_DEREF wrap that rvalue() may have added. */
        Node *cinner = node->cond;
        while (cinner && cinner->ast_type == OP_DEREF) cinner = cinner->operand;
        int t = literal_truthy(cinner);
        if (t == 1 && node->then) return node->then;
        if (t == 0) {
            if (node->els) return node->els;
            /* if(0) with no else: empty noop. Represent as empty
               compound to keep the statement-list shape. */
            Node *empty = calloc(1, sizeof(Node));
            empty->ast_type = AST_COMPOUND_STMT;
            empty->stmts = array_init(NULL);
            return empty;
        }
        return node;
    }

    case AST_COMPOUND_STMT: {
        /* Drop siblings between an unconditional exit (return/goto) and
           the next AST_LABEL — they are unreachable. A LABEL re-enters
           live flow because some other jump may target it; we can't tell
           from the local context, so we conservatively assume it does.
           The threading pass will later drop labels with zero incoming
           jumps. */
        int n = (int)array_len(node->stmts);
        int dead = 0;
        for (int i = 0; i < n; i++) {
            Node *s = array_get_byindex(node->stmts, i);
            if (s && s->ast_type == AST_LABEL) dead = 0;
            if (dead) {
                array_set_byindex(node->stmts, i, NULL);
                continue;
            }
            if (s && unconditionally_exits(s)) dead = 1;
        }
        return node;
    }

    default:
        return node;
    }
}

/* ----- Jump threading + dead-label removal --------------------------- */

/*
 * Three local rewrites over AST_LABEL / AST_JUMP / AST_SWITCH_CASE,
 * iterated to fixed point:
 *
 *  (1) Trampoline aliasing.  A label whose immediate body is a single
 *      unconditional `goto L'` is a trampoline. All jumps to it are
 *      redirected to L'. Iterating handles `L1 -> L2 -> L3` chains.
 *
 *  (2) Jump-to-next.  A `goto L` whose immediate (skipping NULLs)
 *      successor in the same compound is `LABEL L` is a no-op; drop the
 *      goto.
 *
 *  (3) Unreferenced-label removal.  After (1) and (2), any LABEL whose
 *      use count is zero is dead; NULL it out.
 *
 * Use counts come from a single tree-walk that increments per
 * AST_JUMP and per AST_SWITCH_CASE.sw_label.
 *
 * Limited to label IDs that fit in a small dense table — sccz80 labels
 * are getlabel()-monotonic, often well under 1000 per function.
 */

typedef struct lbl_entry {
    int  label;
    int  uses;
    int  alias;     /* -1 if none, else target label after chain-resolve */
} lbl_entry;

typedef struct lbl_table {
    lbl_entry *entries;
    int n, cap;
} lbl_table;

static void lbl_init(lbl_table *t) { t->entries = NULL; t->n = 0; t->cap = 0; }
static void lbl_free(lbl_table *t) { free(t->entries); t->entries = NULL; t->n = 0; t->cap = 0; }

static lbl_entry *lbl_find(lbl_table *t, int label)
{
    for (int i = 0; i < t->n; i++) if (t->entries[i].label == label) return &t->entries[i];
    return NULL;
}

static lbl_entry *lbl_intern(lbl_table *t, int label)
{
    lbl_entry *e = lbl_find(t, label);
    if (e) return e;
    if (t->n == t->cap) {
        t->cap = t->cap ? t->cap * 2 : 8;
        t->entries = realloc(t->entries, sizeof(lbl_entry) * t->cap);
    }
    t->entries[t->n].label = label;
    t->entries[t->n].uses = 0;
    t->entries[t->n].alias = -1;
    return &t->entries[t->n++];
}

static void thread_count_uses(Node *node, lbl_table *t);

static void tcu_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (n) thread_count_uses(n, (lbl_table *)ctx);
}

static void thread_count_uses(Node *node, lbl_table *t)
{
    if (!node) return;
    switch (node->ast_type) {
    case AST_LABEL:
        lbl_intern(t, node->label);   /* register so we can drop unused */
        break;
    case AST_JUMP:
        lbl_intern(t, node->label)->uses++;
        break;
    case AST_SWITCH_CASE:
        lbl_intern(t, node->sw_label)->uses++;
        break;
    case AST_SWITCH:
        if (node->sw_default_label)
            lbl_intern(t, node->sw_default_label)->uses++;
        if (node->sw_exit_label)
            lbl_intern(t, node->sw_exit_label)->uses++;
        break;
    default:
        break;
    }
    ast_for_each_child(node, tcu_visit, t);
}

/* Find the next non-NULL stmt in a compound, starting from idx. Returns
   the array index, or -1 if none. */
static int next_live_idx(array *stmts, int idx)
{
    int n = (int)array_len(stmts);
    for (int i = idx; i < n; i++) {
        if (array_get_byindex(stmts, i) != NULL) return i;
    }
    return -1;
}

/* Identify trampoline labels in this compound: a LABEL L immediately
   followed (skipping NULLs and other consecutive LABELs) by a single
   AST_JUMP L'. All such labels alias to L'. */
static void thread_find_trampolines_compound(array *stmts, lbl_table *t)
{
    int n = (int)array_len(stmts);
    for (int i = 0; i < n; i++) {
        Node *s = array_get_byindex(stmts, i);
        if (!s || s->ast_type != AST_LABEL) continue;
        /* Walk past consecutive labels (they share the same successor). */
        int j = i;
        while (j < n) {
            Node *t2 = array_get_byindex(stmts, j);
            if (!t2) { j++; continue; }
            if (t2->ast_type != AST_LABEL) break;
            j++;
        }
        if (j >= n) break;
        Node *succ = array_get_byindex(stmts, j);
        if (succ && succ->ast_type == AST_JUMP) {
            int target = succ->label;
            for (int k = i; k < j; k++) {
                Node *l = array_get_byindex(stmts, k);
                if (!l || l->ast_type != AST_LABEL) continue;
                if (l->label == target) continue;   /* self-trampoline */
                lbl_entry *e = lbl_intern(t, l->label);
                e->alias = target;
            }
        }
        i = j - 1;   /* outer for++ moves past last consumed label */
    }
}

static void thread_find_trampolines(Node *node, lbl_table *t);

static void tft_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (n) thread_find_trampolines(n, (lbl_table *)ctx);
}

static void thread_find_trampolines(Node *node, lbl_table *t)
{
    if (!node) return;
    if (node->ast_type == AST_COMPOUND_STMT)
        thread_find_trampolines_compound(node->stmts, t);
    ast_for_each_child(node, tft_visit, t);
}

/* Resolve alias chains. A label aliases through any number of
   trampolines until a non-aliased label or a cycle is reached. */
static int resolve_alias(lbl_table *t, int label, int depth)
{
    if (depth > 32) return label;  /* cycle guard */
    lbl_entry *e = lbl_find(t, label);
    if (!e || e->alias < 0 || e->alias == label) return label;
    int dest = resolve_alias(t, e->alias, depth + 1);
    e->alias = dest;
    return dest;
}

static void thread_resolve_all_aliases(lbl_table *t)
{
    for (int i = 0; i < t->n; i++) {
        if (t->entries[i].alias >= 0)
            t->entries[i].alias = resolve_alias(t, t->entries[i].label, 0);
    }
}

static int thread_apply_aliases(Node *node, lbl_table *t);

typedef struct apply_ctx {
    lbl_table *t;
    int changed;
} apply_ctx;

static void taa_visit(const AstSlot *slot, void *ctx)
{
    apply_ctx *ac = (apply_ctx *)ctx;
    Node *n = ast_slot_get(slot);
    if (n && thread_apply_aliases(n, ac->t)) ac->changed = 1;
}

/* Apply alias-redirect to every AST_JUMP, AST_SWITCH_CASE.sw_label and
   AST_SWITCH.sw_default_label / sw_exit_label. Returns 1 if at least
   one redirect happened in this subtree. */
static int thread_apply_aliases(Node *node, lbl_table *t)
{
    if (!node) return 0;
    int changed = 0;
    switch (node->ast_type) {
    case AST_JUMP: {
        lbl_entry *e = lbl_find(t, node->label);
        if (e && e->alias >= 0 && e->alias != node->label) {
            node->label = e->alias;
            changed = 1;
        }
        break;
    }
    case AST_SWITCH_CASE: {
        lbl_entry *e = lbl_find(t, node->sw_label);
        if (e && e->alias >= 0 && e->alias != node->sw_label) {
            node->sw_label = e->alias;
            changed = 1;
        }
        break;
    }
    case AST_SWITCH: {
        if (node->sw_default_label) {
            lbl_entry *e = lbl_find(t, node->sw_default_label);
            if (e && e->alias >= 0 && e->alias != node->sw_default_label) {
                node->sw_default_label = e->alias;
                changed = 1;
            }
        }
        if (node->sw_exit_label) {
            lbl_entry *e = lbl_find(t, node->sw_exit_label);
            if (e && e->alias >= 0 && e->alias != node->sw_exit_label) {
                node->sw_exit_label = e->alias;
                changed = 1;
            }
        }
        break;
    }
    default:
        break;
    }
    apply_ctx ac = { t, 0 };
    ast_for_each_child(node, taa_visit, &ac);
    return changed | ac.changed;
}

/* Locate the effective last live statement reachable through any number
   of trailing nested compounds — sccz80 builds `continue;` and `break;`
   as a one-element AST_COMPOUND_STMT around the goto, so the JUMP is
   sometimes one level below the LABEL it precedes. */
typedef struct last_loc {
    array *stmts;     /* parent array, or NULL if the node is itself top */
    int    idx;       /* index in `stmts` */
    Node  *node;
} last_loc;

static last_loc effective_last(Node *n)
{
    last_loc r = { NULL, -1, n };
    while (n && n->ast_type == AST_COMPOUND_STMT) {
        int len = (int)array_len(n->stmts);
        Node *last = NULL;
        int last_idx = -1;
        for (int i = len - 1; i >= 0; i--) {
            Node *s = array_get_byindex(n->stmts, i);
            if (s) { last = s; last_idx = i; break; }
        }
        if (!last) return r;
        r.stmts = n->stmts;
        r.idx = last_idx;
        r.node = last;
        n = last;
    }
    return r;
}

/* Drop `goto L` immediately followed (skipping NULLs) by `LABEL L`,
   including the case where the goto is the last live element of a
   nested compound (continue/break/return scaffolding). */
static int thread_drop_jump_to_next_compound(array *stmts)
{
    int changed = 0;
    int n = (int)array_len(stmts);
    for (int i = 0; i < n; i++) {
        Node *s = array_get_byindex(stmts, i);
        if (!s) continue;
        last_loc ll = effective_last(s);
        if (!ll.node || ll.node->ast_type != AST_JUMP) continue;
        int j = next_live_idx(stmts, i + 1);
        if (j < 0) continue;
        Node *nx = array_get_byindex(stmts, j);
        if (nx && nx->ast_type == AST_LABEL && nx->label == ll.node->label) {
            if (ll.stmts) array_set_byindex(ll.stmts, ll.idx, NULL);
            else          array_set_byindex(stmts, i, NULL);
            changed = 1;
        }
    }
    return changed;
}

static int thread_drop_jump_to_next(Node *node);

static void tdjn_visit(const AstSlot *slot, void *ctx)
{
    int *changed = (int *)ctx;
    Node *n = ast_slot_get(slot);
    if (n && thread_drop_jump_to_next(n)) *changed = 1;
}

static int thread_drop_jump_to_next(Node *node)
{
    if (!node) return 0;
    int changed = 0;
    if (node->ast_type == AST_COMPOUND_STMT)
        changed |= thread_drop_jump_to_next_compound(node->stmts);
    ast_for_each_child(node, tdjn_visit, &changed);
    return changed;
}

static int thread_drop_unused_labels(Node *node, lbl_table *t);

typedef struct dul_ctx {
    lbl_table *t;
    int changed;
} dul_ctx;

static void tdul_visit(const AstSlot *slot, void *ctx)
{
    dul_ctx *dc = (dul_ctx *)ctx;
    Node *n = ast_slot_get(slot);
    if (n && thread_drop_unused_labels(n, dc->t)) dc->changed = 1;
}

/* NULL out every AST_LABEL whose use count is 0 in the current tree. */
static int thread_drop_unused_labels(Node *node, lbl_table *t)
{
    if (!node) return 0;
    int changed = 0;
    if (node->ast_type == AST_COMPOUND_STMT) {
        int n = (int)array_len(node->stmts);
        for (int i = 0; i < n; i++) {
            Node *s = array_get_byindex(node->stmts, i);
            if (s && s->ast_type == AST_LABEL) {
                lbl_entry *e = lbl_find(t, s->label);
                if (e && e->uses == 0) {
                    array_set_byindex(node->stmts, i, NULL);
                    changed = 1;
                }
            }
        }
    }
    dul_ctx dc = { t, 0 };
    ast_for_each_child(node, tdul_visit, &dc);
    return changed | dc.changed;
}

Node *ast_thread_jumps(Node *root)
{
    if (!root) return NULL;
    /* Iterate to fixed point, capped at a few rounds — each round can
       create new opportunities (a redirected jump may unmask a dead
       label, dropping which may unmask another trampoline). */
    for (int iter = 0; iter < 4; iter++) {
        lbl_table t;
        lbl_init(&t);
        thread_count_uses(root, &t);
        thread_find_trampolines(root, &t);
        thread_resolve_all_aliases(&t);
        int changed = 0;
        changed |= thread_apply_aliases(root, &t);
        /* Re-count after alias rewrite — old targets lost uses,
           new targets gained them. */
        for (int i = 0; i < t.n; i++) t.entries[i].uses = 0;
        thread_count_uses(root, &t);
        changed |= thread_drop_jump_to_next(root);
        /* Re-count after jump-to-next removal. */
        for (int i = 0; i < t.n; i++) t.entries[i].uses = 0;
        thread_count_uses(root, &t);
        changed |= thread_drop_unused_labels(root, &t);
        lbl_free(&t);
        if (!changed) break;
    }
    return root;
}

/* ----- Common subexpression elimination via value numbering ---------- */

/*
 * Conservative within-basic-block CSE that piggy-backs on locals the
 * user has already declared. When `int b = expr;` is parsed, we record
 * (expr → b). A later occurrence of an SEF expression equal to `expr`
 * is replaced with `OP_DEREF(LOCAL_VAR b)` — no synthesized symbol,
 * no stack-allocation surgery, no parser state mutation. Same for
 * `b = expr;` (top-level assignment to a simple local).
 *
 * Invalidations are conservative:
 *   - assignment / pre/post-step / address-of of a local: drop env
 *     entries whose recorded expr mentions that local.
 *   - function call / inline asm anywhere in a stmt: clear env (could
 *     write through pointers, modify globals, etc.).
 *   - if / ternary / switch / loop / label: clear env (we do not
 *     reason across alternative paths).
 *
 * Eligibility for *being recorded*: SEF AND "interesting" — must
 * contain at least one binary op or compound deref. Pure
 * `OP_DEREF(LOCAL_VAR)` etc. are not worth a CSE entry (they would
 * substitute one read with another read of the same width).
 */

typedef struct cse_entry {
    Node   *expr;
    SYMBOL *sym;
} cse_entry;

typedef struct cse_env {
    cse_entry *entries;
    int n, cap;
} cse_env;

#define CSE_MAX_ENTRIES 32

static void cse_env_init(cse_env *e)  { e->entries = NULL; e->n = 0; e->cap = 0; }
static void cse_env_free(cse_env *e)  { free(e->entries); e->entries = NULL; e->n = 0; e->cap = 0; }
static void cse_env_clear(cse_env *e) { e->n = 0; }

static void cse_env_clone(cse_env *dst, const cse_env *src)
{
    dst->n = src->n;
    dst->cap = src->n;
    dst->entries = src->n ? malloc(sizeof(cse_entry) * src->n) : NULL;
    if (src->n) memcpy(dst->entries, src->entries, sizeof(cse_entry) * src->n);
}

static void cse_env_add(cse_env *e, Node *expr, SYMBOL *sym)
{
    if (e->n >= CSE_MAX_ENTRIES) {
        /* Drop the oldest. The locality assumption is that recent
           bindings are the most likely to be reused. */
        memmove(e->entries, e->entries + 1, sizeof(cse_entry) * (e->n - 1));
        e->n--;
    }
    if (e->n == e->cap) {
        e->cap = e->cap ? e->cap * 2 : 4;
        e->entries = realloc(e->entries, sizeof(cse_entry) * e->cap);
    }
    e->entries[e->n].expr = expr;
    e->entries[e->n].sym  = sym;
    e->n++;
}

static SYMBOL *cse_env_lookup(cse_env *e, Node *expr)
{
    for (int i = 0; i < e->n; i++) {
        if (nodes_equivalent(e->entries[i].expr, expr)) return e->entries[i].sym;
    }
    return NULL;
}

typedef struct mentions_ctx {
    SYMBOL *sym;
    int found;
} mentions_ctx;

static int subtree_mentions(Node *n, SYMBOL *sym);

static void mentions_visit(const AstSlot *slot, void *ctx)
{
    mentions_ctx *mc = (mentions_ctx *)ctx;
    if (mc->found) return;
    Node *n = ast_slot_get(slot);
    if (n && subtree_mentions(n, mc->sym)) mc->found = 1;
}

/* True if `n` mentions sym anywhere in its subtree. */
static int subtree_mentions(Node *n, SYMBOL *sym)
{
    if (!n) return 0;
    if ((n->ast_type == AST_LOCAL_VAR || n->ast_type == AST_GLOBAL_VAR)
        && n->sym == sym)
        return 1;
    mentions_ctx mc = { sym, 0 };
    ast_for_each_child(n, mentions_visit, &mc);
    return mc.found;
}

static void cse_env_invalidate_sym(cse_env *e, SYMBOL *sym)
{
    int w = 0;
    for (int i = 0; i < e->n; i++) {
        if (subtree_mentions(e->entries[i].expr, sym)) continue;
        if (e->entries[i].sym == sym) continue;     /* drop self-binding too */
        if (w != i) e->entries[w] = e->entries[i];
        w++;
    }
    e->n = w;
}

/* "Interesting" enough to record. SEF is checked separately. */
static int is_cse_interesting(Node *n)
{
    if (!n) return 0;
    switch (n->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        return 0;
    case OP_DEREF: case AST_DEREF:
        /* Only worth it if the deref target is non-trivial (array index,
           pointer arithmetic). Plain OP_DEREF(LOCAL_VAR) is just a
           load — no win from CSE'ing it. */
        if (n->operand && (n->operand->ast_type == AST_LOCAL_VAR
                        || n->operand->ast_type == AST_GLOBAL_VAR))
            return 0;
        return 1;
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST:
        return 1;
    default:
        return 0;
    }
}

/* #261: rough z80 cycle cost estimate for an AST subtree, used by
   cse-synth's hoist gate. Each op is annotated with a representative
   plain-z80 cycle count for "load operand(s), apply op, leave result
   in HL/DE:HL". Numbers are deliberately conservative ballpark figures
   — the comparison only needs to be DIRECTIONALLY correct (cheap-load
   gets a low number, expensive-helper gets a high number).
   The cost is symmetric across cpus that don't have native sp+d (z80,
   8080, 8085, gbz80) where the regression hurts most; on Rabbit/KC160/
   ez80 the load cost is lower but so is the recompute, and the cost
   model's comparison is still in the right direction. */
static int cse_est_cost(Node *n)
{
    if (!n) return 0;
    switch (n->ast_type) {
    case AST_LITERAL:    return 7;
    case AST_STR_LIT:    return 7;
    case AST_LOCAL_VAR:  return 30;
    case AST_GLOBAL_VAR: return 25;
    case OP_DEREF: case AST_DEREF:
        return 50 + cse_est_cost(n->operand);
    case OP_ADDR: case AST_ADDR:
        return 11 + cse_est_cost(n->operand);
    case OP_NEG: case OP_COMP: case OP_LNEG:
        return 11 + cse_est_cost(n->operand);
    case OP_CAST:
        return 5 + cse_est_cost(n->operand);
    case OP_ADD: case OP_SUB:
        return 15 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case OP_AND: case OP_OR: case OP_XOR:
        return 60 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case OP_MULT:
        return 200 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case OP_DIV: case OP_MOD:
        return 400 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case OP_SSHL: case OP_USHL: case OP_SSHR: case OP_USHR: {
        int base = 100;
        if (n->right && n->right->ast_type == AST_LITERAL) {
            int amt = (int)n->right->zval;
            if (amt < 0) amt = -amt;
            if (amt > 16) amt = 16;
            base = 12 + 5 * amt;
        }
        return base + cse_est_cost(n->left);
    }
    case OP_EQ: case OP_NE: case OP_LT: case OP_LE: case OP_GT: case OP_GE:
        return 30 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case OP_OROR: case OP_ANDAND:
        return 25 + cse_est_cost(n->left) + cse_est_cost(n->right);
    case AST_FUNC_CALL: case AST_FUNCPTR_CALL:
        return 500;
    default:
        return 20;
    }
}

/* Costs for hoisting a candidate into a `1cse_<N>` synth temp:
   store_cost is one store at hoist point; load_cost is per use site.
   Both are conservative averages for sp-relative temps that often
   live deep in the frame (cse-synth's always_interferes=1 forces
   them out of sp+0/sp+2). If recompute_total > hoist_total the
   hoist is profitable; otherwise the temp's load+pressure cost
   exceeds what we save by not recomputing. */
#define CSE_STORE_COST 35
#define CSE_LOAD_COST  55

static int cse_hoist_profitable(Node *cand, int count)
{
    if (count < 2) return 0;
    int c = cse_est_cost(cand);
    int recompute = c * count;
    int hoist     = c + CSE_STORE_COST + count * CSE_LOAD_COST;
    return (recompute - hoist) > 0;
}

static Node *cse_make_lv_deref(SYMBOL *sym, Type *type)
{
    Node *lv = calloc(1, sizeof(Node));
    lv->ast_type = AST_LOCAL_VAR;
    lv->sym = sym;
    /* The lv carries the sym's actual storage type (which may have been
       decayed by make_licm_stub_sym from array → pointer). The outer
       deref keeps the original expression type so parent nodes see the
       same shape they did before substitution. For non-decayed cases
       (CSE), sym->ctype == type and the two coincide. */
    lv->type = sym->ctype ? sym->ctype : type;
    Node *deref = calloc(1, sizeof(Node));
    deref->ast_type = OP_DEREF;
    deref->operand = lv;
    deref->type = type;
    return deref;
}

/* Forward decl for the recursive walker. */
static Node *cse_walk(Node *node, cse_env *env, int *had_break);

/* Try to substitute `node` with a lookup hit. Returns the replacement
   or NULL. Does not mutate `node`. */
static Node *cse_try_substitute(Node *node, cse_env *env)
{
    if (!node) return NULL;
    if (!is_cse_interesting(node)) return NULL;
    if (!is_side_effect_free(node)) return NULL;
    SYMBOL *sym = cse_env_lookup(env, node);
    if (!sym) return NULL;
    return cse_make_lv_deref(sym, node->type);
}

/* Walk an LHS for purposes of CSE invalidation. Returns the modified
   LHS (CSE substitution may apply within sub-lvalue expressions like
   `arr[expr]`). Sets `*lhs_local` to the SYMBOL of a top-level local
   lvalue (for `OP_DEREF(LOCAL_VAR sym)`), or NULL if the lvalue is
   compound (array index, pointer deref) and we should treat it as
   "unknown — clear env"). */
static Node *cse_walk_lvalue(Node *lhs, cse_env *env, SYMBOL **lhs_local, int *unknown)
{
    *lhs_local = NULL;
    *unknown = 0;
    if (!lhs) return lhs;
    /* Simple local lvalue: in sccz80 the assignment target appears
       either as bare AST_LOCAL_VAR (`a = ...`) or as OP_DEREF(LV) for
       compound forms. Either way the invalidation target is the
       contained sym. */
    if (lhs->ast_type == AST_LOCAL_VAR) {
        *lhs_local = lhs->sym;
        return lhs;
    }
    if (lhs->ast_type == OP_DEREF
        && lhs->operand && lhs->operand->ast_type == AST_LOCAL_VAR) {
        *lhs_local = lhs->operand->sym;
        return lhs;
    }
    /* Globals: bare AST_GLOBAL_VAR is a simple global write — we don't
       CSE-track globals on the LHS but invalidating the (matching) sym
       still matters because env may carry (g+1, somelocal) entries. */
    if (lhs->ast_type == AST_GLOBAL_VAR) {
        *lhs_local = lhs->sym;
        return lhs;
    }
    /* Defensive: if some earlier pass corrupted the LHS into a leaf
       form (literal etc.), don't crash trying to walk it as a binary
       expression — the union overlap would deref bit patterns. Just
       clear the env and bail. */
    switch (lhs->ast_type) {
    case AST_LITERAL: case AST_STR_LIT: case AST_LABEL: case AST_JUMP:
    case AST_UNDECL: case AST_INIT_STATIC: case AST_ASM:
        *unknown = 1;
        return lhs;
    default: break;
    }
    /* Compound lvalue — array index, deref of pointer. Walk for CSE
       substitution within the sub-expression but flag the env for
       conservative clear (we don't know what was modified). */
    int dummy = 0;
    if (lhs->left)    lhs->left    = cse_walk(lhs->left, env, &dummy);
    if (lhs->right)   lhs->right   = cse_walk(lhs->right, env, &dummy);
    if (lhs->operand) lhs->operand = cse_walk(lhs->operand, env, &dummy);
    *unknown = 1;
    return lhs;
}

static Node *cse_walk(Node *node, cse_env *env, int *had_break)
{
    if (!node) return NULL;

    /* Pre-substitution: largest match first. */
    Node *sub = cse_try_substitute(node, env);
    if (sub) return sub;

    switch (node->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_INIT_STATIC:
        return node;

    case AST_LABEL:
        /* See note in prop_walk: label targets can join state from
           multiple incoming edges, including back-jumps. Clear. */
        cse_env_clear(env);
        return node;

    case AST_ASM:
        cse_env_clear(env);
        return node;

    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(node->args); i++) {
            Node *a = array_get_byindex(node->args, i);
            Node *r = cse_walk(a, env, had_break);
            if (r != a) array_set_byindex(node->args, i, r);
        }
        if (node->callee) node->callee = cse_walk(node->callee, env, had_break);
        cse_env_clear(env);
        return node;

    case AST_RETURN:
        if (node->retval) node->retval = cse_walk(node->retval, env, had_break);
        return node;

    case AST_COMPOUND_STMT: {
        int n = (int)array_len(node->stmts);
        for (int i = 0; i < n; i++) {
            Node *s = array_get_byindex(node->stmts, i);
            Node *r = cse_walk(s, env, had_break);
            if (r != s) array_set_byindex(node->stmts, i, r);
        }
        return node;
    }

    case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(node->stmts); i++) {
            Node *e = array_get_byindex(node->stmts, i);
            Node *r = cse_walk(e, env, had_break);
            if (r != e) array_set_byindex(node->stmts, i, r);
        }
        return node;

    case AST_IF:
    case AST_TERNARY: {
        if (node->cond) node->cond = cse_walk(node->cond, env, had_break);
        cse_env then_env, else_env;
        cse_env_clone(&then_env, env);
        cse_env_clone(&else_env, env);
        if (node->then) node->then = cse_walk(node->then, &then_env, had_break);
        if (node->els)  node->els  = cse_walk(node->els,  &else_env, had_break);
        cse_env_free(&then_env);
        cse_env_free(&else_env);
        cse_env_clear(env);
        return node;
    }

    case AST_SWITCH: {
        if (node->sw_expr) node->sw_expr = cse_walk(node->sw_expr, env, had_break);
        if (node->sw_body) {
            cse_env body_env;
            cse_env_clone(&body_env, env);
            node->sw_body = cse_walk(node->sw_body, &body_env, had_break);
            cse_env_free(&body_env);
        }
        cse_env_clear(env);
        return node;
    }

    case AST_SWITCH_CASE:
        if (node->sw_value) node->sw_value = cse_walk(node->sw_value, env, had_break);
        return node;

    case AST_DECL: {
        /* Walk the initializer so substitutions within it apply. Then,
           if it's interesting+SEF, record (init, decl_sym). */
        if (node->declvar) node->declvar = cse_walk(node->declvar, env, had_break);
        if (node->sym && node->declvar
            && is_cse_interesting(node->declvar)
            && is_side_effect_free(node->declvar)
            && (!node->sym->ctype || !node->sym->ctype->isvolatile)) {
            cse_env_add(env, node->declvar, node->sym);
        }
        return node;
    }

    case AST_CRITICAL:
        if (node->operand) node->operand = cse_walk(node->operand, env, had_break);
        cse_env_clear(env);   /* di/ei wrapper — opaque */
        return node;

    case OP_ADDR: case AST_ADDR:
        if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
            && node->operand->sym) {
            cse_env_invalidate_sym(env, node->operand->sym);
        }
        if (node->operand) node->operand = cse_walk(node->operand, env, had_break);
        return node;

    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
        if (node->operand) node->operand = cse_walk(node->operand, env, had_break);
        if (node->operand && node->operand->ast_type == OP_DEREF
            && node->operand->operand
            && node->operand->operand->ast_type == AST_LOCAL_VAR
            && node->operand->operand->sym) {
            cse_env_invalidate_sym(env, node->operand->operand->sym);
        } else if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
                   && node->operand->sym) {
            cse_env_invalidate_sym(env, node->operand->sym);
        } else {
            cse_env_clear(env);   /* unknown — bail */
        }
        return node;

    case OP_DEREF: case AST_DEREF:
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST: case OP_SIZEOF:
        if (node->operand) node->operand = cse_walk(node->operand, env, had_break);
        /* Post-substitution: children may have changed shape so a
           larger match could now hit. */
        sub = cse_try_substitute(node, env);
        if (sub) return sub;
        return node;

    case OP_ASSIGN: {
        /* Walk RHS first so it sees the OLD env; then walk LHS and
           apply invalidation. Recording the new (RHS, lhs_sym) binding
           comes last. */
        if (node->right) node->right = cse_walk(node->right, env, had_break);
        SYMBOL *lhs_sym = NULL;
        int unknown = 0;
        if (node->left) node->left = cse_walk_lvalue(node->left, env, &lhs_sym, &unknown);
        if (unknown) {
            cse_env_clear(env);
        } else if (lhs_sym) {
            cse_env_invalidate_sym(env, lhs_sym);
            if (node->right
                && is_cse_interesting(node->right)
                && is_side_effect_free(node->right)
                && lhs_sym->ctype && !lhs_sym->ctype->isvolatile) {
                cse_env_add(env, node->right, lhs_sym);
            }
        }
        return node;
    }

    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL: {
        if (node->right) node->right = cse_walk(node->right, env, had_break);
        SYMBOL *lhs_sym = NULL;
        int unknown = 0;
        if (node->left) node->left = cse_walk_lvalue(node->left, env, &lhs_sym, &unknown);
        if (unknown)         cse_env_clear(env);
        else if (lhs_sym)    cse_env_invalidate_sym(env, lhs_sym);
        return node;
    }

    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        if (node->left)  node->left  = cse_walk(node->left, env, had_break);
        if (node->right) node->right = cse_walk(node->right, env, had_break);
        sub = cse_try_substitute(node, env);
        if (sub) return sub;
        return node;

    default:
        if (node->left)    node->left    = cse_walk(node->left, env, had_break);
        if (node->right)   node->right   = cse_walk(node->right, env, had_break);
        if (node->operand) node->operand = cse_walk(node->operand, env, had_break);
        return node;
    }
}

Node *ast_cse(Node *root)
{
    if (!root) return NULL;
    cse_env env;
    cse_env_init(&env);
    int dummy = 0;
    Node *r = cse_walk(root, &env, &dummy);
    cse_env_free(&env);
    return r;
}

/* ----- CSE temp synthesis (second-stage) ----------------------------- */

/*
 * Catches shared SEF subexpressions that have no existing binding in
 * the user's source. Per BB segment in a compound:
 *   1. Walk all stmts collecting every SEF "interesting" subtree.
 *   2. Cluster by structural equivalence. A cluster of size ≥2 is a
 *      synthesis candidate IF every var the expr reads is unmutated
 *      across the segment (calls/asm/labels/etc. already segment the
 *      BB boundary).
 *   3. Synthesize a stub SYMBOL `1cse_<n>`, deep-clone the canonical
 *      occurrence as the AST_DECL's initializer, insert the decl at
 *      segment start, replace every occurrence with `OP_DEREF(LV sym)`.
 *
 * Stub SYMBOL: not added to symtab/locptr. Print walker only reads
 * `sym->name`. Subsequent opt passes see it as a normal STKLOC sym;
 * codegen-from-AST (when it resumes) will need to walk synthesized
 * AST_DECLs and allocate stack space for them — at which point the
 * stub is upgraded to a real addloc-backed entry.
 */

static int cse_temp_seq = 0;

static SYMBOL *cse_make_stub_sym(Type *type)
{
    SYMBOL *s = calloc(1, sizeof(SYMBOL));
    /* Leading digit means the name can never collide with a C
       identifier — every name with a digit prefix is internal-only. */
    snprintf(s->name, sizeof(s->name), "1cse_%d", cse_temp_seq++);
    /* Decay arrays to pointers — the hoisted expression's "value" is
       the array's first-element address, which fits a 2-byte pointer
       slot. Storing it as KIND_ARRAY would ask the backend to allocate
       a full array temp (which neither IR build nor the walker can do
       for a synthesized local). Same rationale as make_licm_stub_sym. */
    if (type && type->kind == KIND_ARRAY && type->ptr) {
        type = make_pointer(type->ptr);
    }
    s->ident = ID_VARIABLE;
    s->type = type ? type->kind : KIND_INT;
    s->ctype = type;
    s->storage = STKLOC;
    return s;
}

/* Deep-clone an AST sub-tree. Used to give the synthesized AST_DECL its
   own copy of the canonical expr so subsequent replacement passes can
   safely rewrite the original occurrences without disturbing the decl. */
static Node *clone_subtree(Node *n)
{
    if (!n) return NULL;
    Node *c = calloc(1, sizeof(Node));
    *c = *n;   /* copy scalar/union fields verbatim */
    /* Recurse for the union variant in use. */
    switch (n->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_LABEL:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_INIT_STATIC:
    case AST_ASM:
        return c;
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST: case OP_SIZEOF:
    case OP_DEREF: case AST_DEREF:
    case OP_ADDR:  case AST_ADDR:
        c->operand = clone_subtree(n->operand);
        return c;
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        c->left  = clone_subtree(n->left);
        c->right = clone_subtree(n->right);
        return c;
    default:
        /* Conservative: clone whatever's there. Caller only feeds us
           SEF interesting subtrees so we shouldn't see exotic kinds. */
        if (n->left)    c->left    = clone_subtree(n->left);
        if (n->right)   c->right   = clone_subtree(n->right);
        if (n->operand) c->operand = clone_subtree(n->operand);
        return c;
    }
}

typedef struct cse_replace_ctx {
    Node *target;
    SYMBOL *sym;
    Type *ttype;
} cse_replace_ctx;

static Node *cse_replace_walk(Node *node, Node *target, SYMBOL *sym, Type *ttype);

static void cse_replace_visit(const AstSlot *slot, void *ctx)
{
    cse_replace_ctx *rc = (cse_replace_ctx *)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = cse_replace_walk(n, rc->target, rc->sym, rc->ttype);
    if (r != n) ast_slot_set(slot, r);
}

/* Replace every subtree equivalent to `target` with `OP_DEREF(LV sym)`,
   in-place. Walks the SEF/binop tree shape. Does not descend into
   AST_DECL we just inserted (caller arranges the insertion point so
   the canonical occurrence's *clone* is in the decl, the originals
   remain in the body). */
static Node *cse_replace_walk(Node *node, Node *target, SYMBOL *sym, Type *ttype)
{
    if (!node) return NULL;
    if (is_side_effect_free(node) && nodes_equivalent(node, target)) {
        return cse_make_lv_deref(sym, ttype);
    }
    cse_replace_ctx rc = { target, sym, ttype };
    ast_for_each_child(node, cse_replace_visit, &rc);
    return node;
}

/* Collect every SEF interesting subtree at every nesting level. We
   need ALL levels (not just maximal): the cluster pass picks the one
   with the highest count, which is usually the smallest shared
   subtree. Maximal-only would miss `(x+1) + (x+1)` because the outer
   add is also SEF and would shadow the inner duplicates. */
static void collect_sef_subtrees(Node *node, array *bag)
{
    if (!node) return;
    if (is_cse_interesting(node) && is_side_effect_free(node)) {
        array_add(bag, node);
        /* keep recursing — children may also be SEF interesting and
           appear elsewhere in the tree. */
    }
    switch (node->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_LABEL:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_INIT_STATIC:
    case AST_ASM:
        return;
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(node->args); i++)
            collect_sef_subtrees(array_get_byindex(node->args, i), bag);
        if (node->callee) collect_sef_subtrees(node->callee, bag);
        return;
    case AST_RETURN:
        collect_sef_subtrees(node->retval, bag);
        return;
    case AST_COMPOUND_STMT:
    case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(node->stmts); i++)
            collect_sef_subtrees(array_get_byindex(node->stmts, i), bag);
        return;
    case AST_IF:
    case AST_TERNARY:
        collect_sef_subtrees(node->cond, bag);
        collect_sef_subtrees(node->then, bag);
        collect_sef_subtrees(node->els,  bag);
        return;
    case AST_SWITCH:
        collect_sef_subtrees(node->sw_expr, bag);
        collect_sef_subtrees(node->sw_body, bag);
        return;
    case AST_SWITCH_CASE:
        collect_sef_subtrees(node->sw_value, bag);
        return;
    case AST_DECL:
        collect_sef_subtrees(node->declvar, bag);
        return;
    case AST_CRITICAL:
        collect_sef_subtrees(node->operand, bag);
        return;
    case OP_ASSIGN:
        /* RHS only — LHS is the target of a write, not an rvalue use. */
        collect_sef_subtrees(node->right, bag);
        return;
    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        collect_sef_subtrees(node->right, bag);
        return;
    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
        return;     /* operand is an lvalue being mutated */
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_DEREF: case AST_DEREF:
    case OP_ADDR:  case AST_ADDR:
    case OP_CAST: case OP_SIZEOF:
        collect_sef_subtrees(node->operand, bag);
        return;
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        collect_sef_subtrees(node->left, bag);
        collect_sef_subtrees(node->right, bag);
        return;
    default:
        return;
    }
}

static int cand_reads_global(Node *expr);

static void cand_reads_global_visit(const AstSlot *slot, void *ctx)
{
    int *found = (int *)ctx;
    if (*found) return;
    Node *n = ast_slot_get(slot);
    if (n && cand_reads_global(n)) *found = 1;
}

/* True if the SEF candidate reads any global. Used to gate
   synthesis when the containing stmt also contains a call (calls
   can modify globals; locals are assumed not to alias). */
static int cand_reads_global(Node *expr)
{
    if (!expr) return 0;
    if (expr->ast_type == AST_GLOBAL_VAR) return 1;
    int found = 0;
    ast_for_each_child(expr, cand_reads_global_visit, &found);
    return found;
}

static int stmt_has_call_or_asm(Node *stmt);

static void hca_visit(const AstSlot *slot, void *ctx)
{
    int *found = (int *)ctx;
    if (*found) return;
    Node *n = ast_slot_get(slot);
    if (n && stmt_has_call_or_asm(n)) *found = 1;
}

/* True if `stmt` contains an AST_FUNC_CALL or AST_FUNCPTR_CALL or
   AST_ASM anywhere in its subtree. */
static int stmt_has_call_or_asm(Node *stmt)
{
    if (!stmt) return 0;
    switch (stmt->ast_type) {
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
    case AST_ASM:
    case AST_CRITICAL:
        return 1;
    default: break;
    }
    int found = 0;
    ast_for_each_child(stmt, hca_visit, &found);
    return found;
}

/* Direct-mutation detector: returns 1 only if `stmt` directly writes
   to a sym mentioned by `cand` (assignment, compound assign, pre/post
   step, address-of). Calls are NOT auto-flagged here — caller decides
   whether call presence invalidates based on whether `cand` reads a
   global. */
static int stmt_directly_mutates_cand_sym(Node *stmt, Node *cand);

static int subtree_directly_mutates(Node *n, Node *cand)
{
    if (!n) return 0;
    /* Direct write target check. */
    if (n->ast_type == OP_ASSIGN
     || n->ast_type == OP_AADD || n->ast_type == OP_ASUB
     || n->ast_type == OP_AMULT|| n->ast_type == OP_ADIV
     || n->ast_type == OP_AMOD || n->ast_type == OP_AAND
     || n->ast_type == OP_AOR  || n->ast_type == OP_AXOR
     || n->ast_type == OP_ASSHR|| n->ast_type == OP_ASSHL) {
        SYMBOL *t = NULL;
        if (n->left) {
            if (n->left->ast_type == AST_LOCAL_VAR
             || n->left->ast_type == AST_GLOBAL_VAR) t = n->left->sym;
            else if (n->left->ast_type == OP_DEREF
                  && n->left->operand
                  && (n->left->operand->ast_type == AST_LOCAL_VAR
                   || n->left->operand->ast_type == AST_GLOBAL_VAR))
                t = n->left->operand->sym;
        }
        if (t && subtree_mentions(cand, t)) return 1;
    }
    if ((n->ast_type == OP_PRE_INC || n->ast_type == OP_POST_INC
      || n->ast_type == OP_PRE_DEC || n->ast_type == OP_POST_DEC)
        && n->operand) {
        Node *o = n->operand;
        SYMBOL *t = NULL;
        if (o->ast_type == AST_LOCAL_VAR || o->ast_type == AST_GLOBAL_VAR) t = o->sym;
        else if (o->ast_type == OP_DEREF && o->operand
              && (o->operand->ast_type == AST_LOCAL_VAR
               || o->operand->ast_type == AST_GLOBAL_VAR)) t = o->operand->sym;
        if (t && subtree_mentions(cand, t)) return 1;
    }
    /* Address-of a sym the cand mentions: escape, future calls could
       mutate it. Conservative skip. */
    if ((n->ast_type == OP_ADDR || n->ast_type == AST_ADDR)
        && n->operand && n->operand->ast_type == AST_LOCAL_VAR
        && subtree_mentions(cand, n->operand->sym)) {
        return 1;
    }
    return stmt_directly_mutates_cand_sym(n, cand);
}

typedef struct sdm_ctx {
    Node *cand;
    int found;
} sdm_ctx;

static void sdm_visit(const AstSlot *slot, void *ctx)
{
    sdm_ctx *sc = (sdm_ctx *)ctx;
    if (sc->found) return;
    Node *n = ast_slot_get(slot);
    if (n && subtree_directly_mutates(n, sc->cand)) sc->found = 1;
}

static int stmt_directly_mutates_cand_sym(Node *stmt, Node *cand)
{
    if (!stmt) return 0;
    /* Check the stmt node itself — AST_DECL with initializer is a write
       that subtree_directly_mutates would otherwise miss (the synthesize
       pass would happily hoist a read of the decl's sym above the decl
       itself otherwise). Inline rather than calling subtree_directly_
       mutates to avoid recursing back through this helper. */
    if (stmt->ast_type == AST_DECL && stmt->declvar && stmt->sym
        && subtree_mentions(cand, stmt->sym)) {
        return 1;
    }
    sdm_ctx sc = { cand, 0 };
    ast_for_each_child(stmt, sdm_visit, &sc);
    return sc.found;
}

static Node *synthesize_walk(Node *node);

static int subtree_size(Node *n);

static void size_visit(const AstSlot *slot, void *ctx)
{
    int *total = (int *)ctx;
    *total += subtree_size(ast_slot_get(slot));
}

/* Subtree node count — used to pick the largest shared sub-expression
   first. Replacing the largest first removes any smaller candidates
   that were embedded inside it, so we don't waste decls on now-absent
   matches. */
static int subtree_size(Node *n)
{
    if (!n) return 0;
    int total = 1;
    ast_for_each_child(n, size_visit, &total);
    return total;
}

/* Find the most attractive cluster in `bag`: count ≥ 2, passes the
   per-stmt invalidation rules, and (tie-break) largest exemplar.
   Returns the index in `bag` of a representative occurrence, or -1. */
static int pick_synth_target(array *bag, Node *stmt)
{
    int n = (int)array_len(bag);
    int *cluster = calloc(n, sizeof(int));
    int *count = NULL;
    int *size  = NULL;
    int best_idx = -1;
    int best_size = -1;
    for (int k = 0; k < n; k++) cluster[k] = -1;
    int next_id = 0;
    for (int k = 0; k < n; k++) {
        if (cluster[k] >= 0) continue;
        cluster[k] = next_id++;
        for (int m = k + 1; m < n; m++)
            if (cluster[m] < 0
                && nodes_equivalent(array_get_byindex(bag, k),
                                    array_get_byindex(bag, m)))
                cluster[m] = cluster[k];
    }
    count = calloc(next_id, sizeof(int));
    size  = calloc(next_id, sizeof(int));
    int *first_idx = calloc(next_id, sizeof(int));
    for (int k = 0; k < next_id; k++) first_idx[k] = -1;
    for (int k = 0; k < n; k++) {
        count[cluster[k]]++;
        if (first_idx[cluster[k]] < 0) {
            first_idx[cluster[k]] = k;
            size[cluster[k]] = subtree_size(array_get_byindex(bag, k));
        }
    }
    int call_in_stmt = stmt_has_call_or_asm(stmt);
    for (int cid = 0; cid < next_id; cid++) {
        if (count[cid] < 2) continue;
        Node *cand = array_get_byindex(bag, first_idx[cid]);
        if (stmt_directly_mutates_cand_sym(stmt, cand)) continue;
        if (call_in_stmt && cand_reads_global(cand)) continue;
        /* #261: only hoist if cycle-cost model says it pays. Reject
           candidates where the recompute_total <= hoist_total
           (compute-once + store + N loads from a synth-temp slot
           that always_interferes pins deep in the frame). */
        if (!cse_hoist_profitable(cand, count[cid])) continue;
        if (size[cid] > best_size) {
            best_size = size[cid];
            best_idx  = first_idx[cid];
        }
    }
    free(first_idx);
    free(size);
    free(count);
    free(cluster);
    return best_idx;
}

/* True if this stmt ends a CSE-synthesis segment. We can't hoist a
   shared subexpression across a control-flow alternative (the IF body
   may not run, hoisting would change evaluation count), or across a
   label / jump / return / opaque block (asm / __critical). Function
   calls *within* a stmt do NOT break the segment — they're handled by
   per-candidate validation (calls invalidate only candidates that read
   a global). */
static int is_synth_segment_breaker(Node *s)
{
    if (!s) return 0;
    switch (s->ast_type) {
    case AST_LABEL:
    case AST_JUMP:
    case AST_RETURN:
    case AST_IF:
    case AST_TERNARY:
    case AST_SWITCH:
    case AST_SWITCH_CASE:
    case AST_ASM:
    case AST_CRITICAL:
        return 1;
    default:
        return 0;
    }
}

/* Pick the largest shared SEF subexpression from the bag whose
   validation passes against EVERY stmt in the segment. */
static int pick_synth_target_segment(array *bag, array *stmts,
                                     int seg_start, int seg_end_excl)
{
    int n = (int)array_len(bag);
    if (n < 2) return -1;
    int *cluster = calloc(n, sizeof(int));
    for (int k = 0; k < n; k++) cluster[k] = -1;
    int next_id = 0;
    for (int k = 0; k < n; k++) {
        if (cluster[k] >= 0) continue;
        cluster[k] = next_id++;
        for (int m = k + 1; m < n; m++)
            if (cluster[m] < 0
                && nodes_equivalent(array_get_byindex(bag, k),
                                    array_get_byindex(bag, m)))
                cluster[m] = cluster[k];
    }
    int *count = calloc(next_id, sizeof(int));
    int *first_idx = calloc(next_id, sizeof(int));
    int *size = calloc(next_id, sizeof(int));
    for (int k = 0; k < next_id; k++) first_idx[k] = -1;
    for (int k = 0; k < n; k++) {
        count[cluster[k]]++;
        if (first_idx[cluster[k]] < 0) {
            first_idx[cluster[k]] = k;
            size[cluster[k]] = subtree_size(array_get_byindex(bag, k));
        }
    }
    /* Pre-compute segment-wide call/asm presence. */
    int seg_has_call = 0;
    for (int k = seg_start; k < seg_end_excl; k++) {
        if (stmt_has_call_or_asm(array_get_byindex(stmts, k))) {
            seg_has_call = 1;
            break;
        }
    }
    int best_idx = -1;
    int best_size = -1;
    for (int cid = 0; cid < next_id; cid++) {
        if (count[cid] < 2) continue;
        Node *cand = array_get_byindex(bag, first_idx[cid]);
        /* (1) reject if any var the cand reads is directly written
              somewhere in the segment. */
        int mutated = 0;
        for (int k = seg_start; k < seg_end_excl; k++) {
            if (stmt_directly_mutates_cand_sym(array_get_byindex(stmts, k), cand)) {
                mutated = 1;
                break;
            }
        }
        if (mutated) continue;
        /* (2) calls/asm in segment may modify globals — only invalidate
              if the cand reads a global (locals assumed not aliased). */
        if (seg_has_call && cand_reads_global(cand)) continue;
        /* #261: cycle-cost gate, same logic as pick_synth_target. */
        if (!cse_hoist_profitable(cand, count[cid])) continue;
        if (size[cid] > best_size) {
            best_size = size[cid];
            best_idx = first_idx[cid];
        }
    }
    free(first_idx); free(size); free(count); free(cluster);
    return best_idx;
}

/* Process one segment: stmts[start..end_excl). Repeatedly pick the
   largest shared SEF subexpression and hoist a `1cse_<n>` decl at
   the segment start; replace occurrences in every stmt of the
   segment. Returns the count of decls inserted. */
static int synthesize_segment(array *stmts, int start, int end_excl)
{
    int hoisted = 0;
    if (end_excl - start < 2) return 0;
    for (int guard = 0; guard < 16; guard++) {
        array *bag = array_init(NULL);
        for (int k = start; k < end_excl; k++) {
            collect_sef_subtrees(array_get_byindex(stmts, k), bag);
        }
        if ((int)array_len(bag) < 2) { array_free(bag); break; }
        int chosen = pick_synth_target_segment(bag, stmts, start, end_excl);
        if (chosen < 0) { array_free(bag); break; }
        Node *cand = array_get_byindex(bag, chosen);
        SYMBOL *sym = cse_make_stub_sym(cand->type);
        Node *decl = calloc(1, sizeof(Node));
        decl->ast_type = AST_DECL;
        decl->sym = sym;
        decl->declvar = clone_subtree(cand);
        decl->type = cand->type;
        decl->filename = cand->filename;
        decl->line = cand->line;
        array_insert(stmts, start, decl);
        start++;
        end_excl++;
        hoisted++;
        for (int k = start; k < end_excl; k++) {
            Node *t = array_get_byindex(stmts, k);
            Node *r = cse_replace_walk(t, cand, sym, cand->type);
            if (r != t) array_set_byindex(stmts, k, r);
        }
        array_free(bag);
    }
    return hoisted;
}

/* Per-stmt synthesis (Q15b) + cross-stmt segment synthesis (Q20).
   Segment-level runs first so cross-stmt duplicates get folded into a
   single temp — per-stmt then cleans up any intra-stmt duplicates that
   remain (e.g. inside a control-flow stmt that broke the segment). */
static void synthesize_in_compound(array *stmts)
{
    /* Phase 1: cross-stmt segment synthesis. */
    int i = 0;
    while (i < (int)array_len(stmts)) {
        Node *s = array_get_byindex(stmts, i);
        if (s == NULL || is_synth_segment_breaker(s)) {
            i++;
            continue;
        }
        int j = i;
        while (j < (int)array_len(stmts)) {
            Node *t = array_get_byindex(stmts, j);
            if (t == NULL || is_synth_segment_breaker(t)) break;
            j++;
        }
        if (j - i >= 2) {
            int hoisted = synthesize_segment(stmts, i, j);
            j += hoisted;
        }
        i = j;
    }

    /* Phase 2: per-stmt synthesis. Iterates over the already-segmented
       stmt list. Inside a control-flow stmt (IF / SWITCH / TERNARY) the
       cond / then / els still gets visited via the walker recursion;
       per-stmt synthesis at this level catches multi-occurrence patterns
       within a SINGLE such stmt. */
    for (int i = 0; i < (int)array_len(stmts); i++) {
        Node *s = array_get_byindex(stmts, i);
        if (!s) continue;
        switch (s->ast_type) {
        case AST_LABEL: case AST_JUMP: case AST_ASM:
        case AST_UNDECL: case AST_LITERAL:
            continue;
        default: break;
        }
        for (int guard = 0; guard < 16; guard++) {
            array *bag = array_init(NULL);
            collect_sef_subtrees(array_get_byindex(stmts, i), bag);
            if ((int)array_len(bag) < 2) { array_free(bag); break; }
            int chosen = pick_synth_target(bag, array_get_byindex(stmts, i));
            if (chosen < 0) { array_free(bag); break; }
            Node *cand = array_get_byindex(bag, chosen);
            SYMBOL *sym = cse_make_stub_sym(cand->type);
            Node *decl = calloc(1, sizeof(Node));
            decl->ast_type = AST_DECL;
            decl->sym = sym;
            decl->declvar = clone_subtree(cand);
            decl->type = cand->type;
            decl->filename = cand->filename;
            decl->line = cand->line;
            array_insert(stmts, i, decl);
            i++;     /* s is now at i+1; bump i to point at s again */
            Node *new_s = cse_replace_walk(array_get_byindex(stmts, i),
                                           cand, sym, cand->type);
            array_set_byindex(stmts, i, new_s);
            array_free(bag);
        }
    }
    /* Recurse into nested compounds. */
    for (int i = 0; i < (int)array_len(stmts); i++) {
        Node *s = array_get_byindex(stmts, i);
        Node *r = synthesize_walk(s);
        if (r != s) array_set_byindex(stmts, i, r);
    }
}

static void synth_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = synthesize_walk(n);
    if (r != n) ast_slot_set(slot, r);
}

static Node *synthesize_walk(Node *node)
{
    if (!node) return NULL;
    if (node->ast_type == AST_COMPOUND_STMT) {
        synthesize_in_compound(node->stmts);
        return node;
    }
    ast_for_each_child(node, synth_visit, NULL);
    return node;
}

Node *ast_cse_synthesize(Node *root)
{
    if (!root) return NULL;
    return synthesize_walk(root);
}

/* ----- Loop-Invariant Code Motion ------------------------------------ */

/*
 * Hoists SEF "safe-to-hoist" subexpressions out of loop bodies. Loops
 * are detected structurally: an AST_LABEL followed (at the same
 * compound-stmt level) by an AST_JUMP whose target is that label is a
 * back-edge — the body lives between them, the LABEL itself is the
 * preheader insertion point.
 *
 * Safety: we only hoist expressions that would be safe to evaluate
 * even if the loop ran zero times. That excludes division (could
 * trap), modulo, and pointer derefs (could fault on a stale/invalid
 * pointer). Reads of named locals / globals are fine — those are
 * always valid as long as the symbol is in scope.
 *
 * Invariance: a candidate is invariant if no symbol it reads is
 * directly written within the body, and (if the body contains a call
 * or asm) the candidate reads no globals.
 *
 * Synthesis: stub `1licm_<n>` SYMBOL (same shape as Q15b's
 * `1cse_<n>` — no symtab/locptr mutation; print walker only reads
 * sym->name). Decl is inserted at the LABEL's slot, shifting the
 * LABEL down by one.
 *
 * Per loop, we iterate to a fixed point: each pass extracts the
 * largest available invariant and re-collects from the modified body
 * (so smaller invariants subsumed by a larger one don't get separate
 * decls). Capped at 16 rounds.
 */

typedef struct sym_set {
    SYMBOL **items;
    int n, cap;
} sym_set;

static void sym_set_init(sym_set *s)  { s->items = NULL; s->n = 0; s->cap = 0; }
static void sym_set_free(sym_set *s)  { free(s->items); s->items = NULL; s->n = 0; s->cap = 0; }

static int sym_set_contains(sym_set *s, SYMBOL *sym)
{
    for (int i = 0; i < s->n; i++) if (s->items[i] == sym) return 1;
    return 0;
}

static void sym_set_add(sym_set *s, SYMBOL *sym)
{
    if (!sym || sym_set_contains(s, sym)) return;
    if (s->n == s->cap) {
        s->cap = s->cap ? s->cap * 2 : 4;
        s->items = realloc(s->items, sizeof(SYMBOL *) * s->cap);
    }
    s->items[s->n++] = sym;
}

static void sym_set_remove(sym_set *s, SYMBOL *sym)
{
    if (!sym) return;
    int w = 0;
    for (int i = 0; i < s->n; i++) {
        if (s->items[i] == sym) continue;
        if (w != i) s->items[w] = s->items[i];
        w++;
    }
    s->n = w;
}

/* True if `n` is safe to evaluate even when the loop body would not
   have executed. Excludes division, modulo, and pointer derefs that
   could fault. Plain LV/GV reads are fine. */
static int is_safe_to_hoist(Node *n)
{
    if (!n) return 1;
    if (!is_side_effect_free(n)) return 0;
    switch (n->ast_type) {
    case OP_DIV: case OP_MOD:
        return 0;
    case OP_DEREF: case AST_DEREF:
        if (n->operand && (n->operand->ast_type == AST_LOCAL_VAR
                        || n->operand->ast_type == AST_GLOBAL_VAR))
            return 1;
        return 0;
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        return 1;
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST: case OP_SIZEOF:
        return is_safe_to_hoist(n->operand);
    case OP_ADD: case OP_SUB: case OP_MULT:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        return is_safe_to_hoist(n->left) && is_safe_to_hoist(n->right);
    default:
        return 0;
    }
}

typedef struct licm_mod_ctx {
    sym_set *modified;
    int *has_call;
} licm_mod_ctx;

static void licm_compute_modified(Node *node, sym_set *modified, int *has_call);

static void licm_mod_visit(const AstSlot *slot, void *ctx)
{
    licm_mod_ctx *mc = (licm_mod_ctx *)ctx;
    Node *n = ast_slot_get(slot);
    if (n) licm_compute_modified(n, mc->modified, mc->has_call);
}

/* Walk body collecting (a) every sym written/escaped, (b) whether any
   call or asm appears. */
static void licm_compute_modified(Node *node, sym_set *modified, int *has_call)
{
    if (!node) return;
    switch (node->ast_type) {
    case AST_ASM:
        *has_call = 1;
        break;
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
    case AST_CRITICAL:
        *has_call = 1;
        break;
    case AST_DECL:
        /* The new local being declared is mutated (initialized) here. */
        if (node->sym) sym_set_add(modified, node->sym);
        break;
    case OP_ASSIGN:
    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        if (node->left) {
            Node *l = node->left;
            SYMBOL *t = NULL;
            if (l->ast_type == AST_LOCAL_VAR || l->ast_type == AST_GLOBAL_VAR) t = l->sym;
            else if (l->ast_type == OP_DEREF && l->operand
                  && (l->operand->ast_type == AST_LOCAL_VAR
                   || l->operand->ast_type == AST_GLOBAL_VAR)) t = l->operand->sym;
            if (t) sym_set_add(modified, t);
        }
        break;
    case OP_PRE_INC: case OP_POST_INC:
    case OP_PRE_DEC: case OP_POST_DEC:
        if (node->operand) {
            Node *o = node->operand;
            SYMBOL *t = NULL;
            if (o->ast_type == AST_LOCAL_VAR || o->ast_type == AST_GLOBAL_VAR) t = o->sym;
            else if (o->ast_type == OP_DEREF && o->operand
                  && (o->operand->ast_type == AST_LOCAL_VAR
                   || o->operand->ast_type == AST_GLOBAL_VAR)) t = o->operand->sym;
            if (t) sym_set_add(modified, t);
        }
        break;
    case OP_ADDR: case AST_ADDR:
        if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
            && node->operand->sym) sym_set_add(modified, node->operand->sym);
        break;
    default:
        break;
    }
    licm_mod_ctx mc = { modified, has_call };
    ast_for_each_child(node, licm_mod_visit, &mc);
}

typedef struct srm_ctx {
    sym_set *modified;
    int has_call;
    int found;
} srm_ctx;

static int subtree_reads_modified(Node *expr, sym_set *modified, int has_call);

static void srm_visit(const AstSlot *slot, void *ctx)
{
    srm_ctx *sc = (srm_ctx *)ctx;
    if (sc->found) return;
    Node *n = ast_slot_get(slot);
    if (n && subtree_reads_modified(n, sc->modified, sc->has_call))
        sc->found = 1;
}

/* True if `expr` reads any sym in `modified`, or (if has_call) reads
   any global. Conservative: an unknown variant's children are walked
   (an unrecognised expression that happens to read modified state
   defeats hoisting rather than enabling a wrong hoist). */
static int subtree_reads_modified(Node *expr, sym_set *modified, int has_call)
{
    if (!expr) return 0;
    if (expr->ast_type == AST_LOCAL_VAR)
        return sym_set_contains(modified, expr->sym);
    if (expr->ast_type == AST_GLOBAL_VAR)
        return has_call || sym_set_contains(modified, expr->sym);
    srm_ctx sc = { modified, has_call, 0 };
    ast_for_each_child(expr, srm_visit, &sc);
    return sc.found;
}

/* Collect candidate invariant subtrees. A candidate is the LARGEST
   invariant subtree at its location: we don't recurse into a subtree
   we've already classified as invariant. */
static void licm_collect_invariants(Node *node, sym_set *modified, int has_call, array *bag)
{
    if (!node) return;
    if (is_cse_interesting(node)
        && is_safe_to_hoist(node)
        && !subtree_reads_modified(node, modified, has_call)) {
        array_add(bag, node);
        return;
    }
    switch (node->ast_type) {
    case AST_LITERAL: case AST_STR_LIT: case AST_LOCAL_VAR: case AST_GLOBAL_VAR:
    case AST_LABEL: case AST_JUMP: case AST_UNDECL:
    case AST_INIT_STATIC: case AST_ASM:
        return;
    case AST_FUNC_CALL: case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(node->args); i++)
            licm_collect_invariants(array_get_byindex(node->args, i), modified, has_call, bag);
        if (node->callee)
            licm_collect_invariants(node->callee, modified, has_call, bag);
        return;
    case AST_COMPOUND_STMT: case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(node->stmts); i++)
            licm_collect_invariants(array_get_byindex(node->stmts, i), modified, has_call, bag);
        return;
    case AST_RETURN:
        licm_collect_invariants(node->retval, modified, has_call, bag);
        return;
    case AST_IF: case AST_TERNARY:
        licm_collect_invariants(node->cond, modified, has_call, bag);
        licm_collect_invariants(node->then, modified, has_call, bag);
        licm_collect_invariants(node->els,  modified, has_call, bag);
        return;
    case AST_SWITCH:
        licm_collect_invariants(node->sw_expr, modified, has_call, bag);
        licm_collect_invariants(node->sw_body, modified, has_call, bag);
        return;
    case AST_SWITCH_CASE:
        licm_collect_invariants(node->sw_value, modified, has_call, bag);
        return;
    case AST_DECL:
        licm_collect_invariants(node->declvar, modified, has_call, bag);
        return;
    case AST_CRITICAL:
        licm_collect_invariants(node->operand, modified, has_call, bag);
        return;
    case OP_ASSIGN:
    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        /* RHS is rvalue, walk it. LHS is lvalue — we don't try to
           hoist lvalue computations (they're store targets). */
        if (node->right) licm_collect_invariants(node->right, modified, has_call, bag);
        return;
    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
        return;     /* operand is the lvalue being mutated */
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_DEREF: case AST_DEREF:
    case OP_ADDR:  case AST_ADDR:
    case OP_CAST:  case OP_SIZEOF:
        if (node->operand) licm_collect_invariants(node->operand, modified, has_call, bag);
        return;
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
    case OP_OROR: case OP_ANDAND:
        licm_collect_invariants(node->left,  modified, has_call, bag);
        licm_collect_invariants(node->right, modified, has_call, bag);
        return;
    default:
        return;
    }
}

/* Pick the largest invariant from the bag. Returns the bag index, or
   -1 if empty. */
static int pick_largest_invariant(array *bag)
{
    int n = (int)array_len(bag);
    int best = -1;
    int best_size = -1;
    for (int i = 0; i < n; i++) {
        Node *cand = array_get_byindex(bag, i);
        int sz = subtree_size(cand);
        if (sz > best_size) { best_size = sz; best = i; }
    }
    return best;
}

typedef struct sctj_ctx {
    int label_id;
    int found;
} sctj_ctx;

static int stmt_contains_jump_to(Node *node, int label_id);

static void sctj_visit(const AstSlot *slot, void *ctx)
{
    sctj_ctx *c = (sctj_ctx *)ctx;
    if (c->found) return;
    Node *n = ast_slot_get(slot);
    if (n && stmt_contains_jump_to(n, c->label_id)) c->found = 1;
}

/* Recursively check whether `node` contains an AST_JUMP that targets
   `label_id`. Used to detect back-edges that are nested inside
   if/ternary/compound (do-while builds the back-edge as an IF whose
   then is `goto top`). */
static int stmt_contains_jump_to(Node *node, int label_id)
{
    if (!node) return 0;
    switch (node->ast_type) {
    case AST_JUMP:
        return node->label == label_id;
    case AST_SWITCH:
        if (node->sw_default_label == label_id) return 1;
        if (node->sw_exit_label == label_id) return 1;
        break;
    case AST_SWITCH_CASE:
        if (node->sw_label == label_id) return 1;
        break;
    default:
        break;
    }
    sctj_ctx c = { label_id, 0 };
    ast_for_each_child(node, sctj_visit, &c);
    return c.found;
}

/* Find the LAST same-compound-level stmt that contains a JUMP to
   `label_id` (directly or nested). The last one is taken so a
   conditional `continue` doesn't prematurely truncate the loop body. */
static int find_loop_close_idx(array *stmts, int label_idx, int label_id)
{
    int n = (int)array_len(stmts);
    int best = -1;
    for (int i = label_idx + 1; i < n; i++) {
        Node *s = array_get_byindex(stmts, i);
        if (s && stmt_contains_jump_to(s, label_id)) best = i;
    }
    return best;
}

static int licm_temp_seq = 0;

static SYMBOL *make_licm_stub_sym(Type *type)
{
    SYMBOL *s = calloc(1, sizeof(SYMBOL));
    /* Leading digit — guaranteed non-colliding with C identifiers
       (see cse_make_stub_sym for rationale). */
    snprintf(s->name, sizeof(s->name), "1licm_%d", licm_temp_seq++);
    /* Decay arrays to pointers — the hoisted expression's "value" is
       the array's first-element address, which fits in a 2-byte
       pointer slot. Storing it as KIND_ARRAY would ask the walker
       to allocate a full array temp, which it can't. After decay
       the temp behaves like any other pointer-typed local. */
    if (type && type->kind == KIND_ARRAY && type->ptr) {
        type = make_pointer(type->ptr);
    }
    s->ident = ID_VARIABLE;
    s->type = type ? type->kind : KIND_INT;
    s->ctype = type;
    s->storage = STKLOC;
    return s;
}

/* Per-loop processing. body_end_excl is one-past-last body stmt:
   for/while loops pass jump_idx (excluding the top-level JUMP), do-while
   loops pass close_idx + 1 (including the IF that wraps the back-jump).
   Returns the count of decls inserted. */
static int licm_process_loop(array *stmts, int label_idx, int body_end_excl)
{
    int hoisted = 0;
    for (int guard = 0; guard < 16; guard++) {
        sym_set modified;
        sym_set_init(&modified);
        int has_call = 0;
        for (int k = label_idx + 1; k < body_end_excl; k++) {
            Node *s = array_get_byindex(stmts, k);
            licm_compute_modified(s, &modified, &has_call);
        }
        array *bag = array_init(NULL);
        for (int k = label_idx + 1; k < body_end_excl; k++) {
            Node *s = array_get_byindex(stmts, k);
            licm_collect_invariants(s, &modified, has_call, bag);
        }
        int chosen = pick_largest_invariant(bag);
        if (chosen < 0) {
            sym_set_free(&modified);
            array_free(bag);
            break;
        }
        Node *cand = array_get_byindex(bag, chosen);
        SYMBOL *sym = make_licm_stub_sym(cand->type);
        Node *decl = calloc(1, sizeof(Node));
        decl->ast_type = AST_DECL;
        decl->sym = sym;
        decl->declvar = clone_subtree(cand);
        decl->type = cand->type;
        decl->filename = cand->filename;
        decl->line = cand->line;
        array_insert(stmts, label_idx, decl);
        label_idx++;
        body_end_excl++;
        hoisted++;
        for (int k = label_idx + 1; k < body_end_excl; k++) {
            Node *t = array_get_byindex(stmts, k);
            Node *r = cse_replace_walk(t, cand, sym, cand->type);
            if (r != t) array_set_byindex(stmts, k, r);
        }
        sym_set_free(&modified);
        array_free(bag);
    }
    return hoisted;
}

static Node *licm_walk(Node *node);

static void licm_walk_compound(array *stmts)
{
    /* Recurse first (deepest-first: process inner loops before outer). */
    for (int i = 0; i < (int)array_len(stmts); i++) {
        Node *s = array_get_byindex(stmts, i);
        Node *r = licm_walk(s);
        if (r != s) array_set_byindex(stmts, i, r);
    }
    /* Then loops at this level. */
    int i = 0;
    while (i < (int)array_len(stmts)) {
        Node *s = array_get_byindex(stmts, i);
        if (s && s->ast_type == AST_LABEL) {
            int close_idx = find_loop_close_idx(stmts, i, s->label);
            if (close_idx > i) {
                /* Body span is exclusive of a top-level JUMP (just a
                   goto, no expressions to analyze) but INCLUSIVE of a
                   stmt that merely contains a nested back-jump (e.g.
                   the IF wrapping `goto top` at the bottom of a
                   do-while — the IF's cond is part of each iteration). */
                Node *cs = array_get_byindex(stmts, close_idx);
                int body_end_excl =
                    (cs && cs->ast_type == AST_JUMP) ? close_idx
                                                     : (close_idx + 1);
                int hoisted = licm_process_loop(stmts, i, body_end_excl);
                /* After insertion, advance past the close stmt. */
                i = close_idx + hoisted + 1;
                continue;
            }
        }
        i++;
    }
}

static void licm_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    Node *n = ast_slot_get(slot);
    if (!n) return;
    Node *r = licm_walk(n);
    if (r != n) ast_slot_set(slot, r);
}

static Node *licm_walk(Node *node)
{
    if (!node) return NULL;
    if (node->ast_type == AST_COMPOUND_STMT) {
        licm_walk_compound(node->stmts);
        return node;
    }
    ast_for_each_child(node, licm_visit, NULL);
    return node;
}

Node *ast_licm(Node *root)
{
    if (!root) return NULL;
    return licm_walk(root);
}

/* ----- Dead Store Elimination --------------------------------------- */

/*
 * Backward live-variable analysis at the compound-stmt level. A store
 * to a non-volatile local whose value isn't subsequently read (either
 * because no later stmt mentions it, or because every subsequent
 * mention is also a store before any read) is dead and can be dropped
 * provided the RHS is side-effect-free.
 *
 * The pass operates per AST_COMPOUND_STMT, walking backward, with a
 * `live` set of locals whose current value is live (will be read
 * before being overwritten). Patterns recognised:
 *   - `OP_ASSIGN(LV x, RHS)` with x non-volatile, non-escaped, RHS
 *     SEF, and x not in `live` → drop the assignment.
 *   - `AST_DECL(x = init)` with the same conditions → drop the decl
 *     entirely (the local was never used).
 *
 * Conservative handling for control flow:
 *   - `AST_LABEL`: clears `live` to a "function-wide ever-read" set
 *     (we can't tell what state a back-jump might bring).
 *   - `AST_JUMP` / `AST_RETURN`: liveness AT this point starts from
 *     the return value's USEs only.
 *   - `AST_IF` / `AST_TERNARY`: walk els and then with copies of
 *     `live`, union the resulting live-ins, then process the cond.
 *   - `AST_SWITCH` / `AST_ASM` / `AST_CRITICAL`: opaque — reset to
 *     ever-read.
 *   - Function calls: don't kill locals (no aliasing assumed). Args
 *     are walked for USE info.
 *   - `&local` is detected in a pre-pass and the local marked as
 *     "escaped" (never DSE'd, always considered live).
 */

typedef struct dse_state {
    sym_set escaped;     /* locals whose & has been taken */
    sym_set ever_read;   /* locals referenced anywhere as an rvalue */
    sym_set referenced;  /* locals mentioned anywhere by AST_LOCAL_VAR
                            outside of their own AST_DECL — covers reads,
                            writes, escapes. A sym not in this set has
                            no other use in the function and its decl
                            can be dropped. */
} dse_state;

static void dse_collect_escaped(Node *n, sym_set *escaped);

static void dse_escaped_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (n) dse_collect_escaped(n, (sym_set *)ctx);
}

/* Pre-pass: collect every local whose & has been taken. Such locals
   may be modified through the escaped pointer and are conservatively
   treated as always live. */
static void dse_collect_escaped(Node *n, sym_set *escaped)
{
    if (!n) return;
    if ((n->ast_type == OP_ADDR || n->ast_type == AST_ADDR)
        && n->operand && n->operand->ast_type == AST_LOCAL_VAR
        && n->operand->sym) {
        sym_set_add(escaped, n->operand->sym);
    }
    ast_for_each_child(n, dse_escaped_visit, escaped);
}

/* Pre-pass: collect every local that has at least one rvalue read
   anywhere in the function. Used for the conservative LABEL reset.
   Reads are detected at OP_DEREF(AST_LOCAL_VAR), and at LHS of
   compound-assigns / pre-post-step (which read-then-write). */
static void dse_collect_ever_read(Node *n, sym_set *ever_read)
{
    if (!n) return;
    switch (n->ast_type) {
    case AST_LITERAL: case AST_STR_LIT: case AST_GLOBAL_VAR:
    case AST_LABEL: case AST_JUMP: case AST_UNDECL:
    case AST_INIT_STATIC: case AST_ASM:
        return;
    case AST_LOCAL_VAR:
        /* Bare LV — caller is responsible for context (LHS of
           OP_ASSIGN doesn't count). For everything else we get here
           from, treat as a read. */
        if (n->sym) sym_set_add(ever_read, n->sym);
        return;
    case OP_DEREF: case AST_DEREF:
        if (n->operand && n->operand->ast_type == AST_LOCAL_VAR && n->operand->sym) {
            sym_set_add(ever_read, n->operand->sym);
        } else {
            dse_collect_ever_read(n->operand, ever_read);
        }
        return;
    case OP_ADDR: case AST_ADDR:
        /* &bare-local is not a value read (the escape pass keeps the
           local alive). A folded address expression (&p->member,
           &arr[i]) DOES read the locals inside it — walk the
           subtree. */
        if (n->operand && n->operand->ast_type != AST_LOCAL_VAR
                       && n->operand->ast_type != AST_GLOBAL_VAR)
            dse_collect_ever_read(n->operand, ever_read);
        return;
    case AST_FUNC_CALL: case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(n->args); i++)
            dse_collect_ever_read(array_get_byindex(n->args, i), ever_read);
        if (n->callee) dse_collect_ever_read(n->callee, ever_read);
        return;
    case AST_COMPOUND_STMT: case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(n->stmts); i++)
            dse_collect_ever_read(array_get_byindex(n->stmts, i), ever_read);
        return;
    case AST_RETURN:
        dse_collect_ever_read(n->retval, ever_read);
        return;
    case AST_IF: case AST_TERNARY:
        dse_collect_ever_read(n->cond, ever_read);
        dse_collect_ever_read(n->then, ever_read);
        dse_collect_ever_read(n->els,  ever_read);
        return;
    case AST_SWITCH:
        dse_collect_ever_read(n->sw_expr, ever_read);
        dse_collect_ever_read(n->sw_body, ever_read);
        return;
    case AST_SWITCH_CASE:
        dse_collect_ever_read(n->sw_value, ever_read);
        return;
    case AST_DECL:
        dse_collect_ever_read(n->declvar, ever_read);
        return;
    case AST_CRITICAL:
        dse_collect_ever_read(n->operand, ever_read);
        return;
    case OP_ASSIGN:
        /* RHS reads count; LHS does not (it's a write target). */
        dse_collect_ever_read(n->right, ever_read);
        /* But if LHS is a complex lvalue (e.g. *(p+i)), the components
           are read — walk via the deref structure. Bare AST_LOCAL_VAR
           on LHS is a write target and should NOT be counted. */
        if (n->left && n->left->ast_type != AST_LOCAL_VAR
                    && n->left->ast_type != AST_GLOBAL_VAR)
            dse_collect_ever_read(n->left, ever_read);
        return;
    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        /* Compound assign: LHS is read AND written. */
        dse_collect_ever_read(n->left, ever_read);
        dse_collect_ever_read(n->right, ever_read);
        return;
    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
        /* Pre/post step: operand is read AND written. */
        dse_collect_ever_read(n->operand, ever_read);
        return;
    default:
        if (n->left)    dse_collect_ever_read(n->left, ever_read);
        if (n->right)   dse_collect_ever_read(n->right, ever_read);
        if (n->operand) dse_collect_ever_read(n->operand, ever_read);
        return;
    }
}

static void dse_collect_referenced(Node *n, sym_set *referenced);

static void dse_referenced_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (n) dse_collect_referenced(n, (sym_set *)ctx);
}

/* Pre-pass: collect every local mentioned by an AST_LOCAL_VAR
   anywhere in the function — except inside its own AST_DECL's init.
   A sym absent from this set has no references outside its decl, so
   the decl can be dropped entirely (saves stack space). */
static void dse_collect_referenced(Node *n, sym_set *referenced)
{
    if (!n) return;
    if (n->ast_type == AST_LOCAL_VAR) {
        if (n->sym) sym_set_add(referenced, n->sym);
        return;
    }
    ast_for_each_child(n, dse_referenced_visit, referenced);
}

/* Add all locals read by `n` to `live`. Mirrors dse_collect_ever_read
   but writes into the per-walk live set instead of a global. */
static void dse_add_uses(Node *n, sym_set *live)
{
    /* Same shape as dse_collect_ever_read — reuse via a wrapper. */
    dse_collect_ever_read(n, live);
}

/* Walk a compound's stmts backward. May NULL out array entries to
   drop dead stores / dead decls. */
static void dse_walk(Node *node, sym_set *live, dse_state *st);

static void dse_compound(array *stmts, sym_set *live, dse_state *st)
{
    int n = (int)array_len(stmts);
    for (int i = n - 1; i >= 0; i--) {
        Node *s = array_get_byindex(stmts, i);
        if (!s) continue;
        switch (s->ast_type) {
        case AST_LABEL:
            /* Label: any back-jump could come from anywhere, so any
               ever-read local could be live. Reset live = ever_read
               ∪ escaped. */
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
            for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
            break;
        case AST_JUMP:
            /* Jump: liveness at this point is whatever is live at the
               target. Approximate: ever-read ∪ escaped (conservative). */
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
            for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
            break;
        case AST_RETURN:
            /* Return: discard live-after (locals don't survive
               function exit), restart from USE(retval). */
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < st->escaped.n; k++) sym_set_add(live, st->escaped.items[k]);
            if (s->retval) dse_add_uses(s->retval, live);
            break;
        case AST_DECL: {
            SYMBOL *sym = s->sym;
            /* Truly unused: no other AST_LOCAL_VAR mentions this sym
               anywhere in the function. Drop the entire decl — no
               stack space needed. */
            int truly_unused = (sym && sym->storage == STKLOC
                                && (!sym->ctype || !sym->ctype->isvolatile)
                                && !sym_set_contains(&st->escaped, sym)
                                && !sym_set_contains(&st->referenced, sym)
                                && (s->declvar == NULL
                                    || is_side_effect_free(s->declvar)));
            if (truly_unused) {
                array_set_byindex(stmts, i, NULL);
                break;
            }
            /* Otherwise: var is referenced somewhere (a later assign,
               a read elsewhere). Keep the decl shell — codegen-from-AST
               relies on it for stack allocation — but drop the init if
               its value is overwritten before being read. */
            int drop_init = (sym && sym->storage == STKLOC
                             && (!sym->ctype || !sym->ctype->isvolatile)
                             && !sym_set_contains(&st->escaped, sym)
                             && !sym_set_contains(live, sym)
                             && s->declvar
                             && is_side_effect_free(s->declvar));
            if (drop_init) s->declvar = NULL;
            if (sym) sym_set_remove(live, sym);
            if (s->declvar) dse_add_uses(s->declvar, live);
            break;
        }
        case OP_ASSIGN: {
            /* Simple `x = RHS` where x is a bare local. */
            if (s->left && s->left->ast_type == AST_LOCAL_VAR
                && s->left->sym && s->left->sym->storage == STKLOC) {
                SYMBOL *sym = s->left->sym;
                /* Aggregate sym (struct / array): a bare-LV
                   assignment is actually a *partial* write —
                   sccz80 simplifies `f.a = N` for a bitfield
                   member down to `(= (lv=f) N)` when the field's
                   byte offset is 0, and similar for `arr[0] = N`.
                   Treating it as whole-symbol kill drops earlier
                   writes that targeted *different* bits / bytes
                   (e.g. `f.a = 1; f.b = 2; f.c = 3` would
                   collapse to just `f.c = 3`). Walk uses
                   normally and don't drop. */
                int is_aggregate = (sym->ctype
                    && (sym->ctype->kind == KIND_STRUCT
                     || sym->ctype->kind == KIND_ARRAY));
                if (is_aggregate) {
                    if (s->right) dse_add_uses(s->right, live);
                    break;
                }
                int dropable = ((!sym->ctype || !sym->ctype->isvolatile)
                                && !sym_set_contains(&st->escaped, sym)
                                && !sym_set_contains(live, sym)
                                && s->right && is_side_effect_free(s->right));
                if (dropable) {
                    array_set_byindex(stmts, i, NULL);
                    break;
                }
                sym_set_remove(live, sym);
                if (s->right) dse_add_uses(s->right, live);
                break;
            }
            /* Other LHS forms: walk normally — RHS reads, then LHS
               reads (compound lvalue may have sub-expressions). */
            if (s->right) dse_add_uses(s->right, live);
            if (s->left)  dse_add_uses(s->left, live);
            break;
        }
        case AST_IF:
        case AST_TERNARY: {
            sym_set then_live, els_live;
            sym_set_init(&then_live);
            sym_set_init(&els_live);
            for (int k = 0; k < live->n; k++) {
                sym_set_add(&then_live, live->items[k]);
                sym_set_add(&els_live,  live->items[k]);
            }
            dse_walk(s->then, &then_live, st);
            dse_walk(s->els,  &els_live,  st);
            /* live before IF = then_live ∪ els_live, then add cond reads. */
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < then_live.n; k++) sym_set_add(live, then_live.items[k]);
            for (int k = 0; k < els_live.n; k++)  sym_set_add(live, els_live.items[k]);
            sym_set_free(&then_live);
            sym_set_free(&els_live);
            if (s->cond) dse_add_uses(s->cond, live);
            break;
        }
        case AST_SWITCH:
            /* Treat conservatively: switch body's branches join in
               complex ways; reset live to ever_read. */
            if (s->sw_body) dse_walk(s->sw_body, live, st);
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
            for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
            if (s->sw_expr) dse_add_uses(s->sw_expr, live);
            break;
        case AST_SWITCH_CASE:
            if (s->sw_value) dse_add_uses(s->sw_value, live);
            break;
        case AST_ASM:
        case AST_CRITICAL:
            /* Opaque — reset to ever_read. */
            sym_set_free(live);
            sym_set_init(live);
            for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
            for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
            if (s->ast_type == AST_CRITICAL && s->operand)
                dse_walk(s->operand, live, st);
            break;
        case AST_COMPOUND_STMT:
            dse_compound(s->stmts, live, st);
            break;
        case AST_FUNC_CALL:
        case AST_FUNCPTR_CALL: {
            for (int k = 0; k < (int)array_len(s->args); k++)
                dse_add_uses(array_get_byindex(s->args, k), live);
            if (s->callee) dse_add_uses(s->callee, live);
            break;
        }
        case AST_LITERAL: case AST_STR_LIT: case AST_LOCAL_VAR: case AST_GLOBAL_VAR:
        case AST_UNDECL: case AST_INIT_STATIC:
            break;
        default:
            /* Compound assign / pre-post-step / arithmetic / etc. —
               compute USEs into live. The "kill" semantics for compound
               assign LHS are subsumed: x is used (read) and the write
               can't be dropped without proving the read result is
               also dead, which is too aggressive without explicit
               handling. So compound assigns only contribute USE. */
            dse_add_uses(s, live);
            break;
        }
    }
}

static void dse_walk(Node *node, sym_set *live, dse_state *st)
{
    if (!node) return;
    switch (node->ast_type) {
    case AST_COMPOUND_STMT:
        dse_compound(node->stmts, live, st);
        return;
    case AST_IF:
    case AST_TERNARY: {
        sym_set then_live, els_live;
        sym_set_init(&then_live);
        sym_set_init(&els_live);
        for (int k = 0; k < live->n; k++) {
            sym_set_add(&then_live, live->items[k]);
            sym_set_add(&els_live,  live->items[k]);
        }
        dse_walk(node->then, &then_live, st);
        dse_walk(node->els,  &els_live,  st);
        sym_set_free(live);
        sym_set_init(live);
        for (int k = 0; k < then_live.n; k++) sym_set_add(live, then_live.items[k]);
        for (int k = 0; k < els_live.n; k++)  sym_set_add(live, els_live.items[k]);
        sym_set_free(&then_live);
        sym_set_free(&els_live);
        if (node->cond) dse_add_uses(node->cond, live);
        return;
    }
    case AST_SWITCH:
        if (node->sw_body) dse_walk(node->sw_body, live, st);
        sym_set_free(live);
        sym_set_init(live);
        for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
        for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
        if (node->sw_expr) dse_add_uses(node->sw_expr, live);
        return;
    case AST_DECL: {
        SYMBOL *sym = node->sym;
        if (sym) sym_set_remove(live, sym);
        if (node->declvar) dse_add_uses(node->declvar, live);
        return;
    }
    case AST_CRITICAL:
        sym_set_free(live);
        sym_set_init(live);
        for (int k = 0; k < st->ever_read.n; k++) sym_set_add(live, st->ever_read.items[k]);
        for (int k = 0; k < st->escaped.n; k++)   sym_set_add(live, st->escaped.items[k]);
        if (node->operand) dse_walk(node->operand, live, st);
        return;
    case OP_ASSIGN:
        if (node->right) dse_add_uses(node->right, live);
        if (node->left && node->left->ast_type == AST_LOCAL_VAR && node->left->sym)
            sym_set_remove(live, node->left->sym);
        else if (node->left)
            dse_add_uses(node->left, live);
        return;
    default:
        dse_add_uses(node, live);
        return;
    }
}

Node *ast_dse(Node *root)
{
    if (!root) return NULL;
    /* Iterate: dropping a store removes the AST_LOCAL_VAR mentions
       from `referenced`, which can in turn make the decl droppable on
       a subsequent pass. Capped to a few rounds; converges quickly in
       practice. */
    for (int iter = 0; iter < 4; iter++) {
        dse_state st;
        sym_set_init(&st.escaped);
        sym_set_init(&st.ever_read);
        sym_set_init(&st.referenced);
        dse_collect_escaped(root, &st.escaped);
        dse_collect_ever_read(root, &st.ever_read);
        dse_collect_referenced(root, &st.referenced);
        sym_set live;
        sym_set_init(&live);
        for (int k = 0; k < st.escaped.n; k++) sym_set_add(&live, st.escaped.items[k]);
        dse_walk(root, &live, &st);
        sym_set_free(&live);
        sym_set_free(&st.escaped);
        sym_set_free(&st.ever_read);
        sym_set_free(&st.referenced);
    }
    return root;
}

/* ----- Driver -------------------------------------------------------- */

/* Rewrite `(post++ X)` → `(pre++ X)` (and `post--` → `pre--`) when
   the expression's value is unused. This is the typical
   `for(...; i++)` and standalone `i++;` shape — the post-step
   walker would otherwise emit an extra "un-step" instruction
   purely to recover the OLD value, which is then discarded.

   Statement context propagates from a function body's outermost
   compound through child statements, and through the then/els
   branches of an AST_TERNARY when the ternary itself is in
   statement context (sccz80 reuses AST_TERNARY for `if`).
   The cond of any IF/TERNARY is value context — no rewrite there.
   AST_DECL.declvar is value context. */
static void demote_post_walk(Node *node, int stmt_ctx);

static void demote_post_at(Node *target)
{
    if (!target) return;
    /* Peel a single OP_DEREF — rvalue() in primary.c wraps a deref
       around step expressions out of habit. */
    if (target->ast_type == OP_DEREF && target->operand)
        target = target->operand;
    if (target->ast_type == OP_POST_INC) target->ast_type = OP_PRE_INC;
    else if (target->ast_type == OP_POST_DEC) target->ast_type = OP_PRE_DEC;
}

static void demote_post_walk(Node *node, int stmt_ctx)
{
    if (!node) return;
    switch (node->ast_type) {
    case AST_COMPOUND_STMT:
        for (int i = 0; i < (int)array_len(node->stmts); i++) {
            Node *s = array_get_byindex(node->stmts, i);
            if (!s) continue;
            demote_post_at(s);
            demote_post_walk(s, 1);
        }
        return;
    case AST_TERNARY:
        /* cond is value context. then / els inherit the parent's
           context — sccz80's AST_TERNARY is reused for both `if`
           statements (statement context, value unused) and true
           ternary expressions (value used). */
        demote_post_walk(node->cond, 0);
        if (stmt_ctx) {
            demote_post_at(node->then);
            demote_post_at(node->els);
        }
        demote_post_walk(node->then, stmt_ctx);
        demote_post_walk(node->els,  stmt_ctx);
        return;
    case AST_IF:
        demote_post_walk(node->cond, 0);
        demote_post_at(node->then);
        demote_post_at(node->els);
        demote_post_walk(node->then, 1);
        demote_post_walk(node->els,  1);
        return;
    case AST_SWITCH:
        demote_post_walk(node->sw_expr, 0);
        demote_post_walk(node->sw_body, 1);
        return;
    case AST_RETURN:
        demote_post_walk(node->retval, 0);
        return;
    case AST_DECL:
        demote_post_walk(node->declvar, 0);
        return;
    case AST_CRITICAL:
        demote_post_walk(node->operand, 1);
        return;
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(node->args); i++)
            demote_post_walk(array_get_byindex(node->args, i), 0);
        if (node->callee) demote_post_walk(node->callee, 0);
        return;
    /* Terminals — Node uses a UNION for variant fields so reading
       node->left etc. for an AST_LITERAL would return garbage from
       the zdouble bits. Don't recurse for these. */
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_UNDECL:
    case AST_LABEL:
    case AST_JUMP:
    case AST_INIT_STATIC:
    case AST_ASM:
    case AST_INIT_LIST:
        return;
    case AST_SWITCH_CASE:
        demote_post_walk(node->sw_value, 0);
        return;
    /* Binops — left/right are real Node*. */
    case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR:  case OP_XOR:
    case OP_EQ:  case OP_NE:
    case OP_LT:  case OP_LE:  case OP_GT:  case OP_GE:
    case OP_OROR: case OP_ANDAND:
    case OP_USHR: case OP_USHL: case OP_SSHR: case OP_SSHL:
    case OP_ASSIGN:
    case OP_AADD: case OP_ASUB:
    case OP_AMULT: case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        demote_post_walk(node->left,  0);
        demote_post_walk(node->right, 0);
        return;
    /* Unops — operand is a real Node*. The step ops themselves
       use this slot too (their operand is the lvalue), and we
       recurse so a step nested in something else still gets
       walked (no-op if value used). */
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_DEREF: case OP_ADDR:
    case AST_DEREF: case AST_ADDR:
    case OP_PRE_INC: case OP_POST_INC:
    case OP_PRE_DEC: case OP_POST_DEC:
    case OP_CAST:
    case OP_SIZEOF:
        demote_post_walk(node->operand, 0);
        return;
    default:
        /* Be conservative for unknown nodes — the union layout
           means a wrong field-access could be a use-after-garbage.
           If a new node type appears, add it explicitly. */
        return;
    }
}

Node *ast_demote_unused_poststep(Node *root)
{
    if (root) demote_post_walk(root, 1);
    return root;
}

/* ----- Loop reversal (count-up → count-down with djnz / dec bc) ------ */

/*
 * Detects the canonical for-loop shape emitted by stmt.c::dofor and
 * rewrites it as AST_LOOP_COUNTDOWN. The Z80 back-edge then becomes
 * `djnz` (8-bit count in B) or `dec bc; ld a,b; or c; jp nz` (16-bit
 * count in BC) — much tighter than `inc + cmp + cond-jp`.
 *
 * v1 preconditions (everything stricter than this declines silently):
 *
 *   for (iv = INIT_LIT; iv < BOUND_LIT; iv++) BODY
 *
 *   - INIT_LIT and BOUND_LIT are AST_LITERALs.
 *   - BOUND_LIT > INIT_LIT (positive trip count).
 *   - cond op is OP_LT, step is `iv++` (post or pre).
 *   - iv is a STKLOC local and IS NOT mentioned anywhere in BODY.
 *   - BODY contains no `break` (jump to the loop's exit label).
 *
 * The parser's for-loop shape at the parent compound is:
 *
 *   stmts[init_idx]      = OP_ASSIGN(LV iv, init_lit)  -- or AST_DECL
 *   stmts[label_idx]     = AST_LABEL l_condition          (entry point)
 *   stmts[label_idx + 1] = AST_TERNARY(cond, NULL, AST_JUMP(exit))
 *   stmts[label_idx + 2] = body (a single Node, may be compound)
 *   stmts[cont_idx]      = AST_LABEL wq.loop               (continue tgt)
 *   stmts[step_idx]      = step (`iv++`)
 *   stmts[back_idx]      = AST_JUMP l_condition            (back-edge)
 *   stmts[back_idx + 1]  = AST_LABEL wq.exit
 *
 * After rewrite:
 *
 *   stmts[init_idx]      = NULL
 *   stmts[label_idx]     = AST_LOOP_COUNTDOWN(trip_lit, body, exit, cont, w8)
 *   stmts[label_idx + 1] = NULL
 *   stmts[label_idx + 2] = NULL
 *   stmts[cont_idx]      = NULL
 *   stmts[step_idx]      = NULL
 *   stmts[back_idx]      = NULL
 *   stmts[back_idx + 1]  = NULL   (marker's walker re-emits exit label)
 *
 * BC clobbers inside the body (calls, asm, critical, nested countdown
 * loops) are wrapped in AST_PRESERVE_BC.
 */

/* TODO: when __preserve_regs lands on Type, read the regset and
   return 1 if BC (or B for djnz) is preserved by the callee. */
static int callee_preserves_bc(Node *call) { (void)call; return 0; }

static void wrap_bc_visit(const AstSlot *slot, void *ctx);

static void wrap_bc_clobbers(Node *body)
{
    if (!body) return;
    ast_for_each_child(body, wrap_bc_visit, NULL);
}

static void wrap_bc_visit(const AstSlot *slot, void *ctx)
{
    Node *n = ast_slot_get(slot);
    if (!n) return;
    int need_wrap = (n->ast_type == AST_FUNC_CALL
                  || n->ast_type == AST_FUNCPTR_CALL
                  || n->ast_type == AST_ASM
                  || n->ast_type == AST_CRITICAL
                  || n->ast_type == AST_LOOP_COUNTDOWN);
    if (need_wrap && !callee_preserves_bc(n)) {
        /* Recurse into children first so any nested clobber inside an
           arg is wrapped too (and lives inside our outer push/pop). */
        ast_for_each_child(n, wrap_bc_visit, ctx);
        ast_slot_set(slot, ast_preserve_bc(n));
        return;
    }
    ast_for_each_child(n, wrap_bc_visit, ctx);
}

/* Peel a single OP_DEREF rvalue wrap if present. */
static Node *peel_deref(Node *n)
{
    if (n && (n->ast_type == OP_DEREF || n->ast_type == AST_DEREF) && n->operand)
        return n->operand;
    return n;
}

/* doexpr() wraps every expression-statement in a single-stmt
   AST_COMPOUND_STMT. Peel through any such singleton-compounds (NULL
   slots from earlier passes are skipped). Returns the inner stmt, or
   the original node if it isn't a singleton. */
static Node *peel_singleton_compound(Node *n)
{
    while (n && n->ast_type == AST_COMPOUND_STMT && n->stmts) {
        Node *single = NULL;
        int len = (int)array_len(n->stmts);
        for (int i = 0; i < len; i++) {
            Node *s = array_get_byindex(n->stmts, i);
            if (!s) continue;
            if (single) return n;  /* >1 non-NULL stmt — not a singleton */
            single = s;
        }
        if (!single) return n;
        n = single;
    }
    return n;
}

/* Extract a sym written by a step expression, returning the step
   direction (+1 / -1) or 0 if not recognisable. */
static int extract_step(Node *step, SYMBOL **out_sym)
{
    if (!step) return 0;
    Node *s = peel_deref(peel_singleton_compound(step));
    int dir = 0;
    if (s->ast_type == OP_POST_INC || s->ast_type == OP_PRE_INC) dir = +1;
    else if (s->ast_type == OP_POST_DEC || s->ast_type == OP_PRE_DEC) dir = -1;
    else return 0;
    Node *op = peel_deref(s->operand);
    if (!op || op->ast_type != AST_LOCAL_VAR) return 0;
    *out_sym = op->sym;
    return dir;
}

typedef struct loop_recognized {
    SYMBOL *iv;
    int   init_value;
    int   bound_value;
    int   trip_count;     /* always positive */
    int   cond_op;
    int   step_dir;

    int   label_idx;      /* AST_LABEL l_condition */
    int   test_idx;       /* AST_TERNARY exit-cond */
    int   body_idx;       /* the body node (single slot) */
    int   cont_label_idx; /* AST_LABEL wq.loop */
    int   step_idx;       /* incr stmt (may be -1 if absent) */
    int   back_jump_idx;  /* AST_JUMP back to l_condition */
    int   exit_label_idx; /* AST_LABEL wq.exit (== back_jump_idx + 1) */
    int   init_idx;       /* preceding OP_ASSIGN or AST_DECL */

    int   exit_label;     /* label number */
    int   cont_label;     /* label number */
    int   init_is_decl;   /* init was AST_DECL (iv scoped to the loop) */
} loop_recognized;

static int try_recognize_loop(array *stmts, int label_idx, loop_recognized *out)
{
    int n = (int)array_len(stmts);
    if (label_idx < 1 || label_idx + 5 >= n) return 0;

    Node *top = array_get_byindex(stmts, label_idx);
    if (!top || top->ast_type != AST_LABEL) return 0;
    int l_condition = top->label;

    Node *test = array_get_byindex(stmts, label_idx + 1);
    if (!test || test->ast_type != AST_TERNARY) return 0;
    if (test->then != NULL) return 0;
    if (!test->els || test->els->ast_type != AST_JUMP) return 0;
    int exit_label = test->els->label;

    /* Locate the back-jump and the continue label between them. */
    int back_jump_idx = -1;
    for (int k = label_idx + 2; k < n; k++) {
        Node *s = array_get_byindex(stmts, k);
        if (!s) continue;
        if (s->ast_type == AST_JUMP && s->label == l_condition) {
            back_jump_idx = k;
            break;
        }
        if (s->ast_type == AST_LABEL && s->label == exit_label)
            return 0;   /* exit before back-jump = malformed */
    }
    if (back_jump_idx < 0) return 0;

    /* The step (incr) sits immediately before the back-jump (modulo
       NULL slots from earlier passes). Walk backward from
       back_jump_idx - 1, skipping NULLs, to find it. */
    int step_idx = -1;
    for (int k = back_jump_idx - 1; k > label_idx + 1; k--) {
        Node *s = array_get_byindex(stmts, k);
        if (s) { step_idx = k; break; }
    }
    if (step_idx < 0) return 0;

    SYMBOL *iv = NULL;
    int step_dir = extract_step(array_get_byindex(stmts, step_idx), &iv);
    if (!iv || step_dir != +1) return 0;
    if (iv->storage != STKLOC) return 0;

    /* Optional continue label immediately before the step. If the
       threading pass dropped it (no `continue` in body → uses==0),
       step is directly preceded by the body. */
    int cont_label_idx = -1;
    for (int k = step_idx - 1; k > label_idx + 1; k--) {
        Node *s = array_get_byindex(stmts, k);
        if (!s) continue;
        if (s->ast_type == AST_LABEL && s->label != l_condition
            && s->label != exit_label) {
            cont_label_idx = k;
        }
        break;     /* first non-NULL backward is either the label or body */
    }

    /* Body span: [label_idx + 2, body_end). v1 requires exactly one
       node in the span. */
    int body_end = (cont_label_idx >= 0) ? cont_label_idx : step_idx;
    int body_idx = -1;
    int body_count = 0;
    for (int k = label_idx + 2; k < body_end; k++) {
        if (array_get_byindex(stmts, k)) {
            body_idx = k;
            body_count++;
        }
    }
    if (body_count != 1) return 0;
    Node *body = array_get_byindex(stmts, body_idx);

    /* Body must not mention iv (the IV-used-in-body case is parked). */
    if (body && subtree_mentions(body, iv)) return 0;

    /* No `break` inside body. */
    if (body && stmt_contains_jump_to(body, exit_label)) return 0;

    /* Cond: `iv < literal`. Only OP_LT for v1. */
    Node *cond = peel_deref(test->cond);
    if (!cond || cond->ast_type != OP_LT) return 0;
    if (!cond->left || !cond->right) return 0;
    Node *lh = peel_deref(cond->left);
    if (!lh || lh->ast_type != AST_LOCAL_VAR || lh->sym != iv) return 0;
    if (cond->right->ast_type != AST_LITERAL) return 0;
    int bound = (int)cond->right->zval;

    /* Init at label_idx - 1: `iv = literal` (OP_ASSIGN or AST_DECL).
       doexpr-wrapped expressions arrive as a singleton compound. */
    int init_idx = label_idx - 1;
    Node *init = peel_singleton_compound(array_get_byindex(stmts, init_idx));
    int init_value = 0;
    int have_init = 0;
    int init_is_decl = 0;
    if (init) {
        if (init->ast_type == OP_ASSIGN && init->left && init->right
            && init->right->ast_type == AST_LITERAL) {
            Node *lhs = peel_deref(init->left);
            if (lhs && lhs->ast_type == AST_LOCAL_VAR && lhs->sym == iv) {
                init_value = (int)init->right->zval;
                have_init = 1;
            }
        } else if (init->ast_type == AST_DECL && init->sym == iv
                && init->declvar && init->declvar->ast_type == AST_LITERAL) {
            init_value = (int)init->declvar->zval;
            have_init = 1;
            init_is_decl = 1;   /* iv declared in the for → scoped to it */
        }
    }
    if (!have_init) return 0;

    int trip = bound - init_value;
    if (trip <= 0) return 0;

    /* Confirm stmts[back_jump_idx + 1] is the exit AST_LABEL. */
    int exit_label_idx = back_jump_idx + 1;
    if (exit_label_idx >= n) return 0;
    Node *maybe_exit = array_get_byindex(stmts, exit_label_idx);
    if (!maybe_exit || maybe_exit->ast_type != AST_LABEL
        || maybe_exit->label != exit_label)
        return 0;

    Node *cont_lbl = (cont_label_idx >= 0)
                   ? array_get_byindex(stmts, cont_label_idx) : NULL;

    out->iv = iv;
    out->init_value = init_value;
    out->bound_value = bound;
    out->trip_count = trip;
    out->cond_op = cond->ast_type;
    out->step_dir = step_dir;
    out->label_idx = label_idx;
    out->test_idx = label_idx + 1;
    out->body_idx = body_idx;
    out->cont_label_idx = cont_label_idx;
    out->step_idx = step_idx;
    out->back_jump_idx = back_jump_idx;
    out->exit_label_idx = exit_label_idx;
    out->init_idx = init_idx;
    out->exit_label = exit_label;
    out->cont_label = cont_lbl ? cont_lbl->label : 0;
    out->init_is_decl = init_is_decl;
    return 1;
}

static int try_reverse_loop(array *stmts, int label_idx)
{
    loop_recognized info;
    if (!try_recognize_loop(stmts, label_idx, &info)) return 0;

    int width8 = (info.trip_count <= 255);
    Type *ctype = width8 ? type_uchar : type_uint;
    Node *counter_init = ast_literal(ctype, (zdouble)info.trip_count);

    Node *body = array_get_byindex(stmts, info.body_idx);
    wrap_bc_clobbers(body);

    Node *marker = ast_loop_countdown(counter_init, body,
                                      info.exit_label,
                                      info.cont_label,
                                      width8);

    array_set_byindex(stmts, info.init_idx, NULL);
    array_set_byindex(stmts, info.label_idx, marker);
    array_set_byindex(stmts, info.test_idx, NULL);
    array_set_byindex(stmts, info.body_idx, NULL);
    if (info.cont_label_idx >= 0)
        array_set_byindex(stmts, info.cont_label_idx, NULL);
    array_set_byindex(stmts, info.step_idx, NULL);
    array_set_byindex(stmts, info.back_jump_idx, NULL);
    /* Restore the induction variable's post-loop value. The original
       `for (iv = init; iv < bound; iv++)` leaves iv == bound on exit; the
       countdown counter is a fresh temp, so without this any later read of
       iv (e.g. `assertEqual(i, 10)`) saw a stale value. Placed at the
       (now-removed) exit-label slot so it builds into the loop's exit BB,
       which the countdown marker already created from info.exit_label. If
       iv is dead afterwards, IR DCE drops the store.
       Skip when iv was declared in the for header (`for (int iv ...)`): it
       is scoped to the loop, so it is never read afterwards AND a reference
       to it past its scope doesn't translate to IR. */
    if (!info.init_is_decl) {
        Node *iv_lhs = ast_local_var(info.iv, info.iv->name);
        Node *iv_val = ast_literal(info.iv->ctype, (zdouble)info.bound_value);
        Node *iv_restore = ast_binop(OP_ASSIGN, iv_lhs, iv_val);
        iv_restore->type = info.iv->ctype;
        array_set_byindex(stmts, info.exit_label_idx, iv_restore);
    } else {
        array_set_byindex(stmts, info.exit_label_idx, NULL);
    }
    return 1;
}

static void rev_walk(Node *node);

static void rev_walk_visit(const AstSlot *slot, void *ctx)
{
    (void)ctx;
    rev_walk(ast_slot_get(slot));
}

static void rev_walk(Node *node)
{
    if (!node) return;
    /* Recurse children first so inner loops get reversed before outer
       attempts to (which never fires for v1 anyway, since outer would
       see the inner loop's wrapped body and reject body-references). */
    ast_for_each_child(node, rev_walk_visit, NULL);
    if (node->ast_type == AST_COMPOUND_STMT) {
        int n = (int)array_len(node->stmts);
        for (int i = 0; i < n; i++) try_reverse_loop(node->stmts, i);
    }
}

Node *ast_loop_reverse(Node *root)
{
    if (root) rev_walk(root);
    return root;
}

Node *ast_opt_run(Node *root)
{
    if (!root) return NULL;
    /* Normalise types first so the passes can inspect node->type for
       signedness, kind, and operator-result types. The strength-reduce
       pass uses these to decide whether `x / 4` can become `x >> 2`
       (only for unsigned). The normaliser is not gated — downstream
       code (and the walker itself) relies on node->type being set. */
    ast_normalize_types(root);
    if (!(c_opt_disable & OPT_DISABLE_FOLD)) root = ast_fold_constants(root);
    if (!(c_opt_disable & OPT_DISABLE_PROP)) root = ast_const_propagate(root);
    /* Re-fold: propagation may have created new fully-literal sub-trees
       (e.g. `int x = 5; int y = x + 1;` → `int y = 5 + 1;` → fold to 6). */
    if (!(c_opt_disable & OPT_DISABLE_FOLD)) root = ast_fold_constants(root);
    if (!(c_opt_disable & OPT_DISABLE_SIMPLIFY)) root = ast_simplify_algebraic(root);
    /* Simplification can produce new fully-literal sub-trees (e.g.
       `x == x` → `1`, then an enclosing `!(x==x)` becomes `!(1)` which
       is fold-able). One more fold collapses these. */
    if (!(c_opt_disable & OPT_DISABLE_FOLD)) root = ast_fold_constants(root);
    /* Type-check pass: pure-warning diagnostics for type mismatches
       (signedness, ptr/non-ptr comparisons, ptr+int direction, ptr-ptr
       mismatch, far→near narrowing). Runs after const-prop + fold so
       constant-revealed literal operands silence the warning, matching
       legacy parser semantics. Must run before ast_strength_reduce —
       which rewrites `x/4` to `x>>2` and would hide signedness checks
       on OP_DIV. */
    if (!(c_opt_disable & OPT_DISABLE_TYPECHECK)) ast_typecheck(root);
    /* #231: rewrite `a = a op b` → `a op= b` for bare lvalues. Run
       before strength_reduce so the compound form gets the same
       const-RHS treatment via cg2_compound_assign's *_const helpers. */
    if (!(c_opt_disable & OPT_DISABLE_COMPOUNDIFY)) root = ast_compoundify_assign(root);
    if (!(c_opt_disable & OPT_DISABLE_STRENGTH_REDUCE)) root = ast_strength_reduce(root);
    /* CSE runs after const-prop / fold / simplify so it operates on
       the maximally-reduced tree. Pure-literal expressions are gone
       by now, so anything CSE catches is genuinely a non-trivial
       computation worth sharing. Stage 1 (binding-based) reuses
       existing locals; stage 2 synthesizes `1cse_<n>` temps for
       shared SEF expressions that have no convenient existing local. */
    if (!(c_opt_disable & OPT_DISABLE_CSE)) root = ast_cse(root);
    if (!(c_opt_disable & OPT_DISABLE_CSE_SYNTH)) root = ast_cse_synthesize(root);
    /* LICM runs after CSE so it sees a maximally-shared body. Hoisting
       a single shared expression is more impactful than hoisting two
       separate copies. Threading hasn't run yet — the loop's
       LABEL/JUMP back-edges are intact for LICM to recognize. */
    if (!(c_opt_disable & OPT_DISABLE_LICM)) root = ast_licm(root);
    /* DSE runs after const-prop / fold / simplify / CSE / LICM because
       those passes frequently *create* dead stores by folding away
       the consumer of an assignment. */
    if (!(c_opt_disable & OPT_DISABLE_DSE)) root = ast_dse(root);
    if (!(c_opt_disable & OPT_DISABLE_DEAD_CODE)) root = ast_dead_code(root);
    /* Threading runs last so it sees the final shape after dead-code
       has dropped post-exit siblings (which would otherwise contain
       jumps that no longer matter). */
    if (!(c_opt_disable & OPT_DISABLE_THREAD_JUMPS)) root = ast_thread_jumps(root);
    /* Threading may drop a label that was previously protecting a
       region from dead-code's post-exit sweep. Re-run dead-code so
       newly-orphaned siblings don't survive. */
    if (!(c_opt_disable & OPT_DISABLE_DEAD_CODE)) root = ast_dead_code(root);
    /* Demote post→pre on step expressions whose value goes unused
       — saves the un-step instruction the walker would otherwise
       emit to recover the OLD value. Common in `for(...; i++)`. */
    if (!(c_opt_disable & OPT_DISABLE_DEMOTE_POSTSTEP)) root = ast_demote_unused_poststep(root);
    /* Loop reversal runs last so the original LABEL/JUMP loop shape is
       intact for threading, dead-code, demote etc. above. */
    if (!(c_opt_disable & OPT_DISABLE_LOOP_REVERSE)) root = ast_loop_reverse(root);
    return root;
}

/* ----- Local constant propagation ----------------------------------- */

/*
 * Conservative single-function constant propagation. Walks the AST
 * top-down keeping a small (SYMBOL* → AST_LITERAL) environment. Uses
 * of a tracked local through OP_DEREF(AST_LOCAL_VAR) are substituted
 * with a clone of the literal.
 *
 * Invalidations:
 *   - assignment to the var
 *   - pre/post-step on the var
 *   - address-of (`&x`) — once a pointer escapes we can't track writes
 *   - any function call seen anywhere in the tree (might write through
 *     escaped pointers / globals / locals via earlier &x)
 * Nested control structures (if-bodies, loop bodies): the env is passed
 * down by *copy*; modifications inside don't leak back.
 * Loops: invalidate everything before entering the body — any var
 * mutated by the loop body would otherwise be propagated wrongly past
 * the first iteration.
 *
 * Statics, volatile, and ports are excluded from tracking. Globals are
 * out of scope: tracking them safely requires aliasing analysis.
 */

typedef struct prop_entry {
    SYMBOL *sym;
    Node   *lit;     /* AST_LITERAL */
} prop_entry;

typedef struct prop_env {
    prop_entry *entries;
    int n;
    int cap;
} prop_env;

static void prop_env_init(prop_env *e) { e->entries = NULL; e->n = 0; e->cap = 0; }

static void prop_env_free(prop_env *e) { if (e->entries) free(e->entries); e->entries = NULL; e->n = 0; e->cap = 0; }

static void prop_env_clone(prop_env *dst, const prop_env *src) {
    dst->n = src->n;
    dst->cap = src->n;
    dst->entries = src->n ? malloc(sizeof(prop_entry) * src->n) : NULL;
    if (src->n) memcpy(dst->entries, src->entries, sizeof(prop_entry) * src->n);
}

static int prop_env_find(const prop_env *e, SYMBOL *sym) {
    for (int i = 0; i < e->n; i++) if (e->entries[i].sym == sym) return i;
    return -1;
}

static Node *prop_env_lookup(const prop_env *e, SYMBOL *sym) {
    int idx = prop_env_find(e, sym);
    return idx >= 0 ? e->entries[idx].lit : NULL;
}

static void prop_env_set(prop_env *e, SYMBOL *sym, Node *lit) {
    int idx = prop_env_find(e, sym);
    if (idx >= 0) {
        e->entries[idx].lit = lit;
        return;
    }
    if (e->n == e->cap) {
        e->cap = e->cap ? e->cap * 2 : 4;
        e->entries = realloc(e->entries, sizeof(prop_entry) * e->cap);
    }
    e->entries[e->n].sym = sym;
    e->entries[e->n].lit = lit;
    e->n++;
}

static void prop_env_remove(prop_env *e, SYMBOL *sym) {
    int idx = prop_env_find(e, sym);
    if (idx < 0) return;
    for (int i = idx; i < e->n - 1; i++) e->entries[i] = e->entries[i+1];
    e->n--;
}

static void prop_env_clear(prop_env *e) { e->n = 0; }

/* Is this symbol eligible for tracking? Locals only, non-static,
   non-volatile, non-port, has a usable type. */
static int prop_eligible(SYMBOL *sym)
{
    if (!sym) return 0;
    if (sym->storage != STKLOC) return 0;
    if (sym->ctype && sym->ctype->isvolatile) return 0;
    if (sym->type == KIND_PORT8 || sym->type == KIND_PORT16) return 0;
    return 1;
}

/* Function-wide set of locals whose address has escaped (an
   AST_ADDR / OP_ADDR of a local appears somewhere in the function).
   Tracked lexically: an indirect store through any pointer
   (`*p = …`, `arr[i] = …`, `*p += …`) invalidates exactly the syms
   in this set, since non-escaped locals are provably non-aliased.
   Set is monotonic within a function — &local can't be "untaken" —
   so it doesn't get cloned with prop_env across if/then/else.
   Initialised at ast_const_propagate entry, freed at exit. */
static sym_set prop_escaped;

static void prop_env_invalidate_escaped(prop_env *e)
{
    if (!prop_escaped.n) return;
    for (int i = e->n - 1; i >= 0; i--) {
        if (sym_set_contains(&prop_escaped, e->entries[i].sym)) {
            for (int j = i; j < e->n - 1; j++) e->entries[j] = e->entries[j+1];
            e->n--;
        }
    }
}

/* Forward decls for the recursive walker. */
static Node *prop_walk(Node *node, prop_env *env, int *had_call_or_escape);

/* Detect things that would invalidate the whole env if seen anywhere
   inside an expression: function calls, address-of-local. We let
   prop_walk track these via the *had_call_or_escape flag during a
   single statement, then act on it once at statement boundary. */

/* Substitute a literal use for a tracked local. The OP_DEREF(LV) shape
   is what rvalue() builds for any local rvalue read. We clone the
   literal so each use has its own node — the fold/simplify passes are
   in-place mutators and shouldn't share substructure. */
static Node *clone_literal(Node *lit)
{
    Node *c = calloc(1, sizeof(Node));
    c->ast_type = AST_LITERAL;
    c->type = lit->type;
    c->zval = lit->zval;
    c->filename = lit->filename;
    c->line = lit->line;
    return c;
}

/* A read of a tracked local yields the local's DECLARED type, not the
   type of whatever constant was last stored into it. Coerce the stored
   literal to the symbol's type (widen / narrow + signedness) before
   tracking it, reusing the OP_CAST literal fold. Otherwise a narrow
   constant forwarded into a wider use is materialised at the constant's
   width and the use reads the wrong byte count — e.g. `long a = 0xffff`
   (0xffff is a 16-bit unsigned int) then `printf("%ld", a)` pushed a
   2-byte vararg for a %ld. Returns the (re-typed) literal, or NULL when
   it can't be safely retyped (caller then drops it from tracking). */
static Node *coerce_literal_to_sym(Node *lit, SYMBOL *sym)
{
    if (!lit || lit->ast_type != AST_LITERAL) return NULL;
    Type *st = sym ? sym->ctype : NULL;
    if (!st) return lit;
    if (lit->type && lit->type->kind == st->kind
        && !!lit->type->isunsigned == !!st->isunsigned)
        return lit;                              /* already the right type */
    Node *folded = ast_fold_constants(ast_cast(st, lit));
    if (folded && folded->ast_type == AST_LITERAL
        && folded->type && folded->type->kind == st->kind)
        return folded;
    return NULL;                                 /* can't retype → don't track */
}

/* Try to substitute one of the leaf node patterns we know how to
   propagate. Returns the replacement, or NULL if no substitution. */
static Node *try_substitute(Node *node, prop_env *env)
{
    if (!node) return NULL;
    /* OP_DEREF(LOCAL_VAR sym) — the rvalue-load form. */
    if (node->ast_type == OP_DEREF && node->operand
        && node->operand->ast_type == AST_LOCAL_VAR) {
        SYMBOL *sym = node->operand->sym;
        Node *lit = prop_env_lookup(env, sym);
        if (lit) return clone_literal(lit);
    }
    return NULL;
}

static Node *prop_walk(Node *node, prop_env *env, int *had_call_or_escape)
{
    if (!node) return NULL;

    /* Try to substitute first — if this is exactly OP_DEREF(LOCAL_VAR),
       the substitution short-circuits the recursion. */
    Node *sub = try_substitute(node, env);
    if (sub) return sub;

    switch (node->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_INIT_STATIC:
        return node;

    case AST_LABEL:
        /* A label can be the target of any jump — including back-edges
           from later in the function that reach this point with
           different state. Clear the env: anything tracked from the
           fall-through path may not hold for jump-arrivals. */
        prop_env_clear(env);
        return node;

    case AST_ASM:
        /* Inline asm is opaque: it can clobber registers, write through
           pointers, modify any local. Treat like a function call —
           mark the flag so the statement walker clears the env. */
        if (had_call_or_escape) *had_call_or_escape = 1;
        return node;

    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        /* Function call invalidates all tracked vars — but only AFTER
           the call's args/callee have had substitution applied. Mark
           the flag; the caller (statement walker) clears the env. */
        for (int i = 0; i < (int)array_len(node->args); i++) {
            Node *a = array_get_byindex(node->args, i);
            Node *r = prop_walk(a, env, had_call_or_escape);
            if (r != a) array_set_byindex(node->args, i, r);
        }
        if (node->callee) node->callee = prop_walk(node->callee, env, had_call_or_escape);
        if (had_call_or_escape) *had_call_or_escape = 1;
        return node;

    case AST_RETURN:
        if (node->retval) node->retval = prop_walk(node->retval, env, had_call_or_escape);
        return node;

    case AST_COMPOUND_STMT: {
        /* Each compound walks with a fresh-ish env — the caller may
           have pre-populated for outer scope; we modify in place but
           don't undo on exit. The caller wraps with a clone if it
           wants outer scope preserved. */
        int n = (int)array_len(node->stmts);
        for (int i = 0; i < n; i++) {
            Node *s = array_get_byindex(node->stmts, i);
            int local_had_call = 0;
            Node *r = prop_walk(s, env, &local_had_call);
            if (r != s) array_set_byindex(node->stmts, i, r);

            /* Apply post-statement env updates based on what the stmt did.
               Fold the RHS first — propagation may have substituted a
               literal use which now creates a fully-literal RHS. Without
               this in-line fold, chained props (a=10; b=a+5; c=b*2)
               would only propagate one level deep. */
            if (s) {
                if (s->ast_type == AST_DECL && s->sym && prop_eligible(s->sym)) {
                    if (s->declvar) s->declvar = ast_fold_constants(s->declvar);
                    Node *lit = (s->declvar && s->declvar->ast_type == AST_LITERAL)
                              ? coerce_literal_to_sym(s->declvar, s->sym) : NULL;
                    if (lit) prop_env_set(env, s->sym, lit);
                    else     prop_env_remove(env, s->sym);
                } else if (s->ast_type == OP_ASSIGN && s->left
                           && s->left->ast_type == AST_LOCAL_VAR && s->left->sym) {
                    if (s->right) s->right = ast_fold_constants(s->right);
                    Node *lit = (s->right && s->right->ast_type == AST_LITERAL
                                 && prop_eligible(s->left->sym))
                              ? coerce_literal_to_sym(s->right, s->left->sym) : NULL;
                    if (lit) prop_env_set(env, s->left->sym, lit);
                    else     prop_env_remove(env, s->left->sym);
                } else if ((s->ast_type == OP_AADD || s->ast_type == OP_ASUB
                            || s->ast_type == OP_AMULT || s->ast_type == OP_ADIV
                            || s->ast_type == OP_AMOD || s->ast_type == OP_AAND
                            || s->ast_type == OP_AOR  || s->ast_type == OP_AXOR
                            || s->ast_type == OP_ASSHR || s->ast_type == OP_ASSHL)
                           && s->left && s->left->ast_type == AST_LOCAL_VAR
                           && s->left->sym) {
                    prop_env_remove(env, s->left->sym);
                }
            }

            /* Function-call inside the stmt: clear all (any local could
               have been mutated through an earlier &x escape we missed,
               or via a pointer parameter). */
            if (local_had_call) prop_env_clear(env);
        }
        return node;
    }

    case AST_IF:
    case AST_TERNARY: {
        /* Cond evaluates in current env. Then/else are alternatives —
           run each on a copy of the env so they don't poison each
           other; after the join, conservatively keep only the
           intersection... too complex. Simpler: invalidate everything
           after the if. */
        if (node->cond) node->cond = prop_walk(node->cond, env, had_call_or_escape);
        prop_env then_env, else_env;
        prop_env_clone(&then_env, env);
        prop_env_clone(&else_env, env);
        if (node->then) node->then = prop_walk(node->then, &then_env, had_call_or_escape);
        if (node->els)  node->els  = prop_walk(node->els,  &else_env, had_call_or_escape);
        prop_env_free(&then_env);
        prop_env_free(&else_env);
        /* After the join, conservatively clear: either branch may have
           mutated tracked vars. */
        prop_env_clear(env);
        return node;
    }

    case AST_SWITCH:
        if (node->sw_expr) node->sw_expr = prop_walk(node->sw_expr, env, had_call_or_escape);
        if (node->sw_body) {
            prop_env body_env;
            prop_env_clone(&body_env, env);
            node->sw_body = prop_walk(node->sw_body, &body_env, had_call_or_escape);
            prop_env_free(&body_env);
        }
        prop_env_clear(env);
        return node;

    case AST_SWITCH_CASE:
        if (node->sw_value) node->sw_value = prop_walk(node->sw_value, env, had_call_or_escape);
        return node;

    case AST_DECL:
        if (node->declvar) node->declvar = prop_walk(node->declvar, env, had_call_or_escape);
        return node;

    case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(node->stmts); i++) {
            Node *e = array_get_byindex(node->stmts, i);
            Node *r = prop_walk(e, env, had_call_or_escape);
            if (r != e) array_set_byindex(node->stmts, i, r);
        }
        return node;

    case AST_CRITICAL:
        if (node->operand) node->operand = prop_walk(node->operand, env, had_call_or_escape);
        return node;

    case OP_ADDR: case AST_ADDR:
        /* `&local` — the address escapes. Invalidate that var, and
           remember the escape function-wide so subsequent indirect
           stores can selectively invalidate this sym (and only the
           syms that are actually aliasable). */
        if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
            && node->operand->sym) {
            prop_env_remove(env, node->operand->sym);
            sym_set_add(&prop_escaped, node->operand->sym);
        }
        if (node->operand) node->operand = prop_walk(node->operand, env, had_call_or_escape);
        return node;

    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
        /* Mutating step on a tracked local: invalidate. */
        if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
            && node->operand->sym) {
            prop_env_remove(env, node->operand->sym);
        }
        if (node->operand) node->operand = prop_walk(node->operand, env, had_call_or_escape);
        return node;

    case OP_DEREF:
    case AST_DEREF:
    case OP_NEG: case OP_COMP: case OP_LNEG:
    case OP_CAST: case OP_SIZEOF:
        if (node->operand) node->operand = prop_walk(node->operand, env, had_call_or_escape);
        return node;

    case OP_ASSIGN:
        /* RHS first (uses the OLD env), then LHS (which may have
           sub-expressions). The post-statement update in the
           AST_COMPOUND_STMT handler captures the effect for bare
           LV/GV LHS. For complex LHS (OP_DEREF — `*p = X`,
           `arr[i] = X`, `s->m = X`) an aliasing pointer may write
           to any escaped local; invalidate them all from env. */
        if (node->right) node->right = prop_walk(node->right, env, had_call_or_escape);
        if (node->left)  node->left  = prop_walk(node->left,  env, had_call_or_escape);
        if (node->left && (node->left->ast_type == OP_DEREF
                        || node->left->ast_type == AST_DEREF)) {
            prop_env_invalidate_escaped(env);
        }
        return node;

    case OP_AADD: case OP_ASUB: case OP_AMULT:
    case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHR: case OP_ASSHL:
        /* Compound assigns. The LHS in sccz80 is `OP_DEREF(X)` for
           every form — bare local has X = AST_LOCAL_VAR, complex
           has X = AST_LOCAL_VAR-pointer / OP_ADD(arr, idx) / etc.
           Bare-LV path: invalidate that sym only. Complex path:
           indirect store may alias any escaped local — invalidate
           the escape set. Substituting the LHS itself would replace
           the lvalue with a literal and break codegen, so the LHS
           walk is skipped. */
        if (node->right) node->right = prop_walk(node->right, env, had_call_or_escape);
        if (node->left && node->left->ast_type == OP_DEREF
            && node->left->operand
            && node->left->operand->ast_type == AST_LOCAL_VAR
            && node->left->operand->sym) {
            prop_env_remove(env, node->left->operand->sym);
        } else if (node->left && (node->left->ast_type == OP_DEREF
                               || node->left->ast_type == AST_DEREF)) {
            prop_env_invalidate_escaped(env);
        }
        return node;

    default:
        if (node->left)    node->left    = prop_walk(node->left,    env, had_call_or_escape);
        if (node->right)   node->right   = prop_walk(node->right,   env, had_call_or_escape);
        if (node->operand) node->operand = prop_walk(node->operand, env, had_call_or_escape);
        return node;
    }
}

Node *ast_const_propagate(Node *root)
{
    if (!root) return NULL;
    prop_env env;
    prop_env_init(&env);
    sym_set_init(&prop_escaped);
    int dummy = 0;
    Node *r = prop_walk(root, &env, &dummy);
    prop_env_free(&env);
    sym_set_free(&prop_escaped);
    return r;
}
