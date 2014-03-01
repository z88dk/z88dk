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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.c,v 1.4 2014-03-01 15:45:31 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "expr.h"
#include "errors.h"

/*-----------------------------------------------------------------------------
*	Types of operators and associativity
*----------------------------------------------------------------------------*/
enum OperType	{ UNARY_OP, BINARY_OP };
enum AssocType	{ ASSOC_LEFT, ASSOC_RIGHT };

/*-----------------------------------------------------------------------------
*	Calculation functions that need to check arguments
*----------------------------------------------------------------------------*/
long calc_divide ( long a, long b )
{
	if ( b == 0 )
		fatal_divide_by_zero();	/* BUG_0040 */
	return a / b;
}

long calc_mod ( long a, long b )
{
	if ( b == 0 )
		fatal_divide_by_zero();	/* BUG_0040 */
	return a % b;
}

/* exponentiation by squaring */
long calc_power(long base, long exp)
{
    long result = 1;

	if (exp < 0)
		return 0;	/* BUG_0041 */

    while (exp)
    {
        if (exp & 1)
            result *= base;
        exp >>= 1;
        base *= base;
    }

    return result;
}

/*-----------------------------------------------------------------------------
*	Define calc functions for all operators, template:
*	static long f_<symbol> (long a, long b) { return <calc>; }
*----------------------------------------------------------------------------*/
#define OPERATOR(_symbol, _operation, _type, _prec, _assoc, _calc)	\
	static long f_##_operation ( long a, long b ) { return _calc; }
#include "expr_def.h"

#if 0



/*-----------------------------------------------------------------------------
*	Stack of values used for expression computation
*----------------------------------------------------------------------------*/
DEF_ARRAY( long );

/*-----------------------------------------------------------------------------
*	Class to hold one parsed expression
*----------------------------------------------------------------------------*/
DEF_CLASS( Expr )

void Expr_init (Expr *self) 
{ 
	
}

void Expr_copy (Expr *self, Expr *other)
{
	
}

void Expr_fini (Expr *self)
{ 
	
}
#endif

/*
* $Log: expr.c,v $
* Revision 1.4  2014-03-01 15:45:31  pauloscustodio
* CH_0021: New operators ==, !=, &&, ||, <<, >>, ?:
* Handle C-like operators, make exponentiation (**) right-associative.
* Simplify expression parser by handling composed tokens in lexer.
* Change token ids to TK_...
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
