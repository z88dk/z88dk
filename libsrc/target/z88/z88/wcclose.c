
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
	pop	hl	;handle
	push	hl
	push	bc
	push	ix
	push	hl
	pop	ix
	call_oz(gn_wcl)
	pop	ix
	ld	hl,0	;closed okay
	ret	nc
	dec	hl	;-1 if error
#endasm
}
