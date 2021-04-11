; ----- void  xordrawto(int x2, int y2)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xordrawto
    PUBLIC  _xordrawto
    
    EXTERN  asm_xordrawto


.xordrawto
._xordrawto
    pop     af    ; ret addr
    pop     de    ; y2
    pop     hl
    push    hl
    push    de
    ld      d,l    ; x2
    push    af    ; ret addr
    jp      asm_xordrawto
ENDIF
