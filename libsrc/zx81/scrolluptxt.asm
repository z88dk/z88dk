;
;       ZX81 libraries
;
;--------------------------------------------------------------
; Text scrollup.
; Doesn't directly set the current cursor position
;--------------------------------------------------------------
;
;       $Id: scrolluptxt.asm,v 1.3 2015-08-07 06:23:58 stefano Exp $
;
;----------------------------------------------------------------

        PUBLIC    scrolluptxt

scrolluptxt:
IF FORlambda
	ld	hl,16509
ELSE
	ld	hl,(16396)	; D_FILE
ENDIF
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
