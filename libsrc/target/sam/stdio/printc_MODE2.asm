    MODULE printc_MODE2
    PUBLIC printc_MODE2


    EXTERN  __zx_console_attr
    EXTERN  SCREEN_BASE
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout

    EXTERN  THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES
    defc __subtype_protection = THIS_FUNCTION_ONLY_WORKS_WITH_RAM_SUBTYPES

; Mode 2 linear 32x192, attributes +8k
; Entry:  b = y
;         c = x
;       hl' = font entry to print
;        c' = inverse mask
;        b' = flags
printc_MODE2:
    ; Each character row is 8*32 = 256 bytes
    ld      a,+(SCREEN_BASE / 256)
    add     b
    ld      h,a
    ld      l,c
    call    __sam_graphics_pagein
    ld      de,32
    ld      a,(__zx_console_attr)
    ld      c,a
    ld      b,8
print32_loop:
    exx
    bit     4,b
    ld      a,(hl)
    jr      z,no_32_bold
    rrca
    or      (hl)
no_32_bold:
    xor     c
    inc     hl
    exx
    ld      (hl),a
    set     5,h
    ld      (hl),c
    res     5,h
    add     hl,de
    djnz    print32_loop
handle_attributes:
    ; hl holds address of line of character below, lets go back
    exx
    bit     3,b
    jr      z,mode2_end
    exx
    and     a
    sbc     hl,de
    ld      a,255
    ld      (hl),a
mode2_end:
    call    __sam_graphics_pageout
    ret
