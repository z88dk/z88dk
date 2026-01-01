/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2026
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/z88dk/z88dk

Define CPU opcodes
*/

#pragma once

#include "z80asm_defs.h"

/* forward declaration without include cycle */
struct Expr1;

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xED46 */
void add_opcode(long long opcode);

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(long long opcode, struct Expr1 *expr);

/* add opcode followed by jump relative offset expression */
void add_opcode_jre(long long opcode, struct Expr1 *expr);

/* add opcodes followed by jump relative offset expression to the same address*/
void add_opcode_jr_jr(long long opcode0, int opcode1, struct Expr1 *expr0);

/* add opcode followed by 8-bit unsigned expression */
void add_opcode_n(long long opcode, struct Expr1 *expr);

/* add opcode followed by 8-bit offset to 0xff00 expression */
void add_opcode_h(long long opcode, struct Expr1* expr);

/* add opcode followed by 8-bit unsigned expression and a zero byte */
void add_opcode_n_0(long long opcode, struct Expr1* expr);

/* add opcode followed by 8-bit unsigned expression and two zero bytes */
void add_opcode_n_0_0(long long opcode, struct Expr1* expr);

/* add opcode followed by 8-bit signed expression and a zero or 0xff byte depending on sign */
void add_opcode_s_0(long long opcode, struct Expr1* expr);

/* add opcode followed by 8-bit signed expression and two zeros or 0xff bytes depending on sign */
void add_opcode_s_0_0(long long opcode, struct Expr1* expr);

/* add opcode followed by 8-bit signed expression */
void add_opcode_d(long long opcode, struct Expr1 *expr);

/* add opcode followed by 16-bit expression */
void add_opcode_nn(long long opcode, struct Expr1 *expr, int target_offset);

/* add opcodes followed by the same 16-bit expression */
void add_opcode_nn_nn(long long opcode0, long long opcode1, struct Expr1 *expr0);

/* add opcode followed by 24-bit expression */
void add_opcode_nnn(long long opcode, struct Expr1 *expr, int target_offset);

/* add opcode followed by 32-bit expression */
void add_opcode_nnnn(long long opcode, struct Expr1 *expr);

/* add opcode followed by big-endian 16-bit expression */
void add_opcode_NN(long long opcode, struct Expr1 *expr);

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(long long opcode, struct Expr1 *expr);

/* add two (ix+d) and (ix+d+1) opcodes */
void add_opcode_idx_idx1(long long opcode0, long long opcode1, struct Expr1* expr);

/* add opcode followed by IX/IY offset expression and 8 bit expression */
void add_opcode_idx_n(long long opcode, struct Expr1 *idx_expr,
										 struct Expr1 *n_expr );

/* add opcode followed by two 8-bit expressions */
void add_opcode_n_n(long long opcode, struct Expr1* n1_expr,
    struct Expr1* n2_expr);

/* add opcode followed by two 16-bit address and 8-bit segment*/
void add_opcode_x_nn(long long opcode, struct Expr1* x_expr, struct Expr1* nn_expr);

/* add opcode followed by two 16-bit address and 16-bit segment*/
void add_opcode_xx_nn(long long opcode, struct Expr1* xx_expr, struct Expr1* nn_expr);

/* add defb opcode with 8-bit data */
void add_opcode_defb(struct Expr1* expr);

/* call emulation function by name */
void add_call_emul_func(char *emul_func);

/* add jump to text label - offset */
void add_opcode_jr_end(long long opcode, const char* end_label, int offset);
void add_opcode_jp_nn_end(long long opcode, const char* end_label, int offset);
void add_opcode_jp_nnn_end(long long opcode, const char* end_label, int offset);

/* add Z88's opcodes */
void add_Z88_CALL_OZ(int argument);
void add_Z88_CALL_PKG(int argument);
void add_Z88_FPP(int argument);
void add_Z88_INVOKE(int argument);

/* add COPPER UNIT opcodes (ZX Next) */
void add_copper_unit_wait(struct Expr1 *ver, struct Expr1 *hor);
void add_copper_unit_move(struct Expr1 *reg, struct Expr1 *val);
void add_copper_unit_stop();
void add_copper_unit_nop();
