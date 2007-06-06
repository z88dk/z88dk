;
;	Grundy NewBrain clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.2 2007-06-06 08:43:47 stefano Exp $
;

	XLIB	clock
	XREF	nbclockptr

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
