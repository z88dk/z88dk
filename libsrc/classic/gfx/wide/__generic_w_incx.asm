
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
    ld      hl,(__generic_w_curx)
    ld      de,8
    add     hl,de
    ld      (__generic_w_curx),hl
    ld      de,(__generic_w_cury)
    call	w_pixeladdress		; bitpos0 = pixeladdress(x,y)
    ld      h,d
    ld      l,e
    ;pop de
ENDIF

    pop af
    ret

