

    MODULE  generic_console_vpeek
    SECTION code_clib
    PUBLIC  generic_console_vpeek

    EXTERN  generic_console_xypos
    EXTERN  generic_console_font32
    EXTERN  generic_console_udg32
    EXTERN  screendollar
    EXTERN  screendollar_with_count
    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1

generic_console_vpeek:
    ld      hl, -8
    add     hl, sp
    ld      sp, hl
    push    hl                          ;save buffer
    ex      de, hl
    call    generic_console_xypos
    call    swapgfxbk
        ; hl = screen address, de = buffer
    ld      a, 8
loop:
    ex      af, af
    ld      a, (hl)
    ld      (de), a
    inc     de
    ld      bc, 64
    add     hl, bc
    ex      af, af
    dec     a
    jr      nz, loop
    call    swapgfxbk1
    pop     de                          ;buffer
    ld      hl, (generic_console_font32)
    call    screendollar
    jr      nc, gotit
    ld      hl, (generic_console_udg32)
    ld      b, 128
    call    screendollar_with_count
    jr      c, gotit
    add     128
gotit:
    ex      af, af
    ld      hl, 8
    add     hl, sp
    ld      sp, hl
    ex      af, af
    ret
