
    MODULE  conio_vars

    SECTION data_clib
    PUBLIC  __rx78_ink
    PUBLIC  __rx78_paper

__rx78_ink: 
    defb    0x07
__rx78_paper:   
    defb    0x00



    SECTION code_crt_init

    ld      hl, initial_palette
    ld      b, 8
pal_loop:
    ld      a,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    out     (c),a
    djnz    pal_loop

    SECTION rodata_clib
initial_palette:
    defb    0x11, 0xf5
    defb    0x22, 0xf6
    defb    0x44, 0xf7
    defb    0x11, 0xf8
    defb    0x22, 0xf9
    defb    0x44, 0xfa
    defb    0xff, 0xfb
    defb    0x00, 0xfc
    defb    @00111111, 0xfe
