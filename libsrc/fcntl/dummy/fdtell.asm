; $Id: fdtell.asm,v 1.1 2001-05-01 13:55:21 dom Exp $

	XLIB	fdtell

.fdtell
	ld	hl,-1	;return -1
	ld	d,h
	ld	e,l
	ret

