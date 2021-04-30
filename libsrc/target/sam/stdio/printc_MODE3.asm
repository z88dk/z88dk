    MODULE _printc_MODE3
    PUBLIC  printc_MODE3


    EXTERN  __sam_xypos_MODE3
    EXTERN  __sam_MODE3_attr
    EXTERN  SCREEN_BASE
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES
    defc __subtype_protection = THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES

;Mode 3: 4 pixels per byte
;p0 p0 p1 p1 p2 p2 p3 p3
; Entry:  b = y
;         c = x
;       hl' = font entry to print
;        c' = inverse mask
;        b' = flags
printc_MODE3:
    call    __sam_xypos_MODE3
    call    __sam_graphics_pagein
    ld      b,8
printc_MODE3_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_MODE3_no_underline
    cp      1
    jr      nz,printc_MODE3_no_underline
    ld      a,255
    jr      printc_MODE3_not_bold
printc_MODE3_no_underline:
    ld      a,(hl)
    bit     4,b
    ld      a,(hl)
    jr      z,printc_MODE3_not_bold
    rrca
    or      (hl)
printc_MODE3_not_bold:
    xor     c
    inc     hl
    exx

    ld      b,2
printc_MODE3_2:
    ld      de,(__sam_MODE3_attr)    ;e = ink, b = paper
    push    bc
    push    hl
    ld      l,a
    ld      b,4    ;4 iterations
    ld      c,0    ;final byte
printc_MODE3_3:
    rl      l
    ld      a,d
    jr      nc,is_paper
    ld      a,e
is_paper:
    or      c
    ld      c,a
    srl     d
    srl     d
    srl     e
    srl     e
    djnz    printc_MODE3_3
    ld      a,l    ;Save the character for a moment
    pop     hl
    ld      (hl),c
    inc     hl
    pop     bc
    djnz    printc_MODE3_2
    ld      de,128 - 2
    add     hl,de
    pop     bc
    djnz    printc_MODE3_1
    call    __sam_graphics_pageout
    ret

