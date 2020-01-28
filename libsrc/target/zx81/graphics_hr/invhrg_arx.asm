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
;	$Id: invhrg_arx.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		SECTION code_clib
                PUBLIC	invhrg
                PUBLIC	_invhrg
				
		EXTERN	HRG_LineStart

invhrg:
_invhrg:
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
