/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2024
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define CPU opcodes
*/

#include "../portability.h"
#include "codearea.h"
#include "directives.h"
#include "errors.h"
#include "expr1.h"
#include "opcodes.h"
#include "options.h"
#include "parse1.h"
#include "symtab1.h"
#include "xassert.h"
#include "z80asm_defs.h"
#include "z80asm1.h"

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xCB00
*  need 64 bits to be able to code "ld ix, 0" in ez80, 0xDD,0x21,0x00,0x00,0x00 */
void add_opcode(long long opcode)
{
	bool out = false;
	
	if (out || (opcode & 0xFF0000000000LL)) {
		out = true;
		append_byte( (opcode >> 40) & 0xFF );
	}

	if (out || (opcode & 0xFF00000000LL)) {
		out = true;
		append_byte( (opcode >> 32) & 0xFF );
	}

	if (out || (opcode & 0xFF000000LL)) {
		out = true;
		append_byte( (opcode >> 24) & 0xFF );
	}

	if (out || (opcode & 0xFF0000LL)) {
		out = true;
		append_byte( (opcode >> 16) & 0xFF );
	}

	if (out || (opcode & 0xFF00LL)) {
		out = true;
		append_byte((opcode >> 8) & 0xFF);
	}

	append_byte( opcode & 0xFF );
}

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(long long opcode, Expr1 *expr)
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
        case R4K_DWJNZ:		// "dec b; jp nz" is always slower
        case (Z80_DEC(REG_B) << 8) | Z80_JR_FLAG(FLAG_NZ):
        case (RABBIT_ALTD << 8) | Z80_DJNZ:
        case (RABBIT_ALTD << 16) | R4K_DWJNZ:
            add_opcode(opcode);
            Pass2infoExpr(RANGE_JR_OFFSET, expr);
            break;
        case R4K_JR_FLAG(FLAG_R4K_GT):            // jr cx is faster than jp cx
        case R4K_JR_FLAG(FLAG_R4K_GTU):
        case R4K_JR_FLAG(FLAG_R4K_LT):
        case R4K_JR_FLAG(FLAG_R4K_V):
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

void add_opcode_jre(long long opcode, struct Expr1* expr) {
    add_opcode(opcode);
    Pass2infoExpr(RANGE_JRE_OFFSET, expr);
}

/* add opcodes followed by jump relative offset expression to the same address*/
void add_opcode_jr_jr(long long opcode0, int opcode1, struct Expr1* expr0)
{
    // build expr1 = expr0
    UT_string* expr1_text;
    utstring_new(expr1_text);
    utstring_printf(expr1_text, "%s", expr0->text->data);

    add_opcode_jr(opcode0, expr0);

    struct Expr1* expr1 = parse_expr(utstring_body(expr1_text));
    if (expr1)
        add_opcode_jr(opcode1, expr1);

    utstring_free(expr1_text);
}

/* add opcode followed by 8-bit unsigned expression */
void add_opcode_n(long long opcode, Expr1* expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

/* add opcode followed by 8-bit offset to 0xff00 expression */
void add_opcode_h(long long opcode, Expr1* expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_HIGH_OFFSET, expr);
}

/* add opcode followed by 8-bit unsigned expression and a zero byte */
void add_opcode_n_0(long long opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_WORD_UNSIGNED, expr);
}

/* add opcode followed by 8-bit unsigned expression and two zero bytes */
void add_opcode_n_0_0(long long opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_PTR_UNSIGNED, expr);
}

/* add opcode followed by 8-bit signed expression and a 0x00/0xFF byte */
void add_opcode_s_0(long long opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_WORD_SIGNED, expr);
}

/* add opcode followed by 8-bit signed expression and two zeros or 0xff bytes depending on sign */
void add_opcode_s_0_0(long long opcode, struct Expr1* expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_BYTE_TO_PTR_SIGNED, expr);
}

/* add opcode followed by 8-bit signed expression */
void add_opcode_d(long long opcode, Expr1 *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_SIGNED, expr);
}

