; Usage: circle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__


    SECTION code_graphics
    
    PUBLIC  circle_callee
    PUBLIC  _circle_callee
    
    PUBLIC  asm_circle

    EXTERN  w_draw_circle
    EXTERN  w_plotpixel
    
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.circle_callee
._circle_callee

;      de = x0, hl = y0, bc = radius, a = skip

    pop     af
    ex      af,af

    pop     de    ; skip
    ld      a,e
    pop     bc    ;radius
    pop     hl    ; y
    pop     de    ; x
    ex      af,af
    push    af
    ex      af,af

.asm_circle
    push    ix
    push    af
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    pop     af
    ld      ix,w_plotpixel
    call    w_draw_circle
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop    ix
  ENDIF
    ret
ENDIF
ENDIF
