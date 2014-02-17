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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.c,v 1.1 2014-02-17 23:36:07 pauloscustodio Exp $
*/

#include "xmalloc.h"   /* before any other include */

#include "expr.h"

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
* Revision 1.1  2014-02-17 23:36:07  pauloscustodio
* Embryo of new expression parser
*
*
*/
