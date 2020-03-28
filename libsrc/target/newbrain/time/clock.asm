;
;	Grundy NewBrain clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.5 2016-06-12 17:02:26 dom Exp $
;

        SECTION code_clib
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
