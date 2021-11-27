/*
Z88-DK Z80ASM - Z80 Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2021
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define ragel-based parser. 
*/

#include "class.h"
#include "codearea.h"
#include "die.h"
#include "directives.h"
#include "expr.h"
#include "listfile.h"
#include "module.h"
#include "opcodes.h"
#include "parse.h"
#include "scan.h"
#include "str.h"
#include "strutil.h"
#include "sym.h"
#include "symtab.h"
#include "utarray.h"
#include "utstring.h"
#include "zutils.h"
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
	tokid_t	open_tok;			// open token - TK_IF, TK_ELSE, ...
	const char *filename;		// file and line where token found
	int		line_num;
	bool	active : 1;			// in true branch of conditional compilation
	bool	parent_active : 1;	// in true branch of parent's conditional compilation
	bool	elif_was_true : 1;	// true if any of the IF/ELIF branches returned true
} OpenStruct;

static UT_icd ut_OpenStruct_icd = { sizeof(OpenStruct), NULL, NULL, NULL };
static UT_array* open_structs;

/*-----------------------------------------------------------------------------
* 	init module
*----------------------------------------------------------------------------*/
static void deinit_module(void) {
	utarray_free(open_structs);
}

static void init_module(void) {
	static bool inited = false;
	if (!inited) {
		utarray_new(open_structs, &ut_OpenStruct_icd);
		atexit(deinit_module);
		inited = true;
	}
}

/*-----------------------------------------------------------------------------
* 	Current parse context
*----------------------------------------------------------------------------*/
ParseCtx *ParseCtx_new(void)
{
	init_module();

	ParseCtx *ctx = m_new(ParseCtx);

	utarray_new(ctx->tokens, &ut_Sym_icd);
	utarray_new(ctx->token_strings, &ut_str_icd);
	utarray_new(ctx->exprs, &ut_exprs_icd);

	ctx->current_sm = SM_MAIN;

	return ctx;
}

void ParseCtx_delete(ParseCtx *ctx)
{
	init_module();

	utarray_free(ctx->exprs);
	utarray_free(ctx->token_strings);
	utarray_free(ctx->tokens);
	m_free(ctx);
}

/*-----------------------------------------------------------------------------
*   Parse expression and push it to exprs
*----------------------------------------------------------------------------*/

/* save the current scanner context and parse the given expression */
struct Expr *parse_expr(const char *expr_text)
{
	init_module();

	Expr *expr;
	int num_errors;

	save_scan_state();
	{
		sfile_hold_input();
		{
			SetTemporaryLine(expr_text);
			num_errors = get_num_errors();
			found_EOL = false;
			scan_expect_operands();
			GetSym();
			expr = expr_parse();		/* may output error */
			if (sym.tok != TK_END && num_errors == get_num_errors())
				error_syntax();
		}
		sfile_unhold_input();
	}
	restore_scan_state();
	
	return expr;
}

/* push current expression */
static void push_expr(ParseCtx *ctx)
{
	init_module();

	STR_DEFINE(expr_text, STR_SIZE);
	Expr *expr;
	Sym  *expr_p;

	/* build expression text - split constant prefixes from numbers and names */
	Str_clear(expr_text);
	bool last_was_prefix = false;
	for (expr_p = ctx->expr_start; expr_p < ctx->p; expr_p++)
	{
		if (last_was_prefix && expr_p->tlen > 0 &&
			(isalnum(*expr_p->tstart) || *expr_p->tstart == '"'))
		{
			Str_append_char(expr_text, ' ');
			last_was_prefix = false;
		}

		Str_append_n(expr_text, expr_p->tstart, expr_p->tlen);

		if (expr_p->tlen > 0)
		{
			switch (expr_p->tstart[expr_p->tlen - 1])
			{
			case '@':
			case '%':
			case '$':
				last_was_prefix = true;
				break;

			default:
				last_was_prefix = false;
			}
		}
	}
	
	/* parse expression */
	expr = parse_expr(Str_data(expr_text));

	/* push the new expression, or NULL on error */
	utarray_push_back(ctx->exprs, &expr);

	STR_DELETE(expr_text);
}

/*-----------------------------------------------------------------------------
*   Pop and return expression
*----------------------------------------------------------------------------*/
static Expr *pop_expr(ParseCtx *ctx)
{
	init_module();

	Expr *expr;

	expr = *((Expr **)utarray_back(ctx->exprs));
	*((Expr **)utarray_back(ctx->exprs)) = NULL;		/* do not destroy */
	
	utarray_pop_back(ctx->exprs);

	return expr;
}

