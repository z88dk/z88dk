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
 *	$Id: writebyte.c,v 1.1 2001-05-01 13:55:21 dom Exp $
 */

#include <fcntl.h>

int writebyte(int handle, int byte)
{
#asm
	XREF	dodos
	pop	bc
	pop	hl	;byte
	pop	de	;handle
	push	de
	push	hl
	push	bc
	ld	c,l	;byte
	ld	b,e	;file handle
	ld	iy,283	;DOS_BYTE_WRITE
	push	bc	;keep byte
	call	dodos
	pop	bc
	ld	hl,-1	;EOF
	ret	nc	;error
	ld	l,c
	ld	h,0
#endasm
}
