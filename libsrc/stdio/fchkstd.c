/*
 *	Short routine to check for std* channels
 *	
 *	This is implemented in order to use different routines
 *	for console input/output
 *
 *	Returns: 0 = not console, c
 *		 1 = input, nc
 *		-1 = output, nc
 * --------
 * $Id: fchkstd.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>


int fchkstd(FILE *fp)
{
#ifdef Z80
#asm
	pop	de
	pop	ix
	push	ix
	push	de
	ld	hl,0
	ld	a,(ix+fp_flags)
	and	_IOSYSTEM
	scf
	ret	z	;non system return 0
	dec	hl	;-1
	ld	a,(ix+fp_flags)
	and	_IOREAD
	and	a	;don`t think this is necessary
	ret	nz
	inc	hl
	inc	hl	;write, return 1
	and	a
#endasm
#else
	if ( fp->flags&_IOSYSTEM == 0 ) return 0;

	return ( fp->flags&_IOREAD ? -1 : 1 );
#endif
}

