/*
 *	Read byte from file (+3DOS)
 *
 *	18/3/2000 djm
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: readbyte.c,v 1.7 2016-03-07 13:44:48 dom Exp $
 */

#include <fcntl.h>

int __FASTCALL__ readbyte(int handle)
{
#asm
	INCLUDE	"p3dos.def"
	EXTERN	dodos
	pop	bc	;for FASTCALL parameter is pushed on entry
	push	bc
	ld	b,c	;file handle
	ld	iy,DOS_BYTE_READ	
	call	dodos
	ld	hl,-1	;EOF
	ccf
	jr	c,end	;error
	ld	l,c
	ld	h,0
.end
#endasm
}
