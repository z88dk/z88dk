/*
 *      Small C+ Compiler
 *
 *      Plunging routines
 *
 *      $Id: plunge.c,v 1.1 2000-07-04 15:33:32 dom Exp $
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
int skim(opstr, testfuncz, testfuncq, dropval, endval, heir, lval)
char *opstr;
void (*testfuncz)();
void (*testfuncq)();
int dropval, endval, (*heir)() ;
LVALUE *lval ;
{
        int droplab, endlab, hits, k ;

        hits = 0 ;
        while (1) {
                k = plnge1(heir, lval) ;
                if ( streq(line+lptr, opstr) == 2 ) {
                        inbyte() ;
                        inbyte() ;
                        if (hits == 0) {
                                hits = 1 ;
                                droplab = getlabel() ;
                        }
                        dropout(k, testfuncz,testfuncq, droplab, lval) ;
                }
                else if (hits) {
                        dropout(k, testfuncz,testfuncq, droplab, lval) ;
                        vconst(endval) ;   
                        jumpr(endlab=getlabel()) ;
                        postlabel(droplab);
                        vconst(dropval);
                        postlabel(endlab) ;
                        lval->indirect = lval->ptr_type = lval->is_const =
                                lval->const_val = 0 ;
                        lval->stage_add = NULL_CHAR ;
			lval->binop=dummy;
                        return (0) ;
                }
                else return k ;
        }
}

/*
 * test for early dropout from || or && evaluations
 */
void dropout(k, testfuncz,testfuncq, exit1, lval)
int k, exit1;
void (*testfuncz)();
void (*testfuncq)();
LVALUE *lval ;
{
        if ( k )
                rvalue(lval) ;
        else if ( lval->is_const ) {
                if (lval->val_type == LONG) vlongconst(lval->const_val);
                else vconst(lval->const_val) ;
        }
        if (DoTestJump(lval) || lval->binop==dummy ) {
		if (lval->binop==dummy) lval->val_type=CINT;
                (*testfuncz)(lval,exit1);       /* test zero jump */
	} else {
                (*testfuncq)(exit1);            /* carry jump */
	}
}

/*
 * unary plunge to lower level
 */
int plnge1(heir, lval)
int (*heir)() ;
LVALUE *lval ;
{
        char *before, *start ;
        int k ;

        setstage(&before, &start) ;
        k = (*heir)(lval) ;
        if ( lval->is_const ) {
                /* constant, load it later */
                clearstage( before, 0 ) ;
        }
        return (k) ;
}

/*
 * binary plunge to lower level (not for +/-)
 */
