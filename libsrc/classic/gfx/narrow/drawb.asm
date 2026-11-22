; ----- void __CALLEE__ drawb(int x, int y, int h, int v)
;
;    $Id: drawb.asm $
;


    SECTION code_graphics

    PUBLIC  drawb
    PUBLIC  _drawb
    PUBLIC  ___drawb

    EXTERN  asm_drawb
    INCLUDE "classic/gfx/grafix.inc"


drawb:
_drawb:
___drawb:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      c, (ix+2)
    ld      b, (ix+4)
    ld      l, (ix+6)
    ld      h, (ix+8)
    pop     ix
ELSE
    pop     af
    pop     bc                          ; height
    pop     de
    ld      b, e                        ; width
    pop     hl                          ; x
    pop     de
    push    de
    push    hl
    ld      h, e                        ; y
    push    de                          ; this value is lost
    push    bc
    push    af
ENDIF

    jp      asm_drawb
