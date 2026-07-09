; ----- void  undraw(int x, int y, int x2, int y2)


    SECTION code_graphics

    PUBLIC  undraw
    PUBLIC  _undraw
    PUBLIC  ___undraw

    EXTERN  asm_undraw
    INCLUDE "classic/gfx/grafix.inc"


undraw:
_undraw:
___undraw:

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
    pop     af                          ; ret addr
    pop     de                          ; y2
    pop     hl
    ld      d, l                        ; x2
    pop     hl                          ; y
    pop     bc

    push    bc
    push    hl
    ld      h, c                        ; x
    push    hl                          ; foo value, the original value is gone
    push    de
    
    push    af                          ; ret addr
ENDIF

    jp      asm_undraw

