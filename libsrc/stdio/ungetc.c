/*
 *      New stdio functions for Small C+
 *
 *      djm 4/5/99
 *
 * --------
 * $Id: ungetc.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO

#define STDIO_ASM

#include <stdio.h>

int ungetc(int c, FILE *fp)
{
#ifdef Z80
#asm
	pop	de	;ret
	pop	ix	;fp
	pop	bc	;c
	push	bc
	push	ix
	push	de
	ld	hl,EOF
	ld	a,(ix+fp_flags)
	ld	b,a
	and	_IOUSE
	ret	z	;not being used
	ld	a,b
	and	_IOEOF |_IOWRITE
	ret	nz	;cant push back after EOF (or for write stream)
	ld	a,(ix+fp_ungetc)
	and	a
	ret	nz
	ld	(ix+fp_ungetc),c	;store the char
	ld	l,c			;return it
	ld	h,0
#endasm
#else
        if (fp == 0 || c == EOF || fp->ungetc || fp->flags&_IOWRITE ) return(EOF);
        
        fp->ungetc=(unsigned char)c;
        return(c);
#endif
}
