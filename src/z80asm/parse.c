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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse.c,v 1.22 2015-01-03 18:39:05 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "codearea.h"
#include "directives.h"
#include "expr.h"
#include "init.h"
#include "model.h"
#include "opcodes.h"
#include "parse.h"
#include "scan.h"
#include "strpool.h"
#include "sym.h"
#include "symtab.h"
#include "utarray.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/

/* array of tokens in the current statement */
static Sym *p, *pe, *eof;
static Sym *expr_start;
static UT_array *tokens;
static UT_icd ut_Sym_icd = { sizeof(Sym), NULL, NULL, NULL };

/* strings saved from the current statement */
static UT_array *token_strings;

/* array of expressions computed during parse */
static void ut_exprs_init(void *elt) { Expr *expr = OBJ_NEW(Expr); *((Expr **)elt) = expr;  };
static void ut_exprs_dtor(void *elt) { Expr *expr = *((Expr **)elt);  OBJ_DELETE(expr); };

static UT_array *exprs;
static UT_icd ut_exprs_icd = { sizeof(Expr *), ut_exprs_init, NULL, ut_exprs_dtor };

static int  expr_value;
static Bool expr_error;
static Bool expr_in_parens;				/* true if expression has enclosing parens */
static int  expr_open_parens;			/* number of open parens */

/* Ragel state variables */
static int cs;							/* current state */

#if 0
/* Ragel state stack */
static UT_array *state_stack;
static int *stack, top;
#endif

/* Statement label, NULL if none */
static char *stmt_label;

/* current parser state machine */
static enum { SM_MAIN, SM_DEFVARS_OPEN, SM_DEFVARS_LINE }
	current_sm = SM_MAIN;

/*-----------------------------------------------------------------------------
*   Cleanup memory at end
*----------------------------------------------------------------------------*/
DEFINE_init()
{
	utarray_new(tokens, &ut_Sym_icd);
	utarray_new(token_strings, &ut_str_icd);
#if 0
	utarray_new(state_stack, &ut_int_icd);
#endif
	utarray_new(exprs, &ut_exprs_icd);

	parse_init();
}

DEFINE_fini()
{
	utarray_free(tokens);
	utarray_free(token_strings);
#if 0
	utarray_free(state_stack);
#endif
	utarray_free(exprs);
}

/*-----------------------------------------------------------------------------
*   Parse expression and push it to exprs
*----------------------------------------------------------------------------*/

/* save the current scanner context and parse the given expression */
struct Expr *parse_expr(char *expr_text)
{
	Expr *expr;
	int num_errors;

	init();

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
static void push_expr(Sym *expr_start, Sym *expr_end)
{
	static Str *expr_text;
	Expr *expr;
	Sym  *expr_p;

	INIT_OBJ(Str, &expr_text);

	/* build expression text */
	Str_clear(expr_text);
	for (expr_p = expr_start; expr_p < expr_end; expr_p++)
		Str_append(expr_text, expr_p->text);
	
	/* parse expression */
	expr = parse_expr(expr_text->str);

	/* push the new expression, or NULL on error */
	utarray_push_back(exprs, &expr);
}

/*-----------------------------------------------------------------------------
*   Pop and return expression
*----------------------------------------------------------------------------*/
static Expr *pop_expr(void)
{
	Expr *expr;

	expr = *((Expr **)utarray_back(exprs));
	*((Expr **)utarray_back(exprs)) = NULL;		/* do not destroy */
	
	utarray_pop_back(exprs);

	return expr;
}

/*-----------------------------------------------------------------------------
*   Pop and compute expression, issue error on failure
*----------------------------------------------------------------------------*/
static void pop_eval_expr(int *pvalue, Bool *perror)
{
	Expr *expr;

	*pvalue = 0;
	*perror = FALSE;

	expr = pop_expr();
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
*   Compute auto-label
*----------------------------------------------------------------------------*/
char *autolabel(void)
{
	static Str *label;
	static int n;

	init();

	INIT_OBJ(Str, &label);

	Str_sprintf(label, "__autolabel_%04d", ++n);
	return strpool_add(label->str);
}

/*-----------------------------------------------------------------------------
*   String pool for the current statement
*----------------------------------------------------------------------------*/
static char *token_strings_add(char *str)
{
	if (!str)		/* NULL string */
		return NULL;

	utarray_push_back(token_strings, &str);
	return *((char **)utarray_back(token_strings));
}

/*-----------------------------------------------------------------------------
*   Read tokens from the current statement into tokensd[], to be parsed
*	by state machine
*----------------------------------------------------------------------------*/
static void read_token(void)
{
	static Str *buffer;
	Sym sym_copy;
	int p_index;
	int expr_start_index;

	INIT_OBJ(Str, &buffer);

	p_index = p ? p - (Sym *)utarray_front(tokens) : -1;
	expr_start_index = expr_start ? expr_start - (Sym *)utarray_front(tokens) : -1;

	sym_copy = sym;

	/* make text to be used while concatenating tokens to build an expression to parse */
	switch (sym_copy.tok)
	{
	case TK_NUMBER:
		Str_sprintf(buffer, "%d", sym_copy.number);
		sym_copy.text = token_strings_add(buffer->str);
		break;

	case TK_NAME:
	case TK_LABEL:
		sym_copy.text = token_strings_add(sym_copy.string);
		break;

	case TK_STRING:
		Str_sprintf(buffer, "\"%s\"", sym_copy.string);
		sym_copy.text = token_strings_add(buffer->str);
		break;

	case TK_END:
		sym_copy.text = "";
		break;

	default:
		if (!*(sym_copy.text))
			assert(*(sym_copy.text));
	}
	sym_copy.string = token_strings_add(sym.string);
	utarray_push_back(tokens, &sym_copy);

	p = (Sym *)utarray_front(tokens) + (p_index >= 0 ? p_index : 0);
	pe = (Sym *)utarray_back(tokens) + 1;

	if (sym.tok == TK_END)
		eof = pe;
	else
		eof = NULL;

	expr_start = expr_start_index >= 0 ? ((Sym *)utarray_front(tokens)) + expr_start_index : NULL;

	GetSym();
}

static void free_tokens(void)
{
	utarray_clear(tokens);
	utarray_clear(token_strings);
	utarray_clear(exprs);
}

/*-----------------------------------------------------------------------------
*   Import parser generated by ragel
*----------------------------------------------------------------------------*/
#include "parse_rules.h"

/*-----------------------------------------------------------------------------
*   init the parser state
*----------------------------------------------------------------------------*/
void parse_init(void)
{
	_parse_init();
}

/*-----------------------------------------------------------------------------
*   Parse one statement, if possible
*----------------------------------------------------------------------------*/
Bool parse_statement(Bool compile_active)
{
	Bool parse_ok;

	init();

	save_scan_state();
	{
		stmt_label = NULL;
		expr_value = 0;
		expr_error = FALSE;
		parse_ok = _parse_statement(compile_active);
		free_tokens(); 
	}
	if (parse_ok)
		drop_scan_state();
	else
		restore_scan_state();

	return parse_ok;
}
