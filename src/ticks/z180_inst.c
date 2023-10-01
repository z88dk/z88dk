
// Z180 instructions
#include "ticks.h"
#include <stdio.h>


#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemeneted opcode %02x/%s",o,t); \
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
        UNIMPLEMENTED(opcode, "MLT SP");
        break;
    }
    st += isez80() ? 6 : 17;
}



void z180_otim(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "otim");
}

void z180_otdm(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "otdm");
}

void z180_otimr(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "otimr");
}

void z180_otdmr(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "otdmr");
}