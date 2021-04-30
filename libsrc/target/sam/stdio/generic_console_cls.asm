    MODULE  generic_console_cls
    SECTION code_driver

    PUBLIC  generic_console_cls

    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr
    EXTERN  __sam_MODE3_attr
    EXTERN  __sam_MODE4_attr
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout
    EXTERN  l_dcal
    EXTERN  SCREEN_BASE


generic_console_cls:
    call    __sam_graphics_pagein
    ld      a,(__zx_screenmode)
    add     a
    add     +(cls_table % 256)
    ld      l,a
    ld      a,0
    adc     +(cls_table / 256)
    ld      h,a
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    call    l_dcal
    call    __sam_graphics_pageout
    ret

cls_MODE1:
    ld      hl,SCREEN_BASE
    ld      de,SCREEN_BASE+1
    ld      bc,6144
    ld      (hl),0
    ldir
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ld      bc,767
    ldir
    ret

cls_MODE2:
    ld      hl,SCREEN_BASE
    ld      de,SCREEN_BASE+1
    ld      bc,6143
    ld      (hl),0
    ldir
    ld      hl,SCREEN_BASE + 8192
    ld      de,SCREEN_BASE + 8192 + 1
    ld      bc,6143
    ld      a,(__zx_console_attr)
    ld      (hl),a
    ldir
    ret


cls_MODE4:
    ld      a,(__sam_MODE4_attr+1)          ;Paper, in bits 6,7
    ld      b,a
    rrca
    rrca
    rrca
    rrca
    and     15
    or      b
    jr      clear_block

cls_MODE3:
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
clear_block:
    ld      hl,SCREEN_BASE
    ld      de,SCREEN_BASE+1
    ld      bc,24575
    ld      (hl),a
    ldir
    ret

    SECTION rodata_driver

cls_table:
    defw    cls_MODE1
    defw    cls_MODE2
    defw    cls_MODE3
    defw    cls_MODE4


