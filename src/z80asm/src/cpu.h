//-----------------------------------------------------------------------------
// z80asm
// CPU opcodes
// Copyright (C) Paulo Custodio, 2011-2022
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------

#pragma once

// CPU types
#define CPU_Z80     (1 << 0)
#define CPU_Z80N	(1 << 1)
#define CPU_Z180    (1 << 2)
#define CPU_R2KA	(1 << 3)
#define CPU_R3K		(1 << 4)
#define CPU_8080	(1 << 5)
#define CPU_8085	(1 << 6)
#define CPU_GBZ80	(1 << 7)

#define CPU_Z80_NAME		"z80"
#define CPU_Z80N_NAME		"z80n"
#define CPU_Z180_NAME		"z180"
#define CPU_R2KA_NAME		"r2ka"
#define CPU_R3K_NAME		"r3k"
#define CPU_8080_NAME		"8080"
#define CPU_8085_NAME		"8085"
#define CPU_GBZ80_NAME		"gbz80"
#define ARCH_TI83_NAME		"ti83"
#define ARCH_TI83PLUS_NAME	"ti83plus"

#define CPU_ZILOG	(CPU_Z80 | CPU_Z80N | CPU_Z180)
#define CPU_RABBIT	(CPU_R2KA | CPU_R3K)
#define CPU_ALL		(CPU_ZILOG | CPU_RABBIT)
#define CPU_NOT_Z80	(CPU_ALL & ~(CPU_Z80 | CPU_Z80N))

// flags
#define FLAG_NZ		0
#define FLAG_Z		1
#define FLAG_NC		2
#define FLAG_C		3
#define FLAG_PO		4
#define FLAG_PE		5
#define FLAG_P		6
#define FLAG_M		7

#define FLAG_LZ		FLAG_PO
#define FLAG_LO		FLAG_PE

#define FLAG_NV		FLAG_PO
#define FLAG_V		FLAG_PE

#define NOT_FLAG(flag)	((flag) ^ 1)

// 8-bit registers
#define REG_B		0
#define REG_C		1
#define REG_D		2
#define REG_E		3
#define REG_H		4
#define REG_L		5
#define REG_idx		6
#define REG_A		7
#define REG_F		REG_idx

// opcodes
#define Z80_DJNZ			0x10
#define Z80_JR				0x18
#define Z80_JP				0xC3
#define Z80_CALL			0xCD

#define Z80_JR_FLAG(flag)	(0x20 + ((flag) << 3))
#define Z80_JP_FLAG(flag)	(0xC2 + ((flag) << 3))
#define Z80_CALL_FLAG(flag)	(0xC4 + ((flag) << 3))
#define Z80_RST(addr)		(0xC7 + (addr))

#define Z80_DEC(reg)		(0x05 + ((reg) << 3))
#define Z80_INC(reg)		(0x04 + ((reg) << 3))

// Z80Next
#define Z80N_MMU_N(c)		(0xED9150 + (c))
#define Z80N_MMU_A(c)		(0xED9250 + (c))
