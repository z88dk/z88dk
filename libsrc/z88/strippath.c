
/*
 *	Strip path from filespec
 *
 *	GWL 26/3/00
 */

#include <z88.h>

char *strippath(char *fspec)
{
#asm
	pop	bc
	pop	hl		; fspec
	push	hl
	push	bc
.newseg
	ld	d,h		; DE=current segment start
	ld	e,l
.findseg
	ld	a,(hl)
	inc	hl
	cp	'/'
	jr	z,newseg	; back to save next segment start
	cp	$5c
	jr	z,newseg	; ditto
	and	a
	jr	nz,findseg
	ex	de,hl		; HL=pointer to final segment
#endasm
}
