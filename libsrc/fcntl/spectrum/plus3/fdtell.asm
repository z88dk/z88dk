;
; long fdtell(int fd)
;
; Return position in file
;
; Not written as yet!
;
; $Id: fdtell.asm,v 1.3 2003-10-10 11:05:02 dom Exp $

		XLIB	fdtell

	        INCLUDE "#p3dos.def"

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
