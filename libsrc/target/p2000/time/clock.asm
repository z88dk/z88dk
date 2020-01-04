;
;	Philips P2000 clock() function
;	By Stefano Bodrato - Apr. 2014
;
;   20ms pulses counter
;
; --------
; $Id: clock.asm,v 1.4 2016-06-12 17:02:26 dom Exp $

        SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,($6010)
	ld	de,0
	ret
