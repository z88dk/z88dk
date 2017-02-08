/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define CPU opcodes
*/

#include "directives.h"
#include "expr.h"
#include "codearea.h"
#include "model.h"
#include "opcodes.h"
#include "parse.h"
#include "z80asm.h"

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xCB00 */
void add_opcode(int opcode)
{
	if ( opcode & 0xFF000000 )
		append_byte( (opcode >> 24) & 0xFF );
	if ( opcode & 0xFF0000 )
		append_byte( (opcode >> 16) & 0xFF );
	if ( opcode & 0xFF00 )
		append_byte( (opcode >> 8) & 0xFF );
	append_byte( opcode & 0xFF );
}

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_JR_OFFSET, expr);
}

/* add opcode followed by 8-bit expression */
void add_opcode_n(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/* add opcode followed by 16-bit expression */
void add_opcode_nn(int opcode, Expr *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD, expr);
}

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(int opcode, Expr *expr)
{
	if (opcode & 0xFF0000) 
	{				/* 3 bytes, insert idx offset as 2nd byte */
		add_opcode( (opcode >> 8) & 0xFFFF );
		Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
		add_opcode( opcode & 0xFF );
	}
	else
	{
		add_opcode(opcode);
		Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
	}
}

/* add opcode followed by IX/IY offset expression and 8 bit expression */
void add_opcode_idx_n(int opcode, struct Expr *idx_expr,
								  struct Expr *n_expr )
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_SIGNED, idx_expr);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n_expr);
}

/* add "call flag", or emulation on a Rabbit */
void add_call_flag(int flag, Expr *target)
{
	char *end_label;
	Expr *end_label_expr;
	int jump_size;

	if (!(opts.cpu & CPU_RABBIT))
		add_opcode_nn(Z80_CALL_FLAG(flag), target);
	else
	{
		end_label = autolabel();
		end_label_expr = parse_expr(end_label);

		if (flag <= FLAG_C)
		{
			add_opcode_jr(Z80_JR_FLAG(NOT_FLAG(flag)), end_label_expr);
			jump_size = 2;
		}
		else
		{
			add_opcode_nn(Z80_JP_FLAG(NOT_FLAG(flag)), end_label_expr);
			jump_size = 3;
		}

		add_opcode_nn(Z80_CALL, target);

		asm_LABEL_offset(end_label, jump_size + 3);
	}
}

/* add opcode, or call emulation function on a Rabbit */
void add_opcode_emul(int opcode, char *emul_func)
{
	Expr *emul_func_expr;

	if (!(opts.cpu & CPU_RABBIT))
		add_opcode(opcode);
	else
	{
		declare_extern_symbol(emul_func);
		emul_func_expr = parse_expr(emul_func);
		add_opcode_nn(Z80_CALL, emul_func_expr);
	}
}

/* add Z88's opcodes */
void add_Z88_CALL_OZ(int argument)
{
	if (argument > 0 && argument <= 255)
	{
		append_byte(Z80_RST(0x20));
		append_byte(argument);
	}
	else if (argument > 255 && argument <= 65535)
	{
		append_byte(Z80_RST(0x20));
		append_word(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_CALL_PKG(int argument)
{
	if (argument >= 0 && argument <= 65535)
	{
		append_byte(Z80_RST(0x08));
		append_word(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_FPP(int argument)
{
	if (argument > 0 && argument < 255)
	{
		append_byte(Z80_RST(0x18));
		append_byte(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_INVOKE(int argument)
{
	int opcode;

	if (opts.ti83plus)
		opcode = Z80_RST(0x28);		/* Ti83Plus: RST 28H instruction */
	else
		opcode = Z80_CALL;			/* Ti83: CALL */

	if (argument >= 0 && argument <= 65535)
	{
		append_byte(opcode);
		append_word(argument);
	}
	else
		error_int_range(argument);
}
