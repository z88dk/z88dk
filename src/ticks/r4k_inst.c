// Rabbit 4k instructions
// These mostly involve the px registers

#include "ticks.h"
#include <stdio.h>

uint32_t pw,px,py,pz;
uint32_t pw_,px_,py_,pz_;


#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)

// Used for ex instructions
#define SWAPR(r1,r2) { t = (r1); (r1) = (r2); (r1) = t; }


// TODO: Flags may be wrong...
#define ALU_OP(oper, r, lhs, rhs) do { \
    uint8_t  carry = (((alts && (oper == 1 || oper == 3)) ? ff_ : ff) >> 8) & 1; \
    uint8_t zero = 0; /* Set by all ops */   \
    switch (oper) {                    \
        case 0: /* add*/               \
            r = rhs + lhs;             \
            carry = r < rhs;           \
            zero = r == 0;             \
            break;                     \
        case 1: /* adc */              \
            r = rhs + lhs + carry;     \
            carry = r < rhs;           \
            zero = r == 0;             \
            break;                     \
        case 2: /* sub */              \
            r = lhs - rhs;             \
            carry = r > lhs;           \
            zero = r == 0;             \
            break;                     \
        case 3: /* sbc */              \
            r = lhs - rhs - carry;     \
            carry = r > lhs;           \
            zero = r == 0;             \
            break;                     \
        case 4: /* and */              \
            r = rhs & lhs;             \
            zero = r == 0;             \
            carry = 0;                 \
            break;                     \
        case 5: /* xor */              \
            r = rhs ^ lhs;             \
            zero = r == 0;             \
            carry = 0;                 \
            break;                     \
        case 6: /* or */               \
            r = rhs | lhs;             \
            zero = r == 0;             \
            carry = 0;                 \
            break;                     \
        case 7: /* cp */               \
            carry = rhs > lhs;         \
            zero = (lhs == rhs);       \
            break;                     \
    }                                  \
    if ( altd  ) { fr_ = zero; ff_ = carry << 8; } \
    else { fr = zero; ff_ = carry << 8; } \
} while(0)


static uint32_t read_ps(uint8_t reg)
{
    switch (reg) {
    case 0:
        return alts ? pw_ : pw;
    case 1:
        return alts ? px_ : px;
    case 2:
        return alts ? py_ : py;
    case 3:
        return alts ? py_ : pz;
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




static uint8_t **get_r32_source_ptr(uint8_t isjkhl)
{
    static uint8_t  *reg32[4];
    if (isjkhl) {
        if (alts) {
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
        if (alts) {
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

static uint8_t **get_r32_dest_ptr(uint8_t isjkhl)
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

static uint8_t *get_rr_msb_ptr(int reg, uint8_t alt)
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
    if ( alt ) return r_;
    return r;
}

static uint8_t *get_rr_lsb_ptr(int reg, uint8_t alt)
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
    if ( alt ) return r_;
    return r;
}

static uint8_t *get_rp2_msb_ptr(int reg, uint8_t alt)
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
        r = &h; r_ = &h_;
        break;
    case 3:
        r = &j; r_ = &j_;
        break;
    }
    if ( alt ) return r_;
    return r;
}

static uint8_t *get_rp2_lsb_ptr(int reg, uint8_t alt)
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
        r = &l; r_ = &l_;
        break;
    case 3:
        r = &k; r_ = &k_;
        break;
    }
    if ( alt ) return r_;
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

    dm = get_rr_msb_ptr(dreg, altd);
    dl = get_rr_lsb_ptr(dreg, altd);
    
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

    dm = get_rr_msb_ptr(dreg, altd);
    dl = get_rr_lsb_ptr(dreg, altd);

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

    dm = get_rr_msb_ptr(dreg, altd);
    dl = get_rr_lsb_ptr(dreg, altd);
    
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

    dm = get_rr_msb_ptr(dreg, alts);
    dl = get_rr_lsb_ptr(dreg, alts);

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
    reg32 = get_r32_source_ptr(isjkhl);

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
    reg32 = get_r32_source_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);;

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);;

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
    reg32 = get_r32_source_ptr(isjkhl);

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
    reg32 = get_r32_dest_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);;

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);;

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);;

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);

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
    reg32 = get_r32_source_ptr(isjkhl);
    
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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_source_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_source_ptr(isjkhl);

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
    reg32 = get_r32_source_ptr(isjkhl);

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
    reg32 = get_r32_source_ptr(isjkhl);
    put_memory_physical(ps8se(addr,0),*reg32[0]);
    put_memory_physical(ps8se(addr,1),*reg32[1]);
    put_memory_physical(ps8se(addr,2),*reg32[2]);
    put_memory_physical(ps8se(addr,3),*reg32[3]);

    st += 18;
}

