; void fillb_callee(int tlx, int tly, int width, int height)


  IF    !__CPU_INTEL__&!__CPU_GBZ80__

        SECTION code_graphics

        PUBLIC  fillb_callee
        PUBLIC  _fillb_callee

        PUBLIC  asm_fillb

        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        EXTERN  fillarea
        INCLUDE "graphics/grafix.inc"


fillb_callee:
_fillb_callee:
        pop     af                      ; ret addr
        pop     bc                      ; y2
        pop     hl
        ld      b, l                    ; x2
        pop     hl                      ; y
        pop     de
        ld      h, e                    ; x
        push    af                      ; ret addr
asm_fillb:
        push    ix
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    fillarea
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF

  ENDIF
