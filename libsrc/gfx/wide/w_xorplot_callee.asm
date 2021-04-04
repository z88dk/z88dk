; ----- void  xorplot(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xorplot_callee
    PUBLIC  _xorplot_callee
    PUBLIC  asm_xorplot
   
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    EXTERN  w_xorpixel
    INCLUDE "graphics/grafix.inc"


.xorplot_callee
._xorplot_callee
    pop     bc
    pop     de    ; y
    pop     hl    ; x
    push    bc

.asm_xorplot
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    call    w_xorpixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
    pop     ix
    ret
ENDIF
ENDIF
