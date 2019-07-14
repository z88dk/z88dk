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

/* add opcode followed by 8-bit unsigned expression */
extern void add_opcode_n(int opcode, struct Expr *expr);

/* add opcode followed by 8-bit signed expression */
extern void add_opcode_d(int opcode, struct Expr *expr);

/* add opcode followed by 16-bit expression */
extern void add_opcode_nn(int opcode, struct Expr *expr);

/* add opcode followed by big-endian 16-bit expression */
extern void add_opcode_NN(int opcode, struct Expr *expr);

/* add opcode followed by IX/IY offset expression */
extern void add_opcode_idx(int opcode, struct Expr *expr);

/* add opcode followed by IX/IY offset expression and 8 bit expression */
extern void add_opcode_idx_n(int opcode, struct Expr *idx_expr,
										 struct Expr *n_expr );

/* add opcode followed by two 8-bit expressions */
extern void add_opcode_n_n(int opcode, struct Expr *n1_expr,
									   struct Expr *n2_expr );

/* call emulation function by name */
extern void add_call_emul_func(char *emul_func);

/* add Z88's opcodes */
extern void add_Z88_CALL_OZ(int argument);
extern void add_Z88_CALL_PKG(int argument);
extern void add_Z88_FPP(int argument);
extern void add_Z88_INVOKE(int argument);

/* add COPPER UNIT opcodes (ZX Next) */
extern void add_copper_unit_wait(struct Expr *ver, struct Expr *hor);
extern void add_copper_unit_move(struct Expr *reg, struct Expr *val);
extern void add_copper_unit_stop();
extern void add_copper_unit_nop();

/* assert we are on a Z80 */
#define _Z80_ONLY(x)		(!(opts.cpu & (CPU_Z80|CPU_Z80N)) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _EXCEPT_Z80(x)		((opts.cpu & (CPU_Z80|CPU_Z80N)) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _Z180_ONLY(x)		(!(opts.cpu & CPU_Z180) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _RCM2000_ONLY(x)	(!(opts.cpu & CPU_R2K) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _RCM3000_ONLY(x)	(!(opts.cpu & CPU_R3K) ? \
								(error_illegal_ident(), 0) : \
								(x))

#define _ZILOG_ONLY(x)		(!(opts.cpu & CPU_ZILOG) ? \
								(error_illegal_ident(), 0) : \
								(x))
#define _RABBIT_ONLY(x)		(!(opts.cpu & CPU_RABBIT) ? \
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
enum { FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO_LZ, FLAG_PE_LO, FLAG_P, FLAG_M };

#define FLAG_PO		FLAG_PO_LZ
#define FLAG_PE		FLAG_PE_LO

#define FLAG_LZ		_RABBIT_ONLY(FLAG_PO_LZ)
#define FLAG_LO		_RABBIT_ONLY(FLAG_PE_LO)

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
#define _CHOOSE4_(n, i1, o1, i2, o2, i3, o3, i4, o4)	\
			((n) == (i1) ? (o1) : \
			 _CHOOSE3_((n), (i2), (o2), (i3), (o3), (i4), (o4)))

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
#define Z80_DAA				_ZILOG_ONLY(0x27)
#define Z80_DEC(reg)		(0x05 + ((reg) << 3))
#define Z80_DEC16(reg)		(0x0B + ((reg) << 4))
#define Z80_DI				_ZILOG_ONLY(0xF3)
#define Z80_DJNZ			0x10
#define Z80_EI				_ZILOG_ONLY(0xFB)
#define Z80_EXX				0xD9
#define Z80_EX_AF_AF		0x08
#define Z80_EX_DE_HL		0xEB
#define Z80_EX_IND_SP_HL	((opts.cpu & CPU_RABBIT) ? 0xED54 : 0xE3)
#define Z80_EX_IND_SP_idx	0xE3	/* (IX) or (IY) */
#define Z80_HALT			_ZILOG_ONLY(0x76)
#define Z80_IM(n)			_ZILOG_ONLY(_CHOOSE3_((n), 0, 0xED46, 1, 0xED56, 2, 0xED5E))
#define Z80_INC(reg)		(0x04 + ((reg) << 3))
#define Z80_INC16(reg)		(0x03 + ((reg) << 4))
#define Z80_IND				_ZILOG_ONLY(0xEDAA)
#define Z80_INDR			_ZILOG_ONLY(0xEDBA)
#define Z80_INI				_ZILOG_ONLY(0xEDA2)
#define Z80_INIR			_ZILOG_ONLY(0xEDB2)
#define Z80_IN_A_n			_ZILOG_ONLY(0xDB)
#define Z80_IN_REG_C(reg)	_ZILOG_ONLY((0xED40 + ((reg) << 3)))
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
#define Z80_OTDR			_ZILOG_ONLY(0xEDBB)
#define Z80_OTIR			_ZILOG_ONLY(0xEDB3)
#define Z80_OUTD			_ZILOG_ONLY(0xEDAB)
#define Z80_OUTI			_ZILOG_ONLY(0xEDA3)
#define Z80_OUT_C_REG(reg)	_ZILOG_ONLY((0xED41 + ((reg) << 3)))
#define Z80_OUT_n_A			_ZILOG_ONLY(0xD3)
#define Z80_POP(reg)		(0xC1 + ((reg) << 4))
#define Z80_PUSH(reg)		(0xC5 + ((reg) << 4))
#define Z80_RES(bit,reg)	_Z80_BRS(BRS_RES, (bit), (reg))
#define Z80_RET				0xC9
#define Z80_RETI			0xED4D
#define Z80_RETN			_ZILOG_ONLY(0xED45)
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
#define Z80_SLL(reg)		_ZILOG_ONLY(_Z80_RS(RS_SLL, (reg)))
#define Z80_SRA(reg)		_Z80_RS(RS_SRA, (reg))
#define Z80_SRL(reg)		_Z80_RS(RS_SRL, (reg))
#define Z80_SUB(reg)		_Z80_ALU(ALU_SUB, (reg))
#define Z80_SUB_n			_Z80_ALU_n(ALU_SUB)
#define Z80_XOR(reg)		_Z80_ALU(ALU_XOR, (reg))
#define Z80_XOR_n			_Z80_ALU_n(ALU_XOR)

