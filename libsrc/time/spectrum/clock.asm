;
;	clock()
;	Goodness knows it this is right..ages since
;	I used a spectrum...
;
;	djm 12/1/2000
;
; ------
; $Id: clock.asm,v 1.5 2016-06-10 21:14:50 dom Exp $
;

	SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,(23672)
	ld	a,(23674)
	ld	e,a
	ld	d,0
	ret
