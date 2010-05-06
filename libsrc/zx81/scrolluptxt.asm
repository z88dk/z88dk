;
;       ZX81 libraries
;
;--------------------------------------------------------------
; Text scrollup.
; Doesn't directly set the current cursor position
;--------------------------------------------------------------
;
;       $Id: scrolluptxt.asm,v 1.1 2010-05-06 14:42:38 stefano Exp $
;
;----------------------------------------------------------------

        XLIB    scrolluptxt

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
