;
;      Z88 Graphics Functions
;      Written around the Interlogic Standard Library
;
;      Wide resolution (int type parameters) and CALLEE conversion by Stefano Bodrato, 2018
;

;
;    $Id: w_drawr_callee.asm $
;

; ----- void __CALLEE__ drawr_callee(int x, int y)


IF !__CPU_INTEL__
    SECTION code_graphics
    PUBLIC drawr_callee
    PUBLIC _drawr_callee
    PUBLIC ASMDISP_DRAWR_CALLEE

    EXTERN    swapgfxbk
    ;EXTERN    swapgfxbk1
;    EXTERN    __gfx_color
    EXTERN    w_line_r
    EXTERN    w_plotpixel
    EXTERN    __graphics_end
    INCLUDE "graphics/grafix.inc"


.drawr_callee
._drawr_callee

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
    ld      ix,w_plotpixel
    call    w_line_r
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF

DEFC ASMDISP_DRAWR_CALLEE = asmentry - drawr_callee
ENDIF
