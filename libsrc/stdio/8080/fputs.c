/*
 *      New stdio functions for Small C+
 *
 *	fputc handles all types
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: fputs.c,v 1.1 2002-05-10 11:08:56 dom Exp $
 */


#include <stdio.h>
#include <fcntl.h>



int fputs(unsigned char *s,FILE *fp)
{
#ifdef Z80
#asm
	pop	hl	;ret
	pop	de	;fp
	pop	bc	;s
	push	bc	
	push	de	
	push	hl
.loop
	ld	hl,1	;non -ve number
	ld	a,(bc)	;*s
	and	a
	ret	z	;end of string
	ld	l,a
	ld	h,0
	inc	bc	;s++
	push	bc	;keep s
	push	hl	;send *s++
	push	de	;send fp
	call	fputc
	pop	de	;get fp back
	pop	bc	;discard hl
	pop	bc	;get s back
	ld	a,l	;test for EOF returned
	and	h
	inc	a
	ret	z
	jr	loop
#endasm
#else
        while (*s) {
                if ( fputc(*s++,fp) == EOF) return(EOF);
        }
#endif
}
