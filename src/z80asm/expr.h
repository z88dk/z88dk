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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.h,v 1.9 2014-03-15 02:12:07 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "array.h"
#include "class.h"
#include "symbol.h"
#include "token.h"
#include "strutil.h"

/*-----------------------------------------------------------------------------
*	Types of operations and associativity
*----------------------------------------------------------------------------*/
typedef enum 
{ 
	NUMBER_OP, NAME_OP, CONST_EXPR_OP, 
	UNARY_OP, BINARY_OP, TERNARY_OP,
} op_type_t;
typedef enum { ASSOC_NONE, ASSOC_LEFT, ASSOC_RIGHT } assoc_t;

/*-----------------------------------------------------------------------------
*	Calculation functions for all operators, template:
*	long calc_<symbol> (long a [, long b [, long c ] ] );
*----------------------------------------------------------------------------*/
#define OPERATOR(_operation, _tok, _type, _prec, _assoc, _args, _calc)	\
	extern long calc_##_operation _args;
#include "expr_def.h"

/*-----------------------------------------------------------------------------
*	Operator descriptors
*----------------------------------------------------------------------------*/
typedef struct Operator
{
	tokid_t		tok;				/* symbol */
	op_type_t	op_type;			/* UNARY_OP, BINARY_OP, TERNARY_OP */
	int			prec;				/* precedence lowest (1) to highest (N) */
	assoc_t		assoc;				/* left or rigth association */
	union
	{
		long (*unary)(long a);						/* compute unary operator */			
		long (*binary)(long a, long b);				/* compute binary operator */
		long (*ternary)(long a, long b, long c);	/* compute ternary operator */
	} calc;
} Operator;

/* get the operator descriptor for the given (sym, op_type) */
extern Operator *Operator_get( tokid_t tok, op_type_t op_type );

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
extern void Calc_push( long value );
extern long Calc_pop( void );
extern void Calc_compute_unary(   long (*calc)(long a) );
extern void Calc_compute_binary(  long (*calc)(long a, long b) );
extern void Calc_compute_ternary( long (*calc)(long a, long b, long c) );

/*-----------------------------------------------------------------------------
*	Expression operations
*----------------------------------------------------------------------------*/
typedef struct ExprOp				/* hold one operation or operand */
{
	op_type_t	op_type;			/* select type of operator / operand */
	union
	{
		/* NUMBER_OP */
		long	value;				/* operand value */

		/* NAME_OP */
		struct 
		{
			char   *name;			/* name of identifier, stored in strpool */
			byte_t	sym_type;		/* type of identifier (local, global, rel. address or constant) */
		} ident;

		/* CONST_EXPR_OP - no data */
		
		/* UNARY_OP, BINARY_OP, TERNARY_OP */
		Operator *op;				/* static struct, retrieved by Operator_get() */
	} d;
} ExprOp;

ARRAY( ExprOp );					/* hold list of Expr operations/operands */

/* init each type of ExprOp */
extern void ExprOp_init_number(     ExprOp *self, long value );
extern void ExprOp_init_name(       ExprOp *self, char *name, byte_t sym_type );
extern void ExprOp_init_const_expr( ExprOp *self );
extern void ExprOp_init_operator(   ExprOp *self, tokid_t tok, op_type_t op_type );

/*-----------------------------------------------------------------------------
*	Expression
*----------------------------------------------------------------------------*/


#if 0
struct postfixlist
{
    struct postfixlist *nextoperand;	/* pointer to next element in postfix expression */
    long               operandconst;
    tokid_t			   operatortype;
    char              *id;				/* pointer to identifier */
    byte_t			   sym_type;		/* type of identifier (local, global, rel. address or constant) */
};
#endif

struct expr
{
    struct expr        *nextexpr;		/* pointer to next expression */

	ExprOpArray		*rpn_ops;			/* list of operands / operators in reverse polish notation */
	Str				*text;				/* expression in infix text */

	byte_t			   expr_type;		/* range type of evaluated expression */
    enum flag          stored;			/* Flag to indicate that expression has been stored to object file */
    uint_t             codepos;			/* rel. position in module code to patch (in pass 2) */
    char               *srcfile;		/* expr. in file 'srcfile' - allocated name area deleted by ReleaseFile */
    int                curline;			/* expression in line of source file */
    long               listpos;			/* position in listing file to patch (in pass 2) */
};

struct expression
{
    struct expr        *firstexpr;		/* header of list of expressions in current module */
    struct expr        *currexpr;
};

/* compute ExprOp using Calc_xxx functions */
extern void ExprOp_compute( ExprOp *self, struct expr *pfixlist );




#if 0

CLASS( Expr )

END_CLASS
#endif

/*
* $Log: expr.h,v $
* Revision 1.9  2014-03-15 02:12:07  pauloscustodio
* Rename last token to tok*
* GetSym() declared in scan.h
*
* Revision 1.8  2014/03/06 00:18:43  pauloscustodio
* BUG_0043: buffer overflow on constants longer than 128 chars in object file
* z80asm crashed when the expression to be stored in the obejct file was
* longer than the maximum allocated size (128). Changed to dynamic string.
*
* Revision 1.7  2014/03/04 11:49:47  pauloscustodio
* Expression parser and expression evaluator use a look-up table of all
* supported unary, binary and ternary oprators, instead of a big switch
* statement to select the operation.
* Expression operations are stored in a contiguous array instead of
* a liked list to reduce administrative overhead of adding / iterating.
*
* Revision 1.6  2014/03/03 13:43:50  pauloscustodio
* Renamed symbol and expression type attributes
*
* Revision 1.5  2014/03/03 02:44:15  pauloscustodio
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
