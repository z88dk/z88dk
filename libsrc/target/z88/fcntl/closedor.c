/*
 *	Close a DOR
 *
 *	void closedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: closedor.c,v 1.5 2016-03-06 20:36:12 dom Exp $
 */

#include <z88.h>

void closedor(int handle)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	hl
	push	hl
	push	de
	push	ix	;save caller
	push	hl
	pop	ix
	ld	a,dr_fre
	call_oz(os_dor)
	pop	ix
#endasm
}

