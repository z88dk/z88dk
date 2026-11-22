; Usage: xorcircle(int x, int y, int radius, int skip);


    SECTION code_graphics

    PUBLIC  xorcircle
    PUBLIC  _xorcircle
    PUBLIC  ___xorcircle

    EXTERN  asm_xorcircle
    INCLUDE "classic/gfx/grafix.inc"


xorcircle:
_xorcircle:
___xorcircle:

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

    jp      asm_xorcircle

