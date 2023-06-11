
;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int rename(char *source, char *dest)
;
;	$Id: rename.asm,v 1.6 2017-01-02 21:02:22 aralbrec Exp $


		SECTION	code_clib
		PUBLIC	rename
      PUBLIC   _rename
		EXTERN	dodos

		INCLUDE "target/zx/def/p3dos.def"


.rename
._rename
	pop	bc
	pop	de	;new filename
	pop	hl	;old
	push	hl
	push	de
	push	bc
	push	ix
	ld	ix,DOS_RENAME
	call	dodos
	pop	ix
	ld	hl,0
	ret	c	;OK
	dec	hl
	ret
