;
;	ZX81 clock() function
;	By Stefano Bodrato - Oct. 2011
;	Back to default FRAMES counter + 1 extra byte ;)
;
; --------
; $Id: clock.asm,v 1.7 2012-12-31 10:38:23 stefano Exp $


	XLIB	clock
;	XREF	frames3

.clock
IF FORzx81
	ld	hl,-1
	ld	de,($4034)
	and a
	sbc hl,de
ELSE
	ld	hl,($401E)
ENDIF
	ld	de,0
	ret
