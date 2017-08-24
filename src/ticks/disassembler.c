#include <stdio.h>
#include "ticks.h"

static uint8_t get_memory(int pc);

typedef enum {
   OP_NONE,
   OP_A,
   OP_B,
   OP_C,
   OP_D,
   OP_E,
   OP_H,
   OP_L,
   OP_AF,
   OP_HL,
   OP_DE,
   OP_BC,
   OP_SP,
   OP_INDHL,
   OP_INDDE,
   OP_INDBC,
   OP_INDSP,
   OP_REL8,
   OP_IND8,
   OP_IND16,
   OP_IMMED8,
   OP_IMMED16,
   OP_Z,
   OP_NZ,
   OP_Ca,
   OP_NC,
   OP_P,
   OP_PO,
   OP_PE,
   OP_M,
   OP_RST,
   OP_BIT,
   OP_PORTC,
   OP_F,
   OP_I,
   OP_R,
   OP_IM,

} operand;

#define F_IXY   1   /* ix */
#define F_INDXY 2   /* (ix+dd) */
#define F_Z80  4
#define F_Z180 32
#define F_ZXN  64
#define F_R2K  128
#define F_R3K  256
#define F_ALT  512
#define F_IO   1024

typedef struct {
    const char   *opcode;
    operand       op1;
    operand       op2;
    int           flags;
} instruction;


