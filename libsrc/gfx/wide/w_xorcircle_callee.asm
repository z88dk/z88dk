; Usage: xorcircle(int x, int y, int radius, int skip);


  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics

        PUBLIC  xorcircle_callee
        PUBLIC  _xorcircle_callee
        PUBLIC  asm_xorcircle

        EXTERN  w_draw_circle
        EXTERN  w_xorpixel
        EXTERN  swapgfxbk
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"


xorcircle_callee:
_xorcircle_callee:
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

asm_xorcircle:
        push    ix
        push    af
    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        pop     af
        ld      ix, w_xorpixel
        call    w_draw_circle
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF
  ENDIF
