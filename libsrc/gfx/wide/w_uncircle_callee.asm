; Usage: uncircle_callee(int x, int y, int radius, int skip);


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  uncircle_callee
        PUBLIC  _uncircle_callee

        PUBLIC  asm_uncircle

        EXTERN  w_draw_circle
        EXTERN  w_respixel

        EXTERN  swapgfxbk
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"


uncircle_callee:
_uncircle_callee:

;      de = x0, hl = y0, bc = radius, a = skip

        pop     af
        ex      af, af

        pop     de                      ; skip
        ld      a, e
        pop     bc                      ;radius
        pop     hl                      ; y
        pop     de                      ; x

        ex      af, af
        push    af
        ex      af, af

asm_uncircle:
        push    ix
        ld      ix, w_respixel
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    w_draw_circle
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF
  ENDIF
