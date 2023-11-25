// Rabbit 4k instructions
// These mostly involve the px registers

#include "ticks.h"
#include <stdio.h>

uint32_t pw,px,py,pz;
uint32_t pw_,px_,py_,pz_;


#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)


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



static uint8_t **get_r32_ptr(uint8_t isjkhl)
{
    static uint8_t  *reg32[4];
    if (isjkhl) {
        if (altd) {
            reg32[0] = &l_;
            reg32[1] = &h_;
            reg32[2] = &j_;
            reg32[3] = &k_;
        } else {
            reg32[0] = &l;
            reg32[1] = &h;
            reg32[2] = &j;
            reg32[3] = &k;
        }
    } else {
        if (altd) {
            reg32[0] = &e_;
            reg32[1] = &d_;
            reg32[2] = &c_;
            reg32[3] = &b_;
        } else {
            reg32[0] = &e;
            reg32[1] = &d;
            reg32[2] = &c;
            reg32[3] = &b;
        }
    }
    return reg32;
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

static uint8_t *get_rr_msb_ptr(int reg)
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

static uint8_t *get_rr_lsb_ptr(int reg)
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

    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);
    
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

    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);

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

    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);
    
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

    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);

    put_memory_physical(addr,*dl);
    put_memory_physical(ps8se(addr,1),*dm);

    st += 19;
}


// ld pd,ps+rr rr=iy,ix,de,hl
static void r4k_ld_pd_psrr(uint8_t opcode, uint8_t lsb, uint8_t msb)
{
    uint8_t dreg = (opcode >> 6) & 0x03;
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,msb<<8|lsb);

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
void r4k_ld_pd_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(dreg);

    if (isjkhl)
        *pd = ( j << 24 ) | (k << 16 ) | (h << 8) | (l << 0);
    else
        *pd = ( b << 24 ) | (c << 16 ) | (d << 8) | (e << 0);
    st += 4;
}


// ld (pd+hl),bcde, ld (pd+hl),jkhl
void r4k_ld_ipdhl_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps16se(pd,h<<8|l);
    uint8_t **reg32;

    altd = 0;
    reg32 = get_r32_ptr(isjkhl);

    put_memory_physical(ps8se(addr,0),*reg32[0]);
    put_memory_physical(ps8se(addr,1),*reg32[1]);
    put_memory_physical(ps8se(addr,2),*reg32[2]);
    put_memory_physical(ps8se(addr,3),*reg32[3]);

    st += 18;
}

void r4k_ld_ihl_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t addr = h<<8|l;
    uint8_t **reg32;

    altd = 0;
    reg32 = get_r32_ptr(isjkhl);

    put_memory(addr+0, *reg32[0]);
    put_memory(addr+1, *reg32[1]);
    put_memory(addr+2, *reg32[2]);
    put_memory(addr+3, *reg32[3]);
    
    st += 18;
}


// ld bcde,ps / ld jkhl,ps
void r4k_ld_r32_ps(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t  sreg = (opcode >> 4) & 0x03;
    uint32_t s = read_ps(sreg);
    uint8_t **reg32 = get_r32_ptr(isjkhl);;

    *reg32[0] = ( s >> 24 ) & 0xff;
    *reg32[1] = ( s >> 16 ) & 0xff;
    *reg32[2] = ( s >> 8  ) & 0xff;
    *reg32[3] = ( s >> 0  ) & 0xff;

    st += 4;
}


// ld bcde,(hl) ld jkhl,(hl)
void r4k_ld_r32_ihl(uint8_t opcode, uint8_t isjkhl)
{
    uint32_t addr = h<<8|l;
    uint8_t **reg32 = get_r32_ptr(isjkhl);;

    *reg32[0] = get_memory(addr + 0, MEM_TYPE_DATA);
    *reg32[1] = get_memory(addr + 1, MEM_TYPE_DATA);
    *reg32[2] = get_memory(addr + 2, MEM_TYPE_DATA);
    *reg32[3] = get_memory(addr + 3, MEM_TYPE_DATA);
    
    st += 14;
}


// ld (mn),bcde ld (mn),jkhl
void r4k_ld_imn_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t addr = get_memory_inst(pc) | (get_memory_inst(pc+1) << 8);
    uint8_t **reg32;

    pc += 2;
    altd = 0;
    reg32 = get_r32_ptr(isjkhl);

    put_memory(addr+0, *reg32[0]);
    put_memory(addr+1, *reg32[1]);
    put_memory(addr+2, *reg32[2]);
    put_memory(addr+3, *reg32[3]);
    
    st += 19;
}

