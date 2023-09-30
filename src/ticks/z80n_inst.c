
// Spectrum Next Z80N instructions

#include "ticks.h"


static const uint8_t mirror_table[] = {
    0x0, 0x8, 0x4, 0xC,  /*  0-3  */
    0x2, 0xA, 0x6, 0xE,  /*  4-7  */
    0x1, 0x9, 0x5, 0xD,  /*  8-11 */
    0x3, 0xB, 0x7, 0xF   /* 12-15 */
};


void z80n_mirror(void)
{
    a = mirror_table[a & 0x0f] << 4 | mirror_table[(a & 0xf0) >> 4];
    st += 8;
}

// OUTINB : out(BC,HL*); HL++
void z80n_outinb(void)
{
    uint8_t t;
    out(c | b << 8, t = get_memory_data(l | h << 8));
    ++l || h++;
    st += 16;
}


// NEXTREG $im8,$im8	
void z80n_nextreg_8_8(void)
{
    uint8_t v = get_memory_inst(pc++);
    uint8_t r = get_memory_inst(pc++);
    out(0x243b, v);
    out(0x253b, r);
    st += 20;
}

// NEXTREG $im8,a
void z80n_nextreg_8_a(void)
{
    uint8_t v = get_memory_inst(pc++);
    out(0x243b, v);
    out(0x253b, a);
    st += 17;
}


// LDWS : DE*:=HL*; INC L; INC D;
void z80n_ldws(void)
{
    uint8_t t;
    put_memory(e | d << 8, t = get_memory_data(l | h << 8));
    l++; d++;
    st += 14;
}



// LDPIRX : do{t:=(HL&$FFF8+E&7)*; {if t!=A DE*:=t;} DE++; BC--}while(BC>0)
void z80n_ldpirx(void)
{
    uint8_t t = get_memory_data(((l | h << 8) & 0xfff8) + (e & 0x07));
    if (t != a) put_memory(e | d << 8, t);
    ++e || d++;
    c-- || b--;
    st += 16;
    if ((b | c) != 0) { pc -= 2; st += 5; }
}

// LDIX: {if HL*!=A DE*:=HL*;} DE++; HL++; BC--
void z80n_ldix(void)
{
    uint8_t t;
    // LDIX
    st += 16;
    t = get_memory_data(l | h<<8);
    if ( t != a ) {
        put_memory(e | d<<8, t= get_memory_data(l | h<<8));
    }
    ++l || h++;
    ++e || d++;
    c-- || b--;
    fr && (fr= 1);
    t+= a;
    ff=  ff    & -41
        | t     &   8
        | t<<4  &  32;
    fa= 0;
    b|c && (fa= 128);
    fb= fa;
}

// LDDX: {if HL*!=A DE*:=HL*;} DE++; HL--; BC--
void z80n_lddx(void)
{
    uint8_t t = get_memory_data(l | h<<8);
    st += 16;
    if ( t != a ) {
        put_memory(e | d<<8, t= get_memory_data(l | h<<8));
    }
    l-- || h--;
    e-- || d--;
    c-- || b--;
    fr && (fr= 1);
    t+= a;
    ff=  ff    & -41
    | t     &   8
    | t<<4  &  32;
    fa= 0;
    b|c && (fa= 128);
    fb= fa;
}

// LDIRX: do LDIX while(BC>0)
void z80n_ldirx(void)
{
    uint8_t t = get_memory_data(l | h<<8);
    st += 16;
    if ( t != a ) {
        put_memory(e | d<<8, t= get_memory_data(l | h<<8));
    }
    ++l || h++;
    ++e || d++;
    c-- || b--;
    fr && (fr= 1);
    t+= a;
    ff=  ff    & -41
    | t     &   8
    | t<<4  &  32;
    fa= 0;
    b|c && ( fa= 128,
            st+= 5,
            mp= --pc,
                    --pc);
    fb= fa;
}

// LDDRX: do LDDX while(BC>0)
void z80n_lddrx(void)
{
    uint8_t t = get_memory_data(l | h<<8);
    st += 16;
    if ( t != a ) {
        put_memory(e | d<<8, t= get_memory_data(l | h<<8));
    }
    l-- || h--;
    e-- || d--;
    c-- || b--;
    fr && (fr= 1);
    t+= a;
    ff=  ff    & -41
    | t     &   8
    | t<<4  &  32;
    fa= 0;
    b|c && ( fa= 128,
            st+= 5,
            mp= --pc,
            --pc);
    fb= fa;
}

void z80n_mul_d_e(void)
{
    int16_t result = d * e;
    d  = (result >> 8 ) & 0xff;
    e = result & 0xff;
    st += 8;
}

void z80n_add_hl_a(void)
{
    int16_t result = (( h * 256 ) + l) + a;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 8;
}

void z80n_add_hl_mn(void)
{
    // ADD HL,mn
    uint8_t lsb = get_memory_inst(pc++);
    uint8_t msb = get_memory_inst(pc++);
    int16_t result = (( h * 256 ) + l) + ( lsb + msb * 256);
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 16;
}

void z80n_add_de_mn(void)
{
    uint8_t lsb = get_memory_inst(pc++);
    uint8_t msb = get_memory_inst(pc++);
    int16_t result = (( d * 256 ) + e) + ( lsb + msb * 256);
    d  = (result >> 8 ) & 0xff;
    e = result & 0xff;
    st += 16;
}

void z80n_add_bc_mn(void)
{
    uint8_t lsb = get_memory_inst(pc++);
    uint8_t msb = get_memory_inst(pc++);
    int16_t result = (( b * 256 ) + c) + ( lsb + msb * 256);
    b = (result >> 8 ) & 0xff;
    c = result & 0xff;
    st += 16;
}


void z80n_push_mn(void)
{
    uint8_t msb = get_memory_inst(pc++);
    uint8_t lsb = get_memory_inst(pc++);

    put_memory(--sp,lsb);
    put_memory(--sp,msb);

    st += 23;
}


void z80n_add_de_a(void)
{
    int16_t result = (( d * 256 ) + e) + a;
    d  = (result >> 8 ) & 0xff;
    e = result & 0xff;
    st += 8;
}

void z80n_add_bc_a(void)
{            
    int16_t result = (( b * 256 ) + c) + a;
    b  = (result >> 8 ) & 0xff;
    c = result & 0xff;
    st += 8;
}
