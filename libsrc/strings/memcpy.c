/*
 *       memcpy(void *s1, void *s2, size_t size)
 *
 *      djm 22/11/99
 *
 *	$Id: memcpy.c,v 1.4 2001-09-06 08:34:57 dom Exp $
 */


#include <string.h>


void *memcpy(void *s1, void *s2, int size)
{
#asm
        ld      hl,2   
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ;bc=n
        ld      a,c
        or      b
        ret     z       ;check c<>0
        inc     hl
        ld      e,(hl)  
        inc     hl
        ld      d,(hl)  ;de=src
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)  
        ld      l,a     ;hl=dest
#if 1
	push	hl
	ex	de,hl
	ldir
	pop	hl
#else
.memcpy1
        ld      a,(de)
        ld      (hl),a
        and     a
        jp      z,memcpy3
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jp      nz,memcpy1
.memcpy3
        ld      hl,6
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
	ex	de,hl
#endif
#endasm
}

