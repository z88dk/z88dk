

    SECTION code_graphics
    PUBLIC  __graphics_end

    EXTERN  swapgfxbk1
    INCLUDE "graphics/grafix.inc"


__graphics_end:
IFDEF _GFX_PAGE_VRAM
    call    swapgfxbk1
ENDIF
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
