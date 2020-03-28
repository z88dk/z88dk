;
;	clock()
;
;
; ------
; $Id: clock.asm,v 1.4 2016-06-12 17:02:26 dom Exp $
;

        SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

.clock
._clock
	ld	hl,($3C2B)
	ld	de,($3C2D)
	ret
