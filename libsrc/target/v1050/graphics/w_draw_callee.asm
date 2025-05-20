; ----- void __CALLEE__ draw(int x, int y, int x2, int y2)

    SECTION code_graphics
    PUBLIC  draw_callee
    PUBLIC  _draw_callee
    PUBLIC  asm_draw

    EXTERN  __v1050_line
;    EXTERN  __v1050_pixel

    INCLUDE "graphics/grafix.inc"

draw_callee:
_draw_callee:
    pop     af
    pop     de                          ;y2
    pop     hl                          ;x2
    exx                                 ; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
    pop     de                          ;y1
    pop     hl                          ;x1
    push    af                          ; ret addr

; de = x1, hl = y1, hl'=x2, de'=y2
asm_draw:
    ld      c, '0'
    jp      __v1050_line
