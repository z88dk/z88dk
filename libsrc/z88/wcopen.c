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
	push	ix
	ld	ix,2
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
	push	ix
	pop	de
	pop	ix	;callers ix
	ld	hl,0	;NULL - error
	ret	c
	ex	de,hl	;hl=now handle
#endasm
}
