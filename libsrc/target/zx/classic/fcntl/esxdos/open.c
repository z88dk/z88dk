

#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(char *name, int flags, mode_t mode) __naked
{
#asm
    EXTERN  asm_esxdos_f_open
    push    ix
    ld      hl,6	;flags
    add     hl,sp
    ld      a,(hl)	; esxdos flags are +1 on C flags
    inc     a
    and     3
    inc     hl
    ld      c,0		; esx_mode_open_exist
    bit     2,(hl)      ;O_CREAT
    jr      z,not_o_creat
    ld      c,8         ; esx_mode_open_crea
    bit     1,(hl)	;O_TRUNC
    jr      z,not_o_trunc
    ld	    c,$0c	; esx_mode_creat_trunc
not_o_creat:
not_o_trunc:
    or      c		; add in open mode
    ld      b,a
    inc     hl
    ld      e,(hl)	;filename
    inc     hl
    ld      d,(hl)
    ex      de,hl
    ld      a,$2a	;*
    call    asm_esxdos_f_open
    jr      c,end
    ld      h,0
end:
    pop     ix
    ret
#endasm
}
