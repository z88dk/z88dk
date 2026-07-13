/*
 *      Small C+ Compiler
 *
 *      Plunging routines
 *
 *      $Id: plunge.c,v 1.12 2016-03-29 13:39:44 dom Exp $
 */

#include "ccdefs.h"
#include "tokeniser.h"
#include <limits.h>

/*
 * skim over text adjoining || and && operators
 */
int skim(TokenKind tk_op, int (*heir)(LVALUE* lval), LVALUE* lval)
{
    int droplab, hits, k;
    Node *left, *right;
    int is_or = (tk_op == TK_LOR);

    hits = 0;
    /* `first` = we have not yet captured an operand IN THIS skim. It must NOT be
       derived from the incoming lval->node: when skim() is invoked NESTED (an
       inner `&&` chain parsed as one operand of an outer `||`, via plnge1), the
       entry lval->node still holds the OUTER chain's operand. Testing `left !=
       NULL` then wrongly folds that outer operand into this chain — turning
       `A || (B && C)` into `A || ((A && B) && C)` (the isalpha idiom miscompile).
       Track the first operand explicitly instead. */
    int first = 1;
    while (1) {
        left = lval->node;
        k = plnge1(heir, lval);
        /* Phase L3c-8f: tk_match_kind_at_lptr advances lptr by the
           full 2-byte source span and consumes from the tokeniser
           — replaces the legacy `streq+inbyte+inbyte` triple. */
        if (tk_match_kind_at_lptr(tk_op)) {
            if (hits == 0) {
                hits = 1;
                droplab = getlabel();
            }
            /* Run dropout FIRST so its rvalue() wrap (when k==1) is
               applied to lval->node before we capture `right`. Then any
               ast_binop pairs a wrapped right with a wrapped left,
               matching what legacy emits. */
            dropout(k, is_or, droplab, lval);
            right = lval->node;
            if (!first) {
                /* Combine with the prior operand of THIS chain (carried in
                   lval->node from the previous iteration). The first operand
                   has no prior to chain with — just keep it. */
                lval->node = ast_binop(is_or ? OP_OROR : OP_ANDAND, left, right);
            }
            first = 0;
        } else if (hits) {
            dropout(k, is_or, droplab, lval);
            right = lval->node;
            lval->node = ast_binop(is_or ? OP_OROR : OP_ANDAND, left, right);
            lval->val_type = KIND_INT;
            lval->ltype = type_int;
            lval->indirect_kind = KIND_NONE;
            lval->ptr_type = lval->is_const = 0;
            lval->const_val = 0;
            return (0);
        } else
            return k;
    }
}


/*
 * test for early dropout from || or && evaluations
 */
void dropout(int k, int is_or, int exit1, LVALUE* lval)
{
    /* The IR reconstructs short-circuit control flow from AST_OROR /
       AST_ANDAND nodes, so no jump is emitted here. `rvalue(lval)`
       stays — it wraps the value-yielding operand in OP_DEREF for
       the AST builder. The constant-short-circuit early-return is
       a behaviour-preserving optimisation that skim() relies on:
       in `||`, a const-true operand short-circuits the chain to
       true; in `&&`, a const-false operand short-circuits to false. */
    (void)exit1;
    if (k) {
        rvalue(lval);
    } else if (lval->is_const) {
        if ( lval->const_val && is_or ) return;
        if ( lval->const_val == 0 && !is_or ) return;
    }
}

/*
 * unary plunge to lower level
 */
int plnge1(int (*heir)(LVALUE* lval), LVALUE* lval)
{
    int k;

    k = (*heir)(lval);
    if (lval->is_const) {
        /* constant, load it later */
    }
    return (k);
}


/* Ops valid on decimal (float / fixed) operands. The `%` vs `%=`
   asymmetry is intentional: `%=` (OP_AMOD) is integer-only. */
static int op_is_decimal_capable(int ast_type)
{
    switch (ast_type) {
    case OP_EQ: case OP_NE: case OP_LE: case OP_GE: case OP_LT: case OP_GT:
    case OP_MULT: case OP_DIV: case OP_MOD:
    case OP_AMULT: case OP_ADIV:
        return 1;
    default: return 0;
    }
}


/*
 * binary plunge to lower level (not for +/-)
 */