/* add opcode followed by 16-bit expression */
void add_opcode_nn(long long opcode, Expr1 *expr, int target_offset) {
	if (target_offset != 0) {
		// build expr1 = expr+target_offset
		UT_string* expr1_text;
		utstring_new(expr1_text);
		utstring_printf(expr1_text, "+(%s)+%d", expr->text->data, target_offset);

		struct Expr1* expr1 = parse_expr(utstring_body(expr1_text));
		xassert(expr1);
		
		add_opcode(opcode);
		Pass2infoExpr(RANGE_WORD, expr1);

		utstring_free(expr1_text);
	}
	else {
		add_opcode(opcode);
		Pass2infoExpr(RANGE_WORD, expr);
	}
}

/* add opcodes followed by the same 16-bit expression */
void add_opcode_nn_nn(long long opcode0, long long opcode1, struct Expr1* expr0)
{
    // build expr1 = expr0
    UT_string* expr1_text;
    utstring_new(expr1_text);
    utstring_printf(expr1_text, "%s", expr0->text->data);

    add_opcode_nn(opcode0, expr0, 0);

    struct Expr1* expr1 = parse_expr(utstring_body(expr1_text));
    if (expr1)
        add_opcode_nn(opcode1, expr1, 0);

    utstring_free(expr1_text);
}

/* add opcode followed by 24-bit expression */
void add_opcode_nnn(long long opcode, struct Expr1 *expr, int target_offset) {
	if (target_offset != 0) {
		// build expr1 = expr+target_offset
		UT_string* expr1_text;
		utstring_new(expr1_text);
		utstring_printf(expr1_text, "+(%s)+%d", expr->text->data, target_offset);

		struct Expr1* expr1 = parse_expr(utstring_body(expr1_text));
		xassert(expr1);
		
		add_opcode(opcode);
		Pass2infoExpr(RANGE_PTR24, expr1);

		utstring_free(expr1_text);
	}
	else {
		add_opcode(opcode);
		Pass2infoExpr(RANGE_PTR24, expr);
	}
}

/* add opcode followed by 32-bit expression */
void add_opcode_nnnn(long long opcode, struct Expr1 *expr) {
	add_opcode(opcode);
	Pass2infoExpr(RANGE_DWORD, expr);
}

/* add opcode followed by big-endian 16-bit expression */
void add_opcode_NN(long long opcode, struct Expr1 *expr)
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_WORD_BE, expr);
}

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(long long opcode, Expr1 *expr)
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
void add_opcode_idx_idx1(long long opcode0, long long opcode1, struct Expr1* expr0) {
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
void add_opcode_idx_n(long long opcode, struct Expr1 *idx_expr,
								  struct Expr1 *n_expr )
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_SIGNED, idx_expr);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n_expr);
}

/* add opcode followed by two 8-bit expressions */
void add_opcode_n_n(long long opcode, struct Expr1 *n1_expr,
								struct Expr1 *n2_expr )
{
	add_opcode(opcode);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n1_expr);
	Pass2infoExpr(RANGE_BYTE_UNSIGNED, n2_expr);
}

/* add opcode followed by two 16-bit address and 8-bit segment*/
void add_opcode_x_nn(long long opcode, Expr1* x_expr, Expr1* nn_expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_WORD, nn_expr);
    Pass2infoExpr(RANGE_BYTE_UNSIGNED, x_expr);
}

/* add opcode followed by two 16-bit address and 16-bit segment*/
void add_opcode_xx_nn(long long opcode, Expr1* xx_expr, Expr1* nn_expr)
{
    add_opcode(opcode);
    Pass2infoExpr(RANGE_WORD, nn_expr);
    Pass2infoExpr(RANGE_WORD, xx_expr);
}

/* add defb opcode with 8-bit data */
void add_opcode_defb(struct Expr1* expr) {
    Pass2infoExpr(RANGE_BYTE_UNSIGNED, expr);
}

void add_call_emul_func(char * emul_func)
{ 
	declare_extern_symbol(emul_func);
	Expr1 *emul_expr = parse_expr(emul_func);
    cpu_t cpu = option_cpu();
    if (cpu == CPU_EZ80 || cpu == CPU_EZ80_STRICT)
        add_opcode_nnn(0xCD, emul_expr, 0);
    else
        add_opcode_nn(0xCD, emul_expr, 0);
}

