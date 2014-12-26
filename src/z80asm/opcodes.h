/*
     ZZZZZZZZZZZZZZZZZZZZ    8888888888888       00000000000
   ZZZZZZZZZZZZZZZZZZZZ    88888888888888888    0000000000000
                ZZZZZ      888           888  0000         0000
              ZZZZZ        88888888888888888  0000         0000
            ZZZZZ            8888888888888    0000         0000       AAAAAA         SSSSSSSSSSS   MMMM       MMMM
          ZZZZZ            88888888888888888  0000         0000      AAAAAAAA      SSSS            MMMMMM   MMMMMM
        ZZZZZ              8888         8888  0000         0000     AAAA  AAAA     SSSSSSSSSSS     MMMMMMMMMMMMMMM
      ZZZZZ                8888         8888  0000         0000    AAAAAAAAAAAA      SSSSSSSSSSS   MMMM MMMMM MMMM
    ZZZZZZZZZZZZZZZZZZZZZ  88888888888888888    0000000000000     AAAA      AAAA           SSSSS   MMMM       MMMM
  ZZZZZZZZZZZZZZZZZZZZZ      8888888888888       00000000000     AAAA        AAAA  SSSSSSSSSSS     MMMM       MMMM

Copyright (C) Paulo Custodio, 2011-2014

Define CPU opcodes

$Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/opcodes.h,v 1.12 2014-12-26 18:33:20 pauloscustodio Exp $ 
*/

#pragma once

#include "xmalloc.h"   /* before any other include */

#include "errors.h"
#include "options.h"

/* forward declaration without include cycle */
struct Expr;

/* constants */
enum { IDX_REG_HL = 0, IDX_REG_IX = 0xDD, IDX_REG_IY = 0xFD };
enum { FLAG_NONE = -1, FLAG_NZ, FLAG_Z, FLAG_NC, FLAG_C, FLAG_PO, FLAG_PE, FLAG_P, FLAG_M };
enum { REG_NONE = -1, REG_BC, REG_DE, REG_HL, REG_SP, REG_AF, 
					  REG_IX, REG_IY };

/* add 1 or 2 bytes opcode opcode to object code 
*  bytes in big-endian format, e.g. 0xED46 */
extern void add_opcode(int opcode);

/* add opcode followed by jump relative offset expression */
extern void add_opcode_jr(int opcode, struct Expr *expr);

/* add opcode followed by 16-bit expression */
extern void add_opcode_nn(int opcode, struct Expr *expr);

/* choose value, error if none */
#define _CHOOSE2_(n, i1, o1, i2, o2)	\
			((n) == (i1) ? (o1) : \
			 (n) == (i2) ? (o2) : \
			 (error_int_range(n), 0))		/* ,0 to transform (void) into (int) */
#define _CHOOSE3_(n, i1, o1, i2, o2, i3, o3)	\
			((n) == (i1) ? (o1) : \
			 _CHOOSE2_((n), (i2), (o2), (i3), (o3)))

#define _IX_		(opts.swap_ix_iy ? IDX_REG_IY : IDX_REG_IX)
#define _IY_		(opts.swap_ix_iy ? IDX_REG_IX : IDX_REG_IY)
#define _IX_IY_OPCODE(reg) \
			(((reg) == REG_IX ? _IX_ : (reg) == REG_IY ? _IY_ : 0) << 8)
