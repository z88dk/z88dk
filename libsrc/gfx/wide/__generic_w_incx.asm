
;

PUBLIC __generic_w_incx

EXTERN __generic_w_curx
EXTERN __generic_w_cury

EXTERN  w_pixeladdress

SECTION code_graphics


__generic_w_incx:
    push    af

IF  !__CPU_INTEL__&!__CPU_GBZ80__
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
ENDIF

    pop af
    ret

