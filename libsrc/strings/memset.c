/*
 *       memset(void *s, uchar byte, size_t size)
 *
 *      djm 27/4/99
 *
 *	$Id: memset.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */


#include <string.h>


void *memset(void *s, unsigned char byte, int size)
{
#asm
        pop     de      ;return address
        pop     bc      ;size
        pop     hl      
        ld      a,l     ;filler
        pop     hl      ;address

        push    hl
        push    hl
        push    bc
        push    de

        ex      af,af  ;preserve filler
        ld      a,c
        or      b
        ret     z       ;not doing 0!
        ld      d,h
        ld      e,l
        inc     de
        ex      af,af  ;get filler back
        ld      (hl),a
        dec     bc
        ld      a,b
        or      c
        ret     z       ;not gonna do one either...
        push    hl      ;keep address
        ldir
	pop	hl
#endasm
}

