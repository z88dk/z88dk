/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk
*/

#include "die.h"
#include "expr1.h"
#include "if.h"
#include "limits.h"
#include "modlink.h"
#include "scan1.h"
#include "symtab1.h"
#include "types.h"
#include "xassert.h"
#include "zobjfile.h"

/* external functions */

/* local functions */
void Z80pass2(int start_errors, const char* obj_filename)
{
	Expr1ListElem* iter;
	Expr1* expr, * expr2;
	long value;
	bool do_patch;
	long asmpc;		// should be an int!

	/* compute all dependent expressions */
	compute_equ_exprs(CURRENTMODULE->exprs, false, true);

	iter = Expr1List_first(CURRENTMODULE->exprs);
	while (iter != NULL)
	{
		expr = iter->obj;

		/* set error location */
		set_error_location(expr->filename, expr->line_num);
		set_error_source_line(expr->text->data);	// show expression in case of error

		/* Define code location; BUG_0048 */
		set_cur_section(expr->section);
		set_PC(expr->asmpc);

		/* try to evaluate expression to detect missing symbols */
		value = Expr_eval(expr, true);

		/* check if expression is stored in object file or computed and patched */
		do_patch = true;

		if (expr->result.undefined_symbol ||
			expr->result.not_evaluable ||
			expr->result.cross_section_addr ||
			expr->result.extern_symbol ||
			!expr->is_computed)
		{
			do_patch = false;
		}
        else if (expr->range == RANGE_JR_OFFSET || expr->range == RANGE_JRE_OFFSET)
        {
            do_patch = true;
        }
		else if (expr->type >= TYPE_ADDRESS ||
			expr->target_name)
		{
			do_patch = false;            /* store expression in relocatable file */
		}


		if (do_patch)
		{
			switch (expr->range)
			{
			case RANGE_JR_OFFSET:
				asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
				value -= asmpc + expr->opcode_size;		/* get module PC at JR instruction */

                if (value < -128 || value > 127)
                    error_int_range(value);
                else
                    patch_byte(expr->code_pos, (byte_t)value);
                break;

			case RANGE_JRE_OFFSET:
				asmpc = get_phased_PC() >= 0 ? get_phased_PC() : get_PC();
				value -= asmpc + expr->opcode_size;		/* get module PC at JR instruction */

                if (value < -0x8000 || value > 0x7FFF)
                    error_int_range(value);
                else
                    patch_word(expr->code_pos, value);
                break;

			case RANGE_BYTE_UNSIGNED:
				if (value < -128 || value > 255)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			case RANGE_BYTE_SIGNED:
				if (value < -128 || value > 127)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				break;

			case RANGE_HIGH_OFFSET:
				if ((value & 0xff00) != 0) {
					if ((value & 0xff00) != 0xff00)
						warn_int_range(value);
				}

				patch_byte(expr->code_pos, (byte_t)(value & 0xff));
				break;

			case RANGE_WORD:
				patch_word(expr->code_pos, (int)value);
				break;

			case RANGE_BYTE_TO_WORD_UNSIGNED:
				if (value < 0 || value > 255)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				patch_byte(expr->code_pos + 1, 0);
				break;

			case RANGE_BYTE_TO_WORD_SIGNED:
				if (value < -128 || value > 127)
					warn_int_range(value);

				patch_byte(expr->code_pos, (byte_t)value);
				patch_byte(expr->code_pos + 1, value < 0 || value > 127 ? 0xff : 0);
				break;

			case RANGE_PTR24:
				patch_byte(expr->code_pos + 0, (byte_t)((value >> 0) & 0xff));
				patch_byte(expr->code_pos + 1, (byte_t)((value >> 8) & 0xff));
				patch_byte(expr->code_pos + 2, (byte_t)((value >> 16) & 0xff));
				break;

			case RANGE_WORD_BE:
				patch_word_be(expr->code_pos, (int)value);
				break;

			case RANGE_DWORD:
				patch_long(expr->code_pos, value);
				break;

			default:
				xassert(0);
			}
		}

		if (option_list_file()) {
			if (expr->range == RANGE_WORD_BE) {
				int swapped = ((value & 0xFF00) >> 8) | ((value & 0x00FF) << 8);
				list_patch_bytes(expr->listpos, swapped, range_size(expr->range));
			}
			else {
				list_patch_bytes(expr->listpos, value, range_size(expr->range));
			}
		}

		/* continue loop - delete expression unless needs to be stored in object file */
		if (do_patch) {
			/* remove current expression, advance iterator */
			expr2 = Expr1List_remove(CURRENTMODULE->exprs, &iter);
			xassert(expr == expr2);

			OBJ_DELETE(expr);
		}
		else
			iter = Expr1List_next(iter);
	}

	// check for undefined symbols
	check_undefined_symbols(CURRENTMODULE->local_symtab);
	check_undefined_symbols(global_symtab);

	/* clean error location */
	clear_error_location();

	/* create object file */
	if (start_errors == get_num_errors())
		write_obj_file(obj_filename);

	// add to the list of objects to link
	if (start_errors == get_num_errors())
        object_file_append(obj_filename, CURRENTMODULE);

	if (start_errors == get_num_errors() && option_symtable())
		write_sym_file(CURRENTMODULE);
}


bool Pass2infoExpr(range_t range, Expr1* expr)
{
	if (expr != NULL)
	{
		expr->range = range;
		expr->code_pos = get_cur_module_size();			/* update expression location */
		expr->opcode_size = get_cur_opcode_size() + range_size(range);

		if (list_is_on())
			expr->listpos = expr->code_pos;
		else
			expr->listpos = -1;

		Expr1List_push(&CURRENTMODULE->exprs, expr);
	}

	/* reserve space */
	append_defs(range_size(range), 0);

	return expr == NULL ? false : true;
}

bool Pass2info(range_t range)
{
	Expr1* expr;

	/* Offset of (ix+d) should be optional; '+' or '-' are necessary */
	if (range == RANGE_BYTE_SIGNED)
	{
		switch (sym.tok)
		{
		case TK_RPAREN:
			append_byte(0);		/* offset zero */
			return true;		/* OK, zero already stored */

		case TK_PLUS:
		case TK_MINUS:          /* + or - expected */
			break;				/* proceed to evaluate expression */

		default:                /* Syntax error, e.g. (ix 4) */
			error_syntax();
			return false;		/* FAIL */
		}

	}

	expr = expr_parse();

	if (range == RANGE_BYTE_SIGNED && sym.tok != TK_RPAREN)
	{
		error_syntax();
		return false;		/* FAIL */
	}

	return Pass2infoExpr(range, expr);
}
