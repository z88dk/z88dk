/*
 *	Get the position of a file
 *
 *	int fgetpos(FILE *fp, fpos_t *posn)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 *
 * --------
 * $Id: fgetpos.c,v 1.3 2003-10-13 22:56:15 dom Exp $
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>

int fgetpos(FILE *fp, fpos_t *posn)
{
#ifdef Z80
#asm
	pop	de	;ret
	pop	bc	;&posn
	pop	ix	;fp
	push	ix
	push	bc
	push	de
	ld	a,(ix+fp_flags)
	and	_IOUSE
	jr	z,fgetpos_abort
	push	ix
	call	fchkstd
	pop	ix
	jr	nc,fgetpos_abort	;std* system
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc)
	push	hl	;fd
	push	bc	;&posn
	call	fdgetpos
	pop	bc
	pop	bc
	ret
.fgetpos_abort
	ld	hl,-1
#endasm
#else
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		return (fdgetpos(fp->fd,posn));
	}
	return -1;
#endif
}


