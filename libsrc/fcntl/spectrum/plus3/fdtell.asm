;
; long fdtell(int fd)
;
; Return position in file
;
; Not written as yet!
;
; $Id: fdtell.asm,v 1.2 2003-01-28 15:45:04 dom Exp $

		XLIB	fdtell

		XREF	dodos

.fdtell
	pop	hl	;ret address
	pop	bc	;lower 8 is file handle
	push	bc
	push	hl
	ld	b,c
	ld	iy,307	;DOS_GET_POSITION
	call	dodos
	ld	d,0
	ret	c
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret
