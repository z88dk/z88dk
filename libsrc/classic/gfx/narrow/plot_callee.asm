; ----- void  plot_callee(int x, int y)

IF  !__CPU_INTEL__&!__CPU_GBZ80__

    SECTION code_graphics

    PUBLIC  plot_callee
    PUBLIC  _plot_callee
    PUBLIC  asm_plot

    EXTERN  __gfx_vram_page_in
    EXTERN  __graphics_end

    EXTERN  plotpixel
    INCLUDE "classic/gfx/grafix.inc"

plot_callee:
_plot_callee:
    pop     bc                          ; ret addr
    pop     hl                          ; y
    pop     de                          ; x
    ld      h, e
    push    bc                          ; ret addr
asm_plot:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    __gfx_vram_page_in
  ENDIF
    call    plotpixel
  IF    _gfx_vram_page
    jp      __graphics_end
  ELSE
    IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    ENDIF
    ret
  ENDIF
ENDIF
