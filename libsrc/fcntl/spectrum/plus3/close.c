/*
 *	Close a file (+3 DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: close.c,v 1.1 2001-05-01 13:55:21 dom Exp $
 */

#include <fcntl.h>
#include <spectrum.h>



int close(int handle)
{
#asm
	XREF	dodos
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,l
	push	bc
	ld	iy,265	;DOS_CLOSE
	call	dodos
	pop	de
	ld	hl,-1	;error!
	ret	nc	;error
	ex	de,hl
	call	freehand
	ld	hl,0
#endasm
}