instruction main_page[] = {
    { "nop",	OP_NONE,  OP_NONE,    0 },
    { "ld",     OP_BC,    OP_IMMED16, 0 },
    { "ld",     OP_INDBC, OP_A,       0 },
    { "inc",    OP_BC,    OP_NONE,    0 }, 
    { "inc",    OP_B,     OP_NONE,    0 }, 
    { "dec",    OP_B,     OP_NONE,    0 }, 
    { "ld",     OP_B,     OP_IMMED8,  0 }, 
    { "rlca",   OP_NONE,  OP_NONE,    0 },
    { "ex",     OP_AF,    OP_AF,      0 },
    { "add",    OP_HL,    OP_BC,      F_IXY },
    { "ld",     OP_A,     OP_INDBC,   0 },
    { "dec",    OP_BC,    OP_NONE,    0 }, 
    { "inc",    OP_C,     OP_NONE,    0 }, 
    { "dec",    OP_C,     OP_NONE,    0 }, 
    { "ld",     OP_C,     OP_IMMED8,  0 }, 
    { "rrca",   OP_NONE,  OP_NONE,    0 },


    { "djnz",   OP_REL8,  OP_NONE,    0 },  /* 10 */
    { "ld",     OP_DE,    OP_IMMED16, 0 },
    { "ld",     OP_INDDE, OP_A,       0 },
    { "inc",    OP_DE,    OP_NONE,    0 }, 
    { "inc",    OP_D,     OP_NONE,    0 }, 
    { "dec",    OP_D,     OP_NONE,    0 }, 
    { "ld",     OP_D,     OP_IMMED8,  0 }, 
    { "rla",    OP_NONE,  OP_NONE,    0 },
    { "jr",     OP_REL8,  OP_NONE,    0 },
    { "add",    OP_HL,    OP_DE,      F_IXY },
    { "ld",     OP_A,     OP_INDDE,   0 },
    { "dec",    OP_DE,    OP_NONE,    0 }, 
    { "inc",    OP_E,     OP_NONE,    0 }, 
    { "dec",    OP_E,     OP_NONE,    0 }, 
    { "ld",     OP_E,     OP_IMMED8,  0 }, 
    { "rra",    OP_NONE,  OP_NONE,    0 },

    { "jr",     OP_NZ,    OP_REL8,    0 },  /* 20 */
    { "ld",     OP_HL,    OP_IMMED16, F_IXY },
    { "ld",     OP_IND16, OP_HL,      F_IXY },
    { "inc",    OP_HL,    OP_NONE,    F_IXY }, 
    { "inc",    OP_H,     OP_NONE,    F_IXY }, 
    { "dec",    OP_H,     OP_NONE,    F_IXY }, 
    { "ld",     OP_H,     OP_IMMED8,  F_INDXY }, 
    { "daa",    OP_NONE,  OP_NONE,    0 },
    { "jr",     OP_Z,     OP_REL8,    0 },
    { "add",    OP_HL,    OP_HL,      F_IXY },
    { "ld",     OP_HL,    OP_IND16,   F_IXY },
    { "dec",    OP_HL,    OP_NONE,    F_IXY }, 
    { "inc",    OP_L,     OP_NONE,    F_IXY }, 
    { "dec",    OP_L,     OP_NONE,    F_IXY }, 
    { "ld",     OP_L,     OP_IMMED8,  F_INDXY }, 
    { "cpl",    OP_NONE,  OP_NONE,    0 },

    { "jr",     OP_NC,    OP_REL8,    0 }, /* 30 */
    { "ld",     OP_SP,    OP_IMMED16, 0 },
    { "ld",     OP_IND16, OP_A,       0 },
    { "inc",    OP_SP,    OP_NONE,    0 },
    { "inc",    OP_INDHL, OP_NONE,    0 },
    { "dec",    OP_INDHL, OP_NONE,    0 },
    { "ld",     OP_INDHL, OP_IMMED8,  0 },
    { "scf",    OP_NONE,  OP_NONE,    0 },
    { "jr",     OP_Ca,    OP_REL8,    0 },
    { "add",    OP_HL,    OP_SP,      F_IXY },
    { "ld",     OP_A,     OP_IND16,   0 },
    { "dec",    OP_SP,    OP_NONE,    0 },
    { "inc",    OP_A,     OP_NONE,    0 },
    { "dec",    OP_A,     OP_NONE,    0 },
    { "ld",     OP_A,     OP_IMMED8,  0 },
    { "ccf",    OP_NONE,  OP_NONE,    0 },

    { "ld",     OP_B,     OP_B,       0 }, /* 40 */
    { "ld",     OP_B,     OP_C,       0 },
    { "ld",     OP_B,     OP_D,       0 },
    { "ld",     OP_B,     OP_E,       0 },
    { "ld",     OP_B,     OP_H,       F_IXY },
    { "ld",     OP_B,     OP_L,       F_IXY },
    { "ld",     OP_B,     OP_INDHL,   F_INDXY },
    { "ld",     OP_B,     OP_A,       0 },
    { "ld",     OP_C,     OP_B,       0 },
    { "ld",     OP_C,     OP_C,       0 },
    { "ld",     OP_C,     OP_D,       0 },
    { "ld",     OP_C,     OP_E,       0 },
    { "ld",     OP_C,     OP_H,       F_IXY },
    { "ld",     OP_C,     OP_L,       F_IXY },
    { "ld",     OP_C,     OP_INDHL,   F_INDXY },
    { "ld",     OP_C,     OP_A,       0 },

    { "ld",     OP_D,     OP_B,       0 }, /* 50 */
    { "ld",     OP_D,     OP_C,       0 },
    { "ld",     OP_D,     OP_D,       0 },
    { "ld",     OP_D,     OP_E,       0 },
    { "ld",     OP_D,     OP_H,       F_IXY },
    { "ld",     OP_D,     OP_L,       F_IXY },
    { "ld",     OP_D,     OP_INDHL,   F_INDXY },
    { "ld",     OP_D,     OP_A,       0 },
    { "ld",     OP_E,     OP_B,       0 },
    { "ld",     OP_E,     OP_C,       0 },
    { "ld",     OP_E,     OP_D,       0 },
    { "ld",     OP_E,     OP_E,       0 },
    { "ld",     OP_E,     OP_H,       F_IXY },
    { "ld",     OP_E,     OP_L,       F_IXY },
    { "ld",     OP_E,     OP_INDHL,   F_INDXY },
    { "ld",     OP_E,     OP_A,       0 },

    { "ld",     OP_H,     OP_B,       F_IXY }, /* 60 */
    { "ld",     OP_H,     OP_C,       F_IXY },
    { "ld",     OP_H,     OP_D,       F_IXY },
    { "ld",     OP_H,     OP_E,       F_IXY },
    { "ld",     OP_H,     OP_H,       F_IXY },
    { "ld",     OP_H,     OP_L,       F_IXY },
    { "ld",     OP_H,     OP_INDHL,   F_INDXY },
    { "ld",     OP_H,     OP_A,       F_IXY },
    { "ld",     OP_L,     OP_B,       F_IXY },
    { "ld",     OP_L,     OP_C,       F_IXY },
    { "ld",     OP_L,     OP_D,       F_IXY },
    { "ld",     OP_L,     OP_E,       F_IXY },
    { "ld",     OP_L,     OP_H,       F_IXY },
    { "ld",     OP_L,     OP_L,       F_IXY },
    { "ld",     OP_L,     OP_INDHL,   F_INDXY },
    { "ld",     OP_L,     OP_A,       F_IXY },

    { "ld",     OP_INDHL, OP_B,       F_INDXY }, /* 70 */
    { "ld",     OP_INDHL, OP_C,       F_INDXY },
    { "ld",     OP_INDHL, OP_D,       F_INDXY },
    { "ld",     OP_INDHL, OP_E,       F_INDXY },
    { "ld",     OP_INDHL, OP_H,       F_INDXY },
    { "ld",     OP_INDHL, OP_L,       F_INDXY },
    { "halt",   OP_NONE,  OP_NONE,    0 },
    { "ld",     OP_INDHL, OP_A,       F_INDXY },
    { "ld",     OP_A,     OP_B,       0 },
    { "ld",     OP_A,     OP_C,       0 },
    { "ld",     OP_A,     OP_D,       0 },
    { "ld",     OP_A,     OP_E,       0 },
    { "ld",     OP_A,     OP_H,       F_IXY },
    { "ld",     OP_A,     OP_L,       F_IXY },
    { "ld",     OP_A,     OP_INDHL,   F_INDXY },
    { "ld",     OP_A,     OP_A,       0 },

    { "add",    OP_A,     OP_B,       0 },
    { "add",    OP_A,     OP_C,       0 },
    { "add",    OP_A,     OP_D,       0 },
    { "add",    OP_A,     OP_E,       0 },
    { "add",    OP_A,     OP_H,       F_IXY },
    { "add",    OP_A,     OP_L,       F_IXY },
    { "add",    OP_A,     OP_INDHL,   F_INDXY },
    { "add",    OP_A,     OP_A,       0 },
    { "adc",    OP_A,     OP_B,       0 },
    { "adc",    OP_A,     OP_C,       0 },
    { "adc",    OP_A,     OP_D,       0 },
    { "adc",    OP_A,     OP_E,       0 },
    { "adc",    OP_A,     OP_H,       F_IXY },
    { "adc",    OP_A,     OP_L,       F_IXY },
    { "adc",    OP_A,     OP_INDHL,   F_INDXY },
    { "adc",    OP_A,     OP_A,       0 },

    { "sub",    OP_A,     OP_B,       0 },
    { "sub",    OP_A,     OP_C,       0 },
    { "sub",    OP_A,     OP_D,       0 },
    { "sub",    OP_A,     OP_E,       0 },
    { "sub",    OP_A,     OP_H,       F_IXY },
    { "sub",    OP_A,     OP_L,       F_IXY },
    { "sub",    OP_A,     OP_INDHL,   F_INDXY },
    { "sub",    OP_A,     OP_A,       0 },
    { "sbc",    OP_A,     OP_B,       0 },
    { "sbc",    OP_A,     OP_C,       0 },
    { "sbc",    OP_A,     OP_D,       0 },
    { "sbc",    OP_A,     OP_E,       0 },
    { "sbc",    OP_A,     OP_H,       F_IXY },
    { "sbc",    OP_A,     OP_L,       F_IXY },
    { "sbc",    OP_A,     OP_INDHL,   F_INDXY },
    { "sbc",    OP_A,     OP_A,       0 },

    { "and",    OP_A,     OP_B,       0 },
    { "and",    OP_A,     OP_C,       0 },
    { "and",    OP_A,     OP_D,       0 },
    { "and",    OP_A,     OP_E,       0 },
    { "and",    OP_A,     OP_H,       F_IXY },
    { "and",    OP_A,     OP_L,       F_IXY },
    { "and",    OP_A,     OP_INDHL,   F_INDXY },
    { "and",    OP_A,     OP_A,       0 },
    { "xor",    OP_A,     OP_B,       0 },
    { "xor",    OP_A,     OP_C,       0 },
    { "xor",    OP_A,     OP_D,       0 },
    { "xor",    OP_A,     OP_E,       0 },
    { "xor",    OP_A,     OP_H,       F_IXY },
    { "xor",    OP_A,     OP_L,       F_IXY },
    { "xor",    OP_A,     OP_INDHL,   F_INDXY },
    { "xor",    OP_A,     OP_A,       0 },

    { "or",     OP_A,     OP_B,       0 },
    { "or",     OP_A,     OP_C,       0 },
    { "or",     OP_A,     OP_D,       0 },
    { "or",     OP_A,     OP_E,       0 },
    { "or",     OP_A,     OP_H,       F_IXY },
    { "or",     OP_A,     OP_L,       F_IXY },
    { "or",     OP_A,     OP_INDHL,   F_INDXY },
    { "or",     OP_A,     OP_A,       0 },
    { "cp",     OP_A,     OP_B,       0 },
    { "cp",     OP_A,     OP_C,       0 },
    { "cp",     OP_A,     OP_D,       0 },
    { "cp",     OP_A,     OP_E,       0 },
    { "cp",     OP_A,     OP_H,       F_IXY },
    { "cp",     OP_A,     OP_L,       F_IXY },
    { "cp",     OP_A,     OP_INDHL,   F_INDXY },
    { "cp",     OP_A,     OP_A,       0 },

    { "ret",    OP_NZ,    OP_NONE,    0 },
    { "pop",    OP_BC,    OP_NONE,    0 },
    { "jp",     OP_NZ,    OP_IMMED16, 0 },
    { "jp",     OP_IMMED16, OP_NONE,  0 },
    { "call",   OP_NZ,    OP_IMMED16, 0 },
    { "push",   OP_BC,    OP_NONE,    0 },
    { "add",    OP_A,     OP_IMMED8,  0 },
    { "rst",    OP_RST,   OP_NONE,    0 },
    { "ret",    OP_Z,     OP_NONE,    0 },
    { "ret",    OP_NONE,  OP_NONE,    0 },
    { "jp",     OP_Z,     OP_IMMED16, 0 },
    { NULL,     OP_NONE,  OP_NONE,    0 },   /* CB */
    { "call",   OP_Z,     OP_IMMED16, 0 },
    { "call",   OP_IMMED16, OP_NONE,  0 },
    { "adc",    OP_A,     OP_IMMED8,  0 },
    { "rst",    OP_RST,   OP_NONE,    0 },

    { "ret",    OP_NC,    OP_NONE,    0 },
    { "pop",    OP_DE,    OP_NONE,    0 },
    { "jp",     OP_NC,    OP_IMMED16, 0 },
    { "out",    OP_IND8,  OP_A,       0 },
    { "call",   OP_NC,    OP_IMMED16, 0 },
    { "push",   OP_DE,    OP_NONE,    0 },
    { "sub",    OP_A,     OP_IMMED8,  0 },
    { "rst",    OP_RST,   OP_NONE,    0 },
    { "ret",    OP_Ca,    OP_NONE,    0 },
    { "exx",    OP_NONE,  OP_NONE,    0 },
    { "jp",     OP_C,     OP_IMMED16, 0 },
    { "in",     OP_A,     OP_IND8,    0 },
    { "call",   OP_Ca,    OP_IMMED16, 0 },
    { NULL,     OP_NONE,  OP_NONE,    0 },   /* DD */
    { "sbc",    OP_A,     OP_IMMED8,  0 },
    { "rst",    OP_RST,   OP_NONE,    0 },

    { "ret",    OP_PO,    OP_NONE,    0 },
    { "pop",    OP_HL,    OP_NONE,    F_IXY },
    { "jp",     OP_PO,    OP_IMMED16, 0 },
    { "ex",     OP_INDSP, OP_HL,      F_IXY },
    { "call",   OP_PO,    OP_IMMED16, 0 },
    { "push",   OP_HL,    OP_NONE,    F_IXY },
    { "and",    OP_IMMED8, OP_NONE,   0 },
    { "rst",    OP_RST,   OP_NONE,    0 },
    { "ret",    OP_PE,    OP_NONE,    0 },
    { "jp",     OP_INDHL, OP_NONE,    0 },
    { "jp",     OP_PE,    OP_IMMED16, 0 },
    { "ex",     OP_DE,    OP_HL,      0 },
    { "call",   OP_PE,    OP_IMMED16, 0 },
    { NULL,     OP_NONE,  OP_NONE,    0 },   /* DD */
    { "xor",    OP_IMMED8, OP_NONE,   0 },

    { "rst",    OP_RST,   OP_NONE,    0 },
    { "ret",    OP_P,     OP_NONE,    0 },
    { "pop",    OP_AF,    OP_NONE,    0 },
    { "jp",     OP_P,     OP_IMMED16, 0 },
    { "di",     OP_NONE,  OP_NONE,    0 },
    { "call",   OP_P,     OP_IMMED16, 0 },
    { "push",   OP_AF,    OP_NONE,    0 },
    { "or",     OP_IMMED8, OP_NONE,   0 },
    { "rst",    OP_RST,   OP_NONE,    0 },
    { "ret",    OP_M,     OP_NONE,    0 },
    { "ld",     OP_SP,    OP_HL,      F_IXY },
    { "jp",     OP_M,     OP_IMMED16, 0 },
    { "ei",     OP_NONE,  OP_NONE,    0 },
    { "call",   OP_M,     OP_IMMED16, 0 },
    { NULL,     OP_NONE,  OP_NONE,    0 },   /* FD */
    { "cp",     OP_IMMED8, OP_NONE,   0 },
    { "rst",    OP_RST,   OP_NONE,    0 }
};

