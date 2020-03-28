;
;       Galaksija libraries
;
;--------------------------------------------------------------
; Text scrollup.
; Doesn't directly set the current cursor position
;--------------------------------------------------------------
;
;       $Id: scrolluptxt.asm $
;
;----------------------------------------------------------------

        SECTION code_clib
        PUBLIC    scrolluptxt
        PUBLIC    _scrolluptxt

scrolluptxt:
_scrolluptxt:
	ld	hl,$2800
	push hl
	ld de,32
	add hl,de
	pop de
	ld	bc,32*15
	ldir
	ld a,32
	ld b,a
blankline:
	ld (de),a
	inc de
	djnz blankline
	ret
