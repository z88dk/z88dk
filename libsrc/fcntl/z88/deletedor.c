/*
 *	Close a DOR
 *
 *	void deletedor(int handle)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: deletedor.c,v 1.2 2001-04-18 14:59:40 stefano Exp $
 */

#include <z88.h>

void deletedor(int handle)
{
#asm
	INCLUDE	"#dor.def"
	pop	de
	pop	ix
	push	ix
	push	de
	ld	a,DR_Del
	call_oz(os_dor)
#endasm
}