instruction cb_page[] = {
    { "rlc",    OP_B,     OP_NONE,    0 },
    { "rlc",    OP_C,     OP_NONE,    0 },
    { "rlc",    OP_D,     OP_NONE,    0 },
    { "rlc",    OP_E,     OP_NONE,    0 },
    { "rlc",    OP_H,     OP_NONE,    0 },
    { "rlc",    OP_L,     OP_NONE,    0 },
    { "rlc",    OP_INDHL, OP_NONE,    F_INDXY },
    { "rlc",    OP_A,     OP_NONE,    0 },
    { "rrc",    OP_B,     OP_NONE,    0 },
    { "rrc",    OP_C,     OP_NONE,    0 },
    { "rrc",    OP_D,     OP_NONE,    0 },
    { "rrc",    OP_E,     OP_NONE,    0 },
    { "rrc",    OP_H,     OP_NONE,    0 },
    { "rrc",    OP_L,     OP_NONE,    0 },
    { "rrc",    OP_INDHL, OP_NONE,    F_INDXY },
    { "rrc",    OP_A,     OP_NONE,    0 },

    { "rl",     OP_B,     OP_NONE,    0 },
    { "rl",     OP_C,     OP_NONE,    0 },
    { "rl",     OP_D,     OP_NONE,    0 },
    { "rl",     OP_E,     OP_NONE,    0 },
    { "rl",     OP_H,     OP_NONE,    0 },
    { "rl",     OP_L,     OP_NONE,    0 },
    { "rl",     OP_INDHL, OP_NONE,    F_INDXY },
    { "rl",     OP_A,     OP_NONE,    0 },
    { "rr",     OP_B,     OP_NONE,    0 },
    { "rr",     OP_C,     OP_NONE,    0 },
    { "rr",     OP_D,     OP_NONE,    0 },
    { "rr",     OP_E,     OP_NONE,    0 },
    { "rr",     OP_H,     OP_NONE,    0 },
    { "rr",     OP_L,     OP_NONE,    0 },
    { "rr",     OP_INDHL, OP_NONE,    F_INDXY },
    { "rr",     OP_A,     OP_NONE,    0 },

    { "sla",    OP_B,     OP_NONE,    0 },
    { "sla",    OP_C,     OP_NONE,    0 },
    { "sla",    OP_D,     OP_NONE,    0 },
    { "sla",    OP_E,     OP_NONE,    0 },
    { "sla",    OP_H,     OP_NONE,    0 },
    { "sla",    OP_L,     OP_NONE,    0 },
    { "sla",    OP_INDHL, OP_NONE,    F_INDXY },
    { "sla",    OP_A,     OP_NONE,    0 },
    { "sra",    OP_B,     OP_NONE,    0 },
    { "sra",    OP_C,     OP_NONE,    0 },
    { "sra",    OP_D,     OP_NONE,    0 },
    { "sra",    OP_E,     OP_NONE,    0 },
    { "sra",    OP_H,     OP_NONE,    0 },
    { "sra",    OP_L,     OP_NONE,    0 },
    { "sra",    OP_INDHL, OP_NONE,    F_INDXY },
    { "sra",    OP_A,     OP_NONE,    0 },

    { "sl1",    OP_B,     OP_NONE,    0 },
    { "sl1",    OP_C,     OP_NONE,    0 },
    { "sl1",    OP_D,     OP_NONE,    0 },
    { "sl1",    OP_E,     OP_NONE,    0 },
    { "sl1",    OP_H,     OP_NONE,    0 },
    { "sl1",    OP_L,     OP_NONE,    0 },
    { "sl1",    OP_INDHL, OP_NONE,    F_INDXY },
    { "sl1",    OP_A,     OP_NONE,    0 },
    { "srl",    OP_B,     OP_NONE,    0 },
    { "srl",    OP_C,     OP_NONE,    0 },
    { "srl",    OP_D,     OP_NONE,    0 },
    { "srl",    OP_E,     OP_NONE,    0 },
    { "srl",    OP_H,     OP_NONE,    0 },
    { "srl",    OP_L,     OP_NONE,    0 },
    { "srl",    OP_INDHL, OP_NONE,    F_INDXY },
    { "srl",    OP_A,     OP_NONE,    0 },

    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },
    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },

    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },
    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },

    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },
    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   0 },
    { "bit",    OP_BIT,   OP_A,       0 },

    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },
    { "bit",    OP_BIT,   OP_B,       0 },
    { "bit",    OP_BIT,   OP_C,       0 },
    { "bit",    OP_BIT,   OP_D,       0 },
    { "bit",    OP_BIT,   OP_E,       0 },
    { "bit",    OP_BIT,   OP_H,       0 },
    { "bit",    OP_BIT,   OP_L,       0 },
    { "bit",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "bit",    OP_BIT,   OP_A,       0 },

    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },
    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   0 },
    { "res",    OP_BIT,   OP_A,       0 },

    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },
    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },

    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },
    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },

    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },
    { "res",    OP_BIT,   OP_B,       0 },
    { "res",    OP_BIT,   OP_C,       0 },
    { "res",    OP_BIT,   OP_D,       0 },
    { "res",    OP_BIT,   OP_E,       0 },
    { "res",    OP_BIT,   OP_H,       0 },
    { "res",    OP_BIT,   OP_L,       0 },
    { "res",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "res",    OP_BIT,   OP_A,       0 },

    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },
    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },

    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },
    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },

    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },
    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },

    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },
    { "set",    OP_BIT,   OP_B,       0 },
    { "set",    OP_BIT,   OP_C,       0 },
    { "set",    OP_BIT,   OP_D,       0 },
    { "set",    OP_BIT,   OP_E,       0 },
    { "set",    OP_BIT,   OP_H,       0 },
    { "set",    OP_BIT,   OP_L,       0 },
    { "set",    OP_BIT,   OP_INDHL,   F_INDXY },
    { "set",    OP_BIT,   OP_A,       0 },
};

