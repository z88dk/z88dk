//-----------------------------------------------------------------------------
// z80asm
// Copyright (C) Paulo Custodio, 2011-2023
// License: The Artistic License 2.0, http://www.perlfoundation.org/artistic_license_2_0
//-----------------------------------------------------------------------------
#pragma once

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

//-----------------------------------------------------------------------------
// CPUs
//-----------------------------------------------------------------------------
typedef enum {
    CPU_Z80         = 1,
    CPU_Z80_STRICT  = 2,
    CPU_Z180        = 3,
    CPU_EZ80_Z80    = 4,
    CPU_EZ80        = 5,
    CPU_Z80N        = 6,
    CPU_R2KA        = 7,
    CPU_R3K         = 8,
    CPU_GBZ80       = 9,
    CPU_8080        = 10,
    CPU_8085        = 11,
    CPU_R800        = 12,
    CPU_R4K         = 13,
    CPU_R5K         = 14,
    CPU_KC160       = 15,
    CPU_KC160_Z80   = 16,

    CPU_UNDEF       = -1,
} cpu_t;

#define ARCH_TI83_NAME		"ti83"
#define ARCH_TI83PLUS_NAME	"ti83plus"

// convert cpu_t to string, NULL if not found
extern const char* cpu_name(cpu_t id);

// lookup cpu name, return cpu_t, CPU_UNDEF if not found
extern cpu_t cpu_id(const char* name);

// static comma-separated list of cpu names
extern const char* cpu_list();

// return list terminated by CPU_UNDEF of all CPUs in the order more specific to more generic
extern const int* cpu_ids();

// check if a code cpu is compatible with a library cpu
extern bool cpu_compatible(cpu_t code_cpu_id, cpu_t lib_cpu_id);


// IXIY
typedef enum {
    IXIY_NO_SWAP,           // no swap
    IXIY_SWAP,              // swap IX and IY
    IXIY_SOFT_SWAP,         // swap IX and IY, but save object file with no swap
} swap_ixiy_t;

extern bool ixiy_compatible(swap_ixiy_t code_swap_ixiy, swap_ixiy_t lib_swap_ixiy);

//-----------------------------------------------------------------------------
// Opcodes
//-----------------------------------------------------------------------------

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


//-----------------------------------------------------------------------------
// Scope of symbol
// Initially defined as LOCAL
//-----------------------------------------------------------------------------

typedef enum {
    SCOPE_NONE      = 0,    // 
    SCOPE_LOCAL     = 1,    // "L"
    SCOPE_PUBLIC    = 2,    // "G"            - defined and exported
    SCOPE_EXTERN    = 3,    //                - not defined and imported
    SCOPE_GLOBAL    = 4,    // "G" if defined - PUBLIC if defined, EXTERN if not defined
} sym_scope_t;

// convert sym_scope_t to text, return NULL if not found
extern const char* sym_scope_str_short(sym_scope_t type);
extern const char* sym_scope_str_long(sym_scope_t type);

// convert object file old-style letter code to sym_scope_t
extern sym_scope_t sym_scope_ofile_code(int code);

//-----------------------------------------------------------------------------
// Type of symbol
// Expressions have the type of the greatest symbol used
//-----------------------------------------------------------------------------

typedef enum {
    TYPE_UNDEFINED  = 0,    //     - symbol not defined
    TYPE_CONSTANT   = 1,    // "C" - can be computed
    TYPE_ADDRESS    = 2,	// "A" - depends on ASMPC, can be computed after address allocation
    TYPE_COMPUTED   = 3,	// "=" - depends on the result of an expression
} sym_type_t;

// convert sym_type_t to text, return NULL if not found
extern const char* sym_type_str_long(sym_type_t type);
extern const char* sym_type_str_short(sym_type_t type);

// convert object file old-style letter code to sym_type_t
extern sym_type_t sym_type_ofile_code(int code);

//-----------------------------------------------------------------------------
// Expression range
//-----------------------------------------------------------------------------

typedef enum {
    RANGE_UNDEFINED             = 0,    // 
    RANGE_JR_OFFSET             = 1,    // "J"
    RANGE_BYTE_UNSIGNED         = 2,    // "U"
    RANGE_BYTE_SIGNED           = 3,    // "S"
    RANGE_WORD                  = 4,    // "W"  // 16-bit value little-endian
    RANGE_WORD_BE               = 5,    // "B"  // 16-bit value big-endian
    RANGE_DWORD                 = 6,    // "L"  // 32-bit signed
    RANGE_BYTE_TO_WORD_UNSIGNED = 7,    // "u"  // unsigned byte extended to 16 bits
    RANGE_BYTE_TO_WORD_SIGNED   = 8,    // "s"  // signed byte sign-extended to 16 bits
    RANGE_PTR24                 = 9,    // "P"  // 24-bit pointer
    RANGE_HIGH_OFFSET           = 10,   // "H"  // byte offset to 0xFF00
    RANGE_ASSIGNMENT            = 11,   // "="  // DEFC expression assigning a symbol
    RANGE_JRE_OFFSET            = 12,   // "j"  // 16-bit relative offset for JRE
} range_t;

// size of each range in object file
extern int range_size(range_t type);

// convert sym_type_t to text, return NULL if not found
extern const char* range_str_short(range_t type);

// convert object file old-style letter code to sym_type_t
extern range_t range_ofile_code(int code);

#ifdef __cplusplus
}
#endif
