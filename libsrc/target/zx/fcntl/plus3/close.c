/*
 *	Close a file (+3 DOS)
 *
 *	18/3/2000 djm
 *
 *	$Id: close.c,v 1.6 2016-03-07 13:44:48 dom Exp $
 */

#include <fcntl.h>
#include <spectrum.h>

extern void __LIB__ freehand(int);

int close(int handle)
{
#asm
        INCLUDE "target/zx/def/p3dos.def"
	EXTERN	dodos
	pop	bc
	pop	hl
	push	hl
	push	bc
	ld	b,l
	push	hl
	push	ix
	ld	ix,DOS_CLOSE	;corrupts ix
	call	dodos
	pop	ix
	pop	de
	ld	hl,-1	;error!
	ret	nc	;error
	ex	de,hl
	call	freehand
	ld	hl,0
#endasm
}


