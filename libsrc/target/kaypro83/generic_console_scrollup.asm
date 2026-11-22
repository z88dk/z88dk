
    SECTION code_graphics
    PUBLIC  generic_console_scrollup

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    EXTERN  clsgraph


    EXTERN  CONSOLE_ROWS
    EXTERN  CONSOLE_COLUMNS

    defc    DISPLAY=$3000
    defc    pagein=__gfx_vram_page_in
    defc    pageout=__gfx_vram_page_out


generic_console_scrollup:
    push    de
    push    bc
    call    pagein
    ld      hl, DISPLAY+128
    ld      de, DISPLAY
    ld      bc, +((128)*(CONSOLE_ROWS-1))
    ldir
    ex      de, hl
    ld      b, CONSOLE_COLUMNS
generic_console_scrollup_3:
    ld      (hl), 32
    inc     hl
    djnz    generic_console_scrollup_3
    call    pageout
    pop     bc
    pop     de
    ret
