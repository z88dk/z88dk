; ----- void __CALLEE__ drawr(int x2, int y2)

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  drawr_callee
    PUBLIC  _drawr_callee
    
    PUBLIC  asm_drawr

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    
    EXTERN  Line_r
    EXTERN  plotpixel
    INCLUDE "graphics/grafix.inc"


.drawr_callee
._drawr_callee    
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    af    ; ret addr
    
.asm_drawr
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      ix,plotpixel
    call    Line_r
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

ENDIF
