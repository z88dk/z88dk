; Usage: uncircle_callee(int x, int y, int radius, int skip);


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  uncircle_callee
    PUBLIC  _uncircle_callee

    PUBLIC  asm_uncircle

    EXTERN  w_draw_circle
    EXTERN  w_respixel

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


uncircle_callee:
_uncircle_callee:

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

asm_uncircle:
    push    ix
    ld      ix, w_respixel
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    w_draw_circle
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
ENDIF
