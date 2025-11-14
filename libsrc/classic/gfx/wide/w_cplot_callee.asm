
; ----- void __CALLEE__ cplot_callee(int x, int y, int c)

    SECTION code_graphics
    PUBLIC  cplot_callee
    PUBLIC  _cplot_callee
    PUBLIC  asm_cplot

    EXTERN  __gfx_vram_page_in
    EXTERN  __gfx_vram_page_out
    EXTERN  __gfx_color
    EXTERN  w_cplotpixel
    INCLUDE "classic/gfx/grafix.inc"


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
IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
ENDIF
    call    w_cplotpixel
IFDEF _gfx_vram_page
    jp      __gfx_vram_page_out
ELSE
    ret
ENDIF

