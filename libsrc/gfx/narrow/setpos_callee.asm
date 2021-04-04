; ----- void __CALLEE__ setpos(int x2, int y2)

    SECTION code_graphics

    PUBLIC  setpos_callee
    PUBLIC  _setpos_callee
    PUBLIC  asm_setpos
  
    EXTERN  setxy


.setpos_callee
._setpos_callee    
    pop     bc    ; ret addr
    pop     hl
    pop     de
    push    bc    ; ret addr
    
.asm_setpos
    ld      h,e
    jp      setxy
