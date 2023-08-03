/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define CPU opcodes
*/

#include "../portability.h"
#include "codearea.h"
#include "directives.h"
#include "expr1.h"
#include "z80asm_cpu.h"
#include "opcodes.h"
#include "parse.h"
#include "symtab1.h"
#include "z80asm.h"
#include <assert.h>

enum { FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO_LZ, FLAG_PE_LO, FLAG_P, FLAG_M };
#define Z80_DJNZ			0x10
#define Z80_JR				0x18
#define Z80_JP				0xC3
#define Z80_JR_FLAG(flag)	(0x20 + ((flag) << 3))
#define Z80_JP_FLAG(flag)	(0xC2 + ((flag) << 3))
#define Z80_CALL			0xCD

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
			xassert(0);
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

/* add opcode followed by 8-bit signed expression and a 0x00/0xFF byte */
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

/* add opcode followed by 24-bit expression */
void add_opcode_nnn(int opcode, struct Expr1 *expr) {
	add_opcode(opcode);
	Pass2infoExpr(RANGE_PTR24, expr);
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

/* add two (ix+d) and (ix+d+1) opcodes */
void add_opcode_idx_idx1(int opcode0, int opcode1, struct Expr1* expr0) {
	// build expr1 = 1+(expr)
	UT_string* expr1_text;
	utstring_new(expr1_text);
	utstring_printf(expr1_text, "1+(%s)", expr0->text->data);

	add_opcode_idx(opcode0, expr0);
	struct Expr1* expr1 = parse_expr(utstring_body(expr1_text));
	if (expr1) 
		add_opcode_idx(opcode1, expr1);

	utstring_free(expr1_text);
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

void add_rst_opcode(int arg) {
    if (arg > 0 && arg < 8)
        arg *= 8;
    switch (arg) {
    case 0x00: case 0x08: case 0x30:
        if (option_cpu() == CPU_R2KA || option_cpu() == CPU_R3K)
            add_opcode(0xCD0000 + (arg << 8));
        else
            add_opcode(0xC7 + arg);
        break;
    case 0x10: case 0x18: case 0x20: case 0x28: case 0x38:
        add_opcode(0xC7 + arg); break;
    default: error_int_range(arg);
    }
}

/* add Z88's opcodes */
void add_Z88_CALL_OZ(int argument)
{
	if (argument > 0 && argument <= 255)
	{
        add_rst_opcode(0x20);
		append_byte(argument);
	}
	else if (argument > 255)
	{
        add_rst_opcode(0x20);
		append_word(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_CALL_PKG(int argument)
{
	if (argument >= 0)
	{
        add_rst_opcode(0x08);
		append_word(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_FPP(int argument)
{
	if (argument > 0 && argument < 255)
	{
        add_rst_opcode(0x18);
		append_byte(argument);
	}
	else
		error_int_range(argument);
}

void add_Z88_INVOKE(int argument)
{
	if (option_ti83() || option_ti83plus()) {
		if (option_ti83plus())
            add_rst_opcode(0x28);		/* Ti83Plus: RST 28H instruction */
		else
			append_byte(Z80_CALL);		/* Ti83: CALL */

		if (argument >= 0)
			append_word(argument);
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
