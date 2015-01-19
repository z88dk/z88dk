; $Id: lseek.asm,v 1.2 2015-01-19 01:32:43 pauloscustodio Exp $

	PUBLIC	lseek

.lseek
	ld	hl,1	;non zero is error
	ld	d,h
	ld	e,l
	ret
