; ----- void  plot(int x, int y)


    SECTION code_graphics
    
    PUBLIC  plot
    PUBLIC  _plot
    
    EXTERN  asm_plot

.plot
._plot
    pop     af
    pop     de    ; y
    pop     hl    ; x
    push    hl
    push    de
    push    af
    jp      asm_plot
   
