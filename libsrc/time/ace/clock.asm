;
;	clock()
;
;
; ------
; $Id: clock.asm,v 1.3 2016-03-05 00:07:01 dom Exp $
;

	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,($3C2B)
	ld	de,($3C2D)
	ret
