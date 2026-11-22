

    SECTION code_graphics
    PUBLIC  generic_console_cls

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

    EXTERN  __bdos

generic_console_cls:
    call    __gfx_vram_page_in
    ld      hl, 0
    ld      de, 1
    ld      bc, +(80*200)-1
    ld      (hl), 0
    ldir
    call    __gfx_vram_page_out
    ret
