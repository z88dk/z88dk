/*
 *      Small C+ String Library
 *
 *      strchr - search for character in string
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strchr.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */

#include <string.h>


char *strchr(unsigned char *s,unsigned char c)
{
#ifdef Z80
#asm
	pop	de	;et addr
	pop	bc	;c
	pop	hl	;s
	push	hl
	push	bc
	push	de
.loop
	ld	a,(hl)
	and	a
	jr	z,zeroret
	cp	c
	ret	z
	inc	hl
	jr	loop
.zeroret
	ld	hl,0
	ret
#endasm
#else

    while(*s) if(*s==c) return(s); else s++;
    return(0);
#endif
}