void r4k_ld_r32_d(uint8_t opcode, uint8_t isjkhl)
{
    uint32_t v = (int8_t)get_memory_inst(pc++);
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);

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
    uint8_t **reg32 = get_r32_dest_ptr(isjkhl);

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

    dm = get_rr_msb_ptr(dreg, altd);
    dl = get_rr_lsb_ptr(dreg, altd);

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
    dm = get_rr_msb_ptr(dreg, alts);
    dl = get_rr_lsb_ptr(dreg, alts);


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
    // if (!ALTD) then JKHL <-> BCDE else JKHL' <-> BCDE
    
    if ( altd ) {
        SWAPR(j_,b);
        SWAPR(k_,c);
        SWAPR(h_,d);
        SWAPR(l_,c);
    } else {
        SWAPR(j,b);
        SWAPR(k,c);
        SWAPR(h,d);
        SWAPR(l,c);
    }
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

// 0xed 0x7c
void r4k_ex_jk1_hl(uint8_t opcode) 
{
    // if (!ALTD) then JK' <-> HL else JK' <-> HL'
    uint8_t t;

    if (altd) {
        SWAPR(j_,h);
        SWAPR(k_,l);
    } else {
        SWAPR(j_,h_);
        SWAPR(k_,l_);
    }
    st += 4;
}

// 0xb9
void r4k_ex_jk_hl(uint8_t opcode)
{
    //  if (!ALTD) then JK <-> HL else JK <-> HL'
    uint8_t t;
    if (altd) {
        SWAPR(j, h_);
        SWAPR(k, l_);
    } else {
        SWAPR(j, h);
        SWAPR(k, l);
    }
    st += 2;
}

// 0xb3
void r4k_ex_bc_hl(uint8_t opcode)
{
    uint8_t t;
    //  if (!ALTD) then BC <-> HL else BC <-> HL'

    if ( altd ) {
        SWAPR(b,h_);
        SWAPR(c,l_);
    } else {
        SWAPR(b,h);
        SWAPR(c,l);
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
    uint16_t hl = *get_rp2_lsb_ptr(2, alts) | (*get_rp2_msb_ptr(2,alts) << 8);
    uint16_t r;

    ALU_OP(2, r, 0, hl);

    *get_rp2_lsb_ptr(2, altd) = r & 0xff;
    *get_rp2_msb_ptr(2, altd) = (r >> 8) & 0xff;
    
    st += 2;
}

void r4k_xor_hl_de(uint8_t opcode)
{
    uint16_t hl = *get_rp2_lsb_ptr(2, alts) | (*get_rp2_msb_ptr(2,alts) << 8);
    uint16_t de = *get_rp2_lsb_ptr(1, alts) | (*get_rp2_msb_ptr(1,alts) << 8);
    uint16_t r;

    ALU_OP(5, r, hl, de);

    *get_rp2_lsb_ptr(2, altd) = r & 0xff;
    *get_rp2_msb_ptr(2, altd) = (r >> 8) & 0xff;

    st += 4;
}

void r4k_test_hlxy(uint8_t opcode, uint8_t prefix)
{
    uint16_t val, r;

    switch (prefix) {
    case 0x00:
        val = *get_rp2_lsb_ptr(2, alts) | (*get_rp2_msb_ptr(2,alts) << 8);
        break;
    case 0xdd:
        val = xl | (xh << 8);
        break;
    case 0xfd:
        val = yl | (yh << 8);
        break;
    }
    ALU_OP(6, r, val, 0); // OR
    st += 4;
}

// test bc, (R6K) test de 
void r4k_test_rp2(uint8_t opcode, uint8_t rp2)
{
    uint16_t val, r;

    if ( opcode == 0x4c ) { // test bc
        val = *get_rp2_lsb_ptr(0, alts) | (*get_rp2_msb_ptr(0,alts) << 8);
    } else {
        val = *get_rp2_lsb_ptr(1, alts) | (*get_rp2_msb_ptr(1,alts) << 8);
    }
    ALU_OP(6, r, val, 0); // OR
    st += 4;
}

void r4k_test_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t **reg32 = get_r32_source_ptr(isjkhl);
    uint32_t r32 = (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);
    uint32_t r;

    ALU_OP(6, r, r32, 0); // OR

    st += 4;
}

