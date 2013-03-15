;
;	CCE MC-1000 clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm,v 1.1 2013-03-15 17:33:41 stefano Exp $
;

	XLIB	clock
	XREF	FRAMES

.clock
	ld	hl,(FRAMES)
	ld	de,(FRAMES+2)
	ret
