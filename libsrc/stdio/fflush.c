/*
 *	fflush(fp)
 *
 *	Only really valid for TCP net connections
 *
 * --------
 * $Id: fflush.c,v 1.4 2016-03-06 21:36:52 dom Exp $
 */

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>


int fflush(FILE *fp)
{
#asm
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	and	_IOUSE|_IOEXTRA
	jr	z,fflush_error 	;not used
	push	ix	;save callers ix
	dec	hl
	dec	hl	;hl = fp
	push	hl
	pop	ix
	ld	a,__STDIO_MSG_FLUSH
	ld	l,(ix+fp_extra)
	ld	h,(ix+fp_extra+1)
	jp	l_jphl
.fflush_error
	ld	hl,-1	; EOF
#endasm
}





