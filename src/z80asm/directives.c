/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Assembly directives.
*/

#include "codearea.h"
#include "directives.h"
#include "errors.h"
#include "fileutil.h"
#include "model.h"
#include "module.h"
#include "parse.h"
#include "strpool.h"
#include "types.h"
#include "symtab.h"
#include "z80asm.h"
#include <assert.h>

/*-----------------------------------------------------------------------------
*   LABEL: define a label at the current location
*----------------------------------------------------------------------------*/
void asm_LABEL_offset(char *name, int offset)
{
	Symbol *sym;

	sym = define_symbol(name, get_PC() + offset, TYPE_ADDRESS);
	sym->is_touched = TRUE;
}

void asm_LABEL(char *name)
{
	asm_LABEL_offset(name, 0);
}

/*-----------------------------------------------------------------------------
*   DEFGROUP
*----------------------------------------------------------------------------*/

static int DEFGROUP_PC;			/* next value to assign */

/* start a new DEFGROUP context, give the value of the next defined constant */
void asm_DEFGROUP_start(int next_value)
{
	DEFGROUP_PC = next_value;
}

/* define one constant with the next value, increment the value */
void asm_DEFGROUP_define_const(char *name)
{
	assert(name != NULL);
	
	if (DEFGROUP_PC > 0xFFFF || DEFGROUP_PC < -0x8000)
		error_int_range(DEFGROUP_PC);
	else
		define_symbol(name, DEFGROUP_PC, TYPE_CONSTANT);
	DEFGROUP_PC++;
}

/*-----------------------------------------------------------------------------
*   DEFVARS
*----------------------------------------------------------------------------*/

static int DEFVARS_GLOBAL_PC;	/* DEFVARS address counter for global structs
								*  created by a chain of DEFVARS -1 */
static int DEFVARS_STRUCT_PC;	/* DEFVARS address counter for zero based structs
								*  restared on each DEFVARS 0 */
static int *DEFVARS_PC = &DEFVARS_STRUCT_PC;	/* select current DEFVARS PC*/

/* start a new DEFVARS context, closing any previously open one */
void asm_DEFVARS_start(int start_addr)
{
	if (start_addr == -1)
		DEFVARS_PC = &DEFVARS_GLOBAL_PC;	/* continue from previous DEFVARS_GLOBAL_PC */
	else if (start_addr == 0)
	{
		DEFVARS_PC = &DEFVARS_STRUCT_PC;	/* start a new struct context */
		DEFVARS_STRUCT_PC = 0;
	}
	else if (start_addr > 0 && start_addr <= 0xFFFF)
	{
		DEFVARS_PC = &DEFVARS_GLOBAL_PC;	/* start a new DEFVARS_GLOBAL_PC */
		DEFVARS_GLOBAL_PC = start_addr;
	}
	else
		error_int_range(start_addr);
}

/* define one constant in the current context */
void asm_DEFVARS_define_const(char *name, int elem_size, int count)
{
	int var_size = elem_size * count;
	int next_pc = *DEFVARS_PC + var_size;

	assert(name != NULL);

	if (var_size > 0xFFFF)
		error_int_range(var_size);
	else if (next_pc > 0xFFFF)
		error_int_range(next_pc);
	else
	{
		define_symbol(name, *DEFVARS_PC, TYPE_CONSTANT);
		*DEFVARS_PC = next_pc;
	}
}

/*-----------------------------------------------------------------------------
*   directives without arguments
*----------------------------------------------------------------------------*/
void asm_LSTON(void)
{
	if (opts.list)
		opts.cur_list = TRUE;
}

void asm_LSTOFF(void)
{
	if (opts.list)
		opts.cur_list = FALSE;
}

/*-----------------------------------------------------------------------------
*   directives with number argument
*----------------------------------------------------------------------------*/
void asm_LINE(int line_nr)
{
	STR_DEFINE(name, STR_SIZE);

	if (opts.line_mode)
		set_error_line(line_nr);

	str_sprintf(name, "__C_LINE_%ld", line_nr);
	asm_LABEL(str_data(name));

	STR_DELETE(name);
}

void asm_ORG(int address)
{
	set_origin_directive(address);
}

/*-----------------------------------------------------------------------------
*   directives with string argument 
*----------------------------------------------------------------------------*/
void asm_INCLUDE(char *filename)
{
	parse_file(filename);
}

void asm_BINARY(char *filename)
{
	FILE *binfile;

	filename = search_file(filename, opts.inc_path);

	binfile = myfopen(filename, "rb");		
	if (binfile)
	{
		append_file_contents(binfile, -1);		/* read binary code */
		myfclose(binfile);
	}
}

/*-----------------------------------------------------------------------------
*   directives with name argument
*----------------------------------------------------------------------------*/
void asm_MODULE(char *name)
{
	CURRENTMODULE->modname = strpool_add(name);		/* replace previous module name */
}

void asm_MODULE_default(void)
{
	if (!CURRENTMODULE->modname)     /* Module name must be defined */
		CURRENTMODULE->modname = path_remove_ext(path_basename(CURRENTMODULE->filename));
}

void asm_SECTION(char *name)
{
	new_section(name);
}

/*-----------------------------------------------------------------------------
*   directives with list of names argument, function called for each argument
*----------------------------------------------------------------------------*/
void asm_GLOBAL(char *name)
{
	declare_global_symbol(name);
}

void asm_EXTERN(char *name)
{
	declare_extern_symbol(name);
}

void asm_PUBLIC(char *name)
{
	declare_public_symbol(name);
}

void asm_DEFINE(char *name)
{
	define_local_def_sym(name, 1);
}

void asm_UNDEFINE(char *name)
{
	SymbolHash_remove(CURRENTMODULE->local_symtab, name);
}

/*-----------------------------------------------------------------------------
*   define a constant or expression 
*----------------------------------------------------------------------------*/
void asm_DEFC(char *name, Expr *expr)
{
	int value; 

	value = Expr_eval(expr, FALSE);		/* DEFC constant expression */
	if ((expr->result.not_evaluable) || (expr->type >= TYPE_ADDRESS))
	{
		/* store in object file to be computed at link time */
		expr->range = RANGE_WORD;
		expr->target_name = strpool_add(name);

		ExprList_push(&CURRENTMODULE->exprs, expr);

		/* create symbol */
		define_symbol(expr->target_name, 0, TYPE_COMPUTED);
	}
	else
	{
		define_symbol(name, value, TYPE_CONSTANT);
		OBJ_DELETE(expr);
	}
}

/*-----------------------------------------------------------------------------
*   DEFS - create a block of empty bytes, called by the DEFS directive
*----------------------------------------------------------------------------*/
void asm_DEFS(int count, int fill)
{
	if (count < 0 || count > 0x10000)
		error_int_range(count);
	else if (fill < -128 || fill > 255)
		error_int_range(fill);
	else
		append_defs(count, fill);
}

/*-----------------------------------------------------------------------------
*   DEFB - add an expression or a string
*----------------------------------------------------------------------------*/
void asm_DEFB_str(char *str, int length)
{
	while (length-- > 0)
		add_opcode((*str++) & 0xFF);
}

void asm_DEFB_expr(Expr *expr)
{
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/*-----------------------------------------------------------------------------
*   DEFW, DEFQ - add 2-byte and 4-byte expressions
*----------------------------------------------------------------------------*/
void asm_DEFW(Expr *expr)
{
	Pass2infoExpr(RANGE_WORD, expr);
}

void asm_DEFQ(Expr *expr)
{
	Pass2infoExpr(RANGE_DWORD, expr);
}
