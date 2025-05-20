
;Usage: c_plot(int x, int y)



    SECTION code_graphics
    PUBLIC  c_plot
    PUBLIC  _c_plot
    PUBLIC  ___c_plot
    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  c_plotpixel
    INCLUDE "graphics/grafix.inc"

c_plot:
_c_plot:
___c_plot:
IF  __CPU_INTEL__|__CPU_GBZ80__
    pop     bc
    pop     hl
    pop     de
    push    de
    push    hl
    push    bc
    ld      h, e
ELSE
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      l, (ix+2)
    ld      h, (ix+4)
ENDIF
IF  NEED_swapgfxbk=1
    call    swapgfxbk
ENDIF
    call    c_plotpixel
IF  NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF    !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
