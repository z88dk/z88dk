; ----- void  plot_callee(int x, int y)

IF !__CPU_INTEL__ & !__CPU_GBZ80__

    SECTION code_graphics

    PUBLIC  plot_callee
    PUBLIC  _plot_callee
    PUBLIC  asm_plot

    EXTERN  swapgfxbk
    EXTERN  __graphics_end

    EXTERN  plotpixel
    INCLUDE "graphics/grafix.inc"

.plot_callee
._plot_callee
    pop     af    ; ret addr
    pop     hl    ; y
    pop     de    ; x
    ld      h,e
    push    af    ; ret addr
.asm_plot
    push    ix
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF
    call    plotpixel
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
ENDIF
