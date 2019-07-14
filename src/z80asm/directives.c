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
#include "strutil.h"
#include "types.h"
#include "symtab.h"
#include "z80asm.h"
#include "die.h"

static void check_org_align();

/*-----------------------------------------------------------------------------
*   LABEL: define a label at the current location
*----------------------------------------------------------------------------*/
void asm_LABEL_offset(const char *name, int offset)
{
	Symbol *sym;
	
	if (get_phased_PC() >= 0)
		sym = define_symbol(name, get_phased_PC() + offset, TYPE_CONSTANT);
	else
		sym = define_symbol(name, get_PC() + offset, TYPE_ADDRESS);

	sym->is_touched = true;
}

void asm_LABEL(const char *name)
{
	asm_LABEL_offset(name, 0);
}

void asm_cond_LABEL(Str *label)
{
	if (Str_len(label)) {
		asm_LABEL(Str_data(label));
		Str_len(label) = 0;
	}

	if (opts.debug_info && !scr_is_c_source()) {
		STR_DEFINE(name, STR_SIZE);

		Str_sprintf(name, "__ASM_LINE_%ld", get_error_line());
		if (!find_local_symbol(Str_data(name)))
			asm_LABEL(Str_data(name));

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
void asm_DEFGROUP_define_const(const char *name)
{
	xassert(name != NULL);
	
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
void asm_DEFVARS_define_const(const char *name, int elem_size, int count)
{
	int var_size = elem_size * count;
	int next_pc = *DEFVARS_PC + var_size;

	xassert(name != NULL);

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
		opts.cur_list = true;
}

void asm_LSTOFF(void)
{
	if (opts.list)
		opts.cur_list = false;
}

/*-----------------------------------------------------------------------------
*   directives with number argument
*----------------------------------------------------------------------------*/
void asm_LINE(int line_nr, const char *filename)
{
	STR_DEFINE(name, STR_SIZE);

	src_set_filename(filename);
	src_set_line_nr(line_nr, 1);
	set_error_file(filename);
	set_error_line(line_nr);

	STR_DELETE(name);
}

void asm_C_LINE(int line_nr, const char *filename)
{
	src_set_filename(filename);
	src_set_line_nr(line_nr, 0);		// do not increment line numbers
	src_set_c_source();
	
	set_error_file(filename);
	set_error_line(line_nr);
	
	if (opts.debug_info) {
		STR_DEFINE(name, STR_SIZE);

		Str_sprintf(name, "__C_LINE_%ld", line_nr);
		if (!find_local_symbol(Str_data(name)))
			asm_LABEL(Str_data(name));

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
void asm_INCLUDE(const char *filename)
{
	parse_file(filename);
}

void asm_BINARY(const char *filename)
{
	filename = path_search(filename, opts.inc_path);
	FILE *binfile = fopen(filename, "rb");
	if (!binfile) {
		error_read_file(filename);
	}
	else {
		append_file_contents(binfile, -1);		/* read binary code */
		xfclose(binfile);
	}
}

/*-----------------------------------------------------------------------------
*   directives with name argument
*----------------------------------------------------------------------------*/
void asm_MODULE(const char *name)
{
	CURRENTMODULE->modname = spool_add(name);		/* replace previous module name */
}

void asm_MODULE_default(void)
{
	if (!CURRENTMODULE->modname)     /* Module name must be defined */
		CURRENTMODULE->modname = path_remove_ext(path_file(CURRENTMODULE->filename));
}

void asm_SECTION(const char *name)
{
	new_section(name);
}

/*-----------------------------------------------------------------------------
*   directives with list of names argument, function called for each argument
*----------------------------------------------------------------------------*/
void asm_GLOBAL(const char *name)
{
	declare_global_symbol(name);
}

void asm_EXTERN(const char *name)
{
	declare_extern_symbol(name);
}

void asm_XREF(const char *name)
{
	declare_extern_symbol(name);
}

void asm_LIB(const char *name)
{
	declare_extern_symbol(name);
}

void asm_PUBLIC(const char *name)
{
	declare_public_symbol(name);
}

void asm_XDEF(const char *name)
{
	declare_public_symbol(name);
}

void asm_XLIB(const char *name)
{
	declare_public_symbol(name);
}

void asm_DEFINE(const char *name)
{
	define_local_def_sym(name, 1);
}

void asm_UNDEFINE(const char *name)
{
	SymbolHash_remove(CURRENTMODULE->local_symtab, name);
}

/*-----------------------------------------------------------------------------
*   define a constant or expression 
*----------------------------------------------------------------------------*/
void asm_DEFC(const char *name, Expr *expr)
{
	int value; 

	value = Expr_eval(expr, false);		/* DEFC constant expression */
	if ((expr->result.not_evaluable) || (expr->type >= TYPE_ADDRESS))
	{
		/* check if expression depends on itself */
		if (Expr_is_recusive(expr, name)) {
			error_expression_recursion(name);
		}
		else {
			/* store in object file to be computed at link time */
			expr->range = RANGE_WORD;
			expr->target_name = spool_add(name);

			ExprList_push(&CURRENTMODULE->exprs, expr);

			/* create symbol */
			define_symbol(expr->target_name, 0, TYPE_COMPUTED);
		}
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
void asm_DEFB_str(const char *str, int length)
{
	while (length-- > 0)
		add_opcode((*str++) & 0xFF);
}

void asm_DEFB_expr(Expr *expr)
{
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/*-----------------------------------------------------------------------------
*   DEFW, DEFQ, DEFDB - add 2-byte and 4-byte expressions
*----------------------------------------------------------------------------*/
void asm_DEFW(Expr *expr)
{
	Pass2infoExpr(RANGE_WORD, expr);
}

void asm_DEFDB(Expr *expr)
{
	Pass2infoExpr(RANGE_WORD_BE, expr);
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
		// first ALIGN defines section alignment
		if (CURRENTSECTION->asmpc == 0) {		
			if (CURRENTSECTION->align_found) {
				error_align_redefined();
			}
			else {
				CURRENTSECTION->align = align;
				CURRENTSECTION->align_found = true;
				check_org_align();
			}
		}
		// other ALIGN reserves space with DEFS
		else {
			int pc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
			int above = pc % align;
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
	xassert(utarray_len(exprs) > 0);

	Expr *expr = *((Expr **)utarray_front(exprs));	// copy first element
	*((Expr **)utarray_front(exprs)) = NULL;		// do not destroy
	utarray_erase(exprs, 0, 1);						// delete first element

	return expr;
}

static bool asm_DMA_shift_byte(UT_array *exprs, int *out_value)
{
	*out_value = 0;

	Expr *expr = asm_DMA_shift_exprs(exprs);
	*out_value = Expr_eval(expr, true);
	bool not_evaluable = expr->result.not_evaluable;
	OBJ_DELETE(expr);

	if (not_evaluable) {
		error_expected_const_expr();
		*out_value = 0;
		return false;
	}
	else if (*out_value < 0 || *out_value > 255) {
		error_int_range(*out_value);
		*out_value = 0;
		return false;
	}
	else
		return true;
}

static void asm_DMA_command_1(int cmd, UT_array *exprs)
{
	int N, W;

	// retrieve first constant expression
	if (!asm_DMA_shift_byte(exprs, &N))
		return;

	// retrieve next arguments
	switch (cmd) {
	case 0:
		/*
		dma.wr0 n [, w, x, y, z] with whitespace following comma including newline and 
		maybe comment to the end of the line so params can be listed on following lines
		n: bit 7 must be 0, bits 1..0 must be 01 else error "base register byte is illegal"

		If bit 3 of n is set then accept one following byte\
		If bit 4 of n is set then accept one following byte/ set together, expect word instead
		If bit 5 of n is set then accept one following byte\
		If bit 6 of n is set then accept one following byte/ set together, expect word instead
		*/
		if ((N & 0x83) != 0x01) {
			error_base_register_illegal(N);
			return;
		}

		// add command byte
		add_opcode(N & 0xFF);

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
		default: xassert(0);
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
		default: xassert(0);
		}

		break;

	case 1:
		/*
		dma.wr1 n [,w]
		or 0x04 into n
		n: bit 7 must be 0, bits 2..0 must be 100 else error "base register byte is illegal"
		If bit 6 of n is set then accept one following byte w.

		In w bits 5..4 must be 0, bits 1..0 must not be 11 error "port A timing is illegal"
		In w if any of bits 7,6,3,2 are set warning "dma does not support half cycle timing"
		*/
		if (((N & 0x87) | 0x04) != 0x04) {
			error_base_register_illegal(N);
			return;
		}
		N |= 0x04;

		// add command byte
		add_opcode(N & 0xFF);

		if (N & 0x40) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			if (!asm_DMA_shift_byte(exprs, &W))
				return;

			add_opcode(W & 0xFF);
			if ((W & 0x30) != 0 || (W & 0x03) == 0x03) {
				error_port_A_timing();
				return;
			}
			if (W & 0xCC)
				warn_dma_half_cycle_timing();
		}
		break;

	case 2:
		/*
		dma.wr2 n [,w,x]
		n: bit 7 must be 0, bits 2..0 must be 000 else error "base register byte is illegal"
		If bit 6 of n is set then accept one following byte w

		In w bit 4 must be 0, bits 1..0 must not be 11 error "port B timing is illegal"
		In w if any of bits 7,6,3,2 are set warning "dma does not support half cycle timing"
		If bit 5 of w is set then accept one following byte x that can be anything.
		*/
		if ((N & 0x87) != 0x00) {
			error_base_register_illegal(N);
			return;
		}

		// add command byte
		add_opcode(N & 0xFF);

		if (N & 0x40) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			if (!asm_DMA_shift_byte(exprs, &W))
				return;

			add_opcode(W & 0xFF);
			if ((W & 0x10) != 0 || (W & 0x03) == 0x03) {
				error_port_B_timing();
				return;
			}
			if (W & 0xCC)
				warn_dma_half_cycle_timing();

			if (W & 0x20) {
				if (utarray_len(exprs) == 0) {
					error_missing_arguments();
					return;
				}
				asm_DEFB_expr(asm_DMA_shift_exprs(exprs));
			}
		}
		break;

	case 3:
		/*
		dma.wr3 n [,w,x]
		or 0x80 into n
		n: bit 7 must be 1, bits 1..0 must be 00 else error "base register byte is illegal"
		If any of bits 6,5,2 of n are set then warning "dma does not support some features"

		If bit 3 of n is set then accept one following byte that can be anything.
		If bit 4 of n is set then accept one following byte that can be anything.
		*/
		if (((N & 0x83) | 0x80) != 0x80) {
			error_base_register_illegal(N);
			return;
		}
		N |= 0x80;

		// add command byte
		add_opcode(N & 0xFF);

		if (N & 0x64)
			warn_dma_unsupported_features();

		if (N & 0x08) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			asm_DEFB_expr(asm_DMA_shift_exprs(exprs));
		}

		if (N & 0x10) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			asm_DEFB_expr(asm_DMA_shift_exprs(exprs));
		}
		break;
		
	case 4:
		/*
		dma.wr4 n, [w,x]
		or 0x81 into n
		n: bit 7 must be 1, bits 1..0 must be 01 else error "base register byte is illegal"
		If bit 4 of n is set then error "dma does not support interrupts"
		If bits 6..5 of n are 00 or 11 error "dma mode is illegal"
		If bit 2 of n is set then accept one following byte\
		If bit 3 of n is set then accept one following byte/ set together, expect word instead

		Again if both bits 2 & 3 are set, w,x must be combined into a single word parameter.
		*/
		if (((N & 0x83) | 0x81) != 0x81) {
			error_base_register_illegal(N);
			return;
		}
		if (N & 0x10) {
			error_dma_unsupported_interrupts();
			return;
		}
		if ((N & 0x60) == 0 || (N & 0x60) == 0x60) {
			error_dma_illegal_mode();
			return;
		}
		N |= 0x81;

		// add command byte
		add_opcode(N & 0xFF);

		if ((N & 0x0C) == 0x0C) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			asm_DEFW(asm_DMA_shift_exprs(exprs));
		}
		else {
			if (N & 0x04) {
				if (utarray_len(exprs) == 0) {
					error_missing_arguments();
					return;
				}
				asm_DEFB_expr(asm_DMA_shift_exprs(exprs));
			}
			if (N & 0x08) {
				if (utarray_len(exprs) == 0) {
					error_missing_arguments();
					return;
				}
				asm_DEFB_expr(asm_DMA_shift_exprs(exprs));
			}
		}
		break;

	case 5:
		/*
		dma.wr5 n
		or 0x82 into n
		n: bits 7..6 must be 10, bits 2..0 must be 010 else error "base register byte is illegal"
		If bit 3 of n is set then warning "dma does not support ready signals"
		*/
		if (((N & 0xC7) | 0x82) != 0x82) {
			error_base_register_illegal(N);
			return;
		}
		N |= 0x82;

		if (N & 0x08)
			warn_dma_ready_signal_unsupported();

		// add command byte
		add_opcode(N & 0xFF);
		
		break;

	case 6:
		/*
		dma.wr6 n [,w] or dma.cmd n [,w]
		n:
		accept 0xcf, 0xd3, 0x87, 0x83, 0xbb
		warning on 0xc3, 0xc7, 0xcb, 0xaf, 0xab, 0xa3, 0xb7, 0xbf, 0x8b, 0xa7, 0xb3 
		"dma does not implement this command"
		anything else error "illegal dma command"

		if n = 0xbb accept a following byte w
		If bit 7 of w is set error "read mask is illegal"

		If any of these are missing following bytes in the comma list then maybe error 
		"missing register group member(s)". 
		if there are too many bytes "too many arguments".
		*/
		switch (N) {
		case 0x83:
		case 0x87:
		case 0xBB:
		case 0xCF:
		case 0xD3:
			break;

		case 0x8B:
		case 0xA3:
		case 0xA7:
		case 0xAB:
		case 0xAF:
		case 0xB3:
		case 0xB7:
		case 0xBF:
		case 0xC3:
		case 0xC7:
		case 0xCB:
			warn_dma_unsupported_command();
			break;

		default:
			error_dma_illegal_command();
			return;
		}

		// add command byte
		add_opcode(N & 0xFF);

		if (N == 0xBB) {
			if (utarray_len(exprs) == 0) {
				error_missing_arguments();
				return;
			}
			if (!asm_DMA_shift_byte(exprs, &W))
				return;

			if (W & 0x80) {
				error_dma_illegal_read_mask();
				return;
			}

			add_opcode(W & 0xFF);
		}
		break;

	default:
		xassert(0);
	}

	// check for extra arguments
	if (utarray_len(exprs) > 0) 
		error_extra_arguments();
}

void asm_DMA_command(int cmd, UT_array *exprs)
{
	if (opts.cpu != CPU_Z80N) {
		error_illegal_ident();
		return;
	}

	xassert(utarray_len(exprs) > 0);
	asm_DMA_command_1(cmd, exprs);
	utarray_clear(exprs);			// clear any expr left over in case of error
}
