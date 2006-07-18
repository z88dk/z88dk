;
; fdtell:  ..see fdgetpos !
;
; Stefano - 5/7/2006
;
;
; $Id: fdtell.asm,v 1.1 2006-07-18 21:02:54 stefano Exp $


	XLIB	fdtell

.fdtell
	ld	hl,-1
	ld	d,h
	ld	e,l
	ret

