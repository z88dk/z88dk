// Reads back what crt_init_rabbit.inc programmed
#include <stdio.h>

static unsigned char get_xpc(void)
{
#asm
    ld      a,xpc
    ld      l,a
    ld      h,0
#endasm
}

static unsigned char get_ioi(unsigned int reg) __z88dk_fastcall
{
    reg;
#asm
    ioi ld  a,(hl)
    ld      l,a
    ld      h,0
#endasm
}

int main(void)
{
    printf("xpc=%02x segsize=%02x dataseg=%02x stackseg=%02x dh=%02x sh=%02x\n",
        get_xpc(), get_ioi(0x13), get_ioi(0x12), get_ioi(0x11),
        get_ioi(0x1f), get_ioi(0x1b));
    return 0;
}
