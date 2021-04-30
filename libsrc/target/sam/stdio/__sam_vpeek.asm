; vpeek() for the Sam Coupe
;
; As with other targets, this won't work if the background isn't palette 0

    MODULE  __zx_vpeek
    SECTION code_driver
    PUBLIC  __sam_vpeek
    EXTERN  __zx_vpeek

    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  __zx_screenmode
    EXTERN  __sam_xypos_MODE3
    EXTERN  __sam_xypos_MODE4
    EXTERN  __sam_graphics_pagein
    EXTERN  __sam_graphics_pageout



    EXTERN  SCREEN_BASE


__sam_vpeek:
    ld      a,(__zx_screenmode)
    and     a
    jp      z,__zx_vpeek            ; Just use the regular +zx code
    ld      hl,-8
    add     hl,sp        ;de = screen, hl = buffer, bc = coords
    ld      sp,hl
    push    hl          ;Save buffer
    ex      de,hl       ;get it into de
    dec     a
    jp      z,vpeek_MODE2
    dec     a
    jr      z,vpeek_MODE3
    ; Lets handle mode 4 here
    call    __sam_xypos_MODE4
    call    __sam_graphics_pagein
    ld      b,8
vpeek_MODE4_row_loop:
    push    bc
    push    de      ;Save buffer
    ld      d,@10000000
    ld      c,0     ;Resultant byte
    ld      a,4     ;4 bytes to do
vpeek_MODE4_loop:
    ex      af,af
    ld      a,(hl)
    and     @11110000
    jr      z,first_nibble_not_set
    ld      a,c
    or      d
    ld      c,a
first_nibble_not_set:
    srl     d
    ld      a,(hl)
    and     @00001111
    jr      z,second_nibble_not_set
    ld      a,c
    or      d
    ld      c,a
second_nibble_not_set:
    srl     d
    inc     hl
    ex      af,af
    dec     a
    jr      nz,vpeek_MODE4_loop
    pop     de
    ld      a,c
    ld      (de),a
    inc     de
    ld      bc,128 - 4
    add     hl,bc
    pop     bc
    djnz    vpeek_MODE4_row_loop
 
do_screendollar:
    call    __sam_graphics_pageout
    pop     de        ;the buffer on the stack
    ld      hl,(__zx_32col_font)
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

vpeek_MODE3:
    call    __sam_xypos_MODE3
    call    __sam_graphics_pagein
    ld      b,8
vpeek_MODE3_row_loop:
    push    bc
    push    de      ;Save buffer
    ld      d,@10000000
    ld      c,0     ;Resultant byte
    ld      a,2     ;We need to do this loop twice
vpeek_MODE3_loop_2:
    ex      af,af
    ld      e,@11000000
    ld      b,4         ;4 interations
vpeek_MODE3_loop_3:
    ld      a,(hl)
    and     e
    jr      z,MODE3_not_set
    ld      a,c
    or      d
    ld      c,a
MODE3_not_set:
    srl     d
    srl     e
    srl     e
    djnz    vpeek_MODE3_loop_3
    inc     hl
    ex      af,af
    dec     a
    jr      nz,vpeek_MODE3_loop_2
    pop     de      ;Buffer
    ld      a,c
    ld      (de),a
    inc     de
    ld      bc,128 - 2
    add     hl,bc
    pop     bc
    djnz    vpeek_MODE3_row_loop
    jr      do_screendollar

vpeek_MODE2:
    ; Each character row is 8*32 = 256 bytes
    ld      a,+(SCREEN_BASE / 256)
    add     b
    ld      h,a
    ld      l,c
    call    __sam_graphics_pagein
    ld      b,8
vpeek_MODE2_loop:
    ld      a,(hl)
    ld      (de),a
    inc     de
    ld      a,32
    add     l
    ld      l,a
    ld      a,h
    adc     0
    ld      h,a
    djnz    vpeek_MODE2_loop
    jr      do_screendollar
