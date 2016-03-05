; $Id: fdtell.asm,v 1.3 2016-03-05 00:13:02 dom Exp $

	PUBLIC	fdtell
	PUBLIC	_fdtell

.fdtell
._fdtell
	ld	hl,-1	;return -1
	ld	d,h
	ld	e,l
	ret

