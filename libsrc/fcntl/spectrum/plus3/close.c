/*
 *	Close a file (+3 DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: close.c,v 1.3 2003-10-12 12:44:23 dom Exp $
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
	push	hl
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


