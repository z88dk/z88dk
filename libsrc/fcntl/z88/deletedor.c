/*
 *	Close a DOR
 *
 *	void deletedor(int handle)
 *
 *	djm 13/3/2000
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

