/*
 *	Read byte from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: readbyte.c,v 1.2 2003-01-28 15:45:09 dom Exp $
 */

#include <fcntl.h>

int __FASTCALL__ readbyte(int handle)
{
#asm
	XREF	dodos
	pop	bc	;for FASTCALL parameter is pushed on entry
	push	bc
	ld	b,c	;file handle
	ld	iy,280	;DOS_BYTE_READ
	call	dodos
	ld	hl,-1	;EOF
	ccf
	ret	c	;error
	ld	l,c
	ld	h,0
#endasm
}
