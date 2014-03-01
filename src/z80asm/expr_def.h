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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr_def.h,v 1.4 2014-03-01 15:45:31 pauloscustodio Exp $
*/

#ifndef OPERATOR
#define OPERATOR(_symbol, _operation, _type, _prec, _assoc, _calc)
#endif

/* define list of operators in increasing priority*/
OPERATOR( TK_LOG_OR,		TK_LOG_OR,		BINARY_OP,	1,	ASSOC_LEFT,		a || b )

OPERATOR( TK_LOG_AND,		TK_LOG_AND,		BINARY_OP,	2,	ASSOC_LEFT,		a && b )

OPERATOR( TK_BIN_OR,		TK_BIN_OR,		BINARY_OP,	3,	ASSOC_LEFT,		a | b )
OPERATOR( TK_BIN_XOR,		TK_BIN_XOR,		BINARY_OP,	3,	ASSOC_LEFT,		a ^ b )

OPERATOR( TK_BIN_AND,		TK_BIN_AND,		BINARY_OP,	4,	ASSOC_LEFT,		a & b )

OPERATOR( TK_EQUAL,			TK_EQUAL,		BINARY_OP,	5,	ASSOC_LEFT,		a == b )
OPERATOR( TK_LESS,			TK_LESS,		BINARY_OP,	5,	ASSOC_LEFT,		a <  b )
OPERATOR( TK_GREATER,		TK_GREATER,		BINARY_OP,	5,	ASSOC_LEFT,		a >  b )
OPERATOR( TK_LESS_EQ,		TK_LESS_EQ,		BINARY_OP,	5,	ASSOC_LEFT,		a <= b )
OPERATOR( TK_GREATER_EQ,	TK_GREATER_EQ,	BINARY_OP,	5,	ASSOC_LEFT,		a >= b )
OPERATOR( TK_NOT_EQ,		TK_NOT_EQ,		BINARY_OP,	5,	ASSOC_LEFT,		a != b )

OPERATOR( TK_LEFT_SHIFT,	TK_LEFT_SHIFT,	BINARY_OP,	6,	ASSOC_LEFT,		a << b )
OPERATOR( TK_RIGHT_SHIFT,	TK_RIGHT_SHIFT,	BINARY_OP,	6,	ASSOC_LEFT,		a >> b )

OPERATOR( TK_PLUS,			TK_PLUS,		BINARY_OP,	7,	ASSOC_LEFT,		a + b )
OPERATOR( TK_MINUS,			TK_MINUS,		BINARY_OP,	7,	ASSOC_LEFT,		a - b )

OPERATOR( TK_MULTIPLY,		TK_MULTIPLY,	BINARY_OP,	8,	ASSOC_LEFT,		a * b )
OPERATOR( TK_DIVIDE,		TK_DIVIDE,		BINARY_OP,	8,	ASSOC_LEFT,		calc_divide(a, b) )
OPERATOR( TK_MOD,			TK_MOD,			BINARY_OP,	8,	ASSOC_LEFT,		calc_mod(a, b) )

OPERATOR( TK_POWER,			TK_POWER,		BINARY_OP,	9,	ASSOC_RIGHT,	calc_power(a, b) )

OPERATOR( TK_MINUS,			TK_NEGATE,		UNARY_OP,	10,	ASSOC_RIGHT,	- a )
OPERATOR( TK_PLUS,			TK_IDENTITY,	UNARY_OP,	10,	ASSOC_RIGHT,	  a )
OPERATOR( TK_BIN_NOT,		TK_BIN_NOT,		UNARY_OP,	10,	ASSOC_RIGHT,	~ a )
OPERATOR( TK_LOG_NOT,		TK_LOG_NOT,		UNARY_OP,	10,	ASSOC_RIGHT,	! a )

#undef OPERATOR

/*
* $Log: expr_def.h,v $
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
* Revision 1.1  2014/02/17 23:41:35  pauloscustodio
* Embryo of new expression parser
*
* 
*/
