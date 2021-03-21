    

    MODULE  __zx_vpeek
    SECTION code_driver

    PUBLIC  __zx_vpeek

    EXTERN  __zx_gencon_xy_to_dfaddr
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __console_w
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  __zx_64col_font
    EXTERN  __zx_screenmode
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout

    EXTERN  generic_console_zxn_tile_vpeek


__zx_vpeek:
IF FORzxn
    ld      a,(__zx_screenmode)
    bit     6,a
    jp      nz,generic_console_zxn_tile_vpeek
ENDIF
    ld      hl,-8
    add     hl,sp        ;de = screen, hl = buffer, bc = coords
    ld      sp,hl
IF FORts2068 | FORzxn
    ld      a,(__zx_screenmode)
    cp      6
    jr      nz,standard_screen
    ld      a,(__console_w)
    cp      128
    jr      z,handle_64col
    jr      continue
standard_screen:
ENDIF
    ld      a,(__console_w)
    cp      32
    jr      nz,handle_64col
continue:
    push    hl          ;Save buffer
    ex      de,hl       ;get it into de
    call    __zx_gencon_xy_to_dfaddr
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    ld      b,8
vpeek_1:
    ld      a,(hl)
    ld      (de),a
    inc     h
    inc     de
    djnz    vpeek_1
    pop     de        ;the buffer on the stack
    ld      hl,(__zx_32col_font)
do_screendollar:
IF FORsam
    call    __sam_graphics_pageout
ENDIF
    call    screendollar
    jr      nc,gotit
    ld      hl,(__zx_32col_udgs)
    ld      b,128
    call    screendollar_with_count
    jr      c,gotit
    add     128
gotit:
    ex      af,af        ; Save those flags
    ld      hl,8        ; Dump our temporary buffer
    add     hl,sp
    ld      sp,hl
    ex      af,af        ; Flags and parameter back
    ret

handle_64col:
    ; hl = buffer
    ; bc = coordinates
    push    hl        ;save buffer
    ex      de,hl
    srl     c
    ex      af,af        ;save flags
    call    __zx_gencon_xy_to_dfaddr
    ;hl = screen
    ex      de,hl        ;de = screen, hl=buffer
    ex      af,af
    ld      c,0xf0
    jr      nc,even_column
    ld      c,0x0f
even_column:
IF FORsam
    call    __sam_graphics_pagein
ENDIF
    ld      b,8
vpeek_2:
    ld      a,(de)
    and     c
    ld      (hl),a
    rrca
    rrca
    rrca
    rrca
    or      (hl)
    ld      (hl),a
    inc     hl
    inc     d
    djnz    vpeek_2
    pop     de        ;buffer
    ld      hl,(__zx_64col_font)
    jr      do_screendollar
