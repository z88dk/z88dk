/*
 *       memcmp(void *s1, void *s2, size_t size)
 *
 *      djm 22/11/99
 *
 *	Let strncmp to all the hard work...
 *
 *	$Id: memcmp.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */


#include <string.h>

int memcmp(void *s1, void *s2, int n)
{
#asm
;return address,n, s2, s1
	ld	ix,0
	add	ix,sp
	ld	c,(ix+2)
	ld	b,(ix+3)
	ld	e,(ix+4)	;s2
	ld	d,(ix+5)
	ld	l,(ix+6)	;s1
	ld	h,(ix+7)
.loop
	ld	a,b
	or	c
	jr	z,setzero
	dec	bc
	ld	a,(de)
	cp	(hl)
	jr	nz,outtahere
	inc	de
	inc	hl
	jr	loop
.setzero
	ld	hl,0
	ret
.outtahere
	ld	hl,1
	ret	c
	dec	hl
	dec	hl	;-1
#endasm
}

