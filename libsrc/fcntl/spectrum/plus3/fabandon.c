/*
 *	Abandon a file (+3 DOS)
 *
 *	30/4/2001 djm
 *
 *	$Id: fabandon.c,v 1.1 2001-05-01 13:55:21 dom Exp $
 */

#include <stdio.h>
#include <spectrum.h>



void fabandon(FILE *fp)
{
	fabandon1(fp->desc.fd);
	fp->desc.fd=0;
	fp->flags=0;
	fp->ungetc=0;
}

int fabandon1(int fd)
{
#asm
	XREF	dodos
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,l
	push	bc
	ld	iy,268	;DOS_ABANDON
	call	dodos
	pop	de
	ld	hl,-1	;error!
	ret	nc	;error
	ex	de,hl
	call	freehand
	ld	hl,0
#endasm
}


