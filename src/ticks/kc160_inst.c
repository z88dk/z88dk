
#include "ticks.h"
#include <stdio.h>



#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)


uint8_t   xp, yp, zp, pp;

uint8_t   spl, sph;

// R goes from 0-2
static uint8_t **get_rr_from_reg(uint8_t r)
{
    static uint8_t *reg[2] = {0};

    switch ( r ) {
    case 0:
        reg[0] = &c;
        reg[1] = &b;
        break;
    case 1:
        reg[0] = &e;
        reg[1] = &d;
        break;
    case 2:
        reg[0] = &l;
        reg[1] = &h;
        break;
    case 3:
        spl = (sp & 0xff);
        sph = (sp >> 8) & 0xff;
        reg[0] = &spl;
        reg[1] = &sph;
        break;
    }
    return reg;
}

// 0 = iy
// 1 = ix
// 2 = sp
static uint16_t get_addr_from_z(uint8_t z)
{
    if ( z == 0 ) {
        return yh<<8|yl;
    } else if ( z == 1 ) {
        return xh<<8|xl;
    }
    return sp;
}

// ld rr,(ix+d), ld rr,(iy+d), ld rr,(sp+d)
void kc160_ld_rr_ixysd(uint8_t opcode)
{
    int dr = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_rr_from_reg(dr);
    uint16_t addr = get_addr_from_z((opcode & 0x0f) - 0x0c) +  (get_memory_inst(pc++)^128)-128;

    *dest[0] = get_memory_data(addr);
    *dest[1] = get_memory_data(addr+1);

    // Little fudge
    if ( dr == 0x03 ) sp = (sph<<8)|spl;

    st += 4;
}



// ld rr,(ix+d), ld rr,(iy+d), ld rr,(sp+d)
void kc160_ld_ixysd_rr(uint8_t opcode)
{
    int sr = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_rr_from_reg(sr);
    uint16_t addr = get_addr_from_z((opcode & 0x0f) - 0x04) +  (get_memory_inst(pc++)^128)-128;

    put_memory(addr, *dest[0]);
    put_memory(addr+1, *dest[1]);
  
    st += 4;
}




// ld xy,(ix+d), ld xy,(iy+d), ld xy,(sp+d)
void kc160_ld_xy_ixysd(uint8_t opcode)
{
    uint16_t addr = get_addr_from_z((opcode & 0x0f) - 0x0c) +  (get_memory_inst(pc++)^128)-128;

    if ( (opcode & 0xf0) == 0x80 ) {
        xl = get_memory_data(addr);
        xh = get_memory_data(addr+1);
    } else {
        xl = get_memory_data(addr);
        xh = get_memory_data(addr+1);
    }

    st += 4;
}



// ld xy,(ix+d), ld xy,(iy+d), ld xy,(sp+d)
void kc160_ld_ixysd_xy(uint8_t opcode)
{
    uint16_t addr = get_addr_from_z((opcode & 0x0f) - 0x04) +  (get_memory_inst(pc++)^128)-128;

    if ( (opcode & 0xf0) == 0x80 ) {
        put_memory(addr, xl);
        put_memory(addr+1, xh);
    } else {
        put_memory(addr, yl);
        put_memory(addr+1, yh);
    }
  
    st += 4;
}

void kc160_jp3(uint8_t opcode, uint8_t dojump)
{
    uint32_t addr;

    addr = get_memory_inst(pc + 0 ) | (get_memory_inst(pc+1) << 8) | (get_memory_inst(pc+2) << 16);
    pc += 3;

    UNIMPLEMENTED(0xed00|opcode, "JP3 [cc,],lmn");

    st += 5;
}

// ld iy,sp ld ix,sp ld hl,sp
void kc160_ld_hxy_sp(uint8_t opcode)
{
    if ( (opcode & 0xf0) == 0x00 ) {
        xh = (sp >> 8 ) & 0xff;
        xl = (sp >> 0 ) & 0xff;
    } else if ( (opcode & 0xf0) == 0x10 ) {
        yh = (sp >> 8 ) & 0xff;
        yl = (sp >> 0 ) & 0xff;
    } else if ( (opcode & 0xf0) == 0x20 ) {
        h = (sp >> 8 ) & 0xff;
        l = (sp >> 0 ) & 0xff;
    }
    st += 2;
}


void kc160_ldi_xy(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ldi xy");
}

void kc160_ldir_xy(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ldir xy");
}

void kc160_ldd_xy(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ldd xy");
}

void kc160_lddr_xy(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"lddr xy");
}


void kc160_cpi_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"cpi x");
}

void kc160_cpir_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"cpir x");
}

void kc160_cpd_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"cpd x");
}

void kc160_cpdr_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"cpdr x");
}


void kc160_ini_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ini x");
}

void kc160_inir_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"inir x");
}

void kc160_ind_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ini x");
}

void kc160_indr_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"inir x");
}

void kc160_outi_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ini x");
}

void kc160_otir_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"inir x");
}

void kc160_outd_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ini x");
}

void kc160_otdr_x(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"inir x");
}