instruction ed_page[] = {
    { NULL,     OP_NONE,  OP_NONE,    0 },   /* 0x00 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },   /* 0x10 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0x20 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0x40 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { "in",     OP_B,     OP_PORTC,   0 }, /* 0x50 */
    { "out",    OP_PORTC, OP_B,       0 },
    { "sbc",    OP_HL,    OP_BC,      0 },
    { "ld",     OP_IND16, OP_BC,      0 },
    { "neg",    OP_NONE,  OP_NONE,    0 },
    { "retn",   OP_NONE,  OP_NONE,    0 },
    { "im",     OP_IM,    OP_NONE,    0 },
    { "ld",     OP_I,     OP_A,       0},
    { "in",     OP_C,     OP_PORTC,   0 },
    { "out",    OP_PORTC, OP_C,       0 },
    { "adc",    OP_HL,    OP_BC,      0 },
    { "ld",     OP_BC,    OP_IND16,   0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "reti",   OP_NONE,  OP_NONE,    0 },
    { "[im0]",  OP_NONE,  OP_NONE,    0 },
    { "ld",     OP_R,     OP_A,       0 },

    { "in",     OP_D,     OP_PORTC,   0 }, /* 0x60 */
    { "out",    OP_PORTC, OP_D,       0 },
    { "sbc",    OP_HL,    OP_DE,      0 },
    { "ld",     OP_IND16, OP_DE,      0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[retn]", OP_NONE,  OP_NONE,    0 },
    { "im",     OP_IM,    OP_NONE,    0 },
    { "ld",     OP_A,     OP_I,       0 },
    { "in",     OP_E,     OP_PORTC,   0 },
    { "out",    OP_PORTC, OP_E,       0 },
    { "adc",    OP_HL,    OP_DE,      0 },
    { "ld",     OP_DE,    OP_IND16,   0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[reti]", OP_NONE,  OP_NONE,    0 },
    { "IM",     OP_IM,    OP_NONE,    0 },
    { "ld",     OP_A,     OP_R,       0 },


    { "in",     OP_H,     OP_PORTC,   0 },  /* 0x70 */
    { "out",    OP_PORTC, OP_H,       0 },
    { "sbc",    OP_HL,    OP_HL,      0 },
    { "ld",     OP_IND16, OP_HL,      0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[retn]", OP_NONE,  OP_NONE,    0 },
    { "[im0]",  OP_NONE,  OP_NONE,    0 },
    { "rrd",    OP_NONE,  OP_NONE,    0 },
    { "in",     OP_L,     OP_PORTC,   0 },
    { "out",    OP_PORTC, OP_L,       0 },
    { "adc",    OP_HL,    OP_HL,      0 },
    { "ld",     OP_HL,    OP_IND16,   0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[reti]", OP_NONE,  OP_NONE,    0 },
    { "[im0]",  OP_NONE,  OP_NONE,    0 },
    { "rld",    OP_NONE,  OP_NONE,    0 },

    { "in",     OP_F,     OP_PORTC,   0 }, /* 0x80 */
    { "out",    OP_PORTC, OP_F,       0 },
    { "sbc",    OP_HL,    OP_SP,      0 },
    { "ld",     OP_IND16, OP_SP,      0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[retn]", OP_NONE,  OP_NONE,    0 },
    { "[im1]",  OP_NONE,  OP_NONE,    0 },
    { "[ld i,i]", OP_NONE,  OP_NONE,    0 },
    { "in",     OP_A,     OP_PORTC,   0 },
    { "out",    OP_PORTC, OP_A,       0 },
    { "adc",    OP_HL,    OP_SP,      0 },
    { "ld",     OP_SP,    OP_IND16,   0 },
    { "[neg]",  OP_NONE,  OP_NONE,    0 },
    { "[reti]", OP_NONE,  OP_NONE,    0 },
    { "[im2]",  OP_NONE,  OP_NONE,    0 },
    { "[ld r,r]", OP_NONE,OP_NONE,    0 },

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0x90 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0xA0 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { "ldi",    OP_NONE,  OP_NONE,    0 }, /* 0xB0 */
    { "cpi",    OP_NONE,  OP_NONE,    0 },
    { "ini",    OP_NONE,  OP_NONE,    0 },
    { "oti",    OP_NONE,  OP_NONE,    0 },
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { "ldd",    OP_NONE,  OP_NONE,    0 },
    { "cpd",    OP_NONE,  OP_NONE,    0 },
    { "ind",    OP_NONE,  OP_NONE,    0 },
    { "otd",    OP_NONE,  OP_NONE,    0 },
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { "ldir",   OP_NONE,  OP_NONE,    0 }, /* 0xc0 */
    { "cpir",   OP_NONE,  OP_NONE,    0 },
    { "inIr",   OP_NONE,  OP_NONE,    0 },
    { "otir",   OP_NONE,  OP_NONE,    0 },
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { "lddr",   OP_NONE,  OP_NONE,    0 },
    { "cpdr",   OP_NONE,  OP_NONE,    0 },
    { "indr",   OP_NONE,  OP_NONE,    0 },
    { "otdr",   OP_NONE,  OP_NONE,    0 },
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0xd0 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 },  /* 0xe0 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 

    { NULL,     OP_NONE,  OP_NONE,    0 }, /* 0xf0 */
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
    { NULL,     OP_NONE,  OP_NONE,    0 }, 
};

typedef struct {
    int       index;
    int       pc;
    int       len;
    uint8_t   opcode;
    uint8_t   instr_bytes[6];
} dcontext;

#define READ_BYTE(state,val) do { \
        val = get_memory(state->pc++); \
        state->instr_bytes[state->len++] = val; \
    } while (0)

char *get_operand(dcontext *state, instruction *instr, operand op, char *buf, size_t buflen)
{
    int8_t displacement = 0;
    uint8_t msb, lsb;


    switch ( op ) {
    case OP_NONE:
	return NULL;
    case OP_A:
	return "a";
    case OP_B:
	return "b";
    case OP_C:
	return "c";
    case OP_D:
	return "d";
    case OP_E:
	return "e";
    case OP_H:
	if ( state->index == 0xDD && instr->flags & F_IXY) {
	    return "ixh";
	} else if ( state->index == 0xFD && instr->flags & F_IXY) {
	    return "iyh";
        }
	return "h";
    case OP_L:
	if ( state->index == 0xDD && instr->flags & F_IXY) {
	    return "ixl";
	} else if ( state->index == 0xFD && instr->flags & F_IXY) {
	    return "iyl";
        }
	return "l";
    case OP_AF:
	return "af";
    case OP_BC:
	return "bc";
    case OP_DE:
	return "de";
    case OP_HL:
	if ( state->index == 0xDD ) {
	    return "ix";
	} else if ( state->index == 0xFD ) {
	    return "iy";
        }
	return "hl";
    case OP_SP:
	return "sp";
    case OP_INDDE:
	return "(de)";
    case OP_INDBC:
	return "(bc)";
    case OP_INDSP:
	return "(sp)";
    case OP_Z:
	return "z";
    case OP_NZ:
	return "nz";
    case OP_Ca:
	return "c";
    case OP_NC:
	return "nc";
    case OP_P:
	return "p";
    case OP_PO:
	return "po";
    case OP_PE:
	return "pe";
    case OP_M:
	return "m";
    case OP_PORTC:
	return "(c)";
    case OP_F:
	return "f";
    case OP_I:
	return "i";
    case OP_R:
	return "r";
    case OP_INDHL:
	if ( instr->flags & F_INDXY && state->index ) {
	    READ_BYTE(state, displacement);
	    snprintf(buf,buflen,"(%s%s$%02x)", state->index == 0xdd ? "ix" : "iy", displacement < 0 ? "-" : "+", displacement < 0 ? -displacement : displacement);
	    return buf;
        }
	return "(hl)";
    case OP_IND8:
	READ_BYTE(state, lsb);
	snprintf(buf,buflen,"($%02x", lsb);
	return buf;
    case OP_IND16:
	READ_BYTE(state, lsb);
	READ_BYTE(state, msb);
	snprintf(buf,buflen,"($%02x%02x)", msb, lsb);
	return buf;
    case OP_IMMED8:
	READ_BYTE(state, lsb);
	snprintf(buf,buflen,"$%02x", lsb);
	return buf;
    case OP_IMMED16:
	READ_BYTE(state, lsb);
	READ_BYTE(state, msb);
	snprintf(buf,buflen,"$%02x%02x", msb, lsb);
	return buf;
    case OP_REL8:
	READ_BYTE(state, lsb);
	snprintf(buf,buflen,"$%04x", state->pc + lsb); // TODO...
	return buf;
    case OP_BIT:
	snprintf(buf,buflen,"%d", (( state->opcode ) & 0x38) >> 3);
	return buf;
    case OP_RST:
	snprintf(buf,buflen,"%d", ( state->opcode ) & 0x38);
	return buf;
    case OP_IM:
        snprintf(buf, buflen, "%d", !(state->opcode & (1 << 4)) ? 0 : !(state->opcode & (1 << 3)) ? 1 : 2);
	return buf; 
    }
}

int disassemble(int pc)
{
    dcontext    s_state = {0};
    dcontext   *state = &s_state;
    int         i;
    uint8_t     b;
    instruction *table = main_page;
    instruction *instr;
    char        *label;

    state->pc = pc;

    label = find_symbol(pc);
    if (label ) {
       printf("%s:\t",label);
    } else {
      printf("l_%04x:\t",pc);
    }
    do {
	char     buf1[100];
	char     buf2[100];
	char    *op1 = NULL;
	char    *op2 = NULL;

	if ( state->len > 5 ) {
	    /* Instruction too long */
	    break;
	}
        READ_BYTE(state,b);
        if ( b == 0xDD || b == 0xFD ) {
            state->index = b;
	    continue;
        }
	if ( b == 0xED ) {
	    table = ed_page;
            READ_BYTE(state,b);
	    state->index = 0; // Index ops not permitted
	} else if ( b == 0xcb ) {
	    table = cb_page;
            READ_BYTE(state,b);
	}
	state->opcode = b;
	instr = &table[b];

	/* We now have the instruction (TODO: CPU flags) */
	if ( instr->opcode == NULL ) {
	    printf("\t[nop]\t\t;");
	} else {
            printf("\t%-8s", instr->opcode);
	    op1 = get_operand(state, instr, instr->op1,buf1,sizeof(buf1));
	    op2 = get_operand(state, instr, instr->op2,buf2,sizeof(buf2));

	    if ( op1 ) {
		printf("%s",op1);
		if ( op2 ) {
		    printf(",%s",op2);
		}
            }
	    printf("\t\t;");
	}
	break;
    } while ( 1 );

    for ( i = 0; i < state->len; i++ ) {
	printf("%s%02x", i ? " " : "", state->instr_bytes[i]);
    }
    printf("\n");

    return state->len;
}



static uint8_t get_memory(int pc)
{
    return mem[pc % 65536];
}
