/*
 *	Close a DOR
 *
 *	void closedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: closedor.c,v 1.4 2014-04-11 11:14:00 stefano Exp $
 */

#include <z88.h>

void closedor(int handle)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	ix
	push	ix
	push	de
	ld	a,dr_fre
	call_oz(os_dor)
#endasm
}

