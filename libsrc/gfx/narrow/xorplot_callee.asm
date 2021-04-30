; ----- void  xorplot(int x, int y)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorplot_callee
    PUBLIC  _xorplot_callee
    PUBLIC  asm_xorplot
    
    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  xorpixel
    INCLUDE "graphics/grafix.inc"



.xorplot_callee
._xorplot_callee
    pop     af    ; ret addr
    pop     hl    ; y
    pop     de    ; x
    ld      h,e
    push    af    ; ret addr

.asm_xorplot
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    call    xorpixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop    ix
  ENDIF
    ret
ENDIF
ENDIF
