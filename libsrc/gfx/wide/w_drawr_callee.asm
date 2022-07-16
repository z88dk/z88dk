; ----- void __CALLEE__ drawr_callee(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee
    PUBLIC  asm_drawr
    
    EXTERN  swapgfxbk
    EXTERN  w_line_r
    EXTERN  w_plotpixel
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


.drawr_callee
._drawr_callee

    pop     af
    pop     de
    pop     hl
    push    af

.asm_drawr
    push ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      ix,w_plotpixel
    call    w_line_r
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

ENDIF
