/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Expression parser based on the shunting-yard algoritm, 
see http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
*/

#pragma once

#include "array.h"
#include "class.h"
#include "classlist.h"
#include "scan.h"
#include "sym.h"

struct Module;
struct Section;

/*-----------------------------------------------------------------------------
*	Types of operations and associativity
*----------------------------------------------------------------------------*/
typedef enum 
{ 
	ASMPC_OP, NUMBER_OP, SYMBOL_OP, CONST_EXPR_OP, 
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
		/* ASMPC_OP - no data */

		/* NUMBER_OP */
		long	value;				/* operand value */

		/* SYMBOL_OP */
		Symbol *symbol;				/* symbol in symbol table */

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
	ExprOpArray	*rpn_ops;			/* list of operands / operators in reverse polish notation */
	Str			*text;				/* expression in infix text */
	
	/* flags set during eval */
	struct {
		Bool not_evaluable:1;		/* TRUE if expression did not retunr a value */
		Bool undefined_symbol:1;	/* TRUE if expression contains one undefined symbol */
		Bool extern_symbol:1;		/* TRUE if expression contains one EXTERN symbol */
		Bool cross_section_addr:1;	/* TRUE if expression referred to symbol on another section */	
	} result;

	range_t		 range;			/* range of expression result */

	sym_type_t	 type;				/* highest type of symbols used in expression */
	Bool		 is_computed : 1;	/* TRUE if all values in expression have been computed */

	char		*target_name;		/* name of the symbol, stored in strpool, 
								    * to receive the result value of the expression 
								    * computation, NULL if not an EQU expression */

	struct Module  *module;			/* module where expression is patched (weak ref) */
	struct Section *section;		/* section where expression is patched (weak ref) */
	int		 asmpc;				/* ASMPC value during linking */
    int		 code_pos;			/* Address to patch expression value */

	char		*filename;			/* file and line where expression defined, string in strpool */
    int			 line_nr;			/* source line */
    long		 listpos;			/* position in listing file to patch (in pass 2), -1 if not listing */
END_CLASS;

CLASS_LIST( Expr );					/* list of expressions */

/* compute ExprOp using Calc_xxx functions */
extern void ExprOp_compute(ExprOp *self, Expr *expr, Bool not_defined_error);

/* parse expression at current input, return new Expr object;
   return NULL and issue syntax error on error */
extern Expr *expr_parse( void );

/* parse and eval an expression, 
   return FALSE and issue syntax error on parse error
   return FALSE and issue symbol not defined error on result.not_evaluable */
extern Bool expr_parse_eval( long *presult );

/* parse and eval an expression as argument to IF, 
   return expression value, ignoring symbol-not-defined errors  */
extern long expr_parse_eval_if( void );

/* evaluate expression if possible, set result.not_evaluable if failed
   e.g. symbol not defined; show error messages if not_defined_error */
extern long Expr_eval(Expr *self, Bool not_defined_error);

/* check if all variables used in an expression are local to the same module
   and section; if yes, the expression can be computed in phase 2 of the compile,
   if not the expression must be passed to the link phase */
extern Bool Expr_is_local_in_section(Expr *self, struct Module *module, struct Section *section);

/* check if the expression refers to more than one address expression; if yes, 
   it needs to be computed at link time */
extern Bool Expr_without_addresses(Expr *self);

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
extern void Calc_push( long value );
extern long Calc_pop( void );
extern void Calc_compute_unary(   long (*calc)(long a) );
extern void Calc_compute_binary(  long (*calc)(long a, long b) );
extern void Calc_compute_ternary( long (*calc)(long a, long b, long c) );
