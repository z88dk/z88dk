;
; lseek:  ..see fdgetpos and fdtell !
;
; Stefano - 5/7/2006
;
;
; $Id: lseek.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $

	PUBLIC	lseek

.lseek
	ld	hl,-1	;non zero is error
	ld	d,h
	ld	e,l
	ret
