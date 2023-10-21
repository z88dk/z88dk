
#include "ticks.h"
#include <stdio.h>



#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)


uint8_t   xp, yp, zp, pp;

uint8_t   spl, sph;

// R goes from 0-3
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


// R goes from 0-2
static uint8_t **get_r24_from_reg(uint8_t r)
{
    static uint8_t *reg[3] = {0};

    switch ( r ) {
    case 0:
        reg[0] = &xl;
        reg[1] = &xh;
        reg[2] = &xp;
        break;
    case 1:
        reg[0] = &yl;
        reg[1] = &yh;
        reg[2] = &yp;
        break;
    case 2:
        reg[0] = &l;
        reg[1] = &h;
        reg[2] = &a;
        break;
    }
    return reg;
}

static uint8_t *get_pp(uint8_t r)
{
    switch (r & 0x03) {
    case 0:
        return &a;
    case 1:
        return &xp;
    case 2:
        return &yp;
    case 3:
        return &zp;
    }
    return NULL;
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

void kc160_ldf_ilmn_rr(uint8_t opcode)
{
    int sr = (opcode >> 4 ) & 0x03;
    uint8_t **src = get_rr_from_reg(sr);
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);

    put_memory_physical(addr, *src[0]);
    put_memory_physical(addr+1, *src[1]);

  
    st += 5;
}

void kc160_ldf_rr_ilmn(uint8_t opcode)
{
    int dr = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_rr_from_reg(dr);
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);


    *dest[0] = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dest[1] = get_memory(addr+1, MEM_TYPE_PHYSICAL);

    // Fudge for SP handling
    if ( dr == 3) sp = (sph<<8)|spl;
  
    st += 5;
}

void kc160_ldf_ilmn_xy(uint8_t opcode)
{
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);

    if ((opcode & 0xf0) == 0x90) {
        put_memory_physical(addr, yl);
        put_memory_physical(addr+1, yh);
    } else {
        put_memory_physical(addr, xl);
        put_memory_physical(addr+1, xh);
    }
    st += 5;
}

void kc160_ldf_xy_ilmn(uint8_t opcode)
{
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);

    if ((opcode & 0xf0) == 0x90) {
        yl = get_memory(addr, MEM_TYPE_PHYSICAL);
        yh = get_memory(addr+1, MEM_TYPE_PHYSICAL);
    } else {
        xl = get_memory(addr, MEM_TYPE_PHYSICAL);
        xh = get_memory(addr+1, MEM_TYPE_PHYSICAL);
    }
  
    st += 5;
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

void kc160_ld_pp_pp(uint8_t opcode)
{
    uint8_t z = (opcode & 0x0f);
    uint8_t q = (opcode >> 3) & 0x1;
    uint8_t p = (opcode >> 4) & 0x03;
    uint8_t *dst, *src;

    dst = get_pp(p);
    if ( q == 0 && z == 4) src=get_pp(3-p);
    else if ( q == 0 && z == 5 ) get_pp((3-p+2)%4);
    else src = get_pp((p+2)%4);

    *dst = *src;

    st += 2;
}
// ld  ([ix|iy|sp]+d), [XIX|YIY|ahl]
void kc160_ld_ixysd_r24(uint8_t opcode)
{
    int sr = (opcode >> 4 ) & 0x03;
    uint8_t **src = get_r24_from_reg(sr);
    uint16_t addr = get_addr_from_z(opcode & 0x0f) +  (get_memory_inst(pc++)^128)-128;

    put_memory(addr, *src[0]);
    put_memory(addr+1, *src[1]);
    put_memory(addr+2, *src[2]);

    st += 6;
}

// ld  [XIX|YIY|ahl],([ix|iy|sp]+d)
void kc160_ld_r24_ixysd(uint8_t opcode)
{
    int r = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_r24_from_reg(r);
    uint16_t addr = get_addr_from_z(opcode & 0x0f) +  (get_memory_inst(pc++)^128)-128;

    *dest[0] = get_memory_data(addr);
    *dest[1] = get_memory_data(addr+1);
    *dest[2] = get_memory_data(addr+2);

    st += 6;
}

