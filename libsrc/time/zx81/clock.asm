;
;	ZX81 clock() function
;	By Stefano Bodrato - Oct. 2007
;	New version based on custom interrupt driver
;	(doesn't work in FAST MODE)
;
; --------
; $Id: clock.asm,v 1.5 2007-10-04 10:28:48 stefano Exp $


	XLIB	clock
	XREF	frames

.clock

	ld	hl,(frames)
	ld	a,(frames+1)
	ld	e,a
	ld	d,0
	ret
