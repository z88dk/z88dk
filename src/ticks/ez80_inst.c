
#include "ticks.h"
#include <stdio.h>


#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)


// R goes from 0-2
uint8_t **get_rr_from_reg(uint8_t r)
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
    }
    return reg;
}


// ed page
// ed 02 = lea bc,ix+d
// ed 12 = lea de,ix+d
// ed 22 = lea hl,ix+d
// ed 03 = lea bc,iy+d
// ed 13 = lea de,iy+d
// ed 23 = lea hl,iy+d
void ez80_lea_rr_xyd(uint8_t opcode)
{
    uint8_t **reg = get_rr_from_reg( (opcode >> 4) & 0x03);
    uint16_t offs;

    if ( (opcode & 0x03) == 0x03 ) {
        offs = (yh << 8)|yl;
    } else {
        offs = (xh << 8)|xl;
    }
    
    offs += (get_memory_inst(pc++)^128)-128;

    *reg[0] = offs & 0xff;
    *reg[1] = (offs >> 8) & 0xff;

    st += 3;
}

// ed page
// bc = $07
// de = $17
// hl = $27
void ez80_ld_rr_ihl(uint8_t opcode)
{
    uint8_t **reg = get_rr_from_reg( (opcode >> 4) & 0x03);
    uint16_t addr = (h<<8)|l;

    *reg[0] = get_memory_data(addr);
    *reg[1] = get_memory_data(addr+1);

    st += 4;
}

// ed page
// bc = $0f
// de = $1f
// hl = $2f
void ez80_ld_ihl_rr(uint8_t opcode)
{
    uint8_t **reg = get_rr_from_reg( (opcode >> 4) & 0x03);
    uint16_t addr = (h<<8)|l;

    put_memory(addr, *reg[0]);
    put_memory(addr+1, *reg[1]);
    
    st += 4;
}



// ed page
// ix = 32 - lea ix, ix+d
// iy = 55 - lea iy, ix+d
void ez80_lea_xy_xd(uint8_t opcode)
{
    uint16_t addr = (get_memory_inst(pc++)^128)-128 + (xh<<8)|xl;

    if ( opcode == 0x32 ) {
        xh = (addr >> 8) & 0xff;
        xl = (addr >> 0) & 0xff;
    } else {
        yh = (addr >> 8) & 0xff;
        yl = (addr >> 0) & 0xff;
    }
    st += 3;
}

// ed page
// ix = 54 - lea ix,iy+d
// iy = 33 - lea iy,iy+d
void ez80_lea_xy_yd(uint8_t opcode)
{
    uint16_t addr = (get_memory_inst(pc++)^128)-128 + (yh<<8)|yl;

    if ( opcode == 0x54 ) {
        xh = (addr >> 8) & 0xff;
        xl = (addr >> 0) & 0xff;
    } else {
        yh = (addr >> 8) & 0xff;
        yl = (addr >> 0) & 0xff;
    }
    st += 3;
}

// ed page
void ez80_pea_xyd(uint8_t opcode)
{
    uint16_t addr;
    // ix = ed 65
    // iy = ed 66
    if ( opcode == 0x65 )
        addr = ((get_memory_inst(pc++)^128)-128+(xl|xh<<8))&65535;
    else
        addr = ((get_memory_inst(pc++)^128)-128+(yl|yh<<8))&65535;
    put_memory(--sp, addr / 256);
    put_memory(--sp, addr % 256);
    st += 5;
}


// ed page
// ix = $37
// iy = $31
void ez80_ld_xy_ihl(uint8_t opcode)
{
    uint16_t addr = (h<<8)|l;

    if ( opcode == 0x37 ) {
        xl = get_memory(addr, MEM_TYPE_DATA);
        xh = get_memory(addr + 1, MEM_TYPE_DATA);
    } else {
        yl = get_memory(addr, MEM_TYPE_DATA);
        yh = get_memory(addr + 1, MEM_TYPE_DATA);
    }
    st += 4;
}


// ed page
// ix = $3f
// iy = $3e
void ez80_ld_ihl_xy(uint8_t opcode)
{
    uint16_t addr = (h<<8)|l;

    if ( opcode == 0x3f ) {
        put_memory(addr, xl);
        put_memory(addr + 1, xh);
    } else {
        put_memory(addr, yl);
        put_memory(addr + 1, yh);
    }
    st += 4;
}




// dd,fd page
// bc = $07
// de = $17
// hl = $27
void ez80_ld_rr_ixyd(uint8_t opcode, uint8_t prefix)
{
    uint8_t **reg = get_rr_from_reg( (opcode >> 4) & 0x03);
    uint16_t addr;

    if ( prefix == 0xfd) addr = ((yh<<8)|yl) +  (get_memory_inst(pc++)^128)-128;
    else addr = ((xh<<8)|xl) +  (get_memory_inst(pc++)^128)-128;


    *reg[0] = get_memory_data(addr);
    *reg[1] = get_memory_data(addr+1);
    addr += 4; 
}

// dd,fd page
// bc = $0f
// de = $1f
// hl = $2f
void ez80_ld_ixyd_rr(uint8_t opcode, uint8_t prefix)
{
    uint8_t **reg = get_rr_from_reg( (opcode >> 4) & 0x03);
    uint16_t addr;

    if ( prefix == 0xfd) addr = ((yh<<8)|yl) +  (get_memory_inst(pc++)^128)-128;
    else addr = ((xh<<8)|xl) +  (get_memory_inst(pc++)^128)-128;

    put_memory(addr, *reg[0]);
    put_memory(addr+1, *reg[1]);
    addr += 4;
}


