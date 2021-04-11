; ----- void  undrawto(int x2, int y2)

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  undrawto
    PUBLIC  _undrawto

    EXTERN  asm_undrawto



.undrawto
._undrawto
    pop     af    ; ret addr
    pop     de    ; y2
    pop     hl
    push    hl
    push    de
    ld      d,l    ; x2
    push    af    ; ret addr
    jp      asm_undrawto
    
ENDIF
