    MODULE  generic_console_scrollup
    SECTION code_driver

    PUBLIC  generic_console_scrollup

    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr
    EXTERN  __sam_MODE3_attr
    EXTERN  __sam_MODE4_attr
    EXTERN  __zx_scrollup
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    EXTERN  SCREEN_BASE
    EXTERN  l_dcal


generic_console_scrollup:
    push    de
    push    bc
    call    __sam_graphics_pagein
    ld      a,(__zx_screenmode)
    add     a
    add     +(scrollup_table % 256)
    ld      l,a
    ld      a,0
    adc     +(scrollup_table / 256)
    ld      h,a
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    call    l_dcal
    call    __sam_graphics_pageout
    pop     bc
    pop     de
    ret

scrollup_MODE2:
    ld      hl,SCREEN_BASE + 256
    ld      de,SCREEN_BASE
    ld      bc,6144 - 256
    ldir
    ld      h,d
    ld      l,e
    inc     de
    ld      (hl),0
    ld      bc,256
    ldir
    ld      hl,SCREEN_BASE + 8192 + 256
    ld      de,SCREEN_BASE + 8192
    ld      bc,6144 - 256
    ldir
    ld      h,d
    ld      l,e
    inc     de
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ld      bc,256
    ldir
    ret



scrollup_MODE4:
    ld      a,(__sam_MODE4_attr+1)          ;Paper, in bits 6,7
    ld      b,a
    rrca
    rrca
    rrca
    rrca
    and     15
    or      b
    jr      scrollup
scrollup_MODE3:
    ld      a,(__sam_MODE3_attr+1)          ;Paper, in bits 6,7
    ld      b,a
    xor     a
    or      b
    srl     a
    srl     a
    or      b
    ld      b,a
    and     a
    rrca
    rrca
    rrca
    rrca
    or      b
scrollup:
    ld      hl,SCREEN_BASE + 1024
    ld      de,SCREEN_BASE
    ld      bc,24576 - 1024
    ld      (hl),0
    ldir
    ld      h,d
    ld      l,e
    inc     de
    ld      bc,1023
    ld      (hl),a
    ldir
    ret


    SECTION rodata_driver

scrollup_table:
    defw    __zx_scrollup
    defw    scrollup_MODE2
    defw    scrollup_MODE3
    defw    scrollup_MODE4
