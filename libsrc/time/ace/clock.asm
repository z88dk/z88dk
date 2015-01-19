;
;	clock()
;
;
; ------
; $Id: clock.asm,v 1.2 2015-01-19 01:33:24 pauloscustodio Exp $
;

	PUBLIC	clock

.clock
	ld	hl,($3C2B)
	ld	de,($3C2D)
	ret