void r4k_neg_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t **reg32 = get_r32_source_ptr(isjkhl);
    uint32_t r32 = (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);
    uint32_t r;
    
    ALU_OP(2, r, 0, r32);

    reg32 = get_r32_dest_ptr(isjkhl);
    *reg32[0] = (r >> 0)  & 0xff;
    *reg32[1] = (r >> 8)  & 0xff;
    *reg32[2] = (r >> 16) & 0xff;
    *reg32[3] = (r >> 24) & 0xff;

    st += 4;
}

void r4k_ld_hl_bc(uint8_t opcode)
{
    uint8_t sl = alts ? c_ : c;
    uint8_t sh = alts ? b_ : b;

    if ( altd ) {
        h_ = sh; l_ = sl;
    } else {
        h = sh; l = sl;
    }
    st+=2; 
}


void r4k_ld_hl_de(uint8_t opcode)
{
    uint8_t sl = alts ? e_ : e;
    uint8_t sh = alts ? d_ : d;

    if ( altd ) {
        h_ = sh; l_ = sl;
    } else {
        h = sh; l = sl;
    }
    st+=2; 
}

void r4k_ld_de_hl(uint8_t opcode)
{
    uint8_t sl = alts ? l_ : l;
    uint8_t sh = alts ? h_ : h;

    if ( altd ) {
        d_ = sh; e_ = sl;
    } else {
        d = sh; e = sl;
    }
    st+=2; 
}

void r4k_rlb_a_r32(uint8_t opcode, uint8_t isjkhl)
{
    // {A, BCDE} = {BCDE, A}
    uint8_t **src;
    uint8_t **dest;
    uint8_t t;

    src = get_r32_source_ptr(isjkhl);
    dest = get_r32_dest_ptr(isjkhl);

    t = alts ? a_ : a;
    if ( altd ) a_ = *src[3]; else a = *src[3];
    *dest[3] = *src[2];
    *dest[2] = *src[1];
    *dest[1] = *src[0];
    *dest[0] = t;
    
    st += 4;

}

void r4k_rrb_a_r32(uint8_t opcode, uint8_t isjkhl)
{
    // {A, BCDE} = {E, A, BCD}
    uint8_t **src;
    uint8_t **dest;
    uint8_t t;

    src = get_r32_source_ptr(isjkhl);  // [0] = lsb
    dest = get_r32_dest_ptr(isjkhl);

    t = *src[0];
    *dest[0] = *src[1];
    *dest[1] = *src[2];
    *dest[2] = *src[3];
    *dest[3] = alts ? a_ : a;
    if ( altd ) a_ = t; else a = t;
    
    st += 4;
}

void r4k_rlc_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t **src;
    uint8_t **dest;
    uint8_t t;

    src = get_r32_source_ptr(isjkhl);  // [0] = lsb
    dest = get_r32_dest_ptr(isjkhl);

    if ( opcode == 0x4f ) {
        // JKHL = {KHL, J}
        t = *src[3];
        *dest[3] = *src[2];
        *dest[2] = *src[1];
        *dest[1] = *src[0];
        *dest[0] = t;
        st += 4;
    } else {
        UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rlc n,r32");
    }
}

