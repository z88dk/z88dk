

    SECTION code_graphics
    PUBLIC  generic_console_cls

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out

generic_console_cls:
    call    __gfx_vram_page_in
    ld      hl, 0
    ld      de, 1
    ld      bc, 32767
    ld      (hl), 0                     ; TODO - as colour??
    ldir
    call    __gfx_vram_page_out
    ret
