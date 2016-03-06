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
#ifdef Z80
#asm
#ifdef NET_STDIO
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	a,(hl)
	and	_IOUSE|_IONETWORK
	jr	z,fflush_error 	;not used
	push	de
	call	fflush_net
	pop	bc
        ret
.fflush_error
	ld	hl,-1	; EOF
	ret
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





