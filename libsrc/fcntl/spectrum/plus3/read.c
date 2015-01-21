/*
 *	Read bytes from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: read.c,v 1.6 2015-01-21 08:27:13 stefano Exp $
 */

#include <fcntl.h>

size_t read(int handle, void *buf, size_t len)
{
#asm
	INCLUDE	"p3dos.def"
	EXTERN	dodos
	ld	ix,0
	add	ix,sp
	ld	e,(ix+2)	;len
	ld	d,(ix+3)
	ld	a,d
	or	e
	jr	nz,read1
	ex	de,hl		;len=0 return 0
	ret
.read1
	ld	l,(ix+4)	;buf
	ld	h,(ix+5)
	ld	b,(ix+6)	;handle
	ld	c,0		;page FIXME
	push	de
	ld	iy,DOS_READ
	call	dodos
	pop	hl		;bytes we wanted to write
	ret	c		;It was okay, we read them all
	sbc	hl,de		;gives number written
#endasm
}


