
#include <cpm.h>


int swapuid(int id) __z88dk_fastcall __naked  {
#asm
    EXTERN __bdos

    push    hl
    ld      c,CPM_SUID
    ld      e,0xff      ;query
    call    __bdos
    pop     de
    cp      e
    ret     z           ;Existing id was the same
    push    af
    ld      c,CPM_SUID
    call    __bdos
    pop     af
    ld      l,a
    ld      h,0
    ret
#endasm
}
