; ----- void  xordrawto(int x2, int y2)

    SECTION code_graphics

    PUBLIC  xordrawto
    PUBLIC  _xordrawto
    PUBLIC  ___xordrawto

    EXTERN  asm_xordrawto


xordrawto:
_xordrawto:
___xordrawto:
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    push    hl
    push    de
    ld      d, l                        ; x2
    push    af                          ; ret addr
    jp      asm_xordrawto
