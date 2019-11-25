/*
 *	Close a DOR
 *
 *	void sondor(int handle, char *type)
 *
 *	Returns son of current dor (old dor invalid)
 *
 *	djm 13/3/2000
 *
 * -----
 * $Id: sondor.c,v 1.5 2016-03-06 20:36:13 dom Exp $
 */


#include <z88.h>

int sondor(int handle, char *type)
{
#asm
	INCLUDE	"dor.def"
	pop	de
	pop	hl
	push	hl
	push	de
	push	ix		;save caller
	push	hl
	pop	ix
	ld	a,dr_son
	call_oz(os_dor)
	pop	bc	
	pop	de
	pop	hl
	ld	(hl),a	;store minor type
	push	hl
	push	de
	push	bc
	push	ix
	pop	hl	;return SON dor
	pop	ix	;old ix
#endasm
}

