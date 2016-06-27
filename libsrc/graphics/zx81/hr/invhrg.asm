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
;	$Id: invhrg.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		SECTION code_clib
                PUBLIC	invhrg
                PUBLIC	_invhrg
				
		EXTERN	HRG_LineStart

invhrg:
_invhrg:
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
