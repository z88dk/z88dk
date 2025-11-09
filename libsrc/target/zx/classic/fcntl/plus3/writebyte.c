/*
 *	Write byte to file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *		    c = byte to write
 *
 *	$Id: writebyte.c,v 1.5 2015-01-21 08:27:13 stefano Exp $
 */

#include <fcntl.h>

int writebyte(int handle, int byte)
{
#asm
	INCLUDE "target/zx/def/p3dos.def"
	EXTERN	dodos
	pop	bc
	pop	hl	;byte
	pop	de	;handle
	push	de
	push	hl
	push	bc
	ld	c,l	;byte
	ld	b,e	;file handle
	push	bc	;keep byte
	push	ix
	ld	ix,DOS_BYTE_WRITE
	call	dodos
	pop	ix
	pop	bc
	ld	hl,-1	;EOF
	ccf
	ret	c	;error
	ld	l,c
	ld	h,0
#endasm
}
