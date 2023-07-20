
    SECTION code_clib

    PUBLIC  copy_font_8x8

    EXTERN  CRT_FONT
    EXTERN  __CLIB_FONT_HEIGHT


; Copy font in PCG area
; Entry: c = number of characters
;       de = address to copy from
;       hl = address for PCG
;
;
; PCG takes 16 bytes, for an 8x8 we want to pad 1 at top, 7 at bottom
copy_font_8x8:
copy_1:
    push    bc
    call    filltop
    ld      b,__CLIB_FONT_HEIGHT
copy_2:
    ld      a,(de)
    ld      (hl),a
    inc     c
    inc     de
    inc     hl
    djnz    copy_2
    call    fillbottom
    pop     bc
    dec     c
    jr      nz,copy_1
    ret

filltop:
    ld      c,0
    ld      a,__CLIB_FONT_HEIGHT
    cp      8
    ret     nz
    ld      a,1
    jr      fill_loop

fillbottom:
    ld      a,16
    sub     c
    ret     c
fill_loop:
    and     a
    ret     z
    ld      (hl),0
    inc     hl
    inc     c
    dec     a
    jr      fill_loop
