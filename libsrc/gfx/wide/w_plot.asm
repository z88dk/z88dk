; ----- void  plot(int x, int y)


        SECTION code_graphics

        PUBLIC  plot
        PUBLIC  _plot
        PUBLIC  ___plot

        EXTERN  asm_plot

plot:
_plot:
___plot:
        pop     bc
        pop     de                      ; y
        pop     hl                      ; x
        push    hl
        push    de
        push    bc
        jp      asm_plot

