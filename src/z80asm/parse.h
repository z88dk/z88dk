/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define ragel-based parser. 
*/

#pragma once

#include "scan.h"
#include "types.h"
#include "utarray.h"

struct Expr;

/*-----------------------------------------------------------------------------
* 	Current parse context
*----------------------------------------------------------------------------*/
typedef struct ParseCtx
{
	enum {
		SM_MAIN,
		SM_SKIP,					/* in FALSE branch of an IF, skip */
		SM_DEFVARS_OPEN, SM_DEFVARS_LINE,
		SM_DEFGROUP_OPEN, SM_DEFGROUP_LINE
	} current_sm;					/* current parser state machine */

	int cs;							/* current state */

	UT_array *tokens;				/* array of tokens in the current statement */
	Sym *p, *pe, *eof, *expr_start;	/* point into array */

	UT_array *token_strings;		/* strings saved from the current statement */
	UT_array *exprs;				/* array of expressions computed during parse */
	UT_array *open_structs;			/* nested array of structures being parsed (IF/ENDIF,...) */
} ParseCtx;

/* create a new parse context */
extern ParseCtx *ParseCtx_new(void);

/* detele the parse context */
extern void ParseCtx_delete(ParseCtx *ctx);

/* parse the given assembly file, return FALSE if failed */
extern Bool parse_file(char *filename);

/* try to parse the current statement, return FALSE if failed */
extern Bool parse_statement(ParseCtx *ctx);

/* save the current scanner context and parse the given expression */
extern struct Expr *parse_expr(char *expr_text);

/* return new auto-label in strpool */
extern char *autolabel(void);