// ld bcde,(mn) ld jkhl,(mn)
void r4k_ld_r32_imn(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t addr = get_memory_inst(pc) | (get_memory_inst(pc+1) << 8);
    uint8_t **reg32;

    pc += 2;
    reg32 = get_r32_ptr(isjkhl);

    *reg32[0] = get_memory(addr + 0, MEM_TYPE_DATA);
    *reg32[1] = get_memory(addr + 1, MEM_TYPE_DATA);
    *reg32[2] = get_memory(addr + 2, MEM_TYPE_DATA);
    *reg32[3] = get_memory(addr + 3, MEM_TYPE_DATA);

    st += 15;
}


// ld bcde,(ps+hl), ld jkhl,(ps+hl)
void r4k_ld_r32_ipshl(uint8_t opcode,uint8_t isjkhl)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps16se(ps,(int16_t)(h<<8|l));
    uint8_t **reg32 = get_r32_ptr(isjkhl);;

    *reg32[0]= get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
    *reg32[1]= get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
    *reg32[2]= get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
    *reg32[3]= get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);
    
    st += 15;
}

// ld bcde,(ps+hl), ld jkhl,(ps+hl)
void r4k_ld_r32_ipsd(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t ps = read_ps(reg);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint8_t **reg32 = get_r32_ptr(isjkhl);;

    *reg32[0] = get_memory(ps8se(addr,0), MEM_TYPE_PHYSICAL);
    *reg32[1] = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
    *reg32[2] = get_memory(ps8se(addr,2), MEM_TYPE_PHYSICAL);
    *reg32[3] = get_memory(ps8se(addr,3), MEM_TYPE_PHYSICAL);

    st += 15;
}

// ld bcde,(ixy+d), ld jkhl,(ixy+d)
void r4k_ld_r32_ixyd(uint8_t opcode, uint8_t lsb, uint8_t msb, uint8_t isjkhl)
{
    uint16_t  addr = (msb << 8|lsb) + (get_memory_inst(pc++)^128)-128;
    uint8_t **reg32 = get_r32_ptr(isjkhl);;

    *reg32[0] = get_memory(addr + 0, MEM_TYPE_DATA);
    *reg32[1] = get_memory(addr + 1, MEM_TYPE_DATA);
    *reg32[2] = get_memory(addr + 2, MEM_TYPE_DATA);
    *reg32[3] = get_memory(addr + 3, MEM_TYPE_DATA);
    
    st += 15;
}

// ldf bcde,(lmn) ldf jkhl,(lmn)
void r4k_ldf_r32_ilmn(uint8_t opcode, uint8_t isjkhl)
{
    uint32_t addr;
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    *reg32[0] = get_memory(ps16se(addr,0), MEM_TYPE_PHYSICAL);
    *reg32[1] = get_memory(ps16se(addr,1), MEM_TYPE_PHYSICAL);
    *reg32[2] = get_memory(ps16se(addr,2), MEM_TYPE_PHYSICAL);
    *reg32[3] = get_memory(ps16se(addr,3), MEM_TYPE_PHYSICAL);

    st+=19;
}

// ldf (lmn),bcde ldf (lmn),jkhl
void r4k_ldf_ilmn_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint32_t addr;
    uint8_t **reg32;
    
    altd = 0;
    reg32 = get_r32_ptr(isjkhl);
    
    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    put_memory_physical(ps16se(addr, 0), *reg32[0]);
    put_memory_physical(ps16se(addr, 1), *reg32[1]);
    put_memory_physical(ps16se(addr, 2), *reg32[2]);
    put_memory_physical(ps16se(addr, 3), *reg32[3]);
    
    st += 23;
}


// ld bcde,(sp+n) ld jkhl,(sp+n)
void r4k_ld_r32_ispn(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t  s = (sp + get_memory_inst(pc++));
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    *reg32[0] = get_memory(s+0, MEM_TYPE_STACK);
    *reg32[1] = get_memory(s+1, MEM_TYPE_STACK);
    *reg32[2] = get_memory(s+2, MEM_TYPE_STACK);
    *reg32[3] = get_memory(s+3, MEM_TYPE_STACK);

    st+=15;
}

