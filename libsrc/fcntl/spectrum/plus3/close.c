/*
 *	Close a file (+3 DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: close.c,v 1.2 2003-10-10 11:05:02 dom Exp $
 */

#include <fcntl.h>
#include <spectrum.h>



int close(int handle)
{
#asm
        INCLUDE "#p3dos.def"
	XREF	dodos
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,l
	push	bc
	ld	iy,DOS_CLOSE
	call	dodos
	pop	de
	ld	hl,-1	;error!
	ret	nc	;error
	ex	de,hl
	call	freehand
	ld	hl,0
#endasm
}


