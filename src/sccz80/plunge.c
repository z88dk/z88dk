/*
 *      Small C+ Compiler
 *
 *      Plunging routines
 *
 *      $Id: plunge.c,v 1.12 2016-03-29 13:39:44 dom Exp $
 */

#include "ccdefs.h"
#include <limits.h>

/*
 * skim over text adjoining || and && operators
 */
int skim(char* opstr, void (*testfuncz)(LVALUE* lval, int label), void (*testfuncq)(int label), int dropval, int endval, int (*heir)(LVALUE* lval), LVALUE* lval)
{
    int droplab, endlab, hits, k;

    hits = 0;
    while (1) {
        k = plnge1(heir, lval);
        if (streq(line + lptr, opstr) == 2) {
            inbyte();
            inbyte();
            if (hits == 0) {
                hits = 1;
                droplab = getlabel();
            }
            dropout(k, testfuncz, testfuncq, droplab, lval);
        } else if (hits) {
            dropout(k, testfuncz, testfuncq, droplab, lval);
            // TODO: Change to a carry?
            vconst(endval);
            jumpr(endlab = getlabel());
            postlabel(droplab);
            vconst(dropval);
            postlabel(endlab);
            lval->val_type = KIND_INT;
            lval->oldval_kind = KIND_INT;
            lval->ltype = type_int;
            lval->indirect_kind = KIND_NONE;
            lval->ptr_type = lval->is_const = 0;
            lval->const_val = 0;
            lval->stage_add = NULL;
            lval->binop = dummy;
            return (0);
        } else
            return k;
    }
}

void load_constant(LVALUE *lval)
{
    if (lval->val_type == KIND_LONGLONG) {
        vllongconst(lval->const_val);
    } else if (lval->val_type == KIND_LONG || lval->val_type == KIND_CPTR) {
        vlongconst(lval->const_val);
    } else if (kind_is_floating(lval->val_type) ){
        gen_load_constant_as_float(lval->const_val, lval->val_type, 0);
    } else {
        vconst(lval->const_val);
    }
}

/*
 * test for early dropout from || or && evaluations
 */
void dropout(int k, void (*testfuncz)(LVALUE* lval, int label), void (*testfuncq)(int label), int exit1, LVALUE* lval)
{
    if (k)
        rvalue(lval);
    else if (lval->is_const) {
        if ( lval->const_val && testfuncz == eq0 ) {
            gen_jp_label(exit1,1);
            return;
        } else if ( lval->const_val == 0 && testfuncz == testjump) {
            gen_jp_label(exit1,1);
            return;
        } 
        load_constant(lval);
    }
    if (check_lastop_was_testjump(lval) || lval->binop == dummy) {
        if (lval->binop == dummy) {
            lval->val_type = KIND_INT;
            lval->ltype = type_int;      
        }
        (*testfuncz)(lval, exit1); /* test zero jump */
    } else {
        (*testfuncq)(exit1); /* carry jump */
    }
}

/*
 * unary plunge to lower level
 */
int plnge1(int (*heir)(LVALUE* lval), LVALUE* lval)
{
    char *before, *start;
    int k;

    setstage(&before, &start);
    k = (*heir)(lval);
    if (lval->is_const) {
        /* constant, load it later */
        clearstage(before, 0);
    }
    return (k);
}


int operator_is_comparison(void (*oper)(LVALUE *lval)) 
{
    if ( oper == zeq || oper == zne || oper == zle || oper == zlt || oper == zge || oper == zgt ) {
        return 1;
    }
    return 0;
}

int operator_is_commutative(void (*oper)(LVALUE *lval))
{
    if ( oper == zeq || oper == zne || oper == zadd || oper == mult || oper == zand || oper == zor || oper == zxor ) 
        return 1;
    return 0;
}

/*
 * binary plunge to lower level (not for +/-)
 */
