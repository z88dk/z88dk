;
; long fdtell(int fd)
;
; Return position in file
;
; Not written as yet!
;
; $Id: fdtell.asm,v 1.8 2017-01-02 21:02:22 aralbrec Exp $

		SECTION	code_clib
		PUBLIC	fdtell
      PUBLIC   _fdtell

	        INCLUDE "p3dos.def"

		EXTERN	dodos

.fdtell
._fdtell
	pop	hl	;ret address
	pop	bc	;lower 8 is file handle
	push	bc
	push	hl
	push	ix
	ld	b,c
	ld	iy,DOS_GET_POSITION	;corrupts ix
	call	dodos
	pop	ix
	ld	d,0
	ret	c
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
