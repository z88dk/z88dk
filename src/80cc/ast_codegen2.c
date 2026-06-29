/*
 *      sccz80 — AST-driven codegen, second walker
 *
 *  Reuses primitives from `codegen.c`. The parser builds AST only;
 *  this walker is the sole emitter for the function body.
 *
 *  Phase B scope: frame planning with stack-slot coalescing.  All
 *  locals in the function body are assigned offsets via greedy
 *  coloring over an interference graph derived from scope nesting.
 *  A single `modstk(-frame_size,...)` is emitted at function entry;
 *  the matching deallocation is handled by `gen_leave_function` at
 *  function exit.
 *
 *  Walker support (Phase B + minimal Phase C):
 *    AST_COMPOUND_STMT, AST_RETURN, AST_LITERAL (16-bit int),
 *    AST_DECL (with optional SEF init),
 *    OP_DEREF(AST_LOCAL_VAR) (load),
 *    OP_ASSIGN(AST_LOCAL_VAR, RHS) — minimal subset.
 *
 *  See CODEGEN_FROM_AST_PLAN.md for the wider plan.
 */

#include "ccdefs.h"
#include <stdlib.h>

/* ----- AST type normalisation (was ast_codegen.c) -------------------- */

/* Type promotion for binary operations. Matches C integer-promotion
   rules for the kinds sccz80 supports. ACCUM16/ACCUM32 sit alongside
   the floating kinds because they share the same walker dispatch
   (decimal-class storage). */
/* C §6.3.1.8 "usual arithmetic conversions" — picks the result type
   for a binop on two integer types after integer promotions. Three
   sub-rules:
     1. Same rank: if either operand is unsigned, result is unsigned.
     2. Higher-ranked operand is unsigned: result is that operand.
     3. Higher-ranked operand is signed: if it can represent all
        values of the smaller (size_bytes > smaller.size_bytes since
        z80 widths are 1/2/4/8 — strictly greater means the signed
        range covers the unsigned), result is the signed higher.
        Otherwise return the unsigned variant of the higher rank.
   For sccz80's z80 size table (int 2B, long 4B, longlong 8B) the
   "otherwise" branch never fires — each rank's signed type strictly
   wider in bytes than the smaller's unsigned — but keep it for safety. */
static Type *promote_integer_pair(Type *t1, Type *t2,
                                  Type *signed_same, Type *unsigned_same,
                                  Kind same_kind)
{
    /* Same rank case. */
    int t1_same = (t1->kind == same_kind);
    int t2_same = (t2->kind == same_kind);
    if (t1_same && t2_same)
        return (t1->isunsigned || t2->isunsigned) ? unsigned_same : signed_same;
    /* Cross-rank: the operand with `same_kind` is the higher rank. */
    Type *higher  = t1_same ? t1 : t2;
    Type *smaller = t1_same ? t2 : t1;
    if (higher->isunsigned) return higher;
    /* Higher signed; can it represent the smaller unsigned? Yes iff
       its size is strictly greater (z80's doubling-rank size table). */
    if (smaller->isunsigned && higher->size <= smaller->size)
        return unsigned_same;
    return higher;
}

static Type *promote_types(Type *t1, Type *t2)
{
    if (!t1) return t2;
    if (!t2) return t1;
    /* Pointer arithmetic preserves the pointer-ness: (ptr + int) is
       still a pointer address. Without this, OP_ADD demotes a pointer
       expression to a plain int — affecting downstream type
       inspection (e.g. ast_typecheck's pointer-vs-non-pointer check
       on a comparison like `p == &arr[5]`) and far-pointer codegen
       which needs to see KIND_CPTR through the arithmetic. */
    if (t1->kind == KIND_CPTR)                                  return t1;
    if (t2->kind == KIND_CPTR)                                  return t2;
    if (t1->kind == KIND_PTR || t1->kind == KIND_ARRAY)         return t1;
    if (t2->kind == KIND_PTR || t2->kind == KIND_ARRAY)         return t2;
    if (t1->kind == KIND_DOUBLE   || t2->kind == KIND_DOUBLE)   return type_double;
    if (t1->kind == KIND_FLOAT16  || t2->kind == KIND_FLOAT16)  return type_float16;
    if (t1->kind == KIND_ACCUM32  || t2->kind == KIND_ACCUM32)  return type_accum32;
    if (t1->kind == KIND_ACCUM16  || t2->kind == KIND_ACCUM16)  return type_accum16;
    if (t1->kind == KIND_LONGLONG || t2->kind == KIND_LONGLONG)
        return promote_integer_pair(t1, t2, type_longlong, type_ulonglong, KIND_LONGLONG);
    if (t1->kind == KIND_LONG || t2->kind == KIND_LONG)
        return promote_integer_pair(t1, t2, type_long, type_ulong, KIND_LONG);
    if (t1->kind == KIND_INT || t2->kind == KIND_INT)
        return promote_integer_pair(t1, t2, type_int, type_uint, KIND_INT);
    return type_int;
}

static void normalize_types(Node *node)
{
    if (!node) return;
    switch (node->ast_type) {
    case AST_LITERAL:
    case AST_STR_LIT:
    case AST_LOCAL_VAR:
    case AST_GLOBAL_VAR:
        break;
    case AST_FUNC_CALL:
        for (int i = 0; i < array_len(node->args); i++)
            normalize_types(array_get_byindex(node->args, i));
        /* Unwrap node->type from `KIND_FUNC` to the function's
           return type. The parser stamps the call node with the
           function's full type at construction; without unwrapping
           here, downstream type inspection (cg2_cast in particular)
           sees KIND_FUNC and skips the type conversion — e.g. a
           `_Accum` return from `(int)foo()` would emit no
           `l_fix16_f2sint`. Only applied to direct calls;
           AST_FUNCPTR_CALL has its own legacy arg-order quirk
           that's masked by leaving type as-is. */
        if (node->type && node->type->kind == KIND_FUNC
            && node->type->return_type) {
            node->type = node->type->return_type;
        }
        break;
    case AST_FUNCPTR_CALL:
        for (int i = 0; i < array_len(node->args); i++)
            normalize_types(array_get_byindex(node->args, i));
        break;
    case OP_USHR: case OP_USHL: case OP_SSHR: case OP_SSHL:
        /* Shifts don't apply the usual arithmetic conversions —
           C §6.5.7: result type is the LHS type (after integer
           promotion for narrower-than-int operands). Lumping these
           with arith ops via promote_types caused `unsigned long
           >> 1` to land as plain `long`, dropping the unsignedness
           that codegen.c::asr_const reads to choose `srl d` vs
           `sra d` — meaning the unsigned-correct logical shift
           never fired. */
        normalize_types(node->left);
        normalize_types(node->right);
        if (node->left && node->left->type) {
            Kind lk = node->left->type->kind;
            if (lk == KIND_CHAR) node->type = type_int;  /* int-promotion */
            else                 node->type = node->left->type;
        }
        break;
    case OP_MULT: case OP_DIV: case OP_MOD: case OP_ADD: case OP_SUB:
    case OP_OR: case OP_AND: case OP_XOR:
        normalize_types(node->left);
        normalize_types(node->right);
        node->type = promote_types(node->left->type, node->right->type);
        /* `ptr - ptr` is the one case where promote_types over-counts:
           C semantics say the result is ptrdiff_t (integer), not a
           pointer. Override here so downstream type inspection
           (ast_typecheck, comparison result type, etc.) sees an int. */
        if (node->ast_type == OP_SUB
            && node->left->type && node->right->type
            && (node->left->type->kind == KIND_PTR
                || node->left->type->kind == KIND_CPTR
                || node->left->type->kind == KIND_ARRAY)
            && (node->right->type->kind == KIND_PTR
                || node->right->type->kind == KIND_CPTR
                || node->right->type->kind == KIND_ARRAY)) {
            node->type = type_int;
        }
        break;
    case OP_EQ: case OP_NE: case OP_GT: case OP_GE: case OP_LT: case OP_LE:
    case OP_OROR: case OP_ANDAND:
        /* Comparisons / logical ops yield `int` regardless of operand
           promotion. Operand types still need normalising for the
           walker's signedness-aware dispatch. */
        normalize_types(node->left);
        normalize_types(node->right);
        if (!node->type) node->type = type_int;
        break;
    case OP_PRE_INC: case OP_POST_INC: case OP_PRE_DEC: case OP_POST_DEC:
    case OP_COMP: case OP_LNEG: case OP_NEG:
        normalize_types(node->operand);
        if (!node->type) node->type = node->operand->type;
        break;
    case OP_DEREF:
        /* Preserve the storage type the parser stamped on the load
           — don't overwrite. */
        normalize_types(node->operand);
        if (!node->type) node->type = node->operand->type;
        break;
    case OP_ADDR:
        /* &x has type `pointer to operand-type`. The parser wraps
           with OP_ADDR but leaves node->type unset (it tracks the
           pointee type on the LVALUE struct separately), so we
           reconstruct it here. Without this, downstream consumers
           (variadic arg-size calculation, cg2_func_call's push-
           width dispatch, ast_typecheck) see `&long_local` as
           `long` and push 4 bytes instead of 2. */
        normalize_types(node->operand);
        if (!node->type) {
            Type *pointee = node->operand ? node->operand->type : NULL;
            node->type = pointee ? make_pointer(pointee) : type_int;
        }
        break;
    case OP_ASSIGN: case OP_AADD: case OP_ASUB:
    case OP_AMULT: case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR: case OP_AXOR:
    case OP_ASSHL: case OP_ASSHR:
        normalize_types(node->left);
        normalize_types(node->right);
        if (!node->type) node->type = node->left->type;
        break;
    case OP_CAST:
        normalize_types(node->operand);
        /* node->type is set by the parser to the cast target. */
        break;
    case AST_TERNARY:
        normalize_types(node->cond);
        if (node->then) normalize_types(node->then);
        if (node->els)  normalize_types(node->els);
        if (!node->type && node->then && node->els)
            node->type = promote_types(node->then->type, node->els->type);
        break;
    case AST_RETURN:
        normalize_types(node->retval);
        node->type = node->retval ? node->retval->type : type_void;
        break;
    case AST_COMPOUND_STMT:
        for (int i = 0; i < array_len(node->stmts); i++)
            normalize_types(array_get_byindex(node->stmts, i));
        break;
    case AST_IF:
        normalize_types(node->cond);
        normalize_types(node->then);
        if (node->els) normalize_types(node->els);
        break;
    case AST_SWITCH:
        normalize_types(node->sw_expr);
        if (node->sw_body) normalize_types(node->sw_body);
        break;
    case AST_SWITCH_CASE:
        normalize_types(node->sw_value);
        break;
    case AST_CRITICAL:
        normalize_types(node->operand);
        break;
    case AST_LABEL:
    case AST_JUMP:
    case AST_UNDECL:
    case AST_ASM:
        break;
    case AST_DECL:
        if (node->declvar) normalize_types(node->declvar);
        break;
    default:
        break;
    }
}

void ast_normalize_types(Node *node) { normalize_types(node); }

/* ----- Frame planning ------------------------------------------------ */

typedef struct cg2_decl {
    SYMBOL *sym;
    int     size;            /* bytes */
    int     scope_id;
    int     always_interferes; /* escaped, volatile */
    int     offset;          /* assigned by coloring (negative) */
    int     placed;
    int     hotness;         /* loop-depth-weighted ref count (#257) */
} cg2_decl;

typedef struct cg2_scope {
    int parent_id;           /* -1 for root */
} cg2_scope;

typedef struct cg2_plan {
    cg2_decl *decls;
    int       n_decls;
    int       cap_decls;
    cg2_scope *scopes;
    int        n_scopes;
    int        cap_scopes;
    int        frame_size;
    /* Set of escaped SYMBOLs (& taken anywhere in the function). */
    SYMBOL **escaped;
    int      n_escaped;
    int      cap_escaped;
} cg2_plan;

static void plan_init(cg2_plan *p)
{
    memset(p, 0, sizeof(*p));
}

static void plan_free(cg2_plan *p)
{
    free(p->decls); free(p->scopes); free(p->escaped);
    memset(p, 0, sizeof(*p));
}

static int plan_add_scope(cg2_plan *p, int parent_id)
{
    if (p->n_scopes == p->cap_scopes) {
        p->cap_scopes = p->cap_scopes ? p->cap_scopes * 2 : 4;
        p->scopes = realloc(p->scopes, sizeof(cg2_scope) * p->cap_scopes);
    }
    p->scopes[p->n_scopes].parent_id = parent_id;
    return p->n_scopes++;
}

static int escaped_contains(cg2_plan *p, SYMBOL *s)
{
    for (int i = 0; i < p->n_escaped; i++) if (p->escaped[i] == s) return 1;
    return 0;
}

static void escaped_add(cg2_plan *p, SYMBOL *s)
{
    if (!s || escaped_contains(p, s)) return;
    if (p->n_escaped == p->cap_escaped) {
        p->cap_escaped = p->cap_escaped ? p->cap_escaped * 2 : 4;
        p->escaped = realloc(p->escaped, sizeof(SYMBOL *) * p->cap_escaped);
    }
    p->escaped[p->n_escaped++] = s;
}

/* Walk the function body marking any local whose & is taken. Mirrors
   ast_opt.c's dse_collect_escaped — kept local to ast_codegen2 so we
   don't depend on its private symbols. */
static void plan_collect_escaped(Node *n, cg2_plan *p)
{
    if (!n) return;
    switch (n->ast_type) {
    case AST_LITERAL: case AST_STR_LIT:
    case AST_LOCAL_VAR: case AST_GLOBAL_VAR:
    case AST_LABEL: case AST_JUMP: case AST_UNDECL:
    case AST_INIT_STATIC: case AST_ASM:
        return;
    case OP_ADDR: case AST_ADDR:
        if (n->operand && n->operand->ast_type == AST_LOCAL_VAR
            && n->operand->sym) {
            escaped_add(p, n->operand->sym);
        }
        if (n->operand) plan_collect_escaped(n->operand, p);
        return;
    case AST_FUNC_CALL: case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(n->args); i++)
            plan_collect_escaped(array_get_byindex(n->args, i), p);
        if (n->callee) plan_collect_escaped(n->callee, p);
        return;
    case AST_COMPOUND_STMT: case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(n->stmts); i++)
            plan_collect_escaped(array_get_byindex(n->stmts, i), p);
        return;
    case AST_RETURN:
        plan_collect_escaped(n->retval, p); return;
    case AST_IF: case AST_TERNARY:
        plan_collect_escaped(n->cond, p);
        plan_collect_escaped(n->then, p);
        plan_collect_escaped(n->els,  p);
        return;
    case AST_SWITCH:
        plan_collect_escaped(n->sw_expr, p);
        plan_collect_escaped(n->sw_body, p);
        return;
    case AST_SWITCH_CASE:
        plan_collect_escaped(n->sw_value, p); return;
    case AST_DECL:
        plan_collect_escaped(n->declvar, p); return;
    case AST_CRITICAL:
        plan_collect_escaped(n->operand, p); return;
    case AST_LOOP_COUNTDOWN:
        plan_collect_escaped(n->loop_init, p);
        plan_collect_escaped(n->loop_body, p);
        return;
    case AST_PRESERVE_BC:
        plan_collect_escaped(n->operand, p);
        return;
    default:
        if (n->left)    plan_collect_escaped(n->left, p);
        if (n->right)   plan_collect_escaped(n->right, p);
        if (n->operand) plan_collect_escaped(n->operand, p);
        return;
    }
}

static void plan_add_decl(cg2_plan *p, SYMBOL *sym, int scope_id)
{
    if (p->n_decls == p->cap_decls) {
        p->cap_decls = p->cap_decls ? p->cap_decls * 2 : 8;
        p->decls = realloc(p->decls, sizeof(cg2_decl) * p->cap_decls);
    }
    cg2_decl *d = &p->decls[p->n_decls++];
    d->sym = sym;
    d->size = sym->ctype ? sym->ctype->size : 2;
    if (d->size < 1) d->size = 2;   /* defensive */
    d->scope_id = scope_id;
    /* Synthesized temps from ast_opt (LICM / CSE-synth) get inserted at
       the compound that holds the loop label, which can be a sibling of
       the C-scope blocks where the inner loop's index variables live.
       Scope-based liveness — which assumes lifetime ⊆ declaration scope —
       then concludes the synth temp and the index var don't overlap and
       lets plan_color give them the same slot. They DO overlap at run
       time (the temp's read inside the inner loop happens when the
       index var is also live), so force the synth temp to always
       conflict with everything else. Identified by the leading digit
       in the name — C identifiers can't start with a digit, so any
       `[0-9]…`-named sym is internal-only. */
    int is_synth = sym->name[0] >= '0' && sym->name[0] <= '9';
    d->always_interferes = (sym->ctype && sym->ctype->isvolatile)
                        || escaped_contains(p, sym)
                        || is_synth;
    d->offset = 0;
    d->placed = 0;
    d->hotness = 0;
}

/* #257: count AST_LOCAL_VAR references for each tracked local,
   weighted by enclosing loop depth so inner-loop accesses dominate.
   Run once after plan_walk populates the decl table; the count
   feeds plan_color's sort tiebreak so the hottest non-prefix local
   gets the deepest slot (closest to sp+0), where the cheap pop/push
   and short `add hl,sp` peepholes apply on plain z80 targets.
   Weight = 1 << min(depth, 10); the cap prevents overflow and
   saturating is fine at deep nesting. */
static cg2_decl *plan_find_decl(cg2_plan *p, SYMBOL *s)
{
    if (!s) return NULL;
    for (int i = 0; i < p->n_decls; i++)
        if (p->decls[i].sym == s) return &p->decls[i];
    return NULL;
}

static void plan_count_hotness(Node *n, cg2_plan *p, int depth)
{
    if (!n) return;
    int weight = depth > 10 ? (1 << 10) : (1 << depth);
    switch (n->ast_type) {
    case AST_LOCAL_VAR:
        if (n->sym) {
            cg2_decl *d = plan_find_decl(p, n->sym);
            if (d) d->hotness += weight;
        }
        return;
    case AST_LITERAL: case AST_STR_LIT:
    case AST_GLOBAL_VAR:
    case AST_LABEL: case AST_JUMP: case AST_UNDECL:
    case AST_INIT_STATIC: case AST_ASM:
        return;
    case AST_FUNC_CALL: case AST_FUNCPTR_CALL:
        for (int i = 0; i < (int)array_len(n->args); i++)
            plan_count_hotness(array_get_byindex(n->args, i), p, depth);
        if (n->callee) plan_count_hotness(n->callee, p, depth);
        return;
    case AST_COMPOUND_STMT: case AST_INIT_LIST:
        for (int i = 0; i < (int)array_len(n->stmts); i++)
            plan_count_hotness(array_get_byindex(n->stmts, i), p, depth);
        return;
    case AST_RETURN:
        plan_count_hotness(n->retval, p, depth); return;
    case AST_IF: case AST_TERNARY:
        plan_count_hotness(n->cond, p, depth);
        plan_count_hotness(n->then, p, depth);
        plan_count_hotness(n->els,  p, depth);
        return;
    case AST_SWITCH:
        plan_count_hotness(n->sw_expr, p, depth);
        plan_count_hotness(n->sw_body, p, depth);
        return;
    case AST_SWITCH_CASE:
        plan_count_hotness(n->sw_value, p, depth); return;
    case AST_DECL:
        plan_count_hotness(n->declvar, p, depth); return;
    case AST_CRITICAL:
        plan_count_hotness(n->operand, p, depth); return;
    case AST_LOOP_COUNTDOWN:
        plan_count_hotness(n->loop_init, p, depth);
        plan_count_hotness(n->loop_body, p, depth + 1);
        return;
    case AST_PRESERVE_BC:
        plan_count_hotness(n->operand, p, depth);
        return;
    default:
        if (n->left)    plan_count_hotness(n->left, p, depth);
        if (n->right)   plan_count_hotness(n->right, p, depth);
        if (n->operand) plan_count_hotness(n->operand, p, depth);
        return;
    }
}

/* Walk AST building the scope tree and recording each AST_DECL's
   containing scope. Skips storage classes that aren't on the stack. */
static void plan_walk(Node *n, cg2_plan *p, int current_scope)
{
    if (!n) return;
    switch (n->ast_type) {
    case AST_COMPOUND_STMT: {
        /* A multi-declarator (`int a=1, b=2, c=3;`) is parsed as a
           nested AST_COMPOUND_STMT whose stmts are individual AST_DECL
           nodes. Treating it as its own scope would isolate those
           decls from their actual lexical neighbours — sibling
           sub-compounds in the same function get scope_is_ancestor=0
           and don't interfere, so a leading multi-decl block's locals
           wrongly share slots with locals declared by a later sibling
           (e.g. C99 `for (int i = 0; ...)`). Detect the all-decls
           shape and flatten its scope into the parent. cg2_emit_func's
           push-init scan does the same descent for the same reason. */
        int only_decls = (int)array_len(n->stmts) > 0;
        for (int i = 0; i < (int)array_len(n->stmts); i++) {
            Node *child = array_get_byindex(n->stmts, i);
            if (!child || child->ast_type != AST_DECL) { only_decls = 0; break; }
        }
        int new_scope = only_decls ? current_scope : plan_add_scope(p, current_scope);
        for (int i = 0; i < (int)array_len(n->stmts); i++)
            plan_walk(array_get_byindex(n->stmts, i), p, new_scope);
        return;
    }
    case AST_DECL:
        if (n->sym && n->sym->storage == STKLOC) {
            plan_add_decl(p, n->sym, current_scope);
        }
        if (n->declvar) plan_walk(n->declvar, p, current_scope);
        return;
    case AST_IF: case AST_TERNARY:
        plan_walk(n->cond, p, current_scope);
        plan_walk(n->then, p, current_scope);
        plan_walk(n->els,  p, current_scope);
        return;
    case AST_SWITCH:
        plan_walk(n->sw_expr, p, current_scope);
        plan_walk(n->sw_body, p, current_scope);
        return;
    case AST_CRITICAL:
        plan_walk(n->operand, p, current_scope);
        return;
    case AST_RETURN:
        plan_walk(n->retval, p, current_scope);
        return;
    case AST_LOOP_COUNTDOWN:
        plan_walk(n->loop_init, p, current_scope);
        plan_walk(n->loop_body, p, current_scope);
        return;
    case AST_PRESERVE_BC:
        plan_walk(n->operand, p, current_scope);
        return;
    default:
        return;
    }
}

/* True if scope_a is ancestor-or-equal of scope_b in the scope tree. */
static int scope_is_ancestor(cg2_plan *p, int scope_a, int scope_b)
{
    while (scope_b >= 0) {
        if (scope_b == scope_a) return 1;
        scope_b = p->scopes[scope_b].parent_id;
    }
    return 0;
}

/* Two decls interfere iff their lifetimes can overlap. With our
   scope-tree model: lifetimes overlap iff one's scope is an
   ancestor of (or equal to) the other's. Plus the always-interferes
   override for escaped / volatile syms. */
static int decls_interfere(cg2_plan *p, int a_idx, int b_idx)
{
    cg2_decl *A = &p->decls[a_idx];
    cg2_decl *B = &p->decls[b_idx];
    if (A->always_interferes || B->always_interferes) return 1;
    if (A->scope_id == B->scope_id) return 1;
    if (scope_is_ancestor(p, A->scope_id, B->scope_id)) return 1;
    if (scope_is_ancestor(p, B->scope_id, A->scope_id)) return 1;
    return 0;
}

/* Greedy slot coloring. Sort decls by size desc; for each, find the
   smallest |offset| (closest to 0, i.e., least-deep position) that
   doesn't conflict by byte-range with any already-placed interfering
   decl. */
