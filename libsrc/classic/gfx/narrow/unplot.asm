; ----- void  unplot(int x, int y)

    SECTION code_graphics

    PUBLIC  unplot
    PUBLIC  _unplot
    PUBLIC  ___unplot

    EXTERN  asm_unplot

unplot:
_unplot:
___unplot:
    pop     bc                          ; ret addr
    pop     hl                          ; y
    pop     de                          ; x
    push    de
    push    hl
    ld      h, e
    push    bc                          ; ret addr
    jp      asm_unplot
