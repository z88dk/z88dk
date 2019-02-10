;
;       Galaksija libraries
;
;----------------------------------------------------------------
;
; $Id: scrolldowntxt.asm $
;
;----------------------------------------------------------------
; Text scrolldown.
;----------------------------------------------------------------

        SECTION code_clib
    PUBLIC   scrolldowntxt
    PUBLIC   _scrolldowntxt

scrolldowntxt:
_scrolldowntxt:
	ld	hl,$2800
	ld	bc,32*16
	add	hl,bc
	ld	de,32
	push hl
	add hl,de
	pop de
	ex de,hl
	lddr
	xor a
	ld b,16
blankline:
	inc hl
	ld (hl),a
	djnz blankline
	ret
