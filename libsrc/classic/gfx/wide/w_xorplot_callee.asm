; ----- void  xorplot(int x, int y)


IF  !__CPU_INTEL__&&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorplot_callee
    PUBLIC  _xorplot_callee
    PUBLIC  asm_xorplot

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end
    EXTERN  w_xorpixel
    INCLUDE "classic/gfx/grafix.inc"


xorplot_callee:
_xorplot_callee:
    pop     bc
    pop     de                          ; y
    pop     hl                          ; x
    push    bc

asm_xorplot:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    w_xorpixel
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF
ENDIF
