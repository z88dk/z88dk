; Usage: xorcircle(int x, int y, int radius, int skip);


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorcircle_callee
    PUBLIC  _xorcircle_callee

    PUBLIC  asm_xorcircle

    EXTERN  draw_circle
    EXTERN  xorpixel

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


xorcircle_callee:
_xorcircle_callee:
    pop     af
    pop     de                          ; skip
    pop     bc                          ;radius
    ld      d, c
    pop     bc                          ; y
    pop     hl                          ; x
    ld      b, l
    push    af

    push    ix


asm_xorcircle:
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      hl, xorpixel
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
