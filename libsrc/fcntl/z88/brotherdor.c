/*
 *	Close a DOR
 *
 *	void brotherdor(int handle, char *type)
 *
 *	Returns son of current dor (old dor invalid)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: brotherdor.c,v 1.3 2013-03-03 23:51:10 pauloscustodio Exp $
 */

#include <z88.h>

int brotherdor(int handle, char *type)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	ix
	push	ix
	push	de
	ld	a,DR_Sib
	call_oz(os_dor)
	pop	de
	pop	hl
	ld	(hl),a	;store minor type
	push	hl
	push	de
	push	ix
	pop	hl	;return SON dor
#endasm
}

