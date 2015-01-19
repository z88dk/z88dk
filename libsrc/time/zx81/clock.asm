;
;	ZX81 clock() function
;	By Stefano Bodrato - Oct. 2011
;	Back to default FRAMES counter + 1 extra byte ;)
;
; --------
; $Id: clock.asm,v 1.9 2015-01-19 01:33:25 pauloscustodio Exp $


	PUBLIC	clock
;	XREF	frames3
	EXTERN	_FRAMES

.clock
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
