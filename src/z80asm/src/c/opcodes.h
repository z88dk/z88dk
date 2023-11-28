/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2023
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
void add_opcode(int opcode);

/* add opcode followed by jump relative offset expression */
void add_opcode_jr(int opcode, struct Expr1 *expr);

/* add opcode followed by jump relative offset expression */
void add_opcode_jre(int opcode, struct Expr1 *expr);

/* add opcodes followed by jump relative offset expression to the same address*/
void add_opcode_jr_jr(int opcode0, int opcode1, struct Expr1 *expr0);

/* add opcode followed by 8-bit unsigned expression */
void add_opcode_n(int opcode, struct Expr1 *expr);

/* add opcode followed by 8-bit offset to 0xff00 expression */
void add_opcode_h(int opcode, struct Expr1* expr);

/* add opcode followed by 8-bit unsigned expression and a zero byte */
void add_opcode_n_0(int opcode, struct Expr1* expr);

/* add opcode followed by 8-bit signed expression and a zero or 0xff byte depending on sign */
void add_opcode_s_0(int opcode, struct Expr1* expr);

/* add opcode followed by 8-bit signed expression */
void add_opcode_d(int opcode, struct Expr1 *expr);

/* add opcode followed by 16-bit expression */
void add_opcode_nn(int opcode, struct Expr1 *expr, int target_offset);

/* add opcodes followed by the same 16-bit expression */
void add_opcode_nn_nn(int opcode0, int opcode1, struct Expr1 *expr0);

/* add opcode followed by 24-bit expression */
void add_opcode_nnn(int opcode, struct Expr1 *expr, int target_offset);

/* add opcode followed by 32-bit expression */
void add_opcode_nnnn(int opcode, struct Expr1 *expr);

/* add opcode followed by big-endian 16-bit expression */
void add_opcode_NN(int opcode, struct Expr1 *expr);

/* add opcode followed by IX/IY offset expression */
void add_opcode_idx(int opcode, struct Expr1 *expr);

/* add two (ix+d) and (ix+d+1) opcodes */
void add_opcode_idx_idx1(int opcode0, int opcode1, struct Expr1* expr);

/* add opcode followed by IX/IY offset expression and 8 bit expression */
void add_opcode_idx_n(int opcode, struct Expr1 *idx_expr,
										 struct Expr1 *n_expr );

/* add opcode followed by two 8-bit expressions */
void add_opcode_n_n(int opcode, struct Expr1 *n1_expr,
									   struct Expr1 *n2_expr );

/* add defb opcode with 8-bit data */
void add_opcode_defb(struct Expr1* expr);

/* call emulation function by name */
void add_call_emul_func(char *emul_func);

/* add RST opcode */
void add_rst_opcode(int arg);

/* add jump to text label - offset */
void add_opcode_jr_end(int opcode, const char* end_label, int offset);
void add_opcode_nn_end(int opcode, const char* end_label, int offset);
void add_opcode_nnn_end(int opcode, const char* end_label, int offset);

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
