; ----- void __CALLEE__ undrawr_callee(int x2, int y2)


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  undrawr_callee
        PUBLIC  _undrawr_callee
        PUBLIC  asm_undrawr

        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        EXTERN  Line_r
        EXTERN  respixel
        INCLUDE "graphics/grafix.inc"


undrawr_callee:
_undrawr_callee:
        pop     af                      ; ret addr
        pop     de                      ; y
        pop     hl                      ; x
        push    af                      ; ret addr

asm_undrawr:
        push    ix
        call    swapgfxbk
        ld      ix, respixel
        call    Line_r
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF
  ENDIF
