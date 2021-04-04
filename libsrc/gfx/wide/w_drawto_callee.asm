; ----- void __CALLEE__ drawto_callee(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  drawto_callee
    PUBLIC  _drawto_callee
    PUBLIC  asm_drawto

    EXTERN  swapgfxbk
    EXTERN  w_line
    EXTERN  w_plotpixel
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


.drawto_callee
._drawto_callee
    pop     af
    pop     de
    pop     hl
    push    af

.asm_drawto
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      ix,w_plotpixel
    call    w_line
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

ENDIF
