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
 * $Id: brotherdor.c,v 1.4 2014-04-11 11:14:00 stefano Exp $
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
	ld	a,dr_sib
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

