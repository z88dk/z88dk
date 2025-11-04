


    SECTION code_graphics
    PUBLIC  clg
    PUBLIC  _clg
    PUBLIC  ___clg
    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  cleargraphics
    INCLUDE "graphics/grafix.inc"


clg:
_clg:
___clg:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
ENDIF
IFDEF _GFX_PAGE_VRAM
    call    swapgfxbk
ENDIF
    call    cleargraphics
IF  _GFX_PAGE_VRAM
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
