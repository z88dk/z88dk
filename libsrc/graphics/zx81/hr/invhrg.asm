;--------------------------------------------------------------
; WRX16K style Graphics
; for the ZX81
;--------------------------------------------------------------
;
;       Invert screen output
;
;       Stefano - Jan 2009
;
;
;	$Id: invhrg.asm,v 1.1 2010-02-03 11:08:15 stefano Exp $
;

                XLIB	invhrg
				
				XREF	HRG_LineStart

invhrg:
		ld	b,32
		ld	hl,HRG_LineStart
		inc	hl
invloop:
		inc	hl
		ld	a,(hl)
		xor	128
		ld	(hl),a
		djnz invloop
		ret
