// Rabbit 4k instructions
// These mostly involve the px registers

#include "ticks.h"

uint32_t pw,px,py,pz;
uint32_t pw_,px_,py_,pz_;


static uint32_t read_ps(uint8_t reg)
{
    switch (reg) {
    case 0:
        return pw;
    case 1:
        return px;
    case 2:
        return py;
    case 3:
        return pz;
    }
    return 0;
}

static uint32_t *write_pd(uint8_t reg)
{
    uint32_t *r, *r_;
    switch (reg) {
    case 0:
        r = &pw; r_ = &pw_;
        break;
    case 1:
        r = &px; r_ = &px_;
        break;
    case 2:
        r = &py; r_ = &py_;
        break;
    case 3:
        r = &pz; r_ = &pz_;
        break;   
    }
    if ( altd ) return r_;
    return r;
}

static uint32_t ps16se(uint32_t ps, uint16_t offs)
{
    int islogical = ( ps & 0xffff0000 ) == 0xffff0000;
    int32_t offset = (int16_t)offs;
    ps += offset;
    if (islogical) px |= 0xffff0000;
    return ps;
}

static uint32_t ps8se(uint32_t ps, uint8_t offs)
{
    int islogical = ( ps & 0xffff0000 ) == 0xffff0000;
    int32_t offset = (int8_t)offs;
    ps += offset;
    if (islogical) px |= 0xffff0000;
    return ps;
}

static uint8_t *get_6d_dest_msb(int reg)
{
    uint8_t *r, *r_;

    switch (reg) {
    case 0:
        r = &b; r_ = &b_;
        break;
    case 1:
        r = &d; r_ = &d_;
        break;
    case 2:
        r = &xh; r_ = &xh;
        break;
    case 3:
        r = &yh; r_ = &yh;
        break;
    }
    if ( altd ) return r_;
    return r;
}

static uint8_t *get_6d_dest_lsb(int reg)
{
    uint8_t *r, *r_;

    switch (reg) {
    case 0:
        r = &c; r_ = &c_;
        break;
    case 1:
        r = &e; r_ = &e_;
        break;
    case 2:
        r = &xl; r_ = &xl;
        break;
    case 3:
        r = &yl; r_ = &yl;
        break;
    }
    if ( altd ) return r_;
    return r;
}

// exp
void r4k_exp(uint8_t opcode)
{
    uint32_t t;

    t = pw; pw = pw_; pw_ = t;
    t = px; px = px_; px_ = t;
    t = py; py = py_; py_ = t;
    t = pz; pz = pz_; pz_ = t;

    st += 4;
}

// ld a,(ps+hl)
void r4k_ld_a_ipshl(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,(int16_t)(h<<8|l));
    uint8_t *da;

    if (altd) {
        da = &a_;
    } else {
        da = &a;
    }

    *da = get_memory(addr, MEM_TYPE_PHYSICAL);
    st += 6;    
}

// ld (pd+hl),a
void r4k_ld_ipdhl_a(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,(int16_t)(h<<8|l));

    put_memory_physical(addr,a);

    st += 6;
}

// ld a,(ps+d)
void r4k_ld_a_ipsd(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint8_t *da;

    if (altd) {
        da = &a_;
    } else {
        da = &a;
    }

    *da = get_memory(addr, MEM_TYPE_PHYSICAL);
    st += 7;    
}

// ld (pd+d),a
void r4k_ld_ipdd_a(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));

    put_memory_physical(addr,a);
    st += 7;
}

// ld hl,(ps+d)
void r4k_ld_hl_ipsd(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint8_t *dl, *dh;

    if (altd) {
        dh = &h_; dl = &l_;
    } else {
        dh = &h; dl = &l;
    }

    *dl = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dh = get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL);
    st += 11;    
}

// ld (ps+d),hl
void r4k_ld_ipdd_hl(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));

    put_memory_physical(addr,l);
    put_memory_physical(ps8se(addr,1),h);    

    st += 11;
}



