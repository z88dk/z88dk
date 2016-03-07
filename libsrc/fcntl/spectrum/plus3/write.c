/*
 *	Read bytes from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: write.c,v 1.5 2016-03-07 13:44:48 dom Exp $
 */

#include <fcntl.h>

size_t write(int handle, void *buf, size_t len)
{
#asm
	INCLUDE "p3dos.def"
	EXTERN	dodos
	push	ix		;save caller
	ld	ix,2
	add	ix,sp
	ld	e,(ix+2)	;len
	ld	d,(ix+3)
	ld	a,d
	or	e
	jr	nz,write1
	pop	ix
	ex	de,hl		;len=0 return 0
	ret
.write1
	ld	l,(ix+4)	;buf
	ld	h,(ix+5)
	ld	b,(ix+6)	;handle
	ld	c,0		;page FIXME
	push	de
	ld	iy,DOS_WRITE
	call	dodos
	pop	hl		;bytes we wanted to write
	pop	ix		;restore caller
	ret	c		;it went okay
	sbc	hl,de		;gives number written
#endasm
}


