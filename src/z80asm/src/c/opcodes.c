/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2022
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define CPU opcodes
*/

#include "../portability.h"
#include "codearea.h"
#include "directives.h"
#include "expr1.h"
#include "opcodes.h"
#include "parse.h"
#include "symtab1.h"
#include "z80asm.h"
#include <assert.h>

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xCB00 */
void add_opcode(int opcode)
{
	bool out = false;
	
	if (opcode & 0xFF000000) {
		out = true;
		append_byte( (opcode >> 24) & 0xFF );
	}

	if (out || (opcode & 0xFF0000)) {
		out = true;
		append_byte( (opcode >> 16) & 0xFF );
	}

	if (out || (opcode & 0xFF00)) {
		out = true;
		append_byte((opcode >> 8) & 0xFF);
	}

	append_byte( opcode & 0xFF );
}

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(int opcode, Expr1 *expr)
{
	add_opcode_jr_n(opcode, expr, 0);
}

void add_opcode_jr_n(int opcode, struct Expr1* expr, int asmpc_offset)
{
	expr->asmpc += asmpc_offset;		// expr is assumed to be at asmpc+1; add offset if this is not true

	if (option_speed()) {
		switch (opcode) {
		case Z80_JR:
			add_opcode(Z80_JP);
			Pass2infoExpr(RANGE_WORD, expr);
			break;
		case Z80_JR_FLAG(FLAG_NZ):
		case Z80_JR_FLAG(FLAG_Z):
		case Z80_JR_FLAG(FLAG_NC):
		case Z80_JR_FLAG(FLAG_C):
			add_opcode(opcode - Z80_JR_FLAG(0) + Z80_JP_FLAG(0));
			Pass2infoExpr(RANGE_WORD, expr);
			break;
		case Z80_DJNZ:		// "dec b; jp nz" is always slower
			add_opcode(opcode);
			Pass2infoExpr(RANGE_JR_OFFSET, expr);
			break;
		default:
			assert(0);
		}
	}
	else {
		add_opcode(opcode);
		Pass2infoExpr(RANGE_JR_OFFSET, expr);
	}
}

/* add opcode followed by 8-bit unsigned expression */
void add_opcode_n(int opcode, Expr1* expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/* add opcode followed by 8-bit offset to 0xff00 expression */
void add_opcode_h(int opcode, Expr1* expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_HIGH_OFFSET, expr);
}

/* add opcode followed by 8-bit unsigned expression and a zero byte */
void add_opcode_n_0(int opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_WORD_UNSIGNED, expr);
}

void add_opcode_s_0(int opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_WORD_SIGNED, expr);
}

/* add opcode followed by 8-bit signed expression */
void add_opcode_d(int opcode, Expr1 *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
}

/* add opcode followed by 16-bit expression */
void add_opcode_nn(int opcode, Expr1 *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD, expr);
}

/* add opcode followed by big-endian 16-bit expression */
void add_opcode_NN(int opcode, struct Expr1 *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD_BE, expr);
}

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(int opcode, Expr1 *expr)
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
void add_opcode_idx_n(int opcode, struct Expr1 *idx_expr,
								  struct Expr1 *n_expr )
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_SIGNED, idx_expr);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n_expr);
}

/* add opcode followed by two 8-bit expressions */
void add_opcode_n_n(int opcode, struct Expr1 *n1_expr,
								struct Expr1 *n2_expr )
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n1_expr);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n2_expr);
}

void add_call_emul_func(char * emul_func)
{ 
	declare_extern_symbol(emul_func);
	Expr1 *emul_expr = parse_expr(emul_func);
	add_opcode_nn(0xCD, emul_expr);
}

/* add Z88's opcodes */
void add_Z88_CALL_OZ(int argument)
{
	if (argument > 0 && argument <= 255)
	{
		append_byte(Z80_RST(0x20));
		append_byte(argument);
	}
	else if (argument > 255)
	{
		append_byte(Z80_RST(0x20));
		append_word(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_CALL_PKG(int argument)
{
	if (argument >= 0)
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
	if (option_ti83() || option_ti83plus()) {
		int opcode;

		if (option_ti83plus())
			opcode = Z80_RST(0x28);		/* Ti83Plus: RST 28H instruction */
		else
			opcode = Z80_CALL;			/* Ti83: CALL */

		if (argument >= 0)
		{
			append_byte(opcode);
			append_word(argument);
		}
		else
			error_int_range(argument);
	}
	else
		error_illegal_ident();
}

// cu.wait VER, HOR   ->  16 - bit encoding 0x8000 + (HOR << 9) + VER
// (0<=VER<=311, 0<=HOR<=55)  BIG ENDIAN!
void add_copper_unit_wait(Expr1 *ver, Expr1 *hor)
{ 
	if (option_cpu() != CPU_Z80N)
		error_illegal_ident();
	else {
		char expr_text[MAXLINE];
		snprintf(expr_text, sizeof(expr_text),
			"0x8000 + (((%s) & 0x3F) << 9) + ((%s) & 0x1FF)", Str_data(hor->text), Str_data(ver->text));
		Expr1 *expr = parse_expr(expr_text);

		Pass2infoExpr(RANGE_WORD_BE, expr);
		OBJ_DELETE(ver);
		OBJ_DELETE(hor);
	}
}

// cu.move REG, VAL  -> 16 - bit encoding(REG << 8) + VAL
// (0<= REG <= 127, 0 <= VAL <= 255)  BIG ENDIAN!
void add_copper_unit_move(Expr1 *reg, Expr1 *val)
{
	if (option_cpu() != CPU_Z80N)
		error_illegal_ident();
	else {
		char expr_text[MAXLINE];
		snprintf(expr_text, sizeof(expr_text),
			"(((%s) & 0x7F) << 8) + ((%s) & 0xFF)", Str_data(reg->text), Str_data(val->text));
		Expr1 *expr = parse_expr(expr_text);

		Pass2infoExpr(RANGE_WORD_BE, expr);
		OBJ_DELETE(reg);
		OBJ_DELETE(val);
	}

}

// cu.stop   -> 16 - bit encoding 0xffff (impossible cu.wait)
void add_copper_unit_stop()
{
	if (option_cpu() != CPU_Z80N)
		error_illegal_ident();
	else
		append_word_be(0xFFFF);
}

// cu.nop  -> 16 - bit encoding 0x0000 (do nothing cu.move)
void add_copper_unit_nop()
{
	if (option_cpu() != CPU_Z80N)
		error_illegal_ident();
	else
		append_word_be(0x0000);
}
