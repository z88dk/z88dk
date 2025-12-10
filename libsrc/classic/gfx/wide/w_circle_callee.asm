; Usage: circle(int x, int y, int radius, int skip);


IF  !__CPU_INTEL__


    SECTION code_graphics

    PUBLIC  circle_callee
    PUBLIC  _circle_callee

    PUBLIC  asm_circle

    EXTERN  w_draw_circle
    EXTERN  w_plotpixel

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


circle_callee:
_circle_callee:

;      de = x0, hl = y0, bc = radius, a = skip

    pop     af
    ex      af, af

    pop     de                          ; skip
    ld      a, e
    pop     bc                          ;radius
    pop     hl                          ; y
    pop     de                          ; x
    ex      af, af
    push    af
    ex      af, af

asm_circle:
    push    ix
    push    af
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    pop     af
    ld      ix, w_plotpixel
    call    w_draw_circle
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF
