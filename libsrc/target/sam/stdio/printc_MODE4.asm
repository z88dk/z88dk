    MODULE _printc_MODE4
    PUBLIC  printc_MODE4

    EXTERN  __sam_xypos_MODE4
    EXTERN  __sam_MODE4_attr
    EXTERN  SCREEN_BASE
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES
    defc __subtype_protection = THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES

; Mode 4: 16 colours per pixel
; p0 p0 p0 p0 p1 p1 p1 p1
; Entry:  b = y
;         c = x
;       hl' = font entry to print
;        c' = inverse mask
;        b' = flags
printc_MODE4:
    call    __sam_xypos_MODE4
    call    __sam_graphics_pagein
    ld      b,8
printc_MODE4_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_MODE4_no_underline
    cp      1
    jr      nz,printc_MODE4_no_underline
    ld      a,255
    jr      printc_MODE4_not_bold
printc_MODE4_no_underline:
    ld      a,(hl)
    bit     4,b
    jr      z,printc_MODE4_not_bold
    rrca
    or      (hl)
printc_MODE4_not_bold:
    xor     c
    inc     hl
    exx
    
    ex      af,af
    ld      a,4
    ld      de,(__sam_MODE4_attr)    ;e = ink, d = paper
printc_MODE4_2:
    ex      af,af
    ; We have two pixels per byte, so lets unroll a bit

    rlca            ;Do we need ink or paper?
    ld      c,d     ;paper
    jr      nc,printc_MODE4_is_paper
    ld      c,e    ;ink
printc_MODE4_is_paper:
    rlca            ;Get the next pixel
    ld      b,a     ;Save the rest of char line
    ld      a,d
    jr      nc,printc_MODE4_is_paper2
    ld      a,e    ;ink
printc_MODE4_is_paper2:
    rrca
    rrca
    rrca
    rrca
    and     0x0f
    or      c
    ld      (hl),a
    inc     hl
    ld      a,b
    ex      af,af
    dec     a
    jp      nz,printc_MODE4_2
    ld      de,128 - 4
    add     hl,de
    pop     bc
    djnz    printc_MODE4_1
    call    __sam_graphics_pageout
    ret

