/*
 *      Small C+ String Library
 *
 *	memchr(void *data, unsigned char byte, size_t count);
 *
 *	Search memory for a byte..
 *
 *	djm 22/12/99
 */

#include <string.h>


void *memchr(void *s,unsigned char c,int length)
{
#ifdef SMALL_C
#asm
	ld	hl,2
	add	hl,sp
	ld	c,(hl)
	inc	hl
	ld	b,(hl)	;length
	inc	hl
	ld	e,(hl)	;byte
	inc	hl
	inc	hl
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a	;s
.loop
	ld	a,b
	or	c
	jr	z,retzero
	ld	a,(hl)
	cp	e
	ret	z	;matched
	inc	hl
	dec	bc
	jr	loop
.retzero
	ld	hl,0
	ret
#endasm
#else
    while(length--) if((unsigned char)*s==c) return(s); else s++;
    return(0);
#endif
}
