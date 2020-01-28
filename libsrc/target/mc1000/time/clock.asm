;
;	CCE MC-1000 clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm,v 1.4 2016-06-12 17:02:26 dom Exp $
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
