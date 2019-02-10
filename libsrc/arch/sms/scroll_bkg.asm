	SECTION code_clib	
	PUBLIC	scroll_bkg
	PUBLIC	_scroll_bkg
	
;==============================================================
; void scroll_bkg(int x, int y)
;==============================================================
; Scrolls the bkg map to the specified position
;==============================================================
.scroll_bkg
._scroll_bkg
	ld	hl, 2
	add	hl, sp
	ld	a, (hl)		; Y
	inc	hl
	inc	hl
        out	($bf),a		; Output to VDP register 9 (Y Scroll)
        ld	a,$89
        out	($bf),a
	ld	a, (hl)		; X
        out	($bf),a		; Output to VDP register 8 (X Scroll)
        ld	a,$88
        out	($bf),a
	ret
