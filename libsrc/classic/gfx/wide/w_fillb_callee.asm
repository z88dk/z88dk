; void fillb(int tlx, int tly, int width, int height)
IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  fillb_callee
    PUBLIC  _fillb_callee

    PUBLIC  asm_fillb

    EXTERN  w_plotpixel
    EXTERN  w_area

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


fillb_callee:
_fillb_callee:
    pop     af
    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af                          ; ret addr
    exx

asm_fillb:

    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_plotpixel
    call    w_area

  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF
