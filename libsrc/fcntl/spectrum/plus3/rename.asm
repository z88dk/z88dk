
;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int rename(char *source, char *dest)
;
;	$Id: rename.asm,v 1.2 2003-10-10 11:05:02 dom Exp $


		XLIB	rename
		XREF	dodos

		INCLUDE "#p3dos.def"


.rename
	pop	bc
	pop	de	;new filename
	pop	hl	;old
	push	hl
	push	de
	push	bc
	ld	iy,DOS_RENAME
	call	dodos
	ld	hl,0
	ret	c	;OK
	dec	hl
	ret
