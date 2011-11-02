;
;	ZX81 clock() function
;	By Stefano Bodrato - Oct. 2011
;	Back to default FRAMES counter + 1 extra byte ;)
;
; --------
; $Id: clock.asm,v 1.6 2011-11-02 14:24:33 stefano Exp $


	XLIB	clock
;	XREF	frames3

.clock
	ld	hl,-1
	ld	de,($4034)
	and a
	sbc hl,de
	ld	de,0
	ret
