;
;	clock()
;	Goodness knows it this is right..ages since
;	I used a spectrum...
;
;	djm 12/1/2000
;
; ------
; $Id: clock.asm,v 1.2 2001-04-18 12:40:07 stefano Exp $
;

	XLIB	clock

.clock
	ld	hl,(23672)
	ld	a,(23674)
	ld	e,a
	ld	d,0
	ret
