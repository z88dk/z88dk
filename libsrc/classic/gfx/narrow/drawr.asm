; ----- void  drawr(int x, int y)


IF  !__CPU_INTEL__&!__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  drawr
    PUBLIC  _drawr
    PUBLIC  ___drawr

    EXTERN  asm_drawr


drawr:
_drawr:
___drawr:
    pop     bc                          ; ret addr
    pop     de                          ; y
    pop     hl                          ; x
    push    hl
    push    de
    push    bc                          ; ret addr
    jp      asm_drawr
ENDIF
