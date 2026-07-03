/*
 *      sccz80 — AST integer-promotion / type-normalisation pass.
 *
 *  This file once held the AST-driven codegen walker; that is retired —
 *  function codegen now runs through the IR pipeline (ir_build → ir_lower).
 *  What remains is the type-normalisation helpers below.
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
