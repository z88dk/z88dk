; $Id: lseek.asm,v 1.1 2001-05-01 13:55:21 dom Exp $

	XLIB	lseek

.lseek
	ld	hl,1	;non zero is error
	ld	d,h
	ld	e,l
	ret
