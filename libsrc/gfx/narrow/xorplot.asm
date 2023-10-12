; ----- void  xorplot(int x, int y)


        SECTION code_graphics

        PUBLIC  xorplot
        PUBLIC  _xorplot
        PUBLIC  ___xorplot

        EXTERN  asm_xorplot


xorplot:
_xorplot:
___xorplot:
        pop     bc                      ; ret addr
        pop     hl                      ; y
        pop     de                      ; x
        push    de
        push    hl
        ld      h, e
        push    bc                      ; ret addr
        jp      asm_xorplot
