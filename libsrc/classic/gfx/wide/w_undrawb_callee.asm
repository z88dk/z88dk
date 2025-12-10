; void undrawb_callee(int tlx, int tly, int width, int height)

IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  undrawb_callee
    PUBLIC  _undrawb_callee

    PUBLIC  asm_undrawb

    EXTERN  w_respixel
    EXTERN  drawbox

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    INCLUDE "classic/gfx/grafix.inc"


undrawb_callee:
_undrawb_callee:
    pop     af
    pop     de
    pop     hl
    exx                                 ; w_plotpixel and __gfx_vram_page_in must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    push    af                          ; ret addr
    exx
asm_undrawb:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    ld      ix, w_respixel
    call    drawbox
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
ENDIF