// ld rr,(ps+d)
static void r4k_ld_rr_ipsd(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t psreg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(psreg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint8_t *dm, *dl;

    dm = get_6d_dest_msb(dreg);
    dl = get_6d_dest_lsb(dreg);
    
    *dl = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dm = get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL);
    st += 19;    
}

// ld (ps+d),rr
static void r4k_ld_ipdd_rr(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));
    uint8_t *dm, *dl;

    altd = 0;

    dm = get_6d_dest_msb(dreg);
    dl = get_6d_dest_lsb(dreg);

    put_memory_physical(addr,*dl);
    put_memory_physical(ps8se(addr,1),*dm);

    st += 19;
}


// ld rr,(ps+hl)
static void r4k_ld_rr_ipshl(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t psreg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(psreg);
    uint32_t addr = ps16se(ps,h<<8|l);
    uint8_t *dm, *dl;

    dm = get_6d_dest_msb(dreg);
    dl = get_6d_dest_lsb(dreg);
    
    *dl = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dm = get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL);
    st += 19;    
}

// ld (pd+hl),rr
static void r4k_ld_ipdhl_rr(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps16se(pd,h<<8|l);
    uint8_t *dm, *dl;

    altd = 0;

    dm = get_6d_dest_msb(dreg);
    dl = get_6d_dest_lsb(dreg);

    put_memory_physical(addr,*dl);
    put_memory_physical(ps8se(addr,1),*dm);

    st += 19;
}


// ld pd,ps+ix
static void r4k_ld_pd_psix(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,xh<<8|xl);

    *pd = addr;

    st += 4;
}

// ld pd,ps+iy
static void r4k_ld_pd_psiy(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,yh<<8|yl);

    *pd = addr;

    st += 4;
}

// ld pd,ps+de
static void r4k_ld_pd_psde(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,d<<8|e);

    *pd = addr;

    st += 4;
}

// ld pd,ps+hl
static void r4k_ld_pd_pshl(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,h<<8|l);

    *pd = addr;

    st += 4;
}


// ld pd,ps
static void r4k_ld_pd_ps(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);

    *pd = ps;

    st += 4;
}



// ld pd,(ps+d)
static void r4k_ld_pd_ipsd(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));

    *pd = (get_memory(ps8se(addr, 3), MEM_TYPE_PHYSICAL) << 24) |
          (get_memory(ps8se(addr, 2), MEM_TYPE_PHYSICAL) << 16) |
          (get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL) << 8) |
          (get_memory(ps8se(addr, 0), MEM_TYPE_PHYSICAL) << 0);


    st += 15;
}

// ld (pd+d),ps
static void r4k_ld_ipdd_ps(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(*pd,get_memory_inst(pc++));

    put_memory_physical(addr, ps & 0xff);
    put_memory_physical(ps8se(addr,1),(ps >> 8) & 0xff);
    put_memory_physical(ps8se(addr,2),(ps >> 16) & 0xff);
    put_memory_physical(ps8se(addr,3),(ps >> 24) & 0xff);

    st += 15;
}

static void r4k_ld_pd_ipsrr(uint8_t opcode, uint8_t lsb, uint8_t msb)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,msb<<8|lsb);
    
    *pd = (get_memory(ps8se(addr, 3), MEM_TYPE_PHYSICAL) << 24) |
          (get_memory(ps8se(addr, 2), MEM_TYPE_PHYSICAL) << 16) |
          (get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL) << 8) |
          (get_memory(ps8se(addr, 0), MEM_TYPE_PHYSICAL) << 0);


    st += 15;
}

// ld pd,(ps+hl)
static void r4k_ld_pd_ipshl(uint8_t opcode)
{
    r4k_ld_pd_ipsrr(opcode, l, h);
}

// ld pd,(ps+bc)
static void r4k_ld_pd_ipsbc(uint8_t opcode)
{
    r4k_ld_pd_ipsrr(opcode, c, b);
}


