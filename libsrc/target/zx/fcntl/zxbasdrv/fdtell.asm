;
; fdtell:  ..see fdgetpos !
;
; Stefano - 5/7/2006
;
;
; $Id: fdtell.asm,v 1.3 2016-06-23 20:40:25 dom Exp $

	SECTION code_clib
	PUBLIC	fdtell
	PUBLIC	_fdtell

.fdtell
._fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

