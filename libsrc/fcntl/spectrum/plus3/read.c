/*
 *	Read bytes from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: read.c,v 1.7 2016-03-07 13:44:48 dom Exp $
 */

#include <fcntl.h>

size_t read(int handle, void *buf, size_t len)
{
#asm
	INCLUDE	"p3dos.def"
	EXTERN	dodos
	push	ix		;save callers
	ld	ix,2
	add	ix,sp
	ld	e,(ix+2)	;len
	ld	d,(ix+3)
	ld	a,d
	or	e
	jr	nz,read1
	pop	ix		;restore
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
	pop	ix		;restore
	ret	c		;It was okay, we read them all
	sbc	hl,de		;gives number written
#endasm
}


