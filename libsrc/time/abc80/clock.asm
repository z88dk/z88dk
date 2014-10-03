;
;	clock() for the ABC80
;
;
; ------
; $Id: clock.asm,v 1.1 2014-10-03 14:11:04 stefano Exp $
;

	XLIB	clock

.clock
	ld	hl,(65008)
	ld	a,(65010)
	ld	e,a
	ld	d,0
	ret
