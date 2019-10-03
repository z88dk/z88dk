/*
 *	Open a wild char handler
 *
 *	djm 22/3/2000
 *
 */

#include <z88.h>

char *fnexpand(far char *string, char *buffer, size_t size)
{
#asm
	INCLUDE	"fileio.def"
	push	ix
	ld	ix,2
	add	ix,sp
	ld	l,(ix+6)	;filename
	ld	h,(ix+7)
	ld	e,(ix+8)
	ld	d,0
	push	de
	push	hl
	call	_cpfar2near	;get it to near spec
	ld	b,0		;local
	ld	e,(ix+4)	;where to put it
	ld	d,(ix+5)
	ld	c,(ix+2)	;max size
	call_oz(gn_fex)
	ld	hl,0	;NULL - error
	jr	c,fnexpand_exit
	xor	a	;terminate just in case
	ld	(de),a
	ld	l,(ix+4)	;where we expanded it to
	ld	h,(ix+5)
fnexpand_exit:
	pop	ix
#endasm
}
