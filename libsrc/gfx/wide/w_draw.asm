; ----- void  draw(int x, int y, int x2, int y2)

IF !__CPU_INTEL__ && !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC  draw
    PUBLIC  _draw
    EXTERN  asm_draw
    
.draw
._draw
    pop     af
    pop     de    ;y2
    pop     hl    ;x2
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de    ;y1
    pop     hl    ;x1
    push    hl
    push    de
    exx
    push    hl
    push    de
    exx
    
    push    af    ; ret addr
    
; de = x1, hl = y1, hl'=x2, de'=y2
    jp      asm_draw
ENDIF
