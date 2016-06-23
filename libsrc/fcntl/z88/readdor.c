/*
 *	Read a member of a dor
 *
 *	readdor(int handle,char type,char len,void *buf)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: readdor.c,v 1.7 2016-06-23 21:08:41 dom Exp $
 */


#include <z88.h>

void readdor(int handle, int type, int len, void *buf)
{
#asm
	INCLUDE	"dor.def"
	push	ix		;save callers
	ld	ix,2		;Use iy as framepointer for ease
	add	ix,sp
	ld	e,(ix+2)	;buffer
	ld	d,(ix+3)
	ld	c,(ix+4)	;length
	ld	b,(ix+6)	;type
	ld	l,(ix+8)	;dor handle
	ld	h,(ix+9)
	push	hl
	pop	ix		;os_dor wants it in ix
	ld	a,dr_rd		;read dor
	call_oz(os_dor)
	pop	ix	
#endasm
}

