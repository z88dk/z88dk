
#include "ticks.h"
#include <stdio.h>



#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %02x/%s",o,t); \
    } while (0)


#define SUBHLRR(a, b) do {      \
            mp= l+1+(h<<8);     \
            v= l-b+((h-a)<<8),  \
            ff= v>>8,           \
            fa= h,              \
            fb= ~a,             \
            h= ff,              \
            l= v,               \
            fr= h|l<<8;         \
        } while(0)

void i8085_rim(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "rim");
    st+=4;
}

void i8085_sim(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "sim");
    st+=4;
}

void i8085_rstv(uint8_t opcode)
{
    // V flag is bit 1 of flags (not emulated since we don't use it)
    st += 6;;
    UNIMPLEMENTED(opcode, "rstv");
}

void i8085_ld_de_hln(uint8_t opcode)
{
    uint16_t val =(l | h<<8) + get_memory_inst(pc++);
    d = val / 256;
    e = val % 256;
    st += 10;
}


void i8085_ld_de_spn(uint8_t opcode)
{
    uint16_t val = sp + get_memory_inst(pc++);
    d = val / 256;
    e = val % 256;
    st += 10;
}

void i8085_ld_hl_ide(uint8_t opcode)
{
    l = get_memory_data( (e|d<<8));
    h = get_memory_data( (e|d<<8) + 1);
    st+=10;
}

void i8085_ld_ide_hl(uint8_t opcode)
{
    put_memory((e | d<<8),l);
    put_memory((e | d<<8) + 1,h);
    st+=10;
}

void i8085_sub_hl_bc(uint8_t opcode)
{
    int v;
    SUBHLRR(b,c);
    st += 10;
}