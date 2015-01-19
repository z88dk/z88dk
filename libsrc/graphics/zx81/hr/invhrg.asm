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
;	$Id: invhrg.asm,v 1.2 2015-01-19 01:32:52 pauloscustodio Exp $
;

                PUBLIC	invhrg
				
				EXTERN	HRG_LineStart

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
