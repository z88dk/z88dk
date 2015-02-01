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

Copyright (C) Paulo Custodio, 2011-2015

Define ragel-based parser. 

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse.c,v 1.32 2015-02-01 23:52:11 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "codearea.h"
#include "directives.h"
#include "expr.h"
#include "listfile.h"
#include "model.h"
#include "opcodes.h"
#include "parse.h"
#include "scan.h"
#include "strpool.h"
#include "sym.h"
#include "symtab.h"
#include "utarray.h"
#include <assert.h>
#include <ctype.h>

/*-----------------------------------------------------------------------------
* 	Array of tokens
*----------------------------------------------------------------------------*/
static UT_icd ut_Sym_icd = { sizeof(Sym), NULL, NULL, NULL };

/*-----------------------------------------------------------------------------
* 	Current open struct
*----------------------------------------------------------------------------*/
typedef struct OpenStruct
{
	tokid_t	open_tok;			/* open token - TK_IF, TK_ELSE, ... */
	char   *filename;			/* file and line where token found */
	int		line_nr;
	Bool	active : 1;			/* in TRUE branch of conditional compilation */
	Bool	parent_active : 1;	/* in TRUE branch of parent's conditional compilation */
} OpenStruct;

static UT_icd ut_OpenStruct_icd = { sizeof(OpenStruct), NULL, NULL, NULL };

/*-----------------------------------------------------------------------------
* 	Array of expressions computed during parse 
*----------------------------------------------------------------------------*/
void ut_exprs_init(void *elt) 
{
	Expr *expr = OBJ_NEW(Expr); 
	*((Expr **)elt) = expr; 
}

void ut_exprs_dtor(void *elt) 
{ 
	Expr *expr = *((Expr **)elt);  
	OBJ_DELETE(expr); 
}

UT_icd ut_exprs_icd = { sizeof(Expr *), ut_exprs_init, NULL, ut_exprs_dtor };

/*-----------------------------------------------------------------------------
* 	Current parse context
*----------------------------------------------------------------------------*/
ParseCtx *ParseCtx_new(void)
{
	ParseCtx *ctx = xnew(ParseCtx);

	utarray_new(ctx->tokens, &ut_Sym_icd);
	utarray_new(ctx->token_strings, &ut_str_icd);
	utarray_new(ctx->exprs, &ut_exprs_icd);
	utarray_new(ctx->open_structs, &ut_OpenStruct_icd);

	ctx->current_sm = SM_MAIN;

	return ctx;
}

void ParseCtx_delete(ParseCtx *ctx)
{
	utarray_free(ctx->exprs);
	utarray_free(ctx->token_strings);
	utarray_free(ctx->tokens);
	utarray_free(ctx->open_structs);
	xfree(ctx);
}

/*-----------------------------------------------------------------------------
*   Parse expression and push it to exprs
*----------------------------------------------------------------------------*/

/* save the current scanner context and parse the given expression */
struct Expr *parse_expr(char *expr_text)
{
	Expr *expr;
	int num_errors;

	save_scan_state();
	{
		src_push();
		{
			SetTemporaryLine(expr_text);
			num_errors = get_num_errors();
			EOL = FALSE;
			scan_expect_operands();
			GetSym();
			expr = expr_parse();		/* may output error */
			if (sym.tok != TK_END && num_errors == get_num_errors())
				error_syntax();
		}
		src_pop();
	}
	restore_scan_state();
	
	return expr;
}

/* push current expression */
static void push_expr(ParseCtx *ctx)
{
	static Str *expr_text;
	Expr *expr;
	Sym  *expr_p;
	Bool  last_was_prefix;

	INIT_OBJ(Str, &expr_text);

	/* build expression text - split constant prefixes from numbers and names */
	Str_clear(expr_text);
	last_was_prefix = FALSE;
	for (expr_p = ctx->expr_start; expr_p < ctx->p; expr_p++)
	{
		if (last_was_prefix && expr_p->tlen > 0 &&
			(isalnum(*expr_p->tstart) || *expr_p->tstart == '"'))
		{
			Str_append_char(expr_text, ' ');
			last_was_prefix = FALSE;
		}

		Str_append_n(expr_text, expr_p->tstart, expr_p->tlen);

		if (expr_p->tlen > 0)
		{
			switch (expr_p->tstart[expr_p->tlen - 1])
			{
			case '@':
			case '%':
			case '$':
				last_was_prefix = TRUE;
				break;

			default:
				last_was_prefix = FALSE;
			}
		}
	}
	
	/* parse expression */
	expr = parse_expr(expr_text->str);

	/* push the new expression, or NULL on error */
	utarray_push_back(ctx->exprs, &expr);
}

