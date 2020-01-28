;
;	clock() for the ABC80
;
;
; ------
; $Id: clock.asm,v 1.4 2016-06-12 17:02:26 dom Exp $
;

        SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,(65008)
	ld	a,(65010)
	ld	e,a
	ld	d,0
	ret
