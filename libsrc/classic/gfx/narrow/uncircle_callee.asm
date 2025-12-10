; Usage: uncircle(int x, int y, int radius, int skip);


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  uncircle_callee
    PUBLIC  _uncircle_callee

    PUBLIC  asm_uncircle

    EXTERN  draw_circle
    EXTERN  respixel

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


uncircle_callee:
_uncircle_callee:
    pop     af
    pop     de                          ; skip
    pop     bc                          ;radius
    ld      d, c
    pop     bc                          ; y
    pop     hl                          ; x
    ld      b, l
    push    af

    push    ix


asm_uncircle:
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      hl, respixel
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
