;
;	clock()
;
;
; ------
; $Id: clock.asm,v 1.1 2010-05-31 10:32:57 stefano Exp $
;

	XLIB	clock

.clock
	ld	hl,($3C2B)
	ld	de,($3C2D)
	ret
