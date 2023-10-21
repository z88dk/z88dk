; ----- void  unplot_callee(int x, int y)


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  unplot_callee
        PUBLIC  _unplot_callee
        PUBLIC  asm_unplot

        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        EXTERN  w_respixel
        INCLUDE "graphics/grafix.inc"


unplot_callee:
_unplot_callee:
        pop     bc
        pop     de                      ; y
        pop     hl                      ; x
        push    bc

asm_unplot:
        push    ix
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    w_respixel
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF
  ENDIF
