; ----- void __CALLEE__ xordrawr_callee(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  xordrawr_callee
    PUBLIC  _xordrawr_callee
    PUBLIC  asm_xordrawr
    
    EXTERN  swapgfxbk
    EXTERN  w_line_r
    EXTERN  w_xorpixel
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"


.xordrawr_callee
._xordrawr_callee
    pop     af
    pop     de
    pop     hl
    push    af

.asm_xordrawr
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      ix,w_xorpixel
    call    w_line_r
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
    pop     ix
    ret
ENDIF
ENDIF