void plnge2a(int (*heir)(LVALUE* lval), LVALUE* lval, LVALUE* lval2, int ast_type)
{
    Kind   lhs_val_type = lval->val_type;
    Kind   rhs_val_type;

    if (lval->is_const) {
        /* constant on left not loaded yet */

        /* Get RHS */
        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        lval->node = ast_binop(ast_type, lval->node, lval2->node);

        if ( kind_is_decimal(lval->val_type) && lval2->is_const == 0 ) { // FLOATCONST + lvalue
            if ( kind_is_decimal(lval2->val_type)) {
                // If the RHS (non constant) is a float, then use its type 
                lval->val_type = lval2->val_type;
                lval->ltype = lval2->ltype;
             }

            if ( lval2->val_type != lval->val_type ) {  // TODO, always?
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
            }

        } else if ( kind_is_decimal(lval2->val_type) && lval2->is_const == 0 ) {  // INTCONST + floatlvalue
            lval->val_type = lval2->val_type;
            lval->ltype = lval2->ltype;
        } else if (lval->val_type == KIND_LONGLONG) {
            widenintegers(lval, lval2);
            lval2->val_type = KIND_LONGLONG;
            lval2->ltype = lval2->ltype->isunsigned ? type_ulonglong : type_longlong;
        } else if (lval->val_type == KIND_LONG) {
            widenintegers(lval, lval2);
            lval2->val_type = KIND_LONG;
            lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;
        } else {
            if ( lval2->val_type == KIND_LONGLONG ) {
                lval->val_type = KIND_LONGLONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulonglong : type_longlong;
            } else if ( lval2->val_type == KIND_LONG ) {
                lval->val_type = KIND_LONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            } else if ( lval2->val_type == KIND_CPTR ) {
                lval->val_type = KIND_LONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            }
        }
    } else {
        /* non-constant on left */
        if ( lval->val_type == KIND_CARRY) {
            lval->val_type = lhs_val_type = KIND_INT;
            lval->ltype = type_int;
        }

        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        lval->node = ast_binop(ast_type, lval->node, lval2->node);

        if (lval2->is_const) {

            /* constant on right, primary loaded */
            lval->const_val = lval2->const_val;

            /* djm, load double reg for long operators */
            if (  kind_is_decimal(lval2->val_type) || kind_is_decimal(lval->val_type) ) {
                 // Convert to a float (if operator is valid for floats). fixed point allow more operators
                 if ( !kind_is_decimal(lval->val_type)) {
                     lval->val_type = lval2->val_type;
                     lval->ltype = lval2->ltype;
                 }
                 if ( kind_is_decimal(lval->val_type) ) {
                     lval2->val_type = lval->val_type;
                     lval2->ltype = lval->ltype;
                 }
            } else if (lval->val_type == KIND_LONGLONG  || lval2->val_type == KIND_LONGLONG ) {
                // Even if LHS is int, we promote to longlong.
                lval2->val_type = KIND_LONGLONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulonglong : type_longlong;
            } else if (lval->val_type == KIND_LONG  || lval2->val_type == KIND_LONG ) {
                // Even if LHS is int, we promote to long.
                lval2->val_type = KIND_LONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;
            } else if (lval->val_type == KIND_CPTR  || lval2->val_type == KIND_CPTR ) {
                lval2->val_type = KIND_LONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;
            } else if ( kind_is_fixed(lval->val_type)) {
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
            }

            if (lval2->const_val == 0 && (ast_type == OP_DIV || ast_type == OP_ADIV
                                       || ast_type == OP_MOD || ast_type == OP_AMOD)) {
                /* Diagnostic moved to ast_opt::ast_fold_constants
                   so it also fires for const-prop-revealed cases
                   like `int x = 0; ... y = z / x;`. */
                lval->const_val = 0;
                return;
            }
        }
    }
    lval->is_const &= lval2->is_const;

    if ( op_is_decimal_capable(ast_type) || intcheck(lval,lval2) == 0 ) {
        if ( lval->is_const && lval2->is_const ) {
            int isun = lval->ltype->isunsigned || lval2->ltype->isunsigned;
            /* Const-fold the binop AST built above (lval->node =
               ast_binop(...)). ast_fold_constants handles div/mod-by-zero (warns
               + folds to 0), shift-out-of-range (warns + folds to 0),
               integer and decimal arithmetic. After this call,
               lval->node is either an AST_LITERAL (folded) or the
               unchanged binop (e.g. fold gap). */
            lval->node = ast_fold_constants(lval->node);
            if (lval->node && lval->node->ast_type == AST_LITERAL) {
                lval->const_val = lval->node->zval;
                // Char-overflow promotion (per-signedness rules).
                if (isun) {
                    if (lval->val_type == KIND_CHAR && lval->const_val >= 256) {
                        lval->val_type = KIND_INT;
                        lval->ltype = type_uint;
                    }
                } else {
                    if (lval->val_type == KIND_CHAR &&
                        (lval->const_val < -127 || lval->const_val > 127)) {
                        lval->val_type = KIND_INT;
                        lval->ltype = type_int;
                    }
                }
                // Float-result promotion.
                if (kind_is_floating(lhs_val_type) || kind_is_floating(rhs_val_type)) {
                    lval->val_type = KIND_DOUBLE;
                    lval->ltype = type_double;
                }
                return;
            }
            lval->is_const = 0;
        }
        if (widen_if_float(lval, lval2)) {
            // Float op. Mod doesn't apply to floats; warn and skip.
            if ( ast_type == OP_MOD ) {
                errorfmt("Cannot apply operator %% to floating point",1);
            }
            /* Result of comparison is int regardless of operand type. */
            if (ast_type != OP_MULT && ast_type != OP_AMULT
             && ast_type != OP_DIV  && ast_type != OP_ADIV) {
                lval->val_type = KIND_INT;
                lval->ltype = type_int;
            }
            return;
        }
    }

    // If we've got here then, one or more of operands was non-constant

    // Widen the integer types. If we knew what the result type was going to be
    // we could choose not to do this 
    widenintegers(lval, lval2);


    if (lval->ptr_type || lval2->ptr_type) {
        /* Pointer-vs-non-pointer comparison warning AND
           "Invalid pointer arithmetic" error both migrated to
           ast_opt's ast_typecheck pass. We still short-circuit here
           because the legacy semantics return without running
           constoper / widen_if_float when either side is a pointer. */
        return;
    }

    /* Signedness-mismatch warning migrated to ast_opt (ast_typecheck).
       Const-RHS / const-LHS operator selection happens in the IR
       (dispatch on AST_LITERAL operands); the old parser-side block
       that funnelled constoper / dconstoper was dead — computed a value and
       returned without emitting. Both parameters dropped from the
       function signature. */
}

