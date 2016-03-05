;
;	clock()
;	Goodness knows it this is right..ages since
;	I used a spectrum...
;
;	djm 12/1/2000
;
; ------
; $Id: clock.asm,v 1.4 2016-03-05 00:07:01 dom Exp $
;

	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,(23672)
	ld	a,(23674)
	ld	e,a
	ld	d,0
	ret
