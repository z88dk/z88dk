;
;	Philips P2000 clock() function
;	By Stefano Bodrato - Apr. 2014
;
;   20ms pulses counter
;
; --------
; $Id: clock.asm,v 1.3 2016-03-05 00:07:01 dom Exp $


	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,($6010)
	ld	de,0
	ret
