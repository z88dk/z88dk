
// Z180 instructions
#include "ticks.h"
#include <stdio.h>


#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)

void z180_mlt(uint8_t opcode)
{
    int class = (opcode >> 4) & 0x03;
    uint16_t v;

    switch ( class ) {
    case 0x00:      // MLT BC
        v = b * c;
        b = v >> 8;
        c = v;
        break;
    case 0x01:      // MLT DE
        v = d * e;
        d = v >> 8;
        e = v;
        break;
    case 0x02:      // MLT HL
        v = h * l;
        h = v >> 8;
        l = v;
        break;
    case 0x03:      // MLT SP
        UNIMPLEMENTED(0xed00|opcode, "mlt sp");
        break;
    }
    st += isez80() ? 6 : 17;
}



void z180_otim(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "otim");
}

void z180_otdm(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "otdm");
}

void z180_otimr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "otimr");
}

void z180_otdmr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "otdmr");
}


/* Register field of IN0/OUT0. Official ops use B, C, D, E, H, L, and A. */
static uint8_t *z180_io_reg(uint8_t opcode)
{
    switch ( (opcode >> 3) & 7 ) {
    case 0: return &b;
    case 1: return &c;
    case 2: return &d;
    case 3: return &e;
    case 4: return &h;
    case 5: return &l;
    case 7: return &a;
    default: return NULL;
    }
}

void z180_in0(uint8_t opcode)
{
    uint8_t p = get_memory_inst(pc++);
    uint8_t *rp = z180_io_reg(opcode);
    uint8_t v = (uint8_t)in(p);

    if ( rp ) {
        *rp = v;
        /* Same lazy flags as IN r,(C). Carry stays. */
        ff = (ff & -256) | (fr = v);
        fa = v | 256;
        fb = 0;
    }
    st += isez80() ? 4 : 12;
}

void z180_out0(uint8_t opcode)
{
    uint8_t p = get_memory_inst(pc++);
    uint8_t *rp = z180_io_reg(opcode);

    if ( rp )
        out(p, *rp);
    st += isez80() ? 4 : 13;
}

void z180_slp(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "slp");
}