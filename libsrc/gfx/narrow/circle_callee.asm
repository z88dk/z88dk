; Usage: circle(int x, int y, int radius, int skip);


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION    code_graphics

    PUBLIC    circle_callee
    PUBLIC    _circle_callee

    PUBLIC    asm_circle

    EXTERN    draw_circle
    EXTERN    plotpixel

    EXTERN    swapgfxbk
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"

    
.circle_callee
._circle_callee
    pop     af
    pop     de    ; skip
    pop     bc    ;radius
    ld      d,c
    pop     bc    ; y
    pop     hl    ; x
    ld      b,l
    push    af

    push    ix


.asm_circle
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld      hl,plotpixel
    call    draw_circle
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
ENDIF