#define Z80_LD_I_A			 _ZILOG_ONLY(0xED47)
#define Z80_LD_A_I			 _ZILOG_ONLY(0xED57)

#define Z80_LD_R_A			 _ZILOG_ONLY(0xED4F)
#define Z80_LD_A_R			 _ZILOG_ONLY(0xED5F)

#define Z80_LD_EIR_A		_RABBIT_ONLY(0xED47)
#define Z80_LD_A_EIR		_RABBIT_ONLY(0xED57)

#define Z80_LD_IIR_A		_RABBIT_ONLY(0xED4F)
#define Z80_LD_A_IIR		_RABBIT_ONLY(0xED5F)

/* Z180 opcodes */
#define Z80_SLP				_Z180_ONLY(0xED76)
#define Z80_MLT(dd)			((opts.cpu & CPU_Z80) ? \
								(error_illegal_ident(), 0) : \
								(opts.cpu & CPU_RABBIT) && (dd) == REG_SP ? \
									(error_illegal_ident(), 0) : \
									0xED4C + ((dd) << 4))
#define Z80_IN0(r)			_Z180_ONLY(0xED00 + ((r) << 3))
#define Z80_OUT0(r)			_Z180_ONLY(0xED01 + ((r) << 3))
#define Z80_OTIM			_Z180_ONLY(0xED83)
#define Z80_OTIMR			_Z180_ONLY(0xED93)
#define Z80_OTDM			_Z180_ONLY(0xED8B)
#define Z80_OTDMR			_Z180_ONLY(0xED9B)
#define Z80_TSTIO			_Z180_ONLY(0xED74)
#define Z80_TST(r)			_EXCEPT_Z80(0xED04 + ((r) << 3))
#define Z80_TST_n			_EXCEPT_Z80(0xED64)

/* Rabbit opcodes */
#define Z80_IOI				_RABBIT_ONLY(0xD3)
#define Z80_IOE				_RABBIT_ONLY(0xDB)
#define Z80_ALTD			_RABBIT_ONLY(0x76)
#define Z80_IPRES			_RABBIT_ONLY(0xED5D)
#define Z80_IPSET(n)		_RABBIT_ONLY(_CHOOSE4_((n), 0, 0xED46, 1, 0xED56, 2, 0xED4E, 3, 0xED5E))
#define Z80_BOOL			_RABBIT_ONLY(0xCC)
#define Z80_ADD_SP_d		_RABBIT_ONLY(0x27)
#define Z80_AND_HL_DE		_RABBIT_ONLY(0xDC)
#define Z80_OR_HL_DE		_RABBIT_ONLY(0xEC)
#define Z80_BOOL			_RABBIT_ONLY(0xCC)
#define Z80_EX_DE1_HL		_RABBIT_ONLY(0xE3)
#define Z80_EX_DE_HL1		_RABBIT_ONLY(0x76EB)
#define Z80_EX_DE1_HL1		_RABBIT_ONLY(0x76E3)
#define Z80_MUL				_RABBIT_ONLY(0xF7)
#define Z80_IDET			_RCM3000_ONLY(0x5B)
#define Z80_RDMODE			_RCM3000_ONLY(0xED7F)
#define Z80_SETUSR			_RCM3000_ONLY(0xED6F)
#define Z80_SURES			_RCM3000_ONLY(0xED7D)
#define Z80_SYSCALL			_RCM3000_ONLY(0xED75)
#define Z80_UMA				_RCM3000_ONLY(0xEDC0)
#define Z80_UMS				_RCM3000_ONLY(0xEDC8)

