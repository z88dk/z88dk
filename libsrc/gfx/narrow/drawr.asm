; ----- void  drawr(int x, int y)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  drawr
    PUBLIC  _drawr
    
    EXTERN  asm_drawr


.drawr
._drawr
    pop     af    ; ret addr
    pop     de    ; y
    pop     hl    ; x
    push    hl
    push    de
    push    af    ; ret addr
    jp      asm_drawr
ENDIF
