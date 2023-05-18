; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)

    SECTION code_graphics
    PUBLIC  xordraw_callee
    PUBLIC  _xordraw_callee
    PUBLIC  asm_xordraw

    EXTERN  __v1050_line
;    EXTERN  __v1050_pixel

    INCLUDE "graphics/grafix.inc"

.xordraw_callee
._xordraw_callee
    pop     af
    pop     de    ;y2
    pop     hl    ;x2
    exx        ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de    ;y1
    pop     hl    ;x1
    push    af    ; ret addr
    
; de = x1, hl = y1, hl'=x2, de'=y2
.asm_xordraw
	ld      c,'8'
    jp    __v1050_line
