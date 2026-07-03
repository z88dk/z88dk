; Usage: circle(int x, int y, int radius, int skip);


    SECTION code_graphics

    PUBLIC  circle
    PUBLIC  _circle
    PUBLIC  ___circle

    EXTERN  asm_circle
    INCLUDE "classic/gfx/grafix.inc"


circle:
_circle:
___circle:

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    ld      ix, 2
    add     ix, sp
    ld      e, (ix+2)                   ;skip
    ld      d, (ix+4)                   ;radius
    ld      c, (ix+6)                   ;y
    ld      b, (ix+8)                   ;x
    pop     ix
ELSE
    pop     af
    pop     de                          ; skip
    pop     bc                          ;radius
    ld      d, c
    pop     bc                          ; y
    pop     hl                          ; x

	push    de
	push    bc
	push    hl
	push    bc
    ld      b, l
    push    af
ENDIF

    jp      asm_circle