static void plan_color(cg2_plan *p)
{
    int n = p->n_decls;
    if (n == 0) { p->frame_size = 0; return; }

    /* #257 prefix-pin: the walker's push-init optimisation evaluates
       leading decl inits in source order and pushes each result onto
       the stack. That requires slot order to match source order so
       consecutive pushes populate consecutive frame slots. Lock the
       leading run of push-init-eligible decls (top scope, size 2 or
       4, STKLOC, !always_interferes) into source-order offsets
       (-size_0, -size_0-size_1, ...) and let hotness reorder only
       the non-prefix decls. Synth CSE temps have always_interferes
       so they never join the prefix; that's how the intbench
       regression (synth temps grabbing sp+0) gets fixed without
       breaking push-init for user-declared leading locals. */
    int prefix_n = 0;
    int frame_size = 0;
    int top_scope = p->decls[0].scope_id;
    int off = 0;
    for (int i = 0; i < n; i++) {
        cg2_decl *d = &p->decls[i];
        if (d->scope_id != top_scope) break;
        if (d->always_interferes) break;
        if (!d->sym || d->sym->storage != STKLOC) break;
        if (d->size != 2 && d->size != 4) break;
        off -= d->size;
        d->offset = off;
        d->placed = 1;
        d->sym->offset.i = off;
        prefix_n++;
    }
    if (prefix_n > 0) frame_size = -off;

    /* Sort remaining indices by size DESC (largest first → shallowest
       slot), tiebreak by hotness ASC (coldest first → hottest gets
       the deepest slot, closest to sp+0 where pop/push and short
       `add hl,sp` peepholes apply). */
    int rem_n = n - prefix_n;
    if (rem_n > 0) {
        int *order = malloc(sizeof(int) * rem_n);
        for (int i = 0; i < rem_n; i++) order[i] = prefix_n + i;
        for (int i = 0; i < rem_n; i++) {
            for (int j = i + 1; j < rem_n; j++) {
                cg2_decl *A = &p->decls[order[i]];
                cg2_decl *B = &p->decls[order[j]];
                int swap = 0;
                if (B->size > A->size) swap = 1;
                else if (B->size == A->size && B->hotness < A->hotness) swap = 1;
                if (swap) { int t = order[i]; order[i] = order[j]; order[j] = t; }
            }
        }
        for (int k = 0; k < rem_n; k++) {
            int idx = order[k];
            cg2_decl *D = &p->decls[idx];
            int candidate = -D->size;
            while (1) {
                int conflict = 0;
                int A_lo = candidate, A_hi = candidate + D->size;
                for (int j = 0; j < n; j++) {
                    if (j == idx) continue;
                    if (!p->decls[j].placed) continue;
                    if (!decls_interfere(p, idx, j)) continue;
                    int B_lo = p->decls[j].offset;
                    int B_hi = B_lo + p->decls[j].size;
                    if (A_lo < B_hi && B_lo < A_hi) { conflict = 1; break; }
                }
                if (!conflict) {
                    D->offset = candidate;
                    D->placed = 1;
                    D->sym->offset.i = candidate;
                    if (-candidate > frame_size) frame_size = -candidate;
                    break;
                }
                candidate--;
            }
        }
        free(order);
    }
    p->frame_size = frame_size;
}

/* ----- Walker ------------------------------------------------------- */

static void cg2_walk(Node *node);

/* Implicit "this expression's result will be discarded" flag.
   cg2_compound's per-statement loop sets this to 1 before walking
   each statement; cg2_walk's dispatcher captures the inbound value
   and clears it (so child sub-expressions see value-needed = the
   default). Currently only read by OP_ASSIGN's char-literal fast
   path to elide the int-widening-into-HL step (#218a). */
static int cg2_stmt_value_discarded;
static void cg2_walk_cond(Node *node, int target_label, int jump_on_true);
static void cg2_walk_cond_to_ret(Node *node, int ret_if_true);
static void cg2_compound(Node *node);
static void cg2_return(Node *node);
static void cg2_literal(Node *node);
static void cg2_emit_decl(Node *node);
static void cg2_load_local_scalar(SYMBOL *sym);
static void cg2_load_addr_local(SYMBOL *sym);
static void cg2_store_local_scalar(SYMBOL *sym);
static void cg2_store_at_offset(int byte_offset, int width);
static void cg2_binop(Node *node);
static void cg2_unop(Node *node);
static void cg2_step(Node *node);
static void cg2_compound_assign(Node *node);
static void cg2_store_local_keep(SYMBOL *sym, Kind kind);
static void cg2_func_call(Node *node);
static void cg2_build_lvalue(Node *n, LVALUE *out);
static Type *cg2_pointee_type(Node *n);
static void cg2_walk_to_long(Node *n);
static void cg2_walk_to_llong(Node *n);
static void cg2_walk_to_decimal(Node *n, Kind target_kind);
static void cg2_walk_widened(Node *n, Kind dest_k);
static int  cg2_try_byte_pack_long(Node *or_node);
static void cg2_truthiness_test(Kind k);
static int  cg2_try_char_self_ternary(SYMBOL *sym, Node *rhs, int is_global,
                                      int frame_offset);
static int  cg2_node_is_byte_in_a_safe(Node *n, SYMBOL *self);
static void cg2_walk_byte_in_a(Node *n, SYMBOL *self);
static int  cg2_try_char_byte_arith(SYMBOL *sym, Node *rhs, int is_global,
                                    int frame_offset);

/* C_LINE state — every function emit starts fresh. */
static int cg2_last_emitted_line = -1;
static const char *cg2_last_emitted_file = NULL;

/* Branch-to-ret optimisation gate. True iff every AST_RETURN in the
   current function (and the falls-off-end epilogue) emits exactly one
   instruction — `ret`. When true, `if (cond) return;` becomes
   `cond; ret cc` instead of `cond; jp cc, .L; ret; .L`. Computed once
   at function entry from `gen_leave_function`'s prerequisites:
   no frame, no callee-cleanup, no frame pointer, no INTERRUPT /
   CRITICAL / NAKED / SAVEFRAME flags, no debug entry points. */
static int cg2_bare_ret_p = 0;

void ast_generate_code2(Node *root)
{
    if (!root) return;

    cg2_last_emitted_line = -1;
    cg2_last_emitted_file = NULL;

    /* Phase B: build the frame plan. */
    cg2_plan plan;
    plan_init(&plan);
    plan_collect_escaped(root, &plan);
    plan_walk(root, &plan, -1);
    plan_count_hotness(root, &plan, 0);
    plan_color(&plan);

    /* #219 / #254: replace `prologue modstk + per-local store`
       with `eval init; push` for the leading run of AST_DECL-with-
       init at the function body's top. Each push allocates the slot
       AND stores the value in one instruction — saves ~7 bytes per
       int slot vs `modstk + ld (slot),hl`, and ~10+ instructions per
       long slot vs `modstk + push de;push hl;ld hl,N;add hl,sp;
       ld bc,hl;pop hl;pop de;call l_plong` → `push de;push hl`.
       Conservative: leading decls must be plain 2-byte
       (INT/SHORT/PTR/CHAR/FLOAT16/ACCUM16) or 4-byte
       (LONG/CPTR/ACCUM32) integer/pointer kinds, declvar present and
       not AST_INIT_LIST, and sym->offset.i must step down by `size`
       per local from the baseline (no plan_color slot-sharing or
       reordering). For each push, mark the decl's declvar NULL so
       cg2_emit_decl skips the store path.
       A C declaration like `long a = X, b = Y;` becomes a nested
       AST_COMPOUND_STMT whose stmts are the individual AST_DECL
       nodes — we transparently descend one level so multi-declarator
       leading decls still qualify. */
    Node *cand[64];
    int cand_n = 0;
    int push_init_count = 0;
    int push_bytes = 0;
    if (root && root->ast_type == AST_COMPOUND_STMT && plan.frame_size > 0) {
        int n_stmts = (int)array_len(root->stmts);
        for (int i = 0; i < n_stmts && cand_n < (int)(sizeof(cand)/sizeof(cand[0])); i++) {
            Node *s = array_get_byindex(root->stmts, i);
            if (!s) break;
            if (s->ast_type == AST_DECL) {
                cand[cand_n++] = s;
            } else if (s->ast_type == AST_COMPOUND_STMT) {
                int m = (int)array_len(s->stmts);
                int saw_decl = 0;
                for (int j = 0; j < m && cand_n < (int)(sizeof(cand)/sizeof(cand[0])); j++) {
                    Node *ss = array_get_byindex(s->stmts, j);
                    if (!ss || ss->ast_type != AST_DECL) { saw_decl = 0; break; }
                    cand[cand_n++] = ss;
                    saw_decl = 1;
                }
                if (!saw_decl) break;
            } else {
                break;
            }
        }

        int expected_off = 0;
        for (int i = 0; i < cand_n; i++) {
            Node *s = cand[i];
            if (!s->sym || s->sym->storage != STKLOC) break;
            if (!s->declvar || s->declvar->ast_type == AST_INIT_LIST) break;
            Kind sk = s->sym->ctype ? s->sym->ctype->kind : KIND_INT;
            int size;
            if (sk == KIND_INT || sk == KIND_SHORT
                || sk == KIND_PTR || sk == KIND_CHAR
                || sk == KIND_FLOAT16 || sk == KIND_ACCUM16) size = 2;
            else if (sk == KIND_LONG || sk == KIND_CPTR
                  || sk == KIND_ACCUM32) size = 4;
            else break;
            int next_off = expected_off - size;
            if (s->sym->offset.i != next_off) break;
            push_init_count++;
            push_bytes += size;
            expected_off = next_off;
        }
    }

    /* Push-init goes FIRST so the pushed values land at the
       highest-offset slots (closest to the initial sp). The
       prologue alloc that follows covers the remaining deeper
       slots. After both, Zsp = -frame_size and each sym->offset.i
       matches its slot's actual position. */
    if (push_init_count > 0) {
        for (int i = 0; i < push_init_count; i++) {
            Node *s = cand[i];
            Node *init = s->declvar;
            Kind sk = s->sym->ctype ? s->sym->ctype->kind : KIND_INT;
            int is_4byte = (sk == KIND_LONG || sk == KIND_CPTR
                         || sk == KIND_ACCUM32);
            /* Route to the kind-appropriate walk-and-widen so the
               primary register holds the slot-width value before
               push. cg2_walk_widened dispatches by dest kind:
               LONG/CPTR → DE:HL, ACCUM32 → DE:HL (via load_fixed),
               FLOAT16/ACCUM16 → HL, otherwise → HL via cg2_walk. */
            cg2_walk_widened(init, sk);
            if (is_4byte) lpush();   /* push de; push hl */
            else          zpush();   /* push hl */
            /* Mark init as consumed so cg2_emit_decl is a no-op
               when the stmt iteration reaches it. */
            s->declvar = NULL;
        }
    }

    /* Emit prologue modstk to allocate any frame that isn't
       covered by push-init. modstk returns the new SP value but
       does NOT update the global `Zsp` — the caller has to do
       that. */
    int prologue_alloc = plan.frame_size - push_bytes;
    if (prologue_alloc > 0) {
        Zsp = modstk(Zsp - prologue_alloc, KIND_NONE, NO, YES);
    }

    /* "Frame pointer active for this function?" — true iff the
       prologue emits the IX/IY push and the epilogue restores it.
       Today the global `-frameix` / `-frameiy` flag and the per-
       function `__saveframe` attribute are the only triggers; the
       Phase 5 heuristic gate will add a per-function `fp_active`
       decision that swaps in here. Centralised so future
       FP-consumers (Phase 1f's binop DE-direct load, branch-to-ret
       gate, etc.) read one predicate instead of duplicating the
       OR-chain. */
    int fp_active = (c_framepointer_is_ix != -1)
                 || (currfn && currfn->ctype
                     && (currfn->ctype->flags & SAVEFRAME));

    /* Determine whether AST_RETURNs in this function emit just `ret`
       (with no frame restoration / callee cleanup / interrupt-leave
       / etc.). Used by the AST_IF peephole to substitute `ret cc`
       for a `cond; jp cc,L; ret; .L` sequence.

       Declines when FP is active (epilogue pops IX), when frame_size
       > 0 (epilogue undoes modstk), when SAVEFRAME / NAKED ctype
       flags or NAKED/INTERRUPT/CRITICAL function flags require
       custom enter/leave, when CALLEE convention needs stack
       cleanup, or when debug-entry helpers wrap the function. */
    cg2_bare_ret_p = (plan.frame_size == 0)
        && currfn
        && (currfn->flags & (NAKED | INTERRUPT | CRITICAL)) == 0
        && currfn->ctype
        && (currfn->ctype->flags & NAKED) == 0
        && !((currfn->ctype->flags & CALLEE) && stackargs > 2)
        && !fp_active
        && !c_debug_entry_points;

    /* Walk the body. */
    cg2_walk(root);

    /* Epilogue is emitted by the legacy declparse.c tail
       (`gen_leave_function`) for the falls-off-end / non-STRETURN
       case, and by cg2_return for explicit returns. Both restore Zsp
       to 0 via modstk(0, ...). */

    plan_free(&plan);
}

