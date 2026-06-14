
#include "ticks.h"
#include <stdio.h>



#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %02x/%s",o,t); \
    } while (0)

//                        int q = m_HL.b.l - m_BC.b.l;
//                                m_AF.b.l = lut_zs[q & 0xff] | ((q >> 8) & CF) | VF | ((m_HL.b.l ^ q ^ m_BC.b.l) & HF) | (((m_BC.b.l ^ m_HL.b.l) & (m_HL.b.l ^ q) & SF) >> 5);
//                                m_HL.b.l = q;
//                                q = m_HL.b.h - m_BC.b.h - (m_AF.b.l & CF);
//  m_AF.b.l = lut_zs[q & 0xff] | ((q >> 8) & CF) | VF | ((m_HL.b.h ^ q ^ m_BC.b.h) & HF) | (((m_BC.b.h ^ m_HL.b.h) & (m_HL.b.h ^ q) & SF) >> 5);
/* DSUB (HL - rr). The K flag (bit 5) is the 8085's signed-comparison
   indicator: after the subtraction K = S ^ V (sign of the true signed
   result), so `jp k` is taken iff HL < rr signed — including the
   overflow case where the raw result sign alone is wrong. Compute it
   as a clean 0/1 from the original operands (captured before h/l are
   overwritten below). ff/fr/fa/fb/mp are left exactly as before so the
   S/Z/C/H/parity flags are unchanged. */
#define SUBHLRR(a, b) do {                                            \
            int _hl0 = (h<<8)|l;                                      \
            int _rr0 = (((a)&0xff)<<8)|((b)&0xff);                    \
            int _res0 = (_hl0 - _rr0) & 0xffff;                       \
            mp= l+1+(h<<8);                                           \
            v= l-b+((h-a)<<8),                                        \
            ff= v>>8,                                                 \
            fa= h,                                                    \
            fb= ~a,                                                   \
            h= ff,                                                    \
            l= v,                                                     \
            fr= h|l<<8,                                               \
            fk= ((_res0>>15) ^ (((_hl0 ^ _rr0) & (_hl0 ^ _res0))>>15)) & 1; \
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