/*-----------------------------------------------------------------------------
*   Pop and return expression
*----------------------------------------------------------------------------*/
static Expr *pop_expr(ParseCtx *ctx)
{
	Expr *expr;

	expr = *((Expr **)utarray_back(ctx->exprs));
	*((Expr **)utarray_back(ctx->exprs)) = NULL;		/* do not destroy */
	
	utarray_pop_back(ctx->exprs);

	return expr;
}

/*-----------------------------------------------------------------------------
*   Pop and compute expression, issue error on failure
*----------------------------------------------------------------------------*/
static void pop_eval_expr(ParseCtx *ctx, int *pvalue, Bool *perror)
{
	Expr *expr;

	*pvalue = 0;
	*perror = FALSE;

	expr = pop_expr(ctx);
	if (expr == NULL)
	{
		*perror = TRUE;				/* error output by push_expr() */
		return;
	}

	/* eval and discard expression */
	*pvalue = Expr_eval(expr);
	*perror = (expr->result.not_evaluable);
	OBJ_DELETE(expr);

	/* check errors */
	if (*perror)
		error_not_defined();
}

/*-----------------------------------------------------------------------------
*   return new auto-label in strpool
*----------------------------------------------------------------------------*/
char *autolabel(void)
{
	static Str *label;
	static int n;

	INIT_OBJ(Str, &label);

	Str_sprintf(label, "__autolabel_%04d", ++n);
	return strpool_add(label->str);
}

/*-----------------------------------------------------------------------------
*   String pool for the current statement
*----------------------------------------------------------------------------*/
static char *token_strings_add(ParseCtx *ctx, char *str)
{
	if (!str)		/* NULL string */
		return NULL;

	utarray_push_back(ctx->token_strings, &str);
	return *((char **)utarray_back(ctx->token_strings));
}

/*-----------------------------------------------------------------------------
*   Read tokens from the current statement into tokensd[], to be parsed
*	by state machine
*----------------------------------------------------------------------------*/
static void read_token(ParseCtx *ctx)
{
	static Str *buffer;
	Sym sym_copy;
	int p_index;
	int expr_start_index;

	INIT_OBJ(Str, &buffer);

	p_index = ctx->p ? ctx->p - (Sym *)utarray_front(ctx->tokens) : -1;
	expr_start_index = ctx->expr_start ? ctx->expr_start - (Sym *)utarray_front(ctx->tokens) : -1;

	sym_copy = sym;

	/* make text to be used while concatenating tokens to build an expression to parse */
	switch (sym_copy.tok)
	{
	case TK_NUMBER:
		Str_sprintf(buffer, "%d", sym_copy.number);
		sym_copy.tstart = token_strings_add(ctx, buffer->str);
		sym_copy.tlen = buffer->len;
		break;

	case TK_NAME:
	case TK_LABEL:
	case TK_STRING:
		break;

	case TK_END:
		sym_copy.tstart = "";
		sym_copy.tlen = 0;
		break;

	default:;
//		if (!*(sym_copy.text))
//			assert(*(sym_copy.text));
	}
//	sym_copy.string = token_strings_add(sym.string);
	utarray_push_back(ctx->tokens, &sym_copy);

	ctx->p = (Sym *)utarray_front(ctx->tokens) + (p_index >= 0 ? p_index : 0);
	ctx->pe = (Sym *)utarray_back(ctx->tokens) + 1;

	if (sym.tok == TK_END)
		ctx->eof = ctx->pe;
	else
		ctx->eof = NULL;

	ctx->expr_start = expr_start_index >= 0 ? ((Sym *)utarray_front(ctx->tokens)) + expr_start_index : NULL;

	GetSym();
}

static void free_tokens(ParseCtx *ctx)
{
	utarray_clear(ctx->tokens);
	utarray_clear(ctx->token_strings);
	utarray_clear(ctx->exprs);
}

/*-----------------------------------------------------------------------------
*   IF, IFDEF, IFNDEF, ELSE, ENDIF
*----------------------------------------------------------------------------*/
static void start_struct(ParseCtx *ctx, tokid_t open_tok, Bool condition)
{
	OpenStruct *parent_os, os;

	os.open_tok = open_tok;
	os.filename = get_error_file();
	os.line_nr = get_error_line();
	os.active = condition;

	parent_os = (OpenStruct *)utarray_back(ctx->open_structs);
	if (parent_os)
		os.parent_active = parent_os->active && parent_os->parent_active;
	else
		os.parent_active = TRUE;

	utarray_push_back(ctx->open_structs, &os);
}