static void cg2_walk(Node *node)
{
    if (!node) return;
    /* Capture the inbound discard hint and clear for children. Most
       handlers walk their operands as value-needed; only the OP_ASSIGN
       fast path reads `inbound_discard` (via the saved local below).
       Statement-iterating callers (cg2_compound) re-set the flag
       before each child stmt walk so each statement sees discard=1
       at entry. */
    int inbound_discard = cg2_stmt_value_discarded;
    cg2_stmt_value_discarded = 0;
    (void)inbound_discard;
    switch (node->ast_type) {
    case AST_COMPOUND_STMT: cg2_compound(node); return;
    case AST_RETURN:        cg2_return(node);   return;
    case AST_LITERAL:       cg2_literal(node);  return;
    case AST_STR_LIT:
        /* String-literal queue ref: `ld hl, i_<litlab>+<offs>`.
           `litlab` is the global queue label set once at startup;
           `node->zval` is the byte offset within the queue. */
        immedlit(litlab, (int)node->zval);
        nl();
        return;
    case AST_DECL:          cg2_emit_decl(node); return;
    case OP_DEREF: {
        /* Forms handled:
           1. OP_DEREF(LOCAL_VAR sym) where sym is a SCALAR (not array,
              not struct): legacy load-local fastpath.
           2. OP_DEREF(GLOBAL_VAR sym) where sym is a SCALAR:
              gen_load_static.
           3. OP_DEREF wrapping a pre/post-step (`(deref (post++ X))`):
              the step already left the value in HL/DEHL, so the
              wrapping deref is a parser-side rvalue() habit and
              emits no further code.
           4. OP_DEREF(arbitrary expr): walk operand → HL = address;
              then gen_load_indirect with width from node->type. Used
              for array/struct member reads, pointer derefs, and
              array-decay reads (`(deref (lv=arr))` for char str[]).

           rvalue() in primary.c stamps node->type with the member /
           pointee type at construction so the storage width survives
           even after the simplifier strips OP_ADDR / OP_CAST chains
           down to bare `(+ (lv=p) offset)`. */
        Node *op = node->operand;
        if (op && (op->ast_type == OP_PRE_INC
                || op->ast_type == OP_POST_INC
                || op->ast_type == OP_PRE_DEC
                || op->ast_type == OP_POST_DEC)) {
            /* The parser stamps the step's own type as the lvalue
               expression's type (e.g. `double *` for `(*p)++`, or
               `int` for `s->f++`), but the OUTER deref carries the
               actual storage type — propagate it so cg2_step's
               general path sees the right kind for load/store. */
            if (node->type) op->type = node->type;
            cg2_walk(op);
            return;
        }
        Kind op_kind = (op && op->sym && op->sym->ctype)
                     ? op->sym->ctype->kind : KIND_NONE;
        int op_is_aggregate = (op_kind == KIND_ARRAY
                            || op_kind == KIND_STRUCT);
        if (op && op->ast_type == AST_LOCAL_VAR && op->sym && !op_is_aggregate) {
            cg2_load_local_scalar(op->sym);
            return;
        }
        if (op && op->ast_type == AST_GLOBAL_VAR && op->sym && !op_is_aggregate) {
            /* I/O port reads need explicit in/in0/ldh instructions, not
               a memory load — gen_intrinsic_in dispatches on cpu kind. */
            if (op->sym->type == KIND_PORT8 || op->sym->type == KIND_PORT16) {
                gen_intrinsic_in(op->sym);
            } else {
                gen_load_static(op->sym);
            }
            return;
        }
        /* #O1: `global_array[const]` / `global_struct.member` —
           recognise `OP_ADD(AST_GLOBAL_VAR-with-array-or-struct,
           AST_LITERAL)` and emit a direct `ld hl,(sym+offset)` load
           instead of the generic ld-base / ld-offset / add / load
           sandwich. Element kind comes from node->type (set by the
           parser to the storage type at the point of access). */
        if (op && op->ast_type == OP_ADD && op->left && op->right) {
            Node *base = NULL;
            Node *off  = NULL;
            if (op->right->ast_type == AST_LITERAL
                && op->left->ast_type == AST_GLOBAL_VAR
                && op->left->sym && op->left->sym->ctype
                && (op->left->sym->ctype->kind == KIND_ARRAY
                    || op->left->sym->ctype->kind == KIND_STRUCT)) {
                base = op->left; off = op->right;
            } else if (op->left->ast_type == AST_LITERAL
                && op->right->ast_type == AST_GLOBAL_VAR
                && op->right->sym && op->right->sym->ctype
                && (op->right->sym->ctype->kind == KIND_ARRAY
                    || op->right->sym->ctype->kind == KIND_STRUCT)) {
                base = op->right; off = op->left;
            }
            if (base && off
                && (!node->type || node->type->bit_size == 0)) {
                /* Bitfield reads need the gen_bitfield_* RMW path —
                   gen_load_static_offset would emit a plain word/byte
                   load, dropping the mask/shift. Falls through to
                   the general OP_DEREF path which handles bitfields. */
                Kind result_k = node->type ? node->type->kind : KIND_INT;
                int byte_off = (int)off->zval;
                if (gen_load_static_offset(base->sym, byte_off, result_k))
                    return;
            }
        }
        /* General path: address into HL, then load indirect via the
           result type. Prefer node->type (set by rvalue() to the
           member / pointee storage type) over the operand's type
           (which is generally a pointer-arithmetic expression with no
           recoverable element kind after simplification).

           If the address-bearing operand is a far pointer (KIND_CPTR
           after walking, or the pointee carries isfar), the load must
           use the `lp_*` helpers (lp_gint / lp_gchar / lp_glong / …)
           via FARACC. Without this, the walker drops back to near-
           pointer loads and reads from the wrong address. */
        cg2_walk(op);
        Type *result_t = node->type ? node->type : cg2_pointee_type(op);
        if (!result_t) result_t = type_int;
        LVALUE lval;
        memset(&lval, 0, sizeof(lval));
        lval.ltype = result_t;
        lval.indirect_kind = result_t->kind;
        lval.val_type = result_t->kind;
        if ((op && op->type && op->type->kind == KIND_CPTR)
            || (result_t && result_t->isfar)) {
            lval.flags = FARACC;
        }
        gen_load_indirect(&lval);
        return;
    }
    case AST_LOCAL_VAR:
        /* Bare LV in an rvalue context. Behaviours by symbol type:
           - scalar (int/char/short/ptr/long/cptr): load via the
             kind-dispatching `cg2_load_local_scalar`.
           - aggregate (array/struct): decay to the *address* (matches C
             array-decay; the simplifier strips `(& p)` to `(lv=p)`
             for struct member accesses).
           - function: take its address (function-name decay; used as
             fnptr initialisers and direct fnptr expressions). Locals
             of function type are unusual but legal. */
        if (node->sym) {
            Kind sk = node->sym->ctype ? node->sym->ctype->kind : KIND_INT;
            if (sk == KIND_ARRAY || sk == KIND_STRUCT || sk == KIND_FUNC) {
                cg2_load_addr_local(node->sym);
            } else {
                cg2_load_local_scalar(node->sym);
            }
        }
        return;
    case AST_GLOBAL_VAR:
        if (node->sym) {
            Kind sk = node->sym->ctype ? node->sym->ctype->kind : KIND_INT;
            if (sk == KIND_ARRAY || sk == KIND_STRUCT || sk == KIND_FUNC) {
                gen_address(node->sym);
            } else if (node->sym->type == KIND_PORT8
                    || node->sym->type == KIND_PORT16) {
                /* I/O port read — in/in0/ldh, not a memory load. */
                gen_intrinsic_in(node->sym);
            } else {
                /* gen_load_static dispatches on kind — covers
                   char, int, long, cptr. */
                gen_load_static(node->sym);
            }
        }
        return;
    case OP_ADDR: case AST_ADDR:
        /* &local / &global. For LV/GV: emit address. */
        if (node->operand && node->operand->ast_type == AST_LOCAL_VAR
            && node->operand->sym) {
            cg2_load_addr_local(node->operand->sym);
            return;
        }
        if (node->operand && node->operand->ast_type == AST_GLOBAL_VAR
            && node->operand->sym) {
            gen_address(node->operand->sym);
            return;
        }
        /* &(complex_lvalue) — walk the operand which already yields the
           address (for OP_ADD-of-array etc.). */
        cg2_walk(node->operand);
        return;
    case OP_ASSIGN: {
        /* Three shapes:
           1. Bare scalar LV/GV LHS: walk RHS → HL, store directly to
              the local slot / static.
           2. Bare aggregate LV/GV LHS (struct/array): falls into the
              indirect-store path because LV-as-address means the
              "store target" is an address we have to compute.
           3. Arbitrary pointer-LHS (member access, *p, arr[i], etc.):
              walk LHS → HL = address, push, walk RHS → HL = value,
              pop DE = address, store HL through DE with width taken
              from node->type (set by heir1 to lval->ltype, the
              effective storage type at the point of assignment). */
        Node *lhs = node->left;
        Node *rhs = node->right;
        if (!lhs || !rhs) return;

        /* Scalar local fastpath. */
        if (lhs->ast_type == AST_LOCAL_VAR && lhs->sym
            && lhs->sym->ctype
            && lhs->sym->ctype->kind != KIND_ARRAY
            && lhs->sym->ctype->kind != KIND_STRUCT) {
            Kind lk = lhs->sym->ctype->kind;
            /* #267: char-self-feed ternary fastpath. */
            if (lk == KIND_CHAR && inbound_discard
                && cg2_try_char_self_ternary(lhs->sym, rhs, 0,
                                             lhs->sym->offset.i)) {
                return;
            }
            /* #268: general byte-arith-in-A fastpath. */
            if (lk == KIND_CHAR && inbound_discard
                && cg2_try_char_byte_arith(lhs->sym, rhs, 0,
                                           lhs->sym->offset.i)) {
                return;
            }
            /* #218a: char-literal store with discarded result skips
               the int-widening into HL. Emits `ld a,N; ld (slot),a`
               directly. Saves 2 bytes per char-const local init. */
            if (lk == KIND_CHAR && rhs->ast_type == AST_LITERAL
                && inbound_discard) {
                int v = ((int)(int64_t)rhs->zval) & 0xff;
                outfmt("\tld\ta,%d\n", v);
                gen_store_local_byte_in_a(lhs->sym->offset.i);
                return;
            }
            /* #218b: int/long-literal store with discarded result.
               Emit `gen_local_addr; ld (hl),lo; inc hl; ld (hl),hi
               [; inc hl; ld (hl),...]` directly — skips the load-K-
               into-HL/DEHL plus l_pint/l_plong helper round-trip.
               Saves ~50t per fire. */
            {
                int store_width = 0;
                if (lk == KIND_INT || lk == KIND_SHORT
                 || lk == KIND_PTR) store_width = 2;
                else if (lk == KIND_LONG || lk == KIND_CPTR)
                    store_width = 4;
                if (store_width && rhs->ast_type == AST_LITERAL
                    && inbound_discard) {
                    gen_local_addr(lhs->sym->offset.i);
                    gen_store_literal_at_hl((int64_t)rhs->zval,
                                            store_width);
                    return;
                }
            }
            /* Char-store RHS only needs L (the low byte) — the store
               path is `ld a, l; ld (slot), a`. Any OP_CAST(KIND_CHAR)
               at the top of RHS would emit a sign/zero-extend of H
               that's immediately discarded. Strip outer KIND_CHAR
               casts when the operand has an int-class natural type;
               float / decimal need explicit conversion so leave those
               alone. */
            if (lk == KIND_CHAR) {
                while (rhs->ast_type == OP_CAST
                    && rhs->type && rhs->type->kind == KIND_CHAR
                    && rhs->operand && rhs->operand->type) {
                    Kind ok = rhs->operand->type->kind;
                    if (ok != KIND_CHAR && ok != KIND_INT
                     && ok != KIND_SHORT && ok != KIND_LONG
                     && ok != KIND_PTR && ok != KIND_CPTR) break;
                    rhs = rhs->operand;
                }
            }
            /* #237: long-class stores save the LHS address upfront,
               then evaluate RHS, then pop+store via TOS. The
               default `cg2_store_local_keep` path for long ends up
               doing an lpush+gen_local_addr+pop+pop dance (~7 instr
               before l_plong) every time, recomputing the address
               after the RHS evaluated. Save-address-then-walk-then-
               store-tos cuts that to ~3 instr (gen_local_addr + zpush
               at start, pop bc + call l_plong at end). Gated on the
               absence of a native sp/fp-relative paired store —
               Rabbit/KC160/FRAMEPTR have one and beat the save-
               address dance, so they keep the existing path. */
            int is_long_class = (lk == KIND_LONG || lk == KIND_CPTR
                              || lk == KIND_LONGLONG);
            if (is_long_class
                && !can_access_local_native(lhs->sym->offset.i, lk)) {
                gen_local_addr(lhs->sym->offset.i);
                zpush();
                cg2_walk_widened(rhs, lk);
                gen_store_tos(lk);
                return;
            }
            cg2_walk_widened(rhs, lk);
            /* C: the assignment expression's value is the value
               stored. Use the _keep variant so HL (or DEHL) holds
               the assigned value after the store — required for
               `while ((x = …) != K)` and similar shapes. */
            cg2_store_local_keep(lhs->sym, lk);
            return;
        }
        /* Scalar global fastpath. */
        if (lhs->ast_type == AST_GLOBAL_VAR && lhs->sym
            && lhs->sym->ctype
            && lhs->sym->ctype->kind != KIND_ARRAY
            && lhs->sym->ctype->kind != KIND_STRUCT) {
            Kind lk = lhs->sym->ctype->kind;
            /* #267: char-self-feed ternary fastpath. */
            if (lk == KIND_CHAR && inbound_discard
                && !(lhs->sym->ctype->flags & FARACC)
                && lhs->sym->type != KIND_PORT8
                && lhs->sym->type != KIND_PORT16
                && cg2_try_char_self_ternary(lhs->sym, rhs, 1, 0)) {
                return;
            }
            /* #268: general byte-arith-in-A fastpath. */
            if (lk == KIND_CHAR && inbound_discard
                && !(lhs->sym->ctype->flags & FARACC)
                && lhs->sym->type != KIND_PORT8
                && lhs->sym->type != KIND_PORT16
                && cg2_try_char_byte_arith(lhs->sym, rhs, 1, 0)) {
                return;
            }
            /* Char-store RHS only needs L. Strip outer
               OP_CAST(KIND_CHAR) when operand is int-class — see
               the local-LV branch for the longer comment. */
            if (lk == KIND_CHAR
                && !(lhs->sym->ctype->flags & FARACC)
                && lhs->sym->type != KIND_PORT8
                && lhs->sym->type != KIND_PORT16) {
                while (rhs->ast_type == OP_CAST
                    && rhs->type && rhs->type->kind == KIND_CHAR
                    && rhs->operand && rhs->operand->type) {
                    Kind ok = rhs->operand->type->kind;
                    if (ok != KIND_CHAR && ok != KIND_INT
                     && ok != KIND_SHORT && ok != KIND_LONG
                     && ok != KIND_PTR && ok != KIND_CPTR) break;
                    rhs = rhs->operand;
                }
            }
            /* #218a: same shape for globals. `g = -5;` emits
               `ld a,-5; ld (_g),a` (5 bytes) instead of `ld hl,N;
               ld a,l; ld (_g),a` (7 bytes). FARACC, PORT, KIND_CPTR
               and non-CHAR kinds fall through to the standard path. */
            if (lk == KIND_CHAR && rhs->ast_type == AST_LITERAL
                && inbound_discard
                && !(lhs->sym->ctype->flags & FARACC)
                && lhs->sym->type != KIND_PORT8
                && lhs->sym->type != KIND_PORT16) {
                int v = ((int)(int64_t)rhs->zval) & 0xff;
                outfmt("\tld\ta,%d\n", v);
                gen_store_static_byte_in_a(lhs->sym);
                return;
            }
            cg2_walk_widened(rhs, lk);
            if (lhs->sym->type == KIND_PORT8
                || lhs->sym->type == KIND_PORT16) {
                /* I/O port write — out/out0/ldh, not a memory store. */
                gen_intrinsic_out(lhs->sym);
            } else {
                /* gen_store_static dispatches on sym->ctype->kind —
                   covers char, int, long, cptr, etc. */
                gen_store_static(lhs->sym);
            }
            return;
        }
        /* General: pointer-store. */
        Type *t = node->type ? node->type
                : (lhs->type ? lhs->type : type_int);
        Kind k = t ? t->kind : KIND_INT;
        /* #O1 store-side fold: `global_array[const] = rhs` /
           `global_struct.member = rhs`. Recognise the
           `OP_ADD(AST_GLOBAL_VAR-with-array-or-struct, AST_LITERAL)`
           shape and emit a direct `ld (sym+off),hl` store, avoiding
           the push-addr / walk-rhs / pop / l_pint sandwich. The walk
           of rhs must come first so HL holds the value when the
           store fires (no need to save the LHS address). */
        if (lhs->ast_type == OP_ADD && lhs->left && lhs->right) {
            Node *base = NULL;
            Node *off = NULL;
            if (lhs->right->ast_type == AST_LITERAL
                && lhs->left->ast_type == AST_GLOBAL_VAR
                && lhs->left->sym && lhs->left->sym->ctype
                && (lhs->left->sym->ctype->kind == KIND_ARRAY
                    || lhs->left->sym->ctype->kind == KIND_STRUCT)) {
                base = lhs->left; off = lhs->right;
            } else if (lhs->left->ast_type == AST_LITERAL
                && lhs->right->ast_type == AST_GLOBAL_VAR
                && lhs->right->sym && lhs->right->sym->ctype
                && (lhs->right->sym->ctype->kind == KIND_ARRAY
                    || lhs->right->sym->ctype->kind == KIND_STRUCT)) {
                base = lhs->right; off = lhs->left;
            }
            if (base && off && !(base->sym->ctype->flags & FARACC)
                && k != KIND_LONGLONG && k != KIND_STRUCT
                && k != KIND_CPTR
                && !(k == KIND_DOUBLE && c_fp_size > 4)
                && (!t || t->bit_size == 0)) {
                /* Walk RHS first → HL (or DEHL) holds the value. */
                cg2_walk_widened(rhs, k);
                if (gen_store_static_offset(base->sym, (int)off->zval, k))
                    return;
                /* Helper bailed; fall through means we've already
                   walked rhs, so we'd double-walk. Re-walk lhs as
                   the general path below expects. Rare — the helper
                   only bails for FARACC/longlong/etc. which we
                   already filtered above. */
            }
        }
        int is_far_write = (lhs->type && lhs->type->kind == KIND_CPTR);
        /* #218c: pointer-store with literal RHS, discarded result.
           Two sub-cases for the dispatch:
           (a) LHS resolves to a known static symbol (bare
               AST_GLOBAL_VAR for struct/array at offset 0): the
               address is fixed at link time, so `ld hl,K; ld
               (sym+0),hl` is the canonical z80 form (3+3 = 6 bytes
               for int). Defer to gen_store_static_offset which
               picks the wide store on non-gbz80 and the helper on
               gbz80.
           (b) Address is computed at runtime (struct field via
               pointer, *p, a[runtime_i]): walk LHS → HL=address,
               then `ld (hl),lo; inc hl; ...` for the literal value
               byte-by-byte. No push/pop dance, no helper call. */
        if (rhs->ast_type == AST_LITERAL && inbound_discard
            && !is_far_write
            && k != KIND_STRUCT && k != KIND_LONGLONG
            && !(k == KIND_DOUBLE && c_fp_size > 4)
            && !(t && t->bit_size != 0)) {
            /* (a) Static address: bare AST_GLOBAL_VAR. The earlier
               scalar-global path filtered out STRUCT/ARRAY, so any
               AST_GLOBAL_VAR reaching here has struct/array kind,
               and the assignment type `k` is the field/element
               type. Use gen_store_static_offset(sym, 0, k). */
            if (lhs->ast_type == AST_GLOBAL_VAR && lhs->sym
                && lhs->sym->ctype
                && !(lhs->sym->ctype->flags & FARACC)
                && lhs->sym->type != KIND_PORT8
                && lhs->sym->type != KIND_PORT16
                && k != KIND_CPTR) {
                cg2_walk_widened(rhs, k);
                if (gen_store_static_offset(lhs->sym, 0, k))
                    return;
                /* Helper bailed (longlong / cptr / faracc which we
                   already filtered, or far double). Fall through —
                   we've walked rhs, so the general path below would
                   double-walk. Re-walk lhs as it expects. */
            }
            /* (b) Runtime address. */
            int store_width = 0;
            if (k == KIND_CHAR) store_width = 1;
            else if (k == KIND_INT || k == KIND_SHORT
                  || k == KIND_PTR) store_width = 2;
            else if (k == KIND_LONG || k == KIND_CPTR
                  || (k == KIND_DOUBLE && c_fp_size == 4))
                store_width = 4;
            if (store_width && lhs->ast_type != AST_GLOBAL_VAR) {
                cg2_walk(lhs);    /* HL = target address */
                gen_store_literal_at_hl((int64_t)rhs->zval,
                                        store_width);
                return;
            }
        }
        cg2_walk(lhs);          /* HL = address (DE = bank when far) */
        if (is_far_write) {
            gen_push_far_addr();
        } else {
            zpush();             /* save 2-byte addr on stack */
        }
        /* Walk RHS with width-aware coercion. Bitfield and struct stores
           leave HL holding a value/address, so plain cg2_walk is fine.
           Long-class and decimal stores need a DEHL / __i64_acc / FA
           value, so a narrower RHS (e.g. literal `1` typed KIND_INT) must
           be widened first — otherwise gen_store_tos writes DEHL where
           DE was never loaded. */
        int rhs_needs_width = !(t && t->bit_size != 0)
                              && k != KIND_STRUCT;
        if (rhs_needs_width) cg2_walk_widened(rhs, k);
        else                 cg2_walk(rhs);
        if (t && t->bit_size != 0) {
            /* Bitfield write — read-modify-write on 1 or 2 bytes
               of the underlying word. node->type carries
               bit_size / bit_offset (set by heir1 to lval->ltype
               at construction). */
            gen_bitfield_store(t);
            return;
        }
        if (is_far_write) {
            gen_far_store(k);
            return;
        }
        if (k == KIND_STRUCT) {
            gen_struct_copy(t->size);
            return;
        }
        gen_store_tos(k);
        return;
    }
    case OP_ADD: {
        /* #O1 address-value fold: `&global[const]` /
           `&global.member` when consumed for its address (push as
           fn arg, store to ptr var, etc.). Recognise
           `OP_ADD(AST_GLOBAL_VAR-array-or-struct, AST_LITERAL)`
           (either order) and emit `ld hl,sym+offset` directly,
           skipping the binop's load-base / load-offset / add
           sandwich. Mirrors the OP_DEREF/OP_ASSIGN folds but
           triggers when the address itself is the value, not the
           operand of a deref. */
        Node *L = node->left, *R = node->right;
        Node *base = NULL, *off = NULL;
        if (L && R && R->ast_type == AST_LITERAL
            && L->ast_type == AST_GLOBAL_VAR && L->sym && L->sym->ctype
            && (L->sym->ctype->kind == KIND_ARRAY
                || L->sym->ctype->kind == KIND_STRUCT)) {
            base = L; off = R;
        } else if (L && R && L->ast_type == AST_LITERAL
            && R->ast_type == AST_GLOBAL_VAR && R->sym && R->sym->ctype
            && (R->sym->ctype->kind == KIND_ARRAY
                || R->sym->ctype->kind == KIND_STRUCT)) {
            base = R; off = L;
        }
        if (base && off) {
            if (gen_address_offset(base->sym, (int)off->zval))
                return;
        }
        cg2_binop(node);
        return;
    }
    case OP_SUB:
    case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AND: case OP_OR: case OP_XOR:
    case OP_EQ: case OP_NE:
    case OP_LT: case OP_LE: case OP_GT: case OP_GE:
    case OP_SSHR: case OP_SSHL: case OP_USHR: case OP_USHL:
        cg2_binop(node);
        return;
    case OP_NEG: case OP_COMP: case OP_LNEG:
        cg2_unop(node);
        return;
    case OP_PRE_INC: case OP_POST_INC:
    case OP_PRE_DEC: case OP_POST_DEC:
        cg2_step(node);
        return;
    case OP_AADD: case OP_ASUB:
    case OP_AMULT: case OP_ADIV: case OP_AMOD:
    case OP_AAND: case OP_AOR:  case OP_AXOR:
    case OP_ASSHL: case OP_ASSHR:
        cg2_compound_assign(node);
        return;
    case AST_FUNC_CALL:
    case AST_FUNCPTR_CALL:
        cg2_func_call(node);
        return;
    case OP_CAST: {
        /* Walk the operand, then materialize any width-changing
           conversion. Handles int↔long and int/long↔decimal.
           char/short narrowing is a no-op since the value already
           lives in HL. */
        Node *op = node->operand;
        Kind from = op && op->type ? op->type->kind : KIND_INT;
        Kind to   = node->type     ? node->type->kind : KIND_INT;
        int from_unsigned = op && op->type && op->type->isunsigned;
        int to_unsigned = node->type && node->type->isunsigned;
        /* Literal-to-decimal shortcut: skip the produce-then-convert
           dance for constant operands cast to a decimal kind. Saves a
           redundant ftof16 / sint2f call after the parser already
           handed us the value. */
        if (op && op->ast_type == AST_LITERAL && kind_is_decimal(to)) {
            gen_load_constant_as_float((double)op->zval, to,
                from_unsigned ? 1 : 0);
            return;
        }
        cg2_walk(op);
        if (kind_is_decimal(to) && !kind_is_decimal(from)) {
            /* int / long → decimal. zconvert_to_decimal dispatches
               on the source kind and emits the right sint2f /
               slong2f / uchar2f / etc. helper. */
            zconvert_to_decimal(from, to, from_unsigned, to_unsigned);
            return;
        }
        if (kind_is_decimal(from) && !kind_is_decimal(to)) {
            /* decimal → int / long. zconvert_from_decimal picks
               f2sint / f2uint / f2slong / f2ulong by target. */
            zconvert_from_decimal(from, to, to_unsigned);
            return;
        }
        if (kind_is_decimal(from) && kind_is_decimal(to) && from != to) {
            /* decimal → decimal of a different kind (FLOAT16 ↔
               DOUBLE, ACCUM ↔ floating, etc.). */
            zconvert_to_decimal(from, to, from_unsigned, to_unsigned);
            return;
        }
        if (to == KIND_LONGLONG && from != KIND_LONGLONG) {
            /* widen int / long / char → long long via the
               appropriate `l_i64_*int2i64` / `l_i64_*long2i64`
               helper. The result lives in `__i64_acc`. */
            zconvert_to_llong(to_unsigned, from, from_unsigned);
            return;
        }
        if (from == KIND_LONGLONG && to != KIND_LONGLONG) {
            /* narrow long long → long / int / char. The helper
               `l_i64_s64_toi32` (or unsigned variant) drops the
               high half and leaves DEHL holding the low 32 bits;
               for KIND_INT the int return uses HL only. */
            zconvert_to_long(to_unsigned, KIND_LONGLONG, from_unsigned);
            return;
        }
        int from_is_long = (from == KIND_LONG || from == KIND_CPTR);
        int to_is_long   = (to   == KIND_LONG || to   == KIND_CPTR);
        if (!from_is_long && to_is_long) {
            /* int → long. Sign- or zero-extend HL into DE.
               Signedness comes from the *source* type. */
            if (from_unsigned) gen_conv_uint2long();
            else               gen_conv_sint2long();
            return;
        }
        if (to == KIND_CHAR) {
            /* Narrow / signedness-change into char. The value in HL
               represents the source after cg2_walk(op) — for a
               signed-char load that's sign-extended (l_gcharsp), for
               an unsigned-char or wider int load it's the natural
               16-bit value. Re-normalize HL to the target char's
               representation: zero H for unsigned, sign-extend from
               L's bit 7 for signed. Same-kind same-signedness is a
               no-op (cg2_walk already produced the right shape). */
            if (!(from == KIND_CHAR && from_unsigned == to_unsigned)) {
                if (to_unsigned) {
                    ol("ld\th,0");
                } else {
                    ol("ld\ta,l");
                    ol("rlca");
                    ol("sbc\ta,a");
                    ol("ld\th,a");
                }
            }
            return;
        }
        /* long → int: keep HL (low 16 bits), discard DE — natural
           truncation, no emit needed. */
        return;
    }
    case AST_LABEL:
        postlabel(node->label);
        return;
    case AST_JUMP:
        gen_jp_label(node->label, 0);
        return;
    case AST_IF:
    case AST_TERNARY: {
        /* If the cond is false (HL=0), jump to else_lbl. Otherwise
           fall through to the then-branch, then jump past the else.

           Both AST_IF (statement) and AST_TERNARY (value) share this
           shape — the only difference is whether the branch sub-trees
           leave a value in HL (ternary does, if at all) vs. emit
           statements (if).

           Mixed-width ternary: when the result type is long but a
           branch produces int (e.g. `cond ? 100000L : 0`), promote
           the narrower branch — otherwise the false-arm only sets
           HL and DE retains junk from earlier code, leaking through
           the merge point. Mirrors what `force()` does parser-side. */
        Node *thenN = node->then;
        Node *elsN  = node->els;
        /* Branch-to-ret peephole: `if (cond) return;` (no value, no
           else) when the function has a bare-ret epilogue. Saves the
           `jp cc,.L; ret; .L` trio in favour of a single `ret cc`.
           `doreturn()` wraps an empty operand list in an empty
           AST_COMPOUND_STMT, so accept that shape too. */
        if (cg2_bare_ret_p && !elsN && thenN
            && thenN->ast_type == AST_RETURN
            && (thenN->retval == NULL
                || (thenN->retval->ast_type == AST_COMPOUND_STMT
                    && array_len(thenN->retval->stmts) == 0))) {
            cg2_walk_cond_to_ret(node->cond, /*ret_if_true=*/1);
            return;
        }
        /* Peephole for `cond → goto LBL` shapes (which the parser
           emits for `for`/`while`/`if-goto`). When one arm is just a
           jump and the other is either absent or falls through to the
           next sibling, we can drop both the else_lbl trampoline and
           the "skip past els" jump:

             elsN=AST_JUMP(L):  cond → jp on-false to L; thenN
             thenN=AST_JUMP(L) && elsN=NULL: cond → jp on-true to L

           Stmt-context only — a value-context ternary would have
           value-producing arms, never a bare AST_JUMP. */
        if (elsN && elsN->ast_type == AST_JUMP) {
            cg2_walk_cond(node->cond, elsN->label, /*jump_on_true=*/0);
            if (thenN) {
                Kind result_k = node->type ? node->type->kind : KIND_INT;
                cg2_walk_widened(thenN, result_k);
            }
            return;
        }
        if (thenN && thenN->ast_type == AST_JUMP && !elsN) {
            cg2_walk_cond(node->cond, thenN->label, /*jump_on_true=*/1);
            return;
        }
        int else_lbl = getlabel();
        /* Separate end label whenever there's an else branch — the
           TRUE path needs somewhere to land past the elsN code. */
        int end_lbl = elsN ? getlabel() : else_lbl;
        /* Direct-to-branch emit: comparisons end with a flag test, OR
           / AND chains plant their branches in place — no carry→HL
           roundtrip per operand. Falls back to walk + truthiness test
           for unknown cond shapes. */
        cg2_walk_cond(node->cond, else_lbl, /*jump_on_true=*/0);
        Kind result_k = node->type ? node->type->kind : KIND_INT;
        if (thenN) cg2_walk_widened(thenN, result_k);
        /* Whenever there's an `else` branch, the TRUE-path needs to
           jump past it. The original guard `thenN && elsN` was wrong
           for the for-loop reshape `(? cond (noop) (goto exit))`:
           with thenN=NULL the true-path fell straight through into
           the elsN goto. */
        if (elsN) gen_jp_label(end_lbl, 0);
        postlabel(else_lbl);
        if (elsN) {
            cg2_walk_widened(elsN, result_k);
            postlabel(end_lbl);
        }
        return;
    }
    case AST_CRITICAL:
        gen_critical_enter();
        cg2_walk(node->operand);
        gen_critical_leave();
        return;
    case AST_LOOP_COUNTDOWN: {
        /* Reversed loop emitted by the loop-reversal pass.
           8-bit width: counter lives in B, back-edge is `djnz`.
           16-bit width: counter lives in BC, back-edge is `dec bc;
           ld a,b; or c; jp nz`. Pre-test branch covers the zero-trip
           case (decrement would wrap to 256 / 65536 otherwise). */
        int loop_lbl = getlabel();
        int exit_lbl = node->loop_exit_label;
        cg2_walk(node->loop_init);          /* counter → HL */
        if (node->loop_width8) {
            ol("ld\ta,l");
            ol("or\ta");
            opjump("z,", exit_lbl, 0);
            ol("ld\tb,a");
            postlabel(loop_lbl);
            ol("push\tbc");                 /* preserve counter across body */
            Zsp -= 2;
            cg2_walk(node->loop_body);
            if (node->loop_step_label) postlabel(node->loop_step_label);
            ol("pop\tbc");
            Zsp += 2;
            outfmt("\tdjnz\ti_%d\n", loop_lbl);
        } else {
            ol("ld\tb,h");
            ol("ld\tc,l");
            ol("ld\ta,b");
            ol("or\tc");
            opjump("z,", exit_lbl, 0);
            postlabel(loop_lbl);
            ol("push\tbc");                 /* preserve counter across body */
            Zsp -= 2;
            cg2_walk(node->loop_body);
            if (node->loop_step_label) postlabel(node->loop_step_label);
            ol("pop\tbc");
            Zsp += 2;
            ol("dec\tbc");
            ol("ld\ta,b");
            ol("or\tc");
            opjump("nz,", loop_lbl, 0);
        }
        postlabel(exit_lbl);
        return;
    }
    case AST_PRESERVE_BC:
        /* Wraps a body sub-stmt that may clobber BC. Counter is
           preserved across the operand. */
        ol("push\tbc");
        cg2_walk(node->operand);
        ol("pop\tbc");
        return;
    case AST_ASM:
        /* AST_ASM holds the raw asm text in `labelname` (Q13). It
           was captured from the parser's outbyte calls, so it's
           already-formatted asm — emit verbatim. */
        if (node->labelname) outstr(node->labelname);
        return;
    case OP_OROR: {
        /* Short-circuit OR producing HL=0/1 (value context). Operand
           walks route through `cg2_walk_cond` so each comparison
           branches directly on its flag — no per-operand carry→HL
           round-trip. Only the chain's tail materialises 0/1.

           Cond-context callers go through `cg2_walk_cond`'s own OP_OROR
           arm and skip this materialisation entirely. */
        int true_lbl = getlabel();
        int end_lbl  = getlabel();
        cg2_walk_cond(node->left,  true_lbl, 1);
        cg2_walk_cond(node->right, true_lbl, 1);
        vconst(0);
        gen_jp_label(end_lbl, 0);
        postlabel(true_lbl);
        vconst(1);
        postlabel(end_lbl);
        return;
    }
    case OP_ANDAND: {
        /* Short-circuit AND producing HL=0/1. Same shape as OP_OROR,
           inverted polarity. */
        int false_lbl = getlabel();
        int end_lbl   = getlabel();
        cg2_walk_cond(node->left,  false_lbl, 0);
        cg2_walk_cond(node->right, false_lbl, 0);
        vconst(1);
        gen_jp_label(end_lbl, 0);
        postlabel(false_lbl);
        vconst(0);
        postlabel(end_lbl);
        return;
    }
    case AST_UNDECL:
    case AST_INIT_STATIC:
        /* AST_UNDECL: with single-frame allocation, no per-block
           unwinding is needed. AST_INIT_STATIC: aggregate-from-static
           init — Phase F. */
        return;
    case AST_SWITCH: {
        /* Self-contained switch (Phase D'): sw_cases holds the dispatch
           list, sw_default_label is the default target (== exit label
           if no `default:`), sw_exit_label is the break / fall-through
           target. Layout matches the legacy emission:
             eval sw_expr            ; -> HL (or A for char)
             jp   dispatch
             body (case-target labels live inside)
           dispatch:
             preamble                ; sets up A or calls l_case
             case-table              ; per-case compare/branch entries
             postamble               ; table terminator (non-char)
             jp default              ; either user `default:` or exit
           exit:                     ; break target / fall-through
        */
        Kind k = node->type ? node->type->kind : KIND_INT;
        int dispatch_lbl = getlabel();
        cg2_walk(node->sw_expr);
        gen_jp_label(dispatch_lbl, 0);
        if (node->sw_body) cg2_walk(node->sw_body);
        postlabel(dispatch_lbl);
        gen_switch_preamble(k);
        for (int i = 0; i < (int)array_len(node->sw_cases); i++) {
            Node *c = array_get_byindex(node->sw_cases, i);
            if (!c || c->ast_type != AST_SWITCH_CASE) continue;
            int64_t v = c->sw_value ? (int64_t)c->sw_value->zval : 0;
            gen_switch_case(k, v, c->sw_label);
        }
        gen_switch_postamble(k);
        gen_jp_label(node->sw_default_label, 1);
        if (node->sw_exit_label) postlabel(node->sw_exit_label);
        return;
    }
    case AST_SWITCH_CASE:
        /* Should not appear standalone — case dispatch is inside the
           AST_SWITCH node (see Phase D'). */
        errorfmt("ast-codegen2: stray AST_SWITCH_CASE outside switch", 1);
        return;
    default:
        errorfmt("ast-codegen2: unhandled AST kind %d (Phase B)", 1, node->ast_type);
        return;
    }
}

