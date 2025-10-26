#include "regis.h"


void __regis_outstr(char *str) __z88dk_fastcall __naked
{
__asm
    EXTERN  ___regis_outc
loop:
    ld      a,(hl)
    and     a
    ret     z
    push    hl
    ld      l,a
    ld      h,0
    call    ___regis_outc
    pop     hl
    inc     hl
    jr      loop
__endasm;
}
