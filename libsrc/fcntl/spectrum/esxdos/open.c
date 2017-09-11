

#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(char *name, int flags, mode_t mode) __naked
{
#asm
    EXTERN  asm_esxdos_f_open
    push    ix
    ld      hl,6	;flags
    add     hl,sp
    ld      b,(hl)
    inc     hl
    inc     hl
    ld      e,(hl)	;filename
    inc     hl
    ld      d,(hl)
    ex      de,hl
    ld      a,'*'
    call    asm_esxdos_f_open
    jr      nc,end
    ld      h,0
end:
    pop     ix
    ret
#endasm
}
