;
;	Philips P2000 clock() function
;	By Stefano Bodrato - Apr. 2014
;
;   20ms pulses counter
;
; --------
; $Id: clock.asm,v 1.2 2015-01-19 01:33:24 pauloscustodio Exp $


	PUBLIC	clock

.clock
	ld	hl,($6010)
	ld	de,0
	ret
