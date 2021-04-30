; ----- void  unplot(int x, int y)


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  unplot
    PUBLIC  _unplot
    
    EXTERN  asm_unplot
    
.unplot
._unplot
    pop     bc    ; ret addr
    pop     hl    ; y
    pop     de    ; x
    push    de
    push    hl
    ld      h,e
    push    bc    ; ret addr
    jp      asm_unplot
ENDIF