// ld (pd+d),rr
static void r4k_ld_ipdrr(uint8_t opcode, uint8_t lsb, uint8_t msb)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd;
    uint32_t ps = read_ps(reg);
    uint32_t addr;

    altd = 0;
    pd = write_pd(dreg);
    addr = ps16se(*pd,msb<<8|lsb);

    put_memory_physical(addr, ps & 0xff);
    put_memory_physical(ps8se(addr,1),(ps >> 8) & 0xff);
    put_memory_physical(ps8se(addr,2),(ps >> 16) & 0xff);
    put_memory_physical(ps8se(addr,3),(ps >> 24) & 0xff);

    st += 15;
}

// ld (pd+hl),ps
static void r4k_ld_ipdhl_ps(uint8_t opcode)
{
    r4k_ld_ipdrr(opcode, l, h);
}

// ld (pd+bc),ps
static void r4k_ld_ipdbc_ps(uint8_t opcode)
{
    r4k_ld_ipdrr(opcode, c, b);
}



// ld pd,ps+d
static void r4k_ld_pd_psd(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));

    *pd = addr;

    st += 6;
}

// ld pd,(sp+n)
void r4k_ld_pd_ispn(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint16_t  s = (sp + get_memory_inst(pc++));

    *pd = (get_memory(s+3, MEM_TYPE_STACK) << 24) |
          (get_memory(s+2, MEM_TYPE_STACK) << 16) |
          (get_memory(s+1, MEM_TYPE_STACK) << 8) |
          (get_memory(s+0, MEM_TYPE_STACK) << 0);

    st+=15;
}


// ld (sp+n),ps
void r4k_ld_ispn_ps(uint8_t opcode)
{
    uint8_t  sreg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(sreg);
    uint16_t  d = (sp + get_memory_inst(pc++));

    put_memory(d, (ps >> 0) & 0xff);
    put_memory(d+1, (ps >> 8) & 0xff);
    put_memory(d+2, (ps >> 16) & 0xff);
    put_memory(d+3, (ps >> 24) & 0xff);

    st += 19;
}

// ld pd,klmn
void r4k_ld_pd_klmn(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);

    *pd = (get_memory_inst(pc+0) << 0) |
          (get_memory_inst(pc+1) << 16) |
          (get_memory_inst(pc+2) << 24) |
          (get_memory_inst(pc+3) << 24);
    pc += 4;

    st += 12;
}

// ldl pd,mn
void r4k_ldl_pd_mn(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);

    *pd = (get_memory_inst(pc+0) << 0) |
          (get_memory_inst(pc+1) << 8) |
          0xffff0000;
    pc += 2;
          
    st += 8;
}

// ldl pd,(sp+n)
void r4k_ldl_pd_ispn(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint16_t  s = (sp + get_memory_inst(pc++));

    *pd = (get_memory(s+0, MEM_TYPE_STACK) << 0) |
          (get_memory(s+1, MEM_TYPE_STACK) << 8) |
          0xffff0000;

    st+=11;
}

// Used for de,hl,ix,iy
void r4k_ldl_pd_rr(uint8_t opcode, uint8_t lsb, uint8_t msb)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);

    *pd = (lsb << 0) |
          (msb << 8) |
          0xffff0000;

    st+=2;
}
// ld pd,jkhl / ld pd,bcde
void r4k_ld_pd_r32(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);

    if (iyprefix)
        *pd = ( j << 24 ) | (k << 16 ) | (h << 8) | (l << 0);
    else
        *pd = ( b << 24 ) | (c << 16 ) | (d << 8) | (e << 0);
    st += 4;
}


// ld (pd+hl),bcde, ld (pd+hl),jkhl
void r4k_ld_ipdhl_r32(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps16se(pd,h<<8|l);

    if (iyprefix) {
        put_memory_physical(addr,l);
        put_memory_physical(ps8se(addr,1),h);
        put_memory_physical(ps8se(addr,2),k);
        put_memory_physical(ps8se(addr,3),j);
    } else {
        put_memory_physical(addr,e);
        put_memory_physical(ps8se(addr,1),d);
        put_memory_physical(ps8se(addr,2),c);
        put_memory_physical(ps8se(addr,3),b);
    }
    st += 18;
}

