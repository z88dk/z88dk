/*
 *	Get the position of a file
 *
 *	long ftell(FILE *fp)
 *
 *	Calls some machine dependent routine to do the dirty work
 *
 *	djm 1/4/2000
 */

#define ANSI_STDIO

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>

fpos_t ftell(FILE *fp)
{
#ifdef Z80
#asm
	pop	bc
	pop	ix
	push	ix
	push	bc
	ld	a,(ix+fp_flags)
	and	_IOUSE
	jr	z,ftell_abort
	push	ix
	call	fchkstd
	pop	ix
	jr	nc,ftell_abort	;system
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc)
	push	hl
	call	fdtell
	pop	bc
	ret
.ftell_abort
	ld	de,65535	;-1
	ld	l,e
	ld	h,d
#endasm
#else
	if ( fp->flags&_IOUSE && fchkstd(fp)== 0 ) {
		return (fdtell(fp->fd));
	}
	return -1L;
#endif
}


