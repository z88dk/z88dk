/*
 *	Close a DOR
 *
 *	void deletedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: deletedor.c,v 1.5 2016-03-06 20:36:12 dom Exp $
 */

#include <z88.h>

void deletedor(int handle)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	hl
	push	hl
	push	de
	push	ix
	push	hl
	pop	ix
	ld	a,dr_del
	call_oz(os_dor)
#endasm
}

