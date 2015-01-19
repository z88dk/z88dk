;
; long fdtell(int fd)
;
; Return position in file
;
; Not written as yet!
;
; $Id: fdtell.asm,v 1.5 2015-01-19 01:32:43 pauloscustodio Exp $

		PUBLIC	fdtell

	        INCLUDE "p3dos.def"

		XREF	dodos

.fdtell
	pop	hl	;ret address
	pop	bc	;lower 8 is file handle
	push	bc
	push	hl
	ld	b,c
	ld	iy,DOS_GET_POSITION
	call	dodos
	ld	d,0
	ret	c
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
