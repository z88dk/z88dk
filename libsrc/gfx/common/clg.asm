 


    SECTION        code_graphics
    PUBLIC    clg
    PUBLIC    _clg
    EXTERN    swapgfxbk
    EXTERN	__graphics_end

    EXTERN    cleargraphics
    INCLUDE "graphics/grafix.inc"


.clg
._clg
IF !__CPU_INTEL__ & !__CPU_GBZ80__
    push	ix
ENDIF
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF 
    call    cleargraphics
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
