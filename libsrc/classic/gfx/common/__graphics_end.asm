

    SECTION code_graphics
    PUBLIC  __graphics_end

    EXTERN  __gfx_vram_page_out
    INCLUDE "classic/gfx/grafix.inc"


__graphics_end:
IFDEF _gfx_vram_page
    call    __gfx_vram_page_out
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
