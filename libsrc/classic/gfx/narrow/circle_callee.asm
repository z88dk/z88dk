; Usage: circle(int x, int y, int radius, int skip);


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  circle_callee
    PUBLIC  _circle_callee

    PUBLIC  asm_circle

    EXTERN  draw_circle
    EXTERN  plotpixel

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


circle_callee:
_circle_callee:
    pop     af
    pop     de                          ; skip
    pop     bc                          ;radius
    ld      d, c
    pop     bc                          ; y
    pop     hl                          ; x
    ld      b, l
    push    af

    push    ix


asm_circle:
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      hl, plotpixel
    call    draw_circle
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF
