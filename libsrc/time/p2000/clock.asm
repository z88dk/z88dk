;
;	Philips P2000 clock() function
;	By Stefano Bodrato - Apr. 2014
;
;   20ms pulses counter
;
; --------
; $Id: clock.asm,v 1.1 2014-04-18 07:38:59 stefano Exp $


	XLIB	clock

.clock
	ld	hl,($6010)
	ld	de,0
	ret
