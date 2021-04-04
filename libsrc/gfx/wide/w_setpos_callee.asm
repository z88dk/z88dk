; ----- void __CALLEE__ setpos_callee(int x2, int y2)

    SECTION code_graphics

    PUBLIC  setpos_callee
    PUBLIC  _setpos_callee
    
    PUBLIC  asm_setpos
    defc    asm_setpos = w_setxy
    EXTERN  w_setxy


.setpos_callee
._setpos_callee    
    pop     bc    ; ret addr
    pop     de
    pop     hl
    push    bc    ; ret addr
    jp      w_setxy
