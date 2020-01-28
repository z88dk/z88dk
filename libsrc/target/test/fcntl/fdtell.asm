; $Id: fdtell.asm,v 1.4 2016-03-06 21:39:54 dom Exp $

                SECTION code_clib

	PUBLIC	fdtell
	PUBLIC	_fdtell

.fdtell
._fdtell
	ld	hl,-1	;return -1
	ld	d,h
	ld	e,l
	ret

