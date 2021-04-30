; void xordrawb_callee(int tlx, int tly, int width, int height)

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xordrawb_callee
    PUBLIC  _xordrawb_callee
    
    PUBLIC  asm_xordrawb
    
    EXTERN  w_xorpixel
    EXTERN  drawbox
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.xordrawb_callee
._xordrawb_callee
    pop     af
    pop     de
    pop     hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af    ; ret addr
    exx
    
.asm_xordrawb
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      ix,w_xorpixel
    call    drawbox

IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
    pop     ix
    ret
ENDIF
ENDIF
