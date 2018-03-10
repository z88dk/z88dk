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

static void check_org_align();

/*-----------------------------------------------------------------------------
*   LABEL: define a label at the current location
*----------------------------------------------------------------------------*/
void asm_LABEL_offset(char *name, int offset)
{
	Symbol *sym;
	
	if (get_phased_PC() >= 0)
		sym = define_symbol(name, get_phased_PC() + offset, TYPE_CONSTANT);
	else
		sym = define_symbol(name, get_PC() + offset, TYPE_ADDRESS);

	sym->is_touched = TRUE;
}

void asm_LABEL(char *name)
{
	asm_LABEL_offset(name, 0);
}

void asm_cond_LABEL(Str *label)
{
	if (str_len(label)) {
		asm_LABEL(str_data(label));
		str_len(label) = 0;
	}

	if (opts.debug_info && !scr_is_c_source()) {
		STR_DEFINE(name, STR_SIZE);

		str_sprintf(name, "__ASM_LINE_%ld", get_error_line());
		if (!find_local_symbol(str_data(name)))
			asm_LABEL(str_data(name));

		STR_DELETE(name);
	}
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
void asm_LINE(int line_nr, char *filename)
{
	STR_DEFINE(name, STR_SIZE);

	src_set_filename(filename);
	src_set_line_nr(line_nr, 1);
	set_error_file(filename);
	set_error_line(line_nr);

	STR_DELETE(name);
}

void asm_C_LINE(int line_nr, char *filename)
{
	src_set_filename(filename);
	src_set_line_nr(line_nr, 0);		// do not increment line numbers
	src_set_c_source();
	
	set_error_file(filename);
	set_error_line(line_nr);
	
	if (opts.debug_info) {
		STR_DEFINE(name, STR_SIZE);

		str_sprintf(name, "__C_LINE_%ld", line_nr);
		if (!find_local_symbol(str_data(name)))
			asm_LABEL(str_data(name));

		STR_DELETE(name);
	}
}

void asm_ORG(int address)
{
	set_origin_directive(address);
	check_org_align();
}

void asm_PHASE(int address)
{
	set_phase_directive(address);
}

void asm_DEPHASE()
{
	clear_phase_directive();
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

void asm_XREF(char *name)
{
	declare_extern_symbol(name);
}

void asm_LIB(char *name)
{
	declare_extern_symbol(name);
}

void asm_PUBLIC(char *name)
{
	declare_public_symbol(name);
}

void asm_XDEF(char *name)
{
	declare_public_symbol(name);
}

void asm_XLIB(char *name)
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

void asm_ALIGN(int align, int filler)
{
	if (align < 1 || align > 0xFFFF) {
		error_int_range(align);
	}
	else {
		if (CURRENTSECTION->asmpc == 0) {		// first ALIGN defines section alignment
			if (CURRENTSECTION->align_found) {
				error_align_redefined();
			}
			else {
				CURRENTSECTION->align = align;
				CURRENTSECTION->align_found = TRUE;
				check_org_align();
			}
		}
		else {									// other ALIGN reserves space with DEFS
			int above = CURRENTSECTION->asmpc % align;
			if (above > 0)
				asm_DEFS(align - above, filler);
		}
	}
}

static void check_org_align()
{
	int org = CURRENTSECTION->origin;
	int align = CURRENTSECTION->align;
	if (org >= 0 && align > 1 && (org % align) != 0)
		error_org_not_aligned(org, align);
}

/*-----------------------------------------------------------------------------
*   DMA
*----------------------------------------------------------------------------*/
static Expr *asm_DMA_shift_exprs(UT_array *exprs)
{
	assert(utarray_len(exprs) > 0);

	Expr *expr = *((Expr **)utarray_front(exprs));	// copy first element
	*((Expr **)utarray_front(exprs)) = NULL;		// do not destroy
	utarray_erase(exprs, 0, 1);						// delete first element

	return expr;
}

static void asm_DMA_command_1(int cmd, UT_array *exprs)
{
	// retrieve first constant expression
	Expr *expr = asm_DMA_shift_exprs(exprs);
	int N = Expr_eval(expr, TRUE);
	Bool not_evaluable = expr->result.not_evaluable;
	OBJ_DELETE(expr);
	if (not_evaluable) {
		error_expected_const_expr();
		return;
	}
	if (N >= 128 || N < 0) {
		error_int_range(N);
		return;
	}

	// retrieve next arguments
	switch (cmd) {
	case 0:
		/*
		dma.wr0 n [, w, x, y, z] with whitespace following comma including newline and 
		maybe comment to the end of the line so params can be listed on following lines
		or 0x01 into n
		n: bit 7 must be 0, bits 1..0 must be 01 else error "base register byte is illegal"
		If bit 3 of n is set then accept one following byte\
		If bit 4 of n is set then accept one following byte/ set together, expect word instead
		If bit 5 of n is set then accept one following byte\
		If bit 6 of n is set then accept one following byte/ set together, expect word instead
		*/
		N |= 0x01;
		if ((N & 0x03) != 0x01) {
			error_base_register_illegal(N);
			return;
		}

		// add command byte
		add_opcode(N & 0x7F);

		// parse wr0 parameters: check bits 3,4
		if ((N & 0x18) != 0 && utarray_len(exprs) == 0) {
			error_missing_arguments();
			return;
		}
		switch (N & 0x18) {
		case 0: break;
		case 0x08: asm_DEFB_expr(asm_DMA_shift_exprs(exprs)); break;		// bit 3
		case 0x10: asm_DEFB_expr(asm_DMA_shift_exprs(exprs)); break; 		// bit 4
		case 0x18: asm_DEFW(asm_DMA_shift_exprs(exprs)); break; 			// bits 3,4
		default: assert(0);
		}

		// parse wr0 parameters: check bits 5,6
		if ((N & 0x60) != 0 && utarray_len(exprs) == 0) {
			error_missing_arguments();
			return;
		}
		switch (N & 0x60) {
		case 0: break;
		case 0x20: asm_DEFB_expr(asm_DMA_shift_exprs(exprs)); break;		// bit 5
		case 0x40: asm_DEFB_expr(asm_DMA_shift_exprs(exprs)); break;		// bit 6
		case 0x60: asm_DEFW(asm_DMA_shift_exprs(exprs)); break;				// bits 5,6
		default: assert(0);
		}

		break;

	default: 
		assert(0);
	}

	// check for extra arguments
	if (utarray_len(exprs) > 0) 
		error_extra_arguments();
}

void asm_DMA_command(int cmd, UT_array *exprs)
{
	assert(utarray_len(exprs) > 0);
	asm_DMA_command_1(cmd, exprs);
	utarray_clear(exprs);			// clear any expr left over in case of error
}
