
// R800 instructions

#include "ticks.h"

// Unsigned 8 bit multiplication
void r800_mulub(uint8_t opcode)
{
    int op = (opcode >> 3 ) & 0x07;
    uint8_t r2;
    uint16_t v;
    
    switch ( op ) {
    case 0x00:
        r2 = b;
        break;
    case 0x01:
        r2 = c;
        break;
    case 0x02:
        r2  = d;
        break;
    case 0x03:
        r2 = e;
        break;
    case 0x04:
        r2 = h;
        break;
    case 0x05:
        r2 = l;
    case 0x06:
        return;   // No opcode here
    case 0x07:
        r2 = a;
        break;
    }
    
    v = a * r2;  
    h = (v >> 8) & 0xff;
    l = v & 0xff;
    st += 14;
}

// DE:HL = HL • rr
void r800_muluw(uint8_t opcode)
{
    int  op = (opcode >> 4) &0x03;
    uint32_t r;
    uint32_t result;

    switch (op) {
    case 0x00:
        r = (( b * 256 ) + c);
        break;
    case 0x01:
        r = (( d * 256 ) + e);
        break;
    case 0x02:
        r = (( h * 256 ) + l);
        break;
    case 0x03:
        r = (sp & 0xffff);
        break;
    }

    result = (( h * 256 ) + l) * r;
    d = (result >> 24) & 0xff;
    e = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 36;
}