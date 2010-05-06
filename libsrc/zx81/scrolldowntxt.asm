;
;       ZX81 libraries
;
;--------------------------------------------------------------
; Text scrolldown.
; Doesn't directly set the current cursor position
;--------------------------------------------------------------
;
;       $Id: scrolldowntxt.asm,v 1.1 2010-05-06 14:42:38 stefano Exp $
;
;----------------------------------------------------------------

        XLIB    scrolldowntxt

scrolldowntxt:
	ld	hl,(16396)
	ld	bc,33*24
	add	hl,bc
	ld	de,33
	push hl
	add hl,de
	pop de
	ex de,hl
	lddr
	xor a
	ld b,32
blankline:
	inc hl
	ld (hl),a
	djnz blankline
	ret