void r4k_ld_ihl_r32(uint8_t opcode, uint8_t iyprefix)
{
    uint16_t addr = h<<8|l;

    if (iyprefix) {
        put_memory(addr+0, l);
        put_memory(addr+1, h);
        put_memory(addr+2, k);
        put_memory(addr+3, j);
    } else {
        put_memory(addr+0, e);
        put_memory(addr+1, d);
        put_memory(addr+2, c);
        put_memory(addr+3, b);
    }

    st += 18;
}


// ld bcde,ps / ld jkhl,ps
void r4k_ld_r32_ps(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t  sreg = (opcode >> 4) & 0x03;
    uint32_t s = read_ps(sreg);

    if (iyprefix) {
        if (altd) {
            j_ = ( s >> 24 ) & 0xff;
            k_ = ( s >> 16 ) & 0xff;
            h_ = ( s >> 8  ) & 0xff;
            l_ = ( s >> 0  ) & 0xff;
        } else {
            j = ( s >> 24 ) & 0xff;
            k = ( s >> 16 ) & 0xff;
            h = ( s >> 8  ) & 0xff;
            l = ( s >> 0  ) & 0xff;
        }
    } else {
        if (altd) {
            b_ = ( s >> 24 ) & 0xff;
            c_ = ( s >> 16 ) & 0xff;
            d_ = ( s >> 8  ) & 0xff;
            e_ = ( s >> 0  ) & 0xff;
        } else {
            b = ( s >> 24 ) & 0xff;
            c = ( s >> 16 ) & 0xff;
            d = ( s >> 8  ) & 0xff;
            e = ( s >> 0  ) & 0xff;
        }
    }
    st += 4;
}


// ld bcde,(hl) ld jkhl,(hl)
void r4k_ld_r32_ihl(uint8_t opcode, uint8_t iyprefix)
{
    uint32_t addr = h<<8|l;

    if (iyprefix) {
        if (altd) {
            l_ = get_memory(addr + 0, MEM_TYPE_DATA);
            h_ = get_memory(addr + 1, MEM_TYPE_DATA);
            k_ = get_memory(addr + 2, MEM_TYPE_DATA);
            j_ = get_memory(addr + 3, MEM_TYPE_DATA);
        } else {
            l = get_memory(addr + 0, MEM_TYPE_DATA);
            h = get_memory(addr + 1, MEM_TYPE_DATA);
            k = get_memory(addr + 2, MEM_TYPE_DATA);
            j = get_memory(addr + 3, MEM_TYPE_DATA);
        }
    } else {
        if (altd) {
            e_ = get_memory(addr + 0, MEM_TYPE_DATA);
            d_ = get_memory(addr + 1, MEM_TYPE_DATA);
            c_ = get_memory(addr + 2, MEM_TYPE_DATA);
            b_ = get_memory(addr + 3, MEM_TYPE_DATA);
        } else {
            e = get_memory(addr + 0, MEM_TYPE_DATA);
            d = get_memory(addr + 1, MEM_TYPE_DATA);
            c = get_memory(addr + 2, MEM_TYPE_DATA);
            b = get_memory(addr + 3, MEM_TYPE_DATA);
        }
    }
    st += 14;
}

// ld bcde,(ps+hl), ld jkhl,(ps+hl)
void r4k_ld_r32_ipshl(uint8_t opcode,uint8_t iyprefix)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,(int16_t)(h<<8|l));

    if (iyprefix) {
        if (altd) {
            l_ = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            h_ = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            k_ = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            j_ = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        } else {
            l = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            h = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            k = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            j = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        }
    } else {
        if (altd) {
            e_ = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            d_ = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            c_ = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            b_ = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        } else {
            e = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            d = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            c = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            b = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        }
    }
    st += 15;
}

// ld bcde,(ps+hl), ld jkhl,(ps+hl)
void r4k_ld_r32_ipsd(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    
    if (iyprefix) {
        if (altd) {
            l_ = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            h_ = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            k_ = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            j_ = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        } else {
            l = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            h = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            k = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            j = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        }
    } else {
        if (altd) {
            e_ = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            d_ = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            c_ = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            b_ = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        } else {
            e = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
            d = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
            c = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
            b = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
        }
    }
    st += 15;
}


