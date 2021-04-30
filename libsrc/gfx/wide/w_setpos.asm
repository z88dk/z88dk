; ----- void  setpos(int x2, int y2)

    SECTION code_graphics

    PUBLIC  setpos
    PUBLIC  _setpos
    
    EXTERN  asm_setpos
.setpos
._setpos
    pop     bc    ; ret addr
    pop     de
    pop     hl
    push    hl
    push    de
    push    bc    ; ret addr
    jp      asm_setpos