void plnge2a(heir, lval, lval2, oper, doper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
void (*oper)(), (*doper)();
{
        char *before, *start ;

        setstage(&before, &start) ;
        lval->stage_add = 0 ;           /* flag as not "..oper 0" syntax */
        if ( lval->is_const ) {
                /* constant on left not loaded yet */
                if ( plnge1(heir, lval2) )
                        rvalue(lval2) ;
                if ( lval->const_val == 0 )
                        lval->stage_add = stagenext ;

		/* Fixed 4/5/2000 If LHS was long const then we would
		   generate bad code cos constant was only in de and
		   rhs was ot on the stack -> crash (also in plnge2b)
		  */
		if (lval->val_type == LONG) {
			widenlong(lval,lval2);
			lval2->val_type=LONG; /* Kludge */
			lpush();
			vlongconst(lval->const_val);
		} else {
                	const2(lval->const_val) ;
		}
                dcerror(lval2) ;
        }
        else {
                /* non-constant on left */
                if ( lval->val_type == DOUBLE ) dpush() ;
                else {
                        if ( lval->val_type == LONG || lval->val_type==CPTR) { lpush(); }
                        else zpush();
                }
                if( plnge1(heir,lval2) ) rvalue(lval2);
                if ( lval2->is_const ) {
                        /* constant on right, load primary */
                        if ( lval2->const_val == 0 ) lval->stage_add = start ;
/* djm, load double reg for long operators */
                        if (lval->val_type == LONG || lval2->val_type==LONG )
                        {
                              vlongconst(lval2->const_val);
                              lval2->val_type=LONG;
                        }
                        else vconst(lval2->const_val) ;
                        dcerror(lval) ;
                        if (lval2->const_val == 0 && (oper==zdiv || oper==zmod ) ) {
                                clearstage(start,0);
                                if (lval->val_type==LONG) { Zsp +=4;  vlongconst(0); }
                                else { vconst(0); Zsp+=2; }
                                warning(W_DIVZERO);
                                return;
                        }


                }
                if ( lval->val_type != DOUBLE && lval2->val_type != DOUBLE && lval->val_type != LONG && lval2->val_type !=LONG && lval->val_type !=CPTR && lval2->val_type !=CPTR )
/* Dodgy? */
                        zpop() ;
        }
        lval->is_const &= lval2->is_const ;
        /* ensure that operation is valid for double */
        if ( doper == 0 ) intcheck(lval, lval2) ;
        if ( widen(lval, lval2) ) {
                (*doper)(lval);
                /* result of comparison is int */
                if( doper != mult && doper != zdiv )
                        lval->val_type = CINT;
                return;
        }
/* Attempt to compensate width, so that we are doing double oprs if
 * one of the expressions is a double
 */
        if ( !lval->is_const ) widenlong(lval, lval2);
        if ( lval->ptr_type || lval2->ptr_type ) {
                (*oper)(lval);
//                if (lval->val_type == CPTR) zpop(); /* rest top bits */
                lval->binop = oper ;
                return;
        }
/* Moved unsigned thing to below, so can fold expr correctly! */

        if ( (lval2->symbol && lval2->symbol->ident == POINTER) ) {
                    (*oper)(lval);
                    lval->binop = oper ;
                    return;
        }
        if ( lval->is_const ) {
                /* both operands constant taking respect of sign now,
                 * unsigned takes precedence.. 
                 */
                if ( (lval->flags&UNSIGNED) || (lval2->flags&UNSIGNED) )
                        lval->const_val = calcun(lval->const_val, oper, lval2->const_val) ;
                else
                        lval->const_val = calc(lval->const_val, oper, lval2->const_val) ;
                clearstage(before, 0) ;
        }
        else {
                /* one or both operands not constant */


/* djm, if we have a constant and a proper lvalue, then set the flags of
 * const to equal the signedness of the lvalue. This *will* cause 
 * problems if we allow specifiers after numbers
 */
        if (lval->is_const) lval->flags=(lval->flags&MKSIGN)|(lval2->flags&UNSIGNED);
        if (lval2->is_const) lval2->flags=(lval2->flags&MKSIGN)|(lval->flags&UNSIGNED);

/* There's some weird precedence happening here! If the ->& bits are
 * not placed in brackets then this expression sometime comes out to
 * be false when it should be true : i.e. 0 != 1 -> false, 1 != 0 -> true
 */
                if ((lval->flags&UNSIGNED) !=( lval2->flags&UNSIGNED) && (oper==zmod || oper==mult || oper==zdiv)) 
                        warning(W_OPSG);

/* Special case for multiplication by constant... */

                if (oper==mult && (lval2->is_const) && (lval->val_type ==CINT || lval->val_type==CCHAR) ){
                        clearstage(before,0);
                        quikmult(lval2->const_val,NO);
                        return;
                }
                (*oper)(lval);
                lval->binop = oper ;
        }
}

/*
 * binary plunge to lower level (for +/-)
 */
void plnge2b(heir, lval, lval2, oper)
int (*heir)() ;
LVALUE *lval, *lval2 ;
void (*oper)();
{
        char *before, *start, *before1, *start1 ;
        int val ;

        setstage(&before, &start) ;
        if ( lval->is_const ) {
                /* constant on left not yet loaded */
                if ( plnge1(heir, lval2) ) rvalue(lval2) ;
                val = lval->const_val ;
                if ( dbltest(lval2, lval) ) {
                        /* are adding lval to pointer, adjust size */
                        cscale(lval2->ptr_type, lval2->tagsym, &val) ;
                }
		if (lval->val_type == LONG) {
			widenlong(lval,lval2);
			doexx();
			vlongconst(val);
			lpush();
			doexx();
		} else {
                	const2(val) ;
		}
                dcerror(lval2) ;
        }
        else {
                /* non-constant on left */
                setstage(&before1, &start1) ;
                if ( lval->val_type == DOUBLE ) dpush() ;
                else if (lval->val_type == LONG || lval->val_type==CPTR) lpush() ;
/* Long ptrs? */
                else zpush() ;
                if ( plnge1(heir, lval2) ) rvalue(lval2) ;
                if ( lval2->is_const ) {
                        /* constant on right */
                        val = lval2->const_val ;
                        if ( dbltest(lval, lval2) ) {
                                /* are adding lval2 to pointer, adjust size */
                                cscale(lval->ptr_type, lval->tagsym, &val) ;
                        }
                        if ( oper == zsub ) {
                                /* addition on Z80 is cheaper than subtraction */
                                val = (-val) ;
                                /* skip later diff scaling - constant can't be pointer */
                                oper = zadd ;
                        }
                        /* remove zpush and add int constant to int */
                        clearstage(before1, 0) ;
                        Zsp += 2 ; 
                        if ( lval->val_type == LONG || lval->val_type==CPTR) Zsp +=2;
                        addconst(val,0,0) ;
                        dcerror(lval) ;
                }
                else {
                        /* non-constant on both sides or double +/- int const */
                        if (dbltest(lval,lval2))
                        scale(lval->ptr_type, lval->tagsym);
                        if ( widen(lval, lval2) ) {
                                /* floating point operation */
                                (*oper)(lval);
                                lval->is_const = 0 ;
                                return ;
                        }
                        else {
                        widenlong(lval, lval2) ;
                                /* non-constant integer operation */
                        if (lval->val_type != LONG && lval->val_type !=CPTR ) zpop();
                                if ( dbltest(lval2, lval) ) {
                                swap();
                                        scale(lval2->ptr_type, lval2->tagsym) ;
                                        /* subtraction not commutative */
                                        if (oper == zsub) swap();
                                }
                        }
                }
        }
        if ( lval->is_const &= lval2->is_const ) {
                /* both operands constant */
                if (oper == zadd) lval->const_val += lval2->const_val ;
                else if (oper == zsub) lval->const_val -= lval2->const_val ;
                else lval->const_val = 0 ;
                clearstage(before, 0) ;
        }
        else if (lval2->is_const == 0) {
                /* right operand not constant */
        	(*oper)(lval);
        }
        if (oper == zsub && lval->ptr_type ) {
                /* scale difference between pointers */
/* djm...preserve our pointer high 8 bits? */
		if (lval->type == CPTR ){
			lval->val_type=CPTR;
			ltype=LONG;
		} else {
                	lval->val_type=CINT;    /* operate on pointers as ints */
                	ltype=CINT;             /* dodgy maybe 24/4/99 */
		}
                if( lval->ptr_type == CINT && lval2->ptr_type == CINT ) {
                        swap();
                        vconst(1) ;
                        asr(lval); /*  div by 2  */
                }
                else if ( lval->ptr_type == CPTR && lval2->ptr_type == CPTR) {
                        swap();
                        vconst(3);
                        zdiv(lval);
                }
                else if( lval->ptr_type == LONG && lval2->ptr_type == LONG) {
                        swap();
                        vconst(2);
                        asr(lval);  /* div by 4 */
                }
                else if( lval->ptr_type == DOUBLE && lval2->ptr_type == DOUBLE ) {
                        swap();
                        vconst(6) ;
                        zdiv(lval); /* div by 6 */
                }
                else if ( lval->ptr_type == STRUCT && lval2->ptr_type == STRUCT ) {
                        swap() ;
                        vconst(lval->tagsym->size) ;
                        zdiv(lval) ;
                }
        }
    result(lval,lval2);
}
