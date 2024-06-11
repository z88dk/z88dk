
; Optimization option to the w_pixeladdress 
; based generic GFX library


PUBLIC __generic_w_incx

SECTION code_graphics


__generic_w_incx:
    inc hl
	inc de
	ret