// ld (pd+d),bcde
void r4k_ld_ipdd_bcde(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));

    put_memory_physical(ps8se(addr,0),c);
    put_memory_physical(ps8se(addr,1),b);
    put_memory_physical(ps8se(addr,2),e);
    put_memory_physical(ps8se(addr,3),d);

    st += 18;
}


// ld (pd+d),jkhl, ld (pd+d),bcde
void r4k_ld_ipdd_r32(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));

    if (iyprefix) {
        put_memory_physical(ps8se(addr,0),l);
        put_memory_physical(ps8se(addr,1),h);
        put_memory_physical(ps8se(addr,2),k);
        put_memory_physical(ps8se(addr,3),j);
    } else {
        put_memory_physical(ps8se(addr,0),c);
        put_memory_physical(ps8se(addr,1),b);
        put_memory_physical(ps8se(addr,2),e);
        put_memory_physical(ps8se(addr,3),d);
    }

    st += 18;
}


// ld hl,(ps+bc)
void r4k_ld_hl_ipsbc(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,b<<8|c);
    uint8_t *dl, *dh;

    if (altd) {
        dh = &h_; dl = &l_;
    } else {
        dh = &h; dl = &l;
    }

    *dl = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dh = get_memory(ps8se(addr, 1), MEM_TYPE_PHYSICAL);
    st += 11;    
}

// ld (ps+bc),hl
void r4k_ld_ipdbc_hl(uint8_t opcode)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps16se(pd,b<<8|c);

    put_memory_physical(addr,l);
    put_memory_physical(ps8se(addr,1),h);    

    st += 11;
}

// ld a,(ixy+a)
void r4k_ld_a_ixya(uint8_t opcode, uint8_t lsb, uint8_t msb)
{
    uint16_t  addr = (msb << 8|lsb) + a;
    uint8_t   v = get_memory(addr, MEM_TYPE_DATA);

    if (altd) a_=v;
    else a=v;

    st += 8;
}

// push ps
void r4k_push_ps(uint8_t opcode)
{
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);

    put_memory(--sp,(ps >> 24) & 0xff);
    put_memory(--sp,(ps >> 16) & 0xff);
    put_memory(--sp,(ps >> 8 ) & 0xff);
    put_memory(--sp,(ps >> 0 ) & 0xff);
    st += 18;
}

// pop pd
void r4k_pop_pd(uint8_t opcode)
{
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(reg);

    *pd = (get_memory(sp + 0, MEM_TYPE_STACK) << 0) |
          (get_memory(sp + 1, MEM_TYPE_STACK) << 8) |
          (get_memory(sp + 2, MEM_TYPE_STACK) << 16) |
          (get_memory(sp + 3, MEM_TYPE_STACK) << 24);
    sp += 4;
    st += 13;
}


// push bcde, push jkhl
void r4k_push_r32(uint8_t opcode, uint8_t iyprefix)
{
    if ( iyprefix ) {
        put_memory(--sp,b);
        put_memory(--sp,c);
        put_memory(--sp,d);
        put_memory(--sp,e);
    } else {
        put_memory(--sp,j);
        put_memory(--sp,k);
        put_memory(--sp,h);
        put_memory(--sp,l);
    }
    st += 18;
}