/* C_LINE marker emission for the walker. Each statement carries
   the source (filename, line) it came from. When -gcline / -intermix
   is on, emit a C_LINE before the statement's asm so debuggers can
   map asm offsets back to C source positions. Tracks the last
   emitted line to suppress duplicates within a contiguous run on the
   same line. */
static void cg2_emit_cline_for(Node *s)
{
    if (!s) return;
    if (!c_cline_directive && !c_intermix_ccode) return;
    if (s->line <= 0) return;
    if (s->line == cg2_last_emitted_line
        && s->filename == cg2_last_emitted_file) return;
    /* gen_emit_line / gen_comment both read the global `lineno`.
       By walker time it sits at the EOF position, so stash and
       restore around the emit so the directive carries the source
       line of this AST node, not of the cursor. */
    int saved_lineno = lineno;
    lineno = s->line;
    if (c_intermix_ccode) {
        const char *src = get_source_line(s->filename, s->line);
        if (src) gen_comment(src);
    }
    gen_emit_line(s->line);
    lineno = saved_lineno;
    cg2_last_emitted_line = s->line;
    cg2_last_emitted_file = s->filename;
}

static void cg2_compound(Node *node)
{
    int n = (int)array_len(node->stmts);
    for (int i = 0; i < n; i++) {
        Node *s = array_get_byindex(node->stmts, i);
        cg2_emit_cline_for(s);
        /* The statement's resulting value is discarded — every top-
           level statement is run for effect. Hint that to cg2_walk so
           OP_ASSIGN can elide the value-in-HL contract for shapes
           that don't need it (currently char-literal-to-bare-LV/GV). */
        cg2_stmt_value_discarded = 1;
        cg2_walk(s);
        cg2_stmt_value_discarded = 0;
    }
}

static void cg2_literal(Node *node)
{
    Kind k = node->type ? node->type->kind : KIND_INT;
    switch (k) {
    case KIND_CHAR:
    case KIND_SHORT:
    case KIND_INT:
    case KIND_PTR:
    case KIND_ARRAY:
        /* KIND_ARRAY in a literal context arises post-promote_types
           on `arr + N` constant folds — the array name decays to a
           16-bit address, same emit as KIND_PTR. */
        vconst((int64_t)node->zval);
        return;
    case KIND_LONG:
    case KIND_CPTR:
        /* DEHL ← 32-bit constant. */
        vlongconst(node->zval);
        return;
    case KIND_LONGLONG:
        /* `__i64_acc` ← 64-bit constant. `vllongconst` calls
           `load_llong_into_acc` which emits the 8-byte literal
           and `l_i64_load`s it into the accumulator. */
        vllongconst(node->zval);
        return;
    case KIND_ACCUM16:
    case KIND_ACCUM32: {
        /* Fixed-point literals are integer-typed values stored
           HL (Q8.8 for ACCUM16) or DEHL (Q16.16 for ACCUM32) —
           load via `load_fixed`, NOT gen_load_constant_as_float
           (which is for floating-point). The latter would route
           ACCUM through the IEEE/MBF table path and emit a
           4-byte `dload`, breaking ACCUM16's 2-byte semantics. */
        LVALUE lv = {0};
        lv.val_type = k;
        lv.const_val = (double)node->zval;
        load_fixed(&lv);
        return;
    }
    case KIND_FLOAT16:
    case KIND_DOUBLE:
        /* `gen_load_constant_as_float` knows the layout per kind:
           FLOAT16 → HL via load_double_into_fa table-lookup;
           4-byte DOUBLE → DEHL via two `vconst`s with the IEEE
           bytes; bigger DOUBLE → FA via `load_double_into_fa`. */
        gen_load_constant_as_float((double)node->zval, k,
            node->type && node->type->isunsigned ? 1 : 0);
        return;
    default:
        errorfmt("ast-codegen2: literal kind %d not yet supported", 1, k);
        return;
    }
}

/* Recursive constness check for AST_INIT_LIST elements. Accepts:
   - AST_LITERAL: leaf numeric constant.
   - AST_STR_LIT: leaf string-pointer constant (literal queue
     offset, resolved by the linker).
   - AST_INIT_LIST: nested aggregate — all sub-elements must also
     be constant. Covers struct-array and array-of-struct shapes.
   Anything else (runtime expressions, symbol refs) is not const. */
static int init_list_is_const(Node *e)
{
    if (!e) return 0;
    if (e->ast_type == AST_LITERAL) return 1;
    if (e->ast_type == AST_STR_LIT) return 1;
    if (e->ast_type == AST_INIT_LIST) {
        int n = (int)array_len(e->stmts);
        for (int i = 0; i < n; i++) {
            Node *sub = array_get_byindex(e->stmts, i);
            if (!init_list_is_const(sub)) return 0;
        }
        return 1;
    }
    return 0;
}

static void cg2_emit_decl(Node *node)
{
    /* Frame slot already assigned in plan_color. Phase F handles:
       - scalar init (int / char / short): eval expr, store to slot.
       - AST_INIT_LIST init: eval each element, store at offset. */
    if (!node->sym || !node->declvar) return;
    if (node->sym->storage != STKLOC) return;
    SYMBOL *sym = node->sym;
    Kind k = sym->ctype ? sym->ctype->kind : KIND_INT;
    Node *init = node->declvar;

    if (init->ast_type == AST_INIT_LIST) {
        int n = (int)array_len(init->stmts);

        /* All-const fastpath: if every init-list element is a leaf
           constant (AST_LITERAL or AST_STR_LIT) OR a nested
           AST_INIT_LIST whose own elements are recursively
           leaf-const, the parser already emitted the full template
           into .data/.rodata under `auto_<funcname>_<symname>`. A
           single `copy_to_stack` (vconst+add hl,sp; ex de,hl;
           ld hl,label; ld bc,size; ldir) replaces N×(walk+store) —
           breakeven at ~2 elements for ints, immediately better
           for longs/chars. The recursion covers struct-array and
           array-of-array shapes where each element is itself an
           aggregate initialiser. */
        int aggregate_size = sym->ctype ? sym->ctype->size : 0;
        if (aggregate_size <= 0) aggregate_size = sym->size;
        int all_literal = (n > 0) && (aggregate_size > 0);
        for (int i = 0; i < n && all_literal; i++) {
            Node *e = array_get_byindex(init->stmts, i);
            if (!e || !init_list_is_const(e)) all_literal = 0;
        }
        if (all_literal && currfn) {
            char templ[NAMESIZE * 2 + 20];
            snprintf(templ, sizeof(templ), "auto_%s_%s",
                     currfn->name, sym->name);
            copy_to_stack(templ, sym->offset.i - Zsp, aggregate_size);
            return;
        }

        /* Struct init list: pair each element with the corresponding
           field, store at sym->offset + field->offset using the
           field's storage width. The fields live on the struct tag
           (`ctype->tag->fields`), not on ctype itself — sccz80
           gives `struct point p;` a ctype whose `tag` is the struct
           type and whose `fields` is NULL. */
        if (sym->ctype && sym->ctype->kind == KIND_STRUCT
            && sym->ctype->tag && sym->ctype->tag->fields) {
            array *fields = sym->ctype->tag->fields;
            int nf = (int)array_len(fields);
            for (int i = 0; i < n && i < nf; i++) {
                Node *e = array_get_byindex(init->stmts, i);
                Type *field = array_get_byindex(fields, i);
                if (!e || !field) continue;
                Kind fk = field->kind;
                if (fk == KIND_LONG || fk == KIND_CPTR) cg2_walk_to_long(e);
                else                                     cg2_walk(e);
                cg2_store_at_offset(sym->offset.i + (int)field->offset,
                                    field->size);
            }
            return;
        }
        /* Array init: walk each element, store at successive
           per-element offsets. Element width comes from the
           symbol's pointee (ctype->ptr->size). */
        Type *elem = (sym->ctype && sym->ctype->kind == KIND_ARRAY)
                       ? sym->ctype->ptr : sym->ctype;
        int elem_size = elem ? elem->size : 2;
        if (elem_size < 1) elem_size = 2;
        for (int i = 0; i < n; i++) {
            Node *e = array_get_byindex(init->stmts, i);
            if (!e) continue;
            cg2_walk(e);
            cg2_store_at_offset(sym->offset.i + i * elem_size, elem_size);
        }
        return;
    }

    if (k != KIND_INT && k != KIND_SHORT && k != KIND_CHAR
        && k != KIND_PTR && k != KIND_LONG && k != KIND_CPTR
        && k != KIND_LONGLONG
        && !kind_is_decimal(k)) {
        errorfmt("ast-codegen2: AST_DECL of kind %d not yet supported (Phase F)", 1, k);
        return;
    }
    /* #218d: scalar literal init bypasses load + l_pint/l_plong. Same
       byte-store sequence as #218b in the OP_ASSIGN path. Char is
       included since a 1-byte store via `ld (hl),N` is cheaper than
       `cg2_walk_widened` + `gen_store_local` (the latter does
       `ld a,l; ld (slot),a` which is 2 extra bytes for the L→A
       transfer).
       Decimal kinds fall through to the helper path — fp constants
       need format-specific encoding the byte-store can't synthesise. */
    if (init->ast_type == AST_LITERAL && !kind_is_decimal(k)
        && k != KIND_LONGLONG) {
        int store_width = 0;
        if (k == KIND_CHAR) store_width = 1;
        else if (k == KIND_INT || k == KIND_SHORT
              || k == KIND_PTR) store_width = 2;
        else if (k == KIND_LONG || k == KIND_CPTR) store_width = 4;
        if (store_width) {
            gen_local_addr(sym->offset.i);
            gen_store_literal_at_hl((int64_t)init->zval, store_width);
            return;
        }
    }
    /* For long locals walk-and-promote in one step; cg2_walk_to_long
       takes the literal shortcut (vlongconst directly) instead of
       loading int + calling l_int2long_s when the init is a constant. */
    cg2_walk_widened(init, k);
    cg2_store_local_scalar(sym);
}

/* HL ← (sp + offset) where offset = sym->offset.i - Zsp.
   Uses the same `getloc` + `l_gint` pattern as legacy. */
/* Thin walker wrappers: extract (frame_offset, kind, unsigned) from
   the SYMBOL and hand off to codegen.c's gen_load_local /
   gen_store_local / gen_local_addr — those do the SP arithmetic,
   the kind dispatch (char / int / long / longlong / decimal) and
   call the per-CPU primitives (`l_gint` / `l_glong` / `l_i64_load`
   / `dload`, etc.). */
static void cg2_load_local_scalar(SYMBOL *sym)
{
    Kind k = sym->ctype ? sym->ctype->kind : KIND_INT;
    int  u = sym->ctype && sym->ctype->isunsigned;
    gen_load_local(sym->offset.i, k, u);
}

/* HL ← &local — address of a stack-allocated local. Used for array
   decay (`(lv=arr)` returns address) and `&local`. */
static void cg2_load_addr_local(SYMBOL *sym)
{
    gen_local_addr(sym->offset.i);
}

/* Store HL (or low byte of HL) at byte_offset (frame-relative).
   Width 1, 2, or 4 — mapped to KIND_CHAR / KIND_INT / KIND_LONG.
   Used by AST_DECL scalar init and AST_INIT_LIST element stores. */
static void cg2_store_at_offset(int byte_offset, int width)
{
    Kind k = (width == 1) ? KIND_CHAR
           : (width == 4) ? KIND_LONG
           : KIND_INT;
    gen_store_local(byte_offset, k);
}

/* Pick the right plain-store helper for the symbol's kind. */
static void cg2_store_local_scalar(SYMBOL *sym)
{
    Kind k = sym->ctype ? sym->ctype->kind : KIND_INT;
    gen_store_local(sym->offset.i, k);
}

/* Given a node that's expected to produce a pointer/array address,
   walk it down to find the underlying ELEMENT type (i.e. what the
   pointer points at). We need this because `normalize_types`
   promotes the deref's `node->type` to int by default integer
   promotion, but the actual storage width may be smaller. */
static Type *cg2_pointee_type(Node *n)
{
    if (!n) return NULL;
    if ((n->ast_type == AST_LOCAL_VAR || n->ast_type == AST_GLOBAL_VAR)
        && n->sym && n->sym->ctype && n->sym->ctype->ptr) {
        return n->sym->ctype->ptr;
    }
    if (n->type && n->type->ptr) {
        return n->type->ptr;
    }
    /* Pointer arithmetic: recurse on operands. */
    if (n->ast_type == OP_ADD || n->ast_type == OP_SUB) {
        Type *t = cg2_pointee_type(n->left);
        if (t) return t;
        return cg2_pointee_type(n->right);
    }
    if ((n->ast_type == OP_ADDR || n->ast_type == AST_ADDR) && n->operand) {
        /* &x — pointee type is x's type. */
        if ((n->operand->ast_type == AST_LOCAL_VAR
          || n->operand->ast_type == AST_GLOBAL_VAR)
            && n->operand->sym) {
            return n->operand->sym->ctype;
        }
        return n->operand->type;
    }
    return NULL;
}

static void cg2_build_lvalue(Node *n, LVALUE *out)
{
    memset(out, 0, sizeof(*out));
    out->ltype = n && n->type ? n->type : type_int;
    out->val_type = out->ltype->kind;
    out->indirect_kind = out->val_type;
}

/* Set Z flag from the truthiness of the primary "register",
   width-aware. After this, `jp z, X` branches when the value is
   zero. Widths:
     - 16-bit (int / char / short / ptr): value is in HL — OR halves.
     - KIND_LONG / ACCUM32: value is in DEHL — OR all four bytes.
     - KIND_CPTR: 3 bytes, bank in E, address in HL — OR E only.
     - KIND_LONGLONG: 8-byte value lives in `__i64_acc` (memory)
       after l_i64_load, NOT in the z80 registers — call the
       runtime helper `l_i64_eq0` which sets Z accordingly.
   Without these width cases a value like 0x10000 (high=1, low=0)
   would test false because HL alone reads zero. */
static void cg2_truthiness_test(Kind k)
{
    gen_truthy_test(k);
}

/* Walk `n` leaving its value in DEHL. If `n` is already long-class
   just walk it; if it's a narrower scalar, promote afterwards.

   For literal narrower operands take a shortcut: emit
   `vlongconst(value)` directly, which is two `ld` instructions
   instead of `ld hl, val; call l_int2long_s` (a runtime helper).
   The helper sign-extends a value already in HL — wasteful when
   we know the constant at compile time. */
static void cg2_walk_to_long(Node *n)
{
    if (!n) return;
    Kind k = n->type ? n->type->kind : KIND_INT;
    if (k == KIND_LONG || k == KIND_CPTR || k == KIND_ACCUM32) {
        cg2_walk(n);
        return;
    }
    if (n->ast_type == AST_LITERAL) {
        vlongconst((zdouble)n->zval);
        return;
    }
    cg2_walk(n);
    if (n->type && n->type->isunsigned) gen_conv_uint2long();
    else                                  gen_conv_sint2long();
}

/* Walk `n` leaving its 64-bit value in `__i64_acc`. If `n` is
   already KIND_LONGLONG, just walk it. Otherwise walk it and call
   the appropriate `l_i64_*int2i64` / `l_i64_*long2i64` widening
   helper. Mirrors the legacy `widenintegers`/`zwiden_stack_to_llong`
   path but on already-evaluated operands. Constants take a
   shortcut via `vllongconst`. */
static void cg2_walk_to_llong(Node *n)
{
    if (!n) return;
    Kind k = n->type ? n->type->kind : KIND_INT;
    if (k == KIND_LONGLONG) {
        cg2_walk(n);
        return;
    }
    if (n->ast_type == AST_LITERAL) {
        vllongconst((zdouble)n->zval);
        return;
    }
    cg2_walk(n);
    int from_unsigned = n->type && n->type->isunsigned;
    zconvert_to_llong(0, k, from_unsigned);
}

/* Walk `n` leaving its value in the primary register for `target_kind`
   (one of KIND_DOUBLE / KIND_FLOAT16 / KIND_ACCUM16 / KIND_ACCUM32).
   If `n` is already that decimal kind, just walk it. Otherwise walk
   it and call the appropriate conversion. Mirrors the legacy
   `widen_if_float` / `zconvert_to_decimal` flow but operates on
   already-AST-built operands. */
static void cg2_walk_to_decimal(Node *n, Kind target_kind)
{
    if (!n) return;
    Kind k = n->type ? n->type->kind : KIND_INT;
    if (k == target_kind) {
        cg2_walk(n);
        return;
    }
    if (n->ast_type == AST_LITERAL && kind_is_decimal(target_kind)) {
        /* Skip the produce-then-convert dance for literals — emit the
           constant directly in the target kind. */
        gen_load_constant_as_float((double)n->zval, target_kind,
            n->type && n->type->isunsigned ? 1 : 0);
        return;
    }
    cg2_walk(n);
    int from_unsigned = n->type && n->type->isunsigned;
    int target_unsigned = 0;  /* target kind is decimal */
    zconvert_to_decimal(k, target_kind, from_unsigned, target_unsigned);
}

/* Walk `n` leaving its value in the primary register at the width
   the destination kind `dest_k` requires. Dispatcher for the
   common ladder that every assignment / init / call-arg-coerce
   site repeats: longlong → __i64_acc via cg2_walk_to_llong;
   long-class (LONG / CPTR) → DEHL via cg2_walk_to_long; decimal
   (DOUBLE / FLOAT16 / ACCUM16 / ACCUM32) → FA / HL via
   cg2_walk_to_decimal; otherwise bare cg2_walk for the 16-bit
   (or sub-16-bit char) shapes. KIND_ACCUM32 falls into the
   kind_is_decimal arm — cg2_walk_to_decimal handles it via
   load_fixed, which is the correct lowering. */
static void cg2_walk_widened(Node *n, Kind dest_k)
{
    if      (dest_k == KIND_LONGLONG)                       cg2_walk_to_llong(n);
    else if (dest_k == KIND_LONG || dest_k == KIND_CPTR)    cg2_walk_to_long(n);
    else if (kind_is_decimal(dest_k))                       cg2_walk_to_decimal(n, dest_k);
    else                                                    cg2_walk(n);
}

/* Match a single byte-pack term against the shape `(<<S (cast long
   byte_expr) K)` or bare `(cast long byte_expr)` (K=0). On success
   set *out_byte and *out_shift; return 1. K must be 0/8/16/24 and
   the byte_expr's natural width must be 8-bit (so its evaluation
   leaves the byte in L). */
static int match_byte_term(Node *t, Node **out_byte, int *out_shift)
{
    if (!t) return 0;
    int shift = 0;
    Node *cast = t;
    /* Optional shift wrapper: <<S (signed-shift) of a long by a
       literal. Both << and <<u (signed/unsigned shift left) AST
       kinds map here — the operand is long, the count is literal. */
    if (t->ast_type == OP_SSHL || t->ast_type == OP_USHL) {
        if (!t->left || !t->right) return 0;
        if (t->right->ast_type != AST_LITERAL) return 0;
        shift = (int)t->right->zval;
        if (shift != 8 && shift != 16 && shift != 24) return 0;
        cast = t->left;
    }
    /* The cast wraps the byte expression to widen it to UINT4 before
       the shift. Without the cast a literal 24 shift on an 8-bit
       value would be UB / zero; the C code reliably casts first. */
    if (cast->ast_type != OP_CAST || !cast->operand) return 0;
    if (!cast->type
        || (cast->type->kind != KIND_LONG && cast->type->kind != KIND_CPTR))
        return 0;
    Node *byte = cast->operand;
    /* The cast's operand must be 8-bit so its low byte equals the
       cast result's low byte. Accept char locals/globals as well as
       indirect byte loads (`*(p+N)`, struct member char). */
    if (!byte->type || byte->type->kind != KIND_CHAR) return 0;
    *out_byte = byte;
    *out_shift = shift;
    return 1;
}

/* Walk the OR-tree (left-associated) collecting byte-pack terms.
   On any unmatched leaf return -1. Otherwise return the count. */
static int collect_byte_pack_terms(Node *n, Node **bytes, int *shifts,
                                   int *count, int max)
{
    if (!n) return -1;
    if (n->ast_type == OP_OR && n->left && n->right) {
        int rc = collect_byte_pack_terms(n->left, bytes, shifts, count, max);
        if (rc < 0) return -1;
        if (*count >= max) return -1;
        Node *b; int s;
        if (!match_byte_term(n->right, &b, &s)) return -1;
        bytes[*count] = b;
        shifts[*count] = s;
        (*count)++;
        return *count;
    }
    /* Leaf — must be a byte term itself. */
    if (*count >= max) return -1;
    Node *b; int s;
    if (!match_byte_term(n, &b, &s)) return -1;
    bytes[*count] = b;
    shifts[*count] = s;
    (*count)++;
    return *count;
}

/* #267 byte-in-A fastpath helpers.

   Targets the CRC-style bit-twiddling shape:
       c = (c & SINGLE_BIT) ? byte_expr(c, consts) : byte_expr(c, consts)
   where c is a bare char LV/GV and both branches reference only c
   plus byte-width constants. Default codegen reloads c (HL = sp+N;
   ld l,(hl); ld h,0) three times per iteration — once for the cond,
   once per branch. cg2_try_char_self_ternary loads c into A once,
   uses non-destructive `bit B,a` for the cond, evaluates each
   branch in A directly (single-byte instructions: `add a,a`,
   `xor K`, etc.), stores A back. Cuts ~30 instr/bit-iter to ~10
   on the CRC inner loop.

   cg2_node_is_byte_in_a_safe — gate predicate. Only accepts nodes
   whose evaluation can be expressed as byte ops on A.

   cg2_walk_byte_in_a — emits the byte ops, assuming A holds c's
   current value on entry and must hold the expression's value on
   exit. OP_CAST nodes are transparent (we work in byte width
   throughout; the eventual store truncates). */
static int cg2_node_is_byte_in_a_safe(Node *n, SYMBOL *self)
{
    if (!n) return 0;
    /* OP_CAST is transparent in byte-in-A mode. */
    if (n->ast_type == OP_CAST && n->operand)
        return cg2_node_is_byte_in_a_safe(n->operand, self);
    /* Self-read: the walker materializes scalar local/global reads as
       OP_DEREF(LV/GV) — bare AST_LOCAL_VAR by itself is an lvalue
       (address), not a value. Match the OP_DEREF wrapper here. */
    if (n->ast_type == OP_DEREF && n->operand
        && (n->operand->ast_type == AST_LOCAL_VAR
         || n->operand->ast_type == AST_GLOBAL_VAR)
        && n->operand->sym == self)
        return 1;
    /* Byte literal: loadable into A via `ld a, N`. */
    if (n->ast_type == AST_LITERAL) {
        int64_t v = (int64_t)n->zval;
        return v >= 0 && v <= 255;
    }
    /* Commutative byte ops: one operand must be safe sub-expr,
       the other a byte literal. */
    if (n->ast_type == OP_AND || n->ast_type == OP_OR
     || n->ast_type == OP_XOR) {
        Node *l = n->left, *r = n->right;
        if (!l || !r) return 0;
        if (r->ast_type == AST_LITERAL) {
            int64_t v = (int64_t)r->zval;
            if (v < 0 || v > 255) return 0;
            return cg2_node_is_byte_in_a_safe(l, self);
        }
        if (l->ast_type == AST_LITERAL) {
            int64_t v = (int64_t)l->zval;
            if (v < 0 || v > 255) return 0;
            return cg2_node_is_byte_in_a_safe(r, self);
        }
        return 0;
    }
    /* Shifts: left = safe sub-expr, right = literal 1..7. */
    if (n->ast_type == OP_USHL || n->ast_type == OP_SSHL
     || n->ast_type == OP_USHR || n->ast_type == OP_SSHR) {
        if (!n->left || !n->right) return 0;
        if (n->right->ast_type != AST_LITERAL) return 0;
        int64_t k = (int64_t)n->right->zval;
        if (k < 1 || k > 7) return 0;
        return cg2_node_is_byte_in_a_safe(n->left, self);
    }
    return 0;
}

