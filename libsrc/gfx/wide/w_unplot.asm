; ----- void  unplot(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  unplot
    PUBLIC  _unplot
    
    EXTERN  asm_unplot

.unplot
._unplot
    pop     af
    pop     de    ; y
    pop     hl    ; x
    push    hl
    push    de
    push    af
    jp      asm_unplot
   
ENDIF
