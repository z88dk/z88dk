;
;      Z88 Graphics Functions
;      Written around the Interlogic Standard Library
;
;      Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;    $Id: w_drawto_callee.asm $
;

; ----- void __CALLEE__ drawto_callee(int x, int y)


IF !__CPU_INTEL__
    SECTION code_graphics
    PUBLIC drawto_callee
    PUBLIC _drawto_callee
    PUBLIC ASMDISP_DRAWTO_CALLEE

    EXTERN    swapgfxbk
    ;EXTERN    swapgfxbk1
    ;    EXTERN    __gfx_color
    EXTERN    w_line
    EXTERN    w_plotpixel
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"


.drawto_callee
._drawto_callee

   pop af
;   pop bc
   pop de
   pop hl
   push af

.asmentry
;    ld    a,c
;    ld    (__gfx_color),a
    push ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    ld     ix,w_plotpixel
    call    w_line
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_DRAWTO_CALLEE = asmentry - drawto_callee
ENDIF
