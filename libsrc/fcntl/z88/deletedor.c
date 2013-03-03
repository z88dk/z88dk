/*
 *	Close a DOR
 *
 *	void deletedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: deletedor.c,v 1.3 2013-03-03 23:51:10 pauloscustodio Exp $
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
	ld	a,DR_Del
	call_oz(os_dor)
#endasm
}

