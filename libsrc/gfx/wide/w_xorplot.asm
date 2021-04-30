; ----- void  xorplot(int x, int y)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    
    PUBLIC  xorplot
    PUBLIC  _xorplot
    
    EXTERN  asm_xorplot

.xorplot
._xorplot
    pop     af
    pop     de    ; y
    pop     hl    ; x
    push    hl
    push    de
    push    af
    jp      asm_xorplot
ENDIF