static void cg2_walk_byte_in_a(Node *n, SYMBOL *self)
{
    if (!n) return;
    /* OP_CAST transparent: descend. */
    if (n->ast_type == OP_CAST && n->operand) {
        cg2_walk_byte_in_a(n->operand, self);
        return;
    }
    /* Self-read is a no-op (A already has the value). */
    if (n->ast_type == OP_DEREF && n->operand
        && (n->operand->ast_type == AST_LOCAL_VAR
         || n->operand->ast_type == AST_GLOBAL_VAR)
        && n->operand->sym == self) {
        return;
    }
    /* Byte literal — replace A. Caller's invariant says the prior A
       value is no longer needed. (We only hit a bare literal if it's
       a complete sub-expression — never as an operand of a binop
       we're already evaluating, because the predicate restricts the
       literal to one side.) */
    if (n->ast_type == AST_LITERAL) {
        outfmt("\tld\ta,%d\n", (int)((int64_t)n->zval & 0xff));
        return;
    }
    if (n->ast_type == OP_AND || n->ast_type == OP_OR
     || n->ast_type == OP_XOR) {
        const char *op = (n->ast_type == OP_AND) ? "and"
                       : (n->ast_type == OP_OR)  ? "or"
                                                 : "xor";
        Node *sub = n->left;
        Node *lit = n->right;
        if (lit->ast_type != AST_LITERAL) { sub = n->right; lit = n->left; }
        cg2_walk_byte_in_a(sub, self);
        outfmt("\t%s\t%d\n", op, (int)((int64_t)lit->zval & 0xff));
        return;
    }
    if (n->ast_type == OP_USHL || n->ast_type == OP_SSHL) {
        cg2_walk_byte_in_a(n->left, self);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("add\ta");
        return;
    }
    if (n->ast_type == OP_USHR) {
        cg2_walk_byte_in_a(n->left, self);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("srl\ta");
        return;
    }
    if (n->ast_type == OP_SSHR) {
        cg2_walk_byte_in_a(n->left, self);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("sra\ta");
        return;
    }
}

/* Match `c = (c & SINGLE_BIT_LITERAL) ? then_byte_expr : else_byte_expr`
   and emit the byte-in-A sequence. Returns 1 on match, 0 otherwise.
   `is_global` selects the addressing mode for load/store; for locals
   the caller passes `frame_offset` which we use via gen_local_addr +
   ld a,(hl) / ld (hl),a so HL = &c persists across the body. */
static int cg2_try_char_self_ternary(SYMBOL *sym, Node *rhs, int is_global,
                                     int frame_offset)
{
    if (!rhs || rhs->ast_type != AST_TERNARY) return 0;
    Node *cond = rhs->cond;
    Node *then = rhs->then;
    Node *els  = rhs->els;
    if (!cond || !then || !els) return 0;

    /* Cond must be `(self & single_bit_literal)`. AND commutes, accept
       literal on either side. */
    if (cond->ast_type != OP_AND) return 0;
    Node *cl = cond->left, *cr = cond->right;
    Node *cself = NULL;
    int64_t mask = -1;
    /* Helper-style inline check: a node is a self-read iff it's
       OP_DEREF(AST_LOCAL_VAR/AST_GLOBAL_VAR self). */
    #define IS_SELF_READ(n) \
        ((n) && (n)->ast_type == OP_DEREF && (n)->operand \
         && ((n)->operand->ast_type == AST_LOCAL_VAR \
          || (n)->operand->ast_type == AST_GLOBAL_VAR) \
         && (n)->operand->sym == sym)
    if (cl && cr) {
        if (cr->ast_type == AST_LITERAL && IS_SELF_READ(cl)) {
            cself = cl;
            mask = (int64_t)cr->zval;
        } else if (cl->ast_type == AST_LITERAL && IS_SELF_READ(cr)) {
            cself = cr;
            mask = (int64_t)cl->zval;
        }
    }
    #undef IS_SELF_READ
    if (!cself || mask <= 0 || mask > 255) return 0;
    /* Single-bit mask only — gives us non-destructive `bit B,a`. */
    int bit_pos = -1;
    for (int i = 0; i < 8; i++) {
        if (mask == (1LL << i)) { bit_pos = i; break; }
    }
    if (bit_pos < 0) return 0;

    /* Both branches must be byte-in-A safe (only self + byte
       constants + byte-width ops). */
    if (!cg2_node_is_byte_in_a_safe(then, sym)) return 0;
    if (!cg2_node_is_byte_in_a_safe(els,  sym)) return 0;

    /* Emit: load self into A, keeping HL = &self for the store. */
    if (is_global) {
        outfmt("\tld\ta,(_%s)\n", sym->name);
    } else {
        gen_local_addr(frame_offset);
        ol("ld\ta,(hl)");
    }

    int else_lbl = getlabel();
    int end_lbl  = getlabel();

    /* `bit B,a` doesn't modify A, so we can fall through with A=self
       on both paths. Z is set iff bit is 0 → branch on Z to else. */
    outfmt("\tbit\t%d,a\n", bit_pos);
    outfmt("\tjp\tz,i_%d\t;\n", else_lbl);

    cg2_walk_byte_in_a(then, sym);
    if (is_global) outfmt("\tld\t(_%s),a\n", sym->name);
    else           ol("ld\t(hl),a");
    outfmt("\tjp\ti_%d\t;\n", end_lbl);

    outfmt(".i_%d\n", else_lbl);
    cg2_walk_byte_in_a(els, sym);
    if (is_global) outfmt("\tld\t(_%s),a\n", sym->name);
    else           ol("ld\t(hl),a");

    outfmt(".i_%d\n", end_lbl);
    return 1;
}

/* #268 general byte-arith-in-A fastpath for `char_LV = byte_expr`.
   Targets the schar_mix shape: `acc = (signed char)(acc <op> b)`
   where acc and b are bare char LVs. Default codegen calls
   `l_gcharsp` twice (each does load + sign-extend to int, ~64 cyc),
   does the int binop in HL/DE, then narrows back. This fastpath
   evaluates entirely in A using single-byte z80 ops (`add a,(hl)`,
   `sub (hl)`, `and (hl)`, `or (hl)`, `xor (hl)`, `add a,N` etc.),
   so each binop costs ~20 cyc instead of ~150.

   Predicate: byte_expr is any of:
     - OP_CAST(integer kind, X)           — transparent (work in A)
     - AST_LITERAL byte                   — `ld a, N`
     - OP_DEREF(LV/GV char)               — `ld a, (addr)`
     - OP_AND/OR/XOR/ADD/SUB(L, R)
         where R is AST_LITERAL byte      — `<op> a, N`
         OR R is OP_DEREF(LV/GV char)     — `ld hl,&R; <op> a,(hl)`
     - OP_USHL/SSHL/USHR/SSHR(L, lit 1..7) — `add a,a` / `srl a` / `sra a`

   Emit walks: load A from the leftmost leaf, then chain ops to the
   right. After the RHS evaluation A holds the result; store with
   freshly-computed address (HL was clobbered by intermediate
   `<op>(hl)` ops, so the store path recomputes &dest). */
static int cg2_lv_is_bare_char_read(Node *n)
{
    if (!n || n->ast_type != OP_DEREF || !n->operand) return 0;
    Node *op = n->operand;
    if (op->ast_type != AST_LOCAL_VAR && op->ast_type != AST_GLOBAL_VAR)
        return 0;
    if (!op->sym || !op->sym->ctype) return 0;
    if (op->sym->ctype->kind != KIND_CHAR) return 0;
    /* No FAR/PORT/volatile — those need their own path. */
    if (op->sym->ctype->flags & FARACC) return 0;
    if (op->sym->ctype->isvolatile) return 0;
    if (op->sym->type == KIND_PORT8 || op->sym->type == KIND_PORT16) return 0;
    return 1;
}

static int cg2_byte_arith_safe(Node *n)
{
    if (!n) return 0;
    /* OP_CAST transparent across integer kinds — we work in A
       (8 bits), the eventual store narrows. */
    if (n->ast_type == OP_CAST && n->operand && n->type) {
        Kind tk = n->type->kind;
        if (tk == KIND_CHAR || tk == KIND_INT || tk == KIND_SHORT
         || tk == KIND_LONG || tk == KIND_PTR  || tk == KIND_CPTR)
            return cg2_byte_arith_safe(n->operand);
        return 0;
    }
    if (n->ast_type == AST_LITERAL) {
        int64_t v = (int64_t)n->zval;
        return v >= -128 && v <= 255;
    }
    if (cg2_lv_is_bare_char_read(n)) return 1;
    if (n->ast_type == OP_AND || n->ast_type == OP_OR
     || n->ast_type == OP_XOR || n->ast_type == OP_ADD
     || n->ast_type == OP_SUB) {
        Node *l = n->left, *r = n->right;
        if (!l || !r) return 0;
        if (!cg2_byte_arith_safe(l)) return 0;
        /* RHS terminal: byte literal or bare char read. */
        if (r->ast_type == AST_LITERAL) {
            int64_t v = (int64_t)r->zval;
            return v >= -128 && v <= 255;
        }
        return cg2_lv_is_bare_char_read(r);
    }
    if (n->ast_type == OP_USHL || n->ast_type == OP_SSHL
     || n->ast_type == OP_USHR || n->ast_type == OP_SSHR) {
        if (!n->left || !n->right) return 0;
        if (n->right->ast_type != AST_LITERAL) return 0;
        int64_t k = (int64_t)n->right->zval;
        if (k < 1 || k > 7) return 0;
        return cg2_byte_arith_safe(n->left);
    }
    return 0;
}

static void cg2_emit_load_a_from_char_lv(Node *deref)
{
    Node *lv = deref->operand;
    SYMBOL *s = lv->sym;
    if (lv->ast_type == AST_GLOBAL_VAR) {
        outfmt("\tld\ta,(_%s)\n", s->name);
    } else {
        gen_local_addr(s->offset.i);
        ol("ld\ta,(hl)");
    }
}

static void cg2_emit_op_a_with_char_lv(const char *op, Node *deref)
{
    /* Apply A := A <op> mem[&lv]. Load address into HL then `<op> a,(hl)`.
       For globals we could use `ld hl,_sym` (3 bytes); for locals
       gen_local_addr (4 bytes typically). The single-byte `<op> (hl)`
       follows. */
    Node *lv = deref->operand;
    SYMBOL *s = lv->sym;
    if (lv->ast_type == AST_GLOBAL_VAR) {
        outfmt("\tld\thl,_%s\n", s->name);
    } else {
        gen_local_addr(s->offset.i);
    }
    outfmt("\t%s\t(hl)\n", op);
}

static void cg2_walk_byte_arith_into_a(Node *n)
{
    if (n->ast_type == OP_CAST) {
        cg2_walk_byte_arith_into_a(n->operand);
        return;
    }
    if (n->ast_type == AST_LITERAL) {
        outfmt("\tld\ta,%d\n", (int)((int64_t)n->zval & 0xff));
        return;
    }
    if (cg2_lv_is_bare_char_read(n)) {
        cg2_emit_load_a_from_char_lv(n);
        return;
    }
    if (n->ast_type == OP_AND || n->ast_type == OP_OR
     || n->ast_type == OP_XOR || n->ast_type == OP_ADD
     || n->ast_type == OP_SUB) {
        /* z80 8-bit binops accept the implicit `a,` form: `add (hl)`,
           `sub (hl)`, `add N`, `sub N`. Assembler treats these as the
           A-destination variants. Shorter asm than `add a,(hl)`. */
        const char *op = (n->ast_type == OP_AND) ? "and"
                       : (n->ast_type == OP_OR)  ? "or"
                       : (n->ast_type == OP_XOR) ? "xor"
                       : (n->ast_type == OP_ADD) ? "add"
                                                 : "sub";
        cg2_walk_byte_arith_into_a(n->left);
        Node *r = n->right;
        if (r->ast_type == AST_LITERAL) {
            outfmt("\t%s\t%d\n", op, (int)((int64_t)r->zval & 0xff));
        } else {
            cg2_emit_op_a_with_char_lv(op, r);
        }
        return;
    }
    if (n->ast_type == OP_USHL || n->ast_type == OP_SSHL) {
        cg2_walk_byte_arith_into_a(n->left);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("add\ta");
        return;
    }
    if (n->ast_type == OP_USHR) {
        cg2_walk_byte_arith_into_a(n->left);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("srl\ta");
        return;
    }
    if (n->ast_type == OP_SSHR) {
        cg2_walk_byte_arith_into_a(n->left);
        int k = (int)((int64_t)n->right->zval & 0x07);
        for (int i = 0; i < k; i++) ol("sra\ta");
        return;
    }
}

static int cg2_try_char_byte_arith(SYMBOL *sym, Node *rhs, int is_global,
                                   int frame_offset)
{
    if (!rhs) return 0;
    /* Skip trivial shapes that other fastpaths already handle better:
       - AST_LITERAL alone (#218a)
       - AST_TERNARY (#267)
       - Bare self-read (degenerate, store-itself) */
    if (rhs->ast_type == AST_TERNARY) return 0;
    if (rhs->ast_type == AST_LITERAL) return 0;
    /* Must be more than a bare LV — otherwise we'd be paying the
       load-then-store dance for what's effectively `a = b`. Let the
       default path handle that. */
    Node *bare = rhs;
    while (bare->ast_type == OP_CAST && bare->operand) bare = bare->operand;
    if (cg2_lv_is_bare_char_read(bare)) return 0;

    if (!cg2_byte_arith_safe(rhs)) return 0;

    cg2_walk_byte_arith_into_a(rhs);
    if (is_global) {
        outfmt("\tld\t(_%s),a\n", sym->name);
    } else {
        gen_store_local_byte_in_a(frame_offset);
    }
    return 1;
}

/* Detect and emit the 4-byte pack idiom into DEHL. Returns 1 on
   success (caller skips general path), 0 if shape didn't match.
   On success leaves DEHL set so the enclosing assignment / push /
   etc. picks up the assembled long. */
static int cg2_try_byte_pack_long(Node *or_node)
{
    Node *bytes[4];
    int   shifts[4];
    int   count = 0;
    if (collect_byte_pack_terms(or_node, bytes, shifts, &count, 4) < 0)
        return 0;
    /* Require exactly 4 distinct shifts covering 0/8/16/24. */
    if (count != 4) return 0;
    int seen = 0;
    for (int i = 0; i < 4; i++) {
        int bit = 1 << (shifts[i] / 8);   /* 0→1, 8→2, 16→4, 24→8 */
        if (seen & bit) return 0;          /* duplicate position */
        seen |= bit;
    }
    if (seen != 0xF) return 0;             /* missing position */
    /* Reorder to {shift=24, 16, 8, 0} so we walk highest-K first
       and end with K=0 in HL.L. The push-chain then yields bytes
       at known stack offsets that we deposit into D / E / H / L. */
    Node *b_by_pos[4] = {0};
    for (int i = 0; i < 4; i++) b_by_pos[shifts[i] / 8] = bytes[i];

    /* Walk highest-K first, pushing each byte's word; finally walk
       K=0 byte (left in HL.L). Codegen.c's gen_byte_pack_long_finish
       then pops the 3 saved words and deposits each low byte into
       the right DEHL byte. Saves the 3 × l_long_or + per-byte
       shift-into-position scaffolding the general path would emit. */
    cg2_walk(b_by_pos[3]); zpush();   /* byte for D (shift=24) */
    cg2_walk(b_by_pos[2]); zpush();   /* byte for E (shift=16) */
    cg2_walk(b_by_pos[1]); zpush();   /* byte for H (shift=8) */
    cg2_walk(b_by_pos[0]);             /* byte for L (shift=0), in L */
    gen_byte_pack_long_finish();
    return 1;
}

/* Binop dispatch. For literal RHS uses the const-fastpath variants
   when available. Otherwise eval-push-eval-pop, then dispatch to a
   `codegen.c` primitive consuming HL (right) and DE (popped left).

   For comparisons the LVALUE's val_type must reflect the OPERAND
   type (so signedness picks the right helper); the AST node's
   `type` is INT (the comparison result), so we build the LVALUE
   from the LEFT operand instead. */
