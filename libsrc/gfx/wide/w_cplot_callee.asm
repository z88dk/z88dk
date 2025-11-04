
; ----- void __CALLEE__ cplot_callee(int x, int y, int c)

    SECTION code_graphics
    PUBLIC  cplot_callee
    PUBLIC  _cplot_callee
    PUBLIC  asm_cplot

    EXTERN  swapgfxbk
    EXTERN  swapgfxbk1
    EXTERN  __gfx_color
    EXTERN  w_cplotpixel
    INCLUDE "graphics/grafix.inc"


cplot_callee:
_cplot_callee:
    pop     af
    pop     bc
    pop     de
    pop     hl
    push    af

asm_cplot:
    ld      a, c
    ld      (__gfx_color), a
IFDEF _GFX_PAGE_VRAM
    call    swapgfxbk
ENDIF
    call    w_cplotpixel
IFDEF _GFX_PAGE_VRAM
    jp      swapgfxbk1
ELSE
    ret
ENDIF

