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
 * $Id: fchkstd.c,v 1.3 2016-03-06 21:36:52 dom Exp $
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
IF __CPU_R2KA__ | __CPU_R3K__
	ld	hl,(sp + 2)
	ex	de,hl
ELIF __CPU_GBZ80__
	ld	hl,sp+2
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
ELSE
	pop	hl
	pop	de
	push	de
	push	hl
ENDIF
	ld	hl,0
	inc	de
	inc	de	; points to +fp_flags
	ld	a,(de)
IF __CPU_Z80N__ | __CPU_Z180__
	tst	_IOSYSTEM
	scf
	ret	z
	dec	hl
	tst	_IOREAD
ELSE
	and	_IOSYSTEM
	scf
	ret	z	;non system return 0
	dec	hl	;-1
	ld	a,(de)
	and	_IOREAD
ENDIF
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

