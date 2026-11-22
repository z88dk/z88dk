
// Common Rabbit instructions
#include "ticks.h"
#include <stdio.h>


/* Flags after AND/OR rr,DE (Rabbit Instruction Reference Manual 019-0098):
   S from bit 15, Z if the word is 0, L/V from bits 15-12, C cleared. fr keeps
   the high byte in its low byte, so f() takes L/V from bits 15-12 and Z from
   the whole word. */
static void logic16_flags(uint16_t v, int alt)
{
    uint8_t hi = v >> 8, lo = v;

    if ( alt ) {
        ff_ = hi; fr_ = hi | lo << 8; fa_ = 256 | hi; fb_ = 0;
    } else {
        ff = hi; fr = hi | lo << 8; fa = 256 | hi; fb = 0;
    }
}

/* Flags after BOOL: the result is 0 or 1, so S is 0 and Z is set for 0.
   L/V and C are cleared. fa and fb are 0, so f() reads L/V as clear. */
static void bool_flags(uint16_t v, int alt)
{
    if ( alt ) {
        ff_ = 0; fr_ = v; fa_ = 0; fb_ = 0;
    } else {
        ff = 0; fr = v; fa = 0; fb = 0;
    }
}

#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode %04x/%s",o,t); \
    } while (0)


void rxk_ld_hl_ispn(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    int     offset;
    ioi=ioe=0;
    offset = sp + get_memory_inst(pc++);
    st += 9;
    if ( ih ) {
        l = get_memory_data(offset++);
        h = get_memory_data(offset);
    } else if ( iy ) {
        yl = get_memory_data(offset++);
        yh = get_memory_data(offset);
    } else {
        xl = get_memory_data(offset++);
        xh = get_memory_data(offset);
    }
}

void rxk_ld_ispn_hl(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    int     offset;

    ioi=ioe=0;
    st += 9;
    offset = sp + get_memory_inst(pc++);

    if ( ih ) {
        put_memory(offset++,l);
        put_memory(offset, h);
    } else if ( iy ) {
        put_memory(offset++,yl);
        put_memory(offset, yh);
    } else {
        put_memory(offset++,xl);
        put_memory(offset, xh);
    }
}

/* BOOL HL: ALTD selects HL' and the alternate flags (alts selects HL' as the
   source). BOOL IX/IY: ALTD has no effect. */
void rxk_bool(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    uint16_t v;

    if ( ih ) {
        v = alts ? (h_ | l_) != 0 : (h | l) != 0;
        if ( altd ) { h_ = 0; l_ = v; }
        else { h = 0; l = v; }
        bool_flags(v, altd);
    } else if ( iy ) {
        v = (yh | yl) != 0;
        yh = 0; yl = v;
        bool_flags(v, 0);
    } else {
        v = (xh | xl) != 0;
        xh = 0; xl = v;
        bool_flags(v, 0);
    }
    st += 2;
}

/* AND HL,DE: ALTD selects HL' and the alternate flags.
   AND IX/IY,DE: ALTD selects the alternate flags only. */
void rxk_and_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    uint16_t v, de = d << 8 | e;

    if ( ih ) {
        v = (h << 8 | l) & de;
        if ( altd ) { h_ = v >> 8; l_ = v; }
        else { h = v >> 8; l = v; }
    } else if ( iy ) {
        v = (yh << 8 | yl) & de;
        yh = v >> 8; yl = v;
    } else {
        v = (xh << 8 | xl) & de;
        xh = v >> 8; xl = v;
    }
    logic16_flags(v, altd);
    st += 2;
}

/* OR HL,DE: ALTD selects HL' and the alternate flags.
   OR IX/IY,DE: ALTD selects the alternate flags only. */
void rxk_or_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    uint16_t v, de = d << 8 | e;

    if ( ih ) {
        v = (h << 8 | l) | de;
        if ( altd ) { h_ = v >> 8; l_ = v; }
        else { h = v >> 8; l = v; }
    } else if ( iy ) {
        v = (yh << 8 | yl) | de;
        yh = v >> 8; yl = v;
    } else {
        v = (xh << 8 | xl) | de;
        xh = v >> 8; xl = v;
    }
    logic16_flags(v, altd);
    st += 2;
}

 // LD HL,(IXY+d) LD HL,(HL+d)