void r4k_rrc_r32(uint8_t opcode, uint8_t isjkhl)
{
    uint8_t **src;
    uint8_t **dest;
    uint8_t t;

    src = get_r32_source_ptr(isjkhl);  // [0] = lsb
    dest = get_r32_dest_ptr(isjkhl);

    if ( opcode == 0x5f ) {
        // BCDE = {E, BCD}
        t = *src[0];
        *dest[0] = *src[1];
        *dest[1] = *src[2];
        *dest[2] = *src[3];
        *dest[3] = t;
        st += 4;
    } else {
        UNIMPLEMENTED( (isjkhl ? 0xfd00 : 0xdd00) | opcode, "rrc n,r32");
    }
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
    uint16_t compare = (get_memory_inst(pc++)^128)-128;
    uint16_t r;
    uint16_t hl = *get_rp2_lsb_ptr(2, alts) | (*get_rp2_msb_ptr(2,alts) << 8);

    ALU_OP(7, r, hl, compare);
    
    st += 4;
}

void r4k_cp_hl_de(uint8_t opcode)
{
    uint16_t hl = *get_rp2_lsb_ptr(2, alts) | (*get_rp2_msb_ptr(2,alts) << 8);
    uint16_t de = *get_rp2_lsb_ptr(1, alts) | (*get_rp2_msb_ptr(1,alts) << 8);
    uint16_t r;

    ALU_OP(7, r, hl, de);
    st += 4;
}

void r4k_cp_jkhl_bcde(uint8_t opcode)
{
    uint32_t r;
    uint8_t **reg32;
    uint32_t jkhl;
    uint32_t bcde;

    reg32 = get_r32_source_ptr(1);
    jkhl =  (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);

    reg32 = get_r32_source_ptr(0);
    bcde =  (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);

    ALU_OP(7, r, jkhl, bcde); // CP

    st += 4;
}

// Note cp jkhl,bcde uses a different opcode and doesn't enter via here
void r4k_alu_jkhl_bcde(uint8_t opcode)
{
    int op = (opcode >> 3) & 0x07;
    uint32_t r;
    uint8_t **reg32;
    uint32_t jkhl;
    uint32_t bcde;

    reg32 = get_r32_source_ptr(1);
    jkhl =  (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);

    reg32 = get_r32_source_ptr(0);
    bcde =  (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);

    ALU_OP(op, r, jkhl, bcde);

    reg32 = get_r32_dest_ptr(1);
    *reg32[0] = (r >> 0)  & 0xff;
    *reg32[1] = (r >> 8)  & 0xff;
    *reg32[2] = (r >> 16) & 0xff;
    *reg32[3] = (r >> 24) & 0xff;
    st += 4;
}


void r4k_ld_pd_ihtrhl(uint8_t opcode)
{
    altd=0,alts=0;
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

void r6k_ibox_ps(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "ibox ps");
}

void r6k_sbox_ps(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "sbox ps");
}


void r6k_inc_ps(uint8_t opcode)
{
    uint32_t *ptr = write_pd((opcode & 0x0f) >> 4);
    *ptr = *ptr + 1;

    st += 4;
}

void r6k_dec_ps(uint8_t opcode)
{
    uint32_t *ptr = write_pd((opcode & 0x0f) >> 4);

    *ptr = *ptr - 1;
    st += 4;
}


// 0xed, 0xcf (df,ef,ff)
void r6k_swap_rp2(uint8_t opcode)
{
    uint8_t reg = ((opcode & 0xf0) >> 4) - 0x0c; // 0 =bc, 1=de, 2=hl, 3 = jk
    uint8_t *slsb = get_rp2_lsb_ptr(reg, alts);
    uint8_t *smsb = get_rp2_lsb_ptr(reg, alts);
    uint8_t *dlsb = get_rp2_lsb_ptr(reg, altd);
    uint8_t *dmsb = get_rp2_lsb_ptr(reg, altd); 
    uint8_t t;

    if ( dmsb == smsb ) {
        SWAPR(*smsb, *slsb);
    } else {
        SWAPR(*dmsb, *slsb);
        SWAPR(*dlsb, *smsb);
    }
    st += 4;
}

