; ----- void  plot(int x, int y)

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  plot
    PUBLIC  _plot
    
    EXTERN  asm_plot

    
.plot
._plot
    pop     af    ; ret addr
    pop     hl    ; y
    pop     de    ; x
    push    de
    push    hl
    ld      h,e
    push    af    ; ret addr
    jp      asm_plot
ENDIF