void rxk_ld_hl_ihlxyd(uint8_t opcode, uint8_t prefix)
{
    uint16_t t;
    uint8_t lt, ht;
    t = (get_memory_inst(pc++)^128)-128;
    switch (prefix) {
    case 0x00:  // ld hl,(ix+d)
        lt = get_memory_data(t+(xl|xh<<8));
        ht = get_memory_data(t+(xl|xh<<8) + 1);
        break;
    case 0xfd: // ld hl,(iy+d)
        lt = get_memory_data(t+(yl|yh<<8));
        ht = get_memory_data(t+(yl|yh<<8) + 1);
        break;
    case 0xdd: // ld hl,(hl+d)
        lt = get_memory_data(t+(l|h<<8));
        ht = get_memory_data(t+(l|h<<8) + 1);
        break;
    }
    if ( altd ) { h_ = ht; l_ = lt; }
    else { h = ht; l = lt; }
    /* ld hl,(ix+d) is 9 clocks on the R2000/R3000/R4000 and 10 on the R5000/R6000;
       the (iy+d) and (hl+d) forms add the 2-clock prefix (11 and 12) */
    st += israbbit6k() ? 10 : 9;
}

void rxk_ld_ihlxyd_hl(uint8_t opcode, uint8_t prefix)
{
    uint16_t t = (get_memory_inst(pc++)^128)-128;

    switch (prefix) {
    case 0x00:
        put_memory(t+(xl|xh<<8),l);
        put_memory(t+(xl|xh<<8) + 1,h);
        break;
    case 0xfd:
        put_memory(t+(yl|yh<<8),l);
        put_memory(t+(yl|yh<<8) + 1,h);
        break;
    case 0xdd:
        t += (l|h<<8);
        put_memory(t,l);
        put_memory(t + 1, h);
        break;
    }
    /* ld (ix+d),hl is 11 clocks on the R2000/R3000/R4000 and 12 on the R5000/R6000;
       the (iy+d) and (hl+d) forms add the 2-clock prefix (13 and 14) */
    st += israbbit6k() ? 12 : 11;
}

void rxk_ld_hl_xy(uint8_t opcode, uint8_t prefix)
{
    if ( prefix == 0xfd ) {
        if ( altd ) { h_ = yh; l_ = yl; }
        else { h = yh; l = yl; }
    } else {
        if ( altd ) { h_ = xh; l_ = xl; }
        else { h = xh; l = xl; }
    }
    st += 4;
}

void rxk_ld_xy_hl(uint8_t opcode, uint8_t prefix)
{
    if ( prefix == 0xfd ) {
        yl = alts ? l_ : l; yh = alts ? h_ : h;
    } else {
        xl = alts ? l_ : l; xh = alts ? h_ : h;
    }
    st += 4;
}

void rxk_add_sp_d(uint8_t opcode)
{
    uint32_t v;
    st += 4;
    v = sp + (get_memory_inst(pc++)^128)-128;
    sp = v & 0xffff;
    if ( v >> 16 ) ff |= 256;
    else ff &= ~256;
}


void rxk_mul(uint8_t opcode)
{
    // HL:BC = BC • DE
    int32_t result = (( (int32_t)(int8_t)d * 256 ) + e) * (( (int32_t)(int8_t)b * 256 ) + c);
    h = (result >> 24) & 0xff;
    l = (result >> 16) & 0xff;
    b  = (result >> 8 ) & 0xff;
    c = result & 0xff;
    st += 12;
}


void rxk_ld_xpc_a(uint8_t opcode)
{
    rabbit_set_xpc(a);
    st += 4;
}

void rxk_ld_a_xpc(uint8_t opcode)
{
    a = rabbit_get_xpc() & 0xff;
    st += 4;
}


void rxk_push_ip(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "push ip");
    st += 9;
}

void rxk_pop_ip(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "pop ip");
    st += 7;
}




// LDP forms address physical memory: bits 19:16 come from A[3:0]
static uint32_t ldp_phys(uint16_t addr)
{
    return ((uint32_t)(a & 0x0f) << 16) | addr;
}

static void ldp_store(uint16_t addr, uint8_t lo, uint8_t hi)
{
    uint32_t phys = ldp_phys(addr);

    rabbit_phys_write(phys, lo);
    rabbit_phys_write(phys + 1, hi);
}

static void ldp_load(uint16_t addr, uint8_t *lo, uint8_t *hi)
{
    uint32_t phys = ldp_phys(addr);

    *lo = rabbit_phys_read(phys);
    *hi = rabbit_phys_read(phys + 1);
}

