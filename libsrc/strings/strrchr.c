/*
 *      Small C+ String Library
 *
 *      strrchr - search for character in string (backwards)
 *
 *      Taken from vbcc archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 *
 *	$Id: strrchr.c,v 1.2 2001-04-11 12:15:32 dom Exp $
 */

/*
 *      A little black magic..
 */


#include <string.h>


char *strrchr(char *s,unsigned char c)
{
#ifdef Z80
#asm
	pop	hl	;ret
	pop	bc	;c
	pop	de	;s
	push	de
	push	bc
	push	hl
	ld	hl,0
.loop
	ld	a,(de)
	and	a
	ret	z
	inc	de
	cp	c
	jr	nz,loop
	ld	h,d
	ld	l,e
	dec	hl
	jr	loop
#endasm
#else
    unsigned char *p;
    p=0;
    while(*s){
        if(*s==c) p=s;
        s++;
    }
    return(p);
#endif
}
