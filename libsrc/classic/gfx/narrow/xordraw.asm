; ----- void  xordraw(int x, int y, int x2, int y2)


    SECTION code_graphics

    PUBLIC  xordraw
    PUBLIC  _xordraw
    PUBLIC  ___xordraw

    EXTERN  asm_xordraw
    INCLUDE "classic/gfx/grafix.inc"


xordraw:
_xordraw:
___xordraw:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      e, (ix+2)                   ;y1
    ld      d, (ix+4)                   ;x1
    ld      l, (ix+6)                   ;y0
    ld      h, (ix+8)                   ;x0
    pop     ix
ELSE
    pop     af
    pop     de                          ; y1
    pop     bc
    ld      d, c                        ; x1

    pop     hl                          ; y0
    pop     de                          ; x0
    push    de
    push    hl
    ld      h, e                        ; x0

    push    bc
    push    de                          ; foo value, the original value is gone
    push    af
ENDIF

    jp      asm_xordraw

