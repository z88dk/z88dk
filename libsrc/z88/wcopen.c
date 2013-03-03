/*
 *	Open a wild char handler
 *
 *	djm 22/3/2000
 *
 */

#include <z88.h>

wild_t	wcopen(far char *string, int mode)
{
#asm
	INCLUDE	"fileio.def"
	ld	ix,0
	add	ix,sp
	ld	l,(ix+4)
	ld	h,(ix+5)
	ld	e,(ix+6)
	ld	d,0
	push	de
	push	hl
	call	_cpfar2near	;get it to near spec
	ld	b,0		;local
	ld	a,(ix+2)	;mode
	and	@00000011
	call_oz(gn_opw)
	ld	hl,0	;NULL - error
	ret	c
	push	ix	;handle
	pop	hl
#endasm
}
