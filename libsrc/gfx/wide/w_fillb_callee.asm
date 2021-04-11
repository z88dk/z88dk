; void fillb(int tlx, int tly, int width, int height)
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee
    
    PUBLIC  asm_fillb
   
    EXTERN  w_plotpixel
    EXTERN  w_area

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.fillb_callee
._fillb_callee
    pop     af
    pop     de
    pop     hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af    ; ret addr
    exx
    
.asm_fillb
    
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    ld      ix,w_plotpixel
    call    w_area

IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
ENDIF
