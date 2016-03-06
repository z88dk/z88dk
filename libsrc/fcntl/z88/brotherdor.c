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
 * $Id: brotherdor.c,v 1.5 2016-03-06 20:36:12 dom Exp $
 */

#include <z88.h>

int brotherdor(int handle, char *type)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	hl
	push	hl
	push	de
	push	ix	;callers ix
	push	hl
	pop	ix
	ld	a,dr_sib
	call_oz(os_dor)
	pop	de
	pop	hl
	ld	(hl),a	;store minor type
	push	hl
	push	de
	push	ix
	pop	hl	;return SON dor
	pop	ix	;callers ix
#endasm
}