// mainpage 0x59
void r6k_mul_hl_de(void)
{
    // JK:HL = HL • DE
    int32_t result = (( (int32_t)(int8_t)d * 256 ) + e) * (( (int32_t)(int8_t)h * 256 ) + l);
    j = (result >> 24) & 0xff;
    k = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 12;
}

// mainpage 0x69
void r6k_mulu_hl_de(void)
{
    // JK:HL = HL • DE
    uint32_t result = (( d * 256 ) + e) * (( h * 256 ) + l);
    j = (result >> 24) & 0xff;
    k = (result >> 16) & 0xff;
    h  = (result >> 8 ) & 0xff;
    l = result & 0xff;
    st += 12;
}

// oopcode mainpage 0x44
void r6k_ex_jkhl_bcde1(void)
{
    uint8_t t;
    // if (!ALTD) then JKHL <-> BCDE' else JKHL' <-> BCDE'
    if ( altd ) {
        SWAPR(j_,b_);
        SWAPR(k_,c_);
        SWAPR(h_,d_);
        SWAPR(l_,c_);
    } else {
        SWAPR(j,b_);
        SWAPR(k,c_);
        SWAPR(h,d_);
        SWAPR(l,c_);
    }
    st +=2;
}

// swap bcde, swap bcde= 0xdd, 0x32 swap jkhl = 0xfd, 0x32
void r6k_swap_r32(uint8_t opcode, uint8_t isjkhl)
{ 
    uint8_t **dest = get_r32_dest_ptr(isjkhl);
    uint8_t **src = get_r32_source_ptr(isjkhl);
    uint8_t t;

    // B = E; C = D; D = C; E = B  
    if ( altd == 0 && alts == 0 ) {
        SWAPR(*dest[0], *src[3]);
        SWAPR(*dest[1], *src[2]);
    } else {
        SWAPR(*dest[0], *src[3]);
        SWAPR(*dest[1], *src[2]);
        SWAPR(*dest[2], *src[1]);
        SWAPR(*dest[3], *src[0]);
    }
    st += 4;
}

void r6k_add_xy_d(uint8_t opc, uint8_t iy)
{
    uint16_t t = (get_memory_inst(pc++)^128)-128;
    // TODO: altd Flags?
    uint16_t v;

    if ( iy == 0 ) {
        t += xh << 8 | xl;
        xh = (t >> 8) & 0xff;
        xl = (t >> 0) & 0xff;
    } else {
        t +=  v = yh << 8 | yl;
        yh = (t >> 8) & 0xff;
        yl = (t >> 0) & 0xff;
    }
    st += 6;
}


// alu a,(ps+d)
void r6k_alu_a_psd(uint8_t opcode)
{
    uint32_t r;
    uint32_t ps = read_ps(opcode & 0x03);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint8_t val = get_memory(addr, MEM_TYPE_PHYSICAL);
    uint8_t r8 =  alts ? a_ : a;

    ALU_OP( ((opcode >> 4) & 0x07), r, r8, val);

    if ( altd ) a_ = r; else a = r;

    st += 10;
}

// alu a,(sp+n)
void r6k_alu_a_spn(uint8_t opcode)
{
    uint8_t r;
    uint16_t addr = (sp + get_memory_inst(pc++));
    uint8_t val = get_memory(addr, MEM_TYPE_DATA);
    uint8_t r8 =  alts ? a_ : a;

    ALU_OP( ((opcode >> 4) & 0x07), r, r8, val);

    if ( altd ) a_ = r; else a = r;

    st += 10;
}

// alu hl,(ps+d)
void r6k_alu_hl_psd(uint8_t opcode)
{
    uint16_t r;
    uint32_t ps = read_ps(opcode & 0x03);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint16_t val = get_memory(addr, MEM_TYPE_PHYSICAL) | (get_memory(addr+1, MEM_TYPE_PHYSICAL) << 8);
    uint16_t r16 = (*get_rp2_msb_ptr(2,alts) << 8) | *get_rp2_lsb_ptr(2,alts);

    ALU_OP( ((opcode >> 4) & 0x07), r, r16, val);

    *get_rp2_lsb_ptr(2,altd) = r & 0xff;
    *get_rp2_msb_ptr(2,altd) = (r >> 8) & 0xff;

    st += 12;
}


