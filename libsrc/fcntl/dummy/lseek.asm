; $Id: lseek.asm,v 1.4 2016-03-06 21:39:54 dom Exp $

                SECTION code_clib

	PUBLIC	lseek
	PUBLIC	_lseek

.lseek
._lseek
	ld	hl,1	;non zero is error
	ld	d,h
	ld	e,l
	ret
