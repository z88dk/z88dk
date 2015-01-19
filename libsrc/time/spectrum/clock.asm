;
;	clock()
;	Goodness knows it this is right..ages since
;	I used a spectrum...
;
;	djm 12/1/2000
;
; ------
; $Id: clock.asm,v 1.3 2015-01-19 01:33:25 pauloscustodio Exp $
;

	PUBLIC	clock

.clock
	ld	hl,(23672)
	ld	a,(23674)
	ld	e,a
	ld	d,0
	ret
