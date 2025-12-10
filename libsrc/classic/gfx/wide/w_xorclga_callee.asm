; void xorclga_callee(int tlx, int tly, int tlx2, int tly2)

IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorclga_callee
    PUBLIC  _xorclga_callee
    PUBLIC  asm_xorclga

    EXTERN  w_xorpixel
    EXTERN  w_area
    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


xorclga_callee:
_xorclga_callee:
    pop     af
    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af                          ; ret addr

    exx

asm_xorclga:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_xorpixel
    call    w_area
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
ENDIF