// alu hl,(ixy+d)
void r6k_alu_hl_xyd(uint8_t opcode, uint8_t iy)
{
    uint8_t oper = (opcode & 1) + ((((opcode - 0x80) >> 4) & 0x0f) * 2);
    uint8_t msb = iy ? yh : yh;
    uint8_t lsb = iy ? yl : xl;
    uint16_t  addr = (msb << 8|lsb) + (get_memory_inst(pc++)^128)-128;
    uint16_t  rhs = (get_memory(addr + 1, MEM_TYPE_DATA) << 8) | get_memory(addr + 0, MEM_TYPE_DATA);
    uint16_t  lhs = (*get_rp2_msb_ptr(2,alts) << 8) | (*get_rp2_lsb_ptr(2,alts));  // get hl
    uint16_t  r;

    ALU_OP(oper, r, lhs, rhs);

    *get_rp2_msb_ptr(2,altd) = (r >> 8 ) & 0xff;
    *get_rp2_lsb_ptr(2,altd) = (r >> 0 ) & 0xff;

    st += 12;
}

// alu hl,(sp+n)
void r6k_alu_hl_spn(uint8_t opcode)
{
    uint16_t r;
    uint16_t addr = (sp + get_memory_inst(pc++));
    uint16_t val = get_memory(addr, MEM_TYPE_DATA) | (get_memory(addr+1, MEM_TYPE_DATA) << 8);
    uint16_t r16 = (*get_rp2_msb_ptr(2,alts) << 8) | *get_rp2_lsb_ptr(2,alts);

    ALU_OP( ((opcode >> 4) & 0x07), r, r16, val);

    *get_rp2_lsb_ptr(2,altd) = r & 0xff;
    *get_rp2_msb_ptr(2,altd) = (r >> 8) & 0xff;
    

    st += 12;
}



// alu jkhl,(ps+d)
void r6k_alu_jkhl_psd(uint8_t opcode)
{
    uint32_t r;
    uint32_t ps = read_ps(opcode & 0x03);
    uint32_t addr = ps8se(ps,get_memory_inst(pc++));
    uint32_t val = get_memory(addr, MEM_TYPE_PHYSICAL) | (get_memory(addr+1, MEM_TYPE_PHYSICAL) << 8) | (get_memory(addr+2, MEM_TYPE_PHYSICAL) << 16) | (get_memory(addr+3, MEM_TYPE_PHYSICAL) << 24);
    uint8_t **reg32 = get_r32_source_ptr(1);
    uint32_t r32 = (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);


    ALU_OP( ((opcode >> 4) & 0x07), r, r32, val);

    reg32 = get_r32_dest_ptr(1);
    *reg32[0] = (r >> 0)  & 0xff;
    *reg32[1] = (r >> 8)  & 0xff;
    *reg32[2] = (r >> 16) & 0xff;
    *reg32[3] = (r >> 24) & 0xff;

    st += 16;
}

// alu jkhl,ps
void r6k_alu_jkhl_ps(uint8_t opcode)
{
    uint32_t r;
    uint32_t val = read_ps(opcode & 0x03);
    uint8_t **reg32 = get_r32_source_ptr(1);
    uint32_t r32 = (*reg32[3] << 24) | (*reg32[2] << 16) | (*reg32[1] << 8) | (*reg32[0] << 0);

    ALU_OP( ((opcode >> 4) & 0x07), r, r32, val);

    reg32 = get_r32_dest_ptr(1);
    *reg32[0] = (r >> 0)  & 0xff;
    *reg32[1] = (r >> 8)  & 0xff;
    *reg32[2] = (r >> 16) & 0xff;
    *reg32[3] = (r >> 24) & 0xff;

    st += 4;
}


// alu jkhl,(ixy+d)
void r6k_alu_jkhl_xyd(uint8_t opcode, uint8_t iy)
{
    uint8_t oper = (opcode & 1) + ((((opcode - 0x80) >> 4) & 0x0f) * 2);
    uint8_t msb = iy ? yh : yh;
    uint8_t lsb = iy ? yl : xl;
    uint16_t  addr = (msb << 8|lsb) + (get_memory_inst(pc++)^128)-128;
    uint32_t  rhs = (get_memory(addr + 3, MEM_TYPE_DATA) << 24) | (get_memory(addr + 2, MEM_TYPE_DATA) << 16) | (get_memory(addr + 1, MEM_TYPE_DATA) << 8) | get_memory(addr + 0, MEM_TYPE_DATA);
    uint8_t  **r32ptr = get_r32_source_ptr(1);
    uint32_t  lhs = (*r32ptr[3] << 24) | (*r32ptr[2] << 16) | (*r32ptr[1] << 8) | *r32ptr[0];
    uint16_t  r;

    ALU_OP(oper, r, lhs, rhs);

    r32ptr = get_r32_dest_ptr(1);
    *r32ptr[0] = (r >> 0  ) & 0xff;
    *r32ptr[1] = (r >> 8  ) & 0xff;
    *r32ptr[2] = (r >> 16 ) & 0xff;
    *r32ptr[3] = (r >> 24 ) & 0xff;

    st += 16;
}

// alu jkhl,(sp+n)
void r6k_alu_jkhl_spn(uint8_t opcode)
{
    uint16_t addr = (sp + get_memory_inst(pc++));
    uint32_t  rhs = (get_memory(addr + 3, MEM_TYPE_DATA) << 24) | (get_memory(addr + 2, MEM_TYPE_DATA) << 16) | (get_memory(addr + 1, MEM_TYPE_DATA) << 8) | get_memory(addr + 0, MEM_TYPE_DATA);
    uint8_t  **r32ptr = get_r32_source_ptr(1);
    uint32_t  lhs = (*r32ptr[3] << 24) | (*r32ptr[2] << 16) | (*r32ptr[1] << 8) | *r32ptr[0];
    uint16_t  r;

    ALU_OP(((opcode >> 4) & 0x07), r, lhs, rhs);

    r32ptr = get_r32_dest_ptr(1);
    *r32ptr[0] = (r >> 0  ) & 0xff;
    *r32ptr[1] = (r >> 8  ) & 0xff;
    *r32ptr[2] = (r >> 16 ) & 0xff;
    *r32ptr[3] = (r >> 24 ) & 0xff;

    st += 16;
}





void r6k_tstnull_ps(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "tstnull ps");
    st+= 4;
}

void r6k_swap_r(uint8_t opcode)
{
    // Doc suggests that that this is a mirror?
    UNIMPLEMENTED(0xed00|opcode, "swap r");
    st += 4;
}



void r4k_handle_6d_page(void)
{
    uint8_t opc;

    // TODO: 6d = ld l,l
    // TODO: 7f = ld a,a
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
    case 0x0d:
        if ( ((opc >> 4) & 0x03) == 0x01 && israbbit6k()) r6k_inc_ps(opc);
        if ( ((opc >> 4) & 0x03) == 0x02 && israbbit6k()) r6k_sbox_ps(opc);
        break;
    case 0x0e:
        r4k_ld_pd_psrr(opc, l, h);
        break;
    case 0x0f:
        if ( ((opc >> 4) & 0x03) == 0x01 && israbbit6k()) r6k_dec_ps(opc);
        if ( ((opc >> 4) & 0x03) == 0x02 && israbbit6k()) r6k_ibox_ps(opc);
        break;
    }
}






