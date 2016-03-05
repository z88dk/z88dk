;
;	Grundy NewBrain clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.4 2016-03-05 00:07:01 dom Exp $
;

	PUBLIC	clock
	PUBLIC	_clock
	EXTERN	nbclockptr

.clock
._clock
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
