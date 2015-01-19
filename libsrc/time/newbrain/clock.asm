;
;	Grundy NewBrain clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.3 2015-01-19 01:33:24 pauloscustodio Exp $
;

	PUBLIC	clock
	EXTERN	nbclockptr

.clock
	ld	hl,(nbclockptr)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	h,b
	ld	l,c
	ret
