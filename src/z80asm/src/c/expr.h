/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Expression parser based on the shunting-yard algoritm,
see http://www.engr.mun.ca/~theo/Misc/exp_parsing.htm
*/

#pragma once

#include "array.h"
#include "class.h"
#include "classlist.h"
#include "scan.h"
#include "sym.h"
#include "utarray.h"

struct Module;
struct Section;

/*-----------------------------------------------------------------------------
*	UT_array of Expr*
*----------------------------------------------------------------------------*/
extern UT_icd ut_exprs_icd;

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
extern Operator* Operator_get(tokid_t tok, op_type_t op_type);

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
		Symbol* symbol;				/* symbol in symbol table */

		/* CONST_EXPR_OP - no data */

		/* UNARY_OP, BINARY_OP, TERNARY_OP */
		Operator* op;				/* static struct, retrieved by Operator_get() */
	} d;
} ExprOp;

ARRAY(ExprOp);					/* hold list of Expr operations/operands */

/*-----------------------------------------------------------------------------
*	Expression range
*----------------------------------------------------------------------------*/
typedef enum {
	RANGE_JR_OFFSET = 1,
	RANGE_BYTE_UNSIGNED,
	RANGE_BYTE_SIGNED,
	RANGE_WORD,						// 16-bit value little-endian
	RANGE_WORD_BE,					// 16-bit value big-endian
	RANGE_DWORD,
	RANGE_BYTE_TO_WORD_UNSIGNED,    // unsigned byte extended to 16 bits
	RANGE_BYTE_TO_WORD_SIGNED,      // signed byte sign-extended to 16 bits
	RANGE_PTR24,					// 24-bit pointer
	RANGE_HIGH_OFFSET,				// byte offset to 0xFF00 
} range_t;

/* return size in bytes of value of given range */
extern int range_size(range_t range);

/*-----------------------------------------------------------------------------
*	Expression
*----------------------------------------------------------------------------*/
CLASS(Expr)
ExprOpArray* rpn_ops;			/* list of operands / operators in reverse polish notation */
Str*		text;				/* expression in infix text */

/* flags set during eval */
struct {
	bool not_evaluable : 1;		/* true if expression did not retunr a value */
	bool undefined_symbol : 1;	/* true if expression contains one undefined symbol */
	bool extern_symbol : 1;		/* true if expression contains one EXTERN symbol */
	bool cross_section_addr : 1;/* true if expression referred to symbol on another section */
} result;

range_t		 range;				/* range of expression result */

sym_type_t	 type;				/* highest type of symbols used in expression */
bool		 is_computed : 1;	/* true if all values in expression have been computed */

const char* target_name;		/* name of the symbol, stored in strpool,
								* to receive the result value of the expression
								* computation, NULL if not an EQU expression */

struct Module* module;			/* module where expression is patched (weak ref) */
struct Section* section;		/* section where expression is patched (weak ref) */
int			asmpc;				/* ASMPC value during linking */
int			code_pos;			/* Address to patch expression value */

const char* filename;			/* file and line where expression defined, string in strpool */
int			 line_num;			/* source line */
long		 listpos;			/* position in listing file to patch (in pass 2), -1 if not listing */
END_CLASS;

CLASS_LIST(Expr);					/* list of expressions */

/* compute ExprOp using Calc_xxx functions */
extern void ExprOp_compute(ExprOp* self, Expr* expr, bool not_defined_error);

/* parse expression at current input, return new Expr object;
   return NULL and issue syntax error on error */
extern Expr* expr_parse(void);

/* evaluate expression if possible, set result.not_evaluable if failed
   e.g. symbol not defined; show error messages if not_defined_error */
extern long Expr_eval(Expr* self, bool not_defined_error);

/* check if all variables used in an expression are local to the same module
   and section; if yes, the expression can be computed in phase 2 of the compile,
   if not the expression must be passed to the link phase */
extern bool Expr_is_local_in_section(Expr* self, struct Module* module, struct Section* section);

/* check if the expression refers to more than one address expression; if yes,
   it needs to be computed at link time */
extern bool Expr_without_addresses(Expr* self);

/* check if expression depends on itself */
extern bool Expr_is_recusive(Expr* self, const char* name);

/*-----------------------------------------------------------------------------
*	Stack for calculator
*----------------------------------------------------------------------------*/
extern void Calc_push(long value);
extern long Calc_pop(void);
extern void Calc_compute_unary(long (*calc)(long a));
extern void Calc_compute_binary(long (*calc)(long a, long b));
extern void Calc_compute_ternary(long (*calc)(long a, long b, long c));
