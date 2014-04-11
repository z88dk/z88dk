/*
 *	Close a DOR
 *
 *	void deletedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: deletedor.c,v 1.4 2014-04-11 11:14:00 stefano Exp $
 */

#include <z88.h>

void deletedor(int handle)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	ix
	push	ix
	push	de
	ld	a,dr_del
	call_oz(os_dor)
#endasm
}

