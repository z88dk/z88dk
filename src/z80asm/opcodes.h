/*
Z88DK Z80 Macro Assembler

Copyright (C) Gunther Strube, InterLogic 1993-99
Copyright (C) Paulo Custodio, 2011-2017
License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
Repository: https://github.com/pauloscustodio/z88dk-z80asm

Define CPU opcodes
*/

#pragma once

#include "errors.h"
#include "options.h"

/* forward declaration without include cycle */
struct Expr;

/* add 1 to 4 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xED46 */
extern void add_opcode(int opcode);

/* add opcode followed by jump relative offset expression */
extern void add_opcode_jr(int opcode, struct Expr *expr);

/* add opcode followed by 8-bit expression */
extern void add_opcode_n(int opcode, struct Expr *expr);

/* add opcode followed by 16-bit expression */
extern void add_opcode_nn(int opcode, struct Expr *expr);

/* add opcode followed by IX/IY offset expression */
extern void add_opcode_idx(int opcode, struct Expr *expr);

/* add opcode followed by IX/IY offset expression and 8 bit expression */
extern void add_opcode_idx_n(int opcode, struct Expr *idx_expr,
										 struct Expr *n_expr );

/* add "call flag", or emulation on a Rabbit */
extern void add_call_flag(int flag, struct Expr *target);

/* add opcode, or call emulation function on a Rabbit */
extern void add_opcode_emul(int opcode, char *emul_func);

/* add Z88's opcodes */
extern void add_Z88_CALL_OZ(int argument);
extern void add_Z88_CALL_PKG(int argument);
extern void add_Z88_FPP(int argument);
extern void add_Z88_INVOKE(int argument);

/* assert we are on a Z80 */
#define _Z80_ONLY(x)		((opts.cpu & CPU_RABBIT) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _RABBIT_ONLY(x)		(!(opts.cpu & CPU_RABBIT) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _Z180_ONLY(x)		(!(opts.cpu & CPU_Z180) ? \
								(error_illegal_ident(), 0) : \
								(x))

/* Index prefix constants */
#define P_BC	0
#define P_DE	0
#define P_HL	0
#define P_AF	0
#define P_SP	0
#define P_IX	(opts.swap_ix_iy ? 0xFD00 : 0xDD00)
#define P_IY	(opts.swap_ix_iy ? 0xDD00 : 0xFD00)

/* Flags constants */
enum { FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO, FLAG_PE, FLAG_P, FLAG_M };
#define NOT_FLAG(flag)	((flag) ^ 1)

/* 8-bit registers */
enum { REG_B, REG_C, REG_D, REG_E, REG_H, REG_L, REG_idx, REG_A, REG_F=6 };
#define REG_IXH _Z80_ONLY(REG_H)
#define REG_IYH _Z80_ONLY(REG_H)
#define REG_IXL _Z80_ONLY(REG_L)
#define REG_IYL _Z80_ONLY(REG_L)

/* 16-bit registers */
enum { REG_BC, REG_DE, REG_HL, REG_SP, 
	   REG_AF = REG_SP,
	   REG_IX = REG_HL, REG_IY = REG_HL,
	   REG_IND_BC = 0, REG_IND_DE };

/* ALU operations */
enum { ALU_ADD, ALU_ADC, ALU_SUB, ALU_SBC, ALU_AND, ALU_XOR, ALU_OR, ALU_CP };
#define _Z80_ALU(alu,reg)	(0x80 + ((alu) << 3) + (reg))
#define _Z80_ALU_n(alu)		(0xC0 + ((alu) << 3) + REG_idx)

/* Rotate and shift operations */
enum { RS_RLC, RS_RRC, RS_RL, RS_RR, RS_SLA, RS_SRA, RS_SLL, RS_SRL };
#define _Z80_RS(rs,reg)		(0xCB00 + ((rs) << 3) + (reg))

/* Bit instructions */
enum { BRS_BIT = 0x40, BRS_RES = 0x80, BRS_SET = 0xC0 };
#define _CHECK_BIT(bit)		((bit) >= 0 && (bit) < 8 ? \
								(bit) : \
								(error_int_range(bit),0) \
							)
#define _Z80_BRS(brs,bit,reg) (0xCB00 + (brs) + (_CHECK_BIT(bit) << 3) + (reg))

/* choose value, error if none */
#define _CHOOSE2_(n, i1, o1, i2, o2)	\
			((n) == (i1) ? (o1) : \
			 (n) == (i2) ? (o2) : \
			 (error_int_range(n), 0))		/* ,0 to transform (void) into (int) */
#define _CHOOSE3_(n, i1, o1, i2, o2, i3, o3)	\
			((n) == (i1) ? (o1) : \
			 _CHOOSE2_((n), (i2), (o2), (i3), (o3)))

