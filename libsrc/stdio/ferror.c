/*
 *	Check for file errors
 *
 *	Return 1 = Error,  0 = Ok
 *
 *	Stefano Bodrato, Sep. 2019
 *
 * --------
 * $Id: ferror.c $
 */

#define ANSI_STDIO
#define STDIO_ASM

#include <stdio.h>

int wrapper2(FILE *fp) __naked
{
#asm
PUBLIC _ferror
ferror:
_ferror:
	inc	hl
	inc	hl	;flags
	ld	a,(hl)
	ld	hl,1
	
	and	_IOUSE		; in use?
	ret z
	
; check EOF only if not WRITE mode
	and	_IOWRITE
	jr	nz,__ferror_skip_eof
	and	_IOEOF
	ret	nz
__ferror_skip_eof:
	dec	hl	;hl = 0
	ret

#endasm
}
