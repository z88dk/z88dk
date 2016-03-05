;
;	CCE MC-1000 clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm,v 1.3 2016-03-05 00:07:01 dom Exp $
;

	PUBLIC	clock
	PUBLIC	_clock
	EXTERN	FRAMES

.clock
._clock
	ld	hl,(FRAMES)
	ld	de,(FRAMES+2)
	ret
