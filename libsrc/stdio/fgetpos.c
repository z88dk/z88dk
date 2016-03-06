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
 * $Id: fgetpos.c,v 1.4 2016-03-06 21:36:52 dom Exp $
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
	pop	af	;ret
	pop	bc	;&posn
	pop	hl	;fp
	push	hl
	push	bc
	push	af	
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)	;flags
	and	_IOUSE
	jr	z,fgetpos_abort
	and	_IOSYSTEM
	jr	nz,fgetpos_abort
	push	de	;fd
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


