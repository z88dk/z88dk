
// Common Rabbit instructions
#include "ticks.h"
#include <stdio.h>


// TODO: Setting P flag
#define BOOL(hi, lo, hia, loa, isalt) do {                \
          if ( isalt ) {                  \
            loa = fr_ = hi|lo ? 1 : 0; hia = 0; ff_ &= ~256; \
          } else {                       \
            lo = fr = hi|lo ? 1 : 0; hi = 0; ff &= ~256; \
          }                              \
        } while (0)

// TODO: Flags not right
#define AND2(r1, r2, ra) do {            \
          if ( altd ) {                  \
            fa_= ~(ra= ff_= fr_= r1&r2); \
            fb_= 0;                      \
          } else {                       \
            fa= ~(r1= ff= fr= r1&r2);    \
            fb= 0;                       \
          }                              \
          fk = 0; \
        } while (0)

// TODO: Flags not right
#define OR2(r1, r2, ra) do {    \
          if (altd) {           \
            fa_= 256                   \
                | (ff_= fr_= r1|= ra),  \
            fb_= 0, fk=0;        \
          } else {              \
            fa= 256                   \
                | (ff= fr= r1|= r2),  \
            fb= 0, fk=0;        \
          }                     \
    } while (0)

#define UNIMPLEMENTED(o, t) do {  \
        fprintf(stderr, "Unimplemented opcode ed,%02x/%s",o,t); \
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

void rxk_bool(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    if ( ih ) {
        BOOL(h,l, h_, l_, altd);
    } else if ( iy ) {
        BOOL(yh, yl, yh, yl, 0);
    } else {
        BOOL(xh,xl,xh,xl, 0);
    }
    st += 2;
}

void rxk_and_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    if ( ih ) {
        AND2(h,d,h_);
        AND2(l,e,e_);
    } else if ( iy ) {
        AND2(yh, d, yh);
        AND2(yl, e, yl);
    } else {
        AND2(xh, d, xh);
        AND2(xl, e, xl);
    }
    st += 2;
}

void rxk_or_hlxy_de(uint8_t opcode, uint8_t ih, uint8_t iy)
{
    if ( ih ) {
        OR2(h,d,h_);
        OR2(l,e,e_);
    } else if ( iy ) {
        OR2(yh, d, yh);
        OR2(yl, e, yl);
    } else {
        OR2(xh, d, xh);
        OR2(xl, e, xl);
    }
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
    st += 11;
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
    st += 11;
}

void rxk_ld_hl_xy(uint8_t opcode, uint8_t prefix)
{
    if ( prefix == 0xfd ) {
        if ( altd ) { h_ = yh; l_ = yl; }
        else { h = yh; l = yl; }
        st += 4;
    } else {
        if ( altd ) { h_ = xh; l_ = xl; }
        else { h = xh; l = xl; }
        st += 4;
    }
}

void rxk_ld_xy_hl(uint8_t opcode, uint8_t prefix)
{
    if ( prefix == 0xfd ) {
        yl = l; yh = h;
    } else {
        xl = l; xh = h;
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
    UNIMPLEMENTED(opcode, "ld xpc,a");
}

void rxk_ld_a_xpc(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "ld a,xpc");
}


void rxk_push_ip(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "push ip");
    st += 9;
}

void rxk_pop_ip(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "pop ip");
    st += 7;
}

void r3k_push_su(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "push su");
    st += 9;
}

void r3k_pop_su(uint8_t opcode)
{
    UNIMPLEMENTED(opcode, "pop su");
    st += 9;
}