// dd, fd page
void ez80_ld_xy_ixyd(uint8_t opcode, uint8_t prefix)
{
    // ix,(ix+d) = dd $37
    // iy,(ix+d) = dd $31
    // iy,(iy+d) = fd $37
    // ix,(iy+d) = fd $31

    uint16_t addr;
    uint8_t  *lsb, *msb;

    lsb = &xl; msb=&xh;

    if ( prefix == 0xfd ) {
        addr = ((yh<<8)|yl) + (get_memory_inst(pc++)^128)-128;
        if ( opcode == 0x37 ) {
            lsb = &yl; msb= &yh;
        }
    } else {
        addr = ((xh<<8)|xl) + (get_memory_inst(pc++)^128)-128;
        if ( opcode == 0x31 ) {
            lsb = &yl; msb= &yh;
        }
    }

    *lsb = get_memory_data(addr);
    *msb = get_memory_data(addr+1);

    st += 5;
}

// dd, fd page
void ez80_ld_ixyd_xy(uint8_t opcode, uint8_t prefix)
{
    // (ix+d),ix = $dd $3f
    // (ix+d),iy = $dd $3e
    // (iy+d),ix = $fd $3e
    // (iy+d),iy = $fd $3f
    uint16_t addr;
    uint8_t  *lsb, *msb;

    lsb = &xl; msb=&xh;

    if ( prefix == 0xfd ) {
        addr = ((yh<<8)|yl) + (get_memory_inst(pc++)^128)-128;
        if ( opcode == 0x3f ) {
            lsb = &yl; msb= &yh;
        }
    } else {
        addr = ((xh<<8)|xl) + (get_memory_inst(pc++)^128)-128;
        if ( opcode == 0x3e ) {
            lsb = &yl; msb= &yh;
        }
    }

    put_memory(addr, *lsb);
    put_memory(addr+1, *msb);
    st += 5;
}




// ed page
void ez80_otd2r(uint8_t opcode)
{
    // ed bc
    UNIMPLEMENTED(0xed00|opcode, "otd2r");
}


void ez80_stmix(uint8_t opcode)
{
// ed 7d
    UNIMPLEMENTED(0xed00|opcode, "stmix");
}

void ez80_rsmix(uint8_t opcode)
{
// ed 7e
    UNIMPLEMENTED(0xed00|opcode, "rsmix");
}

void ez80_ini2(uint8_t opcode)
{
    // ed 84
    UNIMPLEMENTED(0xed00|opcode, "ini2");
}

void ez80_ini2r(uint8_t opcode)
{
    // ed 94
    UNIMPLEMENTED(0xed00|opcode, "ini2r");
}

void ez80_outi2(uint8_t opcode)
{
    // ed a4
    UNIMPLEMENTED(0xed00|opcode, "outi2");
}

void ez80_oti2r(uint8_t opcode)
{
    // ed b4
    UNIMPLEMENTED(0xed00|opcode, "oti2r");
}

void ez80_ind2(uint8_t opcode)
{
    // ed 8c
    UNIMPLEMENTED(0xed00|opcode, "indr");
}

void ez80_ind2r(uint8_t opcode)
{
    // ed 9c
    UNIMPLEMENTED(0xed00|opcode, "ind2r");
}

void ez80_outd2(uint8_t opcode)
{
    // ed ac
    UNIMPLEMENTED(0xed00|opcode, "outd2");
}

void ez80_outd2r(uint8_t opcode)
{
    // ed bc
    UNIMPLEMENTED(0xed00|opcode, "outd2r");
}


void ez80_inirx(uint8_t opcode)
{
    // ed c2
    UNIMPLEMENTED(0xed00|opcode, "inirx");
}

void ez80_otirx(uint8_t opcode)
{
    // ed c3
    UNIMPLEMENTED(0xed00|opcode, "otirx");
}


void ez80_indrx(uint8_t opcode)
{
    // ed ca
    UNIMPLEMENTED(0xed00|opcode, "indrx");
}

void ez80_otdrx(uint8_t opcode)
{
    // ed cb
    UNIMPLEMENTED(0xed00|opcode, "otdrx");
}

void ez80_ld_mb_a(uint8_t opcode)
{
    // ed 6d
    UNIMPLEMENTED(0xed00|opcode, "ld mb,a");
}

void ez80_ld_a_mb(uint8_t opcode)
{
    // ed 6e
    UNIMPLEMENTED(0xed00|opcode, "ld a,mb");
}

void ez80_ld_i_hl(uint8_t opcode)
{
    // ed c7
    UNIMPLEMENTED(0xed00|opcode, "ld i,hl");
}

void ez80_ld_hl_i(uint8_t opcode)
{
    // ed d7
    UNIMPLEMENTED(0xed00|opcode, "ld hl,i");
}

void ez80_inim(uint8_t opcode)
{
    // ed 82
    UNIMPLEMENTED(0xed00|opcode, "inim");
}

void ez80_inimr(uint8_t opcode)
{
    // ed 92
    UNIMPLEMENTED(0xed00|opcode, "inimr");
}

void ez80_indm(uint8_t opcode)
{
    // ed 8a
    UNIMPLEMENTED(0xed00|opcode, "indm");
}

void ez80_indmr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "indmr");
    // ed 9a
}