;
; lseek:  ..see fdgetpos and fdtell !
;
; Stefano - 5/7/2006
;
;
; $Id: lseek.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	lseek
	PUBLIC	_lseek

.lseek
._lseek
	ld	hl,-1	;non zero is error
	ld	d,h
	ld	e,l
	ret
