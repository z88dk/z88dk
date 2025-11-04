

    SECTION code_graphics
    PUBLIC  generic_console_cls

    EXTERN  __gfx_page_vram_in
    EXTERN  __gfx_page_vram_out

generic_console_cls:
    call    __gfx_page_vram_in
    ld      hl, 0
    ld      de, 1
    ld      bc, 32767
    ld      (hl), 0                     ; TODO - as colour??
    ldir
    call    __gfx_page_vram_out
    ret
