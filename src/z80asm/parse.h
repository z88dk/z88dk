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

Copyright (C) Paulo Custodio, 2011-2014

Define ragel-based parser. 

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse.h,v 1.10 2015-01-17 14:02:03 pauloscustodio Exp $ 
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
		SM_DEFVARS_OPEN, SM_DEFVARS_LINE,
		SM_DEFGROUP_OPEN, SM_DEFGROUP_LINE
	} current_sm;					/* current parser state machine */

	int cs;							/* current state */

	UT_array *tokens;				/* array of tokens in the current statement */
	Sym *p, *pe, *eof, *expr_start;	/* point into array */

	UT_array *token_strings;		/* strings saved from the current statement */
	UT_array *exprs;				/* array of expressions computed during parse */

	int  expr_value;				/* last computed expression value */
	Bool expr_error;				/* last computed expression error */
	Bool expr_in_parens;			/* true if expression has enclosing parens */
	int  expr_open_parens;			/* number of open parens */
} ParseCtx;

/* create a new parse context */
extern ParseCtx *ParseCtx_new(void);

/* detele the parse context */
extern void ParseCtx_delete(ParseCtx *ctx);

/* parse the given assembly file, return FALSE if failed */
extern Bool parse_file(char *filename);

/* try to parse the current statement, return FLASE if failed;
*  compile_active is FALSE on the FALSE branch of an IF-ELSE-ENDIF */
extern Bool parse_statement(ParseCtx *ctx, Bool compile_active);

/* save the current scanner context and parse the given expression */
extern struct Expr *parse_expr(char *expr_text);

/* return new auto-label in strpool */
extern char *autolabel(void);