static void cg2_binop(Node *node)
{
    Node *L = node->left;
    Node *R = node->right;
    int kind = node->ast_type;
    int is_cmp = (kind == OP_EQ || kind == OP_NE
               || kind == OP_LT || kind == OP_LE
               || kind == OP_GT || kind == OP_GE);
    LVALUE lval;
    cg2_build_lvalue(is_cmp ? L : node, &lval);
    /* For comparisons, per C §6.3.1.8, signedness is from the
       usual-arithmetic-converted operand type, not L's own type.
       `(int)-1 < (unsigned int)1` should compare as unsigned. */
    if (is_cmp && L && R && L->type && R->type) {
        Type *promoted = promote_types(L->type, R->type);
        if (promoted) {
            lval.ltype = promoted;
            lval.val_type = promoted->kind;
            lval.indirect_kind = promoted->kind;
        }
    }

    /* Byte-pack fastpath: `(UINT4)b3<<24 | (UINT4)b2<<16 | (UINT4)b1<<8
       | (UINT4)b0` — a common idiom for assembling a 32-bit word from
       4 bytes (MD5 / SHA / network-byte-order conversions). The
       general OR-chain path would emit 3 × `l_long_or` runtime calls
       per pack, each preceded by a shift-into-position dance for the
       partial value. Inlined: walk each byte's low half into a
       temporary, then deposit into the right DEHL byte (D / E / H / L
       for shifts 24 / 16 / 8 / 0). Saves ~3 helper calls + setup per
       pack and shrinks the body. */
    if (kind == OP_OR
        && (lval.val_type == KIND_LONG || lval.val_type == KIND_CPTR)
        && cg2_try_byte_pack_long(node)) {
        return;
    }

    /* Const-RHS fastpath for ops with available *_const variants. The
       16-bit-class path is used for int / short / char; shifts also
       qualify for KIND_LONG since asl_const / asr_const have explicit
       long sequences. Other long-arithmetic ops (zadd_const etc.)
       also handle long but we skip them here for simplicity — the
       general path's `l_long_*` runtime call is fine. */
    /* Const-RHS fastpath: when the RHS is a literal, route through
       the `*_const` primitives in codegen.c. They handle int and
       long-class operands internally (specialised inline sequences
       for small values, `addbchl + jr nc; inc de` for long, etc.).
       Saves one push, the literal's vlongconst, and the runtime
       binop helper call.

       Avoid walking L until we've confirmed the op is one we
       handle here — otherwise we'd double-walk on fall-through. */
    int v_is_int_class = (lval.val_type == KIND_INT
                       || lval.val_type == KIND_SHORT
                       || lval.val_type == KIND_CHAR);
    int v_is_long_class = (lval.val_type == KIND_LONG
                        || lval.val_type == KIND_CPTR);

    /* FP-literal fastpath for OP_MULT / OP_DIV: route to mult_dconst /
       zdiv_dconst so that multiplications by 1.0 are elided and
       multiplications by powers of two collapse to a single `ldexp`
       (nobbles the FP exponent — fewer cycles than calling the FP
       multiply runtime). zdiv_dconst handles `1.0 / x → inversef(x)`.
       The helpers return 1 when they emitted the fast path; we only
       walk the operand if we know one will fire (otherwise fall
       through to the general path which would double-walk). */
    if (R && (kind == OP_MULT || kind == OP_DIV)
        && kind_is_floating(lval.val_type)) {
        Node *constN = NULL, *otherN = NULL;
        int isrhs = -1;
        if (R->ast_type == AST_LITERAL) {
            constN = R; otherN = L; isrhs = 1;
        } else if (L && L->ast_type == AST_LITERAL) {
            /* MULT is commutative; DIV with literal LHS is the
               `1.0/x → inversef(x)` case. Both routed through the
               same dispatch below; the will_fire check rejects
               cases the helpers don't handle. */
            constN = L; otherN = R; isrhs = 0;
        }
        if (constN) {
            double v = (double)constN->zval;
            int exp;
            int will_fire = 0;
            if (kind == OP_MULT) {
                /* mult_dconst fires on value==1.0 (any kind) or on a
                   power-of-two value for floating kinds. */
                will_fire = (v == 1.0)
                    || (kind_is_floating(lval.val_type)
                        && frexp(v, &exp) == 0.5);
            } else {
                /* zdiv_dconst fires on isrhs==0 && value==1.0 for
                   IEEE / FLOAT16 / ACCUM16 / ACCUM32. */
                will_fire = (isrhs == 0 && v == 1.0
                    && (c_maths_mode == MATHS_IEEE
                        || lval.val_type == KIND_FLOAT16
                        || lval.val_type == KIND_ACCUM16
                        || lval.val_type == KIND_ACCUM32));
            }
            if (will_fire) {
                cg2_walk_to_decimal(otherN, lval.val_type);
                if (kind == OP_MULT) mult_dconst(&lval, v, isrhs);
                else                  zdiv_dconst(&lval, v, isrhs);
                return;
            }
        }
    }

    /* #218b: char compare with literal in value context. The cond-
       context fastpath (cg2_walk_cond / cg2_compare_emit) already
       routes through gen_load_byte_cmp_const for these shapes —
       this brings the same byte-load + cp to value context so we
       skip the l_gchar widen, the int compare, and the messy
       int-compare materialise tail. Result HL = 0/1 via direct
       Z→HL or C→HL materialisation. Only fires on the equality
       and unsigned-or-signed `<` / `>=` shapes — `<=` / `>` need
       the K+1 wraparound check, deferred. */
    if (is_cmp && R && R->ast_type == AST_LITERAL) {
        Node *Lbare = L;
        if (Lbare && Lbare->ast_type == OP_DEREF && Lbare->operand)
            Lbare = Lbare->operand;
        int L_is_char = (Lbare
            && (Lbare->ast_type == AST_LOCAL_VAR || Lbare->ast_type == AST_GLOBAL_VAR)
            && Lbare->sym && Lbare->sym->ctype
            && Lbare->sym->ctype->kind == KIND_CHAR
            && !Lbare->sym->ctype->ptr
            && (Lbare->sym->storage == STKLOC
                || Lbare->sym->storage == STATIK
                || Lbare->sym->storage == EXTERNAL)
            && !(Lbare->sym->ctype->flags & FARACC));
        if (L_is_char) {
            SYMBOL *sym = Lbare->sym;
            int v = (int)(int64_t)R->zval;
            int handled = 1;
            if (kind == OP_EQ || kind == OP_NE) {
                gen_load_byte_cmp_const(sym, v);
                /* Z→HL=0/1. After cp K: Z=1 iff sym==K. */
                vconst(0);
                outfmt("\tjr\t%sz,ASMPC+3\n", kind == OP_NE ? "" : "n");
                ol("inc\tl");
            } else if (kind == OP_LT || kind == OP_GE) {
                if (sym->ctype->isunsigned) gen_load_byte_cmp_const(sym, v & 0xff);
                else                         gen_load_byte_signed_cmp_const(sym, v);
                /* After cp K (or xor 128 + cp): C=1 iff sym<K. For
                   OP_GE flip the carry first. */
                if (kind == OP_GE) ol("ccf");
                gen_conv_carry2int();
            } else {
                handled = 0;
            }
            if (handled) return;
        }
    }

    if (R && R->ast_type == AST_LITERAL
        && (v_is_int_class || v_is_long_class)) {
        int has_fast = 0;
        switch (kind) {
        case OP_ADD: case OP_SUB: case OP_MULT: case OP_DIV: case OP_MOD:
        case OP_AND: case OP_OR:  case OP_XOR:
        case OP_EQ:  case OP_NE:
        case OP_LT:  case OP_LE:  case OP_GT:  case OP_GE:
        case OP_SSHL: case OP_USHL: case OP_SSHR: case OP_USHR:
            has_fast = 1; break;
        default: break;
        }
        if (has_fast) {
            int64_t v = (int64_t)R->zval;
            if (v_is_long_class) cg2_walk_to_long(L);
            else                  cg2_walk(L);
            switch (kind) {
            case OP_ADD:  zadd_const(&lval, v); return;
            case OP_SUB:  zadd_const(&lval, -v); return;
            case OP_MULT: mult_const(&lval, v); return;
            case OP_DIV:  zdiv_const(&lval, v); return;
            case OP_MOD:  zmod_const(&lval, v); return;
            case OP_AND:  zand_const(&lval, v); return;
            case OP_OR:   zor_const(&lval,  v); return;
            case OP_XOR:  zxor_const(&lval, v); return;
            /* Comparisons: the codegen.c primitive sets the C flag
               (the legacy convention for branch tests). When the
               comparison is being used as a value (e.g.
               `return a == b;`) we materialize 0/1 in HL via
               gen_conv_carry2int. */
            case OP_EQ:   zeq_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_NE:   zne_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_LT:   zlt_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_LE:   zle_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_GT:   zgt_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_GE:   zge_const(&lval, v); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
            case OP_SSHL: case OP_USHL: asl_const(&lval, v); return;
            case OP_SSHR: case OP_USHR: asr_const(&lval, v); return;
            }
        }
    }

    /* General path: eval left → primary → push; eval right → primary.
       For 16-bit ops we follow up with `zpop()` so DE = left and the
       primitives (zadd/zsub/...) act on HL=R, DE=L. For 32-bit ops the
       runtime helpers (l_long_add etc.) read the saved value off the
       stack themselves, so we lpush() before R and skip the explicit
       pop. zpush/zpop/lpush already maintain Zsp via static push/pop.

       For mixed-width ops (e.g. `acc + 1000` where acc is long and the
       literal is int) we promote the narrower operand to long after
       evaluation — mirrors what `force()` does in the legacy
       parser-side path. Signedness comes from the operand's own type.
       Shift ops are excluded: the helpers (`l_long_asl` etc.) keep
       the shift count in HL as int regardless of the value's width.

       For decimal ops (FLOAT16 / DOUBLE / ACCUM16 / ACCUM32) the push
       uses `gen_push_float` (HL for float16/accum16, DE+HL for 4-byte
       double / accum32, fpush helper for 6/8-byte). The `z*` primitives
       handle the pop themselves: ACCUM16 calls zpop and falls through
       to add hl,de; LONG/ACCUM32 pop both halves; FLOAT16/DOUBLE call
       the library helper which consumes from stack. So no explicit
       walker-side pop. */
    int is_long_op = (lval.val_type == KIND_LONG
                   || lval.val_type == KIND_CPTR);
    int is_long_class = is_long_op || lval.val_type == KIND_ACCUM32;
    int is_longlong = (lval.val_type == KIND_LONGLONG);
    int is_decimal = kind_is_decimal(lval.val_type);
    int is_shift = (kind == OP_SSHL || kind == OP_USHL
                 || kind == OP_SSHR || kind == OP_USHR);
    /* `ex de,hl` fastpath for 16-bit int-class binops: when the
       SECOND operand to be walked is a side-effect-free expression
       whose codegen preserves DE (bare LV/GV via OP_DEREF, or an
       AST_LITERAL of int-class kind), we can skip the zpush/zpop
       pair and just `ex de,hl` after walking the first operand.
       Saves 1 byte (push/pop = 2 vs ex de,hl = 1) plus the stack
       traffic. Only int-class — long-class/longlong/decimal
       helpers consume from the stack so push is mandatory. */
    int use_ex_de_hl = 0;
    if (!is_long_class && !is_decimal && !is_longlong) {
        Node *second = R;  /* cg2_binop walks L then R, so R is second. */
        Node *peeled = second;
        if (peeled && peeled->ast_type == OP_DEREF && peeled->operand) {
            peeled = peeled->operand;
        }
        int second_kind = peeled ? (peeled->type ? peeled->type->kind : KIND_INT)
                                 : KIND_INT;
        int kind_ok = (second_kind == KIND_INT
                    || second_kind == KIND_SHORT
                    || second_kind == KIND_CHAR
                    || second_kind == KIND_PTR
                    || second_kind == KIND_FLOAT16
                    || second_kind == KIND_ACCUM16);
        if (kind_ok && peeled) {
            if (peeled->ast_type == AST_LITERAL
             || ((peeled->ast_type == AST_LOCAL_VAR
                  || peeled->ast_type == AST_GLOBAL_VAR)
                 && peeled->sym && peeled->sym->ctype
                 && !(peeled->sym->ctype->kind == KIND_ARRAY
                   || peeled->sym->ctype->kind == KIND_STRUCT))) {
                use_ex_de_hl = 1;
            }
        }
    }
    /* #241: when L is a long load from a non-bitfield memory
       address, fuse `walk-L + lpush` (which would emit
       `…address-walk…; call l_glong; push de; push hl`) into a
       single `call l_glong2sp` that loads-and-pushes atomically.
       Saves the explicit push de + push hl (2 instructions) per
       long-class binop where L is a deref. The runtime helper is
       available on z80 / r2ka / kc160 (via the 8080.lst chain) but
       not on gbz80; ez80 has its own inline form for l_glong that
       we'd be giving up. Gated accordingly.

       The operand-of-deref shape determines how we compute the
       address into HL (the helper's required input):
       - bare AST_LOCAL_VAR: gen_local_addr (sp-relative compute)
       - bare AST_GLOBAL_VAR: gen_address (ld hl,sym)
       - any pointer-bearing expression (OP_ADD, etc.): cg2_walk
         (the pointer's value IS the address)

       Bare globals/locals would otherwise be short-circuited by
       OP_DEREF's handler into `gen_load_static` / `gen_load_local`
       which load the VALUE — we deliberately bypass that to get
       the address instead. */
    int used_glong2sp = 0;
    if (is_long_op && L && L->ast_type == OP_DEREF && L->operand
        && (!L->type || L->type->bit_size == 0)
        && !IS_GBZ80() && !IS_EZ80()) {
        Node *op = L->operand;
        int can_glong2sp = 1;
        if (op->ast_type == AST_LOCAL_VAR && op->sym) {
            gen_local_addr(op->sym->offset.i);
        } else if (op->ast_type == AST_GLOBAL_VAR && op->sym
                   && op->sym->type != KIND_PORT8
                   && op->sym->type != KIND_PORT16
                   && !(op->sym->ctype && (op->sym->ctype->flags & FARACC))) {
            gen_address(op->sym);
        } else if (op->ast_type == OP_ADD) {
            /* Pointer-arithmetic operand. cg2_walk on OP_ADD emits
               the address computation into HL — exactly the shape
               l_glong2sp wants. */
            cg2_walk(op);
        } else {
            /* Other operand shapes (e.g. AST_LITERAL, function call
               returning a pointer) — skip the fastpath, fall back
               to the standard walk-L + lpush sequence. */
            can_glong2sp = 0;
        }
        if (can_glong2sp) {
            callrts("l_glong2sp");
            Zsp -= 4;   /* helper pushes the loaded long (low, high) */
            used_glong2sp = 1;
        }
    }
    /* #155 / FRAMEPTR Phase 1f: when use_ex_de_hl fastpath fires AND
       L is itself a simple loadable expression with a CPU-supported
       direct-to-DE form, load L directly into DE and skip both the
       cg2_walk(L) into HL and the trailing `ex de,hl`. Saves 1 byte
       per fire site under -frameiy (replaces `ld hl,(ix+d); ex de,hl`
       with `ld de,(ix+d)`) and on KC160 (replaces `ld hl,(sp+d); ex
       de,hl` with `ld de,(sp+d)`). Bare globals work on any CPU via
       `ld de,(nn)`. Literals always work via `ld de,N`. */
    int de_direct_loaded = 0;
    if (!used_glong2sp && use_ex_de_hl) {
        Node *peeled = L;
        if (peeled && peeled->ast_type == OP_DEREF && peeled->operand)
            peeled = peeled->operand;
        if (L && L->ast_type == AST_LITERAL) {
            int v = (int)(int64_t)L->zval;
            outfmt("\tld\tde,%d\n", v);
            de_direct_loaded = 1;
        } else if (peeled && peeled != L
                && (peeled->ast_type == AST_LOCAL_VAR
                 || peeled->ast_type == AST_GLOBAL_VAR)
                && peeled->sym && peeled->sym->ctype
                && !(peeled->sym->ctype->flags & FARACC)
                && peeled->sym->ctype->bit_size == 0
                && peeled->sym->ctype->kind != KIND_ARRAY
                && peeled->sym->ctype->kind != KIND_STRUCT
                && peeled->sym->type != KIND_PORT8
                && peeled->sym->type != KIND_PORT16) {
            if (peeled->ast_type == AST_LOCAL_VAR
                && peeled->sym->storage == STKLOC) {
                if (gen_load_local_int_to_de(peeled->sym->offset.i))
                    de_direct_loaded = 1;
            } else if (peeled->ast_type == AST_GLOBAL_VAR) {
                /* `ld de,(sym)` — 4 bytes (ED 5B nn nn). Available on
                   all z80-family CPUs. */
                ot("ld\tde,(");
                outname(peeled->sym->name, dopref(peeled->sym));
                outstr(")\n");
                de_direct_loaded = 1;
            }
        }
    }
    if (!used_glong2sp && !de_direct_loaded) {
        if (is_longlong)         cg2_walk_to_llong(L);
        else if (is_decimal)     cg2_walk_to_decimal(L, lval.val_type);
        else if (is_long_op)     cg2_walk_to_long(L);
        else                      cg2_walk(L);
    }
    if (used_glong2sp || de_direct_loaded) {
        /* push already done by the helper (glong2sp) or L is already
           in DE (de_direct_loaded) — skip both push and ex. */
    } else if (is_longlong)  llpush();
    else if (is_decimal)     gen_push_float(lval.val_type);
    else if (is_long_class)  lpush();
    else if (use_ex_de_hl)   ol("ex\tde,hl");
    else                     zpush();
    if (is_longlong && !is_shift)     cg2_walk_to_llong(R);
    else if (is_longlong)              cg2_walk(R); /* shift count stays int */
    else if (is_decimal)         cg2_walk_to_decimal(R, lval.val_type);
    else if (is_long_op && !is_shift) cg2_walk_to_long(R);
    else                          cg2_walk(R);
    /* For longlong / long-class / decimal the helper consumes from
       stack (zadd's KIND_LONGLONG case bumps Zsp by 8, etc.); only
       16-bit int-class needs an explicit zpop — unless we already
       moved L into DE via ex de,hl. */
    if (!is_long_class && !is_decimal && !is_longlong && !use_ex_de_hl) zpop();

    /* Comparison primitives in codegen.c stamp lval->val_type *after*
       the call: KIND_CARRY when the result is in the carry flag (the
       16-bit int / char / pointer paths via `set_carry`), KIND_INT when
       the helper returned 0/1 in HL (the long / longlong / FP / fixed
       paths via `set_int`). Materialising 0/1 via gen_conv_carry2int is
       only correct for the KIND_CARRY case — for KIND_INT the result
       already lives in HL and `rl l` would corrupt it. */
    switch (kind) {
    case OP_ADD:  zadd(&lval); return;
    case OP_SUB:
        zsub(&lval);
        /* Pointer subtraction returns the element difference, not the
           byte difference. After zsub leaves the byte-diff in HL we
           scale by 1/elem_size when both operands were pointer-typed.
           Mirrors legacy plnge2b's parser-side scale that vanished
           with the const-fold migration. ast_typecheck has already
           rejected ptr-non-ptr mismatches as errors. */
        if (L && R && L->type && R->type
            && (L->type->kind == KIND_PTR || L->type->kind == KIND_CPTR
                || L->type->kind == KIND_ARRAY)
            && (R->type->kind == KIND_PTR || R->type->kind == KIND_CPTR
                || R->type->kind == KIND_ARRAY)
            && L->type->ptr) {
            gen_ptr_diff_scale(L->type->ptr->size);
        }
        return;
    case OP_MULT: mult(&lval); return;
    case OP_DIV:  zdiv(&lval); return;
    case OP_MOD:  zmod(&lval); return;
    case OP_AND:  zand(&lval); return;
    case OP_OR:   zor(&lval);  return;
    case OP_XOR:  zxor(&lval); return;
    case OP_EQ:   zeq(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_NE:   zne(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_LT:   zlt(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_LE:   zle(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_GT:   zgt(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_GE:   zge(&lval); if (lval.val_type == KIND_CARRY) gen_conv_carry2int(); return;
    case OP_SSHL: case OP_USHL: asl(&lval); return;
    case OP_SSHR: case OP_USHR: asr(&lval); return;
    default:
        errorfmt("ast-codegen2: binop kind %d not implemented", 1, kind);
        return;
    }
}

static void cg2_unop(Node *node)
{
    LVALUE lval;
    cg2_build_lvalue(node, &lval);
    cg2_walk(node->operand);
    switch (node->ast_type) {
    case OP_NEG:  neg(&lval); return;
    case OP_COMP: com(&lval); return;
    case OP_LNEG: lneg(&lval); return;
    default:
        errorfmt("ast-codegen2: unop kind %d not implemented", 1, node->ast_type);
        return;
    }
}

/* Emit a comparison operator (OP_EQ / OP_NE / OP_LT / OP_LE / OP_GT /
   OP_GE) leaving the result on the appropriate flag for branching —
   carry for 16-bit int / char / pointer paths (via codegen.c's
   `set_carry`), HL for the long / longlong / FP paths (which call a
   helper that returns 0/1 in HL via `set_int`). The caller inspects
   `*out_lval` to decide whether to branch on carry or test HL.

   Mirrors cg2_binop's comparison arms but skips the trailing
   `gen_conv_carry2int` — the whole point is to avoid that carry→HL
   round-trip when the caller is going to branch on the result.

   `jp_label` / `jp_invert` are the Z-flag direct-branch hook: when
   jp_label != 0, the inline `_const` and non-const compare helpers
   in codegen.c emit `jp z/nz,jp_label` instead of the
   `scf; jr [z|nz],+3; ccf` materialise tail and mark `out_lval->jp_done`.
   Cond callers pass the target label; value-context callers pass 0.
   The helpers that fall back to `l_eq` / `l_long_eq` / `l_i64_eq` /
   `feq` ignore the hook (those library calls leave carry = result;
   the caller branches on carry as usual). */
static void cg2_compare_emit(Node *node, LVALUE *out_lval,
                             int jp_label, int jp_invert)
{
    int kind = node->ast_type;
    Node *L = node->left;
    Node *R = node->right;
    LVALUE lval;
    cg2_build_lvalue(L, &lval);
    /* Per C §6.3.1.8 the comparison operates on operands after the
       usual arithmetic conversions, not the LHS's own type. With a
       bare cg2_build_lvalue, `(int)-1 < (unsigned int)1` would pick
       a signed compare from L's int type — but the C-correct path
       promotes both operands to unsigned int and the comparison is
       unsigned. Override lval.ltype to the promoted operand type so
       ulvalue() reflects the comparison signedness. Width (val_type
       kind) is the same as L's promoted kind; the walk-to-long
       helpers below pick the right widening for either operand. */
    if (L && R && L->type && R->type) {
        Type *promoted = promote_types(L->type, R->type);
        if (promoted) {
            lval.ltype = promoted;
            lval.val_type = promoted->kind;
            lval.indirect_kind = promoted->kind;
        }
    }
    lval.jp_label  = jp_label;
    lval.jp_invert = jp_invert;

    /* Const-RHS fastpath — mirrors cg2_binop's. The `*_const`
       primitives in codegen.c handle int / char / long internally. */
    int v_is_int_class = (lval.val_type == KIND_INT
                       || lval.val_type == KIND_SHORT
                       || lval.val_type == KIND_CHAR);
    int v_is_long_class = (lval.val_type == KIND_LONG
                        || lval.val_type == KIND_CPTR);
    if (R && R->ast_type == AST_LITERAL && (v_is_int_class || v_is_long_class)) {
        int64_t v = (int64_t)R->zval;
        if (v_is_long_class) cg2_walk_to_long(L);
        else                  cg2_walk(L);
        switch (kind) {
        case OP_EQ: zeq_const(&lval, v); break;
        case OP_NE: zne_const(&lval, v); break;
        case OP_LT: zlt_const(&lval, v); break;
        case OP_LE: zle_const(&lval, v); break;
        case OP_GT: zgt_const(&lval, v); break;
        case OP_GE: zge_const(&lval, v); break;
        }
        *out_lval = lval;
        return;
    }

    /* General path: eval L, push, eval R, pop into DE. Long /
       longlong / decimal use width-specific push/pop and the helper
       consumes from stack. */
    int is_long_op = (lval.val_type == KIND_LONG || lval.val_type == KIND_CPTR);
    int is_long_class = is_long_op || lval.val_type == KIND_ACCUM32;
    int is_longlong = (lval.val_type == KIND_LONGLONG);
    int is_decimal = kind_is_decimal(lval.val_type);
    if (is_longlong)         cg2_walk_to_llong(L);
    else if (is_decimal)     cg2_walk_to_decimal(L, lval.val_type);
    else if (is_long_op)     cg2_walk_to_long(L);
    else                      cg2_walk(L);
    if (is_longlong)         llpush();
    else if (is_decimal)     gen_push_float(lval.val_type);
    else if (is_long_class)  lpush();
    else                     zpush();
    if (is_longlong)         cg2_walk_to_llong(R);
    else if (is_decimal)     cg2_walk_to_decimal(R, lval.val_type);
    else if (is_long_op)     cg2_walk_to_long(R);
    else                      cg2_walk(R);
    if (!is_long_class && !is_decimal && !is_longlong) zpop();

    switch (kind) {
    case OP_EQ: zeq(&lval); break;
    case OP_NE: zne(&lval); break;
    case OP_LT: zlt(&lval); break;
    case OP_LE: zle(&lval); break;
    case OP_GT: zgt(&lval); break;
    case OP_GE: zge(&lval); break;
    }
    *out_lval = lval;
}

/* Walk `node` as a boolean condition, ending with a conditional jump
   to `target_label` taken iff the value is true (jump_on_true=1) or
   false (jump_on_true=0). Produces no value in HL — the caller must
   not consume one.

   Comparisons (OP_EQ/NE/LT/LE/GT/GE) end on a flag the helper sets
   (carry for 16-bit, HL=0/1 for long/longlong/FP) — branched on
   directly. Other shapes fall back to walk + truthiness test + jump,
   matching the pre-existing testjump path. OP_OROR / OP_ANDAND /
   OP_LNEG arms are deferred to follow-on steps. */
static void cg2_walk_cond(Node *node, int target_label, int jump_on_true)
{
    if (!node) return;
    int k = node->ast_type;
    if (k == OP_EQ || k == OP_NE || k == OP_LT || k == OP_LE
     || k == OP_GT || k == OP_GE) {
        /* Char-compare fastpaths. The parser wraps a bare LV/GV in
           OP_DEREF for rvalue access, so peel that off before
           inspecting. Three shapes are intercepted before falling
           through to the generic widen-and-compare path:

           1. `c == K` / `c != K` (and commuted `K == c` / `K != c`):
              `ld a,(c); cp K; jp z/nz, target`.
           2. `c < K` / `c >= K` for unsigned char: `ld a,(c); cp K;
              jp c/nc, target`. For signed char: `xor 128; cp K+128`
              first (sign-bit flip preserves order under unsigned cp).
           3. `c1 == c2` / `c1 != c2` (both bare chars): `ld a,(c1);
              ld b,a; ld a,(c2); cp b; jp z/nz, target`.

           Saves widening via l_gchar + ld h,0 + `ld a,l` re-fetch +
           the scf/ccf materialise tail — ~7-10 bytes per site. */
        Node *L = node->left;
        Node *R = node->right;
        Node *Lbare = L;
        Node *Rbare = R;
        if (Lbare && Lbare->ast_type == OP_DEREF && Lbare->operand) Lbare = Lbare->operand;
        if (Rbare && Rbare->ast_type == OP_DEREF && Rbare->operand) Rbare = Rbare->operand;
        int L_is_char = (Lbare
            && (Lbare->ast_type == AST_LOCAL_VAR || Lbare->ast_type == AST_GLOBAL_VAR)
            && Lbare->sym && Lbare->sym->ctype
            && Lbare->sym->ctype->kind == KIND_CHAR
            && !Lbare->sym->ctype->ptr
            && (Lbare->sym->storage == STKLOC
                || Lbare->sym->storage == STATIK
                || Lbare->sym->storage == EXTERNAL));
        int R_is_char = (Rbare
            && (Rbare->ast_type == AST_LOCAL_VAR || Rbare->ast_type == AST_GLOBAL_VAR)
            && Rbare->sym && Rbare->sym->ctype
            && Rbare->sym->ctype->kind == KIND_CHAR
            && !Rbare->sym->ctype->ptr
            && (Rbare->sym->storage == STKLOC
                || Rbare->sym->storage == STATIK
                || Rbare->sym->storage == EXTERNAL));
        int R_is_lit = (R && R->ast_type == AST_LITERAL);
        int L_is_lit = (L && L->ast_type == AST_LITERAL);

        /* Shape 1: char op literal (commutative for ==/!=, only RHS
           literal for ordered). */
        if (k == OP_EQ || k == OP_NE) {
            SYMBOL *sym = NULL;
            int v = 0;
            if (L_is_char && R_is_lit) {
                sym = Lbare->sym; v = (int)(int64_t)R->zval;
            } else if (R_is_char && L_is_lit) {
                sym = Rbare->sym; v = (int)(int64_t)L->zval;
            }
            if (sym) {
                gen_load_byte_cmp_const(sym, v);
                int branch_on_z = (k == OP_EQ) ? jump_on_true : !jump_on_true;
                opjump(branch_on_z ? "z," : "nz,", target_label, 0);
                return;
            }
        }
        if ((k == OP_LT || k == OP_GE) && L_is_char && R_is_lit) {
            SYMBOL *sym = Lbare->sym;
            int v = (int)(int64_t)R->zval;
            if (sym->ctype->isunsigned) {
                gen_load_byte_cmp_const(sym, v & 0xff);
            } else {
                gen_load_byte_signed_cmp_const(sym, v);
            }
            /* After cp: C=1 iff sym < value. */
            if (k == OP_LT) opjump(jump_on_true ? "c," : "nc,", target_label, 0);
            else            opjump(jump_on_true ? "nc," : "c,", target_label, 0);
            return;
        }

        /* Shape 3: bare char vs bare char (commutative for ==/!=). */
        if ((k == OP_EQ || k == OP_NE) && L_is_char && R_is_char) {
            gen_byte_cmp_byte(Lbare->sym, Rbare->sym);
            int branch_on_z = (k == OP_EQ) ? jump_on_true : !jump_on_true;
            opjump(branch_on_z ? "z," : "nz,", target_label, 0);
            return;
        }

        /* Shape 3b: bare char `<` / `>=` bare char. Both operands
           must share signedness — mixed signedness gets integer-
           promoted under C's usual conversions and the bare-byte
           ordering wouldn't capture the right semantics. */
        if ((k == OP_LT || k == OP_GE) && L_is_char && R_is_char
            && (Lbare->sym->ctype->isunsigned
                == Rbare->sym->ctype->isunsigned)) {
            int u = Lbare->sym->ctype->isunsigned;
            gen_byte_ord_cmp_byte(Lbare->sym, Rbare->sym, u);
            /* After cp b: carry = (lhs < rhs). */
            if (k == OP_LT) opjump(jump_on_true ? "c," : "nc,", target_label, 0);
            else            opjump(jump_on_true ? "nc," : "c,", target_label, 0);
            return;
        }
        /* z88dk's comparison helpers (16-bit `l_eq`/inline `sbc hl,de`
           + scf/jr/ccf path, plus `l_long_eq` / `l_i64_eq` / `deq` /
           `cm48_sccz80p_deq` etc.) all share a single convention:
           **carry is set when the comparison is true**. The wider
           helpers additionally return HL=0/1, which is what
           `set_int(lval)` records — but the flag is set whether or
           not the helper also materialised an int.

           In cond context we branch on carry directly, skipping the
           extra `or h; or l; jp z/nz` test that the HL=0/1 path
           would emit. Works for every width because the convention
           is uniform.

           Additionally, the inline compare paths in codegen.c
           short-circuit their `scf; jr [z|nz],+3; ccf` materialise
           tail when handed a target label via the LVALUE: they emit
           the `jp z/nz,target` directly. We pass the label and
           desired polarity through cg2_compare_emit; if the helper
           branched (out.jp_done), we're done. Library-call paths
           (l_eq / l_long_eq / l_i64_eq / feq) leave jp_done unset
           and the carry-branch below fires. */
        LVALUE out;
        cg2_compare_emit(node, &out, target_label, !jump_on_true);
        if (out.jp_done) return;
        opjump(jump_on_true ? "c," : "nc,", target_label, 0);
        return;
    }
    if (k == OP_LNEG) {
        /* `!x` in cond context: emit x with the polarity flipped. */
        cg2_walk_cond(node->operand, target_label, !jump_on_true);
        return;
    }
    if (k == OP_OROR) {
        if (jump_on_true) {
            /* `(l || r)` → jump-to-target on true. If either operand
               is true, branch. Last operand inherits the target. */
            cg2_walk_cond(node->left,  target_label, 1);
            cg2_walk_cond(node->right, target_label, 1);
        } else {
            /* `(l || r)` → jump-to-target on false. False iff both
               are false; if left is true, skip past target. */
            int skip = getlabel();
            cg2_walk_cond(node->left,  skip,         1);
            cg2_walk_cond(node->right, target_label, 0);
            postlabel(skip);
        }
        return;
    }
    if (k == OP_ANDAND) {
        if (jump_on_true) {
            /* True iff both are true; if left is false, skip past
               target. */
            int skip = getlabel();
            cg2_walk_cond(node->left,  skip,         0);
            cg2_walk_cond(node->right, target_label, 1);
            postlabel(skip);
        } else {
            /* `(l && r)` → jump-to-target on false. False iff either
               is false; either failure branches. */
            cg2_walk_cond(node->left,  target_label, 0);
            cg2_walk_cond(node->right, target_label, 0);
        }
        return;
    }
    /* Bare-char truthiness fastpath: for `if (c)` / `while (c)` /
       ternary cond where `c` is a 1-byte local or global, load the
       byte directly into A and test (`ld a,(...); and a; jp z/nz`)
       instead of widening to 16-bit and testing both halves. Saves
       ~5 bytes per site (skips `l_gchar` / `ld h,0` widen + the
       `ld a,h; or l` truthiness test). The parser wraps the bare
       LV/GV reference in OP_DEREF to fetch the rvalue, so we peel
       that off when looking for the underlying char access. */
    {
        Node *bare = node;
        if (k == OP_DEREF && bare->operand) bare = bare->operand;
        int bk = bare->ast_type;
        if ((bk == AST_LOCAL_VAR || bk == AST_GLOBAL_VAR)
            && bare->sym && bare->sym->ctype
            && bare->sym->ctype->kind == KIND_CHAR
            && !bare->sym->ctype->ptr  /* not char* */
            && (bare->sym->storage == STKLOC
                || bare->sym->storage == STATIK
                || bare->sym->storage == EXTERNAL)) {
            gen_load_byte_test(bare->sym);
            opjump(jump_on_true ? "nz," : "z,", target_label, 0);
            return;
        }
    }

    /* Fallback: walk as a value, test truthiness, branch. Matches
       the pre-existing testjump path. */
    LVALUE lval;
    cg2_build_lvalue(node, &lval);
    cg2_walk(node);
    cg2_truthiness_test(lval.val_type);
    opjump(jump_on_true ? "nz," : "z,", target_label, 0);
}

/* Walk `node` as a boolean condition and emit `ret cc` instead of a
   conditional jump. Used by the AST_IF peephole when the then-arm is
   `return;` (no retval, no else) and the function has a bare-ret
   epilogue — saves the jp+ret+label trio.

   Simple shape only: single comparison or truthiness test plus
   OP_LNEG. Skips OR/AND chains (they'd need intermediate labels for
   the short-circuit; falling back to cg2_walk_cond is cleaner). */
static void cg2_walk_cond_to_ret(Node *node, int ret_if_true)
{
    if (!node) return;
    int k = node->ast_type;
    if (k == OP_LNEG) {
        cg2_walk_cond_to_ret(node->operand, !ret_if_true);
        return;
    }
    if (k == OP_EQ || k == OP_NE || k == OP_LT || k == OP_LE
     || k == OP_GT || k == OP_GE) {
        LVALUE out;
        /* jp_label = -1 sentinel routes emit_jpz_if_target to
           `ret z/nz`. Library-call paths (l_long_eq / l_i64_eq /
           feq etc.) leave jp_done unset; we then emit `ret c/nc`
           on the carry the helper set. */
        cg2_compare_emit(node, &out, -1, !ret_if_true);
        if (out.jp_done) return;
        gen_ret_cc(ret_if_true ? "c" : "nc");
        return;
    }
    /* Fallback: walk, truthiness test, ret cc. */
    LVALUE lval;
    cg2_build_lvalue(node, &lval);
    cg2_walk(node);
    cg2_truthiness_test(lval.val_type);
    gen_ret_cc(ret_if_true ? "nz" : "z");
}

/* Store HL (or DEHL for long, or FA for 6/8-byte double) into a
   local's slot, preserving the value in the primary register so a
   step expression can return it.

   For the int / char path the legacy `cg2_store_local_int` clobbers
   HL (it uses HL to hold the slot address). Here we push the value,
   compute the address, then either `l_pint` (preserves HL) for
   int / short / ptr, or `ld a,l; ld (de),a` for char.

   For long and 4-byte-double / accum32, `cg2_store_local_long`
   round-trips DEHL through the stack so it preserves the value
   naturally.

   For 6/8-byte doubles the value lives in FA; `dstore` (the FP
   store helper for fp_48bit / fp_64bit) preserves FA, so just
   computing the address into HL and calling `dstore` is enough. */
static void cg2_store_local_keep(SYMBOL *sym, Kind kind)
{
    gen_store_local_keep(sym->offset.i, kind);
}

/* Pre/post-increment/decrement on a bare LV/GV scalar.

   Pattern: load → step → store-keep → (for post) un-step.

   `inc()` / `dec()` from codegen.c dispatch on `lval->val_type`:
   `inc hl` for int / char / ptr-without-element-scaling,
   `l_inclong` / `l_declong` for long. For pointer arithmetic with
   element size > 1 we use `zadd_const(±size)` instead — same as
   what `nstep` does parser-side.

   The wrapping `(deref ...)` that the parser emits around the step
   expression (rvalue() habit) is handled by the OP_DEREF case
   below: when its operand is a step op, the dereference is a
   no-op — the step already left the value in the primary. */
static void cg2_step(Node *node)
{
    Node *op = node->operand;
    int kind = node->ast_type;
    int is_inc = (kind == OP_PRE_INC || kind == OP_POST_INC);
    int is_post = (kind == OP_POST_INC || kind == OP_POST_DEC);
    if (!op) return;

    /* ---- Bare LV/GV fastpath ---- */
    if ((op->ast_type == AST_LOCAL_VAR || op->ast_type == AST_GLOBAL_VAR)
        && op->sym) {
        SYMBOL *sym = op->sym;
        Kind sk = sym->ctype ? sym->ctype->kind : KIND_INT;

        /* For pointers with element size > 1, step by element size. */
        int step_amount = 1;
        int use_const_add = 0;
        if (sk == KIND_PTR && sym->ctype && sym->ctype->ptr) {
            int es = sym->ctype->ptr->size;
            if (es > 1) {
                step_amount = es;
                use_const_add = 1;
            }
        }

        LVALUE lv;
        cg2_build_lvalue(op, &lv);

        /* In-place memory-mode step fastpath for 16-bit slots stepping
           by exactly 1. Replaces the load (l_gintsp) / inc hl / store
           (l_pint) sequence (~3 helper calls, ~150 cycles) with an
           inline carry-aware byte-by-byte inc/dec on the slot itself
           (~42 cycles), then loads the new value into HL via the same
           pointer. Common case for loop induction vars, *p++ pointer
           walks, mdContext->in[mdi++] = … etc. Gated on:
             - no const_add (step_amount == 1)
             - 16-bit slot (INT / SHORT / PTR)
             - non-FARACC global; not a PORT
             - non-volatile (would need r/w through the slot's
               canonical address, not a register intermediate). */
        int inplace_ok = !use_const_add
            && (sk == KIND_INT || sk == KIND_SHORT || sk == KIND_PTR)
            && sym->ctype && !sym->ctype->isvolatile
            && !(sym->ctype->flags & FARACC)
            && sym->type != KIND_PORT8 && sym->type != KIND_PORT16
            && !IS_808x()    /* `jr nz` is Z80-only — 8080/8085 fall
                                back to the load+inc+store path. */
            && !can_access_local_native(
                op->ast_type == AST_LOCAL_VAR ? sym->offset.i : 0, sk);
        /* can_access_local_native gating: Rabbit / KC160 / FRAMEPTR
           have direct (sp+d)/(ix+d)/(fp+d) loads and the load+inc+store
           triple already collapses to ~6 instructions there — the
           in-place 8-instruction sequence is a net loss on those CPUs.
           For plain z80 it's a clear win. */
        if (inplace_ok) {
            if (op->ast_type == AST_LOCAL_VAR)
                gen_step_local_inplace_16(sym->offset.i, is_inc);
            else
                gen_step_static_inplace_16(sym, is_inc);
            /* HL = NEW value. Post-step: un-step HL → OLD value. */
            if (is_post) {
                if (is_inc) ol("dec\thl");
                else        ol("inc\thl");
            }
            return;
        }

        if (op->ast_type == AST_LOCAL_VAR) cg2_load_local_scalar(sym);
        else                                gen_load_static(sym);

        if (use_const_add)   zadd_const(&lv, is_inc ? step_amount : -step_amount);
        else if (is_inc)     inc(&lv);
        else                 dec(&lv);

        if (op->ast_type == AST_LOCAL_VAR) cg2_store_local_keep(sym, sk);
        else                                gen_store_static(sym);

        if (is_post) {
            if (use_const_add) zadd_const(&lv, is_inc ? -step_amount : step_amount);
            else if (is_inc)   dec(&lv);
            else               inc(&lv);
        }
        return;
    }

    /* ---- #O1c step-on-global-element fastpath: `++GVARS[2]` and
       friends. Operand is `OP_ADD(AST_GLOBAL_VAR-array-or-struct,
       AST_LITERAL)` (either order). Use direct (sym+off) load /
       store — same shape as the bare-GV fastpath above. Mirrors the
       legacy parser-side `ld hl,(sym+off); inc hl; ld (sym+off),hl`
       sequence, skipping the push-addr / l_gint / pop / l_pint
       sandwich the general indirect path would otherwise produce. */
    if (op->ast_type == OP_ADD && op->left && op->right) {
        Node *base = NULL, *off_node = NULL;
        if (op->right->ast_type == AST_LITERAL
            && op->left->ast_type == AST_GLOBAL_VAR
            && op->left->sym && op->left->sym->ctype
            && (op->left->sym->ctype->kind == KIND_ARRAY
                || op->left->sym->ctype->kind == KIND_STRUCT)) {
            base = op->left; off_node = op->right;
        } else if (op->left->ast_type == AST_LITERAL
            && op->right->ast_type == AST_GLOBAL_VAR
            && op->right->sym && op->right->sym->ctype
            && (op->right->sym->ctype->kind == KIND_ARRAY
                || op->right->sym->ctype->kind == KIND_STRUCT)) {
            base = op->right; off_node = op->left;
        }
        if (base && off_node) {
            Kind sk = node->type ? node->type->kind : KIND_INT;
            /* Match the bail conditions of gen_load/store_static_offset.
               Bitfields excluded — pre/post-step on a bitfield needs
               bitfield-aware RMW which this path doesn't provide. */
            if (!(base->sym->ctype->flags & FARACC)
                && sk != KIND_LONGLONG
                && sk != KIND_CPTR
                && !(sk == KIND_DOUBLE && c_fp_size > 4)
                && (!node->type || node->type->bit_size == 0)) {
                int byte_off = (int)off_node->zval;
                LVALUE lv;
                memset(&lv, 0, sizeof(lv));
                lv.ltype = node->type;
                lv.val_type = sk;
                if (gen_load_static_offset(base->sym, byte_off, sk)) {
                    if (is_inc) inc(&lv);
                    else        dec(&lv);
                    if (!gen_store_static_offset(base->sym, byte_off, sk)) {
                        /* Shouldn't happen — same bail conditions
                           checked above. Fall through is fine: we've
                           already loaded+stepped, but losing the
                           store would be wrong; emit a defensive
                           indirect store and fall through to the
                           un-step. */
                    }
                    if (is_post) {
                        if (is_inc) dec(&lv);
                        else        inc(&lv);
                    }
                    return;
                }
            }
        }
    }

    /* ---- General path: operand is an address-producing expression
       (struct member access, `*p`, `arr[i]`, etc.). Walk it to get
       the address in HL, save it, deref to load the value, step,
       store the new value back through the saved address, optionally
       un-step.

       Storage type comes from `node->type` — the parser's primary.c
       prestep / poststep wraps the step node *and* implicitly leaves
       lval->ltype on the parent OP_DEREF, which `normalize_types`
       propagates back through the step node so we read the right
       width. */
    Type *t = node->type ? node->type : type_int;
    Kind tk = t->kind;

    LVALUE lv;
    cg2_build_lvalue(node, &lv);

    /* 1. Address into HL. */
    cg2_walk(op);
    /* 2. Save the address on the stack — the load through it
          clobbers HL (and DEHL for long, FA for big-DOUBLE), and
          we'll need it back for the store. */
    zpush();

    /* 3. Load via HL. */
    LVALUE load_lv;
    memset(&load_lv, 0, sizeof(load_lv));
    load_lv.ltype = t;
    load_lv.indirect_kind = tk;
    load_lv.val_type = tk;
    gen_load_indirect(&load_lv);

    /* 4. Step the value. inc()/dec() dispatch on lv.val_type for
       all kinds (long, longlong, decimal). */
    if (is_inc) inc(&lv);
    else        dec(&lv);

    /* 5+6. Pop address, store via a memory primitive that preserves
       the value register so steps 7+ can still see the stepped value
       — gen_store_tos handles every kind via the right l_pint /
       l_plong / l_i64_store / dstore / inline char path. */
    gen_store_tos(tk);

    /* 7. Post-step: un-step so the result is the OLD value. */
    if (is_post) {
        if (is_inc) dec(&lv);
        else        inc(&lv);
    }
}

/* Compound assignments: `x += rhs`, `x -= rhs`, etc.

   AST shape: `(OP_AADD (deref X) RHS)` where X is the address
   expression for the lvalue. The outer OP_DEREF on the LHS
   represents the load needed to fetch the current value — same
   loading mechanism the walker would use for a plain read of X.

   Strategy:
     1. Synthesize a binop node `(OP_ADD (deref X) RHS)` and walk
        it. cg2_binop will load the current value, evaluate RHS,
        and combine — leaving the new value in the primary.
     2. Store the new value back at X. For bare LV/GV the
        kind-aware store helpers preserve the primary so the
        assignment expression's value is the new value (matching C
        semantics: `(x += 3)` evaluates to the new x).

   General LHS (member access, *p, arr[i]) is NOT yet supported —
   would need to evaluate the address once, save it, load, op,
   store back, leaving the new value as the result. */
static int compound_to_binop(int aop)
{
    switch (aop) {
    case OP_AADD:  return OP_ADD;
    case OP_ASUB:  return OP_SUB;
    case OP_AMULT: return OP_MULT;
    case OP_ADIV:  return OP_DIV;
    case OP_AMOD:  return OP_MOD;
    case OP_AAND:  return OP_AND;
    case OP_AOR:   return OP_OR;
    case OP_AXOR:  return OP_XOR;
    case OP_ASSHL: return OP_SSHL;
    case OP_ASSHR: return OP_SSHR;
    default:       return OP_ADD;
    }
}

/* #264: emit `byte_expr → A` for the byte-into-int-half compound
   fastpath. Returns 1 iff emit succeeded and A holds the byte; 0
   if the shape isn't on the supported list (caller falls back to
   the general save-addr path).

   Supported byte producers (after stripping any int-class cast):
     - bare char/uchar local                       → ld a,(N+sp)
     - bare char/uchar global                      → ld a,(sym)
     - *bare-char-ptr-local                        → ld a,(bc) via BC
     - *(bare-char-ptr-local++)  (post-inc only)   → ld a,(bc); in-place inc
   Post-dec / pre-step / global char-ptr base are out of scope for
   v1 — fall back to the general path for those. */
static int cg2_emit_byte_producer_to_a(Node *e)
{
    if (!e) return 0;

    /* Strip int-class casts. (int)c, (unsigned int)c, etc. all leave
       the same byte payload to load. */
    while (e && e->ast_type == OP_CAST && e->operand && e->type) {
        Kind tk = e->type->kind;
        if (tk != KIND_INT && tk != KIND_SHORT && tk != KIND_PTR
            && tk != KIND_CHAR) return 0;
        e = e->operand;
    }
    if (!e || !e->type) return 0;
    if (e->type->kind != KIND_CHAR) return 0;
    if (e->type->flags & FARACC) return 0;

    /* Bare char local. */
    if (e->ast_type == AST_LOCAL_VAR && e->sym
        && e->sym->storage == STKLOC
        && e->sym->ctype && !e->sym->ctype->isvolatile) {
        gen_local_addr(e->sym->offset.i);
        ol("ld\ta,(hl)");
        return 1;
    }

    /* Bare char global (non-FAR, non-volatile, non-PORT). */
    if (e->ast_type == AST_GLOBAL_VAR && e->sym && e->sym->ctype
        && !(e->sym->ctype->flags & FARACC)
        && !e->sym->ctype->isvolatile
        && e->sym->type != KIND_PORT8 && e->sym->type != KIND_PORT16) {
        outfmt("\tld\ta,(_%s)\n", e->sym->name);
        return 1;
    }

    /* *bare-char-ptr-local, optionally with post-inc.
       The AST shape for `*p` where p is a local is nested OP_DEREFs:
       OP_DEREF(OP_DEREF(AST_LOCAL_VAR(p))). The inner OP_DEREF reads
       the pointer value from p's frame slot; the outer OP_DEREF reads
       the byte at that pointer. For `*p++` the post-inc sits between
       the two: OP_DEREF(OP_POST_INC(OP_DEREF(AST_LOCAL_VAR(p)))). */
    if (e->ast_type == OP_DEREF && e->operand) {
        Node *ptr = e->operand;
        int post_inc = 0;
        /* Unwrap the inner OP_DEREF that reads the pointer value
           from its frame slot. */
        if (ptr->ast_type == OP_DEREF && ptr->operand) {
            ptr = ptr->operand;
        }
        if (ptr && ptr->ast_type == OP_POST_INC) {
            post_inc = 1;
            ptr = ptr->operand;
            /* The post-inc's lvalue operand may also be wrapped in
               an OP_DEREF (lvalue-form of the bare local). */
            if (ptr && ptr->ast_type == OP_DEREF && ptr->operand) {
                ptr = ptr->operand;
            }
        }
        if (ptr && ptr->ast_type == AST_LOCAL_VAR && ptr->sym
            && ptr->sym->storage == STKLOC
            && ptr->sym->ctype && ptr->sym->ctype->kind == KIND_PTR
            && ptr->sym->ctype->ptr && ptr->sym->ctype->ptr->size == 1
            && !ptr->sym->ctype->isvolatile
            && !(ptr->sym->ctype->flags & FARACC)
            && !IS_808x()) {
            /* HL = &ptr_lo; BC = ptr value; A = *ptr; optional post-inc
               of the in-memory pointer using `inc (hl)` byte-by-byte
               with carry propagation via jr nz. The `jr nz` skip is
               z80-only — 8080/8085 gated out above. */
            gen_local_addr(ptr->sym->offset.i);
            ol("ld\tc,(hl)");
            ol("inc\thl");
            ol("ld\tb,(hl)");          /* BC = ptr */
            ol("ld\ta,(bc)");          /* A = *ptr */
            if (post_inc) {
                /* HL is at &ptr_hi after the inc above. Step down,
                   then inc low, then move HL back to &ptr_hi BEFORE
                   the jr — `inc hl` doesn't touch flags so Z from
                   the byte inc carries through. The jr_nz skips a
                   single 1-byte `inc (hl)` (matches the existing
                   gen_step_local_inplace_16 idiom in codegen.c). */
                ol("dec\thl");          /* HL = &ptr_lo */
                ol("inc\t(hl)");        /* ptr_lo++; Z = wrapped */
                ol("inc\thl");          /* HL = &ptr_hi (Z unchanged) */
                ol("jr\tnz,ASMPC+3");   /* skip the byte-1 inc (hl) below */
                ol("inc\t(hl)");        /* ptr_hi++ on overflow */
            }
            return 1;
        }
    }
    return 0;
}

/* #264: byte-op-into-int-half compound assign. Recognise
       `int_local op= ((cast int)byte_expr) <K`  where K in {0, 8}
   and op in {^=, |=, &=}, and emit:
     A = byte_expr             (one of the producers above)
     HL = &lhs_half_in_question
     <op> a,(hl)               -- 7t single-byte RMW
     ld (hl),a
     [for AND] zero the unchanged half (because byte<<8 has lo=0
              and byte<<0 has hi=0, so AND with it forces the other
              half to 0)
     [if value-needed] reconstruct HL = new int value.
   Saves ~200t per fire vs the general save-addr + l_xor + l_pint
   shape. Returns 1 if matched + emitted, 0 if caller should fall
   through. */
static int cg2_try_byte_into_int_half(Node *node, Node *L, Node *R,
                                       int binop_kind, Kind k)
{
    /* Op must be bitwise. */
    if (binop_kind != OP_XOR && binop_kind != OP_OR && binop_kind != OP_AND)
        return 0;
    /* LHS must be a bare 2-byte local or global int/short/ptr. */
    if (!(k == KIND_INT || k == KIND_SHORT || k == KIND_PTR))
        return 0;
    if (L->ast_type != OP_DEREF || !L->operand) return 0;
    Node *lhs = L->operand;
    if (lhs->ast_type != AST_LOCAL_VAR && lhs->ast_type != AST_GLOBAL_VAR)
        return 0;
    if (!lhs->sym || !lhs->sym->ctype) return 0;
    if (lhs->sym->ctype->isvolatile) return 0;
    if (lhs->sym->ctype->flags & FARACC) return 0;
    if (lhs->sym->type == KIND_PORT8 || lhs->sym->type == KIND_PORT16) return 0;
    if (lhs->ast_type == AST_LOCAL_VAR && lhs->sym->storage != STKLOC) return 0;

    /* RHS: optional OP_SSHL/USHL with literal-8 to target high half. */
    Node *r = R;
    int shift8 = 0;
    if ((r->ast_type == OP_SSHL || r->ast_type == OP_USHL)
        && r->left && r->right
        && r->right->ast_type == AST_LITERAL
        && (int64_t)r->right->zval == 8) {
        shift8 = 1;
        r = r->left;
    }
    /* The (now-unshifted) RHS must be a byte producer (after cast strip).
       cg2_emit_byte_producer_to_a only emits on success — if it returns
       0 it has not touched Zsp or the asm output. */
    if (!cg2_emit_byte_producer_to_a(r)) return 0;

    /* A = byte. HL likely clobbered by the producer. Recompute &LHS_lo. */
    SYMBOL *sym = lhs->sym;
    if (sym->storage == STKLOC) gen_local_addr(sym->offset.i);
    else                         outfmt("\tld\thl,_%s\n", sym->name);

    /* For shift-8, target the high byte (HL+1). */
    if (shift8) ol("inc\thl");

    /* Single-byte RMW on the targeted half. */
    const char *op = (binop_kind == OP_XOR) ? "xor"
                   : (binop_kind == OP_OR)  ? "or"
                                            : "and";
    outfmt("\t%s\t(hl)\n", op);
    ol("ld\t(hl),a");

    /* AND zeros the unchanged half (because `byte<<8` has lo=0 and
       `byte<<0` has hi=0). OR/XOR leave the other half intact. */
    if (binop_kind == OP_AND) {
        if (shift8) ol("dec\thl");      /* → &lo */
        else        ol("inc\thl");      /* → &hi */
        ol("ld\t(hl),0");
    }

    /* If the compound assign's value is used (not stmt-context), the
       walker contract requires HL = new LHS value on return. For
       statement context (cg2_stmt_value_discarded), skip the
       reconstruct — saves 3 instructions / ~17t on the hot path.
       The discarded flag was captured by the cg2_walk dispatcher
       when this OP_AXOR/OR/AND was entered. */
    if (!cg2_stmt_value_discarded) {
        if (binop_kind == OP_AND) {
            /* The non-targeted half was just set to 0. */
            if (shift8) {
                /* HL = &lo (after the dec for the zero store).
                   A still has new hi. Want HL = (lo=0, hi=A). */
                ol("ld\th,a");
                ol("ld\tl,0");
            } else {
                /* HL = &hi. A has new lo. Want HL = (lo=A, hi=0). */
                ol("ld\th,0");
                ol("ld\tl,a");
            }
        } else {
            /* OR/XOR: targeted half = A, other half unchanged in memory.
               Load the unchanged half through C (a temp), so we don't
               clobber HL's high byte before assembling the result. */
            if (shift8) {
                /* HL = &hi. A = new hi. Read original lo from HL-1. */
                ol("dec\thl");         /* HL = &lo */
                ol("ld\tc,(hl)");      /* C = original lo */
                ol("ld\tl,c");         /* L = original lo */
                ol("ld\th,a");         /* H = new hi */
            } else {
                /* HL = &lo. A = new lo. Read original hi from HL+1. */
                ol("inc\thl");         /* HL = &hi */
                ol("ld\tc,(hl)");      /* C = original hi */
                ol("ld\th,c");         /* H = original hi */
                ol("ld\tl,a");         /* L = new lo */
            }
        }
    }

    return 1;
}

static void cg2_compound_assign(Node *node)
{
    Node *L = node->left;
    Node *R = node->right;
    if (!L || !R) return;
    if (L->ast_type != OP_DEREF || !L->operand) {
        errorfmt("ast-codegen2: compound assign LHS not in expected (deref X) shape", 1);
        return;
    }
    Node *addr = L->operand;
    int binop_kind = compound_to_binop(node->ast_type);
    Type *t = node->type ? node->type : L->type;
    Kind k = t ? t->kind : KIND_INT;

    /* Compound-assign save-address fastpath (any scalar type, bare
       LV/GV LHS). Saves &addr on the stack ONCE, loads *addr into
       the primary register(s), applies the arith, then pops the
       saved address back out for the store. Mirrors legacy's
       compact sequence — avoids the post-arith address-recompute
       that `gen_store_local_keep` would otherwise emit.

       Two arith paths:
         CONST RHS + integral kind: `*_const` helpers (zadd_const,
           zand_const, …) in codegen.c. Stack-neutral.
         OTHERWISE: save primary via lpush/llpush/zpush/
           gen_push_float, walk R, then call the standard binop
           helper (zadd/zand/…) — these pop the saved primary off
           the stack and leave the new value in the primary. Stack-
           neutral overall, so the saved &addr at TOS underneath
           survives.

       Both paths finish by calling `gen_store_tos(k)` which pops
       the address into the right register (BC for long-class /
       longlong; DE for int / char; HL for 6/8-byte FP) and emits
       the kind-dispatched store via `l_pint` / `l_plong` /
       `l_i64_store` / `dstore` / inline char store.

       Excludes:
         - KIND_STRUCT / KIND_ARRAY — aggregate compound assign is
           nonsensical / lowered elsewhere.
         - Bitfields (`t->bit_size != 0`) — RMW needs a different
           shape; falls back to the synthesized-binop path.
         - Far-access (`FARACC`) — gen_address emits a runtime call
           that clobbers DE / pushes; lp_* store helpers want a
           different setup. */
    /* #264: byte-op-into-int-half compound assign fastpath. Tried
       before the existing char fastpath (#218c) because it handles a
       SUPERSET of bitwise shapes when the LHS is an int and the RHS
       is a byte producer shifted by 0 or 8. CRC-16's hot statement
       (`crc ^= ((unsigned int)*data++) << 8`) matches here. */
    if (cg2_try_byte_into_int_half(node, L, R, binop_kind, k))
        return;

    /* #218c: char bitwise compound with literal RHS. `c &= N`,
       `c |= N`, `c ^= N` with bare char LV/GV LHS used to widen
       via gen_load_indirect (`ld hl,sym; ld l,(hl); ld h,0`) then
       run zand_const / zor_const / zxor_const at int width
       (which fall back to byte-mask emit but with extra `ld a,l;
       <op> N; ld l,a` round-trips), then narrow back via
       gen_store_tos. Direct byte path: `ld a,(sym); <op> N;
       ld (sym),a` — 3 instructions, 8 bytes vs current 14. Bare
       LV/GV only; non-FAR; non-bitfield. */
    if (L->ast_type == OP_DEREF && L->operand
        && (L->operand->ast_type == AST_LOCAL_VAR
            || L->operand->ast_type == AST_GLOBAL_VAR)
        && L->operand->sym
        && L->operand->sym->ctype
        && L->operand->sym->ctype->kind == KIND_CHAR
        && !L->operand->sym->ctype->ptr
        && !(L->operand->sym->ctype->flags & FARACC)
        && !(t && t->bit_size != 0)
        && R->ast_type == AST_LITERAL
        && (binop_kind == OP_AND || binop_kind == OP_OR
            || binop_kind == OP_XOR)) {
        SYMBOL *sym = L->operand->sym;
        int v = ((int)(int64_t)R->zval) & 0xff;
        gen_load_byte(sym);
        const char *op = (binop_kind == OP_AND) ? "and"
                       : (binop_kind == OP_OR)  ? "or"
                                                : "xor";
        outfmt("\t%s\t%d\n", op, v);
        if (sym->storage == STKLOC) gen_store_local_byte_in_a(sym->offset.i);
        else                         gen_store_static_byte_in_a(sym);
        return;
    }

    int scalar = (k != KIND_STRUCT && k != KIND_ARRAY && k != KIND_VOID);
    int integral = (k == KIND_CHAR || k == KIND_INT || k == KIND_SHORT
                 || k == KIND_PTR  || k == KIND_LONG || k == KIND_CPTR
                 || k == KIND_LONGLONG);
    int bitfield = t && t->bit_size != 0;
    /* FARACC: a bare LV/GV LHS carries the flag on its sym's ctype;
       a complex LHS (OP_DEREF of an arbitrary address expression)
       carries it on L->type (the pointed-to type) when the pointer
       is __far. KIND_CPTR is the 32-bit far-pointer representation
       and needs the lp_* runtime helpers too. Both cases stay in
       the fallback until far + complex LHS is wired in separately. */
    int far_access = (addr->sym && addr->sym->ctype
                       && (addr->sym->ctype->flags & FARACC))
                  || (L->type && (L->type->flags & FARACC))
                  || k == KIND_CPTR;
    /* Globals get a separate, more compact treatment via
       gen_load_static / gen_store_static (which can use direct
       memory addressing `ld (_name),hl` / `ld (_name+2),de`
       instead of the BC-load + l_plong shape). Restrict the bare-
       local fastpath to STKLOC where the address recompute in
       `gen_store_local_keep` is the real cost. */
    int bare_local_lhs = addr->sym
                      && addr->ast_type == AST_LOCAL_VAR
                      && addr->sym->storage == STKLOC;
    /* Complex LHS: anything that isn't a bare LV or GV. Examples:
       `*p += rhs` (addr is the pointer var), `arr[i] += rhs` (addr
       is OP_ADD(arr, i*sizeof)), `s->m += rhs` (addr is OP_ADD on
       a struct base). For these, the address-load step walks the
       address expression once into HL — side-effects in addr (e.g.
       `arr[g_idx++]`) fire exactly once. The rest of the save-
       address dance (push addr, gen_load_indirect, arith, gen_
       store_tos) is shape-agnostic and works unchanged. */
    int complex_lhs = !bare_local_lhs && addr->ast_type != AST_GLOBAL_VAR;
    /* If the CPU has a single-instruction sp-relative load/store
       for this kind+offset (Rabbit `ld hl,(sp+N)`, KC160 `ld hl,
       (sp+d)` / paired long), the fallback synthesized-binop path
       (which routes through gen_load_local + gen_store_local_keep)
       will already produce optimal native code. The save-address
       pattern would otherwise emit `l_gint`/`l_pint` runtime calls
       which beat the address-recompute on plain z80 but lose to
       the native instructions. Skip the fastpath in that case;
       longlong / 6+8-byte FP have no sp+d variant so save-addr
       still wins. Only applies to bare locals — complex LHS has
       no sp-relative equivalent. */
    int sp_native = bare_local_lhs
                 && can_access_local_native(addr->sym->offset.i, k);
    int const_rhs = (R->ast_type == AST_LITERAL);
    /* Bitfields share the save-address fastpath shape — gen_load_indirect
       already handles bitfield reads via lval->ltype->bit_size, and the
       store step swaps gen_store_tos for gen_bitfield_store (same
       contract: HL = value, address on TOS). The const-RHS *_const
       primitives don't know about bit_size, so bitfields skip that arm
       and force the general save-LHS / walk-R / binop path. */
    int use_save_addr = scalar && !far_access
                     && (complex_lhs || (bare_local_lhs && !sp_native)
                         || bitfield);
    if (bitfield) const_rhs = 0;
    if (use_save_addr) {
        LVALUE lval;
        cg2_build_lvalue(L, &lval);

        /* 1. HL = address. Bare local → gen_local_addr (direct);
              complex LHS → walk the address expression (evaluates
              side-effects exactly once). */
        if (bare_local_lhs) gen_local_addr(addr->sym->offset.i);
        else                cg2_walk(addr);
        /* 2. Save &addr on stack. */
        zpush();
        /* 3. Load *addr → primary. gen_load_indirect handles every
           scalar kind via the existing dispatch (char with sign-/
           zero-extend, l_gint, l_glong, l_i64_load, dload). */
        gen_load_indirect(&lval);

        /* 4. Arith. */
        int is_long_op    = (k == KIND_LONG || k == KIND_CPTR);
        int is_long_class = (is_long_op || k == KIND_ACCUM32
                          || (k == KIND_DOUBLE && c_fp_size == 4));
        int is_longlong   = (k == KIND_LONGLONG);
        int is_decimal    = kind_is_decimal(k);
        int is_shift      = (binop_kind == OP_SSHL || binop_kind == OP_USHL
                          || binop_kind == OP_SSHR || binop_kind == OP_USHR);

        if (const_rhs && integral) {
            /* Fast const path — *_const helpers, no second walk. */
            int64_t v = (int64_t)R->zval;
            if (binop_kind == OP_SUB) v = -v;
            switch (binop_kind) {
            case OP_ADD:  zadd_const(&lval, v);  break;
            case OP_SUB:  zadd_const(&lval, v);  break;
            case OP_AND:  zand_const(&lval, v);  break;
            case OP_OR:   zor_const(&lval,  v);  break;
            case OP_XOR:  zxor_const(&lval, v);  break;
            case OP_MULT: mult_const(&lval, v);  break;
            case OP_DIV:  zdiv_const(&lval, v);  break;
            case OP_MOD:  zmod_const(&lval, v);  break;
            case OP_SSHL: case OP_USHL: asl_const(&lval, v); break;
            case OP_SSHR: case OP_USHR: asr_const(&lval, v); break;
            default: goto fallback;
            }
        } else {
            /* General path: save LHS primary, evaluate R, call binop
               helper which consumes the saved LHS from the stack. */
            if (is_longlong)               llpush();
            else if (is_decimal)           gen_push_float(k);
            else if (is_long_class)        lpush();
            else                            zpush();
            if (is_longlong && !is_shift)   cg2_walk_to_llong(R);
            else if (is_longlong)           cg2_walk(R); /* shift count */
            else if (is_decimal)            cg2_walk_to_decimal(R, k);
            else if (is_long_op && !is_shift) cg2_walk_to_long(R);
            else                            cg2_walk(R);
            /* For int-class the binop helpers want LHS in DE, so pop
               it explicitly. Long-class / longlong / decimal helpers
               consume their LHS from the stack themselves. */
            if (!is_long_class && !is_decimal && !is_longlong) zpop();
            switch (binop_kind) {
            case OP_ADD:  zadd(&lval); break;
            case OP_SUB:  zsub(&lval); break;
            case OP_AND:  zand(&lval); break;
            case OP_OR:   zor(&lval);  break;
            case OP_XOR:  zxor(&lval); break;
            case OP_MULT: mult(&lval); break;
            case OP_DIV:  zdiv(&lval); break;
            case OP_MOD:  zmod(&lval); break;
            case OP_SSHL: case OP_USHL: asl(&lval); break;
            case OP_SSHR: case OP_USHR: asr(&lval); break;
            default: goto fallback;
            }
        }

        /* 5+6. Pop &addr + store. Bitfield: gen_bitfield_store does
           the RMW masking on the underlying byte/word. Otherwise:
           plain kind-dispatched store via gen_store_tos. */
        if (bitfield) gen_bitfield_store(t);
        else          gen_store_tos(k);
        return;
    }
fallback:;

    /* Synthesize the equivalent binop and walk it. The synthesized
       node lives on the stack — cg2_binop only reads its fields. */
    Node binop;
    memset(&binop, 0, sizeof(binop));
    binop.ast_type = binop_kind;
    binop.left  = L;
    binop.right = R;
    binop.type  = t;
    cg2_walk(&binop);
    /* New value now lives in HL (or DEHL for long). Store it back. */
    if (addr->ast_type == AST_LOCAL_VAR && addr->sym) {
        Kind sk = addr->sym->ctype ? addr->sym->ctype->kind : KIND_INT;
        cg2_store_local_keep(addr->sym, sk);
    } else if (addr->ast_type == AST_GLOBAL_VAR && addr->sym) {
        gen_store_static(addr->sym);   /* preserves HL/DEHL */
    } else {
        errorfmt("ast-codegen2: compound assign with complex LHS not yet supported", 1);
    }
}

/* Direct AST-driven call sequence. The legacy `callfunction` in
   callfunc.c is tightly bound to the parser (it parses args inline);
   we duplicate the convention logic here on already-evaluated args.
   Supported conventions: __smallc / __stdc, __z88dk_fastcall,
   __z88dk_callee, plus banked / shortcall / hl_call dispatch.

   Argument ordering:
     __smallc        push left-to-right
     __stdc          push right-to-left
   For fastcall, the LAST DECLARED argument is passed in HL — we
   evaluate it last (regardless of push order) so its value is in HL
   at the call point. The remaining args are pushed per the
   convention.

   Stack cleanup: caller-cleans for plain smallc/stdc; callee-cleans
   when __z88dk_callee is set. */
/* Inline emit for the recognised __builtin_* string/mem operations.
   Returns 1 if handled (caller should `return` immediately); 0 if the
   call should fall through to the regular emit path.

   Legacy callfunction did this via a two-step dance: (1) inspect
   args during the eval loop, set `builtin_flags = SMALLC|FASTCALL`
   and selectively close arg tmpfiles to skip pushing const args;
   (2) at emit time, dispatch on funcname and call gen_builtin_*.
   Here we do it directly: detect the name, check constness, and
   emit. The arg-push protocol matches what gen_builtin_* expects
   on entry (see codegen.c around line 5395). */
static int cg2_try_builtin_call(Node *node, SYMBOL *sym, int n_args)
{
    if (!sym || !sym->name[0]) return 0;
    if (c_disable_builtins) return 0;
    if (IS_808x()) return 0;
    const char *name = sym->name;

    if (strcmp(name, "__builtin_strcpy") == 0 && n_args == 2) {
        /* Walk dst → HL, push; walk src → HL; gen_builtin_strcpy
           reads HL=src, pops dst. */
        cg2_walk(array_get_byindex(node->args, 0));
        zpush();
        cg2_walk(array_get_byindex(node->args, 1));
        gen_builtin_strcpy();
        return 1;
    }
    if (strcmp(name, "__builtin_strchr") == 0 && n_args == 2) {
        Node *c_arg = array_get_byindex(node->args, 1);
        int c_const = (c_arg && c_arg->ast_type == AST_LITERAL
                       && c_arg->zval != 0);
        cg2_walk(array_get_byindex(node->args, 0));   /* buffer → HL */
        if (c_const) {
            gen_builtin_strchr((int32_t)c_arg->zval);
        } else {
            zpush();                                   /* buffer on stack */
            cg2_walk(c_arg);                            /* c → HL */
            gen_builtin_strchr(-1);
        }
        return 1;
    }
    if (strcmp(name, "__builtin_memset") == 0 && n_args == 3) {
        Node *size_arg = array_get_byindex(node->args, 2);
        if (!(size_arg && size_arg->ast_type == AST_LITERAL
              && size_arg->zval > 0)) return 0;
        Node *c_arg = array_get_byindex(node->args, 1);
        int c_const = (c_arg && c_arg->ast_type == AST_LITERAL);
        int32_t c_val = c_const ? (int32_t)c_arg->zval : -1;
        cg2_walk(array_get_byindex(node->args, 0));   /* dst → HL */
        if (!c_const) {
            zpush();                                   /* dst on stack */
            cg2_walk(c_arg);                            /* c → HL */
        }
        gen_builtin_memset(c_val, (int32_t)size_arg->zval);
        return 1;
    }
    if (strcmp(name, "__builtin_memcpy") == 0 && n_args == 3) {
        Node *n_arg = array_get_byindex(node->args, 2);
        if (!(n_arg && n_arg->ast_type == AST_LITERAL
              && n_arg->zval > 0)) return 0;
        Node *src_arg = array_get_byindex(node->args, 1);
        int src_const = (src_arg && src_arg->ast_type == AST_LITERAL);
        int32_t src_val = src_const ? (int32_t)src_arg->zval : -1;
        cg2_walk(array_get_byindex(node->args, 0));   /* dst → HL */
        if (!src_const) {
            zpush();                                   /* dst on stack */
            cg2_walk(src_arg);                          /* src → HL */
        }
        gen_builtin_memcpy(src_val, (int32_t)n_arg->zval);
        return 1;
    }
    return 0;
}

static void cg2_func_call(Node *node)
{
    int is_fnptr = (node->ast_type == AST_FUNCPTR_CALL);
    SYMBOL *sym = node->sym;
    /* Direct calls: fntype lives on sym->ctype.
       Function-pointer calls: callfunction() stashed the FUNC type
       (not a pointer) on node->type. */
    Type *fntype = is_fnptr ? node->type
                            : (sym && sym->ctype ? sym->ctype : NULL);
    int n_args = (int)array_len(node->args);

    /* Recognised inline builtins (memset/memcpy/strcpy/strchr) —
       short-circuit to gen_builtin_* before falling into the
       regular calling-convention path. */
    if (!is_fnptr && cg2_try_builtin_call(node, sym, n_args)) return;

    uint32_t flags = fntype ? fntype->flags : 0;
    int smallc   = (flags & SMALLC) != 0;
    int fastcall = (flags & FASTCALL) != 0;
    int callee   = (flags & CALLEE) != 0;
    int total_arg_bytes = 0;

    /* Walk args. With fastcall, the last declared arg goes in HL
       (no push) and is evaluated LAST so HL is correct at call time.
       Other args are pushed in convention order (smallc l-to-r;
       stdc r-to-l).

       For each arg, after walking, coerce the value to the declared
       prototype's kind via `force()`. This matches what legacy
       `callfunction` does (callfunc.c:300-310 / `ForceArgs`):
       e.g. `f((uint8_t)0.5*40)` → AST keeps the result as DOUBLE
       (const-fold preserves FP type) but the parameter is uint8_t,
       so convert FA double → HL int before the push. */
    array *params = fntype ? fntype->parameters : NULL;
    int n_params = params ? (int)array_len(params) : 0;

    /* Fastcall fnptr path: legacy keeps the fnptr address accessible
       through arg evaluation by repeatedly zpush'ing it before each
       arg and ex(sp),hl'ing it back after. The walker mirrors that:
       walk callee FIRST (HL = fnptr), then for each non-last arg
       zpush + walk + push_function_argument_fnptr (does ex(sp),hl
       which puts arg on stack and pulls fnptr back into HL).  For
       the last fastcall arg: zpush fnptr again, walk → HL = last
       arg, and let callstk's FASTCALL branch do the pop af / push
       bc / push af / ret dance. */
    int last_argument_size = 0;
    if (is_fnptr && fastcall) {
        cg2_walk(node->callee);   /* HL = fnptr */
        for (int i = 0; i < n_args; i++) {
            int idx = smallc ? i : (n_args - 1 - i);
            int is_last = (i == n_args - 1);
            Node *arg = array_get_byindex(node->args, idx);
            Kind argkind = arg && arg->type ? arg->type->kind : KIND_INT;
            Type *argtype = arg ? arg->type : type_int;
            zpush();        /* save fnptr; Zsp -= 2 */
            cg2_walk(arg);
            if (idx < n_params) {
                Type *proto = array_get_byindex(params, idx);
                if (proto && proto->kind != KIND_ELLIPSES
                    && proto->kind != argkind) {
                    force(proto->kind, argkind,
                          proto->isunsigned, argtype->isunsigned,
                          arg && arg->ast_type == AST_LITERAL ? 1 : 0);
                    argkind = proto->kind;
                    argtype = proto;
                }
            }
            int pushed = push_function_argument_fnptr(
                argkind, argtype, fntype, 0, is_last);
            if (is_last) {
                last_argument_size = pushed;
            } else {
                total_arg_bytes += pushed;
                /* push_function_argument_fnptr's int branch already
                   does ex(sp),hl which restored fnptr to HL — Zsp
                   bookkeeping is intact (sp unchanged by ex). The
                   net effect is "+2 bytes on stack, fnptr back in
                   HL", but `pushed = 2` accounts for the size. The
                   walker's own zpush above is what actually moved
                   sp; the helper's returned size matches. */
                Zsp -= 2;
                Zsp += 2;  /* no-op pair, documenting the net */
            }
        }
        /* callstk's FASTCALL branch: pops the fnptr (left on TOS by
           the last zpush), pushes return label + fnptr in pop-af
           order, rets to fnptr. The pushed-arg count tracks Zsp;
           callstk handles its own Zsp adjustments. */
        int ret = callstk(fntype, total_arg_bytes, 0, last_argument_size);
        total_arg_bytes += ret;
        goto post_call;
    }

    int n_to_push = fastcall ? (n_args - 1) : n_args;
    for (int i = 0; i < n_to_push; i++) {
        int idx = smallc ? i : (n_to_push - 1 - i);
        Node *arg = array_get_byindex(node->args, idx);
        Kind argkind = arg && arg->type ? arg->type->kind : KIND_INT;
        Type *argtype = arg ? arg->type : type_int;
        cg2_walk(arg);
        if (idx < n_params) {
            Type *proto = array_get_byindex(params, idx);
            if (proto && proto->kind != KIND_ELLIPSES
                && proto->kind != argkind) {
                force(proto->kind, argkind,
                      proto->isunsigned, argtype->isunsigned,
                      arg && arg->ast_type == AST_LITERAL ? 1 : 0);
                argkind = proto->kind;
                argtype = proto;
            }
        }
        int pushed = gen_push_function_argument(argkind, argtype, 0);
        total_arg_bytes += pushed;
    }
    if (fastcall && n_args > 0) {
        Node *last = array_get_byindex(node->args, n_args - 1);
        cg2_walk(last);
    }

    /* Emit the call. */
    if (is_fnptr) {
        /* Walk the callee expression — leaves the function address in
           HL — then `call l_jphl` (= `jp (hl)` thunk; the call pushes
           the return address before transferring control). */
        cg2_walk(node->callee);
        callrts("l_jphl");
    } else if (flags & SHORTCALL) {
        gen_shortcall(fntype, fntype->funcattrs.shortcall_rst,
                      fntype->funcattrs.shortcall_value);
    } else if (flags & HL_CALL) {
        gen_hl_call(fntype, fntype->funcattrs.hlcall_module,
                    fntype->funcattrs.hlcall_addr);
    } else if (flags & BANKED) {
        gen_bankedcall(sym, fntype);
    } else {
        /* SMALLC variadic callees expect the pushed-arg byte count in A
           (loadargc emits `ld a, bytes/2`). stdc and fastcall don't. */
        int va_arg_count = -1;
        if (fntype && fntype->funcattrs.hasva && smallc && !fastcall) {
            va_arg_count = total_arg_bytes;
        }
        gen_call(va_arg_count, sym ? sym->name : "(unknown)", sym);
    }

post_call:
    /* Stack cleanup. Callee-cleans skips the explicit modstk; the
       called function popped the args itself. Otherwise restore Zsp
       by total_arg_bytes via the legacy helper. */
    if (callee) {
        Zsp += total_arg_bytes;
    } else if (total_arg_bytes > 0) {
        Kind retkind = fntype && fntype->return_type
            ? fntype->return_type->kind : KIND_INT;
        Zsp = gen_restore_frame_after_call(total_arg_bytes, retkind, NO, YES);
    }
}

static void cg2_return(Node *node)
{
    if (node->retval) {
        cg2_walk(node->retval);
        Kind retkind = currfn && currfn->ctype && currfn->ctype->return_type
            ? currfn->ctype->return_type->kind
            : KIND_INT;
        gen_leave_function(retkind, NO, 0);
    } else {
        gen_leave_function(KIND_NONE, NO, 0);
    }
}
