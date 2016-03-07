;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int remove(far char *name)
;
;	Being on a +3 we ignore the far stuff
;
;	$Id: remove.asm,v 1.5 2016-03-07 13:44:48 dom Exp $


		SECTION	code_clib
		PUBLIC	remove
		EXTERN	dodos
		INCLUDE	"p3dos.def"


.remove
	pop	bc
	pop	hl	;filename
	push	hl
	push	bc
	ld	iy,DOS_DELETE
	call	dodos
	ld	hl,0
	ret	c	;OK
	dec	hl
	ret

	



