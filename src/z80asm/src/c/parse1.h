/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2024
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define ragel-based parser. 
*/

#pragma once

#include "scan1.h"
#include "types.h"
#include "utarray.h"

struct Expr1;

/*-----------------------------------------------------------------------------
* 	Current parse context
*----------------------------------------------------------------------------*/
typedef struct ParseCtx
{
	enum {
		SM_MAIN,
		SM_SKIP,					/* in false branch of an IF, skip */
		SM_DEFVARS_OPEN, SM_DEFVARS_LINE,
		SM_DEFGROUP_OPEN, SM_DEFGROUP_LINE,
		SM_DMA_PARAMS
	} current_sm;					/* current parser state machine */

	int cs;							/* current state */

	UT_array *tokens;				/* array of tokens in the current statement */
    Sym *p, *pe, *eof_, *expr_start;	/* point into array */

	UT_array *token_strings;		/* strings saved from the current statement */
	UT_array *exprs;				/* array of expressions computed during parse */

	int dma_cmd;					/* current DMA command */
    int expr_value;			        /* last computed expression value */
    bool expr_error;		        /* last computed expression error */
    bool expr_in_parens;	        /* true if expression has enclosing parens */
} ParseCtx;

/* create a new parse context */
extern ParseCtx *ParseCtx_new(void);

/* detele the parse context */
extern void ParseCtx_delete(ParseCtx *ctx);

/* parse the given assembly file, return false if failed */
extern void parse_file(const char *filename);

/* try to parse the current statement, return false if failed */
extern bool parse_statement(ParseCtx *ctx);

/* save the current scanner context and parse the given expression */
extern struct Expr1 *parse_expr(const char *expr_text);
extern void parse_const_expr_eval(const char* expr_text, int* result, bool* got_error);
extern void parse_expr_eval_if_condition(const char *expr_text, bool* condition, bool* got_error);

/* push current expression */
void push_expr(ParseCtx* ctx);

/* Pop and return expression */
struct Expr1* pop_expr(ParseCtx* ctx);

/* Pop and compute expression, issue error on failure */
void pop_eval_expr(ParseCtx* ctx, int* pvalue, bool* perror);

/* check IF conditions */
extern bool check_if_condition(struct Expr1 *expr);
extern bool check_ifdef_condition(const char *name);

/* return new auto-label in strpool */
extern const char *autolabel(void);
