

    SECTION code_graphics
    PUBLIC  __graphics_end

    EXTERN  __gfx_page_vram_out
    INCLUDE "graphics/grafix.inc"


__graphics_end:
IFDEF _GFX_PAGE_VRAM
    call    __gfx_page_vram_out
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
