/*
 *      Tape save routine
 *
 *
 *      djm 16/10/2001
 */


#include <spectrum.h>

int tape_save_block(void *addr, size_t len, unsigned char type)
{
#asm
        pop     hl      ;ret address
        pop     bc      ;type
        ld      a,c     ;
        pop     de      ;length
        pop     ix      ;addr
        push    ix
        push    de
        push    bc
        push    hl
        ld      hl,(23613)
        push    hl
        ld      hl,saveblock1
        push    hl
        ld      (23613),sp
        call    1218            ;call ROM3 routine
        pop     hl              ;successfull dump the random value
        ld      hl,0
.saveblock2
        pop     de
        ld      (23613),de      ;get back original 23613
        ret
.saveblock1
        ld      hl,-1           ;error
        jr      saveblock2
#endasm
}