static Bool check_ifdef_condition(char *name)
{
	Symbol *symbol;

	symbol = find_symbol(name, CURRENTMODULE->local_symtab);
	if (symbol != NULL && ((symbol->sym_type_mask & SYM_DEFINED) || (symbol->sym_type_mask & SYM_EXTERN)))
		return TRUE;

	symbol = find_symbol(name, global_symtab);
	if (symbol != NULL && ((symbol->sym_type_mask & SYM_DEFINED) || (symbol->sym_type_mask & SYM_EXTERN)))
		return TRUE;

	return FALSE;
}

static void asm_IF(ParseCtx *ctx, Expr *expr)
{
	int value;
	Bool condition;

	/* eval and discard expression, ignore errors */
	value = Expr_eval(expr);
	if (value == 0)				/* ignore expr->result.not_evaluable, as undefined values result in 0 */
		condition = FALSE;
	else
		condition = TRUE;

	OBJ_DELETE(expr);

	start_struct(ctx, TK_IF, condition);
}

static void asm_IFDEF(ParseCtx *ctx, char *name)
{
	Bool condition;

	condition = check_ifdef_condition(name);
	start_struct(ctx, TK_IFDEF, condition);
}

static void asm_IFNDEF(ParseCtx *ctx, char *name)
{
	Bool condition;

	condition = ! check_ifdef_condition(name);
	start_struct(ctx, TK_IFNDEF, condition);
}

static void asm_ELSE(ParseCtx *ctx)
{
	OpenStruct *open_struct;

	open_struct = (OpenStruct *)utarray_back(ctx->open_structs);
	if (open_struct == NULL)
		error_unbalanced_struct();
	else
	{
		switch (open_struct->open_tok)
		{
		case TK_IF:
		case TK_IFDEF:
		case TK_IFNDEF:
			open_struct->active = !open_struct->active;
			open_struct->open_tok = TK_ELSE;
			break;

		default:
			error_unbalanced_struct_at(open_struct->filename, open_struct->line_nr);
		}
	}
}

static void asm_ENDIF(ParseCtx *ctx)
{
	OpenStruct *open_struct;

	open_struct = (OpenStruct *)utarray_back(ctx->open_structs);
	if (open_struct == NULL)
		error_unbalanced_struct();
	else
	{
		switch (open_struct->open_tok)
		{
		case TK_IF:
		case TK_IFDEF:
		case TK_IFNDEF:
		case TK_ELSE:
			utarray_pop_back(ctx->open_structs);
			break;

		default:
			error_unbalanced_struct_at(open_struct->filename, open_struct->line_nr);
		}
	}
}

/*-----------------------------------------------------------------------------
*   Import parser generated by ragel
*----------------------------------------------------------------------------*/
#include "parse_rules.h"

/*-----------------------------------------------------------------------------
*   parse the given assembly file, return FALSE if failed
*----------------------------------------------------------------------------*/
static void parseline(ParseCtx *ctx)
{
	int start_num_errors;

	next_PC();				/* update assembler program counter */
	EOL = FALSE;			/* reset END OF LINE flag */

	start_num_errors = get_num_errors();

	scan_expect_opcode();
	GetSym();

	if (get_num_errors() != start_num_errors)		/* detect errors in GetSym() */
		Skipline();
	else if (!parse_statement(ctx))
	{
		if (get_num_errors() == start_num_errors)	/* no error output yet */
			error_syntax();

		Skipline();
	}
	list_end_line();				/* Write current source line to list file */
}

Bool parse_file(char *filename)
{
	ParseCtx *ctx;
	OpenStruct *open_struct;
	int num_errors = get_num_errors();

	ctx = ParseCtx_new();
	if (opts.verbose)
		printf("Reading '%s'...\n", filename);	/* display name of file */

	src_push();
	{
		if (src_open(filename, opts.inc_path))
		{
			sym.tok = TK_NIL;
			while (sym.tok != TK_END)
				parseline(ctx);				/* before parsing it */

			open_struct = (OpenStruct *)utarray_back(ctx->open_structs);
			if (open_struct != NULL)
				error_unbalanced_struct_at(open_struct->filename, open_struct->line_nr);
		}
	}
	src_pop();
	sym.tok = TK_NEWLINE;						/* when called recursively, need to make tok != TK_NIL */

	ParseCtx_delete(ctx);

	return num_errors == get_num_errors();
}

/*-----------------------------------------------------------------------------
*   Parse one statement, if possible
*----------------------------------------------------------------------------*/
Bool parse_statement(ParseCtx *ctx)
{
	Bool parse_ok;

	save_scan_state();
	{
		parse_ok = _parse_statement(ctx);
		free_tokens(ctx);
	}
	if (parse_ok)
		drop_scan_state();
	else
		restore_scan_state();

	return parse_ok;
}
