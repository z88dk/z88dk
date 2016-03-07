;
; long fdtell(int fd)
;
; Return position in file
;
; Not written as yet!
;
; $Id: fdtell.asm,v 1.7 2016-03-07 13:44:48 dom Exp $

		SECTION	code_clib
		PUBLIC	fdtell

	        INCLUDE "p3dos.def"

		EXTERN	dodos

.fdtell
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
