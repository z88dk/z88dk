	SECTION code_clib	
	PUBLIC	scroll_bkg
	PUBLIC	_scroll_bkg
	
        include "macros.inc"
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

    setVDPReg       $89, a  ; Output to VDP register 9 (Y Scroll)
	ld	a, (hl)		; X
    setVDPReg       $88, a  ; Output to VDP register 8 (X Scroll)

	ret
