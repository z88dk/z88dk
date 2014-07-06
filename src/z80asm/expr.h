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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.h,v 1.27 2014-07-06 22:48:53 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "array.h"
#include "class.h"
#include "classlist.h"
#include "scan.h"
#include "sym.h"
#include "strutil.h"

struct Module;
struct Section;

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
			Byte	sym_type_mask;		/* type of identifier (local, global, rel. address or constant) */
		} ident;

		/* CONST_EXPR_OP - no data */
		
		/* UNARY_OP, BINARY_OP, TERNARY_OP */
		Operator *op;				/* static struct, retrieved by Operator_get() */
	} d;
} ExprOp;

ARRAY( ExprOp );					/* hold list of Expr operations/operands */

/*-----------------------------------------------------------------------------
*	Expression range
*----------------------------------------------------------------------------*/
typedef enum {
	RANGE_JR_OFFSET = 1,
	RANGE_BYTE_UNSIGNED,
	RANGE_BYTE_SIGNED,
	RANGE_WORD,
	RANGE_DWORD,
} range_t;

/* return size in bytes of value of given range */
extern int range_size( range_t range );

/*-----------------------------------------------------------------------------
*	Expression
*----------------------------------------------------------------------------*/
CLASS( Expr )
	ExprOpArray	*rpn_ops;		/* list of operands / operators in reverse polish notation */
	Str			*text;			/* expression in infix text */
	
	range_t		 range;			/* range of expression result */

	sym_type_t	 sym_type;		/* highest type of symbols used in expression */

	Byte		 expr_type_mask;/* range type of evaluated expression */

	char		*target_name;	/* name of the symbol, stored in strpool, 
								   to receive the result value of the expression 
								   computation, NULL if not an EQU expression */

	struct Module  *module;		/* module where expression is patched (weak ref) */
	struct Section *section;	/* section where expression is patched (weak ref) */
	UInt		 asmpc;			/* ASMPC value during linking */
    UInt		 code_pos;		/* Address to patch expression value */

	char		*filename;		/* file and line where expression defined, string in strpool */
    int			 line_nr;		/* source line */
    long		 listpos;		/* position in listing file to patch (in pass 2), -1 if not listing */
END_CLASS;

CLASS_LIST( Expr );				/* list of expressions */

/* compute ExprOp using Calc_xxx functions */
extern void ExprOp_compute( ExprOp *self, Expr *expr );

/* parse expression at current input, return new Expr object;
   return NULL and issue syntax error on error */
extern Expr *expr_parse( void );

/* parse and eval an expression, 
   return FALSE and issue syntax error on parse error
   return FALSE and issue symbol not defined error on NOT_EVALUABLE */
extern Bool expr_parse_eval( long *presult );

/* parse and eval an expression as argument to IF, 
   return expression value, ignoring symbol-not-defined errors  */
extern long expr_parse_eval_if( void );

/* evaluate expression if possible, set NOT_EVALUABLE if failed
   e.g. symbol not defined */
extern long Expr_eval( Expr *self );

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
extern void Calc_push( long value );
extern long Calc_pop( void );
extern void Calc_compute_unary(   long (*calc)(long a) );
extern void Calc_compute_binary(  long (*calc)(long a, long b) );
extern void Calc_compute_ternary( long (*calc)(long a, long b, long c) );

extern Bool ExprSigned8( int listoffset );
extern Bool ExprUnsigned8( int listoffset );
extern Bool ExprAddress( int listoffset );
extern Bool ExprLong( int listoffset );
