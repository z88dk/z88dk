/*
 *      Small C+ Compiler
 *
 *      Plunging routines
 *
 *      $Id: plunge.c,v 1.12 2016-03-29 13:39:44 dom Exp $
 *
 *      Altogether now...arse! My cunning scheme to use c as an
 *      indicator flops badly due to logical conditions, I just
 *      wanna scream! So, during the if statement we use c to
 *      signal that we want to drop out, at the end we test for
 *      hl to maintain the logicalness...
 */

#include "ccdefs.h"

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
            vconst(endval);
            jumpr(endlab = getlabel());
            postlabel(droplab);
            vconst(dropval);
            postlabel(endlab);
            lval->val_type = lval->oldval_type = CINT; /* stops the carry stuff coming in */
            lval->indirect = lval->ptr_type = lval->is_const = lval->const_val = 0;
            lval->stage_add = NULL;
            lval->binop = dummy;
            return (0);
        } else
            return k;
    }
}

void load_constant(LVALUE *lval)
{
    if (lval->val_type == LONG) {
        vlongconst(lval->const_val);
    } else if (lval->val_type == DOUBLE ) {
        load_double_into_fa(lval);
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
        load_constant(lval);

       
    }
    if (DoTestJump(lval) || lval->binop == dummy) {
        if (lval->binop == dummy) {
            lval->val_type = CINT;
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
        if ( lval->val_type == DOUBLE ) {
       //     decrement_double_ref(lval);
        }
    }
    return (k);
}

/*
 * binary plunge to lower level (not for +/-)
 */
void plnge2a(int (*heir)(LVALUE* lval), LVALUE* lval, LVALUE* lval2, void (*oper)(LVALUE *lval), void (*doper)(LVALUE *lval), void (*constoper)(LVALUE *lval, int32_t constval))
{
    char *before, *start;
    char *before_constlval, *start_constlval;
    int   savesp;
    int   lhs_val_type = lval->val_type;
    int   rhs_val_type;
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


        if (lval->const_val == 0)
            lval->stage_add = stagenext;

        if ( lval->val_type == DOUBLE && lval2->is_const == 0 ) {
            if ( lval2->val_type != DOUBLE ) {
                convert_int_to_double(lval2->val_type, lval2->flags & UNSIGNED);
                lval2->val_type = DOUBLE;
            }
            dpush();
            load_double_into_fa(lval);
            if ( oper == zdiv || oper == zmod ) {
                callrts("dswap");
            }
        } else if ( lval2->val_type == DOUBLE && lval2->is_const == 0 ) { 
            /* On stack we've got the double, load the constant as a double */
            dpush();
            vlongconst(lval->const_val);
            if ( lval->flags & UNSIGNED ) {
                convUlong2doub();
            } else {
                convSlong2doub();
            }
            lval->val_type = DOUBLE;
            /* division isn't commutative so we need to swap over' */
            if ( oper == zdiv || oper == zmod ) {
                callrts("dswap");
            }
        } else if (lval->val_type == LONG) {
            widenlong(lval, lval2);
            lval2->val_type = LONG; /* Kludge */
            lpush();
            vlongconst(lval->const_val);
        } else {
            if ( lval2->val_type == LONG ) {
                vlongconst_noalt(lval->const_val); 
                lval->val_type = LONG;             
            } else {
                const2(lval->const_val);
            }
        }
    } else {
        /* non-constant on left */
        if (lval->val_type == DOUBLE) {
            dpush();
        } else if (lval->val_type == CARRY) {
            force(CINT, CARRY, 0, 0, 0);
            setstage(&before, &start);
            lval->val_type = CINT;
            zpush();
        } else if (lval->val_type == LONG || lval->val_type == CPTR) {
             lpush();
        } else {
             zpush();
        }
        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        if (lval2->is_const) {
            /* constant on right, primary loaded */
            if (lval2->const_val == 0)
                lval->stage_add = start;

            /* djm, load double reg for long operators */
            if ( lval2->val_type == DOUBLE || lval->val_type == DOUBLE ) {
                 load_double_into_fa(lval2);
                 lval2->val_type = DOUBLE;
            } else if (lval->val_type == LONG || lval2->val_type == LONG) {
                vlongconst(lval2->const_val);
                lval2->val_type = LONG;
            } else {
                vconst(lval2->const_val);
            }

            // TODO: We can do some quickdiv as well surely
            if (lval2->const_val == 0 && (oper == zdiv || oper == zmod)) {
                /* Note, a redundant load of lval has been done, this can be taken out by the optimiser */
                clearstage(before, 0);
                if ( lval2->val_type == DOUBLE ) {
                    decrement_double_ref(lval2);
                }
                Zsp = savesp;
                if (lval->val_type == LONG) {
                    vlongconst(0);
                } else {
                    vconst(0);
                }
                warning(W_DIVZERO);
                return;
            }
        }
        if (lval->val_type != DOUBLE && lval2->val_type != DOUBLE && 
            lval->val_type != LONG && lval2->val_type != LONG && lval->val_type != CPTR && lval2->val_type != CPTR)
            /* Dodgy? */
            zpop();
    }
    lval->is_const &= lval2->is_const;

    /* ensure that operation is valid for double */
    if (  doper != NULL || intcheck(lval,lval2) == 0 ) {
        if ( lval->is_const && lval2->is_const ) {
            if ( lhs_val_type == DOUBLE ) decrement_double_ref(lval);
            if ( rhs_val_type == DOUBLE ) decrement_double_ref(lval2);
            lval->const_val = calcun(lval->const_val, oper, lval2->const_val);

            // Promote as necessary
            if ( lhs_val_type == DOUBLE || rhs_val_type == DOUBLE ) {
                lval->val_type = DOUBLE;
                // Load this constant so we can sort out the refcount for folding
                load_double_into_fa(lval);
            }
            clearstage(before, 0);
            Zsp = savesp;
            return;
        }
        if (widen(lval, lval2)) {
            (*doper)(lval);
            /* result of comparison is int */
            if (doper != mult && doper != zdiv)
                lval->val_type = CINT;
            return;
        }
    }
    /* Attempt to compensate width, so that we are doing double oprs if
 * one of the expressions is a double
 */
    if (!lval->is_const) {
        widenlong(lval, lval2);
    }
    if (lval->ptr_type || lval2->ptr_type) {
        (*oper)(lval);
        //                if (lval->val_type == CPTR) zpop(); /* rest top bits */
        lval->binop = oper;
        return;
    }
    /* Moved unsigned thing to below, so can fold expr correctly! */

    if ((lval2->symbol && lval2->symbol->ident == POINTER)) {
        (*oper)(lval);
        lval->binop = oper;
        return;
    }
    if (lval->is_const) {
        /* both operands constant taking respect of sign now,
         * unsigned takes precedence.. 
         */
        if ( lval->val_type == DOUBLE ) decrement_double_ref(lval);
        if ( lval2->val_type == DOUBLE ) decrement_double_ref(lval2);
        if ((lval->flags & UNSIGNED) || (lval2->flags & UNSIGNED))
            lval->const_val = calcun(lval->const_val, oper, lval2->const_val);
        else
            lval->const_val = calc(lval->const_val, oper, lval2->const_val);
        clearstage(before, 0);
        Zsp = savesp;
    } else {
        /* one or both operands not constant */

        /* djm, if we have a constant and a proper lvalue, then set the flags of
         * const to equal the signedness of the lvalue. This *will* cause 
         * problems if we allow specifiers after numbers
         */
        if (lval->is_const)
            lval->flags = (lval->flags & ~UNSIGNED) | (lval2->flags & UNSIGNED);
        if (lval2->is_const)
            lval2->flags = (lval2->flags & ~UNSIGNED) | (lval->flags & UNSIGNED);

        if ((lval->flags & UNSIGNED) != (lval2->flags & UNSIGNED) && (oper == zmod || oper == mult || oper == zdiv))
            warning(W_OPSG);

        // Remove any function type decorators
        lval->flags &= (UNSIGNED|FAR);

        /* Special case handling for operation by constant */
        if ( constoper != NULL && ( oper == mult || oper == zor || oper == zand || lval2->is_const) ) {
            int doconstoper = 0;
            int32_t const_val;

            if ( lval2->is_const && (lval->val_type == CINT || lval->val_type == CCHAR || lval->val_type == LONG) ) {
                doconstoper = 1;
                const_val = lval2->const_val;
                clearstage(before, 0);
                force(rhs_val_type, lhs_val_type, lval->flags & UNSIGNED ? YES : NO, lval->flags & UNSIGNED ? YES : NO, NO);
            }
            /* Handle the case that the constant was on the left */
            if ( lval1_wasconst && (lval2->val_type == CINT || lval2->val_type == CCHAR || lval2->val_type == LONG) ) {
                doconstoper = 1;
                const_val = lval->const_val;
                clearstage(before_constlval, 0);
                force(lhs_val_type, rhs_val_type, lval2->flags & UNSIGNED ? YES : NO, lval2->flags & UNSIGNED ? YES : NO, NO);
            }
            if ( doconstoper ) {
                Zsp = savesp;                
                constoper(lval, const_val);
                return;
            }
        }
        (*oper)(lval);
        lval->binop = oper;
    }
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
        /* constant on left not yet loaded */
        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        val = lval->const_val;
        if (dbltest(lval2, lval)) {
            int ival = val;
            /* are adding lval to pointer, adjust size */
            cscale(lval2->ptr_type, lval2->tagsym, &ival);
            val = ival;
        }

        if ( lval->val_type == DOUBLE && lval2->is_const == 0 ) {
            if ( lval2->val_type != DOUBLE ) {
                convert_int_to_double(lval2->val_type, lval2->flags & UNSIGNED);
                lval2->val_type = DOUBLE;
            }
            dpush();
            load_double_into_fa(lval);
        } else if ( lval2->val_type == DOUBLE && lval2->is_const == 0 ) { 
            /* FA holds the right hand side */
            dpush();
            if ( lval->val_type == DOUBLE ) {
                load_double_into_fa(lval);
            } else {
                /* On stack we've got the double, load the constant as a double */
                vlongconst(val);
                if ( lval->flags & UNSIGNED ) {
                    convUlong2doub();
                } else {
                    convSlong2doub();
                }
                lval->val_type = DOUBLE;
            }
            /* Subtraction isn't commutative so we need to swap over' */
            if ( oper == zsub ) {
                callrts("dswap");
            }
            
        } else if (lval->val_type == LONG) {
            widenlong(lval, lval2);
            lval2->val_type = LONG; /* Kludge */
            lpush();
            vlongconst(lval->const_val);
        } else {
            if ( lval2->val_type == LONG ) {
                vlongconst_noalt(lval->const_val); 
                lval->val_type = LONG;             
            } else {
                const2(lval->const_val);
            }
        }
    } else {
        /* non-constant on left */
        int savesp1 = Zsp;

        setstage(&before1, &start1);
        if (lval->val_type == DOUBLE) {
            dpush();
        } else if (lval->val_type == LONG || lval->val_type == CPTR) {
            lpush();
        } else {
            if (lval->val_type == CARRY) {
                zcarryconv();
                lval->val_type = CINT;
            }
            zpush();
        }
        if (plnge1(heir, lval2))
            rvalue(lval2);
        rhs_val_type = lval2->val_type;
        if (lval2->is_const) {
            /* constant on right */
            val = lval2->const_val;


            if ( lval2->val_type == DOUBLE ) { 
                clearstage(before1, 0);
                Zsp = savesp1;
                force(DOUBLE, lval->val_type, NO, lval->flags & UNSIGNED, NO);
                lval->val_type = DOUBLE;
                dpush();
                load_double_into_fa(lval2);
                (*oper)(lval);
                return;
            }


            if ( lval->val_type == DOUBLE ) { 
                /* On stack we've got the double, load the constant as a double */
                if ( lval2->val_type == DOUBLE ) {
                    load_double_into_fa(lval2);
                } else {
                    vlongconst(val);
                    if ( lval2->flags & UNSIGNED ) {
                        convUlong2doub();
                    } else {
                        convSlong2doub();
                    }
                }
                (*oper)(lval);
            } else {
                if (dbltest(lval, lval2)) {
                    int ival = val;
                    /* are adding lval2 to pointer, adjust size */
                    cscale(lval->ptr_type, lval->tagsym, &ival);
                    val = ival;
                }
                if (oper == zsub) {
                    /* addition on Z80 is cheaper than subtraction */
                    val = (-val);
                    /* skip later diff scaling - constant can't be pointer */
                    oper = zadd;
                }
                /* remove zpush and add int constant to int */
                clearstage(before1, 0);
                Zsp = savesp1;
                addconst(val, 0, 0);
            }
        } else {
            /* non-constant on both sides  */
            if (dbltest(lval, lval2))
                scale(lval->ptr_type, lval->tagsym);
            if (widen(lval, lval2)) {
                /* floating point operation */
                (*oper)(lval);
                lval->is_const = 0;
                return;
            } else {
                widenlong(lval, lval2);
                /* non-constant integer operation */
                if (lval->val_type != LONG && lval->val_type != CPTR)
                    zpop();
                if (dbltest(lval2, lval)) {
                    swap();
                    scale(lval2->ptr_type, lval2->tagsym);
                    /* subtraction not commutative */
                    if (oper == zsub)
                        swap();
                }
            }
        }
    }
    if (lval->is_const && lval2->is_const) {
        if ( lhs_val_type == DOUBLE ) decrement_double_ref(lval);
        if ( rhs_val_type == DOUBLE ) decrement_double_ref(lval2);
        /* both operands constant */
        if (oper == zadd) 
            lval->const_val += lval2->const_val;
        else if (oper == zsub)
            lval->const_val -= lval2->const_val;
        else
            lval->const_val = 0;
        // Promote as necessary
        if ( lhs_val_type == DOUBLE || rhs_val_type == DOUBLE ) {
            lval->val_type = DOUBLE;
            load_double_into_fa(lval);
        }
        clearstage(before, 0);
        Zsp = oldsp;
    } else if (lval2->is_const == 0) {
        /* right operand not constant */
        lval->is_const = 0;
        (*oper)(lval);
    }
    if (oper == zsub && lval->ptr_type) {
        /* scale difference between pointers */
        /* djm...preserve our pointer high 8 bits? */
        if (lval->val_type == CPTR) {
            lval->val_type = CPTR;
            ltype = LONG;
        } else {
            lval->val_type = CINT; /* operate on pointers as ints */
            ltype = CINT; /* dodgy maybe 24/4/99 */
        }
        if (lval->ptr_type == CINT && lval2->ptr_type == CINT) {
            zdiv_const(lval,2);  /* Divide by two */
        } else if (lval->ptr_type == CPTR && lval2->ptr_type == CPTR) {
            zdiv_const(lval,3);
        } else if (lval->ptr_type == LONG && lval2->ptr_type == LONG) {
            zdiv_const(lval,4); /* div by 4 */
        } else if (lval->ptr_type == DOUBLE && lval2->ptr_type == DOUBLE) {
            zdiv_const(lval,6); /* div by 6 */
        } else if (lval->ptr_type == STRUCT && lval2->ptr_type == STRUCT) {
            zdiv_const(lval, lval->tagsym->size);
        }
    }
    result(lval, lval2);
}
