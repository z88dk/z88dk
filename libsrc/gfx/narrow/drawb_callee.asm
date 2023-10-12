;
;     Z88 Graphics Functions - Small C+ stubs
;
;     Written around the Interlogic Standard Library
;
;
; ----- void __CALLEE__ drawb(int x, int y, int h, int v)
;
;    $Id: drawb_callee.asm $
;


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  drawb_callee
        PUBLIC  _drawb_callee

        PUBLIC  asm_drawb

        EXTERN  drawbox
        EXTERN  plotpixel
        EXTERN  swapgfxbk
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"


drawb_callee:
_drawb_callee:
        pop     af
        pop     bc                      ; height
        pop     de
        ld      b, e                    ; width
        pop     hl                      ; x
        pop     de
        ld      h, e                    ; y
        push    af

asm_drawb:
        push    ix
        ld      ix, plotpixel
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    drawbox
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF
  ENDIF
