;
;       ZX81 libraries
;
;--------------------------------------------------------------
; Text scrollup.
; Doesn't directly set the current cursor position
;--------------------------------------------------------------
;
;       $Id: scrolluptxt.asm,v 1.2 2015-01-19 01:33:26 pauloscustodio Exp $
;
;----------------------------------------------------------------

        PUBLIC    scrolluptxt

scrolluptxt:
	ld	hl,(16396)
	push hl
	ld de,33
	add hl,de
	pop de
	ld	bc,33*23
	ldir
	xor a
	ld b,32
blankline:
	inc de
	ld (de),a
	djnz blankline
	ret