void r6k_handle_49_page(void)
{
   uint8_t opc = get_memory_inst(pc++);

   if ( opc < 0x80 ) {
        switch ( opc & 0x0f ) {
        case 0x0f:  // alu jkhl,(pz+d)
        case 0x0e:  // alu jkhl,(py+d)
        case 0x0d:  // alu jkhl,(px+d)
        case 0x0c:  // alu jkhl,(pw+d) 
            r6k_alu_jkhl_psd(opc);
            break;
        case 0x0b:  // alu hl,(pz+d)
        case 0x0a:  // alu hl,(py+d)
        case 0x09:  // alu hl,(px+d)
        case 0x08:  // alu hl,(pw+d) 
            r6k_alu_hl_psd(opc);
            break;
        case 0x07:  // alu a,(pz+d)
        case 0x06:  // alu a,(py+d)
        case 0x05:  // alu a,(px+d)
        case 0x04:  // alu a,(pw+d) 
            r6k_alu_a_psd(opc);
            break;
        case 0x03:  // alu jkhl,pz
        case 0x02:  // alu jkhl,py
        case 0x01:  // alu jkhl,px
        case 0x00:  // alu jkhl,pw
            r6k_alu_jkhl_ps(opc);
            break;
        }
   } else if ( (opc & 0x0f) >= 0x09 ) {
        switch ( opc & 0x0f ) {
        case 0x09:
            r6k_alu_a_spn(opc);
            break;
        case 0x0a:
            r6k_alu_hl_spn(opc);
            break;
        case 0x0b:
            r6k_alu_jkhl_spn(opc);
            break;
        case 0x0c:
            UNIMPLEMENTED(0x4900|opc, "slXreg");
            break;
        case 0x0d:
            UNIMPLEMENTED(0x4900|opc, "rlXreg");
            break;
        case 0x0e:
            UNIMPLEMENTED(0x4900|opc, "srXreg");
            break;
        case 0x0f:
            UNIMPLEMENTED(0x4900|opc, "rrXreg");
            break;
        }
   } else {
        switch ( opc ) {
        case 0x90:
            UNIMPLEMENTED(0x4900|opc, "pldisr");
            break;
        case 0xa0:
            UNIMPLEMENTED(0x4900|opc, "pldi");
            break;
        case 0xb0:
            UNIMPLEMENTED(0x4900|opc, "plidr");
            break;
        case 0xc0:
            UNIMPLEMENTED(0x4900|opc, "puma");
            break;
        case 0xd0:
            UNIMPLEMENTED(0x4900|opc, "plsidr");
            break;
        case 0xf0:
            UNIMPLEMENTED(0x4900|opc, "plsir");
            break;
        case 0xa2:
            UNIMPLEMENTED(0x4900|opc, "aessr");
            break;
        case 0xb2:
            UNIMPLEMENTED(0x4900|opc, "aesmmc");
            break;
        case 0xc2:
            UNIMPLEMENTED(0x4900|opc, "shaf1");
            break;
        case 0xd2:
            UNIMPLEMENTED(0x4900|opc, "shaf2");
            break;
        case 0xe2:
            UNIMPLEMENTED(0x4900|opc, "shaf3");
            break;
        case 0xa3:
            UNIMPLEMENTED(0x4900|opc, "aesir");
            break;
        case 0xb3:
            UNIMPLEMENTED(0x4900|opc, "aesimc");
            break;
        case 0xc3:
            UNIMPLEMENTED(0x4900|opc, "md5f1");
            break;
        case 0xd3:
            UNIMPLEMENTED(0x4900|opc, "md5f2");
            break;
        case 0xe3:
            UNIMPLEMENTED(0x4900|opc, "md5f3");
            break;
        case 0x98:
            UNIMPLEMENTED(0x4900|opc, "plddsr");
            break;
        case 0xa8:
            UNIMPLEMENTED(0x4900|opc, "pldd");
            break;
        case 0xb8:
            UNIMPLEMENTED(0x4900|opc, "plddr");
            break;
        case 0xc8:
            UNIMPLEMENTED(0x4900|opc, "pums");
            break;
        case 0xd8:
            UNIMPLEMENTED(0x4900|opc, "plsddr");
            break;
        case 0xf8:
            UNIMPLEMENTED(0x4900|opc, "psldr");
            break;
        case 0xa4:
        case 0xa5:
        case 0xa6:
        case 0xa7:
            pc++;
            UNIMPLEMENTED(0x4900|opc, "inc (ps+d)");
            break;
        case 0xb4:
        case 0xb5:
        case 0xb6:
        case 0xb7:
            pc++;
            UNIMPLEMENTED(0x4900|opc, "dec (ps+d)");
            break;
        default:
            UNIMPLEMENTED(0x4900|opc, "Unknown Rabbit 6000 opcode");
            break;
        }
   }
}
