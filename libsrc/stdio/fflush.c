/*
 *	fflush(fp)
 *
 *	Only really valid for TCP net connections
 *
 */

#ifdef Z80
#define STDIO_ASM
#endif

#include <stdio.h>


int fflush(FILE *fp)
{
#ifdef Z80
#asm
#ifdef NET_STDIO
	pop	bc
	pop	ix
	push	ix
	push	bc
	ld	hl,-1	;EOF
	ld	a,(ix+fp_flags)
	ld	c,a
	and	_IOUSE
	ret	z	;not used
	ld	a,c
	and	_IONETWORK
	ret	z	;not network
	ld	l,(ix+fp_desc)
	ld	h,(ix+fp_desc+1)
	push	hl
	call	fflush_net
	pop	bc
#else
	ld	hl,0
#endif
#endasm
#else
#ifdef NET_STDIO
	if	(fp->flags&(_IOUSE|_IONETWORK) == _IOUSE|_IONETWORK ) {
		return (fflush_net(fp->desc.fd));
	}
	return 0;
#else
	return 0;
#endif
#endif
}