void kc160_ld_r24_lmn(uint8_t opcode)
{
    int r = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_r24_from_reg(r);

    *dest[0] = get_memory_inst(pc++);
    *dest[1] = get_memory_inst(pc++);
    *dest[2] = get_memory_inst(pc++);

    st += 4;
}


void kc160_ldf_ilmn_r24(uint8_t opcode)
{
    int r = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_r24_from_reg((r));
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);

    put_memory_physical(addr, *dest[0]);
    put_memory_physical(addr+1, *dest[1]);
    put_memory_physical(addr+2, *dest[2]);

    st += 7;
}

void kc160_ldf_r24_ilmn(uint8_t opcode)
{
    int r = (opcode >> 4 ) & 0x03;
    uint8_t **dest = get_r24_from_reg(r);
    uint32_t addr = get_memory_inst(pc) | ( get_memory_inst(pc+1) << 8 ) | ( get_memory_inst(pc+2) << 16);

    *dest[0] = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dest[1] = get_memory(addr+1, MEM_TYPE_PHYSICAL);
    *dest[2] = get_memory(addr+2, MEM_TYPE_PHYSICAL);

    st += 7;
}

// H = remainder, L = result
void kc160_div_hl_a(uint8_t opcode)
{
    l = ((h<<8)|l) / a;
    h = ((h<<8)|l) % a;

    st += 12;
}

void kc160_divs_hl_a(uint8_t opcode)
{
    l = ((int16_t)((h<<8)|l)) / (int16_t)a;
    h = ((int16_t)((h<<8)|l)) % (int16_t)a;

    st += 12;
    UNIMPLEMENTED(0xed00|opcode,"divs hl,a");
}

void kc160_div_dehl_bc(uint8_t opcode)
{
    uint32_t v = (d << 24) | (e << 16) | ( h<<8) | l;
    uint32_t div = (b << 8 ) | c;
    uint16_t q, r;

    q = v / div;
    r = v % div;

    // hl = quotient, de = remainder
    h = ( q >> 8 ) & 0xff;
    l = ( q >> 0 ) & 0xff;
    d = ( r >> 8 ) & 0xff;
    e = ( r >> 0 ) & 0xff;
  
    st += 21;
}

void kc160_divs_dehl_bc(uint8_t opcode)
{
    int32_t v = (d << 24) | (e << 16) | ( h<<8) | l;
    int32_t div = ((int8_t)b << 8 ) | (int8_t)c;
    int16_t q, r;

    q = v / div;
    r = v % div;

    // hl = quotient, de = remainder
    h = ( q >> 8 ) & 0xff;
    l = ( q >> 0 ) & 0xff;
    d = ( r >> 8 ) & 0xff;
    e = ( r >> 0 ) & 0xff;
  
    st += 21;
}


void kc160_mul_hl(uint8_t opcode)
{
    uint16_t v;
    v = h * l;
    h = v >> 8;
    l = v;
    st += 11;
}

void kc160_muls_hl(uint8_t opcode)
{
    int16_t v;

    v = (int8_t)h * (int8_t)l;
    h = (v >> 8) & 0xff;
    l = (v >> 0) & 0xff;
    st += 11;
}

// DE:HL = HL • DE
void kc160_mul_de_hl(uint8_t opcode)
{
    uint32_t x = (d<<8)|e;
    uint32_t y = (h<<8)|l;
    uint32_t result = x * y;


    
    d = (result >> 24) & 0xff;
    e = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;

    st += 19;
}

void kc160_muls_de_hl(uint8_t opcode)
{
    // DE:HL = HL • DE
    int32_t x = (((int32_t)(int8_t)d) * 256) | (int8_t)e;
    int32_t y = (((int32_t)(int8_t)h) * 256) | (int8_t)l;
    int32_t result = x * y;

    d = (result >> 24) & 0xff;
    e = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;



    st += 19;
}






void kc160_tra(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"tra");
}

void kc160_im3(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ret3");
}


void kc160_call3(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"call3 lmn");
}

void kc160_ret3(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"ret3");
}


void kc160_retn3(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode,"retn3");
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
