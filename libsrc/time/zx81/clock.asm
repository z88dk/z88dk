;
;	ZX81 clock() function
;	By Stefano Bodrato - Oct. 2011
;	Back to default FRAMES counter + 1 extra byte ;)
;
; --------
; $Id: clock.asm,v 1.12 2016-07-14 17:44:18 pauloscustodio Exp $


        SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock
;	EXTERN	frames3
	EXTERN	_FRAMES

.clock
._clock
IF FORzx81
	ld	hl,-1
	;ld	de,($4034)
	ld	de,(_FRAMES)
	and a
	sbc hl,de
ELSE
	;ld	hl,($401E)
	ld	hl,(_FRAMES)
ENDIF
	ld	de,0
	ret