/* add jump relative to text label - offset */
void add_opcode_jr_end(long long opcode, const char* end_label, int offset)
{
	UT_string* target;
	utstring_new(target);
	utstring_printf(target, "%s-%d", end_label, offset);
	Expr1 *target_expr = parse_expr(utstring_body(target));
	add_opcode_jr(opcode, target_expr);			//jump over
	utstring_free(target);
}

void add_opcode_jp_nn_end(long long opcode, const char* end_label, int offset)
{
	UT_string* target;
	utstring_new(target);
	utstring_printf(target, "%s-%d", end_label, offset);
	Expr1 *target_expr = parse_expr(utstring_body(target));
	add_opcode_nn(opcode, target_expr, 0);			//jump over
	utstring_free(target);
}

void add_opcode_jp_nnn_end(long long opcode, const char* end_label, int offset)
{
	UT_string* target;
	utstring_new(target);
	utstring_printf(target, "%s-%d", end_label, offset);
	Expr1 *target_expr = parse_expr(utstring_body(target));
	add_opcode_nnn(opcode, target_expr, 0);			//jump over
	utstring_free(target);
}

/* add Z88's opcodes */
void add_Z88_CALL_OZ(int argument)
{
	if (argument > 0 && argument <= 255)
	{
        add_opcode(Z80_RST(0x20));
		append_byte(argument);
	}
	else if (argument > 255)
	{
        add_opcode(Z80_RST(0x20));
		append_word(argument);
	}
	else
        error_hex4(ErrIntRange, argument);
}

void add_Z88_CALL_PKG(int argument)
{
    cpu_t cpu = option_cpu();
    if (cpu == CPU_R2KA || cpu == CPU_R2KA_STRICT ||
        cpu == CPU_R3K  || cpu == CPU_R3K_STRICT  ||
        cpu == CPU_R4K  || cpu == CPU_R4K_STRICT  ||
        cpu == CPU_R5K  || cpu == CPU_R5K_STRICT  ||
        cpu == CPU_R6K  || cpu == CPU_R6K_STRICT) {
        error_hex4(ErrIntRange, argument);
    }
	else if (argument >= 0)
	{
        add_opcode(Z80_RST(0x08));
		append_word(argument);
	}
    else {
        error_hex4(ErrIntRange, argument);
	}
}

void add_Z88_FPP(int argument)
{
	if (argument > 0 && argument < 255)
	{
        add_opcode(Z80_RST(0x18));
		append_byte(argument);
	}
	else
        error_hex2(ErrIntRange, argument);
}

void add_Z88_INVOKE(int argument)
{
	if (option_ti83() || option_ti83plus()) {
		if (option_ti83plus())
            add_opcode(Z80_RST(0x28));	/* Ti83Plus: RST 28H instruction */
		else
			append_byte(Z80_CALL);		/* Ti83: CALL */

		if (argument >= 0)
			append_word(argument);
		else
            error_hex4(ErrIntRange, argument);
	}
	else
		error(ErrIllegalIdent, NULL);
}

// cu.wait VER, HOR   ->  16 - bit encoding 0x8000 + (HOR << 9) + VER
// (0<=VER<=311, 0<=HOR<=55)  BIG ENDIAN!
void add_copper_unit_wait(Expr1 *ver, Expr1 *hor)
{ 
    cpu_t cpu = option_cpu();
    if (cpu != CPU_Z80N && cpu != CPU_Z80N_STRICT)
		error(ErrIllegalIdent, NULL);
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
    cpu_t cpu = option_cpu();
    if (cpu != CPU_Z80N && cpu != CPU_Z80N_STRICT)
		error(ErrIllegalIdent, NULL);
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
    cpu_t cpu = option_cpu();
    if (cpu != CPU_Z80N && cpu != CPU_Z80N_STRICT)
		error(ErrIllegalIdent, NULL);
	else
		append_word_be(0xFFFF);
}

// cu.nop  -> 16 - bit encoding 0x0000 (do nothing cu.move)
void add_copper_unit_nop()
{
    cpu_t cpu = option_cpu();
    if (cpu != CPU_Z80N && cpu != CPU_Z80N_STRICT)
		error(ErrIllegalIdent, NULL);
	else
		append_word_be(0x0000);
}
