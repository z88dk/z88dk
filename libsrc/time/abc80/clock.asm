;
;	clock() for the ABC80
;
;
; ------
; $Id: clock.asm,v 1.2 2015-01-19 01:33:24 pauloscustodio Exp $
;

	PUBLIC	clock

.clock
	ld	hl,(65008)
	ld	a,(65010)
	ld	e,a
	ld	d,0
	ret