// pop bcde, pop jkhl
void r4k_pop_r32(uint8_t opcode, uint8_t iyprefix)
{
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(reg);

    if (iyprefix) {
        if ( altd ) {
            l_ = get_memory(sp + 0, MEM_TYPE_STACK);
            h_ = get_memory(sp + 1, MEM_TYPE_STACK);
            k_ = get_memory(sp + 2, MEM_TYPE_STACK);
            j_ = get_memory(sp + 3, MEM_TYPE_STACK);
        } else {
            l = get_memory(sp + 0, MEM_TYPE_STACK);
            h = get_memory(sp + 1, MEM_TYPE_STACK);
            k = get_memory(sp + 2, MEM_TYPE_STACK);
            j = get_memory(sp + 3, MEM_TYPE_STACK);
        }
    } else {
        if ( altd ) {
            e_ = get_memory(sp + 0, MEM_TYPE_STACK);
            d_ = get_memory(sp + 1, MEM_TYPE_STACK);
            c_ = get_memory(sp + 2, MEM_TYPE_STACK);
            b_ = get_memory(sp + 3, MEM_TYPE_STACK);
        } else {
            e = get_memory(sp + 0, MEM_TYPE_STACK);
            d = get_memory(sp + 1, MEM_TYPE_STACK);
            c = get_memory(sp + 2, MEM_TYPE_STACK);
            b = get_memory(sp + 3, MEM_TYPE_STACK);
        }
    }
    sp += 4;
    st += 13;
}


// ldf a,(lmn)
void r4k_ldf_a_ilmn(uint8_t opcode)
{
    uint32_t addr;

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    if ( altd ) a_ = get_memory(addr, MEM_TYPE_PHYSICAL);
    else a = get_memory(addr, MEM_TYPE_PHYSICAL);

    st+=11;
}

// ldf (lmn),a
void r4k_ldf_ilmn_a(uint8_t opcode)
{
    uint32_t addr;

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    put_memory_physical(addr, a);
    
    st+=12;
}


// ldf pd,(lmn)
void r4k_ldf_pd_ilmn(uint8_t opcode)
{
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(reg);
    uint32_t addr;

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    *pd = (get_memory(addr + 0, MEM_TYPE_PHYSICAL) << 0 ) |
          (get_memory(addr + 1, MEM_TYPE_PHYSICAL) << 8 ) |
          (get_memory(addr + 2, MEM_TYPE_PHYSICAL) << 16 ) |
          (get_memory(addr + 3, MEM_TYPE_PHYSICAL) << 24);
    
    st+=19;
}

// ldf (lmn),ps
void r4k_ldf_ilmn_ps(uint8_t opcode)
{
    uint32_t addr;
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    put_memory_physical(addr + 0, (ps >> 0 ) & 0xff);
    put_memory_physical(addr + 1, (ps >> 8 ) & 0xff);
    put_memory_physical(addr + 2, (ps >> 16) & 0xff);
    put_memory_physical(addr + 3, (ps >> 24) & 0xff);
    
    st+=23;
}


void r4k_dwjnz(uint8_t opcode)
{
    uint8_t zero = 0;
    if ( altd ) {
        c_-- || (b_ > 0 && b_--);
        zero = (c_ | b_) == 0;
    } else {
        c-- || (b > 0 && b--);
        zero = (c | b) == 0;
    }
    if ( zero ) {
        pc++;
    } else {
        mp = pc += (get_memory_inst(pc) ^ 128) - 127;
    }
    st += 7;
}

void r4k_handle_6d_page(void)
{
    uint8_t opc;

    switch ( (opc = get_memory_inst(pc++) ) & 0x0f ) {
    case 0x00:
        r4k_ld_rr_ipsd(opc);
        break;
    case 0x01:
        r4k_ld_ipdd_rr(opc);
        break;
    case 0x02:
        r4k_ld_rr_ipshl(opc);
        break;
    case 0x03:
        r4k_ld_ipdhl_rr(opc);
        break;
    case 0x04:
        r4k_ld_pd_psix(opc);
        break;
    case 0x05:
        r4k_ld_pd_psiy(opc);
        break;
    case 0x06:
        r4k_ld_pd_psde(opc);
        break;
    case 0x07:
        r4k_ld_pd_ps(opc);
        break;
    case 0x08:
        r4k_ld_pd_ipsd(opc);
        break;
    case 0x09:
        r4k_ld_ipdd_ps(opc);
        break;
    case 0x0a:
        r4k_ld_pd_ipshl(opc);
        break;
    case 0x0b:
        r4k_ld_ipdhl_ps(opc);
        break;
    case 0x0c:
        r4k_ld_pd_psd(opc);
        break;
    case 0x0e:
        r4k_ld_pd_pshl(opc);
        break;
    }
}