// ld (sp+n),bcde ld (sp+n),jkhl
void r4k_ld_ispn_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t  s = (sp + get_memory_inst(pc++));
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    put_memory(sp + 0, *reg32[0]);
    put_memory(sp + 1, *reg32[1]);
    put_memory(sp + 2, *reg32[2]);
    put_memory(sp + 3, *reg32[3]);

    st+=19;
}

// ld bcde,(sp+hl) ld jkhl,(sp+hl)
void r4k_ld_r32_isphl(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t  s = sp + (h<<8|l);
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    *reg32[0] = get_memory(s+0, MEM_TYPE_STACK);
    *reg32[1] = get_memory(s+1, MEM_TYPE_STACK);
    *reg32[2] = get_memory(s+2, MEM_TYPE_STACK);
    *reg32[3] = get_memory(s+3, MEM_TYPE_STACK);

    st+=14;
}

// ld (sp+hl),bcde ld (sp+hl),jkhl
void r4k_ld_isphl_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint16_t  s = sp + (h<<8|l);
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    put_memory(sp + 0, *reg32[0]);
    put_memory(sp + 1, *reg32[1]);
    put_memory(sp + 2, *reg32[2]);
    put_memory(sp + 3, *reg32[3]);

    st+=18;
}





// ld (ixy+d),bcde, ld (ixy+d),jkhl
void r4k_ld_ixyd_r32(uint8_t opcode, uint8_t lsb, uint8_t msb, uint8_t isjkhl)
{
    uint16_t  addr = (msb << 8|lsb) + (get_memory_inst(pc++)^128)-128;
    uint8_t  **reg32;

    altd = 0;
    reg32 = get_r32_ptr(isjkhl);

    put_memory(addr + 0, *reg32[0]);
    put_memory(addr + 1, *reg32[1]);
    put_memory(addr + 2, *reg32[2]);
    put_memory(addr + 3, *reg32[3]);

    st += 19;
}






// ld (pd+d),jkhl, ld (pd+d),bcde
void r4k_ld_ipdd_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t reg = (opcode >> 4) & 0x03;
    uint32_t pd = read_ps(reg);
    uint32_t addr = ps8se(pd,get_memory_inst(pc++));
    uint8_t **reg32;

    altd = 0;
    reg32 = get_r32_ptr(isjkhl);
    put_memory_physical(ps8se(addr,0),*reg32[0]);
    put_memory_physical(ps8se(addr,1),*reg32[1]);
    put_memory_physical(ps8se(addr,2),*reg32[2]);
    put_memory_physical(ps8se(addr,3),*reg32[3]);

    st += 18;
}

