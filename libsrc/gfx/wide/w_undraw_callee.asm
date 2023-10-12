; ----- void __CALLEE__ undraw_callee(int x, int y, int x2, int y2)

  IF    !__CPU_INTEL__&&!__CPU_GBZ80__
        SECTION code_graphics
        PUBLIC  undraw_callee
        PUBLIC  _undraw_callee
        PUBLIC  asm_undraw

        EXTERN  swapgfxbk
        EXTERN  swapgfxbk1

        EXTERN  w_line_r
        EXTERN  w_respixel
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"



undraw_callee:
_undraw_callee:
        pop     af
        pop     de                      ;y2
        pop     hl                      ;x2
        exx                             ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
        pop     de                      ;y1
        pop     hl                      ;x1
        push    af                      ; ret addr

asm_undraw:

        push    ix
        push    hl                      ;x1
        push    de                      ;y1

    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF
        call    w_respixel

        exx
        ex      de, hl
        pop     bc                      ;y1
        or      a
        sbc     hl, bc
        ex      de, hl

        pop     bc                      ;x1
        or      a
        sbc     hl, bc

        ld      ix, w_respixel
        call    w_line_r
    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
        pop     ix
        ret
    ENDIF

  ENDIF
