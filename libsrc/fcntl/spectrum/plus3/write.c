/*
 *	Read bytes from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: write.c,v 1.2 2003-10-10 11:05:02 dom Exp $
 */

#include <fcntl.h>

size_t write(int handle, void *buf, size_t len)
{
#asm
	INCLUDE "#p3dos.def"
	XREF	dodos
	ld	ix,0
	add	ix,sp
	ld	e,(ix+2)	;len
	ld	d,(ix+3)
	ld	a,d
	or	e
	jr	nz,write1
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
	ret	c		;it went okay
	sbc	hl,de		;gives number written
#endasm
}


