;--------------------------------------------------------------
; ARX816 style Graphics
; for the ZX81
;--------------------------------------------------------------
;
;       Invert screen output
;
;       Stefano - Oct 2011
;
;
;	$Id: invhrg_arx.asm,v 1.2 2015-01-19 01:32:52 pauloscustodio Exp $
;

                PUBLIC	invhrg
				
				EXTERN	HRG_LineStart

invhrg:
		ld	hl,HRG_LineStart
		ld	c,2
invhrg2:
		ld	b,32
invloop:
		ld	a,(hl)
		xor	128
		ld	(hl),a
		inc	hl
		djnz invloop
		inc hl
		ld	b,32
		dec c
		jr	nz,invhrg2
		ret