/*-----------------------------------------------------------------------------
*   Pop and compute expression, issue error on failure
*----------------------------------------------------------------------------*/
static void pop_eval_expr(ParseCtx *ctx, int *pvalue, bool *perror)
{
	init_module();

	Expr *expr;

	*pvalue = 0;
	*perror = false;

	expr = pop_expr(ctx);
	if (expr == NULL)
	{
		*perror = true;				/* error output by push_expr() */
		return;
	}

	/* eval and discard expression */
	*pvalue = Expr_eval(expr, true);
	*perror = (expr->result.not_evaluable);
	OBJ_DELETE(expr);
}

/*-----------------------------------------------------------------------------
*   return new auto-label in strpool
*----------------------------------------------------------------------------*/
const char *autolabel(void)
{
	init_module();

	STR_DEFINE(label, STR_SIZE);
	static int n;
	const char *ret;

	Str_sprintf(label, "__autolabel_%04d", ++n);
	ret = spool_add(Str_data(label));

	STR_DELETE(label);
	return ret;
}

/*-----------------------------------------------------------------------------
*   String pool for the current statement
*----------------------------------------------------------------------------*/
static char *token_strings_add(ParseCtx *ctx, char *str)
{
	init_module();

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
	init_module();

	STR_DEFINE(buffer, STR_SIZE);
	Sym sym_copy;
	int p_index;
	int expr_start_index;

	p_index = ctx->p ? ctx->p - (Sym *)utarray_front(ctx->tokens) : -1;
	expr_start_index = ctx->expr_start ? ctx->expr_start - (Sym *)utarray_front(ctx->tokens) : -1;

	sym_copy = sym;

	/* make text to be used while concatenating tokens to build an expression to parse */
	switch (sym_copy.tok)
	{
	case TK_NUMBER:
		Str_sprintf(buffer, "%d", sym_copy.number);
		sym_copy.tstart = token_strings_add(ctx, Str_data(buffer));
		sym_copy.tlen = Str_len(buffer);
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
//			xassert(*(sym_copy.text));
	}
//	sym_copy.string = token_strings_add(sym.string);
	utarray_push_back(ctx->tokens, &sym_copy);

	ctx->p = (Sym *)utarray_front(ctx->tokens) + (p_index >= 0 ? p_index : 0);
	ctx->pe = (Sym *)utarray_back(ctx->tokens) + 1;

	if (sym.tok == TK_END)
		ctx->eof_ = ctx->pe;
	else
		ctx->eof_ = NULL;

	ctx->expr_start = expr_start_index >= 0 ? ((Sym *)utarray_front(ctx->tokens)) + expr_start_index : NULL;

	// if symbol is a prefix, set scanner to get an opcode
	if (sym.tok == TK_ALTD || sym.tok == TK_IOE || sym.tok == TK_IOI)
		scan_expect_opcode();

	GetSym();

	STR_DELETE(buffer);
}

static void free_tokens(ParseCtx *ctx)
{
	init_module();

	utarray_clear(ctx->tokens);
	utarray_clear(ctx->token_strings);
	if (ctx->current_sm != SM_DMA_PARAMS) {		// DMA_PARAMS needs to preserve exprs between lines
		utarray_clear(ctx->exprs);
	}
}

/*-----------------------------------------------------------------------------
*   IF, IFDEF, IFNDEF, ELSE, ELIF, ELIFDEF, ELIFNDEF, ENDIF
*----------------------------------------------------------------------------*/
static void start_struct(tokid_t open_tok, bool condition)
{
	init_module();

	OpenStruct *parent_os, os;

	// init to zeros
	memset(&os, 0, sizeof(OpenStruct));

	os.open_tok = open_tok;
	os.filename = get_error_file();
	os.line_num = get_error_line();
	os.active = condition;
	if (os.active)
		os.elif_was_true = true;

	parent_os = (OpenStruct *)utarray_back(open_structs);
	if (parent_os)
		os.parent_active = parent_os->active && parent_os->parent_active;
	else
		os.parent_active = true;

	utarray_push_back(open_structs, &os);
}

static void continue_struct(tokid_t open_tok, bool condition)
{
	init_module();

	OpenStruct *os = (OpenStruct *)utarray_back(open_structs);
	if (!os)
		error_unbalanced_struct();
	else {
		os->open_tok = open_tok;
		os->active = condition && !os->elif_was_true;
		if (os->active)
			os->elif_was_true = true;
	}
}

static bool check_if_condition(Expr *expr)
{
	init_module();

	int value;
	bool condition;

	// eval and discard expression, ignore errors
	value = Expr_eval(expr, false);
	if (value == 0)				// ignore expr->result.not_evaluable, as undefined values result in 0
		condition = false;
	else
		condition = true;

	OBJ_DELETE(expr);

	return condition;
}

