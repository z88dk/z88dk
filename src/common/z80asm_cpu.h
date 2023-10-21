//-----------------------------------------------------------------------------
// z80asm cpu's
// Copyright (C) Paulo Custodio, 2011-2023
// License: http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include "stdbool.h"

// flags
#define FLAG_NZ     0
#define FLAG_Z      1
#define FLAG_NC     2
#define FLAG_C      3
#define FLAG_PO     4
#define FLAG_PE     5
#define FLAG_P      6
#define FLAG_M      7

#define FLAG_LZ     FLAG_PO
#define FLAG_LO     FLAG_PE

#define FLAG_NV     FLAG_PO
#define FLAG_V      FLAG_PE

#define FLAG_R4K_GT     0x10
#define FLAG_R4K_GTU    0x11
#define FLAG_R4K_LT     0x12
#define FLAG_R4K_V      0x13

#define NOT_FLAG(flag)    ((flag) ^ 1)

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
#define Z80_DJNZ    0x10
#define Z80_JR      0x18
#define Z80_JP      0xC3
#define Z80_CALL    0xCD
#define R4K_DWJNZ   0xED10

#define R4K_JR_FLAG(flag)   (0xA0 + (((flag) & 0x03) << 3))
#define R4K_JP_FLAG(flag)   (0xA2 + (((flag) & 0x03) << 3))

#define Z80_JR_FLAG(flag)   (0x20 + ((flag) << 3))
#define Z80_JP_FLAG(flag)   (0xC2 + ((flag) << 3))
#define Z80_CALL_FLAG(flag) (0xC4 + ((flag) << 3))
#define Z80_RST(addr)       (0xC7 + (addr))

#define Z80_DEC(reg)        (0x05 + ((reg) << 3))
#define Z80_INC(reg)        (0x04 + ((reg) << 3))

#define RABBIT_ALTD         0x76

// Z80Next
#define Z80N_MMU_N(c)       (0xED9150 + (c))
#define Z80N_MMU_A(c)       (0xED9250 + (c))

// CPUs
enum {
#define X(id, value, name)      id = value,
#include "z80asm_cpu.def"
};

#define ARCH_TI83_NAME		"ti83"
#define ARCH_TI83PLUS_NAME	"ti83plus"

const char* cpu_name(int cpu_id);   // NULL if invalid
int cpu_id(const char* name);       // -1 if not found
const char* cpu_list();             // static comma-separated list of names
const int* cpu_ids();               // static list terminated by -1 of all CPUs in the order more
                                    // specific to more generic

bool cpu_compatible(int code_cpu_id, int lib_cpu_id);

// IXIY
typedef enum {
    IXIY_NO_SWAP,           // no swap
    IXIY_SWAP,              // swap IX and IY
    IXIY_SOFT_SWAP,         // swap IX and IY, but save object file with no swap
} swap_ixiy_t;

bool ixiy_compatible(swap_ixiy_t code_swap_ixiy, swap_ixiy_t lib_swap_ixiy);


#ifdef __cplusplus
}
#endif