#define Z80_LD_IND_HL_d_HL	_RABBIT_ONLY(0xDDF4)
#define Z80_LD_IND_IX_d_HL	_RABBIT_ONLY(  0xF4)
#define Z80_LD_IND_IY_d_HL	_RABBIT_ONLY(0xFDF4)

#define Z80_LD_HL_IND_HL_d	_RABBIT_ONLY(0xDDE4)
#define Z80_LD_HL_IND_IX_d	_RABBIT_ONLY(  0xE4)
#define Z80_LD_HL_IND_IY_d	_RABBIT_ONLY(0xFDE4)

#define Z80_LD_IND_SP_n_HL	_RABBIT_ONLY(0xD4)
#define Z80_LD_HL_IND_SP_n	_RABBIT_ONLY(0xC4)

#define Z80_LD_A_XPC		_RABBIT_ONLY(0xED77)
#define Z80_LD_XPC_A		_RABBIT_ONLY(0xED67)
#define Z80_LD_dd1_BC(dd)	_RABBIT_ONLY(0xED49 + ((dd) << 4))
#define Z80_LD_dd1_DE(dd)	_RABBIT_ONLY(0xED41 + ((dd) << 4))

#define Z80_LD_HL_IX		_RABBIT_ONLY(0xDD7C)
#define Z80_LD_HL_IY		_RABBIT_ONLY(0xFD7C)

#define Z80_LD_IX_HL		_RABBIT_ONLY(0xDD7D)
#define Z80_LD_IY_HL		_RABBIT_ONLY(0xFD7D)

#define Z80_LDISR			_RCM3000_ONLY(0xED90)
#define Z80_LDDSR			_RCM3000_ONLY(0xED98)
#define Z80_LSDR			_RCM3000_ONLY(0xEDF8)
#define Z80_LSIR			_RCM3000_ONLY(0xEDF0)
#define Z80_LSDDR			_RCM3000_ONLY(0xEDD8)
#define Z80_LSIDR			_RCM3000_ONLY(0xEDD0)

#define Z80_LDP_IND_HL_HL	_RABBIT_ONLY(0xED64)
#define Z80_LDP_IND_IX_HL	_RABBIT_ONLY(0xDD64)
#define Z80_LDP_IND_IY_HL	_RABBIT_ONLY(0xFD64)

#define Z80_LDP_HL_IND_HL	_RABBIT_ONLY(0xED6C)
#define Z80_LDP_HL_IND_IX	_RABBIT_ONLY(0xDD6C)
#define Z80_LDP_HL_IND_IY	_RABBIT_ONLY(0xFD6C)

#define Z80_LDP_IND_mn_HL	_RABBIT_ONLY(0xED65)
#define Z80_LDP_IND_mn_IX	_RABBIT_ONLY(0xDD65)
#define Z80_LDP_IND_mn_IY	_RABBIT_ONLY(0xFD65)

#define Z80_LDP_HL_IND_mn	_RABBIT_ONLY(0xED6D)
#define Z80_LDP_IX_IND_mn	_RABBIT_ONLY(0xDD6D)
#define Z80_LDP_IY_IND_mn	_RABBIT_ONLY(0xFD6D)

#define Z80_POP_IP			_RABBIT_ONLY(0xED7E)
#define Z80_POP_SU			_RCM3000_ONLY(0xED6E)
#define Z80_PUSH_IP			_RABBIT_ONLY(0xED76)
#define Z80_PUSH_SU			_RCM3000_ONLY(0xED66)

#define Z80_RL_DE			_RABBIT_ONLY(0xF3)
#define Z80_RR_DE			_RABBIT_ONLY(0xFB)
#define Z80_RR_HL			_RABBIT_ONLY(0xFC)
#define Z80_RR_IX			_RABBIT_ONLY(0xDDFC)
#define Z80_RR_IY			_RABBIT_ONLY(0xFDFC)
