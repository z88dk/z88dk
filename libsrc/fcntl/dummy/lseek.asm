; $Id: lseek.asm,v 1.3 2016-03-05 00:13:02 dom Exp $

	PUBLIC	lseek
	PUBLIC	_lseek

.lseek
._lseek
	ld	hl,1	;non zero is error
	ld	d,h
	ld	e,l
	ret
