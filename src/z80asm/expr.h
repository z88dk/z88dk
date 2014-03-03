/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2014

Expression parser based on the shunting-yard algoritm, 
see http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.h,v 1.5 2014-03-03 02:44:15 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "array.h"
#include "class.h"
#include "symbol.h"
#include "token.h"

/*-----------------------------------------------------------------------------
*	Calculation functions for all operators, template:
*	long f_<symbol> (long a [, long b [, long c ] ] );
*----------------------------------------------------------------------------*/
#define OPERATOR(_operation, _symbol, _type, _prec, _assoc, _args, _calc)	\
	extern long calc_ ## _operation _args;
#include "expr_def.h"

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
extern void Calc_push( long value );
extern long Calc_pop( void );
extern void Calc_compute_unary(   long (*calc)(long a) );
extern void Calc_compute_binary(  long (*calc)(long a, long b) );
extern void Calc_compute_ternary( long (*calc)(long a, long b, long c) );

#if 0
/*-----------------------------------------------------------------------------
*	Class to hold one parsed expression
*----------------------------------------------------------------------------*/
typedef struct ExprOp					/* hold one operation or operand */
{
    tokid_t		operatortype;		
    long		operandconst;		/* hold constant */
    char	   *id;					/* identifier name kept in strpool */
    byte_t		type;				/* type of identifier (local, global, rel. address or constant) */
} ExprOp;

ARRAY( ExprOp )						/* hold list of Expr operations/operands */

CLASS( Expr )

END_CLASS
#endif

/*
* $Log: expr.h,v $
* Revision 1.5  2014-03-03 02:44:15  pauloscustodio
* Division by zero error was causing memory leaks - made non-fatal.
* Moved calculator stack to expr.c, made it singleton and based on array.h - no
* need to allocate on every expression computed, elements are stored in
* a vector instead of being allocated individually.
*
* Revision 1.4  2014/02/24 23:08:55  pauloscustodio
* Rename "enum symbols" to "tokid_t", define in token.h
*
* Revision 1.3  2014/02/23 18:48:16  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, ?:
* Handle C-like operators ==, !=, &&, || and ?:.
* Simplify expression parser by handling composed tokens in lexer.
*
* Revision 1.2  2014/02/18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.1  2014/02/17 23:36:07  pauloscustodio
* Embryo of new expression parser
*
*
*/
