
PUBLIC __generic_w_incx
PUBLIC __generic_w_curx
PUBLIC __generic_w_cury

EXTERN  w_pixeladdress

SECTION code_graphics


__generic_w_incx:
    push    af
    ;push    de
    ld      hl,(curx)
    ld      de,8
    add     hl,de
    ld      (curx),hl
    ld      de,(cury)
    call	w_pixeladdress		; bitpos0 = pixeladdress(x,y)
    ld      h,d
    ld      l,e
    ;pop de
    pop af
	ret


	SECTION		bss_graphics
__generic_w_curx:	defw 0
__generic_w_cury:	defw 0
