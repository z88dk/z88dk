/*
 *      Tape load routine
 *
 *
 *      djm 16/10/2001
 */


#include <spectrum.h>

int tape_load_block(void *addr, size_t len, unsigned char type)
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
	scf
        call    1366            ;call ROM3 load routine
        ld      hl,-1
	ret	nc		;error
	inc	hl		;okay
#endasm
}



