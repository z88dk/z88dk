
/*
 *	Strip device from filespec
 *
 *	GWL 26/3/00
 */

#include <z88.h>

char *stripdev(char *fspec)
{
#asm
	pop	bc
	pop	hl		; fspec
	push	hl
	push	bc
	ld	a,(hl)
	inc	hl
	cp	':'
	jr	nz,nostrip	; exit with original pointer if no device
.skipdev
	ld	a,(hl)
	inc	hl
	cp	'/'
	ret	z		; exit if first segment finished
	cp	$5c
	ret	z		; ditto
	and	a
	jr	nz,skipdev
.nostrip
	dec	hl		; if end, backup to terminator
#endasm
}
