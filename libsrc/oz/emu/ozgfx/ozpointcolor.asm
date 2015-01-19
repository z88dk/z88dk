;
;	OZ-7xx DK emulation layer for Z88DK
;	by Stefano Bodrato - Oct. 2003
;
;	"set color" self modifying code service routine
;	sets the AND/OR/XOR mode
;	0 = white
;	1 = black
;	2 = xor
;
; ------
; $Id: ozpointcolor.asm,v 1.2 2015-01-19 01:33:01 pauloscustodio Exp $
;

	PUBLIC	ozpointcolor

        EXTERN     ozplotpixel
        EXTERN	put_instr


.ozpointcolor
		ld	a,(ix+2)
		ld	hl,put_instr
		and	3		;WHITE ?
		jr	nz,nowhite
		ld	a,$2f		;CPL
		ld	(hl),a
		inc	hl
		ld	a,$a6		;AND (HL)
		ld	(hl),a
		ret
.nowhite	dec	a		;BLACK ?
		jr	nz,noblack
		ld	(hl),a		;NOP
		inc	hl
		ld	a,$b6		;OR (HL)
		ld	(hl),a
		ret
.noblack	dec	a		;XOR mode ?
		ret	nz		;Mode 3 unknown
		ld	(hl),a		;NOP
		inc	hl
		ld	a,$ae		;XOR (HL)
		ld	(hl),a
		ret