static bool check_ifdef_condition(char *name)
{
	init_module();

	Symbol *symbol;

	symbol = find_symbol(name, CURRENTMODULE->local_symtab);
	if (symbol != NULL && (symbol->is_defined || (symbol->scope == SCOPE_EXTERN || symbol->scope == SCOPE_GLOBAL)))
		return true;

	symbol = find_symbol(name, global_symtab);
	if (symbol != NULL && (symbol->is_defined || (symbol->scope == SCOPE_EXTERN || symbol->scope == SCOPE_GLOBAL)))
		return true;

	return false;
}

static void asm_IF(Expr *expr)
{
	init_module();

	bool condition = check_if_condition(expr);
	start_struct(TK_IF, condition);
}

static void asm_IFDEF(char *name)
{
	init_module();

	bool condition;

	condition = check_ifdef_condition(name);
	start_struct(TK_IFDEF, condition);
}

static void asm_IFNDEF(char *name)
{
	init_module();

	bool condition;

	condition = ! check_ifdef_condition(name);
	start_struct(TK_IFNDEF, condition);
}

static void asm_ELSE(void)
{
	init_module();

	OpenStruct *os;

	os = (OpenStruct *)utarray_back(open_structs);
	if (!os)
		error_unbalanced_struct();
	else
	{
		switch (os->open_tok)
		{
		case TK_IF:
		case TK_IFDEF:
		case TK_IFNDEF:
			os->active = !os->active && !os->elif_was_true;
			os->open_tok = TK_ELSE;
			break;

		default:
			error_unbalanced_struct_at(os->filename, os->line_num);
		}
	}
}

static void asm_ELIF(Expr *expr)
{
	init_module();

	asm_ELSE();
	bool condition = check_if_condition(expr);
	continue_struct(_TK_IF, condition);
}

static void asm_ELIFDEF(char *name)
{
	init_module();

	asm_ELSE();
	bool condition = check_ifdef_condition(name);
	continue_struct(_TK_IFDEF, condition);
}

static void asm_ELIFNDEF(char *name)
{
	init_module();

	asm_ELSE();
	bool condition = !check_ifdef_condition(name);
	continue_struct(_TK_IFDEF, condition);
}

static void asm_ENDIF(void)
{
	init_module();

	OpenStruct *os;

	os = (OpenStruct *)utarray_back(open_structs);
	if (!os)
		error_unbalanced_struct();
	else
	{
		switch (os->open_tok)
		{
		case TK_IF:
		case TK_IFDEF:
		case TK_IFNDEF:
		case TK_ELSE:
			utarray_pop_back(open_structs);
			break;

		default:
			error_unbalanced_struct_at(os->filename, os->line_num);
		}
	}
}

/*-----------------------------------------------------------------------------
*   Import parser generated by ragel
*----------------------------------------------------------------------------*/
#include "parse_rules.h"

/*-----------------------------------------------------------------------------
*   parse the given assembly file, return false if failed
*----------------------------------------------------------------------------*/
static void parseline(ParseCtx *ctx)
{
	init_module();

	int start_num_errors;

	next_PC();				/* update assembler program counter */
	found_EOL = false;			/* reset END OF LINE flag */

	start_num_errors = get_num_errors();

	scan_expect_opcode();
	GetSym();

	if (get_num_errors() != start_num_errors)		/* detect errors in GetSym() */
		Skipline();
	else if (!parse_statement(ctx))
	{
		if (get_num_errors() == start_num_errors) {	/* no error output yet */
			error_syntax();
			ctx->current_sm = SM_MAIN;				/* reset state machine */
		}

		Skipline();
	}
	list_end_line();				/* Write current source line to list file */
}

static void check_open_structs(void) {
	init_module();
	OpenStruct* os = (OpenStruct*)utarray_back(open_structs);
	if (os != NULL)
		error_unbalanced_struct_at(os->filename, os->line_num);

	// clear stack to prepare for next file
	utarray_clear(open_structs);
}

void parse_include_file(const char* filename)
{
	init_module();

	ParseCtx* ctx = ParseCtx_new();
	{
		if (sfile_open(filename, true)) {
			if (opts.verbose)
				printf("Reading '%s' = '%s'\n",
					path_canon(filename), path_canon(sfile_filename()));	/* display name of file */

			sym.tok = TK_NIL;
			while (sym.tok != TK_END)
				parseline(ctx);				/* before parsing it */
		}

		sym.tok = TK_NEWLINE;				/* when called recursively, need to make tok != TK_NIL */
	}
	ParseCtx_delete(ctx);
}

void parse_file(const char* filename) {
	init_module();
	parse_include_file(filename);
	check_open_structs();
}

/*-----------------------------------------------------------------------------
*   Parse one statement, if possible
*----------------------------------------------------------------------------*/
bool parse_statement(ParseCtx *ctx)
{
	init_module();

	bool parse_ok;

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
