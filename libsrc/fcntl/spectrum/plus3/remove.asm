;
;	z88dk - Spectrum +3 stdio Library
;
;	djm 10/4/2000
;
;	int remove(far char *name)
;
;	Being on a +3 we ignore the far stuff
;
;	$Id: remove.asm,v 1.2 2003-10-10 11:05:02 dom Exp $


		XLIB	remove
		XREF	dodos
		INCLUDE	"#p3dos.def"


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

	



