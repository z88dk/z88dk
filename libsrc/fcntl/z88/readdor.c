/*
 *	Read a member of a dor
 *
 *	readdor(int handle,char type,char len,void *buf)
 *
 *	djm 13/3/2000
 */

#include <z88.h>

void readdor(int handle, char type, char len, void *buf)
{
#asm
	INCLUDE	"#dor.def"
	ld	iy,0		;Use iy as framepointer for ease
	add	iy,sp
	ld	e,(iy+2)	;buffer
	ld	d,(iy+3)
	ld	c,(ix+4)	;length
	ld	b,(ix+6)	;type
	ld	l,(ix+8)	;dor handle
	ld	h,(ix+9)
	push	hl
	pop	ix		;os_dor wants it in ix
	ld	a,DR_Rd		;read dor
	call_oz(os_dor)
#endasm
}