void r4k_ld_r32_d(uint8_t opcode, uint8_t isjkhl)
{
    uint32_t v = (int8_t)get_memory_inst(pc++);
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    *reg32[0] = ( v >> 0 ) & 0xff;
    *reg32[1] = ( v >> 8 ) & 0xff;
    *reg32[2] = ( v >> 16) & 0xff;
    *reg32[3] = ( v >> 24) & 0xff;

    st += 4;
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
void r4k_push_r32(uint8_t opcode, uint8_t isjkhl)
{
    if ( isjkhl ) {
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
void r4k_pop_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t  reg = (opcode >> 4) & 0x03;
    uint32_t *pd = write_pd(reg);
    uint8_t **reg32 = get_r32_ptr(isjkhl);

    *reg32[0] = get_memory(sp + 0, MEM_TYPE_STACK);
    *reg32[1] = get_memory(sp + 1, MEM_TYPE_STACK);
    *reg32[2] = get_memory(sp + 2, MEM_TYPE_STACK);
    *reg32[3] = get_memory(sp + 3, MEM_TYPE_STACK);

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


// ldf hl,(lmn)
void r4k_ldf_hl_ilmn(uint8_t opcode)
{
    uint32_t addr;

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    if ( altd ) {
        l_ = get_memory(addr, MEM_TYPE_PHYSICAL);
        h_ = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
    } else {
        l = get_memory(addr, MEM_TYPE_PHYSICAL);
        h = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
    }

    st+=13;
}


// ldf (lmn),hl
void r4k_ldf_ilmn_hl(uint8_t opcode)
{
    uint32_t addr;

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    put_memory_physical(addr, l);
    put_memory_physical(addr, h);
    
    st+=15;
}


// ldf rr,(lmn) rr=bc,de,ix,iy
void r4k_ldf_rr_ilmn(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t addr;
    uint8_t *dm, *dl;

    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);

    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    *dl = get_memory(addr, MEM_TYPE_PHYSICAL);
    *dm = get_memory(ps8se(addr,1), MEM_TYPE_PHYSICAL);
    st+=15;
}

// ldf (lmn),rr, rr=bc,de,ix,iy
void r4k_ldf_ilmn_rr(uint8_t opcode)
{
    uint8_t dreg = (opcode >> 4) & 0x03;
    uint32_t addr;
    uint8_t *dm, *dl;

    altd = 0;
    dm = get_rr_msb_ptr(dreg);
    dl = get_rr_lsb_ptr(dreg);


    addr = (get_memory(pc + 0, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 1, MEM_TYPE_INST) << 0 ) |
           (get_memory(pc + 2, MEM_TYPE_INST) << 16 );
    pc += 3;

    put_memory_physical(addr, *dl);
    put_memory_physical(addr, *dm);
    
    st+=17;
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


void r4k_push_mn(uint8_t opcode)
{
    uint8_t v, v2;

    v = get_memory_inst(pc++);
    v2 = get_memory_inst(pc++);
    put_memory(--sp, v2);      
    put_memory(--sp, v);      

    st += 15;
}

void r4k_ex_jkhl_bcde(uint8_t opcode)
{
    uint8_t t;

    t = e;
    e = l;
    l = t;
    t = d;
    e = h;
    h = t;

    t = c;
    c = k;
    k = t;
    t = b;
    b = j;
    j = t;

    st += 2;
}

// ld hl,(sp+hl)
void r4k_ld_hl_isphl(uint8_t opcode)
{
    int     offset = sp;
    ioi=ioe=0;
    if ( altd ) {
        offset += (h_ *256) + l_;
        l_ = get_memory_data(offset++);
        h_ = get_memory_data(offset);
    } else {
        offset += (h *256) + l;
        l_ = get_memory_data(offset++);
        h_ = get_memory_data(offset);
    }
    st += 4;
}

void r4k_ex_jk1_hl(uint8_t opcode)
{
    uint8_t t;
    if (altd) {
        t = j_;
        j_ = h_;
        h_ = t;
        t = k_;
        k_ = l_;
        l_ = t;
    } else {
        t = j_;
        j_ = h;
        h = t;
        t = k_;
        k_ = l;
        l = t;
    }
    st += 4;
}

void r4k_ex_jk_hl(uint8_t opcode)
{
    uint8_t t;
    if (altd) {
        t = j;
        j = h_;
        h_ = t;
        t = k;
        k = l_;
        l_ = t;
    } else {
        t = j;
        j = h;
        h = t;
        t = k;
        k = l;
        l = t;
    }
    st += 2;
}

void r4k_ex_bc_hl(uint8_t opcode)
{
    uint8_t t;
    if ( altd ) { // EX BC,HL'
        t = b;
        b = h_;
        h_ = t;
        t = c;
        c = l_;
        l_ = t;
    } else {
        t = b;
        b = h;
        h = t;
        t = c;
        c = l;
        l = t;
    }
    st += 2;
}

void r4k_mulu(uint8_t opcode)
{
    // HL:BC = BC • DE
    uint32_t result = (( d * 256 ) + e) * (( b * 256 ) + c);
    h = (result >> 24) & 0xff;
    l = (result >> 16) & 0xff;
    b  = (result >> 8 ) & 0xff;
    c = result & 0xff;
    st += 10;
}

void r4k_callxy(uint8_t opcode, uint8_t iy)
{
    st += 8;
    put_memory(--sp, pc >> 8);
    put_memory(--sp, pc);
    if (iy) mp = pc = (yh<<8)|yl;
    else mp = pc = (xh<<8)|xl;
}

void r4k_flag_cc_hl(uint8_t opcode, uint8_t set)
{
    h = l = 0;
    if (set) l = 1;
    st += 4;
}

void r4k_neg_hl(uint8_t opcode)
{
     UNIMPLEMENTED(opcode, "neg hl");
}

void r4k_xor_hl_de(uint8_t opcode)
{
     UNIMPLEMENTED(opcode, "xor hl,de");
}

void r4k_test_hlxy(uint8_t opcode, uint8_t prefix)
{
    switch (prefix) {
    case 0x00:
        UNIMPLEMENTED(opcode, "test hl");
        break;
    case 0xdd:
        UNIMPLEMENTED(0xdd00|opcode, "test ix");
        break;
    case 0xfd:
        UNIMPLEMENTED(0xfd00|opcode, "test iy");
        break;
    }
}

void r4k_test_r32(uint8_t opcode, uint8_t isjkhl)
{
    if (isjkhl) UNIMPLEMENTED( 0xfd00 | opcode, "test jkhl");
    else UNIMPLEMENTED( 0xdd00 | opcode, "test bcde");
}

void r4k_neg_r32(uint8_t opcode, uint8_t isjkhl)
{
    if (isjkhl) UNIMPLEMENTED( 0xfd00 | opcode, "neg jkhl");
    else UNIMPLEMENTED( 0xdd00 | opcode, "neg bcde");
}

void r4k_rlb_a_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rlb a,r32");
}

void r4k_rrb_a_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rrb a,r32");
}


void r4k_rlc_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rlc n,r32");
}

