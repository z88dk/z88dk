
/*
 *	Close a wild card handler
 *
 *	djm 22/3/2000
 */

#include <z88.h>

int wcclose(wild_t handle)
{
#asm
	INCLUDE	"fileio.def"
	pop	bc
	pop	ix	;handle
	push	ix
	push	bc
	call_oz(gn_wcl)
	ld	hl,0	;closed okay
	ret	nc
	dec	hl	;-1 if error
#endasm
}
