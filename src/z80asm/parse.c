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

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/parse.c,v 1.14 2014-12-23 00:26:53 pauloscustodio Exp $ 
*/

#include "xmalloc.h"   /* before any other include */

#include "class.h"
#include "codearea.h"
#include "expr.h"
#include "init.h"
#include "model.h"
#include "opcodes.h"
#include "parse.h"
#include "scan.h"
#include "sym.h"
#include "symtab.h"
#include "utarray.h"

/*-----------------------------------------------------------------------------
* 	Static - current scan context
*----------------------------------------------------------------------------*/

/* array of tokens in the current statement */
static Sym *p, *pe, *eof;
static UT_array *tokens;
static UT_icd ut_Sym_icd = { sizeof(Sym), NULL, NULL, NULL };

/* strings saved from the current statement */
static UT_array *token_strings;

/* array of expressions computed during parse */
static void ut_exprs_init(void *elt) { Expr *expr = OBJ_NEW(Expr); *((Expr **)elt) = expr;  };
static void ut_exprs_dtor(void *elt) { Expr *expr = *((Expr **)elt);  OBJ_DELETE(expr); };
static UT_array *exprs;
static UT_icd ut_exprs_icd = { sizeof(Expr *), ut_exprs_init, NULL, ut_exprs_dtor };
static Sym *expr_start;
static int expr_value;

/* Ragel state variables */
static int cs;							/* current state */

#if 0
/* Ragel state stack */
static UT_array *state_stack;
static int *stack, top;
#endif

/* Statement label, NULL if none */
static char *stmt_label;

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
static void push_expr(char *ts, char *te)
{
	static Str *expr_text;
	Expr *expr;
	int num_errors;

	INIT_OBJ(Str, &expr_text);

	/* parse expression */
	Str_set_n(expr_text, ts, te - ts);
	save_scan_state();
	{
		src_push();
		{
			SetTemporaryLine(expr_text->str);
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
static int pop_eval_expr(void)
{
	Expr *expr;
	Bool  failed;
	int   result;

	expr = pop_expr();
	if (expr == NULL)
		return 0;					/* error output by push_expr() */

	/* eval and discard expression */
	result = Expr_eval(expr);
	failed = (expr->result.not_evaluable);
	OBJ_DELETE(expr);

	/* check errors */
	if (failed)
	{
		error_not_defined();
		return 0;
	}

	return result;
}

/*-----------------------------------------------------------------------------
*   insert a macro at the current position in input
*----------------------------------------------------------------------------*/
static void insert_macro(char *macro)
{
	SetTemporaryLine(macro);
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
	Sym sym_copy;
	int p_index;

	p_index = p ? p - (Sym *)utarray_front(tokens) : -1;

	sym_copy = sym;
	sym_copy.string = token_strings_add(sym.string);
	utarray_push_back(tokens, &sym_copy);

	p = (Sym *)utarray_front(tokens) + (p_index >= 0 ? p_index : 0);
	pe = (Sym *)utarray_back(tokens) + 1;

	if (sym.tok == TK_END)
		eof = pe;
	else
		eof = NULL;

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
		parse_ok = _parse_statement(compile_active);
		free_tokens(); 
	}
	if (parse_ok)
		drop_scan_state();
	else
		restore_scan_state();

	return parse_ok;
}
