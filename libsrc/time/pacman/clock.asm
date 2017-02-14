;
;	PacMan clock()
;
;	Stefano 2017
;
; ------
; $Id:$
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
