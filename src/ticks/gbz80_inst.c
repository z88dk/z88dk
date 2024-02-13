
// Instructions for GBZ80/sm83


#include "ticks.h"

void gbz80_ld_inm_sp(void)
{
    mp= get_memory_inst(pc++);
    put_memory(mp|= get_memory_inst(pc++)<<8, sp & 0xff);
    put_memory(++mp,sp>>8);
    st += 20;
}

// TODO: Flags incorrect
void gbz80_add_sp_d(void)
{
    uint32_t v;

    SUSPECT_IMPL("Incorrect flags");
    st += 4;
    v = sp + (get_memory_inst(pc++)^128)-128;
    sp = v & 0xffff;
    if ( v >> 16 ) ff |= 256;
    else ff &= ~256;
}

void gbz80_ld_hl_spd(void)
{
    uint16_t t;
    st += 12;
    t = (sp + (get_memory_inst(pc++)^128)-128) & 0xffff;
    h = t / 256;
    l = t % 256;
}

void gbz80_ld_inm_a(void)
{
    uint16_t t;

    st+= 16;
    t= get_memory_inst(pc++);
    put_memory(t|= get_memory_inst(pc++)<<8,a);
    mp= t+1 & 255
        | a<<8;
}

void gbz80_ld_a_inm(void)
{
    st+= 16;
    mp= get_memory_inst(pc++);
    a= get_memory_data(mp|= get_memory_inst(pc++)<<8);
    ++mp;
}
