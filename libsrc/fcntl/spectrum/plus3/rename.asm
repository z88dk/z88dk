
;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int rename(char *source, char *dest)
;
;	$Id: rename.asm,v 1.1 2001-05-01 13:55:21 dom Exp $


		XLIB	rename
		XREF	dodos


.rename
	pop	bc
	pop	de	;new filename
	pop	hl	;old
	push	hl
	push	de
	push	bc
	ld	iy,295	;DOS_RENAME
	call	dodos
	ld	hl,0
	ret	c	;OK
	dec	hl
	ret
