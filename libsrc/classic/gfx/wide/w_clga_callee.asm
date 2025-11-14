;Usage: clga(int tlx, int tly, int tlx2, int tly2)

IF  !__CPU_INTEL__

    SECTION code_graphics

    PUBLIC  clga_callee
    PUBLIC  _clga_callee

    PUBLIC  asm_clga

    EXTERN  w_respixel
    EXTERN  w_area

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


clga_callee:
_clga_callee:

    pop     af
    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af                          ; ret addr
    exx

asm_clga:

    push    ix
  IFDEF _gfx_vram_page
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_respixel
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