void plnge2a(int (*heir)(LVALUE* lval), LVALUE* lval, LVALUE* lval2, void (*oper)(LVALUE *lval),
             void (*doper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int64_t constval),
             int (*dconstoper)(LVALUE *lval, double constval, int isrhs))
{
    char *before, *start;
    char *before_constlval, *start_constlval;
    int   savesp;
    Kind   lhs_val_type = lval->val_type;
    Kind   rhs_val_type;
    int   lval1_wasconst = 0;

    savesp = Zsp;
    setstage(&before, &start);
    lval->stage_add = NULL; /* flag as not "..oper 0" syntax */
    if (lval->is_const) {
        /* constant on left not loaded yet */
        lval1_wasconst = 1;

        /* Get RHS */
        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        setstage(&before_constlval, &start_constlval);

        lval->stage_add = stagenext;
        lval->stage_add_ltype = lval2->ltype;
        if ( kind_is_floating(lval->val_type) && lval2->is_const == 0 ) { // FLOATCONST + lvalue
            if ( kind_is_floating(lval2->val_type)) {
                // If the RHS (non constant) is a float, then use its type 
                lval->val_type = lval2->val_type;
                lval->ltype = lval2->ltype;
             }

            if ( lval2->val_type != lval->val_type ) {  // TODO, always?
                zconvert_to_double(lval2->val_type, lval->val_type, lval2->ltype->isunsigned);
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
            }

            // Try the const operator
            if ( dconstoper != NULL ) {
                if ( dconstoper(lval, lval->const_val, 0)) {
                    lval->is_const = 0;
                    return;
                }
            }

            // This push/load/swap combo is picked up by an optimisation rule as necessary
            gen_push_float(lval2->val_type);
            load_constant(lval); // This is a float
            if ( !operator_is_commutative(oper) ) {
                gen_swap_float(lval->val_type);
            }
        } else if ( kind_is_floating(lval2->val_type) && lval2->is_const == 0 ) {  // INTCONST + floatlvalue
            /* On stack we've got the double, load the constant (which is an integral type) as a double */
            if ( dconstoper != NULL ) {
                if ( dconstoper(lval2, lval->const_val, 0)) {
                    lval->is_const = 0;
                    lval->val_type = lval2->val_type;
                    lval->ltype = lval2->ltype;
                    return;
                }
            }
            gen_push_float(lval2->val_type);

            lval->val_type = lval2->val_type;
            lval->ltype = lval2->ltype;
            load_constant(lval);  
            /* division isn't commutative so we need to swap over' */
            if ( !operator_is_commutative(oper) ) {
                gen_swap_float(lval->val_type);
            }
        } else if (lval->val_type == KIND_LONGLONG) {
            widenintegers(lval, lval2); 
            lval2->val_type = KIND_LONGLONG;
            lval2->ltype = lval2->ltype->isunsigned ? type_ulonglong : type_longlong;
            vlongconst_tostack(lval->const_val);
        } else if (lval->val_type == KIND_LONG) {
            widenintegers(lval, lval2); 
            lval2->val_type = KIND_LONG;
            lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;
            vlongconst_tostack(lval->const_val);
        } else {
            if ( lval2->val_type == KIND_LONGLONG ) {
                vllongconst_tostack(lval->const_val);
                lval->val_type = KIND_LONGLONG;  
                lval->ltype = lval->ltype->isunsigned ? type_ulonglong : type_longlong;    
            } else if ( lval2->val_type == KIND_LONG ) {
                vlongconst_tostack(lval->const_val); 
                lval->val_type = KIND_LONG;  
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;        
            } else {
                const2(lval->const_val);
            }
        }
    } else {
        /* non-constant on left */
        int  beforesp = Zsp;
        int savestkcount = stkcount;
        setstage(&before_constlval, &start_constlval);

        if ( lval->val_type == KIND_CARRY) {
            force(KIND_INT, KIND_CARRY, 0, 0, 0);
            setstage(&before, &start);
            lval->val_type = lhs_val_type = KIND_INT;
            lval->ltype = type_int;
        }
        gen_push_primary(lval);

        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;

        if (lval2->is_const) {

            /* constant on right, primary loaded */
            lval->stage_add = start;
            lval->stage_add_ltype = lval->ltype;  
            lval->const_val = lval2->const_val; 

            /* djm, load double reg for long operators */
            if (  kind_is_floating(lval2->val_type) || kind_is_floating(lval->val_type) ) {
                 clearstage(before_constlval, NULL);
                 Zsp = beforesp;
                 stkcount = savestkcount;
                 // Convert to a float
                 if ( !kind_is_floating(lval->val_type) ) {
                     zconvert_to_double(lval->val_type, lval2->val_type, lval->ltype->isunsigned);
                     lval->val_type = lval2->val_type;
                     lval->ltype = lval2->ltype;
                 }
                 if ( doper == zdiv ) {
                     doper = mult;
                     dconstoper = mult_dconst;
                     lval2->const_val = 1. / lval2->const_val;
                 }
                 if ( dconstoper != NULL ) {
                     if ( dconstoper(lval, lval2->const_val, 1)) {
                         return;
                     }
                 }
                 gen_push_float(lval->val_type);
                 if ( kind_is_floating(lval->val_type)) {
                     lval2->val_type = lval->val_type;
                     lval2->ltype = lval->ltype;
                 }
                 load_constant(lval2);
             } else if (lval->val_type == KIND_LONGLONG  || lval2->val_type == KIND_LONGLONG ) {
                // Even if LHS is int, we promote to longlong. 
                lval2->val_type = KIND_LONGLONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulonglong : type_longlong;    
                load_constant(lval2);            
            } else if (lval->val_type == KIND_LONG  || lval2->val_type == KIND_LONG ) {
                // Even if LHS is int, we promote to long. 
                lval2->val_type = KIND_LONG;
                lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long;    
                load_constant(lval2);            
            } else {
                vconst(lval2->const_val);
            }

            if (lval2->const_val == 0 && (oper == zdiv || oper == zmod)) {
                /* Note, a redundant load of lval has been done, this can be taken out by the optimiser */
                clearstage(before, 0);
                Zsp = savesp;
                lval->const_val = 0;
                load_constant(lval);
                warningfmt("division-by-zero","Division by zero, result set to be zero");
                return;
            }
        }
        if ( !kind_is_floating(lval->val_type) && !kind_is_floating(lval2->val_type) && 
            lval->val_type != KIND_LONG && lval2->val_type != KIND_LONG && lval->val_type != KIND_CPTR && lval2->val_type != KIND_CPTR &&
            lval->val_type != KIND_LONGLONG && lval2->val_type != KIND_LONGLONG) {
            /* Gets the LHS back again for 16 bit operands */
            zpop();
        }
    }
    lval->is_const &= lval2->is_const;

    if (  doper != NULL || intcheck(lval,lval2) == 0 ) {
        // Fold constants if we can
        if ( lval->is_const && lval2->is_const ) {
            int is16bit = lval->val_type == KIND_INT || lval->val_type == KIND_CHAR || lval2->val_type == KIND_INT || lval2->val_type == KIND_CHAR;
            if (lval->ltype->isunsigned || lval2->ltype->isunsigned ) {
                lval->const_val = calcun(lhs_val_type, lval->const_val, oper, rhs_val_type, lval2->const_val);
                // Promote char here
                if ( lval->val_type == KIND_CHAR && lval->const_val >= 256 ) {
                    lval->val_type = KIND_INT;
                    lval->ltype = type_uint;
                } 
            } else {
                lval->const_val = calc(lhs_val_type, lval->const_val, oper, rhs_val_type, lval2->const_val, is16bit);
                if ( lval->val_type == KIND_CHAR && (lval->const_val < -127 || lval->const_val > 127) ) {
                    lval->val_type = KIND_INT;
                    lval->ltype = type_int;
                }
            }

            // Promote as necessary
            if ( kind_is_floating(lhs_val_type) || kind_is_floating(rhs_val_type) ) {
                // This is a constant, so it will be pulled out as FLOAT16 as necessary
                lval->val_type = KIND_DOUBLE;
                lval->ltype = type_double;
            }
            clearstage(before, 0);
            Zsp = savesp;
            return;
        }
        if (widen_if_float(lval, lval2, operator_is_commutative(oper))) {
            // We only end up in here if at least one of the operands is floating
            if ( doper == zmod ) {
                errorfmt("Cannot apply operator %% to floating point",1);
            }
            (*doper)(lval);
            /* result of comparison is int */
            if (doper != mult && doper != zdiv) {
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


    if ( lval->ptr_type || lval2->ptr_type ) {
        if ( !operator_is_comparison(oper)) {
            errorfmt("Invalid pointer arithmetic",1);
        } else {
            lval->binop = oper;
            (*oper)(lval);
        }
        return;
    }

    /* one or both operands not constant */
    if ( lval2->is_const == 0 && lval1_wasconst == 0 &&
        (lval->ltype->isunsigned != lval2->ltype->isunsigned) && (oper == zmod || oper == mult || oper == zdiv)) {
        warningfmt("signedness","Operation on different signedness!");
    }
    

    /* Special case handling for operation by constant */
    if ( constoper != NULL && 
        ( oper == mult || oper == zor || oper == zand || oper == zxor || lval2->is_const) ) {
        int doconstoper = 0;
        int64_t const_val;

        /* Check for comparisions being out of range, if so, return constant */
        if ( lval2->is_const && operator_is_comparison(oper)) {
            int     always = -1;

            lval2->binop = oper;
            if ( lhs_val_type == KIND_INT ) {
                always = check_range(lval2, -32768, 65535);
            } else if ( lhs_val_type == KIND_CHAR  ) {
                always = check_range(lval2, -128, 255);
            }
            lval2->binop = NULL;

            if ( always != -1 ) {
                warningfmt("limited-range", "Due to limited range of data type, expression is always %s", always ? "true" : "false");
                // It's always "always"
                lval->binop = NULL;
                lval->is_const = 1;
                lval->const_val = always;
                return;
            }
        }
        lval->stage_add = NULL;

        // Handle constant on RHS
        if ( lval2->is_const && kind_is_integer(lval->val_type) ) {
            doconstoper = 1;
	    if ( lval2->ltype->isunsigned ) {
                const_val = (uint64_t)lval2->const_val;
	    } else if (lval2->const_val > (long double)LLONG_MAX ) {
                const_val = (int64_t)(uint64_t)lval2->const_val;
	    } else {
                const_val = (int64_t)lval2->const_val;
            }
            clearstage(before, 0);
            // Promote lhs if it's a smaller integer type than the constant
            if ( lhs_val_type < rhs_val_type) {
                force(rhs_val_type, lhs_val_type, lval->ltype->isunsigned, lval2->ltype->isunsigned,1);
            }
        } else if ( lval1_wasconst && kind_is_integer(lval2->val_type) ) {
            /* Handle the case that the constant was on the left */
            doconstoper = 1;
	    if ( lval->ltype->isunsigned ) {
                const_val = (uint64_t)lval->const_val;
	    } else if (lval->const_val > (long double)LLONG_MAX ) {
                const_val = (int64_t)(uint64_t)lval->const_val;
	    } else {
                const_val = (int64_t)lval->const_val;
            }
            clearstage(before_constlval, 0);
            force(lhs_val_type, rhs_val_type, lval2->ltype->isunsigned, lval->ltype->isunsigned,1);
        }

        // If we should actually do the constant operation, do it
        if ( doconstoper ) {
            Zsp = savesp;  
            lval->binop = oper;              
            constoper(lval, const_val);
            return;
        }
    }
 
    lval->binop = oper;
    (*oper)(lval);
}

/*
 * binary plunge to lower level (for +/-)
 */
void plnge2b(int (*heir)(LVALUE* lval), LVALUE* lval, LVALUE* lval2, void (*oper)(LVALUE *lval))
{
    char *before, *start, *before1, *start1;
    int oldsp = Zsp;
    double val;
    int lhs_val_type, rhs_val_type;

    lhs_val_type = lval->val_type;
    setstage(&before, &start);
    if (lval->is_const) {
        int doconst_oper = 0;
        /* constant on left not yet loaded */
        if (plnge1(heir, lval2))
            rvalue(lval2);

        rhs_val_type = lval2->val_type;

        if (lval->ptr_type != KIND_NONE ) {
            // LHS is a constant pointer, primary is loaded with RHS, need to scale it
            scale(lval->ptr_type, NULL);
        } else if (lval2->ptr_type != KIND_NONE ) {
            int ival = lval->const_val;
            /* are adding lval to pointer, adjust size */
            cscale(lval2->ltype, &ival);
            lval->const_val = ival;
        }


        // We'll use const operator if it's add and RHS is lvalue (implicitly LHS is const since we're here)
        doconst_oper = oper == zadd && lval2->is_const == 0;
        
        if ( kind_is_floating(lval->val_type) && lval2->is_const == 0 ) {
            if ( kind_is_floating(lval2->val_type)) {
                // If the RHS (non constant) is a float, then use its type 
                lval->val_type = lval2->val_type;
                lval->ltype = lval2->ltype;
             }

            // Floatconstant +/- lvalue
            if ( lval2->val_type != lval->val_type ) {
                zconvert_to_double(lval2->val_type, lval->val_type, lval2->ltype->isunsigned);
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
            }
            doconst_oper = 0; // No const operator for double

            // This push/load/swap combo is picked up by an optimisation rule as necessary
            gen_push_float(lval2->val_type);
            load_constant(lval); // LHS is known float
            if ( oper == zsub ) {
                gen_swap_float(lval->val_type);
            }
        } else if ( kind_is_floating(lval2->val_type) && lval2->is_const == 0 ) { 
            // Constant +/- Floatinglvalue
            doconst_oper = 0; // No const operator for double
            /* FA holds the right hand side */
            gen_push_float(lval2->val_type);  // Get RHS onto the stack

            // LHS is constant, lets load it (after converting to the right type)
            lval->val_type = lval2->val_type;
            lval->ltype = get_float_type(lval->val_type);
            load_constant(lval); 
    
            /* Subtraction isn't commutative so we need to swap over' */
            if ( oper == zsub ) {
                gen_swap_float(lval->val_type);
            }
            
        } else if (lval->val_type == KIND_LONG) {
            // LongConstant +/- lvalue
            widenintegers(lval, lval2);
            lval2->val_type = KIND_LONG;
            lval2->ltype = lval2->ltype->isunsigned ? type_ulong : type_long; 
            if ( doconst_oper == 0 ) {
                vlongconst_tostack(lval->const_val); 
            }
        } else {
            // LHS = integer constant, RHS = lvalue?
             if ( lval2->val_type == KIND_LONGLONG ) {
                if ( doconst_oper == 0 ) {
                    vllongconst_tostack(lval->const_val);
                }
                lval->val_type = KIND_LONGLONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            } else if ( lval2->val_type == KIND_LONG ) {
                if ( doconst_oper == 0 ) {
                    vlongconst_tostack(lval->const_val); 
                }
                lval->val_type = KIND_LONG;
                lval->ltype = lval->ltype->isunsigned ? type_ulong : type_long;
            } else {
                lval->ltype = lval2->ltype->isunsigned ? type_uint : type_int;  
                if ( doconst_oper == 0 ) {              
                    const2(lval->const_val);
                }
            }
        }
        if ( doconst_oper ) {
            lval->is_const = 0;
            zadd_const(lval, lval->const_val);
            result(lval, lval2);
            return;
        }
    } else {
        /* non-constant on left - it's already loaded */
        int savesp1 = Zsp;

        setstage(&before1, &start1);
        // Get LHS onto the stack
        if (lval->val_type == KIND_CARRY) {
            gen_conv_carry2int();
            lval->val_type = lhs_val_type = KIND_INT;
            lval->ltype = type_int;
        }
        gen_push_primary(lval);

        if (plnge1(heir, lval2))
            rvalue(lval2);

        rhs_val_type = lval2->val_type;
        if (lval2->is_const) {
            /* constant on right */
            val = lval2->const_val;
            
            if ( kind_is_floating(lval2->val_type) ) { 
                clearstage(before1, 0); // Get rid of primary on the stack
                Zsp = savesp1;

                if ( !kind_is_floating(lval->val_type)) {
                    // Force the primary register to a float
                    force(lval2->val_type, lval->val_type, NO, lval->ltype->isunsigned, 0);
                    lval->val_type = lval2->val_type;
                    lval->ltype = lval2->ltype;
                } else {
                    // Make the constant the same floating type as LHS?
                    lval2->val_type = lval->val_type;
                    lval2->ltype = lval->ltype;
                }
                gen_push_float(lval->val_type);
                // Load RHS (This is a float)
                load_constant(lval2);
                // And do it
                (*oper)(lval);
                return;
            } else if ( kind_is_floating(lval->val_type) ) { 
                /* On stack we've got the double, load the constant as a double */
                lval2->val_type = lval->val_type;
                lval2->ltype = lval->ltype;
                load_constant(lval2); 
                (*oper)(lval);
                return;
            } else {
                /* Integer-Lvalue +/- integer constant */
                if (lval->ptr_type != KIND_NONE ) {
                    int ival = val;
                    /* are adding lval2 to pointer, adjust size */
                    cscale(lval->ltype, &ival);
                    val = ival;
                }
                if (oper == zsub) {
                    /* addition on Z80 is cheaper than subtraction */
                    val = (-val);
                    /* skip later diff scaling - constant can't be pointer */
                    oper = zadd;
                }
                clearstage(before1, 0);  // Clear back to just after the load of LHS
                Zsp = savesp1;
                zadd_const(lval, val);
            }
        } else {
            /* non-constant on both sides  */
            if (dbltest(lval, lval2)) {
                scale(lval->ptr_type, lval->ptr_type == KIND_STRUCT ? lval->ltype->ptr->tag : NULL);
            }
            if (widen_if_float(lval, lval2,operator_is_commutative(oper))) {
                /* floating point operation */
                (*oper)(lval);
                lval->is_const = 0;
                return;
            } else {
                widenintegers(lval, lval2);
                /* non-constant integer operation */
                if (lval->val_type != KIND_LONGLONG && lval->val_type != KIND_LONG && lval->val_type != KIND_CPTR)
                    zpop();
                if (dbltest(lval2, lval)) {
                    UT_string  *str;
                    utstring_new(str);
                    utstring_printf(str,"Converting integer type to pointer witout cast. From ");
                    type_describe(lval->ltype, str);
                    utstring_printf(str, " to ");
                    type_describe(lval2->ltype, str);
                    warningfmt("incompatible-pointer-types","%s", utstring_body(str));
                    utstring_free(str);
                }
            }
        }
    }

    if (lval->is_const && lval2->is_const) {
        // Both operators are constant fold them
        if (oper == zadd) 
            lval->const_val += lval2->const_val;
        else if (oper == zsub)
            lval->const_val -= lval2->const_val;
        else
            lval->const_val = 0;
        // Promote as necessary
        if ( kind_is_floating(lhs_val_type) || kind_is_floating(rhs_val_type) ) {
            lval->val_type = (lhs_val_type == KIND_DOUBLE || rhs_val_type == KIND_DOUBLE) ? KIND_DOUBLE : KIND_FLOAT16; 
            lval->ltype = get_float_type(lval->val_type);
        }
        clearstage(before, 0);  // Wipe all of the code generated
        Zsp = oldsp;
    } else if (lval2->is_const == 0) {
        /* right operand not constant */
        lval->is_const = 0;
        (*oper)(lval);
    }

    
    if (oper == zsub && lval->ptr_type) {
        if (lval->ptr_type == KIND_INT && lval2->ptr_type == KIND_INT) {
            zdiv_const(lval,2);  /* Divide by two */
        } else if (lval->ptr_type == KIND_PTR && lval2->ptr_type == KIND_PTR) {
            zdiv_const(lval,2);  /* Divide by two */
        } else if (lval->ptr_type == KIND_CPTR && lval2->ptr_type == KIND_CPTR) {
            zdiv_const(lval,3);
        } else if (lval->ptr_type == KIND_LONG && lval2->ptr_type == KIND_LONG) {
            zdiv_const(lval,4); /* div by 4 */
        } else if (lval->ptr_type == KIND_FLOAT16 && lval2->ptr_type == KIND_FLOAT16) {
            zdiv_const(lval,2); /* div by 2 */
        } else if (lval->ptr_type == KIND_DOUBLE && lval2->ptr_type == KIND_DOUBLE) {
            zdiv_const(lval,c_fp_size); /* div by 6 */
        } else if (lval->ptr_type == KIND_STRUCT && lval2->ptr_type == KIND_STRUCT) {
            zdiv_const(lval, lval->ltype->ptr->tag->size);
        } else if (lval->ptr_type == KIND_CHAR && lval->ptr_type == KIND_CHAR ) {
        } else if (lval->ptr_type && lval2->ptr_type && lval->ptr_type != lval2->ptr_type ) {
            UT_string  *str;
            utstring_new(str);
            utstring_printf(str,"Pointer arithmetic with non-matching types: ");
            type_describe(lval->ltype, str);
            utstring_printf(str, " - ");
            type_describe(lval2->ltype, str);
            warningfmt("incompatible-pointer-types","%s", utstring_body(str));
            utstring_free(str);
        }
    } else if ( oper == zadd && lval->ptr_type && lval2->ptr_type ) {
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
