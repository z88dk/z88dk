; ----- void __CALLEE__ xordrawto_callee(int x, int y)

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  xordrawto_callee
        PUBLIC  _xordrawto_callee
        PUBLIC  asm_xordrawto

        EXTERN  swapgfxbk
        EXTERN  w_line
        EXTERN  w_xorpixel
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"


xordrawto_callee:
_xordrawto_callee:
        pop     af
        pop     de
        pop     hl
        push    af

asm_xordrawto:
        push    ix
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        ld      ix, w_xorpixel
        call    w_line
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF

  ENDIF
