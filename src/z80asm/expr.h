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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/expr.h,v 1.22 2014-06-02 22:29:13 pauloscustodio Exp $
*/

#pragma once

#include "xmalloc.h"   /* before any other include */
#include "array.h"
#include "class.h"
#include "classlist.h"
#include "scan.h"
#include "strutil.h"

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
			Byte	sym_type;		/* type of identifier (local, global, rel. address or constant) */
		} ident;

		/* CONST_EXPR_OP - no data */
		
		/* UNARY_OP, BINARY_OP, TERNARY_OP */
		Operator *op;				/* static struct, retrieved by Operator_get() */
	} d;
} ExprOp;

ARRAY( ExprOp );					/* hold list of Expr operations/operands */

/*-----------------------------------------------------------------------------
*	Expression
*----------------------------------------------------------------------------*/
CLASS( Expr )
	ExprOpArray	*rpn_ops;		/* list of operands / operators in reverse polish notation */
	Str			*text;			/* expression in infix text */
	Byte		 expr_type;		/* range type of evaluated expression */

	struct Section *section;	/* section where expression is patched (weak ref) */
	uint32_t	 asmpc;			/* ASMPC value during linking */
    uint32_t	 code_pos;		/* Address to patch expression value */

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

/*
* $Log: expr.h,v $
* Revision 1.22  2014-06-02 22:29:13  pauloscustodio
* Write object file in one go at the end of pass 2, instead of writing
* parts during pass 1 assembly. This allows the object file format to be
* changed more easily, to allow sections in a near future.
* Remove global variable objfile and CloseFiles().
*
* Revision 1.21  2014/06/01 22:16:50  pauloscustodio
* Write expressions to object file only in pass 2, to remove dupplicate code
* and allow simplification of object file writing code. All expression
* error messages are now output only during pass 2.
*
* Revision 1.20  2014/05/29 00:19:37  pauloscustodio
* CH_0025: Link-time expression evaluation errors show source filename and line number
* Object file format changed to version 04, to include the source file
* location of expressions in order to give meaningful link-time error messages.
*
* Revision 1.19  2014/05/25 12:55:03  pauloscustodio
* Link expressions to the section they refer to.
*
* Revision 1.18  2014/05/25 01:02:29  pauloscustodio
* Byte, Int, UInt added
*
* Revision 1.17  2014/05/17 14:27:12  pauloscustodio
* Use C99 integer types
*
* Revision 1.16  2014/05/06 22:17:37  pauloscustodio
* Made types all-caps to avoid conflicts with /usr/include/i386-linux-gnu/sys/types.h
*
* Revision 1.15  2014/05/02 21:34:58  pauloscustodio
* byte_t and uint_t renamed to Byte, uint32_t
*
* Revision 1.14  2014/04/22 23:32:42  pauloscustodio
* Release 2.2.0 with major fixes:
*
* - Object file format changed to version 03, to include address of start
* of the opcode of each expression stored in the object file, to allow
* ASMPC to refer to the start of the opcode instead of the patch pointer.
* This solves long standing BUG_0011 and BUG_0048.
*
* - ASMPC no longer stored in the symbol table and evaluated as a separate
* token, to allow expressions including ASMPC to be relocated. This solves
* long standing and never detected BUG_0047.
*
* - Handling ASMPC during assembly simplified - no need to call inc_PC() on
* every assembled instruction, no need to store list of JRPC addresses as
* ASMPC is now stored in the expression.
*
* BUG_0047: Expressions including ASMPC not relocated - impacts call po|pe|p|m emulation in RCMX000
* ASMPC is computed on zero-base address of the code section and expressions
* including ASMPC are not relocated at link time.
* "call po, xx" is emulated in --RCMX000 as "jp pe, ASMPC+3; call xx".
* The expression ASMPC+3 is not marked as relocateable, and the resulting
* code only works when linked at address 0.
*
* BUG_0048: ASMPC used in JP/CALL argument does not refer to start of statement
* In "JP ASMPC", ASMPC is coded as instruction-address + 1 instead
* of instruction-address.
*
* BUG_0011 : ASMPC should refer to start of statememnt, not current element in DEFB/DEFW
* Bug only happens with forward references to relative addresses in expressions.
* See example from zx48.asm ROM image in t/BUG_0011.t test file.
* Need to change object file format to correct - need patchptr and address of instruction start.
*
* Revision 1.13  2014/04/18 17:46:18  pauloscustodio
* - Change struct expr to Expr class, use CLASS_LIST instead of linked list
*   manipulating.
* - Factor parsing and evaluating contants.
* - Factor symbol-not-defined error during expression evaluation.
* - Store module name in strpool instead of xstrdup/xfree.
*
* Revision 1.12  2014/04/12 11:57:02  pauloscustodio
* whitespace
*
* Revision 1.11  2014/04/06 23:29:26  pauloscustodio
* Removed lookup functions in token.c, no longer needed with the ragel based scanner.
* Moved the token definitions from token_def.h to scan_def.h.
*
* Revision 1.10  2014/03/29 00:12:56  pauloscustodio
* Removed struct postfixlist
*
* Revision 1.9  2014/03/15 02:12:07  pauloscustodio
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
