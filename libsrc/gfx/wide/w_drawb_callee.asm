; void drawb(int tlx, int tly, int width, int height)
IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  drawb_callee
    PUBLIC  _drawb_callee
    PUBLIC  asm_drawb
    
    EXTERN  w_plotpixel
    EXTERN  drawbox

    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.drawb_callee
._drawb_callee

    pop     af
    
    pop     de
    pop     hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    
    push    af    ; ret addr
    
    exx
    
.asm_drawb
    
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF    
    ld      ix,w_plotpixel
    call    drawbox

    jp      __graphics_end
ENDIF
