;
;	CCE OSCA clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm,v 1.2 2015-01-19 01:33:24 pauloscustodio Exp $
;

	PUBLIC	clock
	EXTERN	FRAMES

.clock
	ld	hl,(FRAMES)
	ld	de,(FRAMES+2)
	ret
