; ----- void __CALLEE__ xorborder(int x, int y, int x2, int y2)


IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics

    PUBLIC  xorborder
    PUBLIC  _xorborder

    EXTERN  asm_xorborder
    
.xorborder
._xorborder
    pop     af
    pop     de
    pop     hl
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de
    pop     hl
    
    push    hl
    push    de
    exx
    push    hl
    push    de
    
    push    af    ; ret addr
    jp      asm_xorborder
ENDIF
