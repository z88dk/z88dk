/*
 *       memcmp(void *s1, void *s2, size_t size)
 *
 *      djm 22/11/99
 *
 *	Let strncmp to all the hard work...
 *
 *	$Id: memcmp.c,v 1.3 2001-09-06 09:18:01 dom Exp $
 */


#include <string.h>

int memcmp(void *s1, void *s2, int n)
{
#asm
;return address,n, s2, s1
	ld	hl,2
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)	;n
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)	;s2
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a	;s1
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