/*
 * binary plunge to lower level (for +/-)
 */
void plnge2b(int (*heir)(LVALUE* lval), LVALUE* lval, LVALUE* lval2, int ast_type)
{
    int lhs_val_type, rhs_val_type;

    lhs_val_type = lval->val_type;
    if (lval->is_const) {
        int doconst_oper = 0;
        /* constant on left not yet loaded */
        if (plnge1(heir, lval2))
            rvalue(lval2);

        /* Symmetric `int + ptr` pointer scaling: when RHS is the
           pointer, the LHS integer constant needs scaling by pointee
           size. Wrap lval->node in OP_MULT before building the binop
           — ast_fold_constants will collapse OP_MULT(literal, literal)
           back to a single literal so the emit is just `ld bc, N;
           add hl, bc`. Mirrors the LHS-pointer fix below. */
        if (lval2->ptr_type != KIND_NONE && lval->ptr_type == KIND_NONE
            && lval2->ltype && lval2->ltype->ptr
            && lval2->ltype->ptr->size > 1) {
            lval->node = ast_binop(OP_MULT, lval->node,
                ast_literal(type_int, (zdouble)lval2->ltype->ptr->size));
        }
        lval->node = ast_binop(ast_type, lval->node, lval2->node);
        rhs_val_type = lval2->val_type;


        // We'll use const operator if it's add and RHS is lvalue (implicitly LHS is const since we're here)
        doconst_oper = ast_type == OP_ADD && lval2->is_const == 0;
        
        if ( kind_is_decimal(lval->val_type) && lval2->is_const == 0 ) {
            if ( kind_is_decimal(lval2->val_type)) {
                // If the RHS (non constant) is a float, then use its type 
                lval->val_type = lval2->val_type;
                lval->ltype = lval2->ltype;
             }

            // Floatconstant +/- lvalue
            if ( lval2->val_type != lval->val_type ) {
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
            }
            doconst_oper = 0; // No const operator for double
        } else if ( kind_is_decimal(lval2->val_type) && lval2->is_const == 0 ) {
            // Constant +/- Floatinglvalue
            doconst_oper = 0; // No const operator for double

            // LHS is constant, lets load it (after converting to the right type)
            lval->val_type = lval2->val_type;
            lval->ltype = get_decimal_type(lval->val_type, lval2->ltype->isunsigned);
        } else if (lval->val_type == KIND_LONG) {
            // LongConstant +/- lvalue
            widenintegers(lval, lval2);
            if (!ispointer(lval2->ltype)) {
                lval2->val_type = KIND_LONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;
            }
        } else {
            // LHS = integer constant, RHS = lvalue?
             if ( lval2->val_type == KIND_LONGLONG ) {
                if (!ispointer(lval->ltype)) {
                    lval->val_type = KIND_LONGLONG;
                    lval->ltype = lval->ltype->isunsigned ? type_ulonglong : type_longlong;
                }
            } else if ( lval2->val_type == KIND_LONG ) {
                if (!ispointer(lval->ltype)) {
                    lval->val_type = KIND_LONG;
                    lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
                }
            } else {
                if (!ispointer(lval->ltype)) {
                    lval->ltype = lval2->ltype->isunsigned ? type_uint : type_int;
                }
            }
        }
        if ( doconst_oper ) {
            lval->is_const = 0;
            result(lval, lval2);
            return;
        }
    } else {
        /* non-constant on left - it's already loaded */
        if (lval->val_type == KIND_CARRY) {
            lval->val_type = lhs_val_type = KIND_INT;
            lval->ltype = type_int;
        }

        if (plnge1(heir, lval2))
            rvalue(lval2);
        /* Pointer arithmetic: scale the RHS by pointee size before
           the OP_ADD/OP_SUB so the IR emits a plain byte-offset binop
           (`int *p; p + i` → `*(p + i*2)`, `p + 5` → `*(p + 10)`).
           ast_fold_constants collapses the OP_MULT when the index is a
           literal. ptr-minus-int is symmetric; ptr-minus-ptr element
           scaling is handled by the IR. We update
           lval2->node in place so heir1's compound-assign rebuild
           (which discards plnge2b's binop and reuses lval2.node)
           still sees the scaled offset for `p += N` / `p -= N`. */
        if (lval->ptr_type != KIND_NONE && lval2->ptr_type == KIND_NONE
            && lval->ltype && lval->ltype->ptr
            && lval->ltype->ptr->size > 1) {
            lval2->node = ast_binop(OP_MULT, lval2->node,
                ast_literal(type_int, (zdouble)lval->ltype->ptr->size));
        }
        lval->node = ast_binop(ast_type, lval->node, lval2->node);
        rhs_val_type = lval2->val_type;
        if (lval2->is_const) {
            /* constant on right */
            if ( kind_is_decimal(lval2->val_type) ) {
                if ( !kind_is_decimal(lval->val_type)) {
                    lval->val_type = lval2->val_type;
                    lval->ltype = lval2->ltype;
                } else {
                    // Make the constant the same floating type as LHS?
                    lval2->val_type = lval->val_type;
                    lval2->ltype = lval->ltype;
                }
                return;
            } else if ( kind_is_decimal(lval->val_type) ) {
                /* On stack we've got the double, load the constant as a double */
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
                return;
            } else {
                /* Integer-Lvalue +/- integer constant. The pointer
                   scaling that lived here (cscale on a local `val`)
                   is dead: the result was never written back to the
                   AST literal. The current pointer-arith scaling
                   path wraps `lval2->node` in OP_MULT just before
                   the OP_ADD/OP_SUB is built (see above), which
                   handles const-RHS automatically because
                   ast_fold_constants collapses literal-times-literal. */
            }
        } else {
            /* non-constant on both sides  */
            if (widen_if_float(lval, lval2)) {
                /* floating point operation */
                lval->is_const = 0;
                return;
            } else {
                widenintegers(lval, lval2);
                /* "Converting integer type to pointer without cast"
                   warning migrated to ast_opt (ast_typecheck). */
            }
        }
    }

    if (lval->is_const && lval2->is_const) {
        // Both operators are constant fold them
        if (ast_type == OP_ADD) 
            lval->const_val += lval2->const_val;
        else if (ast_type == OP_SUB)
            lval->const_val -= lval2->const_val;
        else
            lval->const_val = 0;
        // Promote as necessary
        if ( kind_is_floating(lhs_val_type) || kind_is_floating(rhs_val_type) ) {
            lval->val_type = (lhs_val_type == KIND_DOUBLE || rhs_val_type == KIND_DOUBLE) ? KIND_DOUBLE :
                             (lhs_val_type == KIND_FLOAT16 || rhs_val_type == KIND_FLOAT16) ? KIND_FLOAT16 :
                             (lhs_val_type == KIND_ACCUM32 || rhs_val_type == KIND_ACCUM32) ? KIND_ACCUM32 : KIND_ACCUM16;
            lval->ltype = get_decimal_type(lval->val_type, 0); // TODO sign?
        }
        /* F1: parser-side `lval->node = ast_literal(...)` removed —
           ast_fold_constants collapses (OP_ADD/OP_SUB literal literal)
           during ast_opt_run. lval->const_val is still maintained for
           constexpr() (F2 migration). */
    } else if (lval2->is_const == 0) {
        /* right operand not constant */
        lval->is_const = 0;
    }

    
    if (ast_type == OP_SUB && lval->ptr_type) {
        /* Pointer subtraction: byte→element scaling is emitted by the
           IR. The "Pointer arithmetic with non-matching types" warning
           has been migrated to ast_opt
           (ast_typecheck pass). */
    } else if ( ast_type == OP_ADD && lval->ptr_type && lval2->ptr_type ) {
        UT_string  *str;
        utstring_new(str);
        utstring_printf(str,"Pointer addition: ");
        type_describe(lval->ltype, str);
        utstring_printf(str, " + ");
        type_describe(lval2->ltype, str);
        utstring_printf(str, " is invalid");
        errorfmt("%s", 1, utstring_body(str));
        utstring_free(str);
    }
    result(lval, lval2);
}