#define _IX_IY_REG(reg) \
			(((reg) == REG_IX || (reg) == REG_IY ? REG_HL : (reg))

/* register values to add to opcodes */

#define _PUSH_POP_REG(reg) \
			(((reg) >= REG_BC && (reg) <= REG_HL ? \
				(reg) - REG_BC : \
				(reg) == REG_IX || (reg) == REG_IY ? \
					2 : \
					(reg) == REG_AF ? \
						3 : \
						(error_syntax(), 0)) \
			<< 4)
#define _PUSH_POP_OPCODE(opcode, reg) \
			(_IX_IY_OPCODE(reg) + (opcode) + _PUSH_POP_REG(reg))

#define _FLAG_OPCODE(flag, max_flag, opcode_none, opcode_flag) \
			((flag) >= FLAG_NZ && (flag) <= (max_flag) ? \
				(opcode_flag) + (((flag) - FLAG_NZ) << 3) : \
				(opcode_none))
#define _FLAG4_OPCODE(flag, opcode_none, opcode_flag) \
			_FLAG_OPCODE((flag), FLAG_C, (opcode_none), (opcode_flag)) 
#define _FLAG8_OPCODE(flag, opcode_none, opcode_flag) \
			_FLAG_OPCODE((flag), FLAG_M, (opcode_none), (opcode_flag)) 

/* Z80 opcodes 
*  n is a constant
*  ix is 0 for HL, 0xDD for IX, 0xFD for IH 
*  flag is FLAG_NONE, FLAG_NZ, FLAG_... 
*  reg is REG_NONE, REG_BC, ... */
#define Z80_CALL(flag)		_FLAG8_OPCODE((flag), 0xCD, 0xC4)
#define Z80_CCF				0x3F
#define Z80_CPD				0xEDA9
#define Z80_CPDR			0xEDB9
#define Z80_CPI				0xEDA1
#define Z80_CPIR			0xEDB1
#define Z80_CPL				0x2F
#define Z80_DAA				0x27
#define Z80_DI				0xF3
#define Z80_DJNZ			0x10
#define Z80_EI				0xFB
#define Z80_EXX				0xD9
#define Z80_EX_AF_AF		0x08
#define Z80_EX_DE_HL		0xEB
#define Z80_EX_IND_SP_HL	((opts.cpu & CPU_RABBIT) ? 0xED54 : 0xE3)
#define Z80_EX_IND_SP_IX	((_IX_ << 8) | 0xE3)
#define Z80_EX_IND_SP_IY	((_IY_ << 8) | 0xE3)
#define Z80_HALT			0x76
#define Z80_IM(n)			_CHOOSE3_((n), 0, 0xED46, 1, 0xED56, 2, 0xED5E)
#define Z80_IND				0xEDAA
#define Z80_INDR			0xEDBA
#define Z80_INI				0xEDA2
#define Z80_INIR			0xEDB2
#define Z80_JP_IND_HL		0xE9
#define Z80_JP_IND_IX		((_IX_ << 8) | 0xE9)
#define Z80_JP_IND_IY		((_IY_ << 8) | 0xE9)
#define Z80_JP(flag)		_FLAG8_OPCODE((flag), 0xC3, 0xC2)
#define Z80_JP_NOT(flag)	Z80_JP((flag) ^ 1)
#define Z80_JR(flag)		_FLAG4_OPCODE((flag), 0x18, 0x20)
#define Z80_JR_NOT(flag)	Z80_JR((flag) ^ 1)
#define Z80_LDD				0xEDA8
#define Z80_LDDR			0xEDB8
#define Z80_LDI				0xEDA0
#define Z80_LDIR 			0xEDB0
#define Z80_NEG				0xED44
#define Z80_NOP				0x00
#define Z80_OTDR			0xEDBB
#define Z80_OTIR			0xEDB3
#define Z80_OUTD			0xEDAB
#define Z80_OUTI			0xEDA3
#define Z80_POP(reg)		_PUSH_POP_OPCODE(0xC1, (reg))
#define Z80_PUSH(reg)		_PUSH_POP_OPCODE(0xC5, (reg))
#define Z80_RET(flag)		_FLAG8_OPCODE((flag), 0xC9, 0xC0)
#define Z80_RETI			0xED4D
#define Z80_RETN			0xED45
#define Z80_RLD				0xED6F
#define Z80_RRD				0xED67
#define Z80_RST(n)			((n) < 0 || (n) > 0x38 || (((n) & 7) != 0) ? \
								(error_int_range(n),0) : \
								((opts.cpu & CPU_RABBIT) && \
									((n) == 0 || (n) == 8 || (n) == 0x30) ? \
										(error_illegal_ident(),0) : \
										0xC7 + (n)))
#define Z80_SCF				0x37
