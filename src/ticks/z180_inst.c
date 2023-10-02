
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


void z180_in0(uint8_t opcode)
{
    uint8_t p = get_memory_inst(pc++);

    UNIMPLEMENTED(0xed00|opcode, "in0");
    st += 12;
}

void z180_out0(uint8_t opcode)
{
    uint8_t p = get_memory_inst(pc++);
    UNIMPLEMENTED(0xed00|opcode, "out0");
    st += 13;
}

void z180_slp(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "slp");
}