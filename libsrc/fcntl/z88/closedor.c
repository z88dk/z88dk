/*
 *	Close a DOR
 *
 *	void closedor(int handle)
 *
 *	djm 13/3/2000
 */

#include <z88.h>

void closedor(int handle)
{
#asm
	INCLUDE	"#dor.def"
	pop	de
	pop	ix
	push	ix
	push	de
	ld	a,DR_Fre
	call_oz(os_dor)
#endasm
}

