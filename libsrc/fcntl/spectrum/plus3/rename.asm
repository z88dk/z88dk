
;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int rename(char *source, char *dest)
;
;	$Id: rename.asm,v 1.5 2016-03-07 13:44:48 dom Exp $


		SECTION	code_clib
		PUBLIC	rename
		EXTERN	dodos

		INCLUDE "p3dos.def"


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
