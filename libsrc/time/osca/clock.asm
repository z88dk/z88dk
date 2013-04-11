;
;	CCE OSCA clock()
;
;	Stefano 2013
;
; ------
; $Id: clock.asm,v 1.1 2013-04-11 16:44:55 stefano Exp $
;

	XLIB	clock
	XREF	FRAMES

.clock
	ld	hl,(FRAMES)
	ld	de,(FRAMES+2)
	ret