static uint16_t ldp_addr_reg(uint8_t prefix)
{
    switch (prefix) {
    case 0xdd: return xh << 8 | xl;
    case 0xfd: return yh << 8 | yl;
    default:   return h << 8 | l;
    }
}

static uint16_t ldp_fetch_mn(void)
{
    uint16_t mn = get_memory_inst(pc++);

    mn |= get_memory_inst(pc++) << 8;
    return mn;
}

void rxk_ldp_hl_irr(uint8_t opcode, uint8_t prefix)
{
    ioi = ioe = 0;
    ldp_load(ldp_addr_reg(prefix), &l, &h);
    st += 10;
}

void rxk_ldp_rr_inm(uint8_t opcode, uint8_t prefix)
{
    uint16_t mn = ldp_fetch_mn();

    ioi = ioe = 0;
    switch (prefix) {
    case 0xdd: ldp_load(mn, &xl, &xh); break;
    case 0xfd: ldp_load(mn, &yl, &yh); break;
    default:   ldp_load(mn, &l, &h); break;
    }
    st += 13;
}

void rxk_ldp_inm_rr(uint8_t opcode, uint8_t prefix)
{
    uint16_t mn = ldp_fetch_mn();

    ioi = ioe = 0;
    switch (prefix) {
    case 0xdd: ldp_store(mn, xl, xh); break;
    case 0xfd: ldp_store(mn, yl, yh); break;
    default:   ldp_store(mn, l, h); break;
    }
    st += 15;
}

void rxk_ldp_irr_hl(uint8_t opcode, uint8_t prefix)
{
    ioi = ioe = 0;
    ldp_store(ldp_addr_reg(prefix), l, h);
    st += 12;
}

void rxk_lret(uint8_t opcode)
{
    uint16_t ret;

    ioi = ioe = 0;
    ret = get_memory_data(sp++);
    ret |= get_memory_data(sp++) << 8;
    rabbit_set_xpc(get_memory_data(sp++));
    mp = pc = ret;
    st += 13;
}

void rxk_lcall(uint8_t opcode)
{
    uint16_t mn = ldp_fetch_mn();
    uint8_t  x = get_memory_inst(pc++);

    ioi = ioe = 0;
    put_memory(--sp, rabbit_get_xpc() & 0xff);
    put_memory(--sp, pc >> 8);
    put_memory(--sp, pc);
    rabbit_set_xpc(x);
    mp = pc = mn;
    st += 19;
}

void rxk_ljp(uint8_t opcode)
{
    uint16_t mn = ldp_fetch_mn();
    uint8_t  x = get_memory_inst(pc++);

    ioi = ioe = 0;
    rabbit_set_xpc(x);
    mp = pc = mn;
    st += 10;
}









// The interrupt priority register is four 2-bit levels used as a stack. It is
// tracked so ipset/ipres pair up, but ticks does not use it to mask interrupts.
static uint8_t rabbit_ip;

void rxk_ipres(uint8_t opcode)
{
    rabbit_ip = (rabbit_ip >> 2) | (rabbit_ip << 6);
    st += 4;
}

void rxk_ipset(uint8_t opcode)
{
    static const uint8_t level[] = { [0x46] = 0, [0x56] = 1, [0x4e] = 2, [0x5e] = 3 };

    rabbit_ip = (rabbit_ip << 2) | level[opcode];
    st += 4;
}

void rxk_ld_eir_a(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld eir,a");
    st += 4;
}

void rxk_ld_iir_a(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld iir,a");
    st += 4;
}

void rxk_ld_a_eir(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld a,eir");
    st += 4;
}

void rxk_ld_a_iir(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld a,iir");
    st += 4;
}


void r3k_push_su(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "push su");
    st += 9;
}

void r3k_pop_su(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "pop su");
    st += 9;
}

void r3k_ldisr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "ldisr");
}

void r3k_lddsr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "lddsr");
}

void r3k_uma(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "uma");
}

void r3k_ums(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "ums");
}

void r3k_lsidr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "lsidr");
}


void r3k_lsddr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "lsddr");
}


void r3k_lsir(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "lsir");
}

void r3k_lsdr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "lsdr");
}

void r3k_setusr(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "setusr");
    st += 4;
}

void r3k_rdmode(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "rdmode");
    st += 4;
}

void r3k_sures(uint8_t opcode)
{
    UNIMPLEMENTED(0xed00|opcode, "sures");
    st += 4;
}
