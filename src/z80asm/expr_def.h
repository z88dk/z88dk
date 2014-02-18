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

Define expression operators

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr_def.h,v 1.2 2014-02-18 22:59:06 pauloscustodio Exp $
*/

#if 0
#ifndef OPERATOR
#define OPERATOR(_symbol, _type, _prec, _assoc, _calc)
#endif

/* define list of operators */
OPERATOR( negated,	UNARY_OP,	4,	ASSOC_RIGHT,	- a )
OPERATOR( log_not,	UNARY_OP,	4,	ASSOC_RIGHT,	! a )
OPERATOR( bin_not,	UNARY_OP,	4,	ASSOC_RIGHT,	~ a )

#undef OPERATOR
#endif

/*
* $Log: expr_def.h,v $
* Revision 1.2  2014-02-18 22:59:06  pauloscustodio
* BUG_0040: Detect and report division by zero instead of crashing
* BUG_0041: truncate negative powers to zero, i.e. pow(2,-1) == 0
*
* Revision 1.1  2014/02/17 23:41:35  pauloscustodio
* Embryo of new expression parser
*
* 
*/
