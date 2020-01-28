;
;	PC-8801 clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm $
;

	SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock
	EXTERN	FRAMES

.clock
._clock
	ld	hl,(FRAMES)
	ld	de,(FRAMES+2)
	ret
