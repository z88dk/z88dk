;
;	Grundy NewBrain clock()
;
;	stefano 5/4/2007
;
; ------
; $Id: clock.asm,v 1.1 2007-05-17 16:25:53 stefano Exp $
;

	XLIB	clock
	XREF	nbclock

.clock
	ld	hl,(nbclock)
	ld	de,(nbclock+2)
	ret
