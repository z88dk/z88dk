; ----- void __CALLEE__ xordrawb(int x, int y, int h, int v)
;
;    $Id: xordrawb.asm $
;


    SECTION code_graphics

    PUBLIC  xordrawb
    PUBLIC  _xordrawb
    PUBLIC  ___xordrawb

    EXTERN  asm_xordrawb
    INCLUDE "classic/gfx/grafix.inc"


xordrawb:
_xordrawb:
___xordrawb:

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

    jp      asm_xordrawb
