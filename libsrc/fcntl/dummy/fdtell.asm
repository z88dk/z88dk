; $Id: fdtell.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	fdtell

.fdtell
	ld	hl,-1	;return -1
	ld	d,h
	ld	e,l
	ret

