;
;	clock() for the ABC80
;
;
; ------
; $Id: clock.asm,v 1.3 2016-03-05 00:07:01 dom Exp $
;

	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,(65008)
	ld	a,(65010)
	ld	e,a
	ld	d,0
	ret
