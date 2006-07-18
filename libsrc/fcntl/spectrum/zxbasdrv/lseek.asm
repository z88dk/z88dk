;
; lseek:  ..see fdgetpos and fdtell !
;
; Stefano - 5/7/2006
;
;
; $Id: lseek.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $

	XLIB	lseek

.lseek
	ld	hl,-1	;non zero is error
	ld	d,h
	ld	e,l
	ret
