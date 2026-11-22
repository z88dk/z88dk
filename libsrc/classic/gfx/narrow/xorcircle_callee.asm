; Usage: xorcircle(int x, int y, int radius, int skip);


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

asm_xorcircle:
    ld      hl, xorpixel
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
	ELSE
    EXTERN  __plot_ADDR
    ld      (__plot_ADDR),hl
    ENDIF
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    draw_circle
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
ENDIF
    ret
  ENDIF
