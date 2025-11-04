; ----- void  plot_callee(int x, int y)


; CALLER LINKAGE FOR FUNCTION POINTERS

IF  !__CPU_INTEL__&&!__CPU_GBZ80__

    SECTION code_graphics

    PUBLIC  plot_callee
    PUBLIC  _plot_callee
    PUBLIC  asm_plot

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  w_plotpixel
    INCLUDE "graphics/grafix.inc"


plot_callee:
_plot_callee:
    pop     bc
    pop     de                          ; y
    pop     hl                          ; x
    push    bc

asm_plot:
    push    ix
  IFDEF _GFX_PAGE_VRAM
    call    swapgfxbk
  ENDIF
    call    w_plotpixel
  IF    _GFX_PAGE_VRAM
    jp      __graphics_end
  ELSE
    pop     ix
    ret
  ENDIF

ENDIF
