#ifndef ZX_H
#define ZX_H

#include <stdio.h>
#include <string.h>

typedef struct {
    uint8_t c;
    uint8_t b;
    uint8_t e;
    uint8_t d;
    uint8_t l;
    uint8_t h;
    uint8_t f;
    uint8_t a;
} regs;


static regs  old_regs;
static regs  new_regs;

static void compare(int param) {
    int res;

    res = memcmp(old_regs, new_regs, 6);

    if ( res == 0 ) {
        // Just compare the carry flag
        res = ! ( (old_regs.f & 0x01) == (new_regs.f & 0x01));
    }

    if ( res != 0 ) {
        static char  message[160];

        snprintf(message,sizeof(message),"Parameter: %04x c=%02x/%02x b=%02x/%02x e=%02x/%02x d=%02x/%02x l=%02x/%02x h=%02x/%02x a=%02x/%02x f=%02x/%02x", param,
                old_regs.c, new_regs.c,
                old_regs.b, new_regs.b,
                old_regs.e, new_regs.e,
                old_regs.d, new_regs.d,
                old_regs.l, new_regs.l,
                old_regs.h, new_regs.h,
                old_regs.a, new_regs.a,
                old_regs.f, new_regs.f);
        Assert(res == 0, message);
    }
}




#endif
