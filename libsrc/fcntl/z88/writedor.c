/*
 *	Read a member of a dor
 *
 *	writedor(int handle,char type,char len,void *buf)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: writedor.c,v 1.5 2014-04-11 11:14:00 stefano Exp $
 */


#include <z88.h>

void writedor(int handle, char type, char len, void *buf)
{
#asm
	INCLUDE	"dor.def"
	ld	iy,0		;Use iy as framepointer for ease
	add	iy,sp
	ld	e,(iy+2)	;buffer
	ld	d,(iy+3)
	ld	c,(iy+4)	;length
	ld	b,(iy+6)	;type
	ld	l,(iy+8)	;dor handle
	ld	h,(iy+9)
	push	hl
	pop	ix		;os_dor wants it in ix
	ld	a,dr_wr		;read dor
	call_oz(os_dor)
#endasm
}