/* choose RST opcode */
#define _RST_ARG(n)			((n) < 0 || (n) > 0x38 || (((n) & 7) != 0) ? \
								(error_int_range(n),0) : \
								((opts.cpu & CPU_RABBIT) && \
									((n) == 0 || (n) == 8 || (n) == 0x30) ? \
										(error_illegal_ident(),0) : \
										0xC7 + (n)))

/* Z80 opcodes 
*  n is a constant
*  flag is FLAG_NZ, FLAG_... 
*  reg is REG_BC, ... */
#define Z80_ADC(reg)		_Z80_ALU(ALU_ADC, (reg))
#define Z80_ADC16(reg)		(0xED4A + ((reg) << 4))
#define Z80_ADC_n			_Z80_ALU_n(ALU_ADC)
#define Z80_ADD(reg)		_Z80_ALU(ALU_ADD, (reg))
#define Z80_ADD16(reg)		(0x09 + ((reg) << 4))
#define Z80_ADD_n			_Z80_ALU_n(ALU_ADD)
#define Z80_AND(reg)		_Z80_ALU(ALU_AND, (reg))
#define Z80_AND_n			_Z80_ALU_n(ALU_AND)
#define Z80_BIT(bit,reg)	_Z80_BRS(BRS_BIT, (bit), (reg))
#define Z80_CALL			0xCD
#define Z80_CALL_FLAG(flag)	(0xC4 + ((flag) << 3))
#define Z80_CCF				0x3F
#define Z80_CP(reg)			_Z80_ALU(ALU_CP, (reg))
#define Z80_CPD				0xEDA9
#define Z80_CPDR			0xEDB9
#define Z80_CPI				0xEDA1
#define Z80_CPIR			0xEDB1
#define Z80_CPL				0x2F
#define Z80_CP_n			_Z80_ALU_n(ALU_CP)
#define Z80_DAA				_Z80_ONLY(0x27)
#define Z80_DEC(reg)		(0x05 + ((reg) << 3))
#define Z80_DEC16(reg)		(0x0B + ((reg) << 4))
#define Z80_DI				_Z80_ONLY(0xF3)
#define Z80_DJNZ			0x10
#define Z80_EI				_Z80_ONLY(0xFB)
#define Z80_EXX				0xD9
#define Z80_EX_AF_AF		0x08
#define Z80_EX_DE_HL		0xEB
#define Z80_EX_IND_SP_HL	((opts.cpu & CPU_RABBIT) ? 0xED54 : 0xE3)
#define Z80_EX_IND_SP_idx	0xE3	/* (IX) or (IY) */
#define Z80_HALT			_Z80_ONLY(0x76)
#define Z80_IM(n)			_Z80_ONLY(_CHOOSE3_((n), 0, 0xED46, 1, 0xED56, 2, 0xED5E))
#define Z80_INC(reg)		(0x04 + ((reg) << 3))
#define Z80_INC16(reg)		(0x03 + ((reg) << 4))
#define Z80_IND				_Z80_ONLY(0xEDAA)
#define Z80_INDR			_Z80_ONLY(0xEDBA)
#define Z80_INI				_Z80_ONLY(0xEDA2)
#define Z80_INIR			_Z80_ONLY(0xEDB2)
#define Z80_IN_A_n			_Z80_ONLY(0xDB)
#define Z80_IN_REG_C(reg)	_Z80_ONLY((0xED40 + ((reg) << 3)))
#define Z80_JP				0xC3
#define Z80_JP_FLAG(flag)	(0xC2 + ((flag) << 3))
#define Z80_JP_idx			0xE9	/* (HL) or (IX) or (IY) */
#define Z80_JR				0x18
#define Z80_JR_FLAG(flag)	(0x20 + ((flag) << 3))
#define Z80_LDD				0xEDA8
#define Z80_LDDR			0xEDB8
#define Z80_LDI				0xEDA0
#define Z80_LDIR 			0xEDB0
#define Z80_LD_A_IND_NN		0x3A
#define Z80_LD_A_IND_dd(dd)	(0x0A + ((dd) << 4))
#define Z80_LD_IND_NN_A		0x32
#define Z80_LD_IND_dd_A(dd)	(0x02 + ((dd) << 4))
#define Z80_LD_IND_nn_dd(dd) (0xED43 + ((dd) << 4))
#define Z80_LD_IND_nn_idx	0x22
#define Z80_LD_SP_idx		0xF9
#define Z80_LD_dd_IND_nn(dd) (0xED4B + ((dd) << 4))
#define Z80_LD_dd_nn(dd)	(0x01 + ((dd) << 4))
#define Z80_LD_idx_IND_nn	0x2A
#define Z80_LD_r_n(r)		(0x06 + ((r) << 3))
#define Z80_LD_r_r(r1,r2)	(0x40 + ((r1) << 3) + (r2))
#define Z80_NEG				0xED44
#define Z80_NOP				0x00
#define Z80_OR(reg)			_Z80_ALU(ALU_OR, (reg))
#define Z80_OR_n			_Z80_ALU_n(ALU_OR)
#define Z80_OTDR			_Z80_ONLY(0xEDBB)
#define Z80_OTIR			_Z80_ONLY(0xEDB3)
#define Z80_OUTD			_Z80_ONLY(0xEDAB)
#define Z80_OUTI			_Z80_ONLY(0xEDA3)
#define Z80_OUT_C_REG(reg)	_Z80_ONLY((0xED41 + ((reg) << 3)))
#define Z80_OUT_n_A			_Z80_ONLY(0xD3)
#define Z80_POP(reg)		(0xC1 + ((reg) << 4))
#define Z80_PUSH(reg)		(0xC5 + ((reg) << 4))
#define Z80_RES(bit,reg)	_Z80_BRS(BRS_RES, (bit), (reg))
#define Z80_RET				0xC9
#define Z80_RETI			0xED4D
#define Z80_RETN			_Z80_ONLY(0xED45)
#define Z80_RET_FLAG(flag)	(0xC0 + ((flag) << 3))
#define Z80_RL(reg)			_Z80_RS(RS_RL,  (reg))
#define Z80_RLA				0x17
#define Z80_RLC(reg)		_Z80_RS(RS_RLC, (reg))
#define Z80_RLCA			0x07
#define Z80_RLD				0xED6F
#define Z80_RR(reg)			_Z80_RS(RS_RR,  (reg))
#define Z80_RRA				0x1F
#define Z80_RRC(reg)		_Z80_RS(RS_RRC, (reg))
#define Z80_RRCA			0x0F
#define Z80_RRD				0xED67
#define Z80_RST(n)			_RST_ARG(n)
#define Z80_SBC(reg)		_Z80_ALU(ALU_SBC, (reg))
#define Z80_SBC16(reg)		(0xED42 + ((reg) << 4))
#define Z80_SBC_n			_Z80_ALU_n(ALU_SBC)
#define Z80_SCF				0x37
#define Z80_SET(bit,reg)	_Z80_BRS(BRS_SET, (bit), (reg))
#define Z80_SLA(reg)		_Z80_RS(RS_SLA, (reg))
#define Z80_SLL(reg)		_Z80_ONLY(_Z80_RS(RS_SLL, (reg)))
#define Z80_SRA(reg)		_Z80_RS(RS_SRA, (reg))
#define Z80_SRL(reg)		_Z80_RS(RS_SRL, (reg))
#define Z80_SUB(reg)		_Z80_ALU(ALU_SUB, (reg))
#define Z80_SUB_n			_Z80_ALU_n(ALU_SUB)
#define Z80_XOR(reg)		_Z80_ALU(ALU_XOR, (reg))
#define Z80_XOR_n			_Z80_ALU_n(ALU_XOR)