void r4k_rrc_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rrc n,r32");
}

void r4k_rl_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rl n,r32");
}

void r4k_rr_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rr n,r32");
}

void r4k_sla_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "sla n,r32");
}

void r4k_sra_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "sra n,r32");
}

void r4k_sll_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "sll n,r32");
}

void r4k_srl_r32(uint8_t opcode, uint8_t isjkhl)
{
    UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "srl n,r32");
}

void r4k_jre(uint8_t opcode, uint8_t dojump)
{
    if (opcode == 0x98) {
        UNIMPLEMENTED( opcode, "jre dddd");
    } else {
        UNIMPLEMENTED( 0xed00 | opcode, "jre cc/cx,dddd");
    }
}


void r4k_lljp(uint8_t opcode, uint8_t dojump)
{
    if (opcode == 0x87) {
        UNIMPLEMENTED( opcode, "lljp lxpc,mn");
    } else {
        UNIMPLEMENTED( 0xed00 | opcode, "lljp cc/cx,lxpc,mn");
    }
    st += 14;
}

void r4k_llcall(uint8_t opcode)
{
    UNIMPLEMENTED( opcode, "llcall lxpc,mn");
    st += 24;
}

void r4k_llcall_jkhl(uint8_t opcode)
{
    UNIMPLEMENTED( opcode, "llcall (jkhl)");
    st += 19;
}

void r4k_cbm(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "cbm n");
    st += 15;
}

void r4k_sbox_a(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "sbox a");
    st += 4;
}

void r4k_ibox_a(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "ibox a");
    st += 4;
}

void r4k_convc(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "convc pp");
}

void r4k_convd(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "convd pp");
}

void r4k_ld_a_htr(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "ld a,htr");
}

void r4k_ld_htr_a(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "ld htr,a");
}

void r4k_cp_hl_d(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "cp hl,d");
    st += 4;
}
void r4k_cp_hl_de(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "cp hl,de");
    st += 4;
}
void r4k_cp_jkhl_bcde(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "cp jkhl,bcde");
    st += 4;
}

void r4k_alu_jkhl_bcde(uint8_t opcode)
{
    int op = (opcode >> 3) & 0x07;
    char *types[] = { "add", "!!", "sub", "!!", "and", "xor", "or", "!!" };
    char  buf[100];

    snprintf(buf, sizeof(buf),"%s jkhl,bcde", types[op]);

    UNIMPLEMENTED( 0xed00|opcode, buf);
    st += 4;
}


void r4k_ld_pd_ihtrhl(uint8_t opcode)
{
    altd=0;
    UNIMPLEMENTED( 0xed00|opcode, "ld pd,(htr+hl)");
    st += 14;
}


void r4k_copy(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "copy");
}

void r4k_copyr(uint8_t opcode)
{
    UNIMPLEMENTED( 0xed00|opcode, "copyr");
}

void r4k_ld_hl_lxpc(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld hl,lxpc");
    st += 2;
}

void r4k_ld_lxpc_hl(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld lxpc,hl");
    st += 2;
}

void r4k_setusrp_mn(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "setusrp mn");
    st += 15;
}

void r4k_fsyscall(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "fsyscall/scall");
    st += 15;
}

void r4k_syscall(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "syscall");
    st += 10;
}

void r4k_sysret(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "sysret");
    st += 10;
}

void r4k_llret(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "llret");
    st += 14;
}

void r4k_setsysp_mn(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "setsysp mn");
    st += 12;
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
        r4k_ld_pd_psrr(opc, xl, xh);
        break;
    case 0x05:
        r4k_ld_pd_psrr(opc, yl, yh);
        break;
    case 0x06:
        r4k_ld_pd_psrr(opc, e, d);
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
        r4k_ld_pd_psrr(opc, l, h);
        break;
    }
}