#define Z80_LD_R_A			   _Z80_ONLY(0xED4F)
#define Z80_LD_EIR_A		_RABBIT_ONLY(0xED4F)

#define Z80_LD_A_R			   _Z80_ONLY(0xED5F)
#define Z80_LD_A_EIR		_RABBIT_ONLY(0xED5F)

#define Z80_LD_A_I			   _Z80_ONLY(0xED57)
#define Z80_LD_A_IIR		_RABBIT_ONLY(0xED57)

#define Z80_LD_I_A			   _Z80_ONLY(0xED47)
#define Z80_LD_IIR_A		_RABBIT_ONLY(0xED47)

/* Z180 opcodes */
#define Z80_SLP				_Z180_ONLY(0xED76)
#define Z80_MLT(dd)			_Z180_ONLY(0xED4C + ((dd) << 4))
#define Z80_IN0(r)			_Z180_ONLY(0xED00 + ((r) << 3))
#define Z80_OUT0(r)			_Z180_ONLY(0xED01 + ((r) << 3))
#define Z80_OTIM			_Z180_ONLY(0xED83)
#define Z80_OTIMR			_Z180_ONLY(0xED93)
#define Z80_OTDM			_Z180_ONLY(0xED8B)
#define Z80_OTDMR			_Z180_ONLY(0xED9B)
#define Z80_TSTIO			_Z180_ONLY(0xED74)
#define Z80_TST(r)			_Z180_ONLY(0xED04 + ((r) << 3))
#define Z80_TST_n			_Z180_ONLY(0xED